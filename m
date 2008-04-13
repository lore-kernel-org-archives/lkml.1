Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYDMUGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYDMUGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYDMUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:06:10 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:34055 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbYDMUGI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:06:08 -0400
Date: Sun, 13 Apr 2008 23:05:52 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: [BUG/PATCH] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080413230552.33ca587a@daedalus.pq.iki.fi>
In-Reply-To: <20080413224207.4430a09c@daedalus.pq.iki.fi>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9d00d006631650e8ba9131356c544a5ae79f873e Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 12 Apr 2008 00:18:57 +0300
Subject: [PATCH] x86 mmiotrace: dynamically disable non-boot CPUs

Mmiotrace is not reliable with multiple CPUs and may
miss events. Drop to single CPU when mmiotrace is activated.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

When I tested this patch on Intel Core 2 Duo, enter_uniprocessor() triggered
the following kernel bug:

Linux version 2.6.25-rc8-sched-devel.git-x86-latest.git (paalanen@ct200006)
(gcc version 4.1.2 (Gentoo 4.1.2 p1.0.1)) #2 SMP PREEMPT Sun Apr 13
22:09:03 EEST 2008
...
in mmio_trace_init
mmiotrace: Disabling non-boot CPUs...
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
BUG: sleeping function called from invalid context at mm/slab.c:3053
in_atomic():1, irqs_disabled():0
5 locks held by bash/4423:
 #0:  (trace_types_lock){--..}, at: [<ffffffff8026442f>] tracing_set_trace_write+0x93/0x11a
 #1:  (mmiotrace_mutex){--..}, at: [<ffffffff802251e0>] enable_mmiotrace+0x17/0x142
 #2:  (cpu_add_remove_lock){--..}, at: [<ffffffff802580e5>] cpu_maps_update_begin+0x12/0x14
 #3:  (&cpu_hotplug.lock){--..}, at: [<ffffffff8025814f>] cpu_hotplug_begin+0x39/0x9f
 #4:  (smp_alt){--..}, at: [<ffffffff80211bd9>] alternatives_smp_switch+0x66/0x1ab
Pid: 4423, comm: bash Not tainted 2.6.25-rc8-sched-devel.git-x86-latest.git #2

Call Trace:
 [<ffffffff802520c0>] ? __debug_show_held_locks+0x22/0x24
 [<ffffffff8022d292>] __might_sleep+0xd9/0xdb
 [<ffffffff80287326>] cache_alloc_debugcheck_before+0x23/0x32
 [<ffffffff80287a32>] __kmalloc+0x34/0xa5
 [<ffffffff80209393>] ? clear_ti_thread_flag+0x10/0x17
 [<ffffffff8027d7f6>] kmalloc_node+0x9/0xb
 [<ffffffff8027d8e0>] __get_vm_area_node+0xa2/0x1cb
 [<ffffffff80209393>] ? clear_ti_thread_flag+0x10/0x17
 [<ffffffff8027da41>] __get_vm_area+0x13/0x15
 [<ffffffff8027da60>] get_vm_area+0x1d/0x1f
 [<ffffffff8027e14c>] vmap+0x2a/0x5c
 [<ffffffff8021191b>] text_poke+0xaa/0x136
 [<ffffffff804cba2b>] ? _etext+0x0/0x5
 [<ffffffff802119f6>] alternatives_smp_unlock+0x4f/0x63
 [<ffffffff80211ce1>] alternatives_smp_switch+0x16e/0x1ab
 [<ffffffff8021b163>] __cpu_die+0x53/0x7d
 [<ffffffff802583e2>] _cpu_down+0x195/0x26c
 [<ffffffff802585ca>] cpu_down+0x26/0x36
 [<ffffffff80225270>] enable_mmiotrace+0xa7/0x142
 [<ffffffff80266b8d>] mmio_trace_init+0x3c/0x40
 [<ffffffff8026448e>] tracing_set_trace_write+0xf2/0x11a
 [<ffffffff80327fac>] ? security_file_permission+0x11/0x13
 [<ffffffff8028b047>] vfs_write+0xa7/0xe1
 [<ffffffff8028b13b>] sys_write+0x47/0x6d
 [<ffffffff8020b4db>] system_call_after_swapgs+0x7b/0x80

mmiotrace: CPU1 is down.
mmiotrace: enabled.

Is this my fault, or is there a bug somewhere else?
The kernel tree is sched-devel/latest git from 12th April, IIRC.

 arch/x86/mm/mmio-mod.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index ab2bb77..f523c5f 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -32,6 +32,7 @@
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
 #include <asm/atomic.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 #include "pf_in.h"
 
@@ -399,6 +400,54 @@ static void clear_trace_list(void)
 	}
 }
 
+static cpumask_t downed_cpus;
+
+static void enter_uniprocessor(void)
+{
+#ifdef CONFIG_SMP
+	int cpu;
+	int err;
+
+	get_online_cpus();
+	downed_cpus = cpu_online_map;
+	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
+	if (num_online_cpus() > 1)
+		pr_notice(NAME "Disabling non-boot CPUs...\n");
+	put_online_cpus();
+
+	for_each_cpu_mask(cpu, downed_cpus) {
+		err = cpu_down(cpu);
+		if (!err) {
+			pr_info(NAME "CPU%d is down.\n", cpu);
+		} else {
+			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
+		}
+	}
+	if (num_online_cpus() > 1)
+		pr_warning(NAME "multiple CPUs still online, "
+						"may miss events.\n");
+#endif /* CONFIG_SMP */
+}
+
+static void leave_uniprocessor(void)
+{
+#ifdef CONFIG_SMP
+	int cpu;
+	int err;
+
+	if (cpus_weight(downed_cpus) == 0)
+		return;
+	pr_notice(NAME "Re-enabling CPUs...\n");
+	for_each_cpu_mask(cpu, downed_cpus) {
+		err = cpu_up(cpu);
+		if (!err)
+			pr_info(NAME "enabled CPU%d.\n", cpu);
+		else
+			pr_err(NAME "cannot re-enable CPU%d: %d\n", cpu, err);
+	}
+#endif /* CONFIG_SMP */
+}
+
 #if 0 /* XXX: out of order */
 static struct file_operations fops_marker = {
 	.owner =	THIS_MODULE,
@@ -421,6 +470,7 @@ void enable_mmiotrace(void)
 
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
+	enter_uniprocessor();
 	spin_lock_irq(&trace_lock);
 	atomic_inc(&mmiotrace_enabled);
 	spin_unlock_irq(&trace_lock);
@@ -441,6 +491,7 @@ void disable_mmiotrace(void)
 	spin_unlock_irq(&trace_lock);
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
+	leave_uniprocessor();
 	if (marker_file) {
 		debugfs_remove(marker_file);
 		marker_file = NULL;
-- 
1.5.3.7

