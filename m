Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbYKRDjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbYKRDjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKRDjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:14 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:34235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYKRDjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=L57gRKiugiSNU6MEXSn+118Dyaf1L0UPTdKRXGAOunuQzRWm1s2ZrreRpCW6DXD+Ae
         mcYEL6VhdRSWnAxxCqN+Mvun/8YXmS3wQs5HqVE9G9HhShOSIsZ4ynqqW2snpsV10g7p
         iIeaelkzyvt/bN+0Zs3MMyA6ACPW6uRdol7vM=
Subject: [PATCH-mm 1/7] unaligned: introduce common header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Newton <will.newton@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:09 -0800
Message-Id: <1226979549.6150.266.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two common cases in the kernel, one where unaligned access
is OK for an arch and one where the arch uses a packed-struct for
the native endianness and opencoded C byteshifting for the other
endianness.  Consolidate these two implementations in asm-generic/unaligned.h

Arches that require no special handling of unaligned access can define
_UNALIGNED_ACCESS_OK in their asm/unaligned.h before including the generic
version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Patches vs linux-next, 1-4 are suitable for mainline anytime as they are pure movement.

Patches 5-6 need some more input from other arch people (CCs added).

 include/asm-generic/unaligned.h |  323 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 323 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
new file mode 100644
index 0000000..8dfca50
--- /dev/null
+++ b/include/asm-generic/unaligned.h
@@ -0,0 +1,323 @@
+#ifndef _ASM_GENERIC_UNALIGNED_H
+#define _ASM_GENERIC_UNALIGNED_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#ifdef _UNALIGNED_ACCESS_OK
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return le16_to_cpup(p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return le32_to_cpup(p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return le64_to_cpup(p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return be16_to_cpup(p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return be32_to_cpup(p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return be64_to_cpup(p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	*(__le16 *)p = cpu_to_le16(val);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	*(__le32 *)p = cpu_to_le32(val);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	*(__le64 *)p = cpu_to_le64(val);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	*(__be16 *)p = cpu_to_be16(val);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	*(__be32 *)p = cpu_to_be32(val);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	*(__be64 *)p = cpu_to_be64(val);
+}
+
+#else /* _UNALIGNED_ACCESS_OK */
+
+struct __una_u16 { u16 x __attribute__((packed)); };
+struct __una_u32 { u32 x __attribute__((packed)); };
+struct __una_u64 { u64 x __attribute__((packed)); };
+
+static inline u16 __get_le16_noalign(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u32 __get_le32_noalign(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline u64 __get_le64_noalign(const u8 *p)
+{
+	return ((u64)__get_le32_noalign(p + 4) << 32) | __get_le32_noalign(p);
+}
+
+static inline u16 __get_be16_noalign(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline u32 __get_be32_noalign(const u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline u64 __get_be64_noalign(const u8 *p)
+{
+	return ((u64)__get_be32_noalign(p) << 32) | __get_be32_noalign(p + 4);
+}
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u16 *)p)->x;
+#else
+	return __get_le16_noalign(p);
+#endif
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u32 *)p)->x;
+#else
+	return __get_le32_noalign(p);
+#endif
+}
+
+static inline u16 get_unaligned_le64(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u64 *)p)->x;
+#else
+	return __get_le64_noalign(p);
+#endif
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u16 *)p)->x;
+#else
+	return __get_be16_noalign(p);
+#endif
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u32 *)p)->x;
+#else
+	return __get_be32_noalign(p);
+#endif
+}
+
+static inline u16 get_unaligned_be64(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u64 *)p)->x;
+#else
+	return __get_be64_noalign(p);
+#endif
+}
+
+static inline void __put_le16_noalign(u8 *p, u16 val)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_le32_noalign(u8 *p, u32 val)
+{
+	__put_le16_noalign(p + 2, val >> 16);
+	__put_le16_noalign(p, val);
+}
+
+static inline void __put_le64_noalign(u8 *p, u64 val)
+{
+	__put_le32_noalign(p + 4, val >> 32);
+	__put_le32_noalign(p, val);
+}
+
+static inline void __put_be16_noalign(u8 *p, u16 val)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_be32_noalign(u8 *p, u32 val)
+{
+	__put_be16_noalign(p, val >> 16);
+	__put_be16_noalign(p + 2, val);
+}
+
+static inline void __put_be64_noalign(u8 *p, u64 val)
+{
+	__put_be32_noalign(p, val >> 32);
+	__put_be32_noalign(p + 4, val);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u16 *)p)->x = val;
+#else
+	__put_le16_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u32 *)p)->x = val;
+#else
+	__put_le32_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u64 *)p)->x = val;
+#else
+	__put_le64_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u16 *)p)->x = val;
+#else
+	__put_be16_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u32 *)p)->x = val;
+#else
+	__put_be32_noalign(p, val);
+#endif
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u64 *)p)->x = val;
+#else
+	__put_be64_noalign(p, val);
+#endif
+}
+
+#endif /* _UNALIGNED_ACCESS_OK */
+
+/*
+ * Cause a link-time error if we try an unaligned access other than
+ * 1,2,4 or 8 bytes long
+ */
+extern void __bad_unaligned_access_size(void);
+
+#define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
+	__bad_unaligned_access_size()))));					\
+	}))
+
+#define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
+	__bad_unaligned_access_size()))));					\
+	}))
+
+#define __put_unaligned_le(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_le16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_le32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_le64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#define __put_unaligned_be(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_be16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_be32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_be64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#ifdef __LITTLE_ENDIAN
+# define get_unaligned __get_unaligned_le
+# define put_unaligned __put_unaligned_le
+#else
+# define get_unaligned __get_unaligned_be
+# define put_unaligned __put_unaligned_be
+#endif
+
+#endif /* _ASM_GENERIC_UNALIGNED_H */
-- 
1.6.0.4.994.g16bd3e


