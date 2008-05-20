Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYETTZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYETTZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbYETTYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:24:25 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:1880 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198AbYETTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rWtO+IuHeyxqieR2bnLfqukAafCog+q70gEMqIL+A7PkwntxGZnWfeRGpFXrBSvaDpjuZd6yDqUeNVYoVyX8lPgG9q3WZ/QLjMlQLmyjC3mAzK4HT0is27V0TpJ3uqW7nFmmO4/8A0RIopdZ/YEorViNHxTC3NwxJu/ytRj3eiY=
Subject: [PATCH 2/2] byteorder: eliminate pointer bytorder api
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 12:24:09 -0700
Message-Id: <1211311449.5915.195.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a great api, should be using cpu_to_etc and deref the pointer yourself.
cpu_to_le16p
cpu_to_le32p
cpu_to_le64p
cpu_to_be16p
cpu_to_be32p
cpu_to_be64p

Replaced by the aligned get_/put_ helpers
le16_to_cpup
le32_to_cpup
le64_to_cpup
be16_to_cpup
be32_to_cpup
be64_to_cpup

Also add const to the get/put helpers and use them in the access_ok case for
unaligned access.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/byteorder/big_endian.h    |   50 +-----------------------------
 include/linux/byteorder/generic.h       |   24 ++++-----------
 include/linux/byteorder/little_endian.h |   50 +-----------------------------
 include/linux/unaligned/access_ok.h     |   12 ++++----
 4 files changed, 16 insertions(+), 120 deletions(-)

diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index 961ed4b..c9a5bd7 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -15,6 +15,7 @@
 #define __constant_ntohl(x) ((__force __u32)(__be32)(x))
 #define __constant_htons(x) ((__force __be16)(__u16)(x))
 #define __constant_ntohs(x) ((__force __u16)(__be16)(x))
+
 #define __constant_cpu_to_le64(x) ((__force __le64)___constant_swab64((x)))
 #define __constant_le64_to_cpu(x) ___constant_swab64((__force __u64)(__le64)(x))
 #define __constant_cpu_to_le32(x) ((__force __le32)___constant_swab32((x)))
@@ -27,6 +28,7 @@
 #define __constant_be32_to_cpu(x) ((__force __u32)(__be32)(x))
 #define __constant_cpu_to_be16(x) ((__force __be16)(__u16)(x))
 #define __constant_be16_to_cpu(x) ((__force __u16)(__be16)(x))
+
 #define __cpu_to_le64(x) ((__force __le64)__swab64((x)))
 #define __le64_to_cpu(x) __swab64((__force __u64)(__le64)(x))
 #define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
@@ -40,54 +42,6 @@
 #define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
 #define __be16_to_cpu(x) ((__force __u16)(__be16)(x))
 
-static inline __le64 __cpu_to_le64p(const __u64 *p)
-{
-	return (__force __le64)__swab64p(p);
-}
-static inline __u64 __le64_to_cpup(const __le64 *p)
-{
-	return __swab64p((__u64 *)p);
-}
-static inline __le32 __cpu_to_le32p(const __u32 *p)
-{
-	return (__force __le32)__swab32p(p);
-}
-static inline __u32 __le32_to_cpup(const __le32 *p)
-{
-	return __swab32p((__u32 *)p);
-}
-static inline __le16 __cpu_to_le16p(const __u16 *p)
-{
-	return (__force __le16)__swab16p(p);
-}
-static inline __u16 __le16_to_cpup(const __le16 *p)
-{
-	return __swab16p((__u16 *)p);
-}
-static inline __be64 __cpu_to_be64p(const __u64 *p)
-{
-	return (__force __be64)*p;
-}
-static inline __u64 __be64_to_cpup(const __be64 *p)
-{
-	return (__force __u64)*p;
-}
-static inline __be32 __cpu_to_be32p(const __u32 *p)
-{
-	return (__force __be32)*p;
-}
-static inline __u32 __be32_to_cpup(const __be32 *p)
-{
-	return (__force __u32)*p;
-}
-static inline __be16 __cpu_to_be16p(const __u16 *p)
-{
-	return (__force __be16)*p;
-}
-static inline __u16 __be16_to_cpup(const __be16 *p)
-{
-	return (__force __u16)*p;
-}
 #define __cpu_to_le64s(x) __swab64s((x))
 #define __le64_to_cpus(x) __swab64s((x))
 #define __cpu_to_le32s(x) __swab32s((x))
diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 1f0c07e..fee629f 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -94,18 +94,6 @@
 #define be32_to_cpu __be32_to_cpu
 #define cpu_to_be16 __cpu_to_be16
 #define be16_to_cpu __be16_to_cpu
-#define cpu_to_le64p __cpu_to_le64p
-#define le64_to_cpup __le64_to_cpup
-#define cpu_to_le32p __cpu_to_le32p
-#define le32_to_cpup __le32_to_cpup
-#define cpu_to_le16p __cpu_to_le16p
-#define le16_to_cpup __le16_to_cpup
-#define cpu_to_be64p __cpu_to_be64p
-#define be64_to_cpup __be64_to_cpup
-#define cpu_to_be32p __cpu_to_be32p
-#define be32_to_cpup __be32_to_cpup
-#define cpu_to_be16p __cpu_to_be16p
-#define be16_to_cpup __be16_to_cpup
 #define cpu_to_le64s __cpu_to_le64s
 #define le64_to_cpus __le64_to_cpus
 #define cpu_to_le32s __cpu_to_le32s
@@ -119,32 +107,32 @@
 #define cpu_to_be16s __cpu_to_be16s
 #define be16_to_cpus __be16_to_cpus
 
-static inline u16 get_le16(void *ptr)
+static inline u16 get_le16(const void *ptr)
 {
 	return le16_to_cpu(*(__le16 *)ptr);
 }
 
-static inline u32 get_le32(void *ptr)
+static inline u32 get_le32(const void *ptr)
 {
 	return le32_to_cpu(*(__le32 *)ptr);
 }
 
-static inline u64 get_le64(void *ptr)
+static inline u64 get_le64(const void *ptr)
 {
 	return le64_to_cpu(*(__le64 *)ptr);
 }
 
-static inline u16 get_be16(void *ptr)
+static inline u16 get_be16(const void *ptr)
 {
 	return be16_to_cpu(*(__be16 *)ptr);
 }
 
-static inline u32 get_be32(void *ptr)
+static inline u32 get_be32(const void *ptr)
 {
 	return be32_to_cpu(*(__be32 *)ptr);
 }
 
-static inline u64 get_be64(void *ptr)
+static inline u64 get_be64(const void *ptr)
 {
 	return be64_to_cpu(*(__be64 *)ptr);
 }
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index 05dc7c3..6ad96f6 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -15,6 +15,7 @@
 #define __constant_ntohl(x) ___constant_swab32((__force __be32)(x))
 #define __constant_htons(x) ((__force __be16)___constant_swab16((x)))
 #define __constant_ntohs(x) ___constant_swab16((__force __be16)(x))
+
 #define __constant_cpu_to_le64(x) ((__force __le64)(__u64)(x))
 #define __constant_le64_to_cpu(x) ((__force __u64)(__le64)(x))
 #define __constant_cpu_to_le32(x) ((__force __le32)(__u32)(x))
@@ -27,6 +28,7 @@
 #define __constant_be32_to_cpu(x) ___constant_swab32((__force __u32)(__be32)(x))
 #define __constant_cpu_to_be16(x) ((__force __be16)___constant_swab16((x)))
 #define __constant_be16_to_cpu(x) ___constant_swab16((__force __u16)(__be16)(x))
+
 #define __cpu_to_le64(x) ((__force __le64)(__u64)(x))
 #define __le64_to_cpu(x) ((__force __u64)(__le64)(x))
 #define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
@@ -40,54 +42,6 @@
 #define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
 #define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))
 
-static inline __le64 __cpu_to_le64p(const __u64 *p)
-{
-	return (__force __le64)*p;
-}
-static inline __u64 __le64_to_cpup(const __le64 *p)
-{
-	return (__force __u64)*p;
-}
-static inline __le32 __cpu_to_le32p(const __u32 *p)
-{
-	return (__force __le32)*p;
-}
-static inline __u32 __le32_to_cpup(const __le32 *p)
-{
-	return (__force __u32)*p;
-}
-static inline __le16 __cpu_to_le16p(const __u16 *p)
-{
-	return (__force __le16)*p;
-}
-static inline __u16 __le16_to_cpup(const __le16 *p)
-{
-	return (__force __u16)*p;
-}
-static inline __be64 __cpu_to_be64p(const __u64 *p)
-{
-	return (__force __be64)__swab64p(p);
-}
-static inline __u64 __be64_to_cpup(const __be64 *p)
-{
-	return __swab64p((__u64 *)p);
-}
-static inline __be32 __cpu_to_be32p(const __u32 *p)
-{
-	return (__force __be32)__swab32p(p);
-}
-static inline __u32 __be32_to_cpup(const __be32 *p)
-{
-	return __swab32p((__u32 *)p);
-}
-static inline __be16 __cpu_to_be16p(const __u16 *p)
-{
-	return (__force __be16)__swab16p(p);
-}
-static inline __u16 __be16_to_cpup(const __be16 *p)
-{
-	return __swab16p((__u16 *)p);
-}
 #define __cpu_to_le64s(x) do {} while (0)
 #define __le64_to_cpus(x) do {} while (0)
 #define __cpu_to_le32s(x) do {} while (0)
diff --git a/include/linux/unaligned/access_ok.h b/include/linux/unaligned/access_ok.h
index 99c1b4d..c16698a 100644
--- a/include/linux/unaligned/access_ok.h
+++ b/include/linux/unaligned/access_ok.h
@@ -6,32 +6,32 @@
 
 static inline u16 get_unaligned_le16(const void *p)
 {
-	return le16_to_cpup((__le16 *)p);
+	return get_le16(p);
 }
 
 static inline u32 get_unaligned_le32(const void *p)
 {
-	return le32_to_cpup((__le32 *)p);
+	return get_le32(p);
 }
 
 static inline u64 get_unaligned_le64(const void *p)
 {
-	return le64_to_cpup((__le64 *)p);
+	return get_le64(p);
 }
 
 static inline u16 get_unaligned_be16(const void *p)
 {
-	return be16_to_cpup((__be16 *)p);
+	return get_be16(p);
 }
 
 static inline u32 get_unaligned_be32(const void *p)
 {
-	return be32_to_cpup((__be32 *)p);
+	return get_be32(p);
 }
 
 static inline u64 get_unaligned_be64(const void *p)
 {
-	return be64_to_cpup((__be64 *)p);
+	return get_be64(p);
 }
 
 static inline void put_unaligned_le16(u16 val, void *p)
-- 
1.5.5.1.570.g26b5e

