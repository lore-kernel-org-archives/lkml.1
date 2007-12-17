Return-Path: <linux-kernel-owner+w=401wt.eu-S934306AbXLQAzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306AbXLQAzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761115AbXLQAy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:54:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:13168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765443AbXLQAyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:54:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tmW9RjkPPEwkBLJhIjaQU3yLaWvDDp2ASJ9J58oWZOIcE3D8btqF9t0UUvkVu3gUXuMDIeOgfOH6s5pBTSTz0YlhdnsBReMuSgQlYAErxb7A4BkvwX7yQCYYgoMyTHk2Qi7wuiYaYPceGksoMMsG4//9lyNhoCE31L+gyyH933A=
Subject: [PATCH 3/4] x86: Introduce asm helpers in local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 16:54:58 -0800
Message-Id: <1197852898.3749.98.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle the use of long on X86_32 and quad on X86_64

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/asm.h      |   12 ++++++++++++
 include/asm-x86/local.h    |    2 ++
 include/asm-x86/local_32.h |   18 +++++++++---------
 include/asm-x86/local_64.h |   18 +++++++++---------
 4 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
index 8661ae7..1a6980a 100644
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -8,6 +8,12 @@
 # define _ASM_ALIGN	" .balign 4 "
 # define _ASM_MOV_UL	" movl "
 
+# define _ASM_INC	" incl "
+# define _ASM_DEC	" decl "
+# define _ASM_ADD	" addl "
+# define _ASM_SUB	" subl "
+# define _ASM_XADD	" xaddl "
+
 #else
 /* 64 bits */
 
@@ -15,6 +21,12 @@
 # define _ASM_ALIGN	" .balign 8 "
 # define _ASM_MOV_UL	" movq "
 
+# define _ASM_INC	" incq "
+# define _ASM_DEC	" decq "
+# define _ASM_ADD	" addq "
+# define _ASM_SUB	" subq "
+# define _ASM_XADD	" xaddq "
+
 #endif /* CONFIG_X86_32 */
 
 #endif /* _ASM_X86_ASM_H */
diff --git a/include/asm-x86/local.h b/include/asm-x86/local.h
index 1e6b5af..194565b 100644
--- a/include/asm-x86/local.h
+++ b/include/asm-x86/local.h
@@ -2,8 +2,10 @@
 #define _ARCH_LOCAL_H
 
 #include <linux/percpu.h>
+
 #include <asm/system.h>
 #include <asm/atomic.h>
+#include <asm/asm.h>
 
 typedef struct
 {
diff --git a/include/asm-x86/local_32.h b/include/asm-x86/local_32.h
index f3bc4d9..33fa3ee 100644
--- a/include/asm-x86/local_32.h
+++ b/include/asm-x86/local_32.h
@@ -4,21 +4,21 @@
 static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
-		"incl %0"
+		_ASM_INC "%0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
-		"decl %0"
+		_ASM_DEC "%0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"addl %1,%0"
+		_ASM_ADD "%1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -26,7 +26,7 @@ static inline void local_add(long i, local_t *l)
 static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"subl %1,%0"
+		_ASM_SUB "%1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -45,7 +45,7 @@ static inline int local_sub_and_test(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"subl %2,%0; sete %1"
+		_ASM_SUB "%2,%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -64,7 +64,7 @@ static inline int local_dec_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"decl %0; sete %1"
+		_ASM_DEC "%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -83,7 +83,7 @@ static inline int local_inc_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"incl %0; sete %1"
+		_ASM_INC "%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -103,7 +103,7 @@ static inline int local_add_negative(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"addl %2,%0; sets %1"
+		_ASM_ADD "%2,%0; sets %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -127,7 +127,7 @@ static inline long local_add_return(long i, local_t *l)
 	/* Modern 486+ processor */
 	__i = i;
 	__asm__ __volatile__(
-		"xaddl %0, %1;"
+		_ASM_XADD "%0, %1;"
 		:"+r" (i), "+m" (l->a.counter)
 		: : "memory");
 	return i + __i;
diff --git a/include/asm-x86/local_64.h b/include/asm-x86/local_64.h
index 7808f53..91983e2 100644
--- a/include/asm-x86/local_64.h
+++ b/include/asm-x86/local_64.h
@@ -4,21 +4,21 @@
 static inline void local_inc(local_t *l)
 {
 	__asm__ __volatile__(
-		"incq %0"
+		_ASM_INC "%0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_dec(local_t *l)
 {
 	__asm__ __volatile__(
-		"decq %0"
+		_ASM_DEC "%0"
 		:"+m" (l->a.counter));
 }
 
 static inline void local_add(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"addq %1,%0"
+		_ASM_ADD "%1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -26,7 +26,7 @@ static inline void local_add(long i, local_t *l)
 static inline void local_sub(long i, local_t *l)
 {
 	__asm__ __volatile__(
-		"subq %1,%0"
+		_ASM_SUB "%1,%0"
 		:"+m" (l->a.counter)
 		:"ir" (i));
 }
@@ -45,7 +45,7 @@ static inline int local_sub_and_test(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"subq %2,%0; sete %1"
+		_ASM_SUB "%2,%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -64,7 +64,7 @@ static inline int local_dec_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"decq %0; sete %1"
+		_ASM_DEC "%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -83,7 +83,7 @@ static inline int local_inc_and_test(local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"incq %0; sete %1"
+		_ASM_INC "%0; sete %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		: : "memory");
 	return c != 0;
@@ -103,7 +103,7 @@ static inline int local_add_negative(long i, local_t *l)
 	unsigned char c;
 
 	__asm__ __volatile__(
-		"addq %2,%0; sets %1"
+		_ASM_ADD "%2,%0; sets %1"
 		:"+m" (l->a.counter), "=qm" (c)
 		:"ir" (i) : "memory");
 	return c;
@@ -120,7 +120,7 @@ static inline long local_add_return(long i, local_t *l)
 {
 	long __i = i;
 	__asm__ __volatile__(
-		"xaddq %0, %1;"
+		_ASM_XADD "%0, %1;"
 		:"+r" (i), "+m" (l->a.counter)
 		: : "memory");
 	return i + __i;
-- 
1.5.4.rc0.1083.gf568


