Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYHLARx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYHLARx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYHLARo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:17:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5751 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYHLARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:17:43 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5358"; a="5452938"
Message-ID: <48A0D6A9.4030603@qualcomm.com>
Date: Mon, 11 Aug 2008 17:17:45 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, avi@qumranet.com, andrea@qumranet.com
Subject: Circular vma locking with kvm, seems to be mmu notifiers related
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got this on the latest mainline git.
There are already a couple of lockdep/kvm threads. So maybe it's known.

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-rc2 #36
---------------------------------------------
qemu-system-x86/3445 is trying to acquire lock:
 (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0

but task is already holding lock:
 (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0

other info that might help us debug this:
4 locks held by qemu-system-x86/3445:
 #0:  (&mm->mmap_sem){----}, at: [<ffffffff802b2009>]
do_mmu_notifier_register+0xe9/0x140
 #1:  (mm_all_locks_mutex){--..}, at: [<ffffffff8029f7e7>]
mm_take_all_locks+0x27/0xf0
 #2:  (&inode->i_data.i_mmap_lock){--..}, at: [<ffffffff8029f877>]
mm_take_all_locks+0xb7/0xf0
 #3:  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>]
mm_take_all_locks+0x8d/0xf0

stack backtrace:
Pid: 3445, comm: qemu-kvm Not tainted 2.6.27-rc2 #36

Call Trace:
 [<ffffffff80261ddf>] __lock_acquire+0x92f/0x1020
 [<ffffffff80260c3d>] ? mark_held_locks+0x4d/0x90
 [<ffffffff80260de1>] ? trace_hardirqs_on_caller+0xe1/0x100
 [<ffffffff8026252b>] lock_acquire+0x5b/0x80
 [<ffffffff8029f84d>] ? mm_take_all_locks+0x8d/0xf0
 [<ffffffff8053348f>] _spin_lock+0x2f/0x40
 [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
 [<ffffffff802b1f75>] do_mmu_notifier_register+0x55/0x140
 [<ffffffff802b207e>] mmu_notifier_register+0xe/0x10
 [<ffffffffa00f21db>] kvm_dev_ioctl+0x17b/0x300 [kvm]
 [<ffffffff802c49a1>] vfs_ioctl+0x31/0xa0
 [<ffffffff802c4c9b>] do_vfs_ioctl+0x28b/0x2f0
 [<ffffffff802c4d4a>] sys_ioctl+0x4a/0x80
 [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
