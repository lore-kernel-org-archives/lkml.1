Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZJAXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZJAXDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbZJAXDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:03:17 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35723 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbZJAXDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:03:17 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 5
	times
Message-Id: <20091001212557.963565363@gentwo.org>
References: <20091001212521.123389189@gentwo.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Oct 2009 17:25:23 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V4 02/20] this_cpu: X86 optimized this_cpu operations
Content-Disposition: inline; filename=this_cpu_x86_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically the existing percpu ops can be used for this_cpu variants that allow
operations also on dynamically allocated percpu data. However, we do not pass a
reference to a percpu variable in. Instead a dynamically or statically
allocated percpu variable is provided.

Preempt, the non preempt and the irqsafe operations generate the same code.
It will always be possible to have the requires per cpu atomicness in a single
RMW instruction with segment override on x86.

64 bit this_cpu operations are not supported on 32 bit.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/percpu.h |   78 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2009-10-01 09:08:37.000000000 -0500
+++ linux-2.6/arch/x86/include/asm/percpu.h	2009-10-01 09:29:43.000000000 -0500
@@ -153,6 +153,84 @@ do {							\
 #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
 #define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
 
+#define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define __this_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+
+#define __this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define __this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define __this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define __this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
+#define __this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
+#define __this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
+#define __this_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
+#define __this_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
+#define __this_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
+#define __this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define __this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define __this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+#define this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_read_4(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
+#define this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
+#define this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
+#define this_cpu_or_1(pcp, val)		percpu_to_op("or", (pcp), val)
+#define this_cpu_or_2(pcp, val)		percpu_to_op("or", (pcp), val)
+#define this_cpu_or_4(pcp, val)		percpu_to_op("or", (pcp), val)
+#define this_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+#define irqsafe_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
+#define irqsafe_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
+#define irqsafe_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
+#define irqsafe_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
+#define irqsafe_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
+#define irqsafe_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
+#define irqsafe_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
+#define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+/*
+ * Per cpu atomic 64 bit operations are only available under 64 bit.
+ * 32 bit must fall back to generic operations.
+ */
+#ifdef CONFIG_X86_64
+#define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define __this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
+#define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
+#define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+#define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
+#define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
+#define this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
+#define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
+#define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+#define irqsafe_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
+#define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
+#define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
+
+#endif
+
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define x86_test_and_clear_bit_percpu(bit, var)				\
 ({									\

-- 
