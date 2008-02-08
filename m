Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbYBHCXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbYBHCXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYBHCXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:23:43 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:46605 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753840AbYBHCXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:23:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAA9Mq0dMQWYq/2dsb2JhbACBWaplgXM
Date: Thu, 7 Feb 2008 21:23:38 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: [PATCH] Fix FRV cmpxchg_local
Message-ID: <20080208022338.GA25604@Krystal>
References: <20080207231350.GG7198@cs181133002.pp.htv.fi> <20080208013422.GA22122@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080208013422.GA22122@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:20:51 up 96 days,  7:26,  3 users,  load average: 1.04, 0.93,
	0.99
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the FRV cmpxchg_local by breaking the following header dependency loop :

linux/kernel.h -> linux/bitops.h -> asm-frv/bitops.h -> asm-frv/atomic.h
  -> asm-frv/system.h -> 
  asm-generic/cmpxchg_local.h -> typecheck() defined in linux/kernel.h

and

linux/kernel.h -> linux/bitops.h -> asm-frv/bitops.h -> asm-frv/atomic.h -> 
  asm-generic/cmpxchg_local.h -> typecheck() defined in linux/kernel.h

In order to fix this :
- Move the atomic_test_and_ *_mask inlines from asm-frv/atomic.h (why are they
  there at all anyway ? They are not touching atomic_t variables!) to
  asm-frv/bitops.h.

Also fix a build issue with cmpxchg : it does not cast to (unsigned long *)
like other architectures, to deal with it in the cmpxchg_local macro.

FRV builds fine with this patch.

Thanks to Adrian Bunk <bunk@kernel.org> for spotting this bug.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <bunk@kernel.org>
---
 include/asm-frv/atomic.h |   81 ---------------------------------------------
 include/asm-frv/bitops.h |   83 +++++++++++++++++++++++++++++++++++++++++++++--
 include/asm-frv/system.h |    3 +
 3 files changed, 83 insertions(+), 84 deletions(-)

Index: linux-2.6-lttng/include/asm-frv/atomic.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/atomic.h	2008-02-07 17:29:09.000000000 -0500
+++ linux-2.6-lttng/include/asm-frv/atomic.h	2008-02-07 17:32:05.000000000 -0500
@@ -125,87 +125,6 @@
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
 #define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
 
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-static inline
-unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	and%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(~mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-static inline
-unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	or%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-static inline
-unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	xor%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-#else
-
-extern unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v);
-extern unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v);
-extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v);
-
-#endif
-
-#define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
-#define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
-
 /*****************************************************************************/
 /*
  * exchange value with memory
Index: linux-2.6-lttng/include/asm-frv/bitops.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/bitops.h	2008-02-07 17:27:48.000000000 -0500
+++ linux-2.6-lttng/include/asm-frv/bitops.h	2008-02-07 17:32:20.000000000 -0500
@@ -16,8 +16,6 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
-#include <asm/atomic.h>
 
 #ifdef __KERNEL__
 
@@ -33,6 +31,87 @@
 #define smp_mb__before_clear_bit()	barrier()
 #define smp_mb__after_clear_bit()	barrier()
 
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+static inline
+unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	and%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(~mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+static inline
+unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	or%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+static inline
+unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	xor%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+#else
+
+extern unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v);
+extern unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v);
+extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v);
+
+#endif
+
+#define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
+#define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
+
 static inline int test_and_clear_bit(int nr, volatile void *addr)
 {
 	volatile unsigned long *ptr = addr;
Index: linux-2.6-lttng/include/asm-frv/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/system.h	2008-02-07 17:34:08.000000000 -0500
+++ linux-2.6-lttng/include/asm-frv/system.h	2008-02-07 17:35:12.000000000 -0500
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/linkage.h>
+#include <linux/kernel.h>
 
 struct thread_struct;
 
@@ -276,7 +277,7 @@
 {
 	switch (size) {
 	case 4:
-		return cmpxchg(ptr, old, new);
+		return cmpxchg((unsigned long *)ptr, old, new);
 	default:
 		return __cmpxchg_local_generic(ptr, old, new, size);
 	}

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
