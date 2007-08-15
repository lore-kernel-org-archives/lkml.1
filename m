Return-Path: <linux-kernel-owner+w=401wt.eu-S1765329AbXHPHSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765329AbXHPHSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756038AbXHPHSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:18:39 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:55923 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbXHPHSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:18:38 -0400
Message-Id: <20070815205708.687507636@breakpoint.cc>
References: <20070815205430.512612422@breakpoint.cc>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 22:54:32 +0200
From: Sebastian Siewior <sebastian@breakpoint.cc>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Chris Snook <csnook@redhat.com>
Subject: [patch 2/2] x86_64: use asm() like the other atomic operations already do.
Content-Disposition: inline; filename=atomic_x86_64.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As Segher pointed out, inline asm is better than the volatile casting all over
the place. From the PowerPC patch description:
 Also use inline functions instead of macros; this actually
 improves code generation (some code becomes a little smaller,
 probably because of improved alias information -- just a few
 hundred bytes total on a default kernel build, nothing shocking).

My config with march=k8 and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
  text    data     bss     dec     hex filename
  4002473  385936  474440 4862849  4a3381 atomic_normal/vmlinux
  4002587  385936  474440 4862963  4a33f3 atomic_inlineasm/vmlinux
  4003911  385936  474440 4864287  4a391f atomic_volatile/vmlinux
  4003959  385936  474440 4864335  4a394f atomic_volatile_inline/vmlinux

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
Cc: Andi Kleen <ak@suse.de>
Cc: Chris Snook <csnook@redhat.com>
--- a/include/asm-x86_64/atomic.h
+++ b/include/asm-x86_64/atomic.h
@@ -32,7 +32,16 @@ typedef struct { int counter; } atomic_t
  * 
  * Atomically reads the value of @v.
  */ 
-#define atomic_read(v)		((v)->counter)
+static inline int atomic_read(const atomic_t *v)
+{
+	int t;
+
+	asm volatile(
+			"movl %1, %0"
+			: "=r"(t)
+			: "m"(v->counter));
+	return t;
+}
 
 /**
  * atomic_set - set atomic variable
@@ -41,7 +50,13 @@ typedef struct { int counter; } atomic_t
  * 
  * Atomically sets the value of @v to @i.
  */ 
-#define atomic_set(v,i)		(((v)->counter) = (i))
+static inline void atomic_set(atomic_t *v, int i)
+{
+	asm volatile(
+			"movl %1, %0"
+			: "=m"(v->counter)
+			: "ir"(i));
+}
 
 /**
  * atomic_add - add integer to atomic variable
@@ -206,7 +221,7 @@ static __inline__ int atomic_sub_return(
 
 /* An 64bit atomic type */
 
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
@@ -217,7 +232,16 @@ typedef struct { volatile long counter; 
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
  */
-#define atomic64_read(v)		((v)->counter)
+static inline long atomic64_read(const atomic64_t *v)
+{
+	long t;
+
+	asm volatile(
+			"movq %1, %0"
+			: "=r"(t)
+			: "m"(v->counter));
+	return t;
+}
 
 /**
  * atomic64_set - set atomic64 variable
@@ -226,7 +250,13 @@ typedef struct { volatile long counter; 
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic64_set(v,i)		(((v)->counter) = (i))
+static inline void atomic64_set(atomic64_t *v, long i)
+{
+	asm volatile(
+			"movq %1, %0"
+			: "=m"(v->counter)
+			: "ir"(i));
+}
 
 /**
  * atomic64_add - add integer to atomic64 variable

-- 

