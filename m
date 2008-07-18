Return-Path: <linux-kernel-owner+w=401wt.eu-S934081AbYGRAQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbYGRAQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbYGRAKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:18 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57350 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbYGRAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GvX+VZJjVz5/TQYzFFy+JZ7Oa9LmMe5EfQkeEV1a/ZT/Bl3d0r9tc07CdrxwPeygvo
         mUXcsq/jGgTk87WujVr/l1ov6FOHXEbdJk3zn3bLtpzsbJfrz5U2TgUKfMJ2q2mxx/Vg
         r2qHtGuhQXGpOCwKKfcDlZzoNve5LTQupG5ME=
Subject: [PATCH 15/20] powerpc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:43 -0700
Message-Id: <1216339783.6029.126.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-powerpc/byteorder.h |   49 ++++++++++++++------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/include/asm-powerpc/byteorder.h b/include/asm-powerpc/byteorder.h
index b377522..9608169 100644
--- a/include/asm-powerpc/byteorder.h
+++ b/include/asm-powerpc/byteorder.h
@@ -11,36 +11,43 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
-#ifdef __KERNEL__
+#define __BIG_ENDIAN
 
-static __inline__ __u16 ld_le16(const volatile __u16 *addr)
+#ifndef __powerpc64__
+# define __SWAB_64_THRU_32__
+#endif
+
+static inline __u16 __arch_swab16p(const volatile __u16 *addr)
 {
 	__u16 val;
 
 	__asm__ __volatile__ ("lhbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define HAVE_ARCH_SWAB16P
 
-static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
+static inline void __arch_swab16s(volatile __u16 *addr, const __u16 val)
 {
 	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
+#define HAVE_ARCH_SWAB16S
 
-static __inline__ __u32 ld_le32(const volatile __u32 *addr)
+static inline __u32 __arch_swab32p(const volatile __u32 *addr)
 {
 	__u32 val;
 
 	__asm__ __volatile__ ("lwbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define HAVE_ARCH_SWAB32P
 
-static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)
+static inline void __arch_swab32s(volatile __u32 *addr, const __u32 val)
 {
 	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
+#define HAVE_ARCH_SWAB32S
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 value)
 {
 	__u16 result;
 
@@ -49,8 +56,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
 	    : "r" (value), "0" (value >> 8));
 	return result;
 }
+#define HAVE_ARCH_SWAB16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 value)
 {
 	__u32 result;
 
@@ -61,29 +69,8 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
 	    : "r" (value), "0" (value >> 24));
 	return result;
 }
+#define HAVE_ARCH_SWAB32
 
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-/* The same, but returns converted value from the location pointer by addr. */
-#define __arch__swab16p(addr) ld_le16(addr)
-#define __arch__swab32p(addr) ld_le32(addr)
-
-/* The same, but do the conversion in situ, ie. put the value back to addr. */
-#define __arch__swab16s(addr) st_le16(addr,*addr)
-#define __arch__swab32s(addr) st_le32(addr,*addr)
-
-#endif /* __KERNEL__ */
-
-#ifndef __STRICT_ANSI__
-#define __BYTEORDER_HAS_U64__
-#ifndef __powerpc64__
-#define __SWAB_64_THRU_32__
-#endif /* __powerpc64__ */
-#endif /* __STRICT_ANSI__ */
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


