Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbXLQAyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbXLQAyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbXLQAyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:54:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:13168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179AbXLQAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:54:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XICj84UL/pGLpYxFC9P3gP1trvhDjy5hBHi6bg8dICy6PduBkW9FclG+2yUGvxMGSBCYbLwGl0Y/IBx406RbqziO1V02R+B1ozJ4HDD4tLMXbRXmKAL2aJBSAlDGiAGkiC0Rv1Nqj+ACg8kQBzyzE3sNo+m9gXhUjTXHyAwtDBI=
Subject: [PATCH 1/4] x86: clean up local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 16:54:23 -0800
Message-Id: <1197852863.3749.94.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common prefix from both files moved to local.h

Change __inline__ to inline

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, this is the revised series with fixed asm incorporating
HPA's comments.

 include/asm-x86/local.h    |   19 +++++++++++++++++--
 include/asm-x86/local_32.h |   34 ++++++++++------------------------
 include/asm-x86/local_64.h |   25 ++++++-------------------
 3 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index f416893..1e6b5af 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -1,10 +1,25 @@
+#ifndef _ARCH_LOCAL_H
+#define _ARCH_LOCAL_H
+
+#include <linux/percpu.h>
+#include <asm/system.h>
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
 #ifdef CONFIG_X86_32
 # include "local_32.h"
 #else
 # include "local_64.h"
 #endif
-#ifndef _ARCH_LOCAL_H
-#define _ARCH_LOCAL_H
 
 #define local_inc_return(l)  (local_add_return(1,l))
 #define local_dec_return(l)  (local_sub_return(1,l))
diff --git a/include/asm-x86/local_32.h b/include/asm-x86/local_32.h
index 10ec0cf..f3bc4d9 100644
--- a/include/asm-x86/local_32.h
+++ b/include/asm-x86/local_32.h
@@ -1,35 +1,21 @@
 #ifndef _ARCH_I386_LOCAL_H
 #define _ARCH_I386_LOCAL_H
 
-#include <linux/percpu.h>
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-
-static __inline__ void local_inc(local_t *l)
+static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
 		"incl %0"
 		:"+m" (l->a.counter));
 }
 
-static __inline__ void local_dec(local_t *l)
+static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
 		"decl %0"
 		:"+m" (l->a.counter));
 }
 
-static __inline__ void local_add(long i, local_t *l)
+static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
 		"addl %1,%0"
@@ -37,7 +23,7 @@ static __inline__ void local_add(long i, local_t *l)
 		:"ir" (i));
 }
 
-static __inline__ void local_sub(long i, local_t *l)
+static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
 		"subl %1,%0"
@@ -54,7 +40,7 @@ static __inline__ void local_sub(long i, local_t *l)
  * true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int local_sub_and_test(long i, local_t *l)
+static inline int local_sub_and_test(long i, local_t *l)
 {
 	unsigned char c;
 
@@ -73,7 +59,7 @@ static __inline__ int local_sub_and_test(long i, local_t *l)
  * returns true if the result is 0, or false for all other
  * cases.
  */
-static __inline__ int local_dec_and_test(local_t *l)
+static inline int local_dec_and_test(local_t *l)
 {
 	unsigned char c;
 
@@ -92,7 +78,7 @@ static __inline__ int local_dec_and_test(local_t *l)
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int local_inc_and_test(local_t *l)
+static inline int local_inc_and_test(local_t *l)
 {
 	unsigned char c;
 
@@ -112,7 +98,7 @@ static __inline__ int local_inc_and_test(local_t *l)
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-static __inline__ int local_add_negative(long i, local_t *l)
+static inline int local_add_negative(long i, local_t *l)
 {
 	unsigned char c;
 
@@ -130,7 +116,7 @@ static __inline__ int local_add_negative(long i, local_t *l)
  *
  * Atomically adds @i to @l and returns @i + @l
  */
-static __inline__ long local_add_return(long i, local_t *l)
+static inline long local_add_return(long i, local_t *l)
 {
 	long __i;
 #ifdef CONFIG_M386
@@ -156,7 +142,7 @@ no_xadd: /* Legacy 386 processor */
 #endif
 }
 
-static __inline__ long local_sub_return(long i, local_t *l)
+static inline long local_sub_return(long i, local_t *l)
 {
 	return local_add_return(-i,l);
 }
diff --git a/include/asm-x86/local_64.h b/include/asm-x86/local_64.h
index ae9a573..da61076 100644
--- a/include/asm-x86/local_64.h
+++ b/include/asm-x86/local_64.h
@@ -1,19 +1,6 @@
 #ifndef _ARCH_X8664_LOCAL_H
 #define _ARCH_X8664_LOCAL_H
 
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-
 static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
@@ -55,7 +42,7 @@ static inline void local_sub(long i, local_t *l)
  * true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int local_sub_and_test(long i, local_t *l)
+static inline int local_sub_and_test(long i, local_t *l)
 {
 	unsigned char c;
 
@@ -74,7 +61,7 @@ static __inline__ int local_sub_and_test(long i, local_t *l)
  * returns true if the result is 0, or false for all other
  * cases.
  */
-static __inline__ int local_dec_and_test(local_t *l)
+static inline int local_dec_and_test(local_t *l)
 {
 	unsigned char c;
 
@@ -93,7 +80,7 @@ static __inline__ int local_dec_and_test(local_t *l)
  * and returns true if the result is zero, or false for all
  * other cases.
  */
-static __inline__ int local_inc_and_test(local_t *l)
+static inline int local_inc_and_test(local_t *l)
 {
 	unsigned char c;
 
@@ -113,7 +100,7 @@ static __inline__ int local_inc_and_test(local_t *l)
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-static __inline__ int local_add_negative(long i, local_t *l)
+static inline int local_add_negative(long i, local_t *l)
 {
 	unsigned char c;
 
@@ -131,7 +118,7 @@ static __inline__ int local_add_negative(long i, local_t *l)
  *
  * Atomically adds @i to @l and returns @i + @l
  */
-static __inline__ long local_add_return(long i, local_t *l)
+static inline long local_add_return(long i, local_t *l)
 {
 	long __i = i;
 	__asm__ __volatile__(
@@ -141,7 +128,7 @@ static __inline__ long local_add_return(long i, local_t *l)
 	return i + __i;
 }
 
-static __inline__ long local_sub_return(long i, local_t *l)
+static inline long local_sub_return(long i, local_t *l)
 {
 	return local_add_return(-i,l);
 }
-- 
1.5.4.rc0.1083.gf568


