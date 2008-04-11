Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbYDKDja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbYDKDja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 23:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbYDKDjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 23:39:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:19752 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbYDKDi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 23:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vxh2mJW9h4o66tB3/ZtNhtN6OWPq1JJvN7mw5LjO+DrQQ/dT/V88aMW1bSOE/IiixZoJU4F8RZBirYI9wnzngYG30LrWvhdwG9glT6QP6YH8JoOMh2n9dhU3WxQDWxEZ6SX5O16h0RM+K3wpAWYyJYnTm7PGMZ+RlbXsTzIgMkw=
Subject: [PATCH 1/2] kernel: add common infrastructure for unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 20:38:57 -0700
Message-Id: <1207885137.22001.86.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a linux/unaligned folder similar in spirit to the linux/byteorder
folder to hold generic implementations collected from various arches.

Currently there are five implementations:
1) cpu_endian.h: C-struct based, from asm-generic/unaligned.h
2) little_endian.h: Open coded byte-swapping, heavily based on asm-arm
3) big_endian.h: Open coded byte-swapping, heavily based on asm-arm
4) no_builtin_memcpy.h: taken from multiple implementations in tree
5) access_ok.h: taken from x86 and others, unaligned access is ok.

All of the new implementations checks for sizes not equal to 1,2,4,8
and will BUG at compile time.

API additions:

get_unaligned_{le16|le32|le64|be16|be32|be64}(p) which is meant to replace
code of the form:
le16_to_cpu(get_unaligned((__le16 *)p));

put_unaligned_{le16|le32|le64|be16|be32|be64}(val, pointer) which is meant to
replace code of the form:
put_unaligned(cpu_to_le16(val), (__le16 *)p);

Headers to create these based on the selected implementation and defining the
appropriate get_unaligned() and put_unaligned() macros are:

generic_le.h: Use the C-struct for get/put_unaligned and the le helpers, use the
opencoded be byteswapping implementation for big-endian.

generic_be.h: Use the C-struct for get/put_unaligned and the be helpers, use the
opencoded le byteswapping implementation for little-endian.

generic.h: Use opencoded byteswapping for all helpers, leaves it to the arch to
define get/put_unaligned.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Removed some superfluous casts noticed by David Howells.  Made all arches check
the only size 1,2,4,8 types are passed to get/put_unaligned.
 include/linux/unaligned/access_ok.h         |   98 +++++++++++++++++++++++++
 include/linux/unaligned/big_endian.h        |   86 ++++++++++++++++++++++
 include/linux/unaligned/cpu_endian.h        |   92 ++++++++++++++++++++++++
 include/linux/unaligned/generic.h           |   67 +++++++++++++++++
 include/linux/unaligned/generic_be.h        |   70 ++++++++++++++++++
 include/linux/unaligned/generic_le.h        |   70 ++++++++++++++++++
 include/linux/unaligned/little_endian.h     |   86 ++++++++++++++++++++++
 include/linux/unaligned/no_builtin_memcpy.h |  102 +++++++++++++++++++++++++++
 8 files changed, 671 insertions(+), 0 deletions(-)

diff --git a/include/linux/unaligned/access_ok.h b/include/linux/unaligned/access_ok.h
new file mode 100644
index 0000000..69f4520
--- /dev/null
+++ b/include/linux/unaligned/access_ok.h
@@ -0,0 +1,98 @@
+#ifndef _LINUX_UNALIGNED_ACCESS_OK_H_
+#define _LINUX_UNALIGNED_ACCESS_OK_H_
+
+#include <linux/kernel.h>
+#include <asm/byteorder.h>
+
+extern void __build_bug_unaligned_length(void);
+
+#define get_unaligned(ptr) ({			\
+	typeof(*(ptr)) __tmp;			\
+	switch (sizeof(__tmp)) {		\
+	case 1:					\
+	case 2:					\
+	case 4:					\
+	case 8:					\
+		__tmp = *(ptr);			\
+		break;				\
+	default:				\
+		__build_bug_unaligned_length();	\
+		break;				\
+	}					\
+	__tmp; })
+
+#define put_unaligned(val, ptr) ({		\
+	switch (sizeof(*(ptr))) {		\
+	case 1:					\
+	case 2:					\
+	case 4:					\
+	case 8:					\
+		*(ptr) = (val);			\
+		break;				\
+	default:				\
+		__build_bug_unaligned_length();	\
+		break;				\
+	}					\
+	(void)0; })
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return le16_to_cpup((__le16 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return le32_to_cpup((__le32 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return le64_to_cpup((__le64 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return be16_to_cpup((__be16 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return be32_to_cpup((__be32 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return be64_to_cpup((__be64 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	*((__le16 *)p) = cpu_to_le16(val);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	*((__le32 *)p) = cpu_to_le32(val);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	*((__le64 *)p) = cpu_to_le64(val);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	*((__be16 *)p) = cpu_to_be16(val);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	*((__be32 *)p) = cpu_to_be32(val);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	*((__be64 *)p) = cpu_to_be64(val);
+}
+
+#endif /* _LINUX_UNALIGNED_ACCESS_OK_H_ */
diff --git a/include/linux/unaligned/big_endian.h b/include/linux/unaligned/big_endian.h
new file mode 100644
index 0000000..23d1532
--- /dev/null
+++ b/include/linux/unaligned/big_endian.h
@@ -0,0 +1,86 @@
+#ifndef _LINUX_UNALIGNED_BIG_ENDIAN_H_
+#define _LINUX_UNALIGNED_BIG_ENDIAN_H_
+
+#include <linux/kernel.h>
+
+extern void __build_bug_unaligned_length(void);
+
+static inline u16 __get_unaligned_be16(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline u32 __get_unaligned_be32(const u8 *p)
+{
+	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
+}
+
+static inline u64 __get_unaligned_be64(const u8 *p)
+{
+	return (u64)__get_unaligned_be32(p) << 32 |
+	       __get_unaligned_be32(p + 4);
+}
+
+#define __get_unaligned_be(ptr) ({			\
+	const void *__gu_p = (ptr);			\
+	typeof(*(ptr)) __val;				\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+		__val = *(const u8 *)__gu_p;		\
+		break;					\
+	case 2:						\
+		__val = __get_unaligned_be16(__gu_p);	\
+		break;					\
+	case 4:						\
+		__val = __get_unaligned_be32(__gu_p);	\
+		break;					\
+	case 8:						\
+		__val = __get_unaligned_be64(__gu_p);	\
+		break;					\
+	default:					\
+		__build_bug_unaligned_length();		\
+		break;					\
+	};						\
+	__val; })
+
+static inline void __put_unaligned_be16(u16 val, u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_unaligned_be32(u32 val, u8 *p)
+{
+	__put_unaligned_be16(val >> 16, p);
+	__put_unaligned_be16(val, p + 2);
+}
+
+static inline void __put_unaligned_be64(u64 val, u8 *p)
+{
+	__put_unaligned_be32(val >> 32, p);
+	__put_unaligned_be32(val, p + 4);
+}
+
+#define __put_unaligned_be(val, ptr) ({					\
+	(void)sizeof(*(ptr) = (val));					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		__put_unaligned_be16((__force u16)(val), __gu_p);	\
+		break;							\
+	case 4:								\
+		__put_unaligned_be32((__force u32)(val), __gu_p);	\
+		break;							\
+	case 8:								\
+		__put_unaligned_be64((__force u64)(val), __gu_p);	\
+		break;							\
+	default:							\
+		__build_bug_unaligned_length();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_BIG_ENDIAN_H_ */
diff --git a/include/linux/unaligned/cpu_endian.h b/include/linux/unaligned/cpu_endian.h
new file mode 100644
index 0000000..91861c4
--- /dev/null
+++ b/include/linux/unaligned/cpu_endian.h
@@ -0,0 +1,92 @@
+#ifndef _LINUX_UNALIGNED_CPU_ENDIAN_H_
+#define _LINUX_UNALIGNED_CPU_ENDIAN_H_
+
+#include <linux/kernel.h>
+
+extern void __build_bug_unaligned_length(void);
+
+struct __una_u16 { u16 x __attribute__((packed)); };
+struct __una_u32 { u32 x __attribute__((packed)); };
+struct __una_u64 { u64 x __attribute__((packed)); };
+
+static inline u16 __get_unaligned_cpu16(const void *p)
+{
+	const struct __una_u16 *ptr = (const struct __una_u16 *)p;
+	return ptr->x;
+}
+
+static inline u32 __get_unaligned_cpu32(const void *p)
+{
+	const struct __una_u32 *ptr = (const struct __una_u32 *)p;
+	return ptr->x;
+}
+
+static inline u64 __get_unaligned_cpu64(const void *p)
+{
+	const struct __una_u64 *ptr = (const struct __una_u64 *)p;
+	return ptr->x;
+}
+
+#define __get_unaligned_cpu(ptr) ({			\
+	const void *__gu_p = (ptr);			\
+	typeof(*(ptr)) __val;				\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+		__val = *(const u8 *)__gu_p;		\
+		break;					\
+	case 2:						\
+		__val = __get_unaligned_cpu16(__gu_p);	\
+		break;					\
+	case 4:						\
+		__val = __get_unaligned_cpu32(__gu_p);	\
+		break;					\
+	case 8:						\
+		__val = __get_unaligned_cpu64(__gu_p);	\
+		break;					\
+	default:					\
+		__build_bug_unaligned_length();		\
+		break;					\
+	};						\
+	__val; })
+
+static inline void __put_unaligned_cpu16(u16 val, void *p)
+{
+	struct __una_u16 *ptr = (struct __una_u16 *)p;
+	ptr->x = val;
+}
+
+static inline void __put_unaligned_cpu32(u32 val, void *p)
+{
+	struct __una_u32 *ptr = (struct __una_u32 *)p;
+	ptr->x = val;
+}
+
+static inline void __put_unaligned_cpu64(u64 val, void *p)
+{
+	struct __una_u64 *ptr = (struct __una_u64 *)p;
+	ptr->x = val;
+}
+
+#define __put_unaligned_cpu(val, ptr) ({				\
+	(void)sizeof(*(ptr) = (val));					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		__put_unaligned_cpu16((__force u16)(val), __gu_p);	\
+		break;							\
+	case 4:								\
+		__put_unaligned_cpu32((__force u32)(val), __gu_p);	\
+		break;							\
+	case 8:								\
+		__put_unaligned_cpu64((__force u64)(val), __gu_p);	\
+		break;							\
+	default:							\
+		__build_bug_unaligned_length();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_CPU_ENDIAN_H_ */
diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
new file mode 100644
index 0000000..50ce393
--- /dev/null
+++ b/include/linux/unaligned/generic.h
@@ -0,0 +1,67 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_H_
+#define _LINUX_UNALIGNED_GENERIC_H_
+
+#include <linux/unaligned/little_endian.h>
+#include <linux/unaligned/big_endian.h>
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_le32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_le64((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_be32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_be64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_GENERIC_H_ */
diff --git a/include/linux/unaligned/generic_be.h b/include/linux/unaligned/generic_be.h
new file mode 100644
index 0000000..a200aca
--- /dev/null
+++ b/include/linux/unaligned/generic_be.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_BE_H_
+#define _LINUX_UNALIGNED_GENERIC_BE_H_
+
+#include <linux/unaligned/cpu_endian.h>
+#include <linux/unaligned/little_endian.h>
+
+#define get_unaligned	__get_unaligned_cpu
+#define put_unaligned	__put_unaligned_cpu
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_le32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_le64((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_cpu16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_cpu32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_cpu64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_cpu16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_cpu32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_cpu64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_GENERIC_BE_H_ */
diff --git a/include/linux/unaligned/generic_le.h b/include/linux/unaligned/generic_le.h
new file mode 100644
index 0000000..8a6f6ae
--- /dev/null
+++ b/include/linux/unaligned/generic_le.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_LE_H_
+#define _LINUX_UNALIGNED_GENERIC_LE_H_
+
+#include <linux/unaligned/cpu_endian.h>
+#include <linux/unaligned/big_endian.h>
+
+#define get_unaligned	__get_unaligned_cpu
+#define put_unaligned	__put_unaligned_cpu
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_cpu16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return __get_unaligned_cpu32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return __get_unaligned_cpu64((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return __get_unaligned_be32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return __get_unaligned_be64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_cpu16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_cpu32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_cpu64(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_GENERIC_LE_H_ */
diff --git a/include/linux/unaligned/little_endian.h b/include/linux/unaligned/little_endian.h
new file mode 100644
index 0000000..2a92f92
--- /dev/null
+++ b/include/linux/unaligned/little_endian.h
@@ -0,0 +1,86 @@
+#ifndef _LINUX_UNALIGNED_LITTLE_ENDIAN_H_
+#define _LINUX_UNALIGNED_LITTLE_ENDIAN_H_
+
+#include <linux/kernel.h>
+
+extern void __build_bug_unaligned_length(void);
+
+static inline u16 __get_unaligned_le16(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u32 __get_unaligned_le32(const u8 *p)
+{
+	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
+}
+
+static inline u64 __get_unaligned_le64(const u8 *p)
+{
+	return (u64)__get_unaligned_le32(p + 4) << 32 |
+	       __get_unaligned_le32(p);
+}
+
+#define __get_unaligned_le(ptr) ({			\
+	const void *__gu_p = (ptr);			\
+	typeof(*(ptr)) __val;				\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+		__val = *(const u8 *)__gu_p;		\
+		break;					\
+	case 2:						\
+		__val = __get_unaligned_le16(__gu_p);	\
+		break;					\
+	case 4:						\
+		__val = __get_unaligned_le32(__gu_p);	\
+		break;					\
+	case 8:						\
+		__val = __get_unaligned_le64(__gu_p);	\
+		break;					\
+	default:					\
+		__build_bug_unaligned_length();		\
+		break;					\
+	};						\
+	__val; })
+
+static inline void __put_unaligned_le16(u16 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_le32(u32 val, u8 *p)
+{
+	__put_unaligned_le16(val >> 16, p + 2);
+	__put_unaligned_le16(val, p);
+}
+
+static inline void __put_unaligned_le64(u64 val, u8 *p)
+{
+	__put_unaligned_le32(val >> 32, p + 4);
+	__put_unaligned_le32(val, p);
+}
+
+#define __put_unaligned_le(val, ptr) ({					\
+	(void)sizeof(*(ptr) = (val));					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		__put_unaligned_le16((__force u16)(val), __gu_p);	\
+		break;							\
+	case 4:								\
+		__put_unaligned_le32((__force u32)(val), __gu_p);	\
+		break;							\
+	case 8:								\
+		__put_unaligned_le64((__force u64)(val), __gu_p);	\
+		break;							\
+	default:							\
+		__build_bug_unaligned_length();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_LITTLE_ENDIAN_H_ */
diff --git a/include/linux/unaligned/no_builtin_memcpy.h b/include/linux/unaligned/no_builtin_memcpy.h
new file mode 100644
index 0000000..9db015b
--- /dev/null
+++ b/include/linux/unaligned/no_builtin_memcpy.h
@@ -0,0 +1,102 @@
+#ifndef _LINUX_UNALIGNED_NO_BUILTIN_MEMCPY_H_
+#define _LINUX_UNALIGNED_NO_BUILTIN_MEMCPY_H_
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <asm/byteorder.h>
+
+extern void __build_bug_unaligned_length(void);
+
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
+
+#define get_unaligned(ptr) ({				\
+	typeof(*(ptr)) __tmp;				\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+	case 8:						\
+		memmove(&__tmp, (ptr), sizeof(*(ptr)));	\
+		break;					\
+	default:					\
+		__build_bug_unaligned_length();		\
+		break;					\
+	}						\
+	__tmp; })
+
+#define put_unaligned(val, ptr) ({			\
+	typeof(*(ptr)) __tmp = (val);			\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+	case 8:						\
+		memmove((ptr), &__tmp, sizeof(*(ptr)));	\
+		break;					\
+	default:					\
+		__build_bug_unaligned_length();		\
+		break;					\
+	}						\
+	(void)0; })
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return le16_to_cpu(get_unaligned((__le16 *)p));
+}
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+	return le32_to_cpu(get_unaligned((__le32 *)p));
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+	return le64_to_cpu(get_unaligned((__le64 *)p));
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return be16_to_cpu(get_unaligned((__be16 *)p));
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+	return be32_to_cpu(get_unaligned((__be32 *)p));
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+	return be64_to_cpu(get_unaligned((__be64 *)p));
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	put_unaligned(cpu_to_le16(val), (__le16 *)p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	put_unaligned(cpu_to_le32(val), (__le32 *)p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	put_unaligned(cpu_to_le64(val), (__le64 *)p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	put_unaligned(cpu_to_be16(val), (__be16 *)p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	put_unaligned(cpu_to_be32(val), (__be32 *)p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	put_unaligned(cpu_to_be64(val), (__be64 *)p);
+}
+
+#endif
-- 
1.5.5.144.g3e42


