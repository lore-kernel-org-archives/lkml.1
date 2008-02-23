Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYBWMwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYBWMwC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:52:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYBWMvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:51:53 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:52792 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbYBWMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:51:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=kzLCdoRX8XVQF87WZuL4dhT9W2Rtps6AvLTirdB8qn1WvPIdj7zsjQnLXCR+icQpe6ZvDHHld/XVpDqIlDpLmgZeybYSunyuPwSEFaM+hHXkLa8pWZtR9yBoSudqMVZS6AT5I9M/SLhgzvxCbtfQ5A9yCvw3Anki/imSzY46wKA=
Message-ID: <47C016E3.1010107@gmail.com>
Date: Sat, 23 Feb 2008 13:51:47 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] stacktrace: add reliability information to saved stack traces
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

This patch is different (probably better?), but touches all users and
all architectures implementing stacktrace saving. If you want it, it's
here... :-)

Kind regards,
Vegard Nossum


 From 98d928d337dca6326773d43da90a268e5ff0c098 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegardno@ifi.uio.no>
Date: Sat, 23 Feb 2008 13:42:56 +0100
Subject: [PATCH] stacktrace: add reliability information to saved stack traces

This will make print_stack_trace() behave more like dump_stack() by saving
"unreliable" trace entries and displaying them as such by prepending a
question mark in front of the function name.

NOTE: This patch has been compile- and run-tested on x86 platform (which is
the only platform supporting unreliable trace entries). No testing has been
carried out for the other platforms. End of note.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
  arch/arm/kernel/stacktrace.c     |    2 +-
  arch/avr32/kernel/stacktrace.c   |    2 +-
  arch/mips/kernel/stacktrace.c    |    8 ++++--
  arch/s390/kernel/stacktrace.c    |   11 +++++----
  arch/sh/kernel/stacktrace.c      |    6 +++-
  arch/sparc64/kernel/stacktrace.c |    2 +-
  arch/x86/kernel/stacktrace.c     |   27 +++++++++++----------
  include/linux/latencytop.h       |    3 ++
  include/linux/stacktrace.h       |   46 +++++++++++++++++++++++++++++++++++--
  kernel/latencytop.c              |    6 +---
  kernel/lockdep.c                 |   17 +++++++------
  kernel/stacktrace.c              |   12 +++++----
  lib/fault-inject.c               |    7 +----
  13 files changed, 98 insertions(+), 51 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index ae31deb..a354f2d 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -49,7 +49,7 @@ static int save_trace(struct stackframe *frame, void *d)
  		return 0;
  	}

-	trace->entries[trace->nr_entries++] = frame->lr;
+	trace->entries.addr[trace->nr_entries++] = frame->lr;

  	return trace->nr_entries >= trace->max_entries;
  }
diff --git a/arch/avr32/kernel/stacktrace.c b/arch/avr32/kernel/stacktrace.c
index 9a68190..db799ed 100644
--- a/arch/avr32/kernel/stacktrace.c
+++ b/arch/avr32/kernel/stacktrace.c
@@ -38,7 +38,7 @@ void save_stack_trace(struct stack_trace *trace)
  		if (skip) {
  			skip--;
  		} else {
-			trace->entries[trace->nr_entries++] = frame->lr;
+			trace->entries.addr[trace->nr_entries++] = frame->lr;
  			if (trace->nr_entries >= trace->max_entries)
  				break;
  		}
diff --git a/arch/mips/kernel/stacktrace.c b/arch/mips/kernel/stacktrace.c
index ebd9db8..6f303b3 100644
--- a/arch/mips/kernel/stacktrace.c
+++ b/arch/mips/kernel/stacktrace.c
@@ -23,8 +23,10 @@ static void save_raw_context_stack(struct stack_trace *trace,
  		if (__kernel_text_address(addr)) {
  			if (trace->skip > 0)
  				trace->skip--;
-			else
-				trace->entries[trace->nr_entries++] = addr;
+			else {
+				trace->entries.addr[trace->nr_entries++]
+					= addr;
+			}
  			if (trace->nr_entries >= trace->max_entries)
  				break;
  		}
@@ -50,7 +52,7 @@ static void save_context_stack(struct stack_trace *trace, struct pt_regs *regs)
  		if (trace->skip > 0)
  			trace->skip--;
  		else
-			trace->entries[trace->nr_entries++] = pc;
+			trace->entries.addr[trace->nr_entries++] = pc;
  		if (trace->nr_entries >= trace->max_entries)
  			break;
  		pc = unwind_stack(current, &sp, pc, &ra);
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 85e46a5..bd62af7 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -28,9 +28,10 @@ static unsigned long save_context_stack(struct stack_trace *trace,
  		sf = (struct stack_frame *)sp;
  		while(1) {
  			addr = sf->gprs[8] & PSW_ADDR_INSN;
-			if (!trace->skip)
-				trace->entries[trace->nr_entries++] = addr;
-			else
+			if (!trace->skip) {
+				trace->entries.addr[trace->nr_entries++]
+					= addr;
+			} else
  				trace->skip--;
  			if (trace->nr_entries >= trace->max_entries)
  				return sp;
@@ -50,7 +51,7 @@ static unsigned long save_context_stack(struct stack_trace *trace,
  		addr = regs->psw.addr & PSW_ADDR_INSN;
  		if (savesched || !in_sched_functions(addr)) {
  			if (!trace->skip)
-				trace->entries[trace->nr_entries++] = addr;
+				trace->entries.addr[trace->nr_entries++] = addr;
  			else
  				trace->skip--;
  		}
@@ -91,5 +92,5 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
  	high = (unsigned long) task_pt_regs(tsk);
  	save_context_stack(trace, sp, low, high, 0);
  	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = ULONG_MAX;
+		trace->entries.addr[trace->nr_entries++] = ULONG_MAX;
  }
diff --git a/arch/sh/kernel/stacktrace.c b/arch/sh/kernel/stacktrace.c
index d41e561..7d6ff92 100644
--- a/arch/sh/kernel/stacktrace.c
+++ b/arch/sh/kernel/stacktrace.c
@@ -27,8 +27,10 @@ void save_stack_trace(struct stack_trace *trace)
  		if (__kernel_text_address(addr)) {
  			if (trace->skip > 0)
  				trace->skip--;
-			else
-				trace->entries[trace->nr_entries++] = addr;
+			else {
+				trace->entries.addr[trace->nr_entries++]
+					= addr;
+			}
  			if (trace->nr_entries >= trace->max_entries)
  				break;
  		}
diff --git a/arch/sparc64/kernel/stacktrace.c b/arch/sparc64/kernel/stacktrace.c
index 47f92a5..95daaac 100644
--- a/arch/sparc64/kernel/stacktrace.c
+++ b/arch/sparc64/kernel/stacktrace.c
@@ -28,7 +28,7 @@ void save_stack_trace(struct stack_trace *trace)
  		if (trace->skip > 0)
  			trace->skip--;
  		else
-			trace->entries[trace->nr_entries++] = rw->ins[7];
+			trace->entries.addr[trace->nr_entries++] = rw->ins[7];

  		fp = rw->ins[6] + STACK_BIAS;
  	} while (trace->nr_entries < trace->max_entries);
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 02f0f61..d1bacaa 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -25,26 +25,27 @@ static int save_stack_stack(void *data, char *name)
  static void save_stack_address(void *data, unsigned long addr, int reliable)
  {
  	struct stack_trace *trace = data;
+
  	if (trace->skip > 0) {
  		trace->skip--;
  		return;
  	}
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = addr;
+
+	if (trace->nr_entries == trace->max_entries)
+		return;
+
+	trace->entries.addr[trace->nr_entries] = addr;
+	trace->entries.reliable[trace->nr_entries] = reliable;
+	trace->nr_entries++;
  }

  static void
  save_stack_address_nosched(void *data, unsigned long addr, int reliable)
  {
-	struct stack_trace *trace = (struct stack_trace *)data;
  	if (in_sched_functions(addr))
  		return;
-	if (trace->skip > 0) {
-		trace->skip--;
-		return;
-	}
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = addr;
+
+	save_stack_address(data, addr, reliable);
  }

  static const struct stacktrace_ops save_stack_ops = {
@@ -66,14 +67,14 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
   */
  void save_stack_trace(struct stack_trace *trace)
  {
+	trace->has_reliable = true;
  	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = ULONG_MAX;
+	save_stack_address(trace, ULONG_MAX, 1);
  }

  void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
  {
+	trace->has_reliable = true;
  	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = ULONG_MAX;
+	save_stack_address(trace, ULONG_MAX, 1);
  }
diff --git a/include/linux/latencytop.h b/include/linux/latencytop.h
index 901c2d6..4abb8f1 100644
--- a/include/linux/latencytop.h
+++ b/include/linux/latencytop.h
@@ -9,6 +9,8 @@
  #ifndef _INCLUDE_GUARD_LATENCYTOP_H_
  #define _INCLUDE_GUARD_LATENCYTOP_H_

+#include <linux/types.h>
+
  #ifdef CONFIG_LATENCYTOP

  #define LT_SAVECOUNT		32
@@ -16,6 +18,7 @@

  struct latency_record {
  	unsigned long	backtrace[LT_BACKTRACEDEPTH];
+	bool		backtrace_reliable[LT_BACKTRACEDEPTH];
  	unsigned int	count;
  	unsigned long	time;
  	unsigned long	max;
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 5da9794..f5e5e9b 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -1,19 +1,59 @@
  #ifndef __LINUX_STACKTRACE_H
  #define __LINUX_STACKTRACE_H

+#include <linux/types.h>
+
  #ifdef CONFIG_STACKTRACE
+
+/*
+ * These two are separate arrays in order to pack entries as tightly
+ * as possible.
+ */
+struct stack_trace_entries {
+	unsigned long *addr;
+	bool *reliable;
+};
+
+#define DEFINE_STACK_TRACE_ENTRIES(entries_addr, entries_reliable)	\
+	{								\
+		.addr = (entries_addr),					\
+		.reliable = (entries_reliable),				\
+	}
+
  struct stack_trace {
-	unsigned int nr_entries, max_entries;
-	unsigned long *entries;
-	int skip;	/* input argument: How many entries to skip */
+	unsigned int nr_entries;
+	unsigned int max_entries;
+	struct stack_trace_entries entries;
+	/* input argument: How many entries to skip */
+	int skip;
+	/*
+	 * Indicate whether the stack-trace dumper has information about the
+	 * reliability of entries. (This varies between architectures.)
+	 */
+	bool has_reliable;
  };

+/*
+ * Common entry point for stack-trace initialisation.
+ */
+static inline void init_stack_trace(struct stack_trace *trace,
+	unsigned int n, int skip, unsigned long *addr, bool *reliable)
+{
+	trace->nr_entries = 0;
+	trace->max_entries = n;
+	trace->entries.addr = addr;
+	trace->entries.reliable = reliable;
+	trace->skip = skip;
+	trace->has_reliable = 0;
+}
+
  extern void save_stack_trace(struct stack_trace *trace);
  extern void save_stack_trace_tsk(struct task_struct *tsk,
  				struct stack_trace *trace);

  extern void print_stack_trace(struct stack_trace *trace, int spaces);
  #else
+# define init_stack_trace(trace, n, skip, addr, rel)	do { } while (0)
  # define save_stack_trace(trace)			do { } while (0)
  # define save_stack_trace_tsk(tsk, trace)		do { } while (0)
  # define print_stack_trace(trace, spaces)		do { } while (0)
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index b4e3c85..01f620a 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -102,10 +102,8 @@ static inline void store_stacktrace(struct task_struct *tsk, struct latency_reco
  {
  	struct stack_trace trace;

-	memset(&trace, 0, sizeof(trace));
-	trace.max_entries = LT_BACKTRACEDEPTH;
-	trace.entries = &lat->backtrace[0];
-	trace.skip = 0;
+	init_stack_trace(&trace, LT_BACKTRACEDEPTH, 0,
+		lat->backtrace, lat->backtrace_reliable);
  	save_stack_trace_tsk(tsk, &trace);
  }

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3574379..43cd90b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -332,16 +332,15 @@ static int verbose(struct lock_class *class)
   * addresses. Protected by the graph_lock.
   */
  unsigned long nr_stack_trace_entries;
-static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
+static unsigned long stack_trace_addr[MAX_STACK_TRACE_ENTRIES];
+static bool stack_trace_reliable[MAX_STACK_TRACE_ENTRIES];

  static int save_trace(struct stack_trace *trace)
  {
-	trace->nr_entries = 0;
-	trace->max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
-	trace->entries = stack_trace + nr_stack_trace_entries;
-
-	trace->skip = 3;
-
+	init_stack_trace(trace,
+		MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries, 3,
+		stack_trace_addr        + nr_stack_trace_entries,
+		stack_trace_reliable    + nr_stack_trace_entries);
  	save_stack_trace(trace);

  	trace->max_entries = trace->nr_entries;
@@ -376,9 +375,11 @@ unsigned int max_recursion_depth;
   */
  static int lockdep_init_error;
  static unsigned long lockdep_init_trace_data[20];
+static bool lockdep_init_trace_reliable[20];
  static struct stack_trace lockdep_init_trace = {
  	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
-	.entries = lockdep_init_trace_data,
+	.entries = DEFINE_STACK_TRACE_ENTRIES(lockdep_init_trace_data,
+					      lockdep_init_trace_reliable),
  };

  /*
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index b71816e..e14b0c9 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -11,14 +11,16 @@

  void print_stack_trace(struct stack_trace *trace, int spaces)
  {
-	int i, j;
+	struct stack_trace_entries *e;
+	int i;

+	e = &trace->entries;
  	for (i = 0; i < trace->nr_entries; i++) {
-		unsigned long ip = trace->entries[i];
+		printk("%*.s [<%p>] ", spaces, "", (void *) e->addr[i]);

-		for (j = 0; j < spaces + 1; j++)
-			printk(" ");
-		print_ip_sym(ip);
+		if (trace->has_reliable)
+			printk("%s ", !e->reliable[i] ? "?" : " ");
+		print_symbol("%s\n", e->addr[i]);
  	}
  }

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index a50a311..0918819 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -62,17 +62,14 @@ static bool fail_stacktrace(struct fault_attr *attr)
  	struct stack_trace trace;
  	int depth = attr->stacktrace_depth;
  	unsigned long entries[MAX_STACK_TRACE_DEPTH];
+	bool entries_reliable[MAX_STACK_TRACE_DEPTH];
  	int n;
  	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);

  	if (depth == 0)
  		return found;

-	trace.nr_entries = 0;
-	trace.entries = entries;
-	trace.max_entries = depth;
-	trace.skip = 1;
-
+	init_stack_trace(&trace, depth, 1, entries, entries_reliable);
  	save_stack_trace(&trace);
  	for (n = 0; n < trace.nr_entries; n++) {
  		if (attr->reject_start <= entries[n] &&
-- 
1.5.3.8

