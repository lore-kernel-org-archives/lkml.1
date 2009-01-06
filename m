Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZAFVdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZAFVdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZAFVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:18234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZAFVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jg+vhmvVXdAY5G13Q2lbn6tMA3Pm9KPL4FemnVzCPfrUSdqRn42TxWl4jWjybD/VB7
         aesZYzBpNC0+/dLWdl/XlJphxSajxDJOUS79bxaHm2Xz61KZHWmXL6MIQvwxEbwaJBEA
         wfHQIlAppckZn4QfNw/FgU3y0P8hwR6ewVwH8=
Subject: [PATCH 06/23] powerpc: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:48 -0800
Message-Id: <1231277448.964.263.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/powerpc/include/asm/Kbuild      |    1 +
 arch/powerpc/include/asm/byteorder.h |   83 +------------------------------
 arch/powerpc/include/asm/swab.h      |   90 ++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 81 deletions(-)

diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 5ab7d7f..9268602 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -35,3 +35,4 @@ unifdef-y += spu_info.h
 unifdef-y += termios.h
 unifdef-y += types.h
 unifdef-y += unistd.h
+unifdef-y += swab.h
diff --git a/arch/powerpc/include/asm/byteorder.h b/arch/powerpc/include/asm/byteorder.h
index d5de325..5cca27a 100644
--- a/arch/powerpc/include/asm/byteorder.h
+++ b/arch/powerpc/include/asm/byteorder.h
@@ -8,86 +8,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-#define __BIG_ENDIAN
-
-#ifdef __GNUC__
-#ifdef __KERNEL__
-
-static __inline__ __u16 ld_le16(const volatile __u16 *addr)
-{
-	__u16 val;
-
-	__asm__ __volatile__ ("lhbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
-	return val;
-}
-#define __arch_swab16p ld_le16
-
-static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
-{
-	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
-}
-
-static inline void __arch_swab16s(__u16 *addr)
-{
-	st_le16(addr, *addr);
-}
-#define __arch_swab16s __arch_swab16s
-
-static __inline__ __u32 ld_le32(const volatile __u32 *addr)
-{
-	__u32 val;
-
-	__asm__ __volatile__ ("lwbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
-	return val;
-}
-#define __arch_swab32p ld_le32
-
-static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)
-{
-	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
-}
-
-static inline void __arch_swab32s(__u32 *addr)
-{
-	st_le32(addr, *addr);
-}
-#define __arch_swab32s __arch_swab32s
-
-static inline __attribute_const__ __u16 __arch_swab16(__u16 value)
-{
-	__u16 result;
-
-	__asm__("rlwimi %0,%1,8,16,23"
-	    : "=r" (result)
-	    : "r" (value), "0" (value >> 8));
-	return result;
-}
-#define __arch_swab16 __arch_swab16
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 value)
-{
-	__u32 result;
-
-	__asm__("rlwimi %0,%1,24,16,23\n\t"
-	    "rlwimi %0,%1,8,8,15\n\t"
-	    "rlwimi %0,%1,24,0,7"
-	    : "=r" (result)
-	    : "r" (value), "0" (value >> 24));
-	return result;
-}
-#define __arch_swab32 __arch_swab32
-
-#endif /* __KERNEL__ */
-
-#ifndef __powerpc64__
-#define __SWAB_64_THRU_32__
-#endif /* __powerpc64__ */
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
diff --git a/arch/powerpc/include/asm/swab.h b/arch/powerpc/include/asm/swab.h
new file mode 100644
index 0000000..ef824ae
--- /dev/null
+++ b/arch/powerpc/include/asm/swab.h
@@ -0,0 +1,90 @@
+#ifndef _ASM_POWERPC_SWAB_H
+#define _ASM_POWERPC_SWAB_H
+
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#ifdef __GNUC__
+
+#ifndef __powerpc64__
+#define __SWAB_64_THRU_32__
+#endif /* __powerpc64__ */
+
+#ifdef __KERNEL__
+
+static __inline__ __u16 ld_le16(const volatile __u16 *addr)
+{
+	__u16 val;
+
+	__asm__ __volatile__ ("lhbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
+	return val;
+}
+#define __arch_swab16p ld_le16
+
+static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
+{
+	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
+}
+
+static inline void __arch_swab16s(__u16 *addr)
+{
+	st_le16(addr, *addr);
+}
+#define __arch_swab16s __arch_swab16s
+
+static __inline__ __u32 ld_le32(const volatile __u32 *addr)
+{
+	__u32 val;
+
+	__asm__ __volatile__ ("lwbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
+	return val;
+}
+#define __arch_swab32p ld_le32
+
+static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)
+{
+	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
+}
+
+static inline void __arch_swab32s(__u32 *addr)
+{
+	st_le32(addr, *addr);
+}
+#define __arch_swab32s __arch_swab32s
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 value)
+{
+	__u16 result;
+
+	__asm__("rlwimi %0,%1,8,16,23"
+	    : "=r" (result)
+	    : "r" (value), "0" (value >> 8));
+	return result;
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 value)
+{
+	__u32 result;
+
+	__asm__("rlwimi %0,%1,24,16,23\n\t"
+	    "rlwimi %0,%1,8,8,15\n\t"
+	    "rlwimi %0,%1,24,0,7"
+	    : "=r" (result)
+	    : "r" (value), "0" (value >> 24));
+	return result;
+}
+#define __arch_swab32 __arch_swab32
+
+#endif /* __KERNEL__ */
+
+#endif /* __GNUC__ */
+
+#endif /* _ASM_POWERPC_SWAB_H */
-- 
1.6.1.94.g9388


