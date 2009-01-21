Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZAUX7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZAUX7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZAUX6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:58:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZAUX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:58:08 -0500
Message-Id: <20090121235805.992357373@goodmis.org>
References: <20090121235306.224764198@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 21 Jan 2009 18:53:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] ring-buffer: do not swap if recording is disabled
Content-Disposition: inline; filename=0002-ring-buffer-do-not-swap-if-recording-is-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the ring buffer recording has been disabled. Do not let
swapping of ring buffers occur. Simply return -EAGAIN.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |   15 +++++++++++++++
 kernel/trace/trace.c       |    2 +-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8de026d..cb260dd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2266,9 +2266,24 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	if (buffer_a->pages != buffer_b->pages)
 		return -EINVAL;
 
+	if (ring_buffer_flags != RB_BUFFERS_ON)
+		return -EAGAIN;
+
+	if (atomic_read(&buffer_a->record_disabled))
+		return -EAGAIN;
+
+	if (atomic_read(&buffer_b->record_disabled))
+		return -EAGAIN;
+
 	cpu_buffer_a = buffer_a->buffers[cpu];
 	cpu_buffer_b = buffer_b->buffers[cpu];
 
+	if (atomic_read(&cpu_buffer_a->record_disabled))
+		return -EAGAIN;
+
+	if (atomic_read(&cpu_buffer_b->record_disabled))
+		return -EAGAIN;
+
 	/*
 	 * We can't do a synchronize_sched here because this
 	 * function can be called in atomic context.
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 220c264..757ae6f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -415,7 +415,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	ftrace_enable_cpu();
 
-	WARN_ON_ONCE(ret);
+	WARN_ON_ONCE(ret && ret != -EAGAIN);
 
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
-- 
1.5.6.5

-- 
