Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbZELH7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbZELH7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZELH7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:59:25 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56565 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZELH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BiPmiUveP/rXaI0OZCS7JMnbmFWlR1ya9W5i2hFNdbwN2yFFsqbQeQbM4w6EmFwPDQ
         YOL73y03DJqt8Oi1d0TDPPR76xzpjdv1TrGWf0ZFApT3whbpC9LzRFq7YXKis3xs5JPY
         /XaRmrpQ8kqHtENZ2NBF9pyM5xDcxEwBIZKWM=
MIME-Version: 1.0
Date: Tue, 12 May 2009 09:59:22 +0200
Message-ID: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
Subject: INFO: possible circular locking dependency at cleanup_workqueue_thread
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

With this kernel a4d7749be5de4a7261bcbe3c7d96c748792ec455

I've got this INFO trace during suspend:


CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30-rc5-00097-gd665355 #59
-------------------------------------------------------
pm-suspend/12129 is trying to acquire lock:
 (events){+.+.+.}, at: [<ffffffff80259496>] cleanup_workqueue_thread+0x26/0xd0

but task is already holding lock:
 (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff80246e57>]
cpu_maps_update_begin+0x17/0x20

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (cpu_add_remove_lock){+.+.+.}:
       [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
       [<ffffffff80271f38>] lock_acquire+0x98/0x140
       [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
       [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
       [<ffffffff80246e57>] cpu_maps_update_begin+0x17/0x20
       [<ffffffff80259c33>] __create_workqueue_key+0xc3/0x250
       [<ffffffff80287b20>] stop_machine_create+0x40/0xb0
       [<ffffffff8027a784>] sys_delete_module+0x84/0x270
       [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #4 (setup_lock){+.+.+.}:
       [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
       [<ffffffff80271f38>] lock_acquire+0x98/0x140
       [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
       [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
       [<ffffffff80287af7>] stop_machine_create+0x17/0xb0
       [<ffffffff80246f06>] disable_nonboot_cpus+0x26/0x130
       [<ffffffff8027dd8d>] suspend_devices_and_enter+0xbd/0x1b0
       [<ffffffff8027dff7>] enter_state+0x107/0x170
       [<ffffffff8027e0f9>] state_store+0x99/0x100
       [<ffffffff803abe17>] kobj_attr_store+0x17/0x20
       [<ffffffff8033f1e9>] sysfs_write_file+0xd9/0x160
       [<ffffffff802e1c88>] vfs_write+0xb8/0x180
       [<ffffffff802e2771>] sys_write+0x51/0x90
       [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #3 (dpm_list_mtx){+.+.+.}:
       [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
       [<ffffffff80271f38>] lock_acquire+0x98/0x140
       [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
       [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
       [<ffffffff804532ff>] device_pm_add+0x1f/0xe0
       [<ffffffff8044b9bf>] device_add+0x45f/0x570
       [<ffffffffa007c578>] wiphy_register+0x158/0x280 [cfg80211]
       [<ffffffffa017567c>] ieee80211_register_hw+0xbc/0x410 [mac80211]
       [<ffffffffa01f7c5c>] iwl3945_pci_probe+0xa1c/0x1080 [iwl3945]
       [<ffffffff803c4307>] local_pci_probe+0x17/0x20
       [<ffffffff803c5458>] pci_device_probe+0x88/0xb0
       [<ffffffff8044e1e9>] driver_probe_device+0x89/0x180
       [<ffffffff8044e37b>] __driver_attach+0x9b/0xa0
       [<ffffffff8044d67c>] bus_for_each_dev+0x6c/0xa0
       [<ffffffff8044e03e>] driver_attach+0x1e/0x20
       [<ffffffff8044d955>] bus_add_driver+0xd5/0x290
       [<ffffffff8044e668>] driver_register+0x78/0x140
       [<ffffffff803c56f6>] __pci_register_driver+0x66/0xe0
       [<ffffffffa00bd05c>] 0xffffffffa00bd05c
       [<ffffffff8020904f>] do_one_initcall+0x3f/0x1c0
       [<ffffffff8027d071>] sys_init_module+0xb1/0x200
       [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (cfg80211_mutex){+.+.+.}:
       [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
       [<ffffffff80271f38>] lock_acquire+0x98/0x140
       [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
       [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
       [<ffffffffa007e66a>] reg_todo+0x19a/0x590 [cfg80211]
       [<ffffffff80258f18>] worker_thread+0x1e8/0x3a0
       [<ffffffff8025dc3a>] kthread+0x5a/0xa0
       [<ffffffff8020d23a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (reg_work){+.+.+.}:
       [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
       [<ffffffff80271f38>] lock_acquire+0x98/0x140
       [<ffffffff80258f12>] worker_thread+0x1e2/0x3a0
       [<ffffffff8025dc3a>] kthread+0x5a/0xa0
       [<ffffffff8020d23a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (events){+.+.+.}:
       [<ffffffff80271b36>] __lock_acquire+0xd36/0x10a0
       [<ffffffff80271f38>] lock_acquire+0x98/0x140
       [<ffffffff802594bd>] cleanup_workqueue_thread+0x4d/0xd0
       [<ffffffff8053fe79>] workqueue_cpu_callback+0xc9/0x10f
       [<ffffffff805539a8>] notifier_call_chain+0x68/0xa0
       [<ffffffff802630d6>] raw_notifier_call_chain+0x16/0x20
       [<ffffffff8053d9ec>] _cpu_down+0x1cc/0x2d0
       [<ffffffff80246f90>] disable_nonboot_cpus+0xb0/0x130
       [<ffffffff8027dd8d>] suspend_devices_and_enter+0xbd/0x1b0
       [<ffffffff8027dff7>] enter_state+0x107/0x170
       [<ffffffff8027e0f9>] state_store+0x99/0x100
       [<ffffffff803abe17>] kobj_attr_store+0x17/0x20
       [<ffffffff8033f1e9>] sysfs_write_file+0xd9/0x160
       [<ffffffff802e1c88>] vfs_write+0xb8/0x180
       [<ffffffff802e2771>] sys_write+0x51/0x90
       [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

4 locks held by pm-suspend/12129:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8033f154>]
sysfs_write_file+0x44/0x160
 #1:  (pm_mutex){+.+.+.}, at: [<ffffffff8027df44>] enter_state+0x54/0x170
 #2:  (dpm_list_mtx){+.+.+.}, at: [<ffffffff80452747>] device_pm_lock+0x17/0x20
 #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff80246e57>]
cpu_maps_update_begin+0x17/0x20

stack backtrace:
Pid: 12129, comm: pm-suspend Not tainted 2.6.30-rc5-00097-gd665355 #59
Call Trace:
 [<ffffffff8026fa3d>] print_circular_bug_tail+0x9d/0xe0
 [<ffffffff80271b36>] __lock_acquire+0xd36/0x10a0
 [<ffffffff80270000>] ? mark_lock+0x3e0/0x400
 [<ffffffff80271f38>] lock_acquire+0x98/0x140
 [<ffffffff80259496>] ? cleanup_workqueue_thread+0x26/0xd0
 [<ffffffff802594bd>] cleanup_workqueue_thread+0x4d/0xd0
 [<ffffffff80259496>] ? cleanup_workqueue_thread+0x26/0xd0
 [<ffffffff802703ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8053fe79>] workqueue_cpu_callback+0xc9/0x10f
 [<ffffffff8054acf1>] ? cpu_callback+0x12/0x280
 [<ffffffff805539a8>] notifier_call_chain+0x68/0xa0
 [<ffffffff802630d6>] raw_notifier_call_chain+0x16/0x20
 [<ffffffff8053d9ec>] _cpu_down+0x1cc/0x2d0
 [<ffffffff80246f90>] disable_nonboot_cpus+0xb0/0x130
 [<ffffffff8027dd8d>] suspend_devices_and_enter+0xbd/0x1b0
 [<ffffffff8027dff7>] enter_state+0x107/0x170
 [<ffffffff8027e0f9>] state_store+0x99/0x100
 [<ffffffff803abe17>] kobj_attr_store+0x17/0x20
 [<ffffffff8033f1e9>] sysfs_write_file+0xd9/0x160
 [<ffffffff802e1c88>] vfs_write+0xb8/0x180
 [<ffffffff8029088c>] ? audit_syscall_entry+0x21c/0x240
 [<ffffffff802e2771>] sys_write+0x51/0x90
 [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Back to C!
