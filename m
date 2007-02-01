Return-Path: <linux-kernel-owner+w=401wt.eu-S1422741AbXBAKhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422741AbXBAKhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXBAKhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:37:32 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:35268 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422741AbXBAKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:37:31 -0500
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 05:37:31 EST
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: remove_proc_entry and read_proc
Date: Thu, 1 Feb 2007 11:15:15 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200701311154.35929.duncan.sands@math.u-psud.fr> <20070131184251.GA5544@martell.zuzino.mipt.ru> <200701312026.14145.duncan.sands@math.u-psud.fr>
In-Reply-To: <200701312026.14145.duncan.sands@math.u-psud.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011115.16276.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't understand how this is supposed to work.  Consider
> 
> CPU1					CPU2
> 
> atomic_inc(&dp->pde_users);
> if (dp->proc_fops)
> 					de->proc_fops = NULL;
> 	use_proc_fops <= BOOM
> 					if (atomic_read(&de->pde_users) > 0) {
> 
> what prevents dereference of a NULL proc_fops value?

I was wrong: what prevents it is that proc_fops isn't used at all in these
paths!  However it is used in proc_get_inode thusly:

                if (de->proc_fops)
                        inode->i_fop = de->proc_fops;

What if proc_fops is set to NULL between these two?  Putting it into a
local variable should take care of this one, but since I'm not sure if
it's really needed I'll leave that to you!

Otherwise, here's a patch that adds memory barriers (maybe these can be
SMP memory barriers) since the atomic ops you are using do not imply
such barriers according to Documentation/atomic_ops.txt.  The memory
barriers are needed, since you need to know that if you saw a non-NULL
proc_fops, then remove_proc_entry saw your increased pde_users count.
If the proc_fops write was re-ordered after the pde_users read, or the
proc_fops read was re-ordered before the pde_users write, then this may
not be true.

Also, I removed the early checks for NULL proc_fops.  True, they avoid
an atomic operation and a memory barrier, however they only avoid them
in the error path, when -EIO is going to be returned, which is hardly a
fast path.  In the common case, they represent a pointless check.

Ciao,

Duncan.

PS: Compiles, but otherwise untested.


Index: Linux/fs/proc/generic.c
===================================================================
--- Linux.orig/fs/proc/generic.c	2006-12-09 17:18:32.000000000 +0100
+++ Linux/fs/proc/generic.c	2007-02-01 10:54:36.000000000 +0100
@@ -19,6 +19,7 @@
 #include <linux/idr.h>
 #include <linux/namei.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
 
@@ -76,6 +77,19 @@
 	if (!(page = (char*) __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 
+	/*
+	 * We are going to call into module's code via ->get_info or
+	 * ->read_proc. Bump refcount so that remove_proc_entry() will
+	 * wait for read to complete.
+	 */
+	atomic_inc(&dp->pde_users);
+	mb();
+	if (!dp->proc_fops)
+		/*
+		 * remove_proc_entry() marked PDE as "going away". Obey.
+		 */
+		goto out_dec;
+
 	while ((nbytes > 0) && !eof) {
 		count = min_t(size_t, PROC_BLOCK_SIZE, nbytes);
 
@@ -195,6 +209,8 @@
 		buf += n;
 		retval += n;
 	}
+out_dec:
+	atomic_dec(&dp->pde_users);
 	free_page((unsigned long) page);
 	return retval;
 }
@@ -205,14 +221,28 @@
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct proc_dir_entry * dp;
+	ssize_t rv;
 	
 	dp = PDE(inode);
 
 	if (!dp->write_proc)
 		return -EIO;
 
-	/* FIXME: does this routine need ppos?  probably... */
-	return dp->write_proc(file, buffer, count, dp->data);
+	rv = -EIO;
+	/*
+	 * We are going to call into module's code via ->write_proc .
+	 * Bump refcount so that module won't dissapear while ->write_proc
+	 * sleeps in copy_from_user(). remove_proc_entry() will wait for
+	 * write to complete.
+	 */
+	atomic_inc(&dp->pde_users);
+	mb();
+	if (dp->proc_fops)
+		/* PDE is ready, refcount bumped, call into module. */
+		/* FIXME: does this routine need ppos?  probably... */
+		rv = dp->write_proc(file, buffer, count, dp->data);
+	atomic_dec(&dp->pde_users);
+	return rv;
 }
 
 
@@ -717,12 +747,26 @@
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
+		de->proc_fops = NULL;
+		mb();
+		/* Wait until all readers/writers are done. */
+		if (atomic_read(&de->pde_users) > 0) {
+			spin_unlock(&proc_subdir_lock);
+			msleep(1);
+			goto again;
+		}
+
 		*p = de->next;
 		de->next = NULL;
 		if (S_ISDIR(de->mode))
Index: Linux/include/linux/proc_fs.h
===================================================================
--- Linux.orig/include/linux/proc_fs.h	2006-10-03 15:39:31.000000000 +0200
+++ Linux/include/linux/proc_fs.h	2007-02-01 10:42:07.000000000 +0100
@@ -56,6 +56,19 @@
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
+	 * dereference it".
+	 *
+	 * If you're allocating ->proc_fops dynamically, save a pointer
+	 * somewhere.
+	 */
 	const struct file_operations * proc_fops;
 	get_info_t *get_info;
 	struct module *owner;
@@ -66,6 +79,8 @@
 	atomic_t count;		/* use count */
 	int deleted;		/* delete flag */
 	void *set;
+	atomic_t pde_users;	/* number of readers + number of writers via
+				 * ->read_proc, ->write_proc, ->get_info */
 };
 
 struct kcore_list {
