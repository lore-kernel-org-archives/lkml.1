Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZLSA2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZLSA2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZLSA05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:26:57 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40063 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZLSA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:26:00 -0500
Message-Id: <20091218222656.296956497@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:33 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 16/16] x86 support for this_cpu_add_return
Content-Disposition: inline; filename=percpu_add_add_return_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 had the xadd instruction that can be use to have a percpu atomic
increment and return instruction.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2009-12-18 15:55:07.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2009-12-18 16:06:33.000000000 -0600
@@ -165,6 +165,35 @@ do {							\
 	__tmp_old;							\
 })
 
+#define this_cpu_add_return_x86(var, val)		\
+({							\
+	typeof(var) pfo_ret__;				\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm("xaddb %0,"__percpu_arg(1)		\
+		    : "+r" (val), "+m" (var)		\
+		    : "qi" ((pto_T__)(val)));		\
+		break;					\
+	case 2:						\
+		asm("xaddw %0,"__percpu_arg(1)		\
+		    : "+r" (val), "+m" (var)		\
+		    : "=r" (pfo_ret__)			\
+		break;					\
+	case 4:						\
+		asm("xaddl %0,"__percpu_arg(1)		\
+		    : "+r" (val), "+m" (var)		\
+		    : "=r" (pfo_ret__)			\
+		break;					\
+	case 8:						\
+		asm("xaddq %0,"__percpu_arg(1)		\
+		    : "+r" (val), "+m" (var)		\
+		    : "re" ((pto_T__)(val)));		\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+	pfo_ret__;					\
+})
+
 /*
  * percpu_read() makes gcc load the percpu variable every time it is
  * accessed while percpu_read_stable() allows the value to be cached.
@@ -216,6 +245,9 @@ do {							\
 #define __this_cpu_xchg_1(pcp, new)	this_cpu_xchg_x86((pcp), new)
 #define __this_cpu_xchg_2(pcp, new)	this_cpu_xchg_x86((pcp), new)
 #define __this_cpu_xchg_4(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define __this_cpu_add_return_1(pcp, val)	this_cpu_add_return_x86((pcp), val)
+#define __this_cpu_add_return_2(pcp, val)	this_cpu_add_return_x86((pcp), val)
+#define __this_cpu_add_return_4(pcp, val)	this_cpu_add_return_x86((pcp), val)
 
 #define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -272,6 +304,9 @@ do {							\
 #define irqsafe_cpu_xchg_1(pcp, new)	this_cpu_xchg_x86((pcp), new)
 #define irqsafe_cpu_xchg_2(pcp, new)	this_cpu_xchg_x86((pcp), new)
 #define irqsafe_cpu_xchg_4(pcp, new)	this_cpu_xchg_x86((pcp), new)
+#define irqsafe_cpu_add_return_1(pcp, val)	this_cpu_add_return_x86((pcp), val)
+#define irqsafe_cpu_add_return_2(pcp, val)	this_cpu_add_return_x86((pcp), val)
+#define irqsafe_cpu_add_return_4(pcp, val)	this_cpu_add_return_x86((pcp), val)
 
 /*
  * Per cpu atomic 64 bit operations are only available under 64 bit.

-- 
