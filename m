Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZAFVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZAFVgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZAFVc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:28 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZAFVcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bfTK1u/HbX2LYPEuVxf2FJG7vuxwqaqboa/gOrYl5lgrc8Q3lxo4eOsCqV8yZ1LsP5
         owo1KJOVqIfHNZ3OMBDkMJUgdFwSyuE27Cf1fFLJH0m414mwoE8vmPnTZ5xBYxJV0Dsi
         F7S+tLeeVNVSYin9r5ZeVJHhBf27+MvrPiPB8=
Subject: [PATCH 14/23] arm: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:52 -0800
Message-Id: <1231277452.964.271.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/arm/include/asm/Kbuild      |    1 +
 arch/arm/include/asm/byteorder.h |   33 +------------------------
 arch/arm/include/asm/swab.h      |   50 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 73237bd..43b0b2b 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += hwcap.h
+unifdef-y += swab.h
diff --git a/arch/arm/include/asm/byteorder.h b/arch/arm/include/asm/byteorder.h
index 4fbfb22..c02b6fc 100644
--- a/arch/arm/include/asm/byteorder.h
+++ b/arch/arm/include/asm/byteorder.h
@@ -15,38 +15,7 @@
 #ifndef __ASM_ARM_BYTEORDER_H
 #define __ASM_ARM_BYTEORDER_H
 
-#include <linux/compiler.h>
-#include <asm/types.h>
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
-{
-	__u32 t;
-
-#ifndef __thumb__
-	if (!__builtin_constant_p(x)) {
-		/*
-		 * The compiler needs a bit of a hint here to always do the
-		 * right thing and not screw it up to different degrees
-		 * depending on the gcc version.
-		 */
-		asm ("eor\t%0, %1, %1, ror #16" : "=r" (t) : "r" (x));
-	} else
-#endif
-		t = x ^ ((x << 16) | (x >> 16)); /* eor r1,r0,r0,ror #16 */
-
-	x = (x << 24) | (x >> 8);		/* mov r0,r0,ror #8      */
-	t &= ~0x00FF0000;			/* bic r1,r1,#0x00FF0000 */
-	x ^= (t >> 8);				/* eor r0,r0,r1,lsr #8   */
-
-	return x;
-}
-
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
+#include <asm/swab.h>
 
 #ifdef __ARMEB__
 #include <linux/byteorder/big_endian.h>
diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
new file mode 100644
index 0000000..27a689b
--- /dev/null
+++ b/arch/arm/include/asm/swab.h
@@ -0,0 +1,50 @@
+/*
+ *  arch/arm/include/asm/byteorder.h
+ *
+ * ARM Endian-ness.  In little endian mode, the data bus is connected such
+ * that byte accesses appear as:
+ *  0 = d0...d7, 1 = d8...d15, 2 = d16...d23, 3 = d24...d31
+ * and word accesses (data or instruction) appear as:
+ *  d0...d31
+ *
+ * When in big endian mode, byte accesses appear as:
+ *  0 = d24...d31, 1 = d16...d23, 2 = d8...d15, 3 = d0...d7
+ * and word accesses (data or instruction) appear as:
+ *  d0...d31
+ */
+#ifndef __ASM_ARM_SWAB_H
+#define __ASM_ARM_SWAB_H
+
+#include <linux/compiler.h>
+#include <asm/types.h>
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	__u32 t;
+
+#ifndef __thumb__
+	if (!__builtin_constant_p(x)) {
+		/*
+		 * The compiler needs a bit of a hint here to always do the
+		 * right thing and not screw it up to different degrees
+		 * depending on the gcc version.
+		 */
+		asm ("eor\t%0, %1, %1, ror #16" : "=r" (t) : "r" (x));
+	} else
+#endif
+		t = x ^ ((x << 16) | (x >> 16)); /* eor r1,r0,r0,ror #16 */
+
+	x = (x << 24) | (x >> 8);		/* mov r0,r0,ror #8      */
+	t &= ~0x00FF0000;			/* bic r1,r1,#0x00FF0000 */
+	x ^= (t >> 8);				/* eor r0,r0,r1,lsr #8   */
+
+	return x;
+}
+#define __arch_swab32 __arch_swab32
+
+#endif
+
-- 
1.6.1.94.g9388


