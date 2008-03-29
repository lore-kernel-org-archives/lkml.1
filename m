Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYC2VDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYC2VDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYC2VDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:03:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:15550 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYC2VDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=UTYfvdsRBM9ugvg/WJZzu7Lu2gkwxtCtA18XmOsBE0vusizZvLrkZ1gomjEFr2yaohvbAXgp1qAF5k+ZVvZdedmIwnMQV0qHPb4l9VYip/Kmk2koRZRHp03H953QlY2lUP+qhK3oxCPo9HmexZL1XJYOUts4D4b0FrGRAtBNZ90=
Date: Sun, 30 Mar 2008 00:00:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] proc: simplify locking in remove_proc_entry()
Message-ID: <20080329210013.GA16275@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_subdir_lock protects only modifying and walking through PDE lists, so
after we've found PDE to remove and actually removed it from lists, there
is no need to hold proc_subdir_lock for the rest of operation.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |   82 ++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 42 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -734,60 +734,58 @@ void free_proc_entry(struct proc_dir_entry *de)
 void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 {
 	struct proc_dir_entry **p;
-	struct proc_dir_entry *de;
+	struct proc_dir_entry *de = NULL;
 	const char *fn = name;
 	int len;
 
 	if (!parent && xlate_proc_name(name, &parent, &fn) != 0)
-		goto out;
+		return;
 	len = strlen(fn);
 
 	spin_lock(&proc_subdir_lock);
 	for (p = &parent->subdir; *p; p=&(*p)->next ) {
-		if (!proc_match(len, fn, *p))
-			continue;
-		de = *p;
-		*p = de->next;
-		de->next = NULL;
-
-		spin_lock(&de->pde_unload_lock);
-		/*
-		 * Stop accepting new callers into module. If you're
-		 * dynamically allocating ->proc_fops, save a pointer somewhere.
-		 */
-		de->proc_fops = NULL;
-		/* Wait until all existing callers into module are done. */
-		if (de->pde_users > 0) {
-			DECLARE_COMPLETION_ONSTACK(c);
-
-			if (!de->pde_unload_completion)
-				de->pde_unload_completion = &c;
-
-			spin_unlock(&de->pde_unload_lock);
-			spin_unlock(&proc_subdir_lock);
+		if (proc_match(len, fn, *p)) {
+			de = *p;
+			*p = de->next;
+			de->next = NULL;
+			break;
+		}
+	}
+	spin_unlock(&proc_subdir_lock);
+	if (!de)
+		return;
 
-			wait_for_completion(de->pde_unload_completion);
+	spin_lock(&de->pde_unload_lock);
+	/*
+	 * Stop accepting new callers into module. If you're
+	 * dynamically allocating ->proc_fops, save a pointer somewhere.
+	 */
+	de->proc_fops = NULL;
+	/* Wait until all existing callers into module are done. */
+	if (de->pde_users > 0) {
+		DECLARE_COMPLETION_ONSTACK(c);
+
+		if (!de->pde_unload_completion)
+			de->pde_unload_completion = &c;
 
-			spin_lock(&proc_subdir_lock);
-			goto continue_removing;
-		}
 		spin_unlock(&de->pde_unload_lock);
 
+		wait_for_completion(de->pde_unload_completion);
+
+		goto continue_removing;
+	}
+	spin_unlock(&de->pde_unload_lock);
+
 continue_removing:
-		if (S_ISDIR(de->mode))
-			parent->nlink--;
-		de->nlink = 0;
-		if (de->subdir) {
-			printk(KERN_WARNING "%s: removing non-empty directory "
-			       "'%s/%s', leaking at least '%s'\n", __func__,
-			       de->parent->name, de->name, de->subdir->name);
-			WARN_ON(1);
-		}
-		if (atomic_dec_and_test(&de->count))
-			free_proc_entry(de);
-		break;
+	if (S_ISDIR(de->mode))
+		parent->nlink--;
+	de->nlink = 0;
+	if (de->subdir) {
+		printk(KERN_WARNING "%s: removing non-empty directory "
+			"'%s/%s', leaking at least '%s'\n", __func__,
+			de->parent->name, de->name, de->subdir->name);
+		WARN_ON(1);
 	}
-	spin_unlock(&proc_subdir_lock);
-out:
-	return;
+	if (atomic_dec_and_test(&de->count))
+		free_proc_entry(de);
 }

