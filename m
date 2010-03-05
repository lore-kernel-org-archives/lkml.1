Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab0CEGHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:07:08 -0500
Received: from ozlabs.org ([203.10.76.45]:51973 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab0CEGHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:07:02 -0500
Date: Fri, 5 Mar 2010 17:06:54 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_event: Fix oops triggered by cpu offline/online
Message-ID: <20100305060654.GE27606@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard found that he could reliably make the kernel hit a
BUG_ON in the slab allocator by taking a cpu offline and then online
while a system-wide perf record session was running.

The reason is that when the cpu comes up, we completely reinitialize
the ctx field of the struct perf_cpu_context for the cpu.  If there is
a system-wide perf record session running, then there will be a struct
perf_event that has a reference to the context, so its refcount will
be 2.  (The perf_event has been removed from the context's group_entry
and event_entry lists by perf_event_exit_cpu(), but that doesn't
remove the perf_event's reference to the context and doesn't decrement
the context's refcount.)

When the cpu comes up, perf_event_init_cpu() gets called, and it calls
__perf_event_init_context() on the cpu's context.  That resets the
refcount to 1.  Then when the perf record session finishes and the
perf_event is closed, the refcount gets decremented to 0 and the
context gets kfreed after an RCU grace period.  Since the context
wasn't kmalloced -- it's part of a per-cpu variable -- bad things
happen.

In fact we don't need to completely reinitialize the context when the
cpu comes up.  It's sufficient to initialize the context once at boot,
but we need to do it for all possible cpus.

This moves the context initialization to happen at boot time.  With
this, we don't trash the refcount and the context never gets kfreed,
and we don't hit the BUG_ON.

Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Tested-by: Anton Blanchard <anton@samba.org>
Cc: stable@kernel.org
---
This bug appears to go back to May 2009, so this patch should get
backported to 2.6.31, .32 and .33.

 kernel/perf_event.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a661e79..6552c20 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5392,12 +5392,22 @@ int perf_event_init_task(struct task_struct *child)
 	return ret;
 }
 
+static void __init perf_event_init_all_cpus(void)
+{
+	int cpu;
+	struct perf_cpu_context *cpuctx;
+
+	for_each_possible_cpu(cpu) {
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		__perf_event_init_context(&cpuctx->ctx, NULL);
+	}
+}
+
 static void __cpuinit perf_event_init_cpu(int cpu)
 {
 	struct perf_cpu_context *cpuctx;
 
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
-	__perf_event_init_context(&cpuctx->ctx, NULL);
 
 	spin_lock(&perf_resource_lock);
 	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
@@ -5474,6 +5484,7 @@ static struct notifier_block __cpuinitdata perf_cpu_nb = {
 
 void __init perf_event_init(void)
 {
+	perf_event_init_all_cpus();
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
