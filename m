Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbXKEK7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbXKEK7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbXKEK7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:59:25 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51439 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbXKEK7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:59:23 -0500
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Is it illegal to refer namespace_sem while inode's mutex held?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200711051959.FIH73935.SOVLJFFFOMOQtH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 5 Nov 2007 19:59:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm running my LSM module on kernel 2.6.23 / Debian Sarge.
I encountered the following warning message.

It seems that calling down_read(&namespace_sem) is not permitted
inside mutex_lock(&inode->i_mutex) , but I'm not sure.
Is it illegal to refer namespace_sem while inode's mutex held?



=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.23-tomoyo2.1 #27
-------------------------------------------------------
rcS/1093 is trying to acquire lock:
 (&namespace_sem){----}, at: [<c017ca7b>] m_start+0x11/0x20

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<c0171e79>] open_namei+0xf2/0x522

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
       [<c017d35b>] graft_tree+0x62/0xca
       [<c013ab37>] check_prev_add+0xc4/0x1bc
       [<c017d35b>] graft_tree+0x62/0xca
       [<c013ac85>] check_prevs_add+0x56/0xcb
       [<c013af9c>] validate_chain+0x2a2/0x31f
       [<c01312ec>] __kernel_text_address+0x18/0x23
       [<c0104b1b>] dump_trace+0x6f/0x87
       [<c013cc54>] __lock_acquire+0x6f2/0x762
       [<c013af6f>] validate_chain+0x275/0x31f
       [<c013d25e>] lock_acquire+0x79/0x93
       [<c017d35b>] graft_tree+0x62/0xca
       [<c0331518>] __mutex_lock_slowpath+0xea/0x280
       [<c017d35b>] graft_tree+0x62/0xca
       [<c017d35b>] graft_tree+0x62/0xca
       [<c017d8f1>] do_add_mount+0x8a/0xe7
       [<c017de52>] do_mount+0x1a9/0x1c0
       [<c0152d76>] __alloc_pages+0x64/0x2b6
       [<c017dc5f>] copy_mount_options+0x4d/0x97
       [<c017e0b5>] sys_mount+0x79/0xb5
       [<c01012f4>] name_to_dev_t+0x4d/0x25d
       [<c0331258>] schedule_timeout+0x79/0x8d
       [<c019b741>] create_proc_entry+0x73/0x86
       [<c012a023>] process_timeout+0x0/0x5
       [<c04648ff>] kernel_init+0x0/0xa3
       [<c0464e93>] prepare_namespace+0x86/0x18e
       [<c0168eb4>] sys_access+0x1f/0x23
       [<c0464998>] kernel_init+0x99/0xa3
       [<c0104aa3>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (&namespace_sem){----}:
       [<c013aa9a>] check_prev_add+0x27/0x1bc
       [<c013ac85>] check_prevs_add+0x56/0xcb
       [<c013af9c>] validate_chain+0x2a2/0x31f
       [<c013cc54>] __lock_acquire+0x6f2/0x762
       [<c0179712>] __d_lookup+0xda/0xfa
       [<c013d25e>] lock_acquire+0x79/0x93
       [<c017ca7b>] m_start+0x11/0x20
       [<c013590f>] down_read+0x3b/0x71
       [<c017ca7b>] m_start+0x11/0x20
       [<c017ca7b>] m_start+0x11/0x20
       [<c01d5abe>] tmy_do_single_write_perm+0x7e/0xda
       [<c0171a74>] vfs_create+0x83/0x105
       [<c0171d44>] open_namei_create+0x47/0x8a
       [<c0171ee3>] open_namei+0x15c/0x522
       [<c01694d3>] do_filp_open+0x25/0x39
       [<c0332cd2>] _spin_unlock+0x14/0x1c
       [<c0169691>] get_unused_fd_flags+0xb0/0xba
       [<c0169764>] do_sys_open+0x44/0xc5
       [<c01697ff>] sys_open+0x1a/0x1c
       [<c0103e6a>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by rcS/1093:
 #0:  (&inode->i_mutex){--..}, at: [<c0171e79>] open_namei+0xf2/0x522

stack backtrace:
 [<c013a37f>] print_circular_bug_tail+0x5f/0x67
 [<c013aa9a>] check_prev_add+0x27/0x1bc
 [<c013ac85>] check_prevs_add+0x56/0xcb
 [<c013af9c>] validate_chain+0x2a2/0x31f
 [<c013cc54>] __lock_acquire+0x6f2/0x762
 [<c0179712>] __d_lookup+0xda/0xfa
 [<c013d25e>] lock_acquire+0x79/0x93
 [<c017ca7b>] m_start+0x11/0x20
 [<c013590f>] down_read+0x3b/0x71
 [<c017ca7b>] m_start+0x11/0x20
 [<c017ca7b>] m_start+0x11/0x20
 [<c01d5abe>] tmy_do_single_write_perm+0x7e/0xda
 [<c0171a74>] vfs_create+0x83/0x105
 [<c0171d44>] open_namei_create+0x47/0x8a
 [<c0171ee3>] open_namei+0x15c/0x522
 [<c01694d3>] do_filp_open+0x25/0x39
 [<c0332cd2>] _spin_unlock+0x14/0x1c
 [<c0169691>] get_unused_fd_flags+0xb0/0xba
 [<c0169764>] do_sys_open+0x44/0xc5
 [<c01697ff>] sys_open+0x1a/0x1c
 [<c0103e6a>] syscall_call+0x7/0xb
 =======================



The location is tmy_do_single_write_perm()
(whose call trace is open_namei() -> open_namei_create() -> security_inode_create())
in the following file
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.1.x/tomoyo-lsm/patches/tomoyo-hooks.diff?rev=653&root=tomoyo&view=markup

Regards.

