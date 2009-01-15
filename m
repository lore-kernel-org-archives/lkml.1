Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbZAOHia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbZAOHia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762309AbZAOHgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:36:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:24672 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762296AbZAOHgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LpdJiaAAHLp8aLO1pkEJXQ5rizpC7LWVRhfaVKpoY3ZyCYX7buK1twowaYeXC0QKN0
         D/S+BnLeLP7srkaFMJXSXREq744L0b8ttZv22IJjsraDormvd4MIdCxpybGZcFCXDfgG
         1TeSzj9LP8Q+KomO4CiKtY7k4tdtY+y7Aw6n0=
Subject: [PATCH 5/7] unaligned: wire up h8300 and m32r arches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 23:36:28 -0800
Message-Id: <1232004988.5819.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide arch overrides using memmove to avoid any functional
changes.  At a later time these arches should be able to just
use the common header directly, but this is not certain currently.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/h8300/include/asm/unaligned.h |   51 +++++++++++++++++++++++++++---
 include/asm-m32r/unaligned.h       |   60 ++++++++++++++++++++++++++++--------
 2 files changed, 93 insertions(+), 18 deletions(-)

diff --git a/arch/h8300/include/asm/unaligned.h b/arch/h8300/include/asm/unaligned.h
index b8d06c7..a184b55 100644
--- a/arch/h8300/include/asm/unaligned.h
+++ b/arch/h8300/include/asm/unaligned.h
@@ -1,11 +1,52 @@
 #ifndef _ASM_H8300_UNALIGNED_H
 #define _ASM_H8300_UNALIGNED_H
 
-#include <linux/unaligned/be_memmove.h>
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/generic.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
 
+static inline u16 __arch_load_cpu16_noalign(const void *p)
+{
+	u16 tmp;
+	memmove(&tmp, p, 2);
+	return tmp;
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+static inline u32 __arch_load_cpu32_noalign(const void *p)
+{
+	u32 tmp;
+	memmove(&tmp, p, 4);
+	return tmp;
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u64 __arch_load_cpu16_noalign(const void *p)
+{
+	u64 tmp;
+	memmove(&tmp, p, 8);
+	return tmp;
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+static inline void __arch_store_cpu16_noalign(void *p, u16 val)
+{
+	memmove(p, &val, 2);
+}
+#define __arch_store_cpu16_noalign __arch_store_cpu16_noalign
+
+static inline void __arch_store_cpu32_noalign(void *p, u32 val)
+{
+	memmove(p, &val, 4);
+}
+#define __arch_store_cpu32_noalign __arch_store_cpu32_noalign
+
+static inline void __arch_store_cpu64_noalign(void *p, u64 val)
+{
+	memmove(p, &val, 8);
+}
+#define __arch_store_cpu64_noalign __arch_store_cpu64_noalign
+
+#include <linux/unaligned.h>
 #endif /* _ASM_H8300_UNALIGNED_H */
diff --git a/include/asm-m32r/unaligned.h b/include/asm-m32r/unaligned.h
index 377eb20..a676014 100644
--- a/include/asm-m32r/unaligned.h
+++ b/include/asm-m32r/unaligned.h
@@ -1,18 +1,52 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-#if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
-#else
-# include <linux/unaligned/be_memmove.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
-#endif
+#include <linux/kernel.h>
+#include <linux/string.h>
 
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
+
+static inline u16 __arch_load_cpu16_noalign(const void *p)
+{
+	u16 tmp;
+	memmove(&tmp, p, 2);
+	return tmp;
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+static inline u32 __arch_load_cpu32_noalign(const void *p)
+{
+	u32 tmp;
+	memmove(&tmp, p, 4);
+	return tmp;
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u64 __arch_load_cpu16_noalign(const void *p)
+{
+	u64 tmp;
+	memmove(&tmp, p, 8);
+	return tmp;
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+static inline void __arch_store_cpu16_noalign(void *p, u16 val)
+{
+	memmove(p, &val, 2);
+}
+#define __arch_store_cpu16_noalign __arch_store_cpu16_noalign
+
+static inline void __arch_store_cpu32_noalign(void *p, u32 val)
+{
+	memmove(p, &val, 4);
+}
+#define __arch_store_cpu32_noalign __arch_store_cpu32_noalign
+
+static inline void __arch_store_cpu64_noalign(void *p, u64 val)
+{
+	memmove(p, &val, 8);
+}
+#define __arch_store_cpu64_noalign __arch_store_cpu64_noalign
+
+#include <linux/unaligned.h>
 #endif /* _ASM_M32R_UNALIGNED_H */
-- 
1.6.1.212.g4b3ec


