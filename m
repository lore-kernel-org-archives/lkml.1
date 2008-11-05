Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYKESQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYKESQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYKESQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:16:24 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:48654 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYKESQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wXbrXv3aoxRTShBkdF0qZJB/6zn5pcSye377JIOlhUBlB/X34pGqBNAcG7XQBq9fV5
         NnmYFpwqXC7KCG/bgcF96ATsqFql6IZcAqW33ZCUMtmJ10tlkMMICAsSSzK5Gm6B7aBu
         BUz3qtHj887HbDncwuBCJUT7agCD22uFoVSwM=
Subject: [RFC-PATCH 1/5] unaligned: introduce common header
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Chris Zankel <chris@zankel.net>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:16:16 -0800
Message-Id: <1225908976.5991.180.camel@brick>
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
Patches 1-3 will have _zero_ functional change, it just consolidates the implementation
in one header rather than the many under linux/unaligned/* and only moves the arches
for which unaligned access is OK or is already using the packed-struct implementation.

Patch 4 will need input from the arch maintainers and isn't meant to be applied immediately,

The memmove-based arches (m32r, xtensa, h8300) are likely going to be fine with this change
barring compiler bugs that made them go with memmove in the first place.

ARM still needs further investigation as to the impact on code generation, but is included
here so that people can try it if possible

Patch 5 is just a removal of the old headers.

 include/asm-generic/unaligned.h |  323 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 323 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
new file mode 100644
index 0000000..583433f
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
+static inline u16 __get_una_le16(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u32 __get_una_le32(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline u64 __get_una_le64(const u8 *p)
+{
+	return ((u64)__get_una_le32(p + 4) << 32) | __get_una_le32(p);
+}
+
+static inline u16 __get_una_be16(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline u32 __get_una_be32(const u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline u64 __get_una_be64(const u8 *p)
+{
+	return ((u64)__get_una_be32(p) << 32) | __get_una_be32(p + 4);
+}
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u16 *)p)->x;
+#else
+	return __get_una_le16(p);
+#endif
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u32 *)p)->x;
+#else
+	return __get_una_le32(p);
+#endif
+}
+
+static inline u16 get_unaligned_le64(const void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	return ((const struct __una_u64 *)p)->x;
+#else
+	return __get_una_le64(p);
+#endif
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u16 *)p)->x;
+#else
+	return __get_una_be16(p);
+#endif
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u32 *)p)->x;
+#else
+	return __get_una_be32(p);
+#endif
+}
+
+static inline u16 get_unaligned_be64(const void *p)
+{
+#ifdef __BIG_ENDIAN
+	return ((const struct __una_u64 *)p)->x;
+#else
+	return __get_una_be64(p);
+#endif
+}
+
+static inline void __put_una_le16(u8 *p, u16 val)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_una_le32(u8 *p, u32 val)
+{
+	__put_una_le16(p + 2, val >> 16);
+	__put_una_le16(p, val);
+}
+
+static inline void __put_una_le64(u8 *p, u64 val)
+{
+	__put_una_le32(p + 4, val >> 32);
+	__put_una_le32(p, val);
+}
+
+static inline void __put_una_be16(u8 *p, u16 val)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_una_be32(u8 *p, u32 val)
+{
+	__put_una_be16(p, val >> 16);
+	__put_una_be16(p + 2, val);
+}
+
+static inline void __put_una_be64(u8 *p, u64 val)
+{
+	__put_una_be32(p, val >> 32);
+	__put_una_be32(p + 4, val);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u16 *)p)->x = val;
+#else
+	__put_una_le16(p, val);
+#endif
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u32 *)p)->x = val;
+#else
+	__put_una_le32(p, val);
+#endif
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+#ifdef __LITTLE_ENDIAN
+	((struct __una_u64 *)p)->x = val;
+#else
+	__put_una_le64(p, val);
+#endif
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u16 *)p)->x = val;
+#else
+	__put_una_be16(p, val);
+#endif
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u32 *)p)->x = val;
+#else
+	__put_una_be32(p, val);
+#endif
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+#ifdef __BIG_ENDIAN
+	((struct __una_u64 *)p)->x = val;
+#else
+	__put_una_be64(p, val);
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
1.6.0.3.756.gb776d


