Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYJBL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYJBL0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYJBL0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:26:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27625 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYJBL0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=HZB1Zdo5sAPPpuDfqc5hXn32NgvFXmQktsw6vrXrm89LY5iMzxXh0ur984i7sJnMEz
         fM4udikLxgHXhFw20dMi2iv9vbl8raPgAp1CK6y9+ia1OdL6z9QlN18QCruLcFQD+bQX
         f1j5jgTZ4sWH+KNdJuK9XuvTxJZ48jRsOZyJ0=
Message-ID: <48E4AFCD.9080004@gmail.com>
Date: Thu, 02 Oct 2008 13:26:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip 2/2] Tracing/fastboot: Get the initcall name before it
 disappears
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some initcall traces, some initcall names may be inconsistent.
That's because these functions will disappear from the .init section
and also their name from the symbols table.
So we have to copy the name of the function in a buffer large enough
during the trace appending. It is not costly for the ring_buffer because
the number of initcall entries is commonly not really large.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h    |    7 ++++---
 init/main.c               |    3 +--
 kernel/trace/trace_boot.c |   14 ++++++++++----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4455490..e672e51 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/kallsyms.h>
 
 extern int ftrace_enabled;
 extern int
@@ -213,7 +214,7 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 
 struct boot_trace {
 	pid_t			caller;
-	initcall_t		func;
+	char 			func[KSYM_NAME_LEN];
 	int			result;
 	unsigned long long	duration;
 	ktime_t			calltime;
@@ -221,10 +222,10 @@ struct boot_trace {
 };
 
 #ifdef CONFIG_BOOT_TRACER
-extern void trace_boot(struct boot_trace *it);
+extern void trace_boot(struct boot_trace *it, initcall_t fn);
 extern void start_boot_trace(void);
 #else
-static inline void trace_boot(struct boot_trace *it) { }
+static inline void trace_boot(struct boot_trace *it, initcall_t fn) { }
 static inline void start_boot_trace(void) { }
 #endif
 
diff --git a/init/main.c b/init/main.c
index ac3f760..47d621a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -727,7 +727,6 @@ int do_one_initcall(initcall_t fn)
 
 	if (initcall_debug) {
 		it.caller = task_pid_nr(current);
-		it.func = fn;
 		printk("calling  %pF @ %i\n", fn, it.caller);
 		it.calltime = ktime_get();
 	}
@@ -740,7 +739,7 @@ int do_one_initcall(initcall_t fn)
 		it.duration = (unsigned long long) delta.tv64 >> 20;
 		printk("initcall %pF returned %d after %Ld msecs\n", fn,
 			it.result, it.duration);
-		trace_boot(&it);
+		trace_boot(&it, fn);
 	}
 
 	msgbuf[0] = 0;
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index a8cb1c5..114fade 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
+#include <linux/kallsyms.h>
 
 #include "trace.h"
 
@@ -56,17 +57,19 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 	struct timespec rettime = ktime_to_timespec(it->rettime);
 
 	if (entry->type == TRACE_BOOT) {
-		ret = trace_seq_printf(s, "[%5ld.%06ld] calling  %pF @ %i\n",
+		ret = trace_seq_printf(s, "[%5ld.%06ld] calling  %s @ %i\n",
 					  calltime.tv_sec,
 					  calltime.tv_nsec,
 					  it->func, it->caller);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-		ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %pF "
+
+		ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %s "
 					  "returned %d after %lld msecs\n",
 					  rettime.tv_sec,
 					  rettime.tv_nsec,
 					  it->func, it->result, it->duration);
+
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 		return TRACE_TYPE_HANDLED;
@@ -83,8 +86,7 @@ struct tracer boot_tracer __read_mostly =
 	.print_line	= initcall_print_line,
 };
 
-
-void trace_boot(struct boot_trace *it)
+void trace_boot(struct boot_trace *it, initcall_t fn)
 {
 	struct ring_buffer_event *event;
 	struct trace_boot *entry;
@@ -95,6 +97,10 @@ void trace_boot(struct boot_trace *it)
 	if (!trace_boot_enabled)
 		return;
 
+	/* Get its name now since this function could
+	 * disappear because it is in the .init section.
+	 */
+	sprint_symbol(it->func, (unsigned long)fn);
 	preempt_disable();
 	data = tr->data[smp_processor_id()];
 
