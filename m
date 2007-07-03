Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbXGCQsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbXGCQsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbXGCQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45922 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761350AbXGCQpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:55 -0400
Message-Id: <20070703164515.766860636@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 08/10] Immediate Value - Documentation
Content-Disposition: inline; filename=immediate-values-documentation.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:45:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/immediate.txt |  103 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

Index: linux-2.6-lttng/Documentation/immediate.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/Documentation/immediate.txt	2007-06-15 16:14:05.000000000 -0400
@@ -0,0 +1,103 @@
+		        Using the Immediate Values
+
+			    Mathieu Desnoyers
+
+
+This document introduces Immediate Values and their use.
+
+* Purpose of immediate values
+
+An immediate value is used to compile into the kernel a branch that is disabled
+at compile-time that has almost no measurable performance impact on the kernel.
+Then, at runtime, it can be enabled dynamically.
+
+It can be used to compile code in the kernel that is seldomly meant to be
+dynamically activated. It's the case of CPU specific workarounds, profiling,
+tracing, etc.
+
+This infrastructure is specialized in supporting dynamic patching of the values
+in the instruction stream when multiple CPUs are running without disturbing the
+normal system behavior.
+
+
+* Usage
+
+In order to use the macro immediate, you should include linux/immediate.h.
+
+#include <linux/immediate.h>
+
+immediate_t __read_mostly this_immediate;
+EXPORT_SYMBOL(this_immediate);
+
+
+Add, in your code :
+
+if (unlikely(immediate(this_immediate))) {
+	some code...
+}
+
+And then, use:
+
+Use immediate_arm(&this_immediate) to activate the immediate value.
+
+Use immediate_disarm(&this_immediate) to deactivate the immediate value.
+
+Use immediate_query(&this_immediate) to query the immediate value state.
+
+The immediate mechanism supports inserting multiple instances of the same
+immediate. Immediate values can be put in inline functions, inlined static
+functions, and unrolled loops.
+
+
+* Optimization for a given architecture
+
+One can implement optimized immediate values for a given architecture by
+replacing asm-$ARCH/immediate.h.
+
+The IF_* flags can be used to control the type of immediate value. See the
+include/linux/immediate.h header for the list of flags. They can be specified as
+the first parameter of the _immediate() macro, as in the following example,
+which uses flags to declare a immediate that always uses the generic version of
+the immediates. It can be useful to use this when immediates are placed in
+kernel code presenting particular reentrancy challenges.
+
+if (unlikely(_immediate(IF_DEFAULT & ~IF_OPTIMIZED, this_immediate))) {
+	some code...
+}
+
+
+* Performance improvement
+
+Result of a small test comparing:
+
+1 - Branch depending on a cache miss (has to fetch in memory, caused by a 128
+    bytes stride)). This is the test that is likely to look like what
+    side-effect the original profile_hit code was causing, under the
+    assumption that the kernel is already using L1 and L2 caches at
+    their full capacity and that a supplementary data load would cause
+    cache trashing.
+2 - Branch depending on L1 cache hit. Just for comparison.
+3 - Branch depending on a load immediate in the instruction stream.
+
+It has been compiled with gcc -O2. Tests done on a 3GHz P4.
+
+In the first test series, the branch is not taken:
+
+number of tests : 1000
+number of branches per test : 81920
+memory hit cycles per iteration (mean) : 48.252
+L1 cache hit cycles per iteration (mean) : 16.1693
+instruction stream based test, cycles per iteration (mean) : 16.0432
+
+
+In the second test series, the branch is taken and an integer is
+incremented within the block:
+
+number of tests : 1000
+number of branches per test : 81920
+memory hit cycles per iteration (mean) : 48.2691
+L1 cache hit cycles per iteration (mean) : 16.396
+instruction stream based test, cycles per iteration (mean) : 16.0441
+
+Therefore, the memory fetch based test seems to be 200% slower than the
+load immediate based test.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
