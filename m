Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbZBFP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbZBFP1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZBFP1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:27:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZBFP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:27:22 -0500
Message-Id: <20090206152720.674386959@goodmis.org>
References: <20090206152151.962749733@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 10:21:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 2/7] ring-buffer: allow tracing_off to be used in core kernel code
Content-Disposition: inline; filename=0002-ring-buffer-allow-tracing_off-to-be-used-in-core-ke.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

tracing_off() is the fastest way to stop recording to the ring buffers.
This may be used in places like panic and die, just before the
ftrace_dump is called.

This patch adds the appropriate CPP conditionals to make it a stub
function when the ring buffer is not configured it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ring_buffer.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index b3b3596..ac94c06 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -124,9 +124,18 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 u64 ring_buffer_time_stamp(int cpu);
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
 
+/*
+ * The below functions are fine to use outside the tracing facility.
+ */
+#ifdef CONFIG_RING_BUFFER
 void tracing_on(void);
 void tracing_off(void);
 void tracing_off_permanent(void);
+#else
+static inline void tracing_on(void) { }
+static inline void tracing_off(void) { }
+static inline void tracing_off_permanent(void) { }
+#endif
 
 void *ring_buffer_alloc_read_page(struct ring_buffer *buffer);
 void ring_buffer_free_read_page(struct ring_buffer *buffer, void *data);
-- 
1.5.6.5

-- 
