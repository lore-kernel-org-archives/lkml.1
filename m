Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbYIJPM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbYIJPM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYIJPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:12:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:45608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYIJPMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:12:47 -0400
Date: Wed, 10 Sep 2008 17:12:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910151245.GC18644@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu> <20080910123246.GA2564@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910123246.GA2564@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:32:46PM +0200, Ingo Molnar wrote:
> 
> here's another one found on another box:
> 
> [  574.380319] =======================================================
> [  574.380381] [ INFO: possible circular locking dependency detected ]
> [  574.380413] 2.6.27-rc6-tip #30918
> [  574.380440] -------------------------------------------------------
> [  574.380472] sshd/8255 is trying to acquire lock:
> [  574.380500]  (&sb->s_type->i_mutex_key#9){--..}, at: [<ffffffff802d5aab>] do_truncate+0x59/0x83
> [  574.380628] 
> [  574.380629] but task is already holding lock:
> [  574.380679]  (&mm->mmap_sem){----}, at: [<ffffffff80249775>] sys32_mmap2+0x64/0xa7
> [  574.380781] 
> [  574.380781] which lock already depends on the new lock.
> [  574.380782] 
> [  574.380857] 
> [  574.380857] the existing dependency chain (in reverse order) is:
> [  574.380910] 
> [  574.380911] -> #1 (&mm->mmap_sem){----}:
> [  574.381025]        [<ffffffff80281979>] __lock_acquire+0x9b4/0xb3b
> [  574.381081]        [<ffffffff80282499>] lock_acquire+0x8d/0xba
> [  574.381219]        [<ffffffff802a94ff>] iov_iter_fault_in_readable+0x84/0x169
> [  574.381359]        [<ffffffff802aae18>] generic_file_buffered_write+0x119/0x5ad
> [  574.381584]        [<ffffffff802ab6cb>] __generic_file_aio_write_nolock+0x260/0x294
> [  574.381809]        [<ffffffff802ab768>] generic_file_aio_write+0x69/0xc5
> [  574.381948]        [<ffffffff802d68e2>] do_sync_write+0xeb/0x132
> [  574.382086]        [<ffffffff802d6f28>] vfs_write+0xa7/0xe1
> [  574.382222]        [<ffffffff802d701c>] sys_write+0x47/0x6d
> [  574.382359]        [<ffffffff802481b7>] cstar_dispatch+0x7/0x4b
> [  574.382496]        [<ffffffffffffffff>] 0xffffffffffffffff
> [  574.382635] 
> [  574.382636] -> #0 (&sb->s_type->i_mutex_key#9){--..}:
> [  574.382942]        [<ffffffff8028181b>] __lock_acquire+0x856/0xb3b
> [  574.383080]        [<ffffffff80282499>] lock_acquire+0x8d/0xba
> [  574.383218]        [<ffffffff80b77600>] __mutex_lock_common+0xe4/0x333
> [  574.383358]        [<ffffffff80b778e9>] mutex_lock_nested+0x30/0x35
> [  574.383495]        [<ffffffff802d5aab>] do_truncate+0x59/0x83
> [  574.383633]        [<ffffffff802cbbf7>] shmem_file_setup+0xcf/0x106
> [  574.383772]        [<ffffffff802cbc50>] shmem_zero_setup+0x22/0x5e
> [  574.383910]        [<ffffffff802bfc92>] mmap_region+0x250/0x438
> [  574.384031]        [<ffffffff802c047f>] do_mmap_pgoff+0x2fe/0x363
> [  574.384031]        [<ffffffff8024978e>] sys32_mmap2+0x7d/0xa7
> [  574.384031]        [<ffffffff802481b7>] cstar_dispatch+0x7/0x4b
> [  574.384031]        [<ffffffffffffffff>] 0xffffffffffffffff
> [  574.384031] 
> [  574.384031] other info that might help us debug this:
> [  574.384031] 
> [  574.384031] 1 lock held by sshd/8255:
> [  574.384031]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff80249775>] sys32_mmap2+0x64/0xa7
> [  574.384031] 
> [  574.384031] stack backtrace:
> [  574.384031] Pid: 8255, comm: sshd Not tainted 2.6.27-rc6-tip #30918
> [  574.384031] Call Trace:
> [  574.384031]  [<ffffffff80280fba>] print_circular_bug_tail+0x71/0x7c
> [  574.384031]  [<ffffffff8028181b>] __lock_acquire+0x856/0xb3b
> [  574.384031]  [<ffffffff80282499>] lock_acquire+0x8d/0xba
> [  574.384031]  [<ffffffff802d5aab>] ? do_truncate+0x59/0x83
> [  574.384031]  [<ffffffff80b77600>] __mutex_lock_common+0xe4/0x333
> [  574.384031]  [<ffffffff802d5aab>] ? do_truncate+0x59/0x83
> [  574.384031]  [<ffffffff802d5aab>] ? do_truncate+0x59/0x83
> [  574.384031]  [<ffffffff804e475f>] ? _raw_spin_unlock+0x8e/0x93
> [  574.384031]  [<ffffffff80b778e9>] mutex_lock_nested+0x30/0x35
> [  574.384031]  [<ffffffff802d5aab>] do_truncate+0x59/0x83
> [  574.384031]  [<ffffffff802d7c1f>] ? init_file+0x99/0xbb
> [  574.384031]  [<ffffffff802d7deb>] ? alloc_file+0x3e/0x4e
> [  574.384031]  [<ffffffff802cbbf7>] shmem_file_setup+0xcf/0x106
> [  574.384031]  [<ffffffff802cbc50>] shmem_zero_setup+0x22/0x5e
> [  574.384031]  [<ffffffff802bfc92>] mmap_region+0x250/0x438
> [  574.384031]  [<ffffffff802282aa>] ? arch_get_unmapped_area_topdown+0x192/0x294
> [  574.384031]  [<ffffffff802c047f>] do_mmap_pgoff+0x2fe/0x363
> [  574.384031]  [<ffffffff8024978e>] sys32_mmap2+0x7d/0xa7
> [  574.384031]  [<ffffffff802481b7>] cstar_dispatch+0x7/0x4b

Oh, nice one.

It had me scratching my head until I realised you must be using tiny shmem.

Patch attached (which brings closely into line with shmem)

--

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
