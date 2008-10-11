Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbYJKURi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbYJKURi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYJKURb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:17:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:52186 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbYJKURa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=dVQ1jSIT6AkDeIGt2bWRnQLSKSkP4WczfaN8Oa0S0GKF8L7huYkWHxj3CnGVNLPh6g
         90khOHDmebg7HwfFumaQtX0PHrPA+H5vsh0yYhMdBg8v+wV7w0ysvktJ7cPfwXChKzvA
         MOrPc4Pa7QLHr/TgOPUHZAOqY5ObHvAMxaQdw=
Message-ID: <48F109D5.9030703@gmail.com>
Date: Sat, 11 Oct 2008 22:17:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] tracing/fastboot: Make the boot tracer use the cpu_clock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the boot tracer use the cpu_clock() rather than the ktime
API. This way we will be able to unify the time capture with 
the sched_switch tracer.
Also delete the duration attribute which is not needed and can be
retrieved at print time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/ftrace.h    |    5 ++---
 init/main.c               |   25 ++++++++++++++++++-------
 kernel/trace/trace_boot.c |   18 ++++++++++--------
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 135a33f..36b570b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -222,9 +222,8 @@ struct boot_trace {
 	pid_t			caller;
 	char 			func[KSYM_NAME_LEN];
 	int			result;
-	unsigned long long	duration;
-	ktime_t			calltime;
-	ktime_t			rettime;
+	unsigned long long	calltime;
+	unsigned long long	rettime;
 };
 
 #ifdef CONFIG_BOOT_TRACER
diff --git a/init/main.c b/init/main.c
index 98c05aa..bf13013 100644
--- a/init/main.c
+++ b/init/main.c
@@ -721,27 +721,38 @@ __setup("initcall_debug", initcall_debug_setup);
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
-	ktime_t delta;
+	ktime_t delta, t0, t1;
 	char msgbuf[64];
+	unsigned long long duration;
 	struct boot_trace it;
 
 	if (initcall_debug) {
+		long cpu;
 		it.caller = task_pid_nr(current);
 		printk("calling  %pF @ %i\n", fn, it.caller);
-		it.calltime = ktime_get();
+		t0 = ktime_get();
+		preempt_disable();
+		cpu = raw_smp_processor_id();
+		it.calltime = cpu_clock(cpu);
+		preempt_enable();
 		enable_boot_trace();
 	}
 
 	it.result = fn();
 
 	if (initcall_debug) {
-		it.rettime = ktime_get();
-		delta = ktime_sub(it.rettime, it.calltime);
-		it.duration = (unsigned long long) delta.tv64 >> 20;
+		long cpu;
+		disable_boot_trace();
+		t1 = ktime_get();
+		preempt_disable();
+		cpu = raw_smp_processor_id();
+		it.rettime = cpu_clock(cpu);
+		preempt_enable();
+		delta = ktime_sub(t1, t0);
+		duration = (unsigned long long) delta.tv64 >> 20;
 		printk("initcall %pF returned %d after %Ld msecs\n", fn,
-			it.result, it.duration);
+			it.result, duration);
 		trace_boot(&it, fn);
-		disable_boot_trace();
 	}
 
 	msgbuf[0] = 0;
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index bd5046c..20d326b 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -68,22 +68,24 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 	struct trace_boot *field = (struct trace_boot *)entry;
 	struct boot_trace *it = &field->initcall;
 	struct trace_seq *s = &iter->seq;
-	struct timespec calltime = ktime_to_timespec(it->calltime);
-	struct timespec rettime = ktime_to_timespec(it->rettime);
+	unsigned long sec, nsec_rem;
+	unsigned long long duration = it->rettime - it->calltime;
 
 	if (entry->type == TRACE_BOOT) {
+		nsec_rem = do_div(it->calltime, 1000000000);
+		sec = (unsigned long) it->calltime;
 		ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
-					  calltime.tv_sec,
-					  calltime.tv_nsec,
-					  it->func, it->caller);
+					  sec, nsec_rem, it->func, it->caller);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 
+		nsec_rem = do_div(it->rettime, 1000000000);
+		sec = (unsigned long) it->rettime;
+		do_div(duration, 1000);
 		ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
 					  "returned %d after %lld msecs\n",
-					  rettime.tv_sec,
-					  rettime.tv_nsec,
-					  it->func, it->result, it->duration);
+					  sec, nsec_rem, it->func, it->result,
+					  duration);
 
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
