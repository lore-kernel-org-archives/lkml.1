Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYK3CmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYK3CmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 21:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbYK3Ckt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 21:40:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:23550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbYK3Ckr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 21:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=c/9T2/g9CCBlPN3B/Lmz9EEqzIpLm7+1B/pvmBsVeTV6OeJAGjH1vVuvuBknjxXu/D
         hQ84ZNICApjO9wK+2SvnfccMJm3vz7Jk9rsp3mW8dYfVFDVa+bETBLjU7jXSfX3/bgRt
         FJXr0NP/JV07JblJgJevbHkqbajEuoOpf4bPo=
Subject: [PATCH-mm 5/7] unaligned: wire up h8300 and m32r arches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain
Date: Sat, 29 Nov 2008 18:40:31 -0800
Message-Id: <1228012831.26141.1030.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
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
1.6.0.4.1044.g77718


