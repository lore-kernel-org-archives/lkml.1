Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZGAW5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZGAW5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbZGAW5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:57:22 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58771 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbZGAW5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:57:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19019.59848.918621.635117@cargo.ozlabs.ibm.com>
Date: Thu, 2 Jul 2009 08:57:12 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Code atomic(64)_read and atomic(64)_set in C not
   CPP [was Re: FRV: Implement atomic64_t]
In-Reply-To: <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
References: <20090701144913.GA28172@elte.hu>
	<20090701164700.29780.15103.stgit@warthog.procyon.org.uk>
	<alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occasionally we get bugs where atomic_read or atomic_set are used on
atomic64_t variables or vice versa.  These bugs don't generate
warnings on x86 because atomic_read and atomic_set are coded as macros
rather than C functions, so we don't get any type-checking on their
arguments; similarly for atomic64_read and atomic64_set in 64-bit
kernels.

This converts them to C functions so that the arguments are
type-checked and bugs like this will get caught more easily.
It also converts atomic_cmpxchg and atomic_xchg, and atomic64_cmpxchg
and atomic64_xchg on 64-bit, so we get type-checking on their
arguments too.

Compiling a typical 64-bit x86 config, this generates no new warnings,
and the vmlinux text is 86 bytes smaller.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Linus Torvalds writes:

> Btw, Ingo: I looked at the x86-32 versions to be sure, and noticed a 
> couple of buglets:
> 
>  - atomic64_xchg uses "atomic_read()". Sure, it happens to work, since 
>    the "atomic_read()" is not type-safe, and gets a non-atomic 64-bit 
>    read, but that looks really really bogus.
> 
>    It _should_ use __atomic64_read(), and the 64-bit versions should use a 
>    different counter name ("counter64"?) or we should use an inline 
>    function for atomic_read(), so that the type safety issue gets fixed.

I did this patch a few weeks ago (before the merge window) and sent it
to Ingo, Thomas & Peter, but it seems to have got lost.

 arch/x86/include/asm/atomic_32.h |   25 +++++++++++++++++-----
 arch/x86/include/asm/atomic_64.h |   42 ++++++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index aff9f1f..0c466cb 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -19,7 +19,10 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+static inline int atomic_read(const atomic_t *v)
+{
+	return v->counter;
+}
 
 /**
  * atomic_set - set atomic variable
@@ -28,7 +31,10 @@
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic_set(v, i)	(((v)->counter) = (i))
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
 
 /**
  * atomic_add - add integer to atomic variable
@@ -200,8 +206,15 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	return atomic_add_return(-i, v);
 }
 
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
 
 /**
  * atomic_add_unless - add unless the number is already a given value
@@ -306,7 +319,7 @@ atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
 	unsigned long long old_val;
 
 	do {
-		old_val = atomic_read(ptr);
+		old_val = __atomic64_read(ptr);
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
 
 	return old_val;
@@ -354,7 +367,7 @@ atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
 	unsigned long long old_val, new_val;
 
 	do {
-		old_val = atomic_read(ptr);
+		old_val = __atomic64_read(ptr);
 		new_val = old_val + delta;
 
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 8c21731..7d5282e 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -18,7 +18,10 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+static inline int atomic_read(const atomic_t *v)
+{
+	return v->counter;
+}
 
 /**
  * atomic_set - set atomic variable
@@ -27,7 +30,10 @@
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic_set(v, i)		(((v)->counter) = (i))
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
 
 /**
  * atomic_add - add integer to atomic variable
@@ -192,7 +198,10 @@ static inline int atomic_sub_return(int i, atomic_t *v)
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
  */
-#define atomic64_read(v)		((v)->counter)
+static inline long atomic64_read(const atomic64_t *v)
+{
+	return v->counter;
+}
 
 /**
  * atomic64_set - set atomic64 variable
@@ -201,7 +210,10 @@ static inline int atomic_sub_return(int i, atomic_t *v)
  *
  * Atomically sets the value of @v to @i.
  */
-#define atomic64_set(v, i)		(((v)->counter) = (i))
+static inline void atomic64_set(atomic64_t *v, long i)
+{
+	v->counter = i;
+}
 
 /**
  * atomic64_add - add integer to atomic64 variable
@@ -355,11 +367,25 @@ static inline long atomic64_sub_return(long i, atomic64_t *v)
 #define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
 #define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
 
-#define atomic64_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
-#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline long atomic64_xchg(atomic64_t *v, long new)
+{
+	return xchg(&v->counter, new);
+}
 
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
+static inline long atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline long atomic_xchg(atomic_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
 
 /**
  * atomic_add_unless - add unless the number is a given value
-- 
1.6.0.4

