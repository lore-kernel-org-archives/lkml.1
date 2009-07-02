Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbZGBHWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbZGBHWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZGBHWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:22:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:44602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbZGBHWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:22:04 -0400
Date: Thu, 2 Jul 2009 07:21:35 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <19019.59848.918621.635117@cargo.ozlabs.ibm.com>
References: <19019.59848.918621.635117@cargo.ozlabs.ibm.com>
Subject: [tip:x86/urgent] x86: Code atomic(64)_read and atomic(64)_set in C not CPP
Message-ID: <tip-584de8a67dcc5f70bd4fdb25ceaf9f840d57937b@git.kernel.org>
Git-Commit-ID: 584de8a67dcc5f70bd4fdb25ceaf9f840d57937b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Jul 2009 07:21:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  584de8a67dcc5f70bd4fdb25ceaf9f840d57937b
Gitweb:     http://git.kernel.org/tip/584de8a67dcc5f70bd4fdb25ceaf9f840d57937b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 2 Jul 2009 08:57:12 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Jul 2009 09:19:11 +0200

x86: Code atomic(64)_read and atomic(64)_set in C not CPP

Occasionally we get bugs where atomic_read or atomic_set are
used on atomic64_t variables or vice versa.  These bugs don't
generate warnings on x86 because atomic_read and atomic_set are
coded as macros rather than C functions, so we don't get any
type-checking on their arguments; similarly for atomic64_read
and atomic64_set in 64-bit kernels.

This converts them to C functions so that the arguments are
type-checked and bugs like this will get caught more easily. It
also converts atomic_cmpxchg and atomic_xchg, and
atomic64_cmpxchg and atomic64_xchg on 64-bit, so we get
type-checking on their arguments too.

Compiling a typical 64-bit x86 config, this generates no new
warnings, and the vmlinux text is 86 bytes smaller.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: akpm@linux-foundation.org
Cc: arnd@arndb.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <19019.59848.918621.635117@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |   25 +++++++++++++++++-----
 arch/x86/include/asm/atomic_64.h |   42 ++++++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 2503d4e..6e26c23 100644
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
@@ -305,7 +318,7 @@ atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
 	unsigned long long old_val;
 
 	do {
-		old_val = atomic_read(ptr);
+		old_val = __atomic64_read(ptr);
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
 
 	return old_val;
@@ -353,7 +366,7 @@ atomic64_add_return(unsigned long long delta, atomic64_t *ptr)
 	unsigned long long old_val, new_val;
 
 	do {
-		old_val = atomic_read(ptr);
+		old_val = __atomic64_read(ptr);
 		new_val = old_val + delta;
 
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 0d63602..d605dc2 100644
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
