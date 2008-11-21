Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYKUBMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYKUBMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYKUBME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:12:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:44290 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYKUBMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:12:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ecoA3p6BUC+7pbhRNMUZYcR3hFYjikHSB3XS34+4Z99jVhub3dmUVgrWlrjbkf2ZRo
         PCETq27+5KaLP6JqA2fHqPUL02LlZWoha00yg+I+Z6SR9WQLjbpHcMpJ4vgfPGsj1Sig
         xOyd2sDCFXSh8EoMGhIRTt96TXka+kw7ArAAs=
Subject: [RFC PATCH-mm] kernel: add new endian and unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 17:11:59 -0800
Message-Id: <1227229919.5354.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following API for the 6 endian types in the kernel
__le16,__le32, __le64, __be16, __be32, __be64:

u16 load_le16(const __le16 *p)
void store_le16(__le16 *p, u16 val)

u16 load_le16_noalign(const __le16 *p)
void store_le16_noalign(__le16 *p, u16 val)

Some general comments:

get/put_unaligned are being replaced because get/put in the kernel
usually implies some kind of reference is being taken/released, which
is not the case here.  They work with void * pointers which defeats
sparse checking. Also, put_unaligned takes its arguments in the
opposite order from what is expected.  The new names are chosen
to allow the APIs to live in parallel without breaking compilation.
The get/put_unaligned API can be removed once all users are converted.

load_le16 is a synonym for the existing le16_to_cpup and is added to
be symmetric with the load_le16_noalign API.  On arches where unaligned
access is OK, the unaligned calls are replaced with aligned calls.

store_le16 is a new API and is added to be symmetric with the unaligned
functions.  It is implemented as a macro to allow compile-time byteswapping
when the value is a constant.  This will also allow use in many places
currently that are of the form:

*(__le16 *)ptr = cpu_to_le16(foo);

In addition, some drivers/filesystems/arches already provide this API
privately, which will allow them to be consolidated into this common
code.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, depends on the unaligned patches and the byteorder patches in -mm,
so needs to come after both sets.

 include/asm-generic/unaligned.h |  117 +++++++++++++++++++++++----------------
 include/linux/byteorder.h       |   26 +++++++--
 2 files changed, 89 insertions(+), 54 deletions(-)

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 55d1126..54d4a48 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -6,6 +6,20 @@
 
 #ifdef _UNALIGNED_ACCESS_OK
 
+# define load_le16_noalign load_le16
+# define load_le32_noalign load_le32
+# define load_le64_noalign load_le64
+# define load_be16_noalign load_be16
+# define load_be32_noalign load_be32
+# define load_be64_noalign load_be64
+
+# define store_le16_noalign store_le16
+# define store_le32_noalign store_le32
+# define store_le64_noalign store_le64
+# define store_be16_noalign store_be16
+# define store_be32_noalign store_be32
+# define store_be64_noalign store_be64
+
 static inline u16 get_unaligned_le16(const void *p)
 {
 	return le16_to_cpup(p);
@@ -102,60 +116,67 @@ static inline u64 __get_be64_noalign(const u8 *p)
 	return ((u64)__get_be32_noalign(p) << 32) | __get_be32_noalign(p + 4);
 }
 
-static inline u16 get_unaligned_le16(const void *p)
+static inline u16 load_le16_noalign(const __le16 *p)
 {
 #ifdef __LITTLE_ENDIAN
-	return ((const struct __una_u16 *)p)->x;
+	return ((__force const struct __una_u16 *)p)->x;
 #else
-	return __get_le16_noalign(p);
+	return __get_le16_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u32 get_unaligned_le32(const void *p)
+static inline u32 load_le32_noalign(const __le32 *p)
 {
 #ifdef __LITTLE_ENDIAN
-	return ((const struct __una_u32 *)p)->x;
+	return ((__force const struct __una_u32 *)p)->x;
 #else
-	return __get_le32_noalign(p);
+	return __get_le32_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u64 get_unaligned_le64(const void *p)
+static inline u64 load_le64_noalign(const __le64 *p)
 {
 #ifdef __LITTLE_ENDIAN
-	return ((const struct __una_u64 *)p)->x;
+	return ((__force const struct __una_u64 *)p)->x;
 #else
-	return __get_le64_noalign(p);
+	return __get_le64_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u16 get_unaligned_be16(const void *p)
+static inline u16 load_be16_noalign(const __be16 *p)
 {
 #ifdef __BIG_ENDIAN
-	return ((const struct __una_u16 *)p)->x;
+	return ((__force const struct __una_u16 *)p)->x;
 #else
-	return __get_be16_noalign(p);
+	return __get_be16_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u32 get_unaligned_be32(const void *p)
+static inline u32 load_be32_noalign(const __be32 *p)
 {
 #ifdef __BIG_ENDIAN
-	return ((const struct __una_u32 *)p)->x;
+	return ((__force const struct __una_u32 *)p)->x;
 #else
-	return __get_be32_noalign(p);
+	return __get_be32_noalign((__force const u8 *)p);
 #endif
 }
 
-static inline u64 get_unaligned_be64(const void *p)
+static inline u64 load_be64_noalign(const __be64 *p)
 {
 #ifdef __BIG_ENDIAN
-	return ((const struct __una_u64 *)p)->x;
+	return ((__force const struct __una_u64 *)p)->x;
 #else
-	return __get_be64_noalign(p);
+	return __get_be64_noalign((__force const u8 *)p);
 #endif
 }
 
+# define get_unaligned_le16(p) load_le16_noalign((const void *)(p))
+# define get_unaligned_le32(p) load_le32_noalign((const void *)(p))
+# define get_unaligned_le64(p) load_le64_noalign((const void *)(p))
+# define get_unaligned_be16(p) load_be16_noalign((const void *)(p))
+# define get_unaligned_be32(p) load_be32_noalign((const void *)(p))
+# define get_unaligned_be64(p) load_be64_noalign((const void *)(p))
+
 static inline void __put_le16_noalign(u8 *p, u16 val)
 {
 	*p++ = val;
@@ -192,57 +213,57 @@ static inline void __put_be64_noalign(u8 *p, u64 val)
 	__put_be32_noalign(p + 4, val);
 }
 
-static inline void put_unaligned_le16(u16 val, void *p)
+static inline void store_le16_noalign(__le16 *p, u16 val)
 {
 #ifdef __LITTLE_ENDIAN
-	((struct __una_u16 *)p)->x = val;
+	((__force struct __una_u16 *)p)->x = val;
 #else
-	__put_le16_noalign(p, val);
+	__put_le16_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_le32(u32 val, void *p)
+static inline void store_le32_noalign(__le32 *p, u32 val)
 {
 #ifdef __LITTLE_ENDIAN
-	((struct __una_u32 *)p)->x = val;
+	((__force struct __una_u32 *)p)->x = val;
 #else
-	__put_le32_noalign(p, val);
+	__put_le32_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_le64(u64 val, void *p)
+static inline void store_le64_noalign(__le64 *p, u64 val)
 {
 #ifdef __LITTLE_ENDIAN
-	((struct __una_u64 *)p)->x = val;
+	((__force struct __una_u64 *)p)->x = val;
 #else
-	__put_le64_noalign(p, val);
+	__put_le64_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_be16(u16 val, void *p)
+static inline void store_be16_noalign(__be16 *p, u16 val)
 {
 #ifdef __BIG_ENDIAN
-	((struct __una_u16 *)p)->x = val;
+	((__force struct __una_u16 *)p)->x = val;
 #else
-	__put_be16_noalign(p, val);
+	__put_be16_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_be32(u32 val, void *p)
+static inline void store_be32_noalign(__be32 *p, u32 val)
 {
 #ifdef __BIG_ENDIAN
-	((struct __una_u32 *)p)->x = val;
+	((__force struct __una_u32 *)p)->x = val;
 #else
-	__put_be32_noalign(p, val);
+	__put_be32_noalign((__force u8 *)p, val);
 #endif
 }
 
-static inline void put_unaligned_be64(u64 val, void *p)
+static inline void store_be64_noalign(__be64 *p, u64 val)
 {
 #ifdef __BIG_ENDIAN
-	((struct __una_u64 *)p)->x = val;
+	((__force struct __una_u64 *)p)->x = val;
 #else
-	__put_be64_noalign(p, val);
+	__put_be64_noalign((__force u8 *)p, val);
 #endif
 }
 
@@ -256,17 +277,17 @@ extern void __bad_unaligned_access_size(void);
 
 #define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
 	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, load_le16_noalign(ptr),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, load_le32_noalign(ptr),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, load_le64_noalign(ptr),	\
 	__bad_unaligned_access_size()))));					\
 	}))
 
 #define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
 	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 2, load_be16_noalign(ptr),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 4, load_be32_noalign(ptr),	\
+	__builtin_choose_expr(sizeof(*(ptr)) == 8, load_be64_noalign(ptr),	\
 	__bad_unaligned_access_size()))));					\
 	}))
 
@@ -277,13 +298,13 @@ extern void __bad_unaligned_access_size(void);
 		*(u8 *)__gu_p = (__force u8)(val);			\
 		break;							\
 	case 2:								\
-		put_unaligned_le16((__force u16)(val), __gu_p);		\
+		store_le16_noalign(__gu_p, (__force u16)(val));		\
 		break;							\
 	case 4:								\
-		put_unaligned_le32((__force u32)(val), __gu_p);		\
+		store_le32_noalign(__gu_p, (__force u32)(val));		\
 		break;							\
 	case 8:								\
-		put_unaligned_le64((__force u64)(val), __gu_p);		\
+		store_le64_noalign(__gu_p, (__force u64)(val));		\
 		break;							\
 	default:							\
 		__bad_unaligned_access_size();				\
@@ -298,13 +319,13 @@ extern void __bad_unaligned_access_size(void);
 		*(u8 *)__gu_p = (__force u8)(val);			\
 		break;							\
 	case 2:								\
-		put_unaligned_be16((__force u16)(val), __gu_p);		\
+		store_be16_noalign(__gu_p, (__force u16)(val));		\
 		break;							\
 	case 4:								\
-		put_unaligned_be32((__force u32)(val), __gu_p);		\
+		store_be32_noalign(__gu_p, (__force u32)(val));		\
 		break;							\
 	case 8:								\
-		put_unaligned_be64((__force u64)(val), __gu_p);		\
+		store_be64_noalign(__gu_p, (__force u64)(val));		\
 		break;							\
 	default:							\
 		__bad_unaligned_access_size();				\
diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
index 29f002d..ba87b00 100644
--- a/include/linux/byteorder.h
+++ b/include/linux/byteorder.h
@@ -292,6 +292,20 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 # define cpu_to_be32 __cpu_to_be32
 # define cpu_to_be64 __cpu_to_be64
 
+# define load_le16 __le16_to_cpup
+# define load_le32 __le32_to_cpup
+# define load_le64 __le64_to_cpup
+# define load_be16 __be16_to_cpup
+# define load_be32 __be32_to_cpup
+# define load_be64 __be64_to_cpup
+
+# define store_le16(p, val)	(*(__le16 *)(p) = __cpu_to_le16(val))
+# define store_le32(p, val)	(*(__le32 *)(p) = __cpu_to_le32(val))
+# define store_le64(p, val)	(*(__le64 *)(p) = __cpu_to_le64(val))
+# define store_be16(p, val)	(*(__be16 *)(p) = __cpu_to_be16(val))
+# define store_be32(p, val)	(*(__be32 *)(p) = __cpu_to_be32(val))
+# define store_be64(p, val)	(*(__be64 *)(p) = __cpu_to_be64(val))
+
 # define le16_to_cpup __le16_to_cpup
 # define le32_to_cpup __le32_to_cpup
 # define le64_to_cpup __le64_to_cpup
@@ -340,32 +354,32 @@ static inline __be64 __cpu_to_be64p(const __u64 *p)
 
 static inline void le16_add_cpu(__le16 *var, u16 val)
 {
-	*var = cpu_to_le16(le16_to_cpup(var) + val);
+	store_le16(var, load_le16(var) + val);
 }
 
 static inline void le32_add_cpu(__le32 *var, u32 val)
 {
-	*var = cpu_to_le32(le32_to_cpup(var) + val);
+	store_le32(var, load_le32(var) + val);
 }
 
 static inline void le64_add_cpu(__le64 *var, u64 val)
 {
-	*var = cpu_to_le64(le64_to_cpup(var) + val);
+	store_le64(var, load_le64(var) + val);
 }
 
 static inline void be16_add_cpu(__be16 *var, u16 val)
 {
-	*var = cpu_to_be16(be16_to_cpup(var) + val);
+	store_be16(var, load_be16(var) + val);
 }
 
 static inline void be32_add_cpu(__be32 *var, u32 val)
 {
-	*var = cpu_to_be32(be32_to_cpup(var) + val);
+	store_be32(var, load_be32(var) + val);
 }
 
 static inline void be64_add_cpu(__be64 *var, u64 val)
 {
-	*var = cpu_to_be64(be64_to_cpup(var) + val);
+	store_be64(var, load_be64(var) + val);
 }
 
 #endif /* __KERNEL__ */
-- 
1.6.0.4.1013.gc6a01



