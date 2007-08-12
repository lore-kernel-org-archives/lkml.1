Return-Path: <linux-kernel-owner+w=401wt.eu-S935699AbXHLPhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935699AbXHLPhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761537AbXHLPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:37:06 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50179 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763257AbXHLPhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:37:04 -0400
Message-Id: <20070812150816.517238007@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 7/8] Immediate Values - Documentation
Content-Disposition: inline; filename=immediate-values-documentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:36:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/immediate.txt |  180 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 180 insertions(+)

Index: linux-2.6-lttng/Documentation/immediate.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/Documentation/immediate.txt	2007-07-13 20:39:51.000000000 -0400
@@ -0,0 +1,180 @@
+		        Using the Immediate Values
+
+			    Mathieu Desnoyers
+
+
+This document introduces Immediate Values and their use.
+
+* Purpose of immediate values
+
+An immediate value is used to compile into the kernel variables that sits within
+the instruction stream. They are meant to be rarely updated but read often.
+Using immediate values for these variables will save cache lines.
+
+This infrastructure is specialized in supporting dynamic patching of the values
+in the instruction stream when multiple CPUs are running without disturbing the
+normal system behavior.
+
+Compiling code meant to be rarely enabled at runtime can be done using
+immediate_if() as condition surrounding the code.
+
+* Usage
+
+In order to use the macro immediate, you should include linux/immediate.h.
+
+#include <linux/immediate.h>
+
+immediate_char_t this_immediate;
+EXPORT_SYMBOL(this_immediate);
+
+
+Add, in your code :
+
+Use immediate_set(&this_immediate) to set the immediate value.
+
+Use immediate_read(&this_immediate) to read the immediate value.
+
+The immediate mechanism supports inserting multiple instances of the same
+immediate. Immediate values can be put in inline functions, inlined static
+functions, and unrolled loops.
+
+If you have to read the immediate values from a function declared as __init or
+__exit, you should explicitly use _immediate_read(), which will fall back on a
+global variable read. Failing to do so will leave a reference to the __init
+section after it is freed (it would generate a modpost warning).
+
+The prefered idiom to dynamically enable compiled-in code is to use
+immediate_if (&this_immediate), which may eventually use gcc improvements to
+provide a jump instruction patching based condition instead of a immediate value
+feeding a conditional jump. You should use _immediate_if () instead of
+immediate_if () in functions marked __init or __exit.
+
+immediate_set_early() should be used only at early kernel boot time, before SMP
+is activated.
+
+If you need to declare your own immediate types (for instance, a pointer to
+struct task_struct), use:
+
+DEFINE_IMMEDIATE_TYPE(struct task_struct*, immediate_task_struct_ptr_t);
+
+and declare your variable with:
+immediate_task_struct_ptr_t myptr;
+
+You can choose to set an initial static value to the immediate by using, for
+instance:
+
+immediate_task_struct_ptr_t myptr = IMMEDIATE_INIT(10);
+
+
+* Optimization for a given architecture
+
+One can implement optimized immediate values for a given architecture by
+replacing asm-$ARCH/immediate.h.
+
+* Performance improvement
+
+* Memory hit for a data-based branch
+
+Here are the results on a 3GHz Pentium 4:
+
+number of tests : 100
+number of branches per test : 100000
+memory hit cycles per iteration (mean) : 636.611
+L1 cache hit cycles per iteration (mean) : 89.6413
+instruction stream based test, cycles per iteration (mean) : 85.3438
+Just getting the pointer from a modulo on a pseudo-random value, doing
+  noting with it, cycles per iteration (mean) : 77.5044
+
+So:
+Base case:                      77.50 cycles
+instruction stream based test:  +7.8394 cycles
+L1 cache hit based test:        +12.1369 cycles
+Memory load based test:         +559.1066 cycles
+
+So let's say we have a ping flood coming at
+(14014 packets transmitted, 14014 received, 0% packet loss, time 1826ms)
+7674 packets per second. If we put 2 markers for irq entry/exit, it
+brings us to 15348 markers sites executed per second.
+
+(15348 exec/s) * (559 cycles/exec) / (3G cycles/s) = 0.0029
+We therefore have a 0.29% slowdown just on this case.
+
+Compared to this, the instruction stream based test will cause a
+slowdown of:
+
+(15348 exec/s) * (7.84 cycles/exec) / (3G cycles/s) = 0.00004
+For a 0.004% slowdown.
+
+If we plan to use this for memory allocation, spinlock, and all sort of
+very high event rate tracing, we can assume it will execute 10 to 100
+times more sites per second, which brings us to 0.4% slowdown with the
+instruction stream based test compared to 29% slowdown with the memory
+load based test on a system with high memory pressure.
+
+
+
+* Markers impact under heavy memory load
+
+Running a kernel with my LTTng instrumentation set, in a test that
+generates memory pressure (from userspace) by trashing L1 and L2 caches
+between calls to getppid() (note: syscall_trace is active and calls
+a marker upon syscall entry and syscall exit; markers are disarmed).
+This test is done in user-space, so there are some delays due to IRQs
+coming and to the scheduler. (UP 2.6.22-rc6-mm1 kernel, task with -20
+nice level)
+
+My first set of results : Linear cache trashing, turned out not to be
+very interesting, because it seems like the linearity of the memset on a
+full array is somehow detected and it does not "really" trash the
+caches.
+
+Now the most interesting result : Random walk L1 and L2 trashing
+surrounding a getppid() call.
+
+- Markers compiled out (but syscall_trace execution forced)
+number of tests : 10000
+No memory pressure
+Reading timestamps takes 108.033 cycles
+getppid : 1681.4 cycles
+With memory pressure
+Reading timestamps takes 102.938 cycles
+getppid : 15691.6 cycles
+
+
+- With the immediate values based markers:
+number of tests : 10000
+No memory pressure
+Reading timestamps takes 108.006 cycles
+getppid : 1681.84 cycles
+With memory pressure
+Reading timestamps takes 100.291 cycles
+getppid : 11793 cycles
+
+
+- With global variables based markers:
+number of tests : 10000
+No memory pressure
+Reading timestamps takes 107.999 cycles
+getppid : 1669.06 cycles
+With memory pressure
+Reading timestamps takes 102.839 cycles
+getppid : 12535 cycles
+
+
+The result is quite interesting in that the kernel is slower without
+markers than with markers. I explain it by the fact that the data
+accessed is not layed out in the same manner in the cache lines when the
+markers are compiled in or out. It seems that it aligns the function's
+data better to compile-in the markers in this case.
+
+But since the interesting comparison is between the immediate values and
+global variables based markers, and because they share the same memory
+layout, except for the movl being replaced by a movz, we see that the
+global variable based markers (2 markers) adds 742 cycles to each system
+call (syscall entry and exit are traced and memory locations for both
+global variables lie on the same cache line).
+
+Therefore, not only is it interesting to use the immediate values to
+dynamically activate dormant code such as the markers, but I think it
+should also be considered as a replacement for many of the "read mostly"
+static variables.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
