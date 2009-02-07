Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZBGXVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZBGXVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZBGXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:21:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:21589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbZBGXVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=Ro4Qymp4NQDk0dOeisYN6xvuRqNN9MlN+quIDxS4rIo0RtKtvi68wh+4qVS1lKSXTp
         hce64+nnVGFtS2KfE6E/zr0hr5vZ7ataqhRxDP4zoiaRftzLO8zCruJRLq3ESicuKfNy
         wOcovf5K3IJrS07egE++oL8ODfwy+3+QdjMuw=
Message-ID: <498e1762.1358560a.0f3f.ffffa0a7@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 7 Feb 2009 22:16:12 +0100
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 3/5] tracing/power: move the power trace headers to a dedicated file
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Move the power tracer headers to trace/power.h to keep ftrace.h and power bits
more easy to maintain as separated topics.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 arch/x86/kernel/process.c                  |    2 +-
 include/linux/ftrace.h                     |   30 ------------------------
 include/trace/power.h                      |   35 ++++++++++++++++++++++++++++
 kernel/trace/trace.h                       |    1 +
 kernel/trace/trace_power.c                 |    2 +-
 6 files changed, 39 insertions(+), 33 deletions(-)
 create mode 100644 include/trace/power.h

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4b1c319..7ed925e 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,7 +33,7 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
-#include <linux/ftrace.h>
+#include <trace/power.h>
 
 #include <linux/acpi.h>
 #include <acpi/processor.h>
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 19d6336..8603066 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -8,7 +8,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
-#include <linux/ftrace.h>
+#include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7840e71..b05c9eb 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -339,36 +339,6 @@ ftrace_init_module(struct module *mod,
 		   unsigned long *start, unsigned long *end) { }
 #endif
 
-enum {
-	POWER_NONE = 0,
-	POWER_CSTATE = 1,
-	POWER_PSTATE = 2,
-};
-
-struct power_trace {
-#ifdef CONFIG_POWER_TRACER
-	ktime_t			stamp;
-	ktime_t			end;
-	int			type;
-	int			state;
-#endif
-};
-
-#ifdef CONFIG_POWER_TRACER
-extern void trace_power_start(struct power_trace *it, unsigned int type,
-					unsigned int state);
-extern void trace_power_mark(struct power_trace *it, unsigned int type,
-					unsigned int state);
-extern void trace_power_end(struct power_trace *it);
-#else
-static inline void trace_power_start(struct power_trace *it, unsigned int type,
-					unsigned int state) { }
-static inline void trace_power_mark(struct power_trace *it, unsigned int type,
-					unsigned int state) { }
-static inline void trace_power_end(struct power_trace *it) { }
-#endif
-
-
 /*
  * Structure that defines an entry function trace.
  */
diff --git a/include/trace/power.h b/include/trace/power.h
new file mode 100644
index 0000000..c7cefbc
--- /dev/null
+++ b/include/trace/power.h
@@ -0,0 +1,35 @@
+#ifndef _TRACE_POWER_H
+#define _TRACE_POWER_H
+
+#include <linux/ktime.h>
+
+enum {
+	POWER_NONE = 0,
+	POWER_CSTATE = 1,
+	POWER_PSTATE = 2,
+};
+
+struct power_trace {
+#ifdef CONFIG_POWER_TRACER
+	ktime_t			stamp;
+	ktime_t			end;
+	int			type;
+	int			state;
+#endif
+};
+
+#ifdef CONFIG_POWER_TRACER
+extern void trace_power_start(struct power_trace *it, unsigned int type,
+					unsigned int state);
+extern void trace_power_mark(struct power_trace *it, unsigned int type,
+					unsigned int state);
+extern void trace_power_end(struct power_trace *it);
+#else
+static inline void trace_power_start(struct power_trace *it, unsigned int type,
+					unsigned int state) { }
+static inline void trace_power_mark(struct power_trace *it, unsigned int type,
+					unsigned int state) { }
+static inline void trace_power_end(struct power_trace *it) { }
+#endif
+
+#endif /* _TRACE_POWER_H */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cb8a84b..95dff7d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -10,6 +10,7 @@
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <trace/kmemtrace.h>
+#include <trace/power.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index bfc21f8..b1d0d08 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -11,7 +11,7 @@
 
 #include <linux/init.h>
 #include <linux/debugfs.h>
-#include <linux/ftrace.h>
+#include <trace/power.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 
-- 
1.6.1


