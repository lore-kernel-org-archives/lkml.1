Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286Ab0ADWhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0ADWhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702Ab0ADWhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:37:08 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46089 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0ADWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:37:04 -0500
Message-Id: <20100104223556.090044300@quilx.com>
References: <20100104223439.228028923@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 16:34:43 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V9 4/7] Generic inc / dec percpu instructions
Content-Disposition: inline; filename=x86_inc_dec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize code generated for percpu access by checking for increment and
decrements.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |  100 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 86 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-01-04 15:33:02.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-01-04 16:11:29.000000000 -0600
@@ -104,6 +104,78 @@ do {							\
 	}						\
 } while (0)
 
+/*
+ * Generate a percpu add to memory instruction and optimize code
+ * if a one is added or subtracted.
+ */
+#define percpu_add_op(var, val)				\
+do {							\
+	typedef typeof(var) pto_T__;			\
+	if (0) {					\
+		pto_T__ pto_tmp__;			\
+		pto_tmp__ = (val);			\
+	}						\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		if (__builtin_constant_p(val) == 1)	\
+		  asm("incb "__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : );				\
+		else if (__builtin_constant_p(val) == -1) \
+		  asm("decb "__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : );				\
+		else					\
+		  asm("addb %1,"__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : "qi" ((pto_T__)(val)));		\
+		break;					\
+	case 2:						\
+		if (__builtin_constant_p(val) == 1)	\
+		  asm("incw "__percpu_arg(0)	\
+		    : "+m" (var)			\
+		    : );				\
+		else if (__builtin_constant_p(val) == -1) \
+		  asm("decw "__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : );				\
+		else					\
+		asm("addw %1,"__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : "ri" ((pto_T__)(val)));		\
+		break;					\
+	case 4:						\
+		if (__builtin_constant_p(val) == 1)	\
+		  asm("incl "__percpu_arg(0)	\
+		    : "+m" (var)			\
+		    : );				\
+		else if (__builtin_constant_p(val) == -1) \
+		  asm("decl "__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : );				\
+		else					\
+		asm("addl %1,"__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : "ri" ((pto_T__)(val)));		\
+		break;					\
+	case 8:						\
+		if (__builtin_constant_p(val) == 1)	\
+		  asm("incq "__percpu_arg(0)	\
+		    : "+m" (var)			\
+		    : );				\
+		else if (__builtin_constant_p(val) == -1) \
+		  asm("decq "__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : );				\
+		else					\
+		asm("addq %1,"__percpu_arg(0)		\
+		    : "+m" (var)			\
+		    : "re" ((pto_T__)(val)));		\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+} while (0)
+
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -147,8 +219,8 @@ do {							\
 #define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
 					       "p" (&per_cpu__##var))
 #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
-#define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
-#define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
+#define percpu_add(var, val)	percpu_add_op(per_cpu__##var, val)
+#define percpu_sub(var, val)	percpu_add_op(per_cpu__##var, -(val))
 #define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
 #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
 #define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
@@ -160,9 +232,9 @@ do {							\
 #define __this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define __this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define __this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
-#define __this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
-#define __this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define __this_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define __this_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
 #define __this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -179,9 +251,9 @@ do {							\
 #define this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
-#define this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
-#define this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define this_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define this_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
 #define this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -192,9 +264,9 @@ do {							\
 #define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 
-#define irqsafe_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
-#define irqsafe_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
-#define irqsafe_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define irqsafe_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define irqsafe_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -212,19 +284,19 @@ do {							\
 #ifdef CONFIG_X86_64
 #define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
-#define irqsafe_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)

-- 
