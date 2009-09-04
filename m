Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbZIEAUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbZIEAUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934526AbZIEAUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525AbZIEAUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:10 -0400
Message-Id: <20090905000128.005257549@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/18] ring-buffer: only enable ring_buffer_swap_cpu when needed
Content-Disposition: inline; filename=0018-ring-buffer-only-enable-ring_buffer_swap_cpu-when-ne.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since the ability to swap the cpu buffers adds a small overhead to
the recording of a trace, we only want to add it when needed.

Only the irqsoff and preemptoff tracers use this feature, and both are
not recommended for production kernels. This patch disables its use
when neither irqsoff nor preemptoff is configured.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    9 +++++++++
 kernel/trace/Kconfig        |    8 ++++++++
 kernel/trace/ring_buffer.c  |    4 ++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e061b4e..5fcc31e 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -140,8 +140,17 @@ unsigned long ring_buffer_size(struct ring_buffer *buffer);
 void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_reset(struct ring_buffer *buffer);
 
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 			 struct ring_buffer *buffer_b, int cpu);
+#else
+static inline int
+ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
+		     struct ring_buffer *buffer_b, int cpu)
+{
+	return -ENODEV;
+}
+#endif
 
 int ring_buffer_empty(struct ring_buffer *buffer);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 163fbfc..1ea0d12 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -62,6 +62,12 @@ config EVENT_TRACING
 config CONTEXT_SWITCH_TRACER
 	bool
 
+config RING_BUFFER_ALLOW_SWAP
+	bool
+	help
+	 Allow the use of ring_buffer_swap_cpu.
+	 Adds a very slight overhead to tracing when enabled.
+
 # All tracer options should select GENERIC_TRACER. For those options that are
 # enabled by all tracers (context switch and event tracer) they select TRACING.
 # This allows those options to appear when no other tracer is selected. But the
@@ -146,6 +152,7 @@ config IRQSOFF_TRACER
 	select TRACE_IRQFLAGS
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  This option measures the time spent in irqs-off critical
 	  sections, with microsecond accuracy.
@@ -167,6 +174,7 @@ config PREEMPT_TRACER
 	depends on PREEMPT
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  This option measures the time spent in preemption off critical
 	  sections, with microsecond accuracy.
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1766c0e..454e74e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2084,6 +2084,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 
 	rb_start_commit(cpu_buffer);
 
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 	/*
 	 * Due to the ability to swap a cpu buffer from a buffer
 	 * it is possible it was swapped before we committed.
@@ -2096,6 +2097,7 @@ rb_reserve_next_event(struct ring_buffer *buffer,
 		local_dec(&cpu_buffer->commits);
 		return NULL;
 	}
+#endif
 
 	length = rb_calculate_event_length(length);
  again:
@@ -3498,6 +3500,7 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
+#ifdef CONFIG_RING_BUFFER_ALLOW_SWAP
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
  * @buffer_a: One buffer to swap with
@@ -3573,6 +3576,7 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
+#endif /* CONFIG_RING_BUFFER_ALLOW_SWAP */
 
 /**
  * ring_buffer_alloc_read_page - allocate a page to read from buffer
-- 
1.6.3.3

-- 
