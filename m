Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbXHKAPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbXHKAPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbXHKAPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:15:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:47498 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbXHKAPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:15:40 -0400
From: Segher Boessenkool <segher@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: paulus@samba.org, Segher Boessenkool <segher@kernel.crashing.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Implement atomic{,64}_{read,write}() without volatile
Date: Sat, 11 Aug 2007 02:15:30 +0200
Message-Id: <11867913303733-git-send-email-segher@kernel.crashing.org>
X-Mailer: git-send-email 1.5.2.1.144.gabc40-dirty
Message-Id: <d6775e129db48371cdf86e94ddfaa1d15617bb8f.1186773842.git.segher@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead, use asm() like all other atomic operations already do.

Also use inline functions instead of macros; this actually
improves code generation (some code becomes a little smaller,
probably because of improved alias information -- just a few
hundred bytes total on a default kernel build, nothing shocking).

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
---
 include/asm-powerpc/atomic.h |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/asm-powerpc/atomic.h b/include/asm-powerpc/atomic.h
index c44810b..bc17506 100644
--- a/include/asm-powerpc/atomic.h
+++ b/include/asm-powerpc/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
 
-typedef struct { volatile int counter; } atomic_t;
+typedef struct { int counter; } atomic_t;
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>
@@ -15,8 +15,19 @@ typedef struct { volatile int counter; } atomic_t;
 
 #define ATOMIC_INIT(i)		{ (i) }
 
-#define atomic_read(v)		((v)->counter)
-#define atomic_set(v,i)		(((v)->counter) = (i))
+static __inline__ int atomic_read(const atomic_t *v)
+{
+	int t;
+
+	__asm__ __volatile__("lwz%U1%X1 %0,%1" : "=r"(t) : "m"(v->counter));
+
+	return t;
+}
+
+static __inline__ void atomic_set(atomic_t *v, int i)
+{
+	__asm__ __volatile__("stw%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
+}
 
 static __inline__ void atomic_add(int a, atomic_t *v)
 {
@@ -240,12 +251,23 @@ static __inline__ int atomic_dec_if_positive(atomic_t *v)
 
 #ifdef __powerpc64__
 
-typedef struct { volatile long counter; } atomic64_t;
+typedef struct { long counter; } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic64_read(v)	((v)->counter)
-#define atomic64_set(v,i)	(((v)->counter) = (i))
+static __inline__ long atomic64_read(const atomic_t *v)
+{
+	long t;
+
+	__asm__ __volatile__("ld%U1%X1 %0,%1" : "=r"(t) : "m"(v->counter));
+
+	return t;
+}
+
+static __inline__ void atomic64_set(atomic_t *v, long i)
+{
+	__asm__ __volatile__("std%U0%X0 %1,%0" : "=m"(v->counter) : "r"(i));
+}
 
 static __inline__ void atomic64_add(long a, atomic64_t *v)
 {
-- 
1.5.2.1.144.gabc40-dirty

