Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZDTW34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZDTW34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbZDTWXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:23:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64093 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbZDTWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:23:27 -0400
Message-Id: <20090420222325.035116865@goodmis.org>
References: <20090420222257.267399830@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 18:22:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] tracing: use recursive counter over irq level
Content-Disposition: inline; filename=0001-tracing-use-recursive-counter-over-irq-level.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Althought using the irq level (hardirq_count, softirq_count and in_nmi)
was nice to detect bad recursion right away, but since the counters are
not atomically updated with respect to the interrupts, the function tracer
might trigger the test from an interrupt handler before the hardirq_count
is updated. This will trigger a false warning.

This patch converts the recursive detection to a simple counter.
If the depth is greater than 16 then the recursive detection will trigger.
16 is more than enough for any nested interrupts.

[ Impact: fix false positive trace recursion detection ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   45 +++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a699767..7bcfd3e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1481,47 +1481,34 @@ rb_reserve_next_event(struct ring_buffer_per_cpu *cpu_buffer,
 	return event;
 }
 
-static int trace_irq_level(void)
-{
-	return (hardirq_count() >> HARDIRQ_SHIFT) +
-		(softirq_count() >> + SOFTIRQ_SHIFT) +
-		!!in_nmi();
-}
+#define TRACE_RECURSIVE_DEPTH 16
 
 static int trace_recursive_lock(void)
 {
-	int level;
-
-	level = trace_irq_level();
+	current->trace_recursion++;
 
-	if (unlikely(current->trace_recursion & (1 << level))) {
-		/* Disable all tracing before we do anything else */
-		tracing_off_permanent();
+	if (likely(current->trace_recursion < TRACE_RECURSIVE_DEPTH))
+		return 0;
 
-		printk_once(KERN_WARNING "Tracing recursion: "
-			    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
-			    hardirq_count() >> HARDIRQ_SHIFT,
-			    softirq_count() >> SOFTIRQ_SHIFT,
-			    in_nmi());
+	/* Disable all tracing before we do anything else */
+	tracing_off_permanent();
 
-		WARN_ON_ONCE(1);
-		return -1;
-	}
+	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
+		    "HC[%lu]:SC[%lu]:NMI[%lu]\n",
+		    current->trace_recursion,
+		    hardirq_count() >> HARDIRQ_SHIFT,
+		    softirq_count() >> SOFTIRQ_SHIFT,
+		    in_nmi());
 
-	current->trace_recursion |= 1 << level;
-
-	return 0;
+	WARN_ON_ONCE(1);
+	return -1;
 }
 
 static void trace_recursive_unlock(void)
 {
-	int level;
-
-	level = trace_irq_level();
-
-	WARN_ON_ONCE(!current->trace_recursion & (1 << level));
+	WARN_ON_ONCE(!current->trace_recursion);
 
-	current->trace_recursion &= ~(1 << level);
+	current->trace_recursion--;
 }
 
 static DEFINE_PER_CPU(int, rb_need_resched);
-- 
1.6.2.1

-- 
