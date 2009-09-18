Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbZIRV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbZIRV3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZIRV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:29:27 -0400
Received: from flusers.ccur.com ([12.192.68.2]:34057 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbZIRV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:29:26 -0400
X-Greylist: delayed 792 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2009 17:29:26 EDT
Date: Fri, 18 Sep 2009 17:15:50 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steve French <sfrench@us.ibm.com>,
       Jeff Layton <sfrench@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Ingo Molnar <mingo@elte.hu>
Subject: circular locking dependency detected panic in filldir when CONFIG_PROVE_LOCKING=y
Message-ID: <20090918211550.GA8258@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I experienced a might_fault panic from NFS's use of filldir
in a 2.6.31 kernel compiled with CONFIG_PROVE_LOCKING=y.

Looking at filldir, I see it is accessing user space with
__put_dir's (which are inatomic) and with one copy_to_user
(which is not inatomic).  It is the single copy_to_user
which is causing the might_fault panic.

It doesn't make any sense to be mixing use of inatomic
and non-inatomic services in filldir.  Either all should be
the inatomic version, or none should be.

The might_fault condition being reported by the panic looks
real to me, so I suspect the wrong answer is converting
everything to the inatomic version, since that just
suppresses the circular dependency check while leaving
the circular dependency in place.

Regards,
Joe

      =======================================================
      [ INFO: possible circular locking dependency detected ]
      2.6.31-debug #1
      -------------------------------------------------------
      passwd/28023 is trying to acquire lock:
       (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c11487b9>] nfs_invalidate_mapping+0x24/0x55

      but task is already holding lock:
       (&mm->mmap_sem){++++++}, at: [<c10061b3>] sys_mmap2+0x74/0xa7

      which lock already depends on the new lock.

      the existing dependency chain (in reverse order) is:

      -> #1 (&mm->mmap_sem){++++++}:
             [<c105a9f0>] check_prev_add+0x2dc/0x46e
             [<c105abe4>] check_prevs_add+0x62/0xba
             [<c105af79>] validate_chain+0x33d/0x3eb
             [<c105b52f>] __lock_acquire+0x508/0x57e
             [<c105c54b>] lock_acquire+0xb2/0xcf
             [<c10a15db>] might_fault+0x60/0x80
             [<c1224a58>] copy_to_user+0x2d/0x41
             [<c10c6003>] filldir+0x8d/0xcd
             [<c1143b1d>] nfs_do_filldir+0xd2/0x1be
             [<c1145db0>] nfs_readdir+0x6bf/0x74f
             [<c10c609e>] vfs_readdir+0x5b/0x87
             [<c10c6304>] sys_getdents+0x64/0xa4
             [<c1002add>] sysenter_do_call+0x1b/0x48
             [<ffffffff>] 0xffffffff

      -> #0 (&sb->s_type->i_mutex_key#5){+.+.+.}:
             [<c105a78c>] check_prev_add+0x78/0x46e
             [<c105abe4>] check_prevs_add+0x62/0xba
             [<c105af79>] validate_chain+0x33d/0x3eb
             [<c105b52f>] __lock_acquire+0x508/0x57e
             [<c105c54b>] lock_acquire+0xb2/0xcf
             [<c16545dc>] mutex_lock_nested+0x53/0x2e4
             [<c11487b9>] nfs_invalidate_mapping+0x24/0x55
             [<c1148aa9>] nfs_revalidate_mapping+0x59/0x5e
             [<c11464c9>] nfs_file_mmap+0x55/0x5d
             [<c10a43f7>] mmap_region+0x1dc/0x373
             [<c10a48c0>] do_mmap_pgoff+0x249/0x2ab
             [<c10061c9>] sys_mmap2+0x8a/0xa7
             [<c1002add>] sysenter_do_call+0x1b/0x48
             [<ffffffff>] 0xffffffff

      other info that might help us debug this:

      1 lock held by passwd/28023:
       #0:  (&mm->mmap_sem){++++++}, at: [<c10061b3>] sys_mmap2+0x74/0xa7

      stack backtrace:
      Pid: 28023, comm: passwd Not tainted 2.6.31-debug #1
      Call Trace:
       [<c105a626>] print_circular_bug_tail+0xa4/0xaf
       [<c105a78c>] check_prev_add+0x78/0x46e
       [<c105b52f>] ? __lock_acquire+0x508/0x57e
       [<c105abe4>] check_prevs_add+0x62/0xba
       [<c105af79>] validate_chain+0x33d/0x3eb
       [<c105b52f>] __lock_acquire+0x508/0x57e
       [<c10b27cc>] ? ____cache_alloc_node+0xf4/0x134
       [<c105c54b>] lock_acquire+0xb2/0xcf
       [<c11487b9>] ? nfs_invalidate_mapping+0x24/0x55
       [<c16545dc>] mutex_lock_nested+0x53/0x2e4
       [<c11487b9>] ? nfs_invalidate_mapping+0x24/0x55
       [<c11487b9>] ? nfs_invalidate_mapping+0x24/0x55
       [<c11487b9>] nfs_invalidate_mapping+0x24/0x55
       [<c1148aa9>] nfs_revalidate_mapping+0x59/0x5e
       [<c11464c9>] nfs_file_mmap+0x55/0x5d
       [<c10a43f7>] mmap_region+0x1dc/0x373
       [<c10a48c0>] do_mmap_pgoff+0x249/0x2ab
       [<c10061c9>] sys_mmap2+0x8a/0xa7
       [<c1002add>] sysenter_do_call+0x1b/0x48

