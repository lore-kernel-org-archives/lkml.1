Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZLSA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZLSA2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZLSA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:26:58 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40059 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZLSA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:26:00 -0500
Message-Id: <20091218222655.192407545@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:31 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 14/16] x86 percpu xchg operation
Content-Disposition: inline; filename=percpu_add_xchg_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xchg on x86 implies LOCK semantics and therefore is slow. Approximate it
using this_cpu_cmpxchg().

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2009-12-18 15:49:09.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2009-12-18 15:50:12.000000000 -0600
@@ -156,6 +156,15 @@ do {							\
 	}						\
 })
 
+#define this_cpu_xchg_x86(var, new)						\
+({	__typeof(*var) __tmp_var,__tmp_old;				\
+	do {								\
+		__tmp_old = __this_cpu_read(var);			\
+		__tmp_var = __this_cpu_cmpxchg(var, __tmp_old, new);	\
+	} while (__tmp_var != __tmp_old);				\
+	__tmp_old;							\
+})
+
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
@@ -204,6 +213,9 @@ do {							\
 #define __this_cpu_cmpxchg_1(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
 #define __this_cpu_cmpxchg_2(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
 #define __this_cpu_cmpxchg_4(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
+#define __this_cpu_xchg_1(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define __this_cpu_xchg_2(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define __this_cpu_xchg_4(pcp, new)	this_cpu_xchg_x86((pcp), new)
 
 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -232,6 +244,9 @@ do {							\
 #define this_cpu_cmpxchg_1(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 #define this_cpu_cmpxchg_2(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 #define this_cpu_cmpxchg_4(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define this_cpu_xchg_1(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define this_cpu_xchg_2(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define this_cpu_xchg_4(pcp, new)	this_cpu_xchg_x86((pcp), new)
 
 #define irqsafe_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
 #define irqsafe_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
@@ -254,6 +269,9 @@ do {							\
 #define irqsafe_cpu_cmpxchg_1(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 #define irqsafe_cpu_cmpxchg_2(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
 #define irqsafe_cpu_cmpxchg_4(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define irqsafe_cpu_xchg_1(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define irqsafe_cpu_xchg_2(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define irqsafe_cpu_xchg_4(pcp, new)	this_cpu_xchg_x86((pcp), new)
 
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.
@@ -269,6 +287,7 @@ do {							\
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define __this_cpu_cmpxchg_8(pcp, old,new)	cmpxchg_local(__this_cpu_ptr(pcp), old, new)
+#define __this_cpu_xchg_8(pcp, new)	this_cpu_xchg_x86((pcp), new)
 
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
@@ -279,6 +298,7 @@ do {							\
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_cmpxchg_8(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define this_cpu_xchg_8(pcp, new)	this_cpu_xchg_x86((pcp), new)
 
 #define irqsafe_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
 #define irqsafe_cpu_inc_8(pcp)		percpu_var_op("inc", (pcp))
@@ -287,6 +307,7 @@ do {							\
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define irqsafe_cpu_cmpxchg_8(pcp, old,new)	cmpxchg_local(this_cpu_ptr(pcp), old, new)
+#define irqsafe_cpu_xchg_8(pcp, new)	this_cpu_xchg_x86((pcp), new)
 
 #endif
 

-- 
