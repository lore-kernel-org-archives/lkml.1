Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYJBK7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYJBK7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 06:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYJBK7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 06:59:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:52605 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYJBK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 06:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=idk9OkodNIJi10Jozh8l3FQOamIVYkT8RUTwXP+5qf7KxMmlEh5cT9+fFgLvu2Ke8h
         /4efKt3xCGz7xj9aBmHHf/ib57b1GuSKWS2U3+L17OO91aTL4bCQesS65pvJ+xKJXkPL
         EygShlxNWoGCIAUzbk0a65FU2fYMNlh1CgDEw=
Message-ID: <48E4A988.5060300@gmail.com>
Date: Thu, 02 Oct 2008 12:59:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip 1/2] Tracing/fastboot: Change the printing of boot tracer
 according to bootgraph.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the boot tracer printing to make it parsable for
the scripts/bootgraph.pl script.
We have now to output two lines for each initcall, according to the
printk in do_one_initcall() in init/main.c
We need now the call's time and the return's time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h    |    2 ++
 init/main.c               |   20 +++++++++-----------
 kernel/trace/trace_boot.c |   22 +++++++++++++++-------
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 91954eb..4455490 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -216,6 +216,8 @@ struct boot_trace {
 	initcall_t		func;
 	int			result;
 	unsigned long long	duration;
+	ktime_t			calltime;
+	ktime_t			rettime;
 };
 
 #ifdef CONFIG_BOOT_TRACER
diff --git a/init/main.c b/init/main.c
index af54e30..ac3f760 100644
--- a/init/main.c
+++ b/init/main.c
@@ -721,34 +721,32 @@ __setup("initcall_debug", initcall_debug_setup);
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
-	ktime_t t0, t1, delta;
+	ktime_t delta;
 	char msgbuf[64];
-	int result;
 	struct boot_trace it;
 
 	if (initcall_debug) {
 		it.caller = task_pid_nr(current);
 		it.func = fn;
 		printk("calling  %pF @ %i\n", fn, it.caller);
-		t0 = ktime_get();
+		it.calltime = ktime_get();
 	}
 
-	result = fn();
+	it.result = fn();
 
 	if (initcall_debug) {
-		t1 = ktime_get();
-		delta = ktime_sub(t1, t0);
-		it.result = result;
+		it.rettime = ktime_get();
+		delta = ktime_sub(it.rettime, it.calltime);
 		it.duration = (unsigned long long) delta.tv64 >> 20;
 		printk("initcall %pF returned %d after %Ld msecs\n", fn,
-			result, it.duration);
+			it.result, it.duration);
 		trace_boot(&it);
 	}
 
 	msgbuf[0] = 0;
 
-	if (result && result != -ENODEV && initcall_debug)
-		sprintf(msgbuf, "error code %d ", result);
+	if (it.result && it.result != -ENODEV && initcall_debug)
+		sprintf(msgbuf, "error code %d ", it.result);
 
 	if (preempt_count() != count) {
 		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
@@ -763,7 +761,7 @@ int do_one_initcall(initcall_t fn)
 		printk(" returned with %s\n", msgbuf);
 	}
 
-	return result;
+	return it.result;
 }
 
 
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 43bde20..a8cb1c5 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -52,16 +52,24 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 	struct trace_boot *field = (struct trace_boot *)entry;
 	struct boot_trace *it = &field->initcall;
 	struct trace_seq *s = &iter->seq;
+	struct timespec calltime = ktime_to_timespec(it->calltime);
+	struct timespec rettime = ktime_to_timespec(it->rettime);
 
 	if (entry->type == TRACE_BOOT) {
-		ret = trace_seq_printf(s, "%pF called from %i "
-				       "returned %d after %lld msecs\n",
-				       it->func, it->caller, it->result,
-				       it->duration);
-		if (ret)
-			return TRACE_TYPE_HANDLED;
-		else
+		ret = trace_seq_printf(s, "[%5ld.%06ld] calling  %pF @ %i\n",
+					  calltime.tv_sec,
+					  calltime.tv_nsec,
+					  it->func, it->caller);
+		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
+		ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %pF "
+					  "returned %d after %lld msecs\n",
+					  rettime.tv_sec,
+					  rettime.tv_nsec,
+					  it->func, it->result, it->duration);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_HANDLED;
 	}
 	return TRACE_TYPE_UNHANDLED;
 }
