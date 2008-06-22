Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYFVVQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYFVVQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYFVVQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:16:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:62186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbYFVVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IRF9e0GvEYPIprFQRrePcjqwuL7kaSxwUnoKncd97KF7rmdczFohPF5sm7ClpNwRwe
         vOH/kM5B00O66OvTfaThakbENF9RpfwfeM9W7KFdZqJHzYhIFSQZdiVNoBa1hz+S8fLM
         cWc8AsUMbp5CpthUpGzHsxZuwFfV1BpY3wC54=
Date: Mon, 23 Jun 2008 01:11:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH] proc: always do ->release
Message-ID: <20080622211158.GC31702@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current two-stage scheme of removing PDE emphasized one bug in proc:

		open
				rmmod
				remove_proc_entry
		close

->release won't be called because ->proc_fops were cleared.
In simple cases it's small memory leak.

For every ->open, ->release has to be done. List of openers is introduced
which is traversed at remove_proc_entry() if neeeded.

Discussions with Al long ago (sigh).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c       |   15 +++++++++
 fs/proc/inode.c         |   74 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/proc/internal.h      |    7 ++++
 include/linux/proc_fs.h |    1 
 4 files changed, 93 insertions(+), 4 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -597,6 +597,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	ent->pde_users = 0;
 	spin_lock_init(&ent->pde_unload_lock);
 	ent->pde_unload_completion = NULL;
+	INIT_LIST_HEAD(&ent->pde_openers);
  out:
 	return ent;
 }
@@ -789,6 +790,20 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 	spin_unlock(&de->pde_unload_lock);
 
 continue_removing:
+	spin_lock(&de->pde_unload_lock);
+	while (!list_empty(&de->pde_openers)) {
+		struct pde_opener *pdeo;
+
+		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
+		list_del(&pdeo->lh);
+		spin_unlock(&de->pde_unload_lock);
+		if (pdeo->release)
+			pdeo->release(pdeo->inode, pdeo->file);
+		kfree(pdeo);
+		spin_lock(&de->pde_unload_lock);
+	}
+	spin_unlock(&de->pde_unload_lock);
+
 	if (S_ISDIR(de->mode))
 		parent->nlink--;
 	de->nlink = 0;
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -119,12 +119,17 @@ static const struct super_operations proc_sops = {
 	.statfs		= simple_statfs,
 };
 
-static void pde_users_dec(struct proc_dir_entry *pde)
+static void __pde_users_dec(struct proc_dir_entry *pde)
 {
-	spin_lock(&pde->pde_unload_lock);
 	pde->pde_users--;
 	if (pde->pde_unload_completion && pde->pde_users == 0)
 		complete(pde->pde_unload_completion);
+}
+
+static void pde_users_dec(struct proc_dir_entry *pde)
+{
+	spin_lock(&pde->pde_unload_lock);
+	__pde_users_dec(pde);
 	spin_unlock(&pde->pde_unload_lock);
 }
 
@@ -311,36 +316,97 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*open)(struct inode *, struct file *);
+	int (*release)(struct inode *, struct file *);
+	struct pde_opener *pdeo;
+
+	/*
+	 * What for, you ask? Well, we can have open, rmmod, remove_proc_entry
+	 * sequence. ->release won't be called because ->proc_fops will be
+	 * cleared. Depending on complexity of ->release, consequences vary.
+	 *
+	 * We can't wait for mercy when close will be done for real, it's
+	 * deadlockable: rmmod foo </proc/foo . So, we're going to do ->release
+	 * by hand in remove_proc_entry(). For this, save opener's credentials
+	 * for later.
+	 */
+	pdeo = kmalloc(sizeof(struct pde_opener), GFP_KERNEL);
+	if (!pdeo)
+		return -ENOMEM;
 
 	spin_lock(&pde->pde_unload_lock);
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
+		kfree(pdeo);
 		return rv;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
+	release = pde->proc_fops->release;
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (open)
 		rv = open(inode, file);
 
-	pde_users_dec(pde);
+	spin_lock(&pde->pde_unload_lock);
+	if (rv == 0) {
+		/* To know what to release. */
+		pdeo->inode = inode;
+		pdeo->file = file;
+		/* Strictly for "too late" ->release in proc_reg_release(). */
+		pdeo->release = release;
+		list_add(&pdeo->lh, &pde->pde_openers);
+	} else
+		kfree(pdeo);
+	__pde_users_dec(pde);
+	spin_unlock(&pde->pde_unload_lock);
 	return rv;
 }
 
+static struct pde_opener *find_pde_opener(struct proc_dir_entry *pde,
+					struct inode *inode, struct file *file)
+{
+	struct pde_opener *pdeo;
+
+	list_for_each_entry(pdeo, &pde->pde_openers, lh) {
+		if (pdeo->inode == inode && pdeo->file == file)
+			return pdeo;
+	}
+	return NULL;
+}
+
 static int proc_reg_release(struct inode *inode, struct file *file)
 {
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	int (*release)(struct inode *, struct file *);
+	struct pde_opener *pdeo;
 
 	spin_lock(&pde->pde_unload_lock);
+	pdeo = find_pde_opener(pde, inode, file);
 	if (!pde->proc_fops) {
-		spin_unlock(&pde->pde_unload_lock);
+		/*
+		 * Can't simply exit, __fput() will think that everything is OK,
+		 * and move on to freeing struct file. remove_proc_entry() will
+		 * find slacker in opener's list and will try to do non-trivial
+		 * things with struct file. Therefore, remove opener from list.
+		 *
+		 * But if opener is removed from list, who will ->release it?
+		 */
+		if (pdeo) {
+			list_del(&pdeo->lh);
+			spin_unlock(&pde->pde_unload_lock);
+			rv = pdeo->release(inode, file);
+			kfree(pdeo);
+		} else
+			spin_unlock(&pde->pde_unload_lock);
 		return rv;
 	}
 	pde->pde_users++;
 	release = pde->proc_fops->release;
+	if (pdeo) {
+		list_del(&pdeo->lh);
+		kfree(pdeo);
+	}
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (release)
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -88,3 +88,10 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *ino,
 		struct dentry *dentry);
 int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 		filldir_t filldir);
+
+struct pde_opener {
+	struct inode *inode;
+	struct file *file;
+	int (*release)(struct inode *, struct file *);
+	struct list_head lh;
+};
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -79,6 +79,7 @@ struct proc_dir_entry {
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;
+	struct list_head pde_openers;	/* who did ->open, but not ->release */
 };
 
 struct kcore_list {
-- 
1.5.4.5


