Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZGCMoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZGCMoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbZGCMo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:44:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbZGCMo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:44:27 -0400
Date: Fri, 3 Jul 2009 12:42:53 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
       arnd@arndb.de, dhowells@redhat.com, fweisbec@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Subject: [tip:perfcounters/urgent] x86: atomic64: Move the 32-bit atomic64_t implementation to a .c file
Message-ID: <tip-b7882b7c65abb00194bdb3d4a22d27d70fcc59ba@git.kernel.org>
Git-Commit-ID: b7882b7c65abb00194bdb3d4a22d27d70fcc59ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 12:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7882b7c65abb00194bdb3d4a22d27d70fcc59ba
Gitweb:     http://git.kernel.org/tip/b7882b7c65abb00194bdb3d4a22d27d70fcc59ba
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 3 Jul 2009 13:26:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 13:26:39 +0200

x86: atomic64: Move the 32-bit atomic64_t implementation to a .c file

Linus noted that the atomic64_t primitives are all inlines
currently which is crazy because these functions have a large
register footprint anyway.

Move them to a separate file: arch/x86/lib/atomic64_32.c

Also, while at it, rename all uses of 'unsigned long long' to
the much shorter u64.

This makes the appearance of the prototypes a lot nicer - and
it also uncovered a few bugs where (yet unused) API variants
had 'long' as their return type instead of u64.

[ More intrusive changes are not yet done in this patch. ]

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |  137 ++++--------------------
 arch/x86/lib/Makefile            |    1 +
 arch/x86/lib/atomic64_32.c       |  216 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 237 insertions(+), 117 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index ae0fbb5..311a43e 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -250,7 +250,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 /* An 64bit atomic type */
 
 typedef struct {
-	unsigned long long __aligned(8) counter;
+	u64 __aligned(8) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(val)	{ (val) }
@@ -264,31 +264,7 @@ typedef struct {
  */
 #define __atomic64_read(ptr)		((ptr)->counter)
 
-static inline unsigned long long
-cmpxchg8b(unsigned long long *ptr, unsigned long long old, unsigned long long new)
-{
-	asm volatile(
-
-		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
-
-		     :		"=A" (old)
-
-		     : [ptr]	"D" (ptr),
-				"A" (old),
-				"b" (ll_low(new)),
-				"c" (ll_high(new))
-
-		     : "memory");
-
-	return old;
-}
-
-static inline unsigned long long
-atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
-		 unsigned long long new_val)
-{
-	return cmpxchg8b(&ptr->counter, old_val, new_val);
-}
+extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
 
 /**
  * atomic64_xchg - xchg atomic64 variable
@@ -298,18 +274,7 @@ atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
  * Atomically xchgs the value of @ptr to @new_val and returns
  * the old value.
  */
-
-static inline unsigned long long
-atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
-{
-	unsigned long long old_val;
-
-	do {
-		old_val = atomic_read(ptr);
-	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
-
-	return old_val;
-}
+extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
 
 /**
  * atomic64_set - set atomic64 variable
@@ -318,10 +283,7 @@ atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
  *
  * Atomically sets the value of @ptr to @new_val.
  */
-static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
-{
-	atomic64_xchg(ptr, new_val);
-}
+extern void atomic64_set(atomic64_t *ptr, u64 new_val);
 
 /**
  * atomic64_read - read atomic64 variable
@@ -329,16 +291,7 @@ static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
  *
  * Atomically reads the value of @ptr and returns it.
  */
-static inline unsigned long long atomic64_read(atomic64_t *ptr)
-{
-	unsigned long long curr_val;
-
-	do {
-		curr_val = __atomic64_read(ptr);
-	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
-
-	return curr_val;
-}
+extern u64 atomic64_read(atomic64_t *ptr);
 
 /**
  * atomic64_add_return - add and return
@@ -347,34 +300,14 @@ static inline unsigned long long atomic64_read(atomic64_t *ptr)
  *
  * Atomically adds @delta to @ptr and returns @delta + *@ptr
  */
-static inline unsigned long long
-atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
-{
-	unsigned long long old_val, new_val;
-
-	do {
-		old_val = atomic_read(ptr);
-		new_val = old_val + delta;
-
-	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
-
-	return new_val;
-}
-
-static inline long atomic64_sub_return(unsigned long long delta, atomic64_t *ptr)
-{
-	return atomic64_add_return(-delta, ptr);
-}
+extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
 
-static inline long atomic64_inc_return(atomic64_t *ptr)
-{
-	return atomic64_add_return(1, ptr);
-}
-
-static inline long atomic64_dec_return(atomic64_t *ptr)
-{
-	return atomic64_sub_return(1, ptr);
-}
+/*
+ * Other variants with different arithmetic operators:
+ */
+extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
+extern u64 atomic64_inc_return(atomic64_t *ptr);
+extern u64 atomic64_dec_return(atomic64_t *ptr);
 
 /**
  * atomic64_add - add integer to atomic64 variable
@@ -383,10 +316,7 @@ static inline long atomic64_dec_return(atomic64_t *ptr)
  *
  * Atomically adds @delta to @ptr.
  */
-static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
-{
-	atomic64_add_return(delta, ptr);
-}
+extern void atomic64_add(u64 delta, atomic64_t *ptr);
 
 /**
  * atomic64_sub - subtract the atomic64 variable
@@ -395,10 +325,7 @@ static inline void atomic64_add(unsigned long long delta, atomic64_t *ptr)
  *
  * Atomically subtracts @delta from @ptr.
  */
-static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
-{
-	atomic64_add(-delta, ptr);
-}
+extern void atomic64_sub(u64 delta, atomic64_t *ptr);
 
 /**
  * atomic64_sub_and_test - subtract value from variable and test result
@@ -409,13 +336,7 @@ static inline void atomic64_sub(unsigned long long delta, atomic64_t *ptr)
  * true if the result is zero, or false for all
  * other cases.
  */
-static inline int
-atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
-{
-	unsigned long long old_val = atomic64_sub_return(delta, ptr);
-
-	return old_val == 0;
-}
+extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
 
 /**
  * atomic64_inc - increment atomic64 variable
@@ -423,10 +344,7 @@ atomic64_sub_and_test(unsigned long long delta, atomic64_t *ptr)
  *
  * Atomically increments @ptr by 1.
  */
-static inline void atomic64_inc(atomic64_t *ptr)
-{
-	atomic64_add(1, ptr);
-}
+extern void atomic64_inc(atomic64_t *ptr);
 
 /**
  * atomic64_dec - decrement atomic64 variable
@@ -434,10 +352,7 @@ static inline void atomic64_inc(atomic64_t *ptr)
  *
  * Atomically decrements @ptr by 1.
  */
-static inline void atomic64_dec(atomic64_t *ptr)
-{
-	atomic64_sub(1, ptr);
-}
+extern void atomic64_dec(atomic64_t *ptr);
 
 /**
  * atomic64_dec_and_test - decrement and test
@@ -447,10 +362,7 @@ static inline void atomic64_dec(atomic64_t *ptr)
  * returns true if the result is 0, or false for all other
  * cases.
  */
-static inline int atomic64_dec_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(1, ptr);
-}
+extern int atomic64_dec_and_test(atomic64_t *ptr);
 
 /**
  * atomic64_inc_and_test - increment and test
@@ -460,10 +372,7 @@ static inline int atomic64_dec_and_test(atomic64_t *ptr)
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-static inline int atomic64_inc_and_test(atomic64_t *ptr)
-{
-	return atomic64_sub_and_test(-1, ptr);
-}
+extern int atomic64_inc_and_test(atomic64_t *ptr);
 
 /**
  * atomic64_add_negative - add and test if negative
@@ -474,13 +383,7 @@ static inline int atomic64_inc_and_test(atomic64_t *ptr)
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-static inline int
-atomic64_add_negative(unsigned long long delta, atomic64_t *ptr)
-{
-	long long old_val = atomic64_add_return(delta, ptr);
-
-	return old_val < 0;
-}
+extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
 
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f9d3563..c3c657c 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -10,6 +10,7 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 
 ifeq ($(CONFIG_X86_32),y)
+        lib-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
new file mode 100644
index 0000000..d21e725
--- /dev/null
+++ b/arch/x86/lib/atomic64_32.c
@@ -0,0 +1,216 @@
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+#include <asm/cmpxchg.h>
+#include <asm/atomic.h>
+
+static inline u64 cmpxchg8b(u64 *ptr, u64 old, u64 new)
+{
+	asm volatile(
+
+		LOCK_PREFIX "cmpxchg8b (%[ptr])\n"
+
+		     :		"=A" (old)
+
+		     : [ptr]	"D" (ptr),
+				"A" (old),
+				"b" (ll_low(new)),
+				"c" (ll_high(new))
+
+		     : "memory");
+
+	return old;
+}
+
+u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val)
+{
+	return cmpxchg8b(&ptr->counter, old_val, new_val);
+}
+
+/**
+ * atomic64_xchg - xchg atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically xchgs the value of @ptr to @new_val and returns
+ * the old value.
+ */
+
+u64 atomic64_xchg(atomic64_t *ptr, u64 new_val)
+{
+	u64 old_val;
+
+	do {
+		old_val = atomic_read(ptr);
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+
+	return old_val;
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+void atomic64_set(atomic64_t *ptr, u64 new_val)
+{
+	atomic64_xchg(ptr, new_val);
+}
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ *
+ * Atomically reads the value of @ptr and returns it.
+ */
+u64 atomic64_read(atomic64_t *ptr)
+{
+	u64 curr_val;
+
+	do {
+		curr_val = __atomic64_read(ptr);
+	} while (atomic64_cmpxchg(ptr, curr_val, curr_val) != curr_val);
+
+	return curr_val;
+}
+
+/**
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+u64 atomic64_add_return(u64 delta, atomic64_t *ptr)
+{
+	u64 old_val, new_val;
+
+	do {
+		old_val = atomic_read(ptr);
+		new_val = old_val + delta;
+
+	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+
+	return new_val;
+}
+
+u64 atomic64_sub_return(u64 delta, atomic64_t *ptr)
+{
+	return atomic64_add_return(-delta, ptr);
+}
+
+u64 atomic64_inc_return(atomic64_t *ptr)
+{
+	return atomic64_add_return(1, ptr);
+}
+
+u64 atomic64_dec_return(atomic64_t *ptr)
+{
+	return atomic64_sub_return(1, ptr);
+}
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+void atomic64_add(u64 delta, atomic64_t *ptr)
+{
+	atomic64_add_return(delta, ptr);
+}
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+void atomic64_sub(u64 delta, atomic64_t *ptr)
+{
+	atomic64_add(-delta, ptr);
+}
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+int atomic64_sub_and_test(u64 delta, atomic64_t *ptr)
+{
+	u64 old_val = atomic64_sub_return(delta, ptr);
+
+	return old_val == 0;
+}
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+void atomic64_inc(atomic64_t *ptr)
+{
+	atomic64_add(1, ptr);
+}
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+void atomic64_dec(atomic64_t *ptr)
+{
+	atomic64_sub(1, ptr);
+}
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+int atomic64_dec_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(1, ptr);
+}
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+int atomic64_inc_and_test(atomic64_t *ptr)
+{
+	return atomic64_sub_and_test(-1, ptr);
+}
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+int atomic64_add_negative(u64 delta, atomic64_t *ptr)
+{
+	long long old_val = atomic64_add_return(delta, ptr);
+
+	return old_val < 0;
+}
