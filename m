Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbZFQX1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbZFQX1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZFQX0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZFQX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:28 -0400
Message-Id: <20090617232630.481598231@goodmis.org>
References: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:26:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/7] ring-buffer: add locks around rb_per_cpu_empty
Content-Disposition: inline; filename=0005-ring-buffer-add-locks-around-rb_per_cpu_empty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The checking of whether the buffer is empty or not needs to be serialized
among the readers. Add the reader spin lock around it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2e99dba..969f7cb 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2756,12 +2756,17 @@ EXPORT_SYMBOL_GPL(ring_buffer_reset);
 int ring_buffer_empty(struct ring_buffer *buffer)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
 	int cpu;
+	int ret;
 
 	/* yes this is racy, but if you don't like the race, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		if (!rb_per_cpu_empty(cpu_buffer))
+		spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+		ret = rb_per_cpu_empty(cpu_buffer);
+		spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+		if (!ret)
 			return 0;
 	}
 
@@ -2777,14 +2782,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_empty);
 int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
+	unsigned long flags;
 	int ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 1;
 
 	cpu_buffer = buffer->buffers[cpu];
+	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 	ret = rb_per_cpu_empty(cpu_buffer);
-
+	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return ret;
 }
-- 
1.6.3.1

-- 
