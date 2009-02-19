Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbZBSDi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbZBSDi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZBSDiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:38:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZBSDiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:38:21 -0500
Message-Id: <20090219033819.743793402@goodmis.org>
References: <20090219033531.360862326@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 18 Feb 2009 22:35:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] tracing: disable tracing while testing ring buffer
Content-Disposition: inline; filename=0001-tracing-disable-tracing-while-testing-ring-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to prevent hard lockup on self tests

If one of the tracers are broken and is constantly filling the ring
buffer while the test of the ring buffer is running, it will hang
the box. The reason is that the test is a consumer that will not
stop till the ring buffer is empty. But if the tracer is broken and
is constantly producing input to the buffer, this test will never
end. The result is a lockup of the box.

This happened when KALLSYMS was not defined and the dynamic ftrace
test constantly filled the ring buffer, because the filter failed
and all functions were being traced. Something was being called
that constantly filled the buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_selftest.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 88c8eb7..a7e0ef6 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -57,11 +57,20 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 
 	cnt = ring_buffer_entries(tr->buffer);
 
+	/*
+	 * The trace_test_buffer_cpu runs a while loop to consume all data.
+	 * If the calling tracer is broken, and is constantly filling
+	 * the buffer, this will run forever, and hard lock the box.
+	 * We disable the ring buffer while we do this test to prevent
+	 * a hard lock up.
+	 */
+	tracing_off();
 	for_each_possible_cpu(cpu) {
 		ret = trace_test_buffer_cpu(tr, cpu);
 		if (ret)
 			break;
 	}
+	tracing_on();
 	__raw_spin_unlock(&ftrace_max_lock);
 	local_irq_restore(flags);
 
-- 
1.5.6.5

-- 
