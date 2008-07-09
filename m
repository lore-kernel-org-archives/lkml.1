Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYGIPEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYGIPEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbYGIPCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:02:55 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41113 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbYGIPCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:02:50 -0400
Message-Id: <20080709150044.013771224@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 02/15] Tracepoints Documentation
Content-Disposition: inline; filename=tracepoints-documentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of tracepoint usage.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 Documentation/tracepoints.txt |  101 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

Index: linux-2.6-lttng/Documentation/tracepoints.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/Documentation/tracepoints.txt	2008-07-07 09:55:13.000000000 -0400
@@ -0,0 +1,101 @@
+ 	             Using the Linux Kernel Tracepoints
+
+			    Mathieu Desnoyers
+
+
+This document introduces Linux Kernel Tracepoints and their use. It provides
+examples of how to insert tracepoints in the kernel and connect probe functions
+to them and provides some examples of probe functions.
+
+
+* Purpose of tracepoints
+
+A tracepoint placed in code provides a hook to call a function (probe) that you
+can provide at runtime. A tracepoint can be "on" (a probe is connected to it) or
+"off" (no probe is attached). When a tracepoint is "off" it has no effect,
+except for adding a tiny time penalty (checking a condition for a branch) and
+space penalty (adding a few bytes for the function call at the end of the
+instrumented function and adds a data structure in a separate section).  When a
+tracepoint is "on", the function you provide is called each time the tracepoint
+is executed, in the execution context of the caller. When the function provided
+ends its execution, it returns to the caller (continuing from the tracepoint
+site).
+
+You can put tracepoints at important locations in the code. They are
+lightweight hooks that can pass an arbitrary number of parameters,
+which prototypes are described in a tracepoint declaration placed in a header
+file.
+
+They can be used for tracing and performance accounting.
+
+
+* Usage
+
+Two elements are required for tracepoints :
+
+- A tracepoint definition, placed in a header file.
+- The tracepoint statement, in C code.
+
+In order to use tracepoints, you should include linux/tracepoint.h.
+
+In subsys/subsys-trace.h :
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(subsys_eventname,
+	TPPTOTO(int firstarg, struct task_struct *p),
+	TPARGS(firstarg, p));
+
+In subsys/file.c (where the tracing statement must be added) :
+
+#include "subsys-trace.h"
+
+void somefct(void)
+{
+	...
+	trace_subsys_eventname(arg, task);
+	...
+}
+
+Where :
+- subsys_eventname is an identifier unique to your event
+    - subsys is the name of your subsystem.
+    - eventname is the name of the event to trace.
+- TPPTOTO(int firstarg, struct task_struct *p) is the prototype of the function
+  called by this tracepoint.
+- TPARGS(firstarg, p) are the parameters names, same as found in the prototype.
+
+Connecting a function (probe) to a tracepoint is done by providing a probe
+(function to call) for the specific tracepoint through
+register_trace_subsys_eventname().  Removing a probe is done through
+unregister_trace_subsys_eventname(); it will remove the probe sure there is no
+caller left using the probe when it returns. Probe removal is preempt-safe
+because preemption is disabled around the probe call. See the "Probe example"
+section below for a sample probe module.
+
+The tracepoint mechanism supports inserting multiple instances of the same
+tracepoint, but a single definition must be made of a given tracepoint name over
+all the kernel to make sure no type conflict will occur. Name mangling of the
+tracepoints is done using the prototypes to make sure typing is correct.
+Verification of probe type correctness is done at the registration site by the
+compiler. Tracepoints can be put in inline functions, inlined static functions,
+and unrolled loops as well as regular functions.
+
+The naming scheme "subsys_event" is suggested here as a convention intended
+to limit collisions. Tracepoint names are global to the kernel: they are
+considered as being the same whether they are in the core kernel image or in
+modules.
+
+
+* Probe / tracepoint example
+
+See the example provided in samples/tracepoints/src
+
+Compile them with your kernel.
+
+Run, as root :
+modprobe tracepoint-example (insmod order is not important)
+modprobe tracepoint-probe-example
+cat /proc/tracepoint-example (returns an expected error)
+rmmod tracepoint-example tracepoint-probe-example
+dmesg

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
