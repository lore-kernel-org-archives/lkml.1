Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYK3Clr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYK3Clr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 21:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYK3Ckr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 21:40:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:23550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbYK3Ckl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 21:40:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XyPRLLYOCDNTQwcLIMOYDQkBsqwIeARoQKP/G+Ur9nEVBxLu6cdI4GcfbV+l+BVBzw
         6LiYHMR8HspQMi4CY67kbnYYpQDWw6yjkngMG0DAc68Ai2TATEMywN6Pgjr58bYqkw9V
         tmTPW+nXoOys9x6H/FYVtIORoZrsNPbHWlQoc=
Subject: [PATCH-mm 4/7] sh: wire up arch overrides for unaligned access on
 the SH4a
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 29 Nov 2008 18:40:30 -0800
Message-Id: <1228012830.26141.1029.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/include/asm/unaligned-sh4a.h |  258 ----------------------------------
 arch/sh/include/asm/unaligned.h      |   76 ++++++++--
 2 files changed, 61 insertions(+), 273 deletions(-)

diff --git a/arch/sh/include/asm/unaligned-sh4a.h b/arch/sh/include/asm/unaligned-sh4a.h
deleted file mode 100644
index d8f8977..0000000
--- a/arch/sh/include/asm/unaligned-sh4a.h
+++ /dev/null
@@ -1,258 +0,0 @@
-#ifndef __ASM_SH_UNALIGNED_SH4A_H
-#define __ASM_SH_UNALIGNED_SH4A_H
-
-/*
- * SH-4A has support for unaligned 32-bit loads, and 32-bit loads only.
- * Support for 16 and 64-bit accesses are done through shifting and
- * masking relative to the endianness. Unaligned stores are not supported
- * by the instruction encoding, so these continue to use the packed
- * struct.
- *
- * The same note as with the movli.l/movco.l pair applies here, as long
- * as the load is gauranteed to be inlined, nothing else will hook in to
- * r0 and we get the return value for free.
- *
- * NOTE: Due to the fact we require r0 encoding, care should be taken to
- * avoid mixing these heavily with other r0 consumers, such as the atomic
- * ops. Failure to adhere to this can result in the compiler running out
- * of spill registers and blowing up when building at low optimization
- * levels. See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34777.
- */
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
-static __always_inline u32 __get_unaligned_cpu32(const u8 *p)
-{
-	unsigned long unaligned;
-
-	__asm__ __volatile__ (
-		"movua.l	@%1, %0\n\t"
-		 : "=z" (unaligned)
-		 : "r" (p)
-	);
-
-	return unaligned;
-}
-
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
-
-static inline u16 __get_unaligned_cpu16(const u8 *p)
-{
-#ifdef __LITTLE_ENDIAN
-	return __get_unaligned_cpu32(p) & 0xffff;
-#else
-	return __get_unaligned_cpu32(p) >> 16;
-#endif
-}
-
-/*
- * Even though movua.l supports auto-increment on the read side, it can
- * only store to r0 due to instruction encoding constraints, so just let
- * the compiler sort it out on its own.
- */
-static inline u64 __get_unaligned_cpu64(const u8 *p)
-{
-#ifdef __LITTLE_ENDIAN
-	return (u64)__get_unaligned_cpu32(p + 4) << 32 |
-		    __get_unaligned_cpu32(p);
-#else
-	return (u64)__get_unaligned_cpu32(p) << 32 |
-		    __get_unaligned_cpu32(p + 4);
-#endif
-}
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return le16_to_cpu(__get_unaligned_cpu16(p));
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return le32_to_cpu(__get_unaligned_cpu32(p));
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return le64_to_cpu(__get_unaligned_cpu64(p));
-}
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return be16_to_cpu(__get_unaligned_cpu16(p));
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return be32_to_cpu(__get_unaligned_cpu32(p));
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return be64_to_cpu(__get_unaligned_cpu64(p));
-}
-
-static inline void __put_le16_noalign(u8 *p, u16 val)
-{
-	*p++ = val;
-	*p++ = val >> 8;
-}
-
-static inline void __put_le32_noalign(u8 *p, u32 val)
-{
-	__put_le16_noalign(p, val);
-	__put_le16_noalign(p + 2, val >> 16);
-}
-
-static inline void __put_le64_noalign(u8 *p, u64 val)
-{
-	__put_le32_noalign(p, val);
-	__put_le32_noalign(p + 4, val >> 32);
-}
-
-static inline void __put_be16_noalign(u8 *p, u16 val)
-{
-	*p++ = val >> 8;
-	*p++ = val;
-}
-
-static inline void __put_be32_noalign(u8 *p, u32 val)
-{
-	__put_be16_noalign(p, val >> 16);
-	__put_be16_noalign(p + 2, val);
-}
-
-static inline void __put_be64_noalign(u8 *p, u64 val)
-{
-	__put_be32_noalign(p, val >> 32);
-	__put_be32_noalign(p + 4, val);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-#ifdef __LITTLE_ENDIAN
-	((struct __una_u16 *)p)->x = val;
-#else
-	__put_le16_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-#ifdef __LITTLE_ENDIAN
-	((struct __una_u32 *)p)->x = val;
-#else
-	__put_le32_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-#ifdef __LITTLE_ENDIAN
-	((struct __una_u64 *)p)->x = val;
-#else
-	__put_le64_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-#ifdef __BIG_ENDIAN
-	((struct __una_u16 *)p)->x = val;
-#else
-	__put_be16_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-#ifdef __BIG_ENDIAN
-	((struct __una_u32 *)p)->x = val;
-#else
-	__put_be32_noalign(p, val);
-#endif
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-#ifdef __BIG_ENDIAN
-	((struct __una_u64 *)p)->x = val;
-#else
-	__put_be64_noalign(p, val);
-#endif
-}
-
-/*
- * Cause a link-time error if we try an unaligned access other than
- * 1,2,4 or 8 bytes long
- */
-extern void __bad_unaligned_access_size(void);
-
-#define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
-	}))
-
-#define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
-	}))
-
-#define __put_unaligned_le(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_le16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_le32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_le64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#define __put_unaligned_be(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_be16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_be32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_be64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#ifdef __LITTLE_ENDIAN
-# define get_unaligned __get_unaligned_le
-# define put_unaligned __put_unaligned_le
-#else
-# define get_unaligned __get_unaligned_be
-# define put_unaligned __put_unaligned_be
-#endif
-
-#endif /* __ASM_SH_UNALIGNED_SH4A_H */
diff --git a/arch/sh/include/asm/unaligned.h b/arch/sh/include/asm/unaligned.h
index 8c0ad5e..ac91e0d 100644
--- a/arch/sh/include/asm/unaligned.h
+++ b/arch/sh/include/asm/unaligned.h
@@ -1,24 +1,70 @@
 #ifndef _ASM_SH_UNALIGNED_H
 #define _ASM_SH_UNALIGNED_H
 
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
 #ifdef CONFIG_CPU_SH4A
-/* SH-4A can handle unaligned loads in a relatively neutered fashion. */
-#include <asm/unaligned-sh4a.h>
-#else
-/* Otherwise, SH can't handle unaligned accesses. */
-#ifdef __LITTLE_ENDIAN__
-# include <linux/unaligned/le_struct.h>
-# include <linux/unaligned/be_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_le
-# define put_unaligned	__put_unaligned_le
+/*
+ * SH-4A has support for unaligned 32-bit loads, and 32-bit loads only.
+ * Support for 16 and 64-bit accesses are done through shifting and
+ * masking relative to the endianness. Unaligned stores are not supported
+ * by the instruction encoding, so these continue to use the packed
+ * struct.
+ *
+ * The same note as with the movli.l/movco.l pair applies here, as long
+ * as the load is gauranteed to be inlined, nothing else will hook in to
+ * r0 and we get the return value for free.
+ *
+ * NOTE: Due to the fact we require r0 encoding, care should be taken to
+ * avoid mixing these heavily with other r0 consumers, such as the atomic
+ * ops. Failure to adhere to this can result in the compiler running out
+ * of spill registers and blowing up when building at low optimization
+ * levels. See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34777.
+ */
+
+static inline u32 __arch_load_cpu32_noalign(const u8 *p)
+{
+	unsigned long unaligned;
+
+	__asm__ __volatile__ (
+		"movua.l	@%1, %0\n\t"
+		 : "=z" (unaligned)
+		 : "r" (p)
+	);
+
+	return unaligned;
+}
+#define __arch_load_cpu32_noalign __arch_load_cpu32_noalign
+
+static inline u16 __arch_load_cpu16_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return __arch_load_cpu32_noalign(p) & 0xffff;
 #else
-# include <linux/unaligned/be_struct.h>
-# include <linux/unaligned/le_byteshift.h>
-# include <linux/unaligned/generic.h>
-# define get_unaligned	__get_unaligned_be
-# define put_unaligned	__put_unaligned_be
+	return __arch_load_cpu32_noalign(p) >> 16;
 #endif
+}
+#define __arch_load_cpu16_noalign __arch_load_cpu16_noalign
+
+/*
+ * Even though movua.l supports auto-increment on the read side, it can
+ * only store to r0 due to instruction encoding constraints, so just let
+ * the compiler sort it out on its own.
+ */
+static inline u64 __arch_load_cpu64_noalign(const u8 *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return (u64)__arch_load_cpu32_noalign(p + 4) << 32 |
+		    __arch_load_cpu32_noalign(p);
+#else
+	return (u64)__arch_load_cpu32_noalign(p) << 32 |
+		    __arch_load_cpu32_noalign(p + 4);
 #endif
+}
+#define __arch_load_cpu64_noalign __arch_load_cpu64_noalign
+
+#endif /* CONFIG_CPU_SH4A */
 
+#include <linux/unaligned.h>
 #endif /* _ASM_SH_UNALIGNED_H */
-- 
1.6.0.4.1044.g77718


