Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYHBM3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYHBM3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 08:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYHBM3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 08:29:23 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:49385 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYHBM3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 08:29:22 -0400
From: hooanon05@yahoo.co.jp
To: robert.richter@amd.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: oprofile? lockdep warning from 2.6.27-rc1-mm1
Date: Sat, 02 Aug 2008 21:28:42 +0900
Message-ID: <7045.1217680122@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

While I was testing my filesystem module on 2.6.27-rc1-mm1, I got this
message from oprofile. Is this a known problem, or did I miss something?
sync_buffer() is the one in drivers/oprofile/buffer_sync.c instead of
fs/buffer.c.


Junjiro R. Okajima

----------------------------------------------------------------------

+ sudo opcontrol --setup --vmlinux=/home/jro/transparent/linux-2.6.27-rc1-mm1/D/vmlinux
+ sudo opcontrol --reset
+ sudo opcontrol --start
Using default event: GLOBAL_POWER_EVENTS:100000:1:1:1
Using 2.6+ OProfile kernel interface.
Reading module info.
Daemon started.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc1-mm1jrousD #1
-------------------------------------------------------
events/0/7 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<c02d6500>] sync_buffer+0xe7/0x3c9

but task is already holding lock:
 (buffer_mutex){--..}, at: [<c02d6445>] sync_buffer+0x2c/0x3c9

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (buffer_mutex){--..}:
       [<c01427d7>] __lock_acquire+0x1195/0x128d
       [<c014296e>] lock_acquire+0x9f/0xb9
       [<c0369f33>] mutex_lock_nested+0xbd/0x39f
       [<c02d6445>] sync_buffer+0x2c/0x3c9
       [<c02d6170>] wq_sync_buffer+0x3e/0x5c
       [<c012ff4a>] run_workqueue+0x128/0x226
       [<c0130b0c>] worker_thread+0x72/0xa7
       [<c0133217>] kthread+0x37/0x59
       [<c0103e37>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #2 (&(&b->work)->work){--..}:
       [<c01427d7>] __lock_acquire+0x1195/0x128d
       [<c014296e>] lock_acquire+0x9f/0xb9
       [<c012ff45>] run_workqueue+0x123/0x226
       [<c0130b0c>] worker_thread+0x72/0xa7
       [<c0133217>] kthread+0x37/0x59
       [<c0103e37>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (events){--..}:
       [<c01427d7>] __lock_acquire+0x1195/0x128d
       [<c014296e>] lock_acquire+0x9f/0xb9
       [<c01306ac>] flush_work+0x51/0xd2
       [<c0130bda>] schedule_on_each_cpu+0x99/0xbf
       [<c0166266>] lru_add_drain_all+0xd/0xf
       [<c01703a6>] __mlock_vma_pages_range+0x44/0x294
       [<c01706eb>] mlock_fixup+0xf5/0x1c3
       [<c0170832>] do_mlockall+0x79/0x8d
       [<c0170b7d>] sys_mlockall+0x74/0x9e
       [<c0103151>] sysenter_do_call+0x12/0x31
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c01425fa>] __lock_acquire+0xfb8/0x128d
       [<c014296e>] lock_acquire+0x9f/0xb9
       [<c036a77e>] down_read+0x3d/0x74
       [<c02d6500>] sync_buffer+0xe7/0x3c9
       [<c02d6170>] wq_sync_buffer+0x3e/0x5c
       [<c012ff4a>] run_workqueue+0x128/0x226
       [<c0130b0c>] worker_thread+0x72/0xa7
       [<c0133217>] kthread+0x37/0x59
       [<c0103e37>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by events/0/7:
 #0:  (events){--..}, at: [<c012fefc>] run_workqueue+0xda/0x226
 #1:  (&(&b->work)->work){--..}, at: [<c012ff22>] run_workqueue+0x100/0x226
 #2:  (buffer_mutex){--..}, at: [<c02d6445>] sync_buffer+0x2c/0x3c9

stack backtrace:
Pid: 7, comm: events/0 Not tainted 2.6.27-rc1-mm1jrousD #1
 [<c013fb3b>] print_circular_bug_tail+0x68/0x71
 [<c013f1ce>] ? print_circular_bug_entry+0x43/0x4b
 [<c01425fa>] __lock_acquire+0xfb8/0x128d
 [<c0236cc4>] ? debug_smp_processor_id+0x28/0xdc
 [<c013e7ed>] ? trace_hardirqs_off+0xb/0xd
 [<c014296e>] lock_acquire+0x9f/0xb9
 [<c02d6500>] ? sync_buffer+0xe7/0x3c9
 [<c036a77e>] down_read+0x3d/0x74
 [<c02d6500>] ? sync_buffer+0xe7/0x3c9
 [<c02d6500>] sync_buffer+0xe7/0x3c9
 [<c02d6170>] wq_sync_buffer+0x3e/0x5c
 [<c012ff22>] ? run_workqueue+0x100/0x226
 [<c012ff4a>] run_workqueue+0x128/0x226
 [<c012ff22>] ? run_workqueue+0x100/0x226
 [<c02d6132>] ? wq_sync_buffer+0x0/0x5c
 [<c0130b0c>] worker_thread+0x72/0xa7
 [<c01334d6>] ? autoremove_wake_function+0x0/0x3a
 [<c0130a9a>] ? worker_thread+0x0/0xa7
 [<c0133217>] kthread+0x37/0x59
 [<c01331e0>] ? kthread+0x0/0x59
 [<c0103e37>] kernel_thread_helper+0x7/0x10
 =======================
Using log file /var/lib/oprofile/oprofiled.log
Profiler running.
