Return-Path: <linux-kernel-owner+w=401wt.eu-S964955AbXBOHU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964955AbXBOHU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964958AbXBOHU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:20:28 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:54720 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964955AbXBOHU1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:20:27 -0500
Date: Thu, 15 Feb 2007 02:20:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] local_t : powerpc extension
Message-ID: <20070215072024.GA9137@Krystal>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214225653.345aad29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070214225653.345aad29.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 02:14:36 up 12 days, 21:22,  4 users,  load average: 1.10, 1.18, 1.17
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 11 Feb 2007 14:18:12 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > local_t : powerpc extension
> 
> This diff contains changes which are also present in "[PATCH 07/10]
> atomic.h : Add atomic64 cmpxchg, xchg and add_unless to powerpc", resulting
> in rather a mess.
> 
> I dropped the duplicated hunks from the later patch rather than this one,
> but I haven't tried to compile the result yet.
> 

Yes, sorry about that : the atomic.h diff has been duplicated in both
the local and atomic changes.

The change to system.h for local.h is to add the xchg_local and
cmpxchg_local, while the change for atomic.h is to simply remove the
#include <asm/atomic.h> from system.h.

Here is a proper local.h diff, if it happens to become necessary, but
simply removing the duplicated asm-powerpc/system.h hunks will be ok.

Thanks,

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/local.h
+++ b/include/asm-powerpc/local.h
@@ -1 +1,342 @@
-#include <asm-generic/local.h>
+#ifndef _ARCH_POWERPC_LOCAL_H
+#define _ARCH_POWERPC_LOCAL_H
+
+#include <linux/percpu.h>
+#include <asm/atomic.h>
+
+typedef struct
+{
+	atomic_long_t a;
+} local_t;
+
+#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
+
+#define local_read(l)	atomic_long_read(&(l)->a)
+#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
+
+#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
+#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
+#define local_inc(l)	atomic_long_inc(&(l)->a)
+#define local_dec(l)	atomic_long_dec(&(l)->a)
+
+#ifndef __powerpc64__
+
+static __inline__ int local_add_return(int a, local_t *l)
+{
+	int t;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%2		# local_add_return\n\
+	add	%0,%1,%0\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%0,0,%2 \n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (a), "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+#define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
+
+static __inline__ int local_sub_return(int a, local_t *l)
+{
+	int t;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%2		# local_sub_return\n\
+	subf	%0,%1,%0\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%0,0,%2 \n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (a), "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+static __inline__ int local_inc_return(local_t *l)
+{
+	int t;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%1		# local_inc_return\n\
+	addic	%0,%0,1\n"
+	PPC405_ERR77(0,%1)
+"	stwcx.	%0,0,%1 \n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+/*
+ * local_inc_and_test - increment and test
+ * @l: pointer of type local_t
+ *
+ * Atomically increments @l by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+#define local_inc_and_test(l) (local_inc_return(l) == 0)
+
+static __inline__ int local_dec_return(local_t *l)
+{
+	int t;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%1		# local_dec_return\n\
+	addic	%0,%0,-1\n"
+	PPC405_ERR77(0,%1)
+"	stwcx.	%0,0,%1\n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+#define local_cmpxchg(l, o, n) \
+	(cmpxchg_local(&((l)->a.counter), (o), (n)))
+#define local_xchg(l, n) (xchg_local(&((l)->a.counter), (n)))
+
+/**
+ * local_add_unless - add unless the number is a given value
+ * @l: pointer of type local_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @l, so long as it was not @u.
+ * Returns non-zero if @l was not @u, and zero otherwise.
+ */
+static __inline__ int local_add_unless(local_t *l, int a, int u)
+{
+	int t;
+
+	__asm__ __volatile__ (
+"1:	lwarx	%0,0,%1		# local_add_unless\n\
+	cmpw	0,%0,%3 \n\
+	beq-	2f \n\
+	add	%0,%2,%0 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%0,0,%1 \n\
+	bne-	1b \n"
+"	subf	%0,%2,%0 \n\
+2:"
+	: "=&r" (t)
+	: "r" (&(l->a.counter)), "r" (a), "r" (u)
+	: "cc", "memory");
+
+	return t != u;
+}
+
+#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
+
+#define local_sub_and_test(a, l)	(local_sub_return((a), (l)) == 0)
+#define local_dec_and_test(l)		(local_dec_return((l)) == 0)
+
+/*
+ * Atomically test *l and decrement if it is greater than 0.
+ * The function returns the old value of *l minus 1.
+ */
+static __inline__ int local_dec_if_positive(local_t *l)
+{
+	int t;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%1		# local_dec_if_positive\n\
+	cmpwi	%0,1\n\
+	addi	%0,%0,-1\n\
+	blt-	2f\n"
+	PPC405_ERR77(0,%1)
+"	stwcx.	%0,0,%1\n\
+	bne-	1b"
+	"\n\
+2:"	: "=&b" (t)
+	: "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+#else /* __powerpc64__ */
+
+static __inline__ long local_add_return(long a, local_t *l)
+{
+	long t;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%2		# local_add_return\n\
+	add	%0,%1,%0\n\
+	stdcx.	%0,0,%2 \n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (a), "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+#define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
+
+static __inline__ long local_sub_return(long a, local_t *l)
+{
+	long t;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%2		# local_sub_return\n\
+	subf	%0,%1,%0\n\
+	stdcx.	%0,0,%2 \n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (a), "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+static __inline__ long local_inc_return(local_t *l)
+{
+	long t;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%1		# local_inc_return\n\
+	addic	%0,%0,1\n\
+	stdcx.	%0,0,%1 \n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+/*
+ * local_inc_and_test - increment and test
+ * @l: pointer of type local_t
+ *
+ * Atomically increments @l by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+#define local_inc_and_test(l) (local_inc_return(l) == 0)
+
+static __inline__ long local_dec_return(local_t *l)
+{
+	long t;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%1		# local_dec_return\n\
+	addic	%0,%0,-1\n\
+	stdcx.	%0,0,%1\n\
+	bne-	1b"
+	: "=&r" (t)
+	: "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+#define local_sub_and_test(a, l)	(local_sub_return((a), (l)) == 0)
+#define local_dec_and_test(l)	(local_dec_return((l)) == 0)
+
+/*
+ * Atomically test *l and decrement if it is greater than 0.
+ * The function returns the old value of *l minus 1.
+ */
+static __inline__ long local_dec_if_positive(local_t *l)
+{
+	long t;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%1		# local_dec_if_positive\n\
+	addic.	%0,%0,-1\n\
+	blt-	2f\n\
+	stdcx.	%0,0,%1\n\
+	bne-	1b"
+	"\n\
+2:"	: "=&r" (t)
+	: "r" (&(l->a.counter))
+	: "cc", "memory");
+
+	return t;
+}
+
+#define local_cmpxchg(l, o, n) \
+	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
+#define local_xchg(l, (n)) (xchg_local(&((l)->a.counter), (n)))
+
+/**
+ * local_add_unless - add unless the number is a given value
+ * @l: pointer of type local_t
+ * @a: the amount to add to l...
+ * @u: ...unless l is equal to u.
+ *
+ * Atomically adds @a to @l, so long as it was not @u.
+ * Returns non-zero if @l was not @u, and zero otherwise.
+ */
+static __inline__ int local_add_unless(local_t *l, long a, long u)
+{
+	long t;
+
+	__asm__ __volatile__ (
+"1:	ldarx	%0,0,%1		# local_add_unless\n\
+	cmpd	0,%0,%3 \n\
+	beq-	2f \n\
+	add	%0,%2,%0 \n"
+"	stdcx.	%0,0,%1 \n\
+	bne-	1b \n"
+"	subf	%0,%2,%0 \n\
+2:"
+	: "=&r" (t)
+	: "r" (&(l->a.counter)), "r" (a), "r" (u)
+	: "cc", "memory");
+
+	return t != u;
+}
+
+#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
+
+#endif /* !__powerpc64__ */
+
+/* Use these for per-cpu local_t variables: on some archs they are
+ * much more efficient than these naive implementations.  Note they take
+ * a variable, not an address.
+ */
+
+#define __local_inc(l)		((l)->a.counter++)
+#define __local_dec(l)		((l)->a.counter++)
+#define __local_add(i,l)	((l)->a.counter+=(i))
+#define __local_sub(i,l)	((l)->a.counter-=(i))
+
+/* Need to disable preemption for the cpu local counters otherwise we could
+   still access a variable of a previous CPU in a non atomic way. */
+#define cpu_local_wrap_v(l)	 	\
+	({ local_t res__;		\
+	   preempt_disable(); 		\
+	   res__ = (l);			\
+	   preempt_enable();		\
+	   res__; })
+#define cpu_local_wrap(l)		\
+	({ preempt_disable();		\
+	   l;				\
+	   preempt_enable(); })		\
+
+#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
+#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
+#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
+#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
+#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
+#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
+
+#define __cpu_local_inc(l)	cpu_local_inc(l)
+#define __cpu_local_dec(l)	cpu_local_dec(l)
+#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
+#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
+
+#endif /* _ARCH_POWERPC_LOCAL_H */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
