Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYKKEMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYKKEMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYKKEMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:12:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYKKEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:12:11 -0500
Message-Id: <20081111041208.896374851@goodmis.org>
References: <20081111041114.360885196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Nov 2008 23:11:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: prevent ftrace_special from recursion
Content-Disposition: inline; filename=0001-ftrace-prevent-ftrace_special-from-recursion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: stop ftrace_special from recursion

The ftrace_special is used to help debug areas of the kernel.
Because of this, if it is put in certain locations, the fact that
it allows recursion can become a problem if the kernel developer
using does not realize that.

This patch changes ftrace_special to not allow recursion into itself
to make it more robust.

It also changes from preempt disable interrupts disable to prevent
any loss of trace entries.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5d3dd8a..50f3237 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -960,6 +960,7 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
+	unsigned long flags;
 	int cpu;
 	int pc;
 
@@ -967,14 +968,15 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 		return;
 
 	pc = preempt_count();
-	preempt_disable_notrace();
+	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
-	if (likely(!atomic_read(&data->disabled)))
+	if (likely(atomic_inc_return(&data->disabled) == 1))
 		ftrace_trace_special(tr, data, arg1, arg2, arg3, pc);
 
-	preempt_enable_notrace();
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_FUNCTION_TRACER
-- 
1.5.6.5

-- 
