Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYE3ELZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYE3ELZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYE3EBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40567 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753418AbYE3EA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:26 -0400
Message-Id: <20080530040024.610015676@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:57:01 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 41/41] x86_64: Support for cpu ops
Content-Disposition: inline; filename=cpu_alloc_ops_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support fast cpu ops in x86_64 by providing a series of functions that
generate the proper instructions.

Define CONFIG_HAVE_CPU_OPS so that core code
can exploit the availability of fast per cpu operations.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig         |    4 ++++
 include/asm-x86/percpu.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2008-05-29 18:05:08.514214613 -0700
+++ linux-2.6/arch/x86/Kconfig	2008-05-29 18:09:55.889464792 -0700
@@ -168,6 +168,10 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+config HAVE_CPU_OPS
+	bool
+	default y
+
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
Index: linux-2.6/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu.h	2008-05-29 18:08:28.513214585 -0700
+++ linux-2.6/include/asm-x86/percpu.h	2008-05-29 18:09:55.889464792 -0700
@@ -196,5 +196,36 @@ do {							\
 #define x86_cmpxchg_percpu(var, old, new) \
 				percpu_cmpxchg_op(per_cpu_var(var), old, new)
 
+#define CPU_READ(obj)		percpu_from_op("mov", obj)
+#define CPU_WRITE(obj, val)	percpu_to_op("mov", obj, val)
+#define CPU_ADD(obj, val)	percpu_to_op("add", obj, val)
+#define CPU_SUB(obj, val)	percpu_to_op("sub", obj, val)
+#define CPU_INC(obj)		percpu_addr_op("inc", obj)
+#define CPU_DEC(obj)		percpu_addr_op("dec", obj)
+#define CPU_XCHG(obj, val)	percpu_to_op("xchg", var, val)
+#define CPU_CMPXCHG(obj, old, new) percpu_cmpxchg_op(var, old, new)
+
+/*
+ * All cpu operations are interrupt safe and do not need to disable
+ * preempt. So the other variants all reduce to the same instruction.
+ */
+#define _CPU_READ CPU_READ
+#define _CPU_WRITE CPU_WRITE
+#define _CPU_ADD CPU_ADD
+#define _CPU_SUB CPU_SUB
+#define _CPU_INC CPU_INC
+#define _CPU_DEC CPU_DEC
+#define _CPU_XCHG CPU_XCHG
+#define _CPU_CMPXCHG CPU_CMPXCHG
+
+#define __CPU_READ CPU_READ
+#define __CPU_WRITE CPU_WRITE
+#define __CPU_ADD CPU_ADD
+#define __CPU_SUB CPU_SUB
+#define __CPU_INC CPU_INC
+#define __CPU_DEC CPU_DEC
+#define __CPU_XCHG CPU_XCHG
+#define __CPU_CMPXCHG CPU_CMPXCHG
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_PERCPU_H_ */

-- 
