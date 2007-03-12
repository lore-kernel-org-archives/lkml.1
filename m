Return-Path: <linux-kernel-owner+w=401wt.eu-S1030472AbXCLQEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030472AbXCLQEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030481AbXCLQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:04:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030472AbXCLQEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:04:04 -0400
Message-ID: <45F579D9.7090307@redhat.com>
Date: Mon, 12 Mar 2007 17:03:37 +0100
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Icedove 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH -rt] fix preempt count underflow in user_trace_stop
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When playing with trace_user_trigger_irq in order to trace
IRQ->userspace latencies, I encountered a bug in the latency tracer. If
I have wakeup_timing enabled and attempt to stop the trace in my
userspace program, the system crashes. This is caused by an unbalanced
preempt_enable() which underflows the preempt count.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

diff --git a/kernel/latency_trace.c b/kernel/latency_trace.c
index e07bb95..29dfb79 100644
--- a/kernel/latency_trace.c
+++ b/kernel/latency_trace.c
@@ -2396,7 +2396,6 @@ long user_trace_stop(void)
 		if (current != sch.task) {
 			__raw_spin_unlock(&sch.trace_lock);
 			local_irq_restore(flags);
-			preempt_enable();
 			return -EINVAL;
 		}
 		sch.task = NULL;


