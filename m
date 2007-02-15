Return-Path: <linux-kernel-owner+w=401wt.eu-S1161437AbXBOVn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161437AbXBOVn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161442AbXBOVn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:43:57 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:37765 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161437AbXBOVnu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:43:50 -0500
Date: Thu, 15 Feb 2007 16:43:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] local_t : powerpc extension - shrink powerpc local.h
Message-ID: <20070215214348.GB3466@Krystal>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214225653.345aad29.akpm@linux-foundation.org> <20070215072024.GA9137@Krystal> <27EC3349-5FD8-47BD-B909-E1180B86AF40@kernel.crashing.org> <20070215200245.GF31359@Krystal> <906FD21B-59B6-4A30-90F0-914E0CD3CFBF@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <906FD21B-59B6-4A30-90F0-914E0CD3CFBF@kernel.crashing.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 16:26:51 up 13 days, 11:34,  5 users,  load average: 1.29, 1.49, 1.49
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

local_t : powerpc extension - shrink powerpc local.h

By using PPC_LLARX and PPC_STLCX, we can cut in half the size of powerpc
local.h.

In applies on top of the local_t : powerpc extension - use long for powerpc32

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/local.h
+++ b/include/asm-powerpc/local.h
@@ -19,17 +19,15 @@ typedef struct
 #define local_inc(l)	atomic_long_inc(&(l)->a)
 #define local_dec(l)	atomic_long_dec(&(l)->a)
 
-#ifndef __powerpc64__
-
 static __inline__ long local_add_return(long a, local_t *l)
 {
 	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%2		# local_add_return\n\
+"1:"	PPC_LLARX	"%0,0,%2		# local_add_return\n\
 	add	%0,%1,%0\n"
 	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
+	PPC_STLCX	"%0,0,%2 \n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (a), "r" (&(l->a.counter))
@@ -45,10 +43,10 @@ static __inline__ long local_sub_return(long a, local_t *l)
 	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%2		# local_sub_return\n\
+"1:"	PPC_LLARX	"%0,0,%2		# local_sub_return\n\
 	subf	%0,%1,%0\n"
 	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%2 \n\
+	PPC_STLCX	"%0,0,%2 \n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (a), "r" (&(l->a.counter))
@@ -62,10 +60,10 @@ static __inline__ long local_inc_return(local_t *l)
 	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%1		# local_inc_return\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_inc_return\n\
 	addic	%0,%0,1\n"
 	PPC405_ERR77(0,%1)
-"	stwcx.	%0,0,%1 \n\
+	PPC_STLCX	"%0,0,%1 \n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (&(l->a.counter))
@@ -89,10 +87,10 @@ static __inline__ long local_dec_return(local_t *l)
 	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%1		# local_dec_return\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_dec_return\n\
 	addic	%0,%0,-1\n"
 	PPC405_ERR77(0,%1)
-"	stwcx.	%0,0,%1\n\
+	PPC_STLCX	"%0,0,%1\n\
 	bne-	1b"
 	: "=&r" (t)
 	: "r" (&(l->a.counter))
@@ -119,12 +117,12 @@ static __inline__ int local_add_unless(local_t *l, long a, long u)
 	long t;
 
 	__asm__ __volatile__ (
-"1:	lwarx	%0,0,%1		# local_add_unless\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_add_unless\n\
 	cmpw	0,%0,%3 \n\
 	beq-	2f \n\
 	add	%0,%2,%0 \n"
 	PPC405_ERR77(0,%2)
-"	stwcx.	%0,0,%1 \n\
+	PPC_STLCX	"%0,0,%1 \n\
 	bne-	1b \n"
 "	subf	%0,%2,%0 \n\
 2:"
@@ -149,12 +147,12 @@ static __inline__ long local_dec_if_positive(local_t *l)
 	long t;
 
 	__asm__ __volatile__(
-"1:	lwarx	%0,0,%1		# local_dec_if_positive\n\
+"1:"	PPC_LLARX	"%0,0,%1		# local_dec_if_positive\n\
 	cmpwi	%0,1\n\
 	addi	%0,%0,-1\n\
 	blt-	2f\n"
 	PPC405_ERR77(0,%1)
-"	stwcx.	%0,0,%1\n\
+	PPC_STLCX	"%0,0,%1\n\
 	bne-	1b"
 	"\n\
 2:"	: "=&b" (t)
@@ -164,146 +162,6 @@ static __inline__ long local_dec_if_positive(local_t *l)
 	return t;
 }
 
-#else /* __powerpc64__ */
-
-static __inline__ long local_add_return(long a, local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%2		# local_add_return\n\
-	add	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (a), "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
-
-static __inline__ long local_sub_return(long a, local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%2		# local_sub_return\n\
-	subf	%0,%1,%0\n\
-	stdcx.	%0,0,%2 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (a), "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-static __inline__ long local_inc_return(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%1		# local_inc_return\n\
-	addic	%0,%0,1\n\
-	stdcx.	%0,0,%1 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-/*
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define local_inc_and_test(l) (local_inc_return(l) == 0)
-
-static __inline__ long local_dec_return(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%1		# local_dec_return\n\
-	addic	%0,%0,-1\n\
-	stdcx.	%0,0,%1\n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_sub_and_test(a, l)	(local_sub_return((a), (l)) == 0)
-#define local_dec_and_test(l)	(local_dec_return((l)) == 0)
-
-/*
- * Atomically test *l and decrement if it is greater than 0.
- * The function returns the old value of *l minus 1.
- */
-static __inline__ long local_dec_if_positive(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%1		# local_dec_if_positive\n\
-	addic.	%0,%0,-1\n\
-	blt-	2f\n\
-	stdcx.	%0,0,%1\n\
-	bne-	1b"
-	"\n\
-2:"	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_cmpxchg(l, o, n) \
-	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
-#define local_xchg(l, (n)) (xchg_local(&((l)->a.counter), (n)))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to l...
- * @u: ...unless l is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-static __inline__ int local_add_unless(local_t *l, long a, long u)
-{
-	long t;
-
-	__asm__ __volatile__ (
-"1:	ldarx	%0,0,%1		# local_add_unless\n\
-	cmpd	0,%0,%3 \n\
-	beq-	2f \n\
-	add	%0,%2,%0 \n"
-"	stdcx.	%0,0,%1 \n\
-	bne-	1b \n"
-"	subf	%0,%2,%0 \n\
-2:"
-	: "=&r" (t)
-	: "r" (&(l->a.counter)), "r" (a), "r" (u)
-	: "cc", "memory");
-
-	return t != u;
-}
-
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-#endif /* !__powerpc64__ */
-
 /* Use these for per-cpu local_t variables: on some archs they are
  * much more efficient than these naive implementations.  Note they take
  * a variable, not an address.
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
