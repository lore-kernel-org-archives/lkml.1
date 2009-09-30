Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZI3J4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZI3J4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZI3J4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbZI3J4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:56:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix kernel build failures when using gcc-4.x
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Mark Salter <msalter@redhat.com>, David Howells <dhowells@redhat.com>
Date: Wed, 30 Sep 2009 10:56:04 +0100
Message-ID: <20090930095604.25744.73401.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Fix some build failures when using gcc-4.x for MN10300.

Firstly, __get_user() fails to build because the pointer points to a const and
__gu_val ends up being read-only:

In file included from include/linux/mempolicy.h:62,
                 from init/main.c:50:
include/linux/pagemap.h: In function 'fault_in_pages_readable':
include/linux/pagemap.h:394: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:394: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:394: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:400: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:400: error: read-only variable '__gu_val' used as 'asm' output
include/linux/pagemap.h:400: error: read-only variable '__gu_val' used as 'asm' output
make[1]: *** [init/main.o] Error 1

Secondly, gcc-4 doesn't allow casts of lvalues:

  UPD     include/linux/compile.h
arch/mn10300/kernel/rtc.c: In function 'calibrate_clock':
arch/mn10300/kernel/rtc.c:170: error: lvalue required as left operand of assignment
arch/mn10300/kernel/rtc.c:172: error: lvalue required as left operand of assignment
make[1]: *** [arch/mn10300/kernel/rtc.o] Error 1

These are seen with gcc 4.2.1.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/uaccess.h             |   73 +++++++++++++-----------
 arch/mn10300/unit-asb2303/include/unit/clock.h |    6 +-
 arch/mn10300/unit-asb2305/include/unit/clock.h |    6 +-
 3 files changed, 45 insertions(+), 40 deletions(-)


diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 8a3a4dd..167e10f 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -129,42 +129,47 @@ extern int fixup_exception(struct pt_regs *regs);
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct *)(x))
 
-#define __get_user_nocheck(x, ptr, size)	\
-({						\
-	__typeof(*(ptr)) __gu_val;		\
-	unsigned long __gu_addr;		\
-	int __gu_err;				\
-	__gu_addr = (unsigned long) (ptr);	\
-	switch (size) {				\
-	case 1:  __get_user_asm("bu"); break;	\
-	case 2:  __get_user_asm("hu"); break;	\
-	case 4:  __get_user_asm(""  ); break;	\
-	default: __get_user_unknown(); break;	\
-	}					\
-	x = (__typeof__(*(ptr))) __gu_val;	\
-	__gu_err;				\
+#define __get_user_nocheck(x, ptr, size)				\
+({									\
+	unsigned long __gu_addr;					\
+	int __gu_err;							\
+	__gu_addr = (unsigned long) (ptr);				\
+	switch (size) {							\
+	case 1: {							\
+		unsigned char __gu_val;					\
+		__get_user_asm("bu");					\
+		(x) = *(__force __typeof__(*(ptr))*) &__gu_val;		\
+		break;							\
+	}								\
+	case 2: {							\
+		unsigned short __gu_val;				\
+		__get_user_asm("hu");					\
+		(x) = *(__force __typeof__(*(ptr))*) &__gu_val;		\
+		break;							\
+	}								\
+	case 4: {							\
+		unsigned int __gu_val;					\
+		__get_user_asm("");					\
+		(x) = *(__force __typeof__(*(ptr))*) &__gu_val;		\
+		break;							\
+	}								\
+	default:							\
+		__get_user_unknown();					\
+		break;							\
+	}								\
+	__gu_err;							\
 })
 
-#define __get_user_check(x, ptr, size)			\
-({							\
-	__typeof__(*(ptr)) __gu_val;			\
-	unsigned long __gu_addr;			\
-	int __gu_err;					\
-	__gu_addr = (unsigned long) (ptr);		\
-	if (likely(__access_ok(__gu_addr,size))) {	\
-		switch (size) {				\
-		case 1:  __get_user_asm("bu"); break;	\
-		case 2:  __get_user_asm("hu"); break;	\
-		case 4:  __get_user_asm(""  ); break;	\
-		default: __get_user_unknown(); break;	\
-		}					\
-	}						\
-	else {						\
-		__gu_err = -EFAULT;			\
-		__gu_val = 0;				\
-	}						\
-	x = (__typeof__(*(ptr))) __gu_val;		\
-	__gu_err;					\
+#define __get_user_check(x, ptr, size)					\
+({									\
+	int _e;								\
+	if (likely(__access_ok((unsigned long) (ptr), (size))))		\
+		_e = __get_user_nocheck((x), (ptr), (size));		\
+	else {								\
+		_e = -EFAULT;						\
+		(x) = (__typeof__(x))0;					\
+	}								\
+	_e;								\
 })
 
 #define __get_user_asm(INSN)					\
diff --git a/arch/mn10300/unit-asb2303/include/unit/clock.h b/arch/mn10300/unit-asb2303/include/unit/clock.h
index 8b450e9..2a0bf79 100644
--- a/arch/mn10300/unit-asb2303/include/unit/clock.h
+++ b/arch/mn10300/unit-asb2303/include/unit/clock.h
@@ -20,9 +20,9 @@ extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
 extern unsigned long mn10300_iobclk;
 extern unsigned long mn10300_tsc_per_HZ;
 
-#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+#define MN10300_IOCLK		mn10300_ioclk
 /* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
+/* #define MN10300_IOBCLK	mn10300_iobclk */
 
 #else /* !CONFIG_MN10300_RTC */
 
@@ -35,7 +35,7 @@ extern unsigned long mn10300_tsc_per_HZ;
 #define MN10300_TSCCLK		MN10300_IOCLK
 
 #ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#define MN10300_TSC_PER_HZ	mn10300_tsc_per_HZ
 #else /* !CONFIG_MN10300_RTC */
 #define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
 #endif /* !CONFIG_MN10300_RTC */
diff --git a/arch/mn10300/unit-asb2305/include/unit/clock.h b/arch/mn10300/unit-asb2305/include/unit/clock.h
index 7d51484..67be3f2 100644
--- a/arch/mn10300/unit-asb2305/include/unit/clock.h
+++ b/arch/mn10300/unit-asb2305/include/unit/clock.h
@@ -20,9 +20,9 @@ extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
 extern unsigned long mn10300_iobclk;
 extern unsigned long mn10300_tsc_per_HZ;
 
-#define MN10300_IOCLK		((unsigned long)mn10300_ioclk)
+#define MN10300_IOCLK		mn10300_ioclk
 /* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	((unsigned long)mn10300_iobclk) */
+/* #define MN10300_IOBCLK	mn10300_iobclk */
 
 #else /* !CONFIG_MN10300_RTC */
 
@@ -35,7 +35,7 @@ extern unsigned long mn10300_tsc_per_HZ;
 #define MN10300_TSCCLK		MN10300_IOCLK
 
 #ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	((unsigned long)mn10300_tsc_per_HZ)
+#define MN10300_TSC_PER_HZ	mn10300_tsc_per_HZ
 #else /* !CONFIG_MN10300_RTC */
 #define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
 #endif /* !CONFIG_MN10300_RTC */

