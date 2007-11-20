Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbXKTB10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbXKTB10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXKTBOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:20 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36874 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756280AbXKTBNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:42 -0500
Message-Id: <20071120011341.956653798@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:15 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 43/45] x86_64: Add a CPU_OR to support or_pda()
Content-Disposition: inline; filename=add_or
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of one of the leftover pda accessors and cut out some more of pda.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 include/asm-x86/pda.h       |   35 +----------------------------------
 include/asm-x86/percpu_64.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 34 deletions(-)

Index: linux-2.6/include/asm-x86/pda.h
===================================================================
--- linux-2.6.orig/include/asm-x86/pda.h	2007-11-19 16:24:13.569640223 -0800
+++ linux-2.6/include/asm-x86/pda.h	2007-11-19 16:24:33.001389877 -0800
@@ -40,12 +40,6 @@ extern struct x8664_pda *_cpu_pda[];
 
 #define cpu_pda(i) (_cpu_pda[i])
 
-/* 
- * There is no fast way to get the base address of the PDA, all the accesses
- * have to mention %fs/%gs.  So it needs to be done this Torvaldian way.
- */ 
-extern void __bad_pda_field(void) __attribute__((noreturn));
-
 /*
  * proxy_pda doesn't actually exist, but tell gcc it is accessed for
  * all PDA accesses so it gets read/write dependencies right.
@@ -54,38 +48,11 @@ extern struct x8664_pda _proxy_pda;
 
 #define pda_offset(field) offsetof(struct x8664_pda, field)
 
-#define pda_to_op(op,field,val) do {		\
-	typedef typeof(_proxy_pda.field) T__;	\
-	if (0) { T__ tmp__; tmp__ = (val); }	/* type checking */ \
-	switch (sizeof(_proxy_pda.field)) {	\
-	case 2:					\
-		asm(op "w %1,%%gs:%c2" : 	\
-		    "+m" (_proxy_pda.field) :	\
-		    "ri" ((T__)val),		\
-		    "i"(pda_offset(field))); 	\
- 		break;				\
-	case 4:					\
-		asm(op "l %1,%%gs:%c2" : 	\
-		    "+m" (_proxy_pda.field) :	\
-		    "ri" ((T__)val),		\
-		    "i" (pda_offset(field))); 	\
-		break;				\
-	case 8:					\
-		asm(op "q %1,%%gs:%c2": 	\
-		    "+m" (_proxy_pda.field) :	\
-		    "ri" ((T__)val),		\
-		    "i"(pda_offset(field))); 	\
-		break;				\
-       default: 				\
-		__bad_pda_field();		\
-       }					\
-       } while (0)
-
 #define read_pda(field) CPU_READ(per_cpu_var(pda).field)
 #define write_pda(field,val) CPU_WRITE(per_cpu_var(pda).field, val)
 #define add_pda(field,val) CPU_ADD(per_cpu_var(pda).field, val)
 #define sub_pda(field,val) CPU_ADD(per_cpu_var(pda).field, val)
-#define or_pda(field,val) pda_to_op("or",field,val)
+#define or_pda(field,val) CPU_OR(per_cpu_var(pda).field, val)
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define test_and_clear_bit_pda(bit,field) ({		\
Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-19 16:17:46.854889825 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-19 16:24:33.001389877 -0800
@@ -305,12 +305,40 @@ static inline unsigned long __cmpxchg_lo
 	((__typeof__(obj))__cmpxchg_local_gs(&(obj),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(obj)))
 
+static inline void __cpu_or_gs(volatile void *ptr,
+				long data, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("orb %b0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("orw %w0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("orl %k0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("orq %0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_or_gs(obj, value)\
+	__cpu_or_gs(&(obj), (unsigned long)value, sizeof(obj))
+
 #define CPU_READ(obj)		cpu_read_gs(obj)
 #define CPU_WRITE(obj,val)	cpu_write_gs(obj, val)
 #define CPU_ADD(obj,val)	cpu_add_gs(obj, val)
 #define CPU_SUB(obj,val)	cpu_sub_gs(obj, val)
 #define CPU_INC(obj)		cpu_inc_gs(obj)
 #define CPU_DEC(obj)		cpu_dec_gs(obj)
+#define CPU_OR(obj, val)	cpu_or_gs(obj, val)
 
 #define CPU_XCHG(obj,val)	cpu_xchg_gs(obj, val)
 #define CPU_CMPXCHG(obj, old, new) cmpxchg_local_gs(obj, old, new)
@@ -327,6 +355,7 @@ static inline unsigned long __cmpxchg_lo
 #define _CPU_DEC CPU_DEC
 #define _CPU_XCHG CPU_XCHG
 #define _CPU_CMPXCHG CPU_CMPXCHG
+#define _CPU_OR CPU_OR
 
 #define __CPU_READ CPU_READ
 #define __CPU_WRITE CPU_WRITE
@@ -336,5 +365,6 @@ static inline unsigned long __cmpxchg_lo
 #define __CPU_DEC CPU_DEC
 #define __CPU_XCHG CPU_XCHG
 #define __CPU_CMPXCHG CPU_CMPXCHG
+#define __CPU_OR CPU_OR
 
 #endif /* _ASM_X8664_PERCPU_H_ */

-- 
