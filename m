Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYHHTiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYHHTiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYHHTh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:37:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:32652 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYHHThy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,329,1215414000"; 
   d="scan'208";a="368977972"
Date: Fri, 8 Aug 2008 12:37:53 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, npiggin@suse.de,
       linux-kernel <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: [PATCH] stack and rcu interaction bug in smp_call_function_mask()
Message-ID: <20080808193753.GA21964@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Found a OOPS on a big SMP box during an overnight reboot test with upstream git.

Suresh and I looked at the oops and looks like the root cause is in
generic_smp_call_function_interrupt() and smp_call_function_mask() with
wait parameter.

The actual oops looked like

[   11.277260] BUG: unable to handle kernel paging request at ffff8802ffffffff
[   11.277815] IP: [<ffff8802ffffffff>] 0xffff8802ffffffff
[   11.278155] PGD 202063 PUD 0
[   11.278576] Oops: 0010 [1] SMP
[   11.279006] CPU 5
[   11.279336] Modules linked in:
[   11.279752] Pid: 0, comm: swapper Not tainted 2.6.27-rc2-00020-g685d87f #290
[   11.280039] RIP: 0010:[<ffff8802ffffffff>]  [<ffff8802ffffffff>] 0xffff8802ffffffff
[   11.280692] RSP: 0018:ffff88027f1f7f70  EFLAGS: 00010086
[   11.280976] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 0000000000000000
[   11.281264] RDX: 0000000000004f4e RSI: 0000000000000001 RDI: 0000000000000000
[   11.281624] RBP: ffff88027f1f7f98 R08: 0000000000000001 R09: ffffffff802509af
[   11.281925] R10: ffff8800280c2780 R11: 0000000000000000 R12: ffff88027f097d48
[   11.282214] R13: ffff88027f097d70 R14: 0000000000000005 R15: ffff88027e571000
[   11.282502] FS:  0000000000000000(0000) GS:ffff88027f1c3340(0000) knlGS:0000000000000000
[   11.283096] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   11.283382] CR2: ffff8802ffffffff CR3: 0000000000201000 CR4: 00000000000006e0
[   11.283760] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   11.284048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   11.284337] Process swapper (pid: 0, threadinfo ffff88027f1f2000, task ffff88027f1f0640)
[   11.284936] Stack:  ffffffff80250963 0000000000000212 0000000000ee8c78 0000000000ee8a66
[   11.285802]  ffff88027e571550 ffff88027f1f7fa8 ffffffff8021adb5 ffff88027f1f3e40
[   11.286599]  ffffffff8020bdd6 ffff88027f1f3e40 <EOI>  ffff88027f1f3ef8 0000000000000000
[   11.287120] Call Trace:
[   11.287768]  <IRQ>  [<ffffffff80250963>] ? generic_smp_call_function_interrupt+0x61/0x12c
[   11.288354]  [<ffffffff8021adb5>] smp_call_function_interrupt+0x17/0x27
[   11.288744]  [<ffffffff8020bdd6>] call_function_interrupt+0x66/0x70
[   11.289030]  <EOI>  [<ffffffff8024ab3b>] ? clockevents_notify+0x19/0x73
[   11.289380]  [<ffffffff803b9b75>] ? acpi_idle_enter_simple+0x18b/0x1fa
[   11.289760]  [<ffffffff803b9b6b>] ? acpi_idle_enter_simple+0x181/0x1fa
[   11.290051]  [<ffffffff8053aeca>] ? cpuidle_idle_call+0x70/0xa2
[   11.290338]  [<ffffffff80209f61>] ? cpu_idle+0x5f/0x7d
[   11.290723]  [<ffffffff8060224a>] ? start_secondary+0x14d/0x152
[   11.291010]
[   11.291287]
[   11.291654] Code:  Bad RIP value.
[   11.292041] RIP  [<ffff8802ffffffff>] 0xffff8802ffffffff
[   11.292380]  RSP <ffff88027f1f7f70>
[   11.292741] CR2: ffff8802ffffffff
[   11.310951] ---[ end trace 137c54d525305f1c ]---

The problem is with the following sequence of events:

- CPU A calls smp_call_function_mask() for CPU B with wait parameter
- CPU A sets up the call_function_data on the stack and does an rcu add to
  call_function_queue
- CPU A waits until the WAIT flag is cleared
- CPU B gets the call function interrupt and starts going through the
  call_function_queue
- CPU C also gets some other call function interrupt and starts going through
  the call_function_queue
- CPU C, which is also going through the call_function_queue, starts referencing
  CPU A's stack, as that element is still in call_function_queue
- CPU B finishes the function call that CPU A set up and as there are no other
  references to it, rcu deletes the call_function_data (which was from CPU A
  stack)
- CPU B sees the wait flag and just clears the flag (no call_rcu to free)
- CPU A which was waiting on the flag continues executing and the stack
  contents change

- CPU C is still in rcu_read section accessing the CPU A's stack sees
  inconsistent call_funation_data and can try to execute
  function with some random pointer, causing stack corruption for A
  (by clearing the bits in mask field) and oops.


One way to solve the problem is to have CPU A wait as long as there is a rcu
read happening. But, we cannot use synchronize_rcu() here as we cannot block.
Another way around is to always allocate call_function_data, instead
of using CPU A's stack. Below patch does this. But, that will still have to
handle the kmalloc failure case somehow.

Any other ideas on how to solve this problem?

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 kernel/smp.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c	2008-08-08 11:45:55.000000000 -0700
+++ linux-2.6/kernel/smp.c	2008-08-08 12:25:07.000000000 -0700
@@ -128,6 +128,8 @@ void generic_smp_call_function_interrupt
 		list_del_rcu(&data->csd.list);
 		spin_unlock(&call_function_lock);
 
+		if (data->csd.flags & CSD_FLAG_ALLOC)
+			call_rcu(&data->rcu_head, rcu_free_call_data);
 		if (data->csd.flags & CSD_FLAG_WAIT) {
 			/*
 			 * serialize stores to data with the flag clear
@@ -135,8 +137,7 @@ void generic_smp_call_function_interrupt
 			 */
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
-		} else
-			call_rcu(&data->rcu_head, rcu_free_call_data);
+		}
 	}
 	rcu_read_unlock();
 
@@ -181,11 +182,12 @@ void generic_smp_call_function_single_in
 
 			data->func(data->info);
 
+			if (data_flags & CSD_FLAG_ALLOC)
+				kfree(data);
 			if (data_flags & CSD_FLAG_WAIT) {
 				smp_wmb();
 				data->flags &= ~CSD_FLAG_WAIT;
-			} else if (data_flags & CSD_FLAG_ALLOC)
-				kfree(data);
+			}
 		}
 		/*
 		 * See comment on outer loop
@@ -207,7 +209,6 @@ void generic_smp_call_function_single_in
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int wait)
 {
-	struct call_single_data d;
 	unsigned long flags;
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
@@ -222,13 +223,12 @@ int smp_call_function_single(int cpu, vo
 	} else {
 		struct call_single_data *data = NULL;
 
-		if (!wait) {
-			data = kmalloc(sizeof(*data), GFP_ATOMIC);
-			if (data)
-				data->flags = CSD_FLAG_ALLOC;
-		}
-		if (!data) {
-			data = &d;
+		data = kmalloc(sizeof(*data), GFP_ATOMIC);
+		if (!data)
+			return -1;
+
+		data->flags = CSD_FLAG_ALLOC;
+		if (wait) {
 			data->flags = CSD_FLAG_WAIT;
 		}
 
@@ -280,7 +280,6 @@ void __smp_call_function_single(int cpu,
 int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 			   int wait)
 {
-	struct call_function_data d;
 	struct call_function_data *data = NULL;
 	cpumask_t allbutself;
 	unsigned long flags;
@@ -306,15 +305,14 @@ int smp_call_function_mask(cpumask_t mas
 		return smp_call_function_single(cpu, func, info, wait);
 	}
 
-	if (!wait) {
-		data = kmalloc(sizeof(*data), GFP_ATOMIC);
-		if (data)
-			data->csd.flags = CSD_FLAG_ALLOC;
-	}
-	if (!data) {
-		data = &d;
+	data = kmalloc(sizeof(*data), GFP_ATOMIC);
+	if (!data)
+		return -1;
+
+	data->csd.flags = CSD_FLAG_ALLOC;
+
+	if (wait) {
 		data->csd.flags = CSD_FLAG_WAIT;
-		wait = 1;
 	}
 
 	spin_lock_init(&data->lock);

