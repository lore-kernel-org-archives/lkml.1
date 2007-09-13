Return-Path: <linux-kernel-owner+w=401wt.eu-S1765546AbXIMFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765546AbXIMFtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXIMFtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:49:10 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:7653 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXIMFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:49:08 -0400
X-IronPort-AV: i="4.20,248,1186372800"; 
   d="scan'208"; a="39521678:sNHT53144287"
Subject: [GIT PULL] Blackfin arch bug fixing for 2.6.23-rc6
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 13 Sep 2007 13:48:29 +0800
Message-Id: <1189662509.24063.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 13 Sep 2007 05:49:07.0044 (UTC) FILETIME=[CC6F8240:01C7F5C9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/mach-common/pm.c              |    6 ++
 include/asm-blackfin/mach-bf561/cdefBF561.h |    4 +-
 include/asm-blackfin/string.h               |  129 +++++++++++++++++----------
 3 files changed, 88 insertions(+), 51 deletions(-)

Michael Hennerich (1):
      Blackfin arch: Update/Fix PM support add new pm_ops valid

Mike Frysinger (1):
      Blackfin arch: fix some bugs in lib/string.h functions found by our string testing modules

Robin Getz (1):
      Blackfin arch: fix the aliased write macros

diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 1772d8d..b103027 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -158,10 +158,16 @@ static int bfin_pm_finish(suspend_state_t state)
 	return 0;
 }
 
+static int bfin_pm_valid(suspend_state_t state)
+{
+	return (state == PM_SUSPEND_STANDBY);
+}
+
 struct pm_ops bfin_pm_ops = {
 	.prepare = bfin_pm_prepare,
 	.enter = bfin_pm_enter,
 	.finish = bfin_pm_finish,
+	.valid	= bfin_pm_valid,
 };
 
 static int __init bfin_pm_init(void)
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h b/include/asm-blackfin/mach-bf561/cdefBF561.h
index 6e87ab2..73d4d65 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -83,9 +83,9 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 
 /* For MMR's that are reserved on Core B, set up defines to better integrate with other ports */
 #define bfin_read_SWRST()                    bfin_read_SICA_SWRST()
-#define bfin_write_SWRST()                   bfin_write_SICA_SWRST()
+#define bfin_write_SWRST(val)                bfin_write_SICA_SWRST(val)
 #define bfin_read_SYSCR()                    bfin_read_SICA_SYSCR()
-#define bfin_write_SYSCR()                   bfin_write_SICA_SYSCR()
+#define bfin_write_SYSCR(val)                bfin_write_SICA_SYSCR(val)
 
 /* System Reset and Interrupt Controller registers for core A (0xFFC0 0100-0xFFC0 01FF) */
 #define bfin_read_SICA_SWRST()               bfin_read16(SICA_SWRST)
diff --git a/include/asm-blackfin/string.h b/include/asm-blackfin/string.h
index 6f1eb7d..e8ada91 100644
--- a/include/asm-blackfin/string.h
+++ b/include/asm-blackfin/string.h
@@ -9,13 +9,16 @@ extern inline char *strcpy(char *dest, const char *src)
 	char *xdest = dest;
 	char temp = 0;
 
-	__asm__ __volatile__
-	    ("1:\t%2 = B [%1++] (Z);\n\t"
-	     "B [%0++] = %2;\n\t"
-	     "CC = %2;\n\t"
-        "if cc jump 1b (bp);\n"
-	: "+&a" (dest), "+&a" (src), "=&d" (temp)
-	     ::"memory", "CC");
+	__asm__ __volatile__ (
+		"1:"
+		"%2 = B [%1++] (Z);"
+		"B [%0++] = %2;"
+		"CC = %2;"
+		"if cc jump 1b (bp);"
+		: "+&a" (dest), "+&a" (src), "=&d" (temp)
+		:
+		: "memory", "CC");
+
 	return xdest;
 }
 
@@ -28,37 +31,56 @@ extern inline char *strncpy(char *dest, const char *src, size_t n)
 	if (n == 0)
 		return xdest;
 
-	__asm__ __volatile__
-	    ("1:\t%3 = B [%1++] (Z);\n\t"
-	     "B [%0++] = %3;\n\t"
-	     "CC = %3;\n\t"
-	     "if ! cc jump 2f;\n\t"
-	     "%2 += -1;\n\t"
-	     "CC = %2 == 0;\n\t"
-	     "if ! cc jump 1b (bp);\n"
-        "2:\n"
-	: "+&a" (dest), "+&a" (src), "+&da" (n), "=&d" (temp)
-	     ::"memory", "CC");
+	__asm__ __volatile__ (
+		"1:"
+		"%3 = B [%1++] (Z);"
+		"B [%0++] = %3;"
+		"CC = %3;"
+		"if ! cc jump 2f;"
+		"%2 += -1;"
+		"CC = %2 == 0;"
+		"if ! cc jump 1b (bp);"
+		"jump 4f;"
+		"2:"
+		/* if src is shorter than n, we need to null pad bytes now */
+		"%3 = 0;"
+		"3:"
+		"%2 += -1;"
+		"CC = %2 == 0;"
+		"if cc jump 4f;"
+		"B [%0++] = %3;"
+		"jump 3b;"
+		"4:"
+		: "+&a" (dest), "+&a" (src), "+&da" (n), "=&d" (temp)
+		:
+		: "memory", "CC");
+
 	return xdest;
 }
 
 #define __HAVE_ARCH_STRCMP
 extern inline int strcmp(const char *cs, const char *ct)
 {
-	char __res1, __res2;
-
-	__asm__
-       ("1:\t%2 = B[%0++] (Z);\n\t" /* get *cs */
-		"%3 = B[%1++] (Z);\n\t"	/* get *ct */
-		"CC = %2 == %3;\n\t"	/* compare a byte */
-		"if ! cc jump 2f;\n\t"	/* not equal, break out */
-		"CC = %2;\n\t"	/* at end of cs? */
-		"if cc jump 1b (bp);\n\t"	/* no, keep going */
-		"jump.s 3f;\n"	/* strings are equal */
-		"2:\t%2 = %2 - %3;\n"	/* *cs - *ct */
-        "3:\n"
-	: "+&a" (cs), "+&a" (ct), "=&d" (__res1), "=&d" (__res2)
-      : :	"CC");
+	/* need to use int's here so the char's in the assembly don't get
+	 * sign extended incorrectly when we don't want them to be
+	 */
+	int __res1, __res2;
+
+	__asm__ __volatile__ (
+		"1:"
+		"%2 = B[%0++] (Z);"      /* get *cs */
+		"%3 = B[%1++] (Z);"      /* get *ct */
+		"CC = %2 == %3;"         /* compare a byte */
+		"if ! cc jump 2f;"       /* not equal, break out */
+		"CC = %2;"               /* at end of cs? */
+		"if cc jump 1b (bp);"    /* no, keep going */
+		"jump.s 3f;"             /* strings are equal */
+		"2:"
+		"%2 = %2 - %3;"          /* *cs - *ct */
+		"3:"
+		: "+&a" (cs), "+&a" (ct), "=&d" (__res1), "=&d" (__res2)
+		:
+		: "memory", "CC");
 
 	return __res1;
 }
@@ -66,26 +88,35 @@ extern inline int strcmp(const char *cs, const char *ct)
 #define __HAVE_ARCH_STRNCMP
 extern inline int strncmp(const char *cs, const char *ct, size_t count)
 {
-	char __res1, __res2;
+	/* need to use int's here so the char's in the assembly don't get
+	 * sign extended incorrectly when we don't want them to be
+	 */
+	int __res1, __res2;
 
 	if (!count)
 		return 0;
-	__asm__
-       ("1:\t%3 = B[%0++] (Z);\n\t"        /* get *cs */
-		"%4 = B[%1++] (Z);\n\t"	/* get *ct */
-		"CC = %3 == %4;\n\t"	/* compare a byte */
-		"if ! cc jump 3f;\n\t"	/* not equal, break out */
-		"CC = %3;\n\t"	/* at end of cs? */
-		"if ! cc jump 4f;\n\t"	/* yes, all done */
-		"%2 += -1;\n\t"	/* no, adjust count */
-	"CC = %2 == 0;\n\t"
-        "if ! cc jump 1b;\n"                 /* more to do, keep going */
-		"2:\t%3 = 0;\n\t"	/* strings are equal */
-        "jump.s    4f;\n"
-        "3:\t%3 = %3 - %4;\n"          /* *cs - *ct */
-        "4:"
-	: "+&a" (cs), "+&a" (ct), "+&da" (count), "=&d" (__res1), "=&d" (__res2)
-      : :	"CC");
+
+	__asm__ __volatile__ (
+		"1:"
+		"%3 = B[%0++] (Z);"      /* get *cs */
+		"%4 = B[%1++] (Z);"      /* get *ct */
+		"CC = %3 == %4;"         /* compare a byte */
+		"if ! cc jump 3f;"       /* not equal, break out */
+		"CC = %3;"               /* at end of cs? */
+		"if ! cc jump 4f;"       /* yes, all done */
+		"%2 += -1;"              /* no, adjust count */
+		"CC = %2 == 0;"
+		"if ! cc jump 1b;"       /* more to do, keep going */
+		"2:"
+		"%3 = 0;"                /* strings are equal */
+		"jump.s 4f;"
+		"3:"
+		"%3 = %3 - %4;"          /* *cs - *ct */
+		"4:"
+		: "+&a" (cs), "+&a" (ct), "+&da" (count), "=&d" (__res1), "=&d" (__res2)
+		:
+		: "memory", "CC");
+
 	return __res1;
 }
 
