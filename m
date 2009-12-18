Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZLSA1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZLSA1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZLSA0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:26:55 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40051 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbZLSAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:25:59 -0500
Message-Id: <20091218222652.997676106@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:27 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 10/16] Support generating inc/dec for this_cpu_inc/dec
Content-Disposition: inline; filename=percpu_add_inc_dec_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support generating inc/dec instruction. Currently we create an
add 1 instruction. Saves one byte per use of this_cpu_xx.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |   47 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2009-12-18 12:45:31.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2009-12-18 14:22:40.000000000 -0600
@@ -133,6 +133,29 @@ do {							\
 	pfo_ret__;					\
 })
 
+#define percpu_var_op(op, var)				\
+({							\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_arg(0)		\
+		    : "+m" (var) :);			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_arg(0)		\
+		    : "+m" (var) :);			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_arg(0)		\
+		    : "+m" (var) :);			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(0)		\
+		    : "+m" (var) :);			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+})
+
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
@@ -163,6 +186,12 @@ do {							\
 #define __this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
 #define __this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
 #define __this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_inc_1(pcp)		percpu_var_op("inc", (pcp))
+#define __this_cpu_inc_2(pcp)		percpu_var_op("inc", (pcp))
+#define __this_cpu_inc_4(pcp)		percpu_var_op("inc", (pcp))
+#define __this_cpu_dec_1(pcp)		percpu_var_op("dec", (pcp))
+#define __this_cpu_dec_2(pcp)		percpu_var_op("dec", (pcp))
+#define __this_cpu_dec_4(pcp)		percpu_var_op("dec", (pcp))
 #define __this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -182,6 +211,12 @@ do {							\
 #define this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
 #define this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
 #define this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_inc_1(pcp)		percpu_var_op("inc", (pcp))
+#define this_cpu_inc_2(pcp)		percpu_var_op("inc", (pcp))
+#define this_cpu_inc_4(pcp)		percpu_var_op("inc", (pcp))
+#define this_cpu_dec_1(pcp)		percpu_var_op("dec", (pcp))
+#define this_cpu_dec_2(pcp)		percpu_var_op("dec", (pcp))
+#define this_cpu_dec_4(pcp)		percpu_var_op("dec", (pcp))
 #define this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -195,6 +230,12 @@ do {							\
 #define irqsafe_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
 #define irqsafe_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
 #define irqsafe_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_inc_1(pcp)		percpu_var_op("inc", (pcp))
+#define irqsafe_cpu_inc_2(pcp)		percpu_var_op("inc", (pcp))
+#define irqsafe_cpu_inc_4(pcp)		percpu_var_op("inc", (pcp))
+#define irqsafe_cpu_dec_1(pcp)		percpu_var_op("dec", (pcp))
+#define irqsafe_cpu_dec_2(pcp)		percpu_var_op("dec", (pcp))
+#define irqsafe_cpu_dec_4(pcp)		percpu_var_op("dec", (pcp))
 #define irqsafe_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -213,6 +254,8 @@ do {							\
 #define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define __this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_inc_8(pcp)		percpu_var_op("inc", (pcp))
+#define __this_cpu_dec_8(pcp)		percpu_var_op("dec", (pcp))
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
@@ -220,11 +263,15 @@ do {							\
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_inc_8(pcp)		percpu_var_op("inc", (pcp))
+#define this_cpu_dec_8(pcp)		percpu_var_op("dec", (pcp))
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
 #define irqsafe_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_inc_8(pcp)		percpu_var_op("inc", (pcp))
+#define irqsafe_cpu_dec_8(pcp)		percpu_var_op("dec", (pcp))
 #define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)

-- 
