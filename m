Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZKIMbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZKIMbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZKIMbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:31:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54150 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZKIMbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:31:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF80B8B.8080203@jp.fujitsu.com>
Date: Mon, 09 Nov 2009 21:31:07 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Kernel oops in resched_task() with 2.6.31.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I frequently encounter the kernel oops attached below in resched_task()
with 2.6.31.5. This kernel oops happens also with 2.6.32-rc5. I don't
know about other kernel.

Here is my analysis:

The immediate cause of this kernel oops is that NULL was passed to
resched_task() from resched_cpu(). From my investigation, this was
caused as follows:

- trigger_load_balance() caluculated cpu number of idle load balancer
  using find_new_ilb(), and find_new_ilb() returned *offline* CPU
  number (16 in my case). Note that I didn't do any CPU hotplug
  operation. On my system, present, online and offline under
  /sys/devices/system/cpu/ are

    [kanesige@localhost ~]$ cat /sys/devices/system/cpu/present
    0-15
    [kanesige@localhost ~]$ cat /sys/devices/system/cpu/online
    0-15
    [kanesige@localhost ~]$ cat /sys/devices/system/cpu/offline
    16-255

  And nr_cpu_ids is 256.

- resched_cpu() calculated current task by cpu_curr() with offline CPU
  number.

So this kernel oops seems to be caused by invalid CPU number returned
from find_new_ilb(). I don't know the find_new_ilb() implementation,
but I suspect the initialization of cpumasks used by find_new_ilb().
The patch attached below seems to fix the problem (With this patch,
the kernel oops doesn't happen). But I don't know if this is the
correct fix.


Kernel oops message
===================
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8104b780>] resched_task+0x17/0x88
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/kernel/uevent_seqnum
CPU 13
Modules linked in: kvm_intel kvm uinput lpfc e1000e igb usb_storage scsi_transport_fc i2c_i801 scsi_tgt dca i2c_core iTCO_wdt iTCO_vendor_support pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod shpchp mptsas mptscsih mptbase scsi_transport_sas [last unloaded: scsi_wait_scan]
Pid: 1218, comm: kstop/13 Not tainted 2.6.31.5-kk #3 SIRIUS
RIP: 0010:[<ffffffff8104b780>]  [<ffffffff8104b780>] resched_task+0x17/0x88
RSP: 0018:ffff880044056db8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8800447c6a00 RCX: ffff88046a5f9750
RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000000
RBP: ffff880044056dc8 R08: ffff88046a5fa100 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000046
R13: 00000000001d6a00 R14: 0000000000000010 R15: ffff880044061310
FS:  0000000000000000(0000) GS:ffff880044053000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000001001000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kstop/13 (pid: 1218, threadinfo ffff8804590b2000, task ffff88046a5f96e0)
Stack:
 ffff880044229a00 0000000013544dc3 ffff880044056e08 ffffffff81052c42
<0> ffff880044056e08 0000000013544dc3 ffff880044229a00 000000000000000d
<0> ffff88046a5f96e0 ffffffff8108ca19 ffff880044056e48 ffffffff8105af6b
Call Trace:
 <IRQ>
 [<ffffffff81052c42>] resched_cpu+0x95/0xc1
 [<ffffffff8108ca19>] ? tick_sched_timer+0x0/0xc4
 [<ffffffff8105af6b>] scheduler_tick+0x190/0x24a
 [<ffffffff8106eb36>] update_process_times+0x61/0x88
 [<ffffffff8108ca9d>] tick_sched_timer+0x84/0xc4
 [<ffffffff81080ab4>] __run_hrtimer+0x98/0xe4
 [<ffffffff81081ac6>] ? hrtimer_interrupt+0xbb/0x17e
 [<ffffffff81081b0b>] hrtimer_interrupt+0x100/0x17e
 [<ffffffff810af2b8>] ? stop_cpu+0x0/0x102
 [<ffffffff8102ad8a>] smp_apic_timer_interrupt+0x8f/0xba
 [<ffffffff81012ab3>] apic_timer_interrupt+0x13/0x20
 <EOI>
 [<ffffffff810af39f>] ? stop_cpu+0xe7/0x102
 [<ffffffff810779c8>] ? worker_thread+0x21d/0x339
 [<ffffffff81077973>] ? worker_thread+0x1c8/0x339
 [<ffffffff814ba0ab>] ? thread_return+0x4e/0xd3
 [<ffffffff8107d7ac>] ? autoremove_wake_function+0x0/0x5a
 [<ffffffff810777ab>] ? worker_thread+0x0/0x339
 [<ffffffff8107d375>] ? kthread+0xa7/0xaf
 [<ffffffff81012fea>] ? child_rip+0xa/0x20
 [<ffffffff81012950>] ? restore_args+0x0/0x30
 [<ffffffff8107d2ce>] ? kthread+0x0/0xaf
 [<ffffffff81012fe0>] ? child_rip+0x0/0x20
Code: 55 f8 65 48 33 14 25 28 00 00 00 74 05 e8 e7 5a 01 00 c9 c3 55 48 89 e5 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48 89 45 f8 31 c0 <48> 8b 57 08 48 c7 c0 00 6a 1d 00 8b 4a 18 48 03 04 cd 10 fc 8a
RIP  [<ffffffff8104b780>] resched_task+0x17/0x88
 RSP <ffff880044056db8>
CR2: 0000000000000008
---[ end trace ea5a6390cdfc7170 ]---



---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.31.5/kernel/sched.c
===================================================================
--- linux-2.6.31.5.orig/kernel/sched.c	2009-11-09 17:03:33.818457759 +0900
+++ linux-2.6.31.5/kernel/sched.c	2009-11-09 18:02:39.619934041 +0900
@@ -9386,8 +9386,8 @@
 	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
 	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */


