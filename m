Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbXGNQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbXGNQC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXGNQCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:02:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbXGNQCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:02:12 -0400
Message-Id: <20070714175839.921317000@chello.nl>
References: <20070714175733.194012000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 14 Jul 2007 19:57:36 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 3/5] asm/local.h cmpxchg
Content-Disposition: inline; filename=local.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/local.h |   25 +++++++++++++++++++++++--
 include/asm-i386/local.h    |   13 +++++++++++++
 include/asm-x86_64/local.h  |   16 ++++++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm1/include/asm-generic/local.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-generic/local.h	2007-07-12 19:44:18.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/asm-generic/local.h	2007-07-12 19:44:57.000000000 -0700
@@ -46,13 +46,34 @@ typedef struct
 #define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
 #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
 
-/* Non-atomic variants, ie. preemption disabled and won't be touched
- * in interrupt, etc.  Some archs can optimize this case well. */
+/*
+ * Establish a state necessary for __local_xx functions to work.
+ */
+#define __local_begin(flags)	local_irq_disable(flags)
+
+static inline void __local_end(unsigned long flags)
+{
+	local_irq_restore(flags);
+}
+
+/*
+ * Non-atomic variants, ie. within local_begin() / local_end() or
+ * preempt_disable / enable() and won't be touched in interrupt, etc.
+ * Some archs can optimize this case well.
+ */
 #define __local_inc(l)		local_set((l), local_read(l) + 1)
 #define __local_dec(l)		local_set((l), local_read(l) - 1)
 #define __local_add(i,l)	local_set((l), local_read(l) + (i))
 #define __local_sub(i,l)	local_set((l), local_read(l) - (i))
 
+#define __local_cmpxchg((v), (o), (n)) (*(v) = (n), (o))
+#define __local_xchg((v), (n)) 						\
+({									\
+	__typeof(v) x = *(v);						\
+	*(v) = (n);							\
+	x;								\
+)}
+
 /* Use these for per-cpu local_t variables: on some archs they are
  * much more efficient than these naive implementations.  Note they take
  * a variable (eg. mystruct.foo), not an address.
Index: linux-2.6.22-rc6-mm1/include/asm-x86_64/local.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-x86_64/local.h	2007-07-12 19:44:18.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/asm-x86_64/local.h	2007-07-12 19:44:57.000000000 -0700
@@ -9,6 +9,7 @@ typedef struct
 	atomic_long_t a;
 } local_t;
 
+
 #define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
 
 #define local_read(l)	atomic_long_read(&(l)->a)
@@ -181,11 +182,26 @@ static __inline__ long local_sub_return(
 
 /* On x86-64 these are better than the atomic variants on SMP kernels
    because they dont use a lock prefix. */
+
+#define __local_begin(__flags)		\
+{					\
+	(__flags) = 0;			\
+	preempt_disable();		\
+}
+
+static inline void __local_end(unsigned long flags) {
+	preempt_enable();
+}
+
 #define __local_inc(l)		local_inc(l)
 #define __local_dec(l)		local_dec(l)
 #define __local_add(i,l)	local_add((i),(l))
 #define __local_sub(i,l)	local_sub((i),(l))
 
+#define __local_cmpxchg		cmpxchg_local
+#define __local_xchg		xchg
+
+
 /* Use these for per-cpu local_t variables: on some archs they are
  * much more efficient than these naive implementations.  Note they take
  * a variable, not an address.
Index: linux-2.6.22-rc6-mm1/include/asm-i386/local.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-i386/local.h	2007-07-12 19:53:00.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/asm-i386/local.h	2007-07-12 19:55:22.000000000 -0700
@@ -194,12 +194,25 @@ static __inline__ long local_sub_return(
 })
 #define local_inc_not_zero(l) local_add_unless((l), 1, 0)
 
+#define __local_begin(__flags)					\
+{								\
+	(__flags) = 0;						\
+	preempt_disable();					\
+}
+
+static inline void __local_end(unsigned long flags) {
+	preempt_enable();
+}
+
 /* On x86, these are no better than the atomic variants. */
 #define __local_inc(l)		local_inc(l)
 #define __local_dec(l)		local_dec(l)
 #define __local_add(i,l)	local_add((i),(l))
 #define __local_sub(i,l)	local_sub((i),(l))
 
+#define __local_cmpxchg		cmpxchg_local
+#define __local_xchg		xchg
+
 /* Use these for per-cpu local_t variables: on some archs they are
  * much more efficient than these naive implementations.  Note they take
  * a variable, not an address.

--

