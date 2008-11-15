Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYKOVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYKOVsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 16:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYKOVsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 16:48:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYKOVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 16:48:00 -0500
Message-Id: <20081115214757.867019408@goodmis.org>
References: <20081115214705.363808961@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 15 Nov 2008 16:47:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] ftrace: replace raw_local_irq_save with local_irq_save
Content-Disposition: inline; filename=0001-ftrace-replace-raw_local_irq_save-with-local_irq_sa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: let logdev work when function tracing is enabled

The raw_local_irq_saves used in ftrace is causing problems with
lockdep. They are not needed, and the normal local_irq_save is fine.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c          |    4 ++--
 kernel/trace/trace_selftest.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a90462..dff4bee 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1051,7 +1051,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	 * Need to use raw, since this must be called before the
 	 * recursive protection is performed.
 	 */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -1062,7 +1062,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	}
 
 	atomic_dec(&data->disabled);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 24e6e07..5cb64ea 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -52,7 +52,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 	int cpu, ret = 0;
 
 	/* Don't allow flipping of max traces now */
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	__raw_spin_lock(&ftrace_max_lock);
 
 	cnt = ring_buffer_entries(tr->buffer);
@@ -63,7 +63,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 			break;
 	}
 	__raw_spin_unlock(&ftrace_max_lock);
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 
 	if (count)
 		*count = cnt;
-- 
1.5.6.5

-- 
