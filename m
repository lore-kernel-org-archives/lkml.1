Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZLSA1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZLSA1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZLSA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:27:00 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40055 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbZLSAZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:25:59 -0500
Message-Id: <20091218222652.446462888@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:26 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 09/16] Allow arch to provide inc/dec functionality for each size separately
Content-Disposition: inline; filename=percpu_add_inc_dec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current this_cpu ops only allow an arch to specify add RMW operations or inc
and dec for all sizes. Some arches can do more efficient inc and dec
operations. Allow size specific override of fallback functions like with
the other operations.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/percpu.h |   96 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 90 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2009-12-18 13:34:13.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2009-12-18 14:19:25.000000000 -0600
@@ -257,6 +257,18 @@ do {									\
 	}								\
 } while (0)
 
+#define __pcpu_size_call_noparam(stem, variable)			\
+do {									\
+	switch(sizeof(variable)) {					\
+		case 1: stem##1(variable);break;			\
+		case 2: stem##2(variable);break;			\
+		case 4: stem##4(variable);break;			\
+		case 8: stem##8(variable);break;			\
+		default: 						\
+			__bad_size_call_parameter();break;		\
+	}								\
+} while (0)
+
 /*
  * Optimized manipulation for memory allocated through the per cpu
  * allocator or for addresses of per cpu variables (can be determined
@@ -352,11 +364,35 @@ do {									\
 #endif
 
 #ifndef this_cpu_inc
-# define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
+# ifndef this_cpu_inc_1
+#  define this_cpu_inc_1(pcp)	__this_cpu_add((pcp), 1)
+# endif
+# ifndef this_cpu_inc_2
+#  define this_cpu_inc_2(pcp)	__this_cpu_add((pcp), 1)
+# endif
+# ifndef this_cpu_inc_4
+#  define this_cpu_inc_4(pcp)	__this_cpu_add((pcp), 1)
+# endif
+# ifndef this_cpu_inc_8
+#  define this_cpu_inc_8(pcp)	__this_cpu_add((pcp), 1)
+# endif
+# define this_cpu_inc(pcp)		__pcpu_size_call_noparam(this_cpu_inc_, (pcp))
 #endif
 
 #ifndef this_cpu_dec
-# define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
+# ifndef this_cpu_dec_1
+#  define this_cpu_dec_1(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# ifndef this_cpu_dec_2
+#  define this_cpu_dec_2(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# ifndef this_cpu_dec_4
+#  define this_cpu_dec_4(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# ifndef this_cpu_dec_8
+#  define this_cpu_dec_8(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# define this_cpu_dec(pcp)		__pcpu_size_call_noparam(this_cpu_dec_, (pcp))
 #endif
 
 #ifndef this_cpu_and
@@ -479,11 +515,35 @@ do {									\
 #endif
 
 #ifndef __this_cpu_inc
-# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
+# ifndef __this_cpu_inc_1
+#  define __this_cpu_inc_1(pcp)	__this_cpu_add_1((pcp), 1)
+# endif
+# ifndef __this_cpu_inc_2
+#  define __this_cpu_inc_2(pcp)	__this_cpu_add_2((pcp), 1)
+# endif
+# ifndef __this_cpu_inc_4
+#  define __this_cpu_inc_4(pcp)	__this_cpu_add_4((pcp), 1)
+# endif
+# ifndef __this_cpu_inc_8
+#  define __this_cpu_inc_8(pcp)	__this_cpu_add_8((pcp), 1)
+# endif
+# define __this_cpu_inc(pcp)	__pcpu_size_call_noparam(__this_cpu_inc_, (pcp))
 #endif
 
 #ifndef __this_cpu_dec
-# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
+# ifndef __this_cpu_dec_1
+#  define __this_cpu_dec_1(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# ifndef __this_cpu_dec_2
+#  define __this_cpu_dec_2(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# ifndef __this_cpu_dec_4
+#  define __this_cpu_dec_4(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# ifndef __this_cpu_dec_8
+#  define __this_cpu_dec_8(pcp)	__this_cpu_sub((pcp), 1)
+# endif
+# define __this_cpu_dec(pcp)	__pcpu_size_call_noparam(__this_cpu_dec_, (pcp))
 #endif
 
 #ifndef __this_cpu_and
@@ -570,11 +630,35 @@ do {									\
 #endif
 
 #ifndef irqsafe_cpu_inc
-# define irqsafe_cpu_inc(pcp)	irqsafe_cpu_add((pcp), 1)
+# ifndef irqsafe_cpu_inc_1
+#  define irqsafe_cpu_inc_1(pcp)	irqsafe_cpu_add_1((pcp), 1)
+# endif
+# ifndef irqsafe_cpu_inc_2
+#  define irqsafe_cpu_inc_2(pcp)	irqsafe_cpu_add_2((pcp), 1)
+# endif
+# ifndef irqsafe_cpu_inc_4
+#  define irqsafe_cpu_inc_4(pcp)	irqsafe_cpu_add_4((pcp), 1)
+# endif
+# ifndef irqsafe_cpu_inc_8
+#  define irqsafe_cpu_inc_8(pcp)	irqsafe_cpu_add_8((pcp), 1)
+# endif
+# define irqsafe_cpu_inc(pcp)	__pcpu_size_call_noparam(irqsafe_cpu_inc_, (pcp))
 #endif
 
 #ifndef irqsafe_cpu_dec
-# define irqsafe_cpu_dec(pcp)	irqsafe_cpu_sub((pcp), 1)
+# ifndef irqsafe_cpu_dec_1
+#  define irqsafe_cpu_dec_1(pcp)	irqsafe_cpu_sub_1((pcp), 1)
+# endif
+# ifndef irqsafe_cpu_dec_2
+#  define irqsafe_cpu_dec_2(pcp)	irqsafe_cpu_sub_2((pcp), 1)
+# endif
+# ifndef irqsafe_cpu_dec_4
+#  define irqsafe_cpu_dec_4(pcp)	irqsafe_cpu_sub_4((pcp), 1)
+# endif
+# ifndef irqsafe_cpu_dec_8
+#  define irqsafe_cpu_dec_8(pcp)	irqsafe_cpu_sub_8((pcp), 1)
+# endif
+# define irqsafe_cpu_dec(pcp)	__pcpu_size_call_noparam(irqsafe_cpu_dec_, (pcp))
 #endif
 
 #ifndef irqsafe_cpu_and

-- 
