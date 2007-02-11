Return-Path: <linux-kernel-owner+w=401wt.eu-S1750749AbXBKUXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750749AbXBKUXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXBKUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:23:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:37616 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXBKUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kiQdjNP0VX2t92tk0URbe5/PQ5pe/o/rCI8OddNI2JQ4m691q/AZab+tOm3SyYY6xJTJ8YelLIJGE2+AZV/Mz9DDf0c9VUJ/pYPBzKQMMoFacmONPuwza45w55ad+iUwdpLDrrpc2BZ5EnzaNS5qsXikUnE1btei7dwotpnbJCQ=
Date: Sun, 11 Feb 2007 23:23:30 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, duncan.sands@math.u-psud.fr
Subject: [PATCH v4] Fix rmmod/read/write races in /proc entries
Message-ID: <20070211202330.GA24509@martell.zuzino.mipt.ru>
References: <20070208132012.GA6041@localhost.sw.ru> <20070209010037.7f4393c5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209010037.7f4393c5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 01:00:37AM -0800, Andrew Morton wrote:
> On Thu, 8 Feb 2007 16:20:12 +0300 Alexey Dobriyan <adobriyan@openvz.org> wrote:
> > +again:
> >  	spin_lock(&proc_subdir_lock);
> >  	for (p = &parent->subdir; *p; p=&(*p)->next ) {
> >  		if (!proc_match(len, fn, *p))
> >  			continue;
> >  		de = *p;
> > +
> > +		/*
> > +		 * Stop accepting new readers/writers. If you're dynamically
> > +		 * allocating ->proc_fops, save a pointer somewhere.
> > +		 */
> > +		spin_lock(&de->pde_unload_lock);
> > +		de->proc_fops = NULL;
> > +		/* Wait until all readers/writers are done. */
> > +		if (de->pde_users > 0) {
> > +			spin_unlock(&de->pde_unload_lock);
> > +			spin_unlock(&proc_subdir_lock);
> > +			schedule();
> > +			goto again;
> > +		}
> > +		spin_unlock(&de->pde_unload_lock);
>
> aergh.  This will devolve into busy-wait-until-we-expire-our-timeslice.
>
> Would be nicer to do this with a wait_for_completion().
>
> I guess it doesn't happen very often - if another process happens to
> be in the middle or a read or write syscall to that /proc file.

Yes, that's rare. OK, I read LDD3 text on completions, hope I got it
right.

Does it pass everyone's bullshit detectors?




[PATCH v4] Fix rmmod/read/write races in /proc entries

Differences from version 3:
	Use completion instead of unlock/schedule/lock
	Move refcount waiting business after removing PDE from lists,
	so that *cough* possible concurrent remove_proc_entry() will
	work.

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

PDE gets counter counting reads and writes in progress done via
->read_proc, ->write_proc, ->get_info . Generic proc code will bump
PDE's counter before calling into module-specific method and decrement
it after it returns.

remove_proc_entry() will wait until all readers and writers are done.
To do this reliably it will set ->proc_fops to NULL and generic proc
code won't call into module it it sees NULL ->proc_fops.

This patch implements part above. So far, no changes in proc users
required except that users dynamically creating ->proc_fops need to
be careful to not get leak. Patch fixes races of type 1.

Patch survives infinite modprobe/rmmod loop in parallel with infinite
read loops with many debugging options turned on including lockdep
(albeit on UP-PREEMPT box).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c       |   83 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/proc_fs.h |   19 ++++++++++
 2 files changed, 100 insertions(+), 2 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -20,6 +20,7 @@ #include <linux/idr.h>
 #include <linux/namei.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/completion.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -76,6 +77,21 @@ proc_file_read(struct file *file, char _
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
 
@@ -195,6 +211,13 @@ proc_file_read(struct file *file, char _
 		buf += n;
 		retval += n;
 	}
+
+	spin_lock(&dp->pde_unload_lock);
+	dp->pde_users--;
+	if (dp->pde_unload_completion && dp->pde_users == 0)
+		complete(dp->pde_unload_completion);
+out_unlock:
+	spin_unlock(&dp->pde_unload_lock);
 	free_page((unsigned long) page);
 	return retval;
 }
@@ -205,14 +228,41 @@ proc_file_write(struct file *file, const
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
+	if (dp->pde_unload_completion && dp->pde_users == 0)
+		complete(dp->pde_unload_completion);
+out_unlock:
+	spin_unlock(&dp->pde_unload_lock);
+out:
+	return rv;
 }
 
 
@@ -604,6 +654,9 @@ static struct proc_dir_entry *proc_creat
 	ent->namelen = len;
 	ent->mode = mode;
 	ent->nlink = nlink;
+	ent->pde_users = 0;
+	spin_lock_init(&ent->pde_unload_lock);
+	ent->pde_unload_completion = NULL;
  out:
 	return ent;
 }
@@ -725,6 +778,32 @@ void remove_proc_entry(const char *name,
 		de = *p;
 		*p = de->next;
 		de->next = NULL;
+
+		spin_lock(&de->pde_unload_lock);
+		/*
+		 * Stop accepting new readers/writers. If you're dynamically
+		 * allocating ->proc_fops, save a pointer somewhere.
+		 */
+		de->proc_fops = NULL;
+		/* Wait until all existing readers/writers are done. */
+		if (de->pde_users > 0) {
+			struct completion c;
+
+			init_completion(&c);
+			if (!de->pde_unload_completion)
+				de->pde_unload_completion = &c;
+
+			spin_unlock(&de->pde_unload_lock);
+			spin_unlock(&proc_subdir_lock);
+
+			wait_for_completion(de->pde_unload_completion);
+
+			spin_lock(&proc_subdir_lock);
+			goto continue_removing;
+		}
+		spin_unlock(&de->pde_unload_lock);
+
+continue_removing:
 		if (S_ISDIR(de->mode))
 			parent->nlink--;
 		proc_kill_inodes(de);
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -7,6 +7,8 @@ #include <linux/spinlock.h>
 #include <linux/magic.h>
 #include <asm/atomic.h>
 
+struct completion;
+
 /*
  * The proc filesystem constants/structures
  */
@@ -56,6 +58,19 @@ struct proc_dir_entry {
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
@@ -66,6 +81,10 @@ struct proc_dir_entry {
 	atomic_t count;		/* use count */
 	int deleted;		/* delete flag */
 	void *set;
+	int pde_users;	/* number of readers + number of writers via
+			 * ->read_proc, ->write_proc, ->get_info */
+	spinlock_t pde_unload_lock;
+	struct completion *pde_unload_completion;
 };
 
 struct kcore_list {

