Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZAFVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZAFVdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZAFVcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZAFVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=S5fz17//yS5EoUw+hw0okbtNCUaW5pw3ExIDVtxfdjOJK0XaABSut12cdRhC1PHmpS
         CdP05eP4Auj0QmfMjI4EvCTmA5AKc443uPK2YzMIK188Nj8+jRJ21veD4NJqAVf1iNVb
         G8h31pcX+qNaWOVPaydHRMDGrvSzOquml2sqU=
Subject: [PATCH 04/23] mips: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "ralf@linux-mips.org" <ralf@linux-mips.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:46 -0800
Message-Id: <1231277446.964.261.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mips/include/asm/Kbuild      |    1 +
 arch/mips/include/asm/byteorder.h |   52 ++---------------------------------
 arch/mips/include/asm/swab.h      |   55 +++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 49 deletions(-)

diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 7897f05..023866c 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += cachectl.h sgidefs.h sysmips.h
+header-y += swab.h
diff --git a/arch/mips/include/asm/byteorder.h b/arch/mips/include/asm/byteorder.h
index 33790b9..607b718 100644
--- a/arch/mips/include/asm/byteorder.h
+++ b/arch/mips/include/asm/byteorder.h
@@ -8,60 +8,14 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <linux/compiler.h>
-#include <asm/types.h>
+#include <asm/swab.h>
 
 #if defined(__MIPSEB__)
-# define __BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
 #elif defined(__MIPSEL__)
-# define __LITTLE_ENDIAN
+#include <linux/byteorder/little_endian.h>
 #else
 # error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
 #endif
 
-#define __SWAB_64_THRU_32__
-
-#ifdef CONFIG_CPU_MIPSR2
-
-static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
-{
-	__asm__(
-	"	wsbh	%0, %1			\n"
-	: "=r" (x)
-	: "r" (x));
-
-	return x;
-}
-#define __arch_swab16 __arch_swab16
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
-{
-	__asm__(
-	"	wsbh	%0, %1			\n"
-	"	rotr	%0, %0, 16		\n"
-	: "=r" (x)
-	: "r" (x));
-
-	return x;
-}
-#define __arch_swab32 __arch_swab32
-
-#ifdef CONFIG_CPU_MIPS64_R2
-static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
-{
-	__asm__(
-	"	dsbh	%0, %1\n"
-	"	dshd	%0, %0"
-	: "=r" (x)
-	: "r" (x));
-
-	return x;
-}
-#define __arch_swab64 __arch_swab64
-#endif /* CONFIG_CPU_MIPS64_R2 */
-
-#endif /* CONFIG_CPU_MIPSR2 */
-
-#include <linux/byteorder.h>
-
 #endif /* _ASM_BYTEORDER_H */
diff --git a/arch/mips/include/asm/swab.h b/arch/mips/include/asm/swab.h
new file mode 100644
index 0000000..88f1f7d
--- /dev/null
+++ b/arch/mips/include/asm/swab.h
@@ -0,0 +1,55 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1996, 99, 2003 by Ralf Baechle
+ */
+#ifndef _ASM_SWAB_H
+#define _ASM_SWAB_H
+
+#include <linux/compiler.h>
+#include <asm/types.h>
+
+#define __SWAB_64_THRU_32__
+
+#ifdef CONFIG_CPU_MIPSR2
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+	__asm__(
+	"	wsbh	%0, %1			\n"
+	: "=r" (x)
+	: "r" (x));
+
+	return x;
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	__asm__(
+	"	wsbh	%0, %1			\n"
+	"	rotr	%0, %0, 16		\n"
+	: "=r" (x)
+	: "r" (x));
+
+	return x;
+}
+#define __arch_swab32 __arch_swab32
+
+#ifdef CONFIG_CPU_MIPS64_R2
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
+{
+	__asm__(
+	"	dsbh	%0, %1\n"
+	"	dshd	%0, %0"
+	: "=r" (x)
+	: "r" (x));
+
+	return x;
+}
+#define __arch_swab64 __arch_swab64
+#endif /* CONFIG_CPU_MIPS64_R2 */
+#endif /* CONFIG_CPU_MIPSR2 */
+#endif /* _ASM_SWAB_H */
-- 
1.6.1.94.g9388


