Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbZAOHiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbZAOHiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762315AbZAOHgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:36:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:29557 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762299AbZAOHgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JFBirMuZVUpyJWNJG0MB8CxDzRIstB8o8WHBwBJxnwoeOF4P8aAXNFKP89V/4cCqa/
         ZOudRHHnVL7HyBqGenvDDTAl/iwnHrxJv/KxVD9QjOeooXglF5OtBIcMoxF1vGTse3O+
         ffmEt5Vj5lWpzpxRWoFiMcCTdWl8vpsBpueQo=
Subject: [PATCH 6/7] unaligned: wire up ARM arch overrides for unaligned
 access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 23:36:29 -0800
Message-Id: <1232004989.5819.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add byteshifting arch overrides to avoid any functional changes
when using the new common header.  At a later time this arch should
be able to use the common header directly, but this has not been
proven yet.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Russell, while this looks like a lot of churn, it is function-equivalent
to the existing situation. It essentially open-codes the [lb]e_byteshift.h
as arch-overrides.  A future patch will move over to the generic
packed-struct version, but I didn't want to introduce behavior changes
while doing the code consolidation.

 arch/arm/include/asm/unaligned.h |   81 ++++++++++++++++++++++++++++++++------
 1 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/unaligned.h b/arch/arm/include/asm/unaligned.h
index 44593a8..1510c8b 100644
--- a/arch/arm/include/asm/unaligned.h
+++ b/arch/arm/include/asm/unaligned.h
@@ -1,19 +1,76 @@
 #ifndef _ASM_ARM_UNALIGNED_H
 #define _ASM_ARM_UNALIGNED_H
 
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_byteshift.h>
-#include <linux/unaligned/generic.h>
-
-/*
- * Select endianness
- */
-#ifndef __ARMEB__
-#define get_unaligned	__get_unaligned_le
-#define put_unaligned	__put_unaligned_le
+#include <linux/kernel.h>
+#include <asm/byteorder.h>
+
+static inline u16 __arch_load_cpu16_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return p[0] | p[1] << 8;
+#else
+	return p[0] << 8 | p[1];
+#endif
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+static inline u32 __arch_load_cpu32_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+#else
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+#endif
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u64 __arch_load_cpu64_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((u64)__arch_load_cpu32_noalign(p + 4) << 32) |
+	        __arch_load_cpu32_noalign(p);
+#else
+	return ((u64)__arch_load_cpu32_noalign(p) << 32) |
+	       __arch_load_cpu32_noalign(p + 4);
+#endif
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+static inline void __arch_store_cpu16_noalign(u8 *p, u16 val)
+{
+#ifdef __LITTLE_ENDIAN
+	*p++ = val;
+	*p++ = val >> 8;
+#else
+	*p++ = val >> 8;
+	*p++ = val;
+#endif
+}
+#define __arch_store_cpu16_noalign __arch_store_cpu16_noalign
+
+static inline void __arch_store_cpu32_noalign(u8 *p, u32 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__arch_store_cpu16_noalign(p, val);
+	__arch_store_cpu16_noalign(p + 2, val >> 16);
+#else
+	__arch_store_cpu16_noalign(p, val >> 16);
+	__arch_store_cpu16_noalign(p + 2, val);
+#endif
+}
+#define __arch_store_cpu32_noalign __arch_store_cpu32_noalign
+
+static inline void __arch_store_cpu64_noalign(u8 *p, u64 val)
+{
+#ifdef __LITTLE_ENDIAN
+	__arch_store_cpu32_noalign(p, val);
+	__arch_store_cpu32_noalign(p + 4, val >> 32);
 #else
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+	__arch_store_cpu32_noalign(p, val >> 32);
+	__arch_store_cpu32_noalign(p + 4, val);
 #endif
+}
+#define __arch_store_cpu64_noalign __arch_store_cpu64_noalign
 
+#include <linux/unaligned.h>
 #endif /* _ASM_ARM_UNALIGNED_H */
-- 
1.6.1.212.g4b3ec


