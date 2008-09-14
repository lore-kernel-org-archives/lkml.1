Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYINWMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYINWMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 18:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYINWMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 18:12:34 -0400
Received: from ns2.suse.de ([195.135.220.15]:34222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbYINWMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 18:12:33 -0400
Date: Mon, 15 Sep 2008 00:12:31 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpm@selenic.com
Subject: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Message-ID: <20080914221231.GG27080@wotan.suse.de>
References: <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914080631.GA10720@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 10:06:31AM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > [ 6460.634452] 
> > > [ 6460.634465] =======================================================
> > > [ 6460.634494] [ INFO: possible circular locking dependency detected ]
> > > [ 6460.634517] 2.6.27-rc6-tip-00290-g8e229c3-dirty #1
> > > [ 6460.634535] -------------------------------------------------------
> > > [ 6460.634555] gdm-simple-gree/4778 is trying to acquire lock:
> > > [ 6460.634574]  (&mm->mmap_sem){----}, at: [<c018fe33>] might_fault+0x36/0x73
> > > [ 6460.634639] 
> > > [ 6460.634645] but task is already holding lock:
> > > [ 6460.634662]  (&dev->ev_mutex){--..}, at: [<c01c7a76>] inotify_read+0xd8/0x16e
> > > [ 6460.634715] 
> > > [ 6460.634721] which lock already depends on the new lock.
> > 
> > Yes, there's a thread in my intray called "inotify_read's ev_mutex vs 
> > do_page_fault's mmap_sem...".  It's a bit flakey-looking, but there's 
> > a patch in there.
> 
> ah, thx. I picked up the patch into tip/out-of-tree. (see below for a 
> tided up changelog) Please queue it up as v2.6.27 material. (i'll report 
> it if anything breaks due to the patch)
> 
> 	Ingo
> 
> --------------->
> >From 1eb0a42e4eb3283521ee1de99adbf567874b622f Mon Sep 17 00:00:00 2001
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Thu, 11 Sep 2008 06:12:51 +1000
> Subject: [PATCH] mm: fix locking, inotify_read's ev_mutex vs do_page_fault's mmap_sem...

I would call this "fs: fix inotify locking....", it's not really an mm bug
if another subsystem misuses mm's APIs. But that's a nitpick.

Here is the other patch I did too.


tiny-shmem calls do_truncate in shmem_file_setup. do_truncate takes i_mutex,
and shmem_file_setup is called with mmap_sem held. However i_mutex nests
outside mmap_sem.

Copy the code in shmem.c to avoid this problem.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/mm/tiny-shmem.c
===================================================================
--- linux-2.6.orig/mm/tiny-shmem.c
+++ linux-2.6/mm/tiny-shmem.c
@@ -65,31 +65,25 @@ struct file *shmem_file_setup(char *name
 	if (!dentry)
 		goto put_memory;
 
+        error = -ENFILE;
+        file = get_empty_filp();
+        if (!file)
+                goto put_dentry;
+
 	error = -ENOSPC;
 	inode = ramfs_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0);
 	if (!inode)
-		goto put_dentry;
-
-	d_instantiate(dentry, inode);
-	error = -ENFILE;
-	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
-			&ramfs_file_operations);
-	if (!file)
-		goto put_dentry;
-
-	inode->i_nlink = 0;	/* It is unlinked */
-
-	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
-	if (error < 0)
 		goto close_file;
 
+        d_instantiate(dentry, inode);
+        inode->i_size = size;
+        inode->i_nlink = 0;     /* It is unlinked */
+        init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
+                        &ramfs_file_operations);
 	return file;
 
 close_file:
 	put_filp(file);
-	return ERR_PTR(error);
-
 put_dentry:
 	dput(dentry);
 put_memory:
