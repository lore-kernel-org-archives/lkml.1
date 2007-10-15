Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbXJOGTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbXJOGTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXJOGTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:19:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50826 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbXJOGTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:19:12 -0400
Date: Mon, 15 Oct 2007 11:48:44 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH] Add irq protection in the percpu-counters cpu-hotplug-callback path
Message-ID: <20071015061844.GA15728@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

While running regular cpu-offline tests on 2.6.23-mm1, I 
hit the following lockdep warning.

It was triggered because some of the per-cpu counters and thus 
their locks are accessed from IRQ context. 
This can cause a deadlock if it interrupts a cpu-offline thread which 
is transferring a dead-cpu's counts to the global counter.

Please find the patch for the same below. Tested on i386.

Thanks and Regards
gautham.

=====================Warning! ===========================================

[root@llm43]# ./all_hotplug_once

CPU 1 is now offline

=================================
[ INFO: inconsistent lock state ]
2.6.23-mm1 #3
---------------------------------
inconsistent {in-softirq-W} -> {softirq-on-W} usage.
sh/7103 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&percpu_counter_irqsafe){-+..}, at: [<c028e296>] percpu_counter_hotcpu_callback+0x22/0x67
{in-softirq-W} state was registered at:
  [<c014126f>] __lock_acquire+0x40d/0xb4a
  [<c0141966>] __lock_acquire+0xb04/0xb4a
  [<c0141a0b>] lock_acquire+0x5f/0x79
  [<c028e4b5>] __percpu_counter_add+0x62/0xad
  [<c04d5e81>] _spin_lock+0x21/0x2c
  [<c028e4b5>] __percpu_counter_add+0x62/0xad
  [<c028e4b5>] __percpu_counter_add+0x62/0xad
  [<c01531af>] test_clear_page_writeback+0x88/0xc5
  [<c014d35e>] end_page_writeback+0x20/0x3c
  [<c0188757>] end_buffer_async_write+0x133/0x181
  [<c0141966>] __lock_acquire+0xb04/0xb4a
  [<c0187eb4>] end_bio_bh_io_sync+0x21/0x29
  [<c0187e93>] end_bio_bh_io_sync+0x0/0x29
  [<c0189345>] bio_endio+0x27/0x29
  [<c04358f8>] dec_pending+0x17d/0x199
  [<c0435a13>] clone_endio+0x73/0x9f
  [<c04359a0>] clone_endio+0x0/0x9f
  [<c0189345>] bio_endio+0x27/0x29
  [<c027ba83>] __end_that_request_first+0x150/0x2c0
  [<c034a161>] scsi_end_request+0x1d/0xab
  [<c014f5ed>] mempool_free+0x63/0x67
  [<c034ac22>] scsi_io_completion+0x108/0x2c7
  [<c027e03b>] blk_done_softirq+0x51/0x5c
  [<c012b291>] __do_softirq+0x68/0xdb
  [<c012b33a>] do_softirq+0x36/0x51
  [<c012b4bf>] irq_exit+0x43/0x4e
  [<c0106f60>] do_IRQ+0x73/0x83
  [<c0105902>] common_interrupt+0x2e/0x34
  [<c01600d8>] add_to_swap+0x23/0x66
  [<c01031b4>] mwait_idle_with_hints+0x3b/0x3f
  [<c01033a8>] mwait_idle+0x0/0xf
  [<c01034d1>] cpu_idle+0x9a/0xc7
  [<ffffffff>] 0xffffffff
irq event stamp: 4007
hardirqs last  enabled at (4007): [<c04d4d9c>] __mutex_lock_slowpath+0x21d/0x241
hardirqs last disabled at (4006): [<c04d4bda>] __mutex_lock_slowpath+0x5b/0x241
softirqs last  enabled at (2130): [<c0135ab7>] __rcu_offline_cpu+0x2f/0x5a
softirqs last disabled at (2128): [<c04d5e94>] _spin_lock_bh+0x8/0x31

other info that might help us debug this:
6 locks held by sh/7103:
 #0:  (&buffer->mutex){--..}, at: [<c019f414>] sysfs_write_file+0x22/0xdb
 #1:  (cpu_add_remove_lock){--..}, at: [<c01450fd>] cpu_down+0x13/0x36
 #2:  (sched_hotcpu_mutex){--..}, at: [<c01220db>] migration_call+0x26/0x36a
 #3:  (cache_chain_mutex){--..}, at: [<c0168289>] cpuup_callback+0x28/0x1f9
 #4:  (workqueue_mutex){--..}, at: [<c013456d>] workqueue_cpu_callback+0x26/0xca
 #5:  (percpu_counters_lock){--..}, at: [<c028e287>] percpu_counter_hotcpu_callback+0x13/0x67

stack backtrace:
 [<c013febd>] print_usage_bug+0x101/0x10b
 [<c01406fd>] mark_lock+0x249/0x3f0
 [<c01412d6>] __lock_acquire+0x474/0xb4a
 [<c0141a0b>] lock_acquire+0x5f/0x79
 [<c028e296>] percpu_counter_hotcpu_callback+0x22/0x67
 [<c04d5e81>] _spin_lock+0x21/0x2c
 [<c028e296>] percpu_counter_hotcpu_callback+0x22/0x67
 [<c028e296>] percpu_counter_hotcpu_callback+0x22/0x67
 [<c04d7e3d>] notifier_call_chain+0x2a/0x47
 [<c013aece>] raw_notifier_call_chain+0x9/0xc
 [<c014503d>] _cpu_down+0x174/0x221
 [<c014510f>] cpu_down+0x25/0x36
 [<c02e7a66>] store_online+0x24/0x56
 [<c02e7a42>] store_online+0x0/0x56
 [<c02e5132>] sysdev_store+0x1e/0x22
 [<c019f499>] sysfs_write_file+0xa7/0xdb
 [<c019f3f2>] sysfs_write_file+0x0/0xdb
 [<c016b882>] vfs_write+0x83/0xf6
 [<c016bde3>] sys_write+0x3c/0x63
 [<c0104e8e>] sysenter_past_esp+0x5f/0x99
 =======================

---> 

From: Gautham R Shenoy <ego@in.ibm.com>

Some of the per-cpu counters and thus their locks
are accessed from IRQ contexts. This can cause a deadlock
if it interrupts a cpu-offline thread which is transferring 
a dead-cpu's counts to the global counter.

Add appropriate IRQ protection in the cpu-hotplug callback path.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

---
 lib/percpu_counter.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.23/lib/percpu_counter.c
===================================================================
--- linux-2.6.23.orig/lib/percpu_counter.c
+++ linux-2.6.23/lib/percpu_counter.c
@@ -124,12 +124,13 @@ static int __cpuinit percpu_counter_hotc
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
 		s32 *pcount;
+		unsigned long flags;
 
-		spin_lock(&fbc->lock);
+		spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
-		spin_unlock(&fbc->lock);
+		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 	return NOTIFY_OK;
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
