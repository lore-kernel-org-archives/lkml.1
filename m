Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbXHVMfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbXHVMfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbXHVMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:33:13 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:40050 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659AbXHVMc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:32:59 -0400
Message-Id: <20070822123644.236127458@de.ibm.com>
References: <20070822123603.501231302@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 14:36:13 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/10] Change atomic_read/set to inline functions with barrier semantics.
Content-Disposition: inline; filename=010-atomic_t.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

After doing some tests this seems to be the best variant for s390 and
should be correct as well. With gcc 4.2.1 we get the following kernel
image sizes using the default configuration:

atomic_t type volatile, atomic_read/set defines   5311824 bytes
atomic_t type int, atomic_read/set defines        5270864 bytes
atomic_t type int, atomic_read/set inline asm     5279056 bytes
atomic_t type int, atomic_read/set inline barrier 5270864 bytes

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/atomic.h |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

Index: quilt-2.6/include/asm-s390/atomic.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/atomic.h
+++ quilt-2.6/include/asm-s390/atomic.h
@@ -67,8 +67,17 @@ typedef struct {
 
 #endif /* __GNUC__ */
 
-#define atomic_read(v)          ((v)->counter)
-#define atomic_set(v,i)         (((v)->counter) = (i))
+static inline int atomic_read(const atomic_t *v)
+{
+	barrier();
+	return v->counter;
+}
+
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+	barrier();
+}
 
 static __inline__ int atomic_add_return(int i, atomic_t * v)
 {
@@ -182,8 +191,17 @@ typedef struct {
 
 #endif /* __GNUC__ */
 
-#define atomic64_read(v)          ((v)->counter)
-#define atomic64_set(v,i)         (((v)->counter) = (i))
+static inline long long atomic64_read(const atomic64_t *v)
+{
+	barrier();
+	return v->counter;
+}
+
+static inline void atomic64_set(atomic64_t *v, long long i)
+{
+	v->counter = i;
+	barrier();
+}
 
 static __inline__ long long atomic64_add_return(long long i, atomic64_t * v)
 {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

