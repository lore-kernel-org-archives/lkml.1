Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYFBToF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYFBToF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYFBTnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:43:52 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:51337 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYFBTnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:43:50 -0400
Date: Mon, 2 Jun 2008 16:43:36 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc4-git4: tty: lockdep warning
Message-ID: <20080602164336.3eb74814@mandriva.com.br>
Organization: Mandriva
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi Alan,

 I'm getting the following lockdep warning when I log on the system
and setfont is called.

 Seems tty related. The kernel is a 2.6.26-rc4-git4 vanilla.

"""
=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-0.rc4.git4.1mdv #1
-------------------------------------------------------
setfont/3775 is trying to acquire lock:
 (tasklist_lock){..--}, at: [<c0127315>] kill_pgrp+0x16/0x39

but task is already holding lock:
 (&tty->ctrl_lock){....}, at: [<c0232d4b>] vc_resize+0x356/0x3ee

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&tty->ctrl_lock){....}:
       [<c0139485>] __lock_acquire+0xa27/0xb97
       [<c0139654>] lock_acquire+0x5f/0x84
       [<c02c7580>] _spin_lock_irqsave+0x35/0x45
       [<c0222a5e>] __proc_set_tty+0x1e/0xa4
       [<c0225cde>] tty_ioctl+0x5e3/0xe85
       [<c017b771>] vfs_ioctl+0x19/0x49
       [<c017b999>] do_vfs_ioctl+0x1f8/0x20f
       [<c017b9f0>] sys_ioctl+0x40/0x5c
       [<c010392f>] sysenter_past_esp+0x78/0xd9
       [<ffffffff>] 0xffffffff

-> #1 (&sighand->siglock){.+..}:
       [<c0139485>] __lock_acquire+0xa27/0xb97
       [<c0139654>] lock_acquire+0x5f/0x84
       [<c02c74d8>] _spin_lock+0x19/0x28
       [<c011cdfb>] copy_process+0xc13/0xf78
       [<c011d20d>] do_fork+0xad/0x1dc
       [<c01024ea>] kernel_thread+0x79/0x81
       [<c012d7f7>] kthreadd+0x95/0x11f
       [<c0104c47>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (tasklist_lock){..--}:
       [<c01393a4>] __lock_acquire+0x946/0xb97
       [<c0139654>] lock_acquire+0x5f/0x84
       [<c02c7723>] _read_lock+0x19/0x28
       [<c0127315>] kill_pgrp+0x16/0x39
       [<c0232d88>] vc_resize+0x393/0x3ee
       [<c01f1786>] vgacon_font_set+0x1c5/0x1e4
       [<c022fb6d>] con_font_op+0x15c/0x378
       [<c022adfb>] vt_ioctl+0x12f7/0x14c0
       [<c0226513>] tty_ioctl+0xe18/0xe85
       [<c017b771>] vfs_ioctl+0x19/0x49
       [<c017b999>] do_vfs_ioctl+0x1f8/0x20f
       [<c017b9f0>] sys_ioctl+0x40/0x5c
       [<c010392f>] sysenter_past_esp+0x78/0xd9
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by setfont/3775:
 #0:  (&tty->termios_mutex){--..}, at: [<c0232d3b>] vc_resize+0x346/0x3ee
 #1:  (&tty->ctrl_lock){....}, at: [<c0232d4b>] vc_resize+0x356/0x3ee

stack backtrace:
Pid: 3775, comm: setfont Not tainted 2.6.26-0.rc4.git4.1mdv #1
 [<c0138845>] print_circular_bug_tail+0x5a/0x65
 [<c01386b7>] ? print_circular_bug_entry+0x39/0x43
 [<c01393a4>] __lock_acquire+0x946/0xb97
 [<c01394a8>] ? __lock_acquire+0xa4a/0xb97
 [<c0139654>] lock_acquire+0x5f/0x84
 [<c0127315>] ? kill_pgrp+0x16/0x39
 [<c02c7723>] _read_lock+0x19/0x28
 [<c0127315>] ? kill_pgrp+0x16/0x39
 [<c0127315>] kill_pgrp+0x16/0x39
 [<c0232d88>] vc_resize+0x393/0x3ee
 [<c01f1786>] vgacon_font_set+0x1c5/0x1e4
 [<c01f15c1>] ? vgacon_font_set+0x0/0x1e4
 [<c022fb6d>] con_font_op+0x15c/0x378
 [<c022adfb>] vt_ioctl+0x12f7/0x14c0
 [<c02c908e>] ? do_page_fault+0x3ab/0x73d
 [<c0229b04>] ? vt_ioctl+0x0/0x14c0
 [<c0226513>] tty_ioctl+0xe18/0xe85
 [<c0176d9e>] ? pipe_read+0x2b4/0x306
 [<c0170f58>] ? do_sync_read+0xaa/0xe8
 [<c012db07>] ? autoremove_wake_function+0x0/0x33
 [<c02256fb>] ? tty_ioctl+0x0/0xe85
 [<c017b771>] vfs_ioctl+0x19/0x49
 [<c017b999>] do_vfs_ioctl+0x1f8/0x20f
 [<c017b9f0>] sys_ioctl+0x40/0x5c
 [<c010392f>] sysenter_past_esp+0x78/0xd9
 =======================
"""

-- 
Luiz Fernando N. Capitulino
