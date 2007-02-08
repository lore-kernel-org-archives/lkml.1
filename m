Return-Path: <linux-kernel-owner+w=401wt.eu-S1423001AbXBHNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbXBHNOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423000AbXBHNOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:14:18 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:38051 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422994AbXBHNOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:14:17 -0500
Date: Thu, 8 Feb 2007 16:20:12 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: akpm@osdl.org
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       duncan.sands@math.u-psud.fr
Subject: [PATCH v3] Fix rmmod/read/write races in /proc entries
Message-ID: <20070208132012.GA6041@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fed up with verifying various barrier-based schemes, this version uses
spinlock.
---------------------------------------------------------------------------

Current /proc creation interfaces suffer from at least two types of races:
--------------------------------------------------------
1. Write via ->write_proc sleeps in copy_from_user(). Module disappears
   meanwhile.

   pde = create_proc_entry()
   if (!pde)
	return -ENOMEM;
   pde->write_proc = ...
				open
				write
				copy_from_user
   pde = create_proc_entry();
   if (!pde) {
	remove_proc_entry();
	return -ENOMEM;
	/* module unloaded */
   }
				*boom*
--------------------------------------------------------
2. Read/write happens when PDE only partially initialized. ->data is NULL
   when create_proc_entry() returns. Almost all ->read_proc and
   ->write_proc handlers assume that ->data is valid.

   pde = create_proc_entry();
   if (pde) {
	/* which dereferences ->data */
	pde->write_proc = ...
				open
				write
	pde->data = ...
   }
--------------------------------------------------------

The following plan is going to be executed (as per Al Viro's explanations):

PDE gets counter counting reads and writes in progress done via ->read_proc,
->write_proc, ->get_info . Generic proc code will bump PDE's counter before
calling into module-specific method and decrement it after it returns.

remove_proc_entry() will wait until all readers and writers are done.
To do this reliably it will set ->proc_fops to NULL and generic proc
code won't call into module it it sees NULL ->proc_fops.

This patch implements part above. So far, no changes in proc users
required. Patch fixes races of type 1.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 fs/proc/generic.c       |   69 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/proc_fs.h |   16 +++++++++++
 2 files changed, 82 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -76,6 +76,21 @@ proc_file_read(struct file *file, char _
 	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
+	spin_lock(&dp->pde_unload_lock);
+	if (!dp->proc_fops)
+		/*
+		 * remove_proc_entry() marked PDE as "going away".
+		 * No new readers allowed.
+		 */
+		goto out_unlock;
+	/*
+	 * We are going to call into module's code via ->get_info or
+	 * ->read_proc. Bump refcount so that remove_proc_entry() will
+	 * wait for read to complete.
+	 */
+	dp->pde_users++;
+	spin_unlock(&dp->pde_unload_lock);
+
 	while ((nbytes > 0) && !eof) {
 		count = min_t(size_t, PROC_BLOCK_SIZE, nbytes);
 
@@ -195,6 +210,11 @@ proc_file_read(struct file *file, char _
 		buf += n;
 		retval += n;
 	}
+
+	spin_lock(&dp->pde_unload_lock);
+	dp->pde_users--;
+out_unlock:
+	spin_unlock(&dp->pde_unload_lock);
 	free_page((unsigned long) page);
 	return retval;
 }
@@ -205,14 +225,39 @@ proc_file_write(struct file *file, const
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry * dp;
+	ssize_t rv = -EIO;
 	
 	dp = PDE(inode);
 
 	if (!dp->write_proc)
-		return -EIO;
+		goto out;
+
+	spin_lock(&dp->pde_unload_lock);
+	if (!dp->proc_fops)
+		/*
+		 * remove_proc_entry() marked PDE as "going away".
+		 * No new writers allowed.
+		 */
+		goto out_unlock;
+	/*
+	 * We are going to call into module's code via ->write_proc .
+	 * Bump refcount so that module won't dissapear while ->write_proc
+	 * sleeps in copy_from_user(). remove_proc_entry() will wait for
+	 * write to complete.
+	 */
+	dp->pde_users++;
+	spin_unlock(&dp->pde_unload_lock);
 
+	/* PDE is ready, refcount bumped, call into module. */
 	/* FIXME: does this routine need ppos?  probably... */
-	return dp->write_proc(file, buffer, count, dp->data);
+	rv = dp->write_proc(file, buffer, count, dp->data);
+
+	spin_lock(&dp->pde_unload_lock);
+	dp->pde_users--;
+out_unlock:
+	spin_unlock(&dp->pde_unload_lock);
+out:
+	return rv;
 }
 
 
@@ -604,6 +649,8 @@ static struct proc_dir_entry *proc_creat
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
+	ent->pde_users = 0;
+	spin_lock_init(&ent->pde_unload_lock);
  out:
 	return ent;
 }
@@ -717,12 +764,28 @@ void remove_proc_entry(const char *name,
 	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
 		goto out;
 	len = strlen(fn);
-
+again:
 	spin_lock(&proc_subdir_lock);
 	for (p = &parent->subdir; *p; p=&(*p)->next ) {
 		if (!proc_match(len, fn, *p))
 			continue;
 		de = *p;
+
+		/*
+		 * Stop accepting new readers/writers. If you're dynamically
+		 * allocating ->proc_fops, save a pointer somewhere.
+		 */
+		spin_lock(&de->pde_unload_lock);
+		de->proc_fops = NULL;
+		/* Wait until all readers/writers are done. */
+		if (de->pde_users > 0) {
+			spin_unlock(&de->pde_unload_lock);
+			spin_unlock(&proc_subdir_lock);
+			schedule();
+			goto again;
+		}
+		spin_unlock(&de->pde_unload_lock);
+
 		*p = de->next;
 		de->next = NULL;
 		if (S_ISDIR(de->mode))
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -56,6 +56,19 @@ struct proc_dir_entry {
 	gid_t gid;
 	loff_t size;
 	struct inode_operations * proc_iops;
+	/*
+	 * NULL ->proc_fops means "PDE is going away RSN" or
+	 * "PDE is just created". In either case ->get_info, ->read_proc,
+	 * ->write_proc won't be called because it's too late or too early,
+	 * respectively.
+	 *
+	 * Valid ->proc_fops means "use this file_operations" or
+	 * "->data is setup, it's safe to call ->read_proc, ->write_proc which
+	 * can dereference it".
+	 *
+	 * If you're allocating ->proc_fops dynamically, save a pointer
+	 * somewhere.
+	 */
 	const struct file_operations * proc_fops;
 	get_info_t *get_info;
 	struct module *owner;
@@ -66,6 +79,9 @@ struct proc_dir_entry {
 	atomic_t count;		/* use count */
 	int deleted;		/* delete flag */
 	void *set;
+	int pde_users;	/* number of readers + number of writers via
+			 * ->read_proc, ->write_proc, ->get_info */
+	spinlock_t pde_unload_lock;
 };
 
 struct kcore_list {

