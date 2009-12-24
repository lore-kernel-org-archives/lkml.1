Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbZLXL0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbZLXL0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZLXL0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:26:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZLXL0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:26:13 -0500
Date: Thu, 24 Dec 2009 03:26:07 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: reiserfs-devel@vger.kernel.org, fweisbec@gmail.com, jeffm@suse.com
Subject: reiserfs: circular locking dependency detected
Message-ID: <alpine.DEB.2.01.0912240314350.3483@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19Rhep65WeKjV2eXg1jP3pZkS0UIkUUaYnYc79
 W5N6+m8pjWpabFsHSPoFNK1nYKwAHwDxQ4C/jqyG1UYsKfNXFP
 PvHwir9RdtpkgUfFGpctA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've seen the lockdep warning reported in 
http://lkml.org/lkml/2009/12/22/365, but this one is slightly different 
and is not happening on mount but when dbench is run on a freshly created 
filesystem. Below is the lockdep warning, I've put sysrq-D/W/P/T output on 

http://nerdbynature.de/bits/2.6.33-rc1/reiserfs/

- t2 is with lockdep enabled
- proc-fs-reiserfs.log is me trying to cat /proc/fs/reiserfs every 
  2 seconds while dbench is running

Thanks,
Christian.

[  990.005931] =======================================================
[  990.012373] [ INFO: possible circular locking dependency detected ]
[  990.013233] 2.6.33-rc1 #1
[  990.013233] -------------------------------------------------------
[  990.013233] dbench/1891 is trying to acquire lock:
[  990.013233]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<ffffffff81159505>] reiserfs_write_lock+0x35/0x50
[  990.013233] 
[  990.013233] but task is already holding lock:
[  990.013233]  (&REISERFS_I(inode)->i_xattr_sem){+.+.+.}, at: [<ffffffff8115899a>] reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233] 
[  990.013233] which lock already depends on the new lock.
[  990.013233] 
[  990.013233] 
[  990.013233] the existing dependency chain (in reverse order) is:
[  990.013233] 
[  990.013233] -> #1 (&REISERFS_I(inode)->i_xattr_sem){+.+.+.}:
[  990.013233]        [<ffffffff81063afc>] __lock_acquire+0xf9c/0x1560
[  990.013233]        [<ffffffff8106414f>] lock_acquire+0x8f/0xb0
[  990.013233]        [<ffffffff814ac194>] down_write+0x44/0x80
[  990.013233]        [<ffffffff8115899a>] reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]        [<ffffffff81158e30>] reiserfs_xattr_set+0xb0/0x150
[  990.013233]        [<ffffffff8115a6aa>] user_set+0x8a/0x90
[  990.013233]        [<ffffffff8115901a>] reiserfs_setxattr+0xaa/0xb0
[  990.013233]        [<ffffffff810e2596>] __vfs_setxattr_noperm+0x36/0xa0
[  990.013233]        [<ffffffff810e26bc>] vfs_setxattr+0xbc/0xc0
[  990.013233]        [<ffffffff810e2780>] setxattr+0xc0/0x150
[  990.013233]        [<ffffffff810e289d>] sys_fsetxattr+0x8d/0xa0
[  990.013233]        [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
[  990.013233] 
[  990.013233] -> #0 (&REISERFS_SB(s)->lock){+.+.+.}:
[  990.013233]        [<ffffffff81063e30>] __lock_acquire+0x12d0/0x1560
[  990.013233]        [<ffffffff8106414f>] lock_acquire+0x8f/0xb0
[  990.013233]        [<ffffffff814aba77>] __mutex_lock_common+0x47/0x3b0
[  990.013233]        [<ffffffff814abebe>] mutex_lock_nested+0x3e/0x50
[  990.013233]        [<ffffffff81159505>] reiserfs_write_lock+0x35/0x50
[  990.013233]        [<ffffffff811340e5>] reiserfs_prepare_write+0x45/0x180
[  990.013233]        [<ffffffff81158bb6>] reiserfs_xattr_set_handle+0x2a6/0x470
[  990.013233]        [<ffffffff81158e30>] reiserfs_xattr_set+0xb0/0x150
[  990.013233]        [<ffffffff8115a6aa>] user_set+0x8a/0x90
[  990.013233]        [<ffffffff8115901a>] reiserfs_setxattr+0xaa/0xb0
[  990.013233]        [<ffffffff810e2596>] __vfs_setxattr_noperm+0x36/0xa0
[  990.013233]        [<ffffffff810e26bc>] vfs_setxattr+0xbc/0xc0
[  990.013233]        [<ffffffff810e2780>] setxattr+0xc0/0x150
[  990.013233]        [<ffffffff810e289d>] sys_fsetxattr+0x8d/0xa0
[  990.013233]        [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b
[  990.013233] 
[  990.013233] other info that might help us debug this:
[  990.013233] 
[  990.013233] 2 locks held by dbench/1891:
[  990.013233]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff810e2678>] vfs_setxattr+0x78/0xc0
[  990.013233]  #1:  (&REISERFS_I(inode)->i_xattr_sem){+.+.+.}, at: [<ffffffff8115899a>] reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233] 
[  990.013233] stack backtrace:
[  990.013233] Pid: 1891, comm: dbench Not tainted 2.6.33-rc1 #1
[  990.013233] Call Trace:
[  990.013233]  [<ffffffff81061639>] print_circular_bug+0xe9/0xf0
[  990.013233]  [<ffffffff81063e30>] __lock_acquire+0x12d0/0x1560
[  990.013233]  [<ffffffff8115899a>] ? reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]  [<ffffffff8106414f>] lock_acquire+0x8f/0xb0
[  990.013233]  [<ffffffff81159505>] ? reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff8115899a>] ? reiserfs_xattr_set_handle+0x8a/0x470
[  990.013233]  [<ffffffff814aba77>] __mutex_lock_common+0x47/0x3b0
[  990.013233]  [<ffffffff81159505>] ? reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff81159505>] ? reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff81062592>] ? mark_held_locks+0x72/0xa0
[  990.013233]  [<ffffffff814ab81d>] ? __mutex_unlock_slowpath+0xbd/0x140
[  990.013233]  [<ffffffff810628ad>] ? trace_hardirqs_on_caller+0x14d/0x1a0
[  990.013233]  [<ffffffff814abebe>] mutex_lock_nested+0x3e/0x50
[  990.013233]  [<ffffffff81159505>] reiserfs_write_lock+0x35/0x50
[  990.013233]  [<ffffffff811340e5>] reiserfs_prepare_write+0x45/0x180
[  990.013233]  [<ffffffff81158bb6>] reiserfs_xattr_set_handle+0x2a6/0x470
[  990.013233]  [<ffffffff81158e30>] reiserfs_xattr_set+0xb0/0x150
[  990.013233]  [<ffffffff814abcb4>] ? __mutex_lock_common+0x284/0x3b0
[  990.013233]  [<ffffffff8115a6aa>] user_set+0x8a/0x90
[  990.013233]  [<ffffffff8115901a>] reiserfs_setxattr+0xaa/0xb0
[  990.013233]  [<ffffffff810e2596>] __vfs_setxattr_noperm+0x36/0xa0
[  990.013233]  [<ffffffff810e26bc>] vfs_setxattr+0xbc/0xc0
[  990.013233]  [<ffffffff810e2780>] setxattr+0xc0/0x150
[  990.013233]  [<ffffffff81056018>] ? sched_clock_cpu+0xb8/0x100
[  990.013233]  [<ffffffff8105eded>] ? trace_hardirqs_off+0xd/0x10
[  990.013233]  [<ffffffff810560a3>] ? cpu_clock+0x43/0x50
[  990.013233]  [<ffffffff810c6820>] ? fget+0xb0/0x110
[  990.013233]  [<ffffffff810c6770>] ? fget+0x0/0x110
[  990.013233]  [<ffffffff81002ddc>] ? sysret_check+0x27/0x62
[  990.013233]  [<ffffffff810e289d>] sys_fsetxattr+0x8d/0xa0
[  990.013233]  [<ffffffff81002dab>] system_call_fastpath+0x16/0x1b


-- 
BOFH excuse #267:

The UPS is on strike.
