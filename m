Return-Path: <linux-kernel-owner+w=401wt.eu-S1763715AbYDXTkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763715AbYDXTkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbYDXTkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:40:06 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:36794 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbYDXTkE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:40:04 -0400
Date: Thu, 24 Apr 2008 22:39:47 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH v2] x86 mmiotrace: dynamically disable non-boot CPUs
Message-ID: <20080424223947.55c053f6@daedalus.pq.iki.fi>
In-Reply-To: <20080413230552.33ca587a@daedalus.pq.iki.fi>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
	<20080413230552.33ca587a@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8979ee55cb6a429c4edd72ebec2244b849f6a79a Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 12 Apr 2008 00:18:57 +0300
Subject: [PATCH] x86 mmiotrace: dynamically disable non-boot CPUs

Mmiotrace is not reliable with multiple CPUs and may
miss events. Drop to single CPU when mmiotrace is activated.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---

I've tested this patch on my Core 2 Duo laptop, and with
"[PATCH v2] Check for breakpoint in text_poke to eliminate bug_on"
cpu hotplug seems to work fine on a sched-devel/latest SMP kernel
both with and without CONFIG_HOTPLUG_CPU.

One strange thing was a stack trace printed just before the CPU resets
for "shutdown -r now", but I could not see what it was about. I'll ignore
that for now, hopefully it's something unrelated.

 arch/x86/mm/mmio-mod.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 6d6cac8..1f77d85 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -32,6 +32,7 @@
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
 #include <asm/atomic.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 #include "pf_in.h"
 
@@ -400,6 +401,64 @@ static void clear_trace_list(void)
 	}
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static cpumask_t downed_cpus;
+
+static void enter_uniprocessor(void)
+{
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
+}
+
+static void leave_uniprocessor(void)
+{
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
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+static void enter_uniprocessor(void)
+{
+	if (num_online_cpus() > 1)
+		pr_warning(NAME "multiple CPUs are online, may miss events. "
+			"Suggest booting with maxcpus=1 kernel argument.\n");
+}
+
+static void leave_uniprocessor(void)
+{
+}
+#endif
+
 #if 0 /* XXX: out of order */
 static struct file_operations fops_marker = {
 	.owner =	THIS_MODULE,
@@ -422,6 +481,7 @@ void enable_mmiotrace(void)
 
 	if (nommiotrace)
 		pr_info(NAME "MMIO tracing disabled.\n");
+	enter_uniprocessor();
 	spin_lock_irq(&trace_lock);
 	atomic_inc(&mmiotrace_enabled);
 	spin_unlock_irq(&trace_lock);
@@ -442,6 +502,7 @@ void disable_mmiotrace(void)
 	spin_unlock_irq(&trace_lock);
 
 	clear_trace_list(); /* guarantees: no more kmmio callbacks */
+	leave_uniprocessor();
 	if (marker_file) {
 		debugfs_remove(marker_file);
 		marker_file = NULL;
-- 
1.5.3.7

