Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbYK0KeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYK0KeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYK0KcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:24 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:37318 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYK0KcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:19 -0500
Message-Id: <20081127103129.621856716@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/60] Move stfle to header file.
Content-Disposition: inline; filename=106-stfle-mv.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

stfle will be needed by the ap_bus module to figure out wether the AP
queue adapter interruption facility is installed.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/system.h |   20 ++++++++++++++++++--
 arch/s390/kernel/setup.c       |   17 -----------------
 2 files changed, 18 insertions(+), 19 deletions(-)

Index: quilt-2.6/arch/s390/include/asm/system.h
===================================================================
--- quilt-2.6.orig/arch/s390/include/asm/system.h
+++ quilt-2.6/arch/s390/include/asm/system.h
@@ -12,6 +12,7 @@
 #define __ASM_SYSTEM_H
 
 #include <linux/kernel.h>
+#include <linux/errno.h>
 #include <asm/types.h>
 #include <asm/ptrace.h>
 #include <asm/setup.h>
@@ -413,8 +414,6 @@ __set_psw_mask(unsigned long mask)
 #define local_mcck_enable()  __set_psw_mask(psw_kernel_bits)
 #define local_mcck_disable() __set_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK)
 
-int stfle(unsigned long long *list, int doublewords);
-
 #ifdef CONFIG_SMP
 
 extern void smp_ctl_set_bit(int cr, int bit);
@@ -438,6 +437,23 @@ static inline unsigned int stfl(void)
 	return S390_lowcore.stfl_fac_list;
 }
 
+static inline int __stfle(unsigned long long *list, int doublewords)
+{
+	typedef struct { unsigned long long _[doublewords]; } addrtype;
+	register unsigned long __nr asm("0") = doublewords - 1;
+
+	asm volatile(".insn s,0xb2b00000,%0" /* stfle */
+		     : "=m" (*(addrtype *) list), "+d" (__nr) : : "cc");
+	return __nr + 1;
+}
+
+static inline int stfle(unsigned long long *list, int doublewords)
+{
+	if (!(stfl() & (1UL << 24)))
+		return -EOPNOTSUPP;
+	return __stfle(list, doublewords);
+}
+
 static inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
Index: quilt-2.6/arch/s390/kernel/setup.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/setup.c
+++ quilt-2.6/arch/s390/kernel/setup.c
@@ -651,23 +651,6 @@ setup_memory(void)
 #endif
 }
 
-static int __init __stfle(unsigned long long *list, int doublewords)
-{
-	typedef struct { unsigned long long _[doublewords]; } addrtype;
-	register unsigned long __nr asm("0") = doublewords - 1;
-
-	asm volatile(".insn s,0xb2b00000,%0" /* stfle */
-		     : "=m" (*(addrtype *) list), "+d" (__nr) : : "cc");
-	return __nr + 1;
-}
-
-int __init stfle(unsigned long long *list, int doublewords)
-{
-	if (!(stfl() & (1UL << 24)))
-		return -EOPNOTSUPP;
-	return __stfle(list, doublewords);
-}
-
 /*
  * Setup hardware capabilities.
  */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

