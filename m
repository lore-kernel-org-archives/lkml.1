Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZGAQrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZGAQrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZGAQrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:47:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZGAQrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:47:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Implement atomic64_t
To: mingo@elte.hu
Cc: torvalds@osdl.org, akpm@linux-foundation.org, paulus@samba.org,
       arnd@arndb.de, dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 01 Jul 2009 17:47:00 +0100
Message-ID: <20090701164700.29780.15103.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090701144913.GA28172@elte.hu>
References: <20090701144913.GA28172@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement atomic64_t and its ops for FRV.  Tested with the following patch:
	diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
	index 55e4fab..086d50d 100644
	--- a/arch/frv/kernel/setup.c
	+++ b/arch/frv/kernel/setup.c
	@@ -746,6 +746,52 @@ static void __init parse_cmdline_early(char *cmdline)

	 } /* end parse_cmdline_early() */

	+static atomic64_t xxx;
	+
	+static void test_atomic64(void)
	+{
	+	atomic64_set(&xxx, 0x12300000023LL);
	+
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != 0x12300000023LL);
	+	mb();
	+	if (atomic64_inc_return(&xxx) != 0x12300000024LL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != 0x12300000024LL);
	+	mb();
	+	if (atomic64_sub_return(0x36900000050LL, &xxx) != -0x2460000002cLL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != -0x2460000002cLL);
	+	mb();
	+	if (atomic64_dec_return(&xxx) != -0x2460000002dLL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != -0x2460000002dLL);
	+	mb();
	+	if (atomic64_add_return(0x36800000001LL, &xxx) != 0x121ffffffd4LL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != 0x121ffffffd4LL);
	+	mb();
	+	if (atomic64_cmpxchg(&xxx, 0x123456789abcdefLL, 0x121ffffffd4LL) != 0x121ffffffd4LL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != 0x121ffffffd4LL);
	+	mb();
	+	if (atomic64_cmpxchg(&xxx, 0x121ffffffd4LL, 0x123456789abcdefLL) != 0x121ffffffd4LL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != 0x123456789abcdefLL);
	+	mb();
	+	if (atomic64_xchg(&xxx, 0xabcdef123456789LL) != 0x123456789abcdefLL)
	+		BUG();
	+	mb();
	+	BUG_ON(atomic64_read(&xxx) != 0xabcdef123456789LL);
	+	mb();
	+}
	+
	 /*****************************************************************************/
	 /*
	  *
	@@ -845,6 +891,8 @@ void __init setup_arch(char **cmdline_p)
	 //	asm volatile("movgs %0,timerd" :: "r"(10000000));
	 //	__set_HSR(0, __get_HSR(0) | HSR0_ETMD);

	+	test_atomic64();
	+
	 } /* end setup_arch() */

	 #if 0

Note that this doesn't cover all the trivial wrappers, but does cover all the
substantial implementations.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/atomic.h |   53 +++++++++++++
 arch/frv/include/asm/system.h |    2 +
 arch/frv/kernel/frv_ksyms.c   |    4 +
 arch/frv/lib/Makefile         |    2 -
 arch/frv/lib/atomic-ops.S     |    3 -
 arch/frv/lib/atomic64-ops.S   |  162 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 221 insertions(+), 5 deletions(-)
 create mode 100644 arch/frv/lib/atomic64-ops.S


diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index 0409d98..cf483d1 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -121,10 +121,57 @@ static inline void atomic_dec(atomic_t *v)
 #define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
 #define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
 
+/*
+ * 64-bit atomic ops
+ */
+typedef struct {
+	volatile long long counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(i)	{ (i) }
+#define atomic64_read(v)	((v)->counter)
+#define atomic64_set(v, i)	(((v)->counter) = (i))
+
+extern long long atomic64_inc_return(atomic64_t *v);
+extern long long atomic64_dec_return(atomic64_t *v);
+extern long long atomic64_add_return(long long i, atomic64_t *v);
+extern long long atomic64_sub_return(long long i, atomic64_t *v);
+
+static inline long long atomic64_add_negative(long long i, atomic64_t *v)
+{
+	return atomic64_add_return(i, v) < 0;
+}
+
+static inline void atomic64_add(long long i, atomic64_t *v)
+{
+	atomic64_add_return(i, v);
+}
+
+static inline void atomic64_sub(long long i, atomic64_t *v)
+{
+	atomic64_sub_return(i, v);
+}
+
+static inline void atomic64_inc(atomic64_t *v)
+{
+	atomic64_inc_return(v);
+}
+
+static inline void atomic64_dec(atomic64_t *v)
+{
+	atomic64_dec_return(v);
+}
+
+#define atomic64_sub_and_test(i,v)	(atomic64_sub_return((i), (v)) == 0)
+#define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
+#define atomic64_inc_and_test(v)	(atomic64_inc_return((v)) == 0)
+
 /*****************************************************************************/
 /*
  * exchange value with memory
  */
+extern uint64_t __xchg_64(uint64_t i, volatile void *v);
+
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
 
 #define xchg(ptr, x)								\
@@ -174,8 +221,10 @@ extern uint32_t __xchg_32(uint32_t i, volatile void *v);
 
 #define tas(ptr) (xchg((ptr), 1))
 
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, old, new)	(cmpxchg(&(v)->counter, old, new))
+#define atomic_xchg(v, new)		(xchg(&(v)->counter, new))
+#define atomic64_cmpxchg(v, old, new)	(__cmpxchg_64(old, new, &(v)->counter))
+#define atomic64_xchg(v, new)		(__xchg_64(new, &(v)->counter))
 
 static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 {
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
index 7742ec0..efd22d9 100644
--- a/arch/frv/include/asm/system.h
+++ b/arch/frv/include/asm/system.h
@@ -208,6 +208,8 @@ extern void free_initmem(void);
  * - if (*ptr == test) then orig = *ptr; *ptr = test;
  * - if (*ptr != test) then orig = *ptr;
  */
+extern uint64_t __cmpxchg_64(uint64_t test, uint64_t new, volatile uint64_t *v);
+
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
 
 #define cmpxchg(ptr, test, new)							\
diff --git a/arch/frv/kernel/frv_ksyms.c b/arch/frv/kernel/frv_ksyms.c
index 0316b3c..a89803b 100644
--- a/arch/frv/kernel/frv_ksyms.c
+++ b/arch/frv/kernel/frv_ksyms.c
@@ -67,6 +67,10 @@ EXPORT_SYMBOL(atomic_sub_return);
 EXPORT_SYMBOL(__xchg_32);
 EXPORT_SYMBOL(__cmpxchg_32);
 #endif
+EXPORT_SYMBOL(atomic64_add_return);
+EXPORT_SYMBOL(atomic64_sub_return);
+EXPORT_SYMBOL(__xchg_64);
+EXPORT_SYMBOL(__cmpxchg_64);
 
 EXPORT_SYMBOL(__debug_bug_printk);
 EXPORT_SYMBOL(__delay_loops_MHz);
diff --git a/arch/frv/lib/Makefile b/arch/frv/lib/Makefile
index 08be305..4ff2fb1 100644
--- a/arch/frv/lib/Makefile
+++ b/arch/frv/lib/Makefile
@@ -4,5 +4,5 @@
 
 lib-y := \
 	__ashldi3.o __lshrdi3.o __muldi3.o __ashrdi3.o __negdi2.o __ucmpdi2.o \
-	checksum.o memcpy.o memset.o atomic-ops.o \
+	checksum.o memcpy.o memset.o atomic-ops.o atomic64-ops.o \
 	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o
diff --git a/arch/frv/lib/atomic-ops.S b/arch/frv/lib/atomic-ops.S
index ee0ac90..5e9e6ab 100644
--- a/arch/frv/lib/atomic-ops.S
+++ b/arch/frv/lib/atomic-ops.S
@@ -163,11 +163,10 @@ __cmpxchg_32:
 	ld.p		@(gr11,gr0),gr8
 	orcr		cc7,cc7,cc3
 	subcc		gr8,gr9,gr7,icc0
-	bne		icc0,#0,1f
+	bnelr		icc0,#0
 	cst.p		gr10,@(gr11,gr0)	,cc3,#1
 	corcc		gr29,gr29,gr0		,cc3,#1
 	beq		icc3,#0,0b
-1:
 	bralr
 
 	.size		__cmpxchg_32, .-__cmpxchg_32
diff --git a/arch/frv/lib/atomic64-ops.S b/arch/frv/lib/atomic64-ops.S
new file mode 100644
index 0000000..b6194ee
--- /dev/null
+++ b/arch/frv/lib/atomic64-ops.S
@@ -0,0 +1,162 @@
+/* kernel atomic64 operations
+ *
+ * For an explanation of how atomic ops work in this arch, see:
+ *   Documentation/frv/atomic-ops.txt
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <asm/spr-regs.h>
+
+	.text
+	.balign 4
+
+
+###############################################################################
+#
+# long long atomic64_inc_return(atomic64_t *v)
+#
+###############################################################################
+	.globl		atomic64_inc_return
+        .type		atomic64_inc_return,@function
+atomic64_inc_return:
+	or.p		gr8,gr8,gr10
+0:
+	orcc		gr0,gr0,gr0,icc3		/* set ICC3.Z */
+	ckeq		icc3,cc7
+	ldd.p		@(gr10,gr0),gr8			/* LDD.P/ORCR must be atomic */
+	orcr		cc7,cc7,cc3			/* set CC3 to true */
+	addicc		gr9,#1,gr9,icc0
+	addxi		gr8,#0,gr8,icc0
+	cstd.p		gr8,@(gr10,gr0)		,cc3,#1
+	corcc		gr29,gr29,gr0		,cc3,#1	/* clear ICC3.Z if store happens */
+	beq		icc3,#0,0b
+	bralr
+
+	.size		atomic64_inc_return, .-atomic64_inc_return
+
+###############################################################################
+#
+# long long atomic64_dec_return(atomic64_t *v)
+#
+###############################################################################
+	.globl		atomic64_dec_return
+        .type		atomic64_dec_return,@function
+atomic64_dec_return:
+	or.p		gr8,gr8,gr10
+0:
+	orcc		gr0,gr0,gr0,icc3		/* set ICC3.Z */
+	ckeq		icc3,cc7
+	ldd.p		@(gr10,gr0),gr8			/* LDD.P/ORCR must be atomic */
+	orcr		cc7,cc7,cc3			/* set CC3 to true */
+	subicc		gr9,#1,gr9,icc0
+	subxi		gr8,#0,gr8,icc0
+	cstd.p		gr8,@(gr10,gr0)		,cc3,#1
+	corcc		gr29,gr29,gr0		,cc3,#1	/* clear ICC3.Z if store happens */
+	beq		icc3,#0,0b
+	bralr
+
+	.size		atomic64_dec_return, .-atomic64_dec_return
+
+###############################################################################
+#
+# long long atomic64_add_return(long long i, atomic64_t *v)
+#
+###############################################################################
+	.globl		atomic64_add_return
+        .type		atomic64_add_return,@function
+atomic64_add_return:
+	or.p		gr8,gr8,gr4
+	or		gr9,gr9,gr5
+0:
+	orcc		gr0,gr0,gr0,icc3		/* set ICC3.Z */
+	ckeq		icc3,cc7
+	ldd.p		@(gr10,gr0),gr8			/* LDD.P/ORCR must be atomic */
+	orcr		cc7,cc7,cc3			/* set CC3 to true */
+	addcc		gr9,gr5,gr9,icc0
+	addx		gr8,gr4,gr8,icc0
+	cstd.p		gr8,@(gr10,gr0)		,cc3,#1
+	corcc		gr29,gr29,gr0		,cc3,#1	/* clear ICC3.Z if store happens */
+	beq		icc3,#0,0b
+	bralr
+
+	.size		atomic64_add_return, .-atomic64_add_return
+
+###############################################################################
+#
+# long long atomic64_sub_return(long long i, atomic64_t *v)
+#
+###############################################################################
+	.globl		atomic64_sub_return
+        .type		atomic64_sub_return,@function
+atomic64_sub_return:
+	or.p		gr8,gr8,gr4
+	or		gr9,gr9,gr5
+0:
+	orcc		gr0,gr0,gr0,icc3		/* set ICC3.Z */
+	ckeq		icc3,cc7
+	ldd.p		@(gr10,gr0),gr8			/* LDD.P/ORCR must be atomic */
+	orcr		cc7,cc7,cc3			/* set CC3 to true */
+	subcc		gr9,gr5,gr9,icc0
+	subx		gr8,gr4,gr8,icc0
+	cstd.p		gr8,@(gr10,gr0)		,cc3,#1
+	corcc		gr29,gr29,gr0		,cc3,#1	/* clear ICC3.Z if store happens */
+	beq		icc3,#0,0b
+	bralr
+
+	.size		atomic64_sub_return, .-atomic64_sub_return
+
+###############################################################################
+#
+# uint64_t __xchg_64(uint64_t i, uint64_t *v)
+#
+###############################################################################
+	.globl		__xchg_64
+        .type		__xchg_64,@function
+__xchg_64:
+	or.p		gr8,gr8,gr4
+	or		gr9,gr9,gr5
+0:
+	orcc		gr0,gr0,gr0,icc3		/* set ICC3.Z */
+	ckeq		icc3,cc7
+	ldd.p		@(gr10,gr0),gr8			/* LDD.P/ORCR must be atomic */
+	orcr		cc7,cc7,cc3			/* set CC3 to true */
+	cstd.p		gr4,@(gr10,gr0)		,cc3,#1
+	corcc		gr29,gr29,gr0		,cc3,#1	/* clear ICC3.Z if store happens */
+	beq		icc3,#0,0b
+	bralr
+
+	.size		__xchg_64, .-__xchg_64
+
+###############################################################################
+#
+# uint64_t __cmpxchg_64(uint64_t test, uint64_t new, uint64_t *v)
+#
+###############################################################################
+	.globl		__cmpxchg_64
+        .type		__cmpxchg_64,@function
+__cmpxchg_64:
+	or.p		gr8,gr8,gr4
+	or		gr9,gr9,gr5
+0:
+	orcc		gr0,gr0,gr0,icc3		/* set ICC3.Z */
+	ckeq		icc3,cc7
+	ldd.p		@(gr12,gr0),gr8			/* LDD.P/ORCR must be atomic */
+	orcr		cc7,cc7,cc3
+	subcc		gr8,gr4,gr0,icc0
+	subcc.p		gr9,gr5,gr0,icc1
+	bnelr		icc0,#0
+	bnelr		icc1,#0
+	cstd.p		gr10,@(gr12,gr0)	,cc3,#1
+	corcc		gr29,gr29,gr0		,cc3,#1	/* clear ICC3.Z if store happens */
+	beq		icc3,#0,0b
+	bralr
+
+	.size		__cmpxchg_64, .-__cmpxchg_64
+

