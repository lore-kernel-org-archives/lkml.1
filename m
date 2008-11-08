Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYKHDvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYKHDvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYKHDsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:48:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbYKHDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:52 -0500
Message-Id: <20081108034750.383808318@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/10] ftrace: force pass of preemptoff selftest
Content-Disposition: inline; filename=0009-ftrace-force-pass-of-preemptoff-selftest.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: preemptoff not tested in selftest

Due to the BKL not being preemptable anymore, the selftest of the
preemptoff code can not be tested. It requires that it is called
with preemption enabled, but since the BKL is held, that is no
longer the case.

This patch simply skips those tests if it detects that the context
is not preemptable. The following will now show up in the tests:

Testing tracer preemptoff: can not test ... force PASSED
Testing tracer preemptirqsoff: can not test ... force PASSED

When the BKL is removed, or it becomes preemptable once again, then
the tests will be performed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_selftest.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index ea4e5d3..0728a10 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -257,6 +257,19 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	unsigned long count;
 	int ret;
 
+	/*
+	 * Now that the big kernel lock is no longer preemptable,
+	 * and this is called with the BKL held, it will always
+	 * fail. If preemption is already disabled, simply
+	 * pass the test. When the BKL is removed, or becomes
+	 * preemptible again, we will once again test this,
+	 * so keep it in.
+	 */
+	if (preempt_count()) {
+		printk(KERN_CONT "can not test ... force ");
+		return 0;
+	}
+
 	/* start the tracing */
 	trace->init(tr);
 	/* reset the max latency */
@@ -293,6 +306,19 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	unsigned long count;
 	int ret;
 
+	/*
+	 * Now that the big kernel lock is no longer preemptable,
+	 * and this is called with the BKL held, it will always
+	 * fail. If preemption is already disabled, simply
+	 * pass the test. When the BKL is removed, or becomes
+	 * preemptible again, we will once again test this,
+	 * so keep it in.
+	 */
+	if (preempt_count()) {
+		printk(KERN_CONT "can not test ... force ");
+		return 0;
+	}
+
 	/* start the tracing */
 	trace->init(tr);
 
-- 
1.5.6.5

-- 
