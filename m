Return-Path: <linux-kernel-owner+w=401wt.eu-S1764977AbZFQHME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764977AbZFQHME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZFQHLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:11:25 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:60176 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764458AbZFQHLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:11:23 -0400
Date: Wed, 17 Jun 2009 17:11:15 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200906170711.n5H7BFw9009030@localhost.localdomain>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: merge the mmu and non-mmu versions of checksum.h
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] m68k: merge the mmu and non-mmu versions of checksum.h

There is only minimal difference between the mmu and non-mmu versions
of checksum.h. Most of its contents is shared. Merge the two separate
files back into a single checksum.h.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 .../m68k/include/asm/{checksum_mm.h => checksum.h} |   11 ++
 arch/m68k/include/asm/checksum_no.h                |  132 --------------------
 arch/m68knommu/lib/checksum.c                      |    9 --
 3 files changed, 11 insertions(+), 141 deletions(-)
 rename arch/m68k/include/asm/{checksum_mm.h => checksum.h} (93%)
 delete mode 100644 arch/m68k/include/asm/checksum_no.h

diff --git a/arch/m68k/include/asm/checksum_mm.h b/arch/m68k/include/asm/checksum.h
similarity index 93%
rename from arch/m68k/include/asm/checksum_mm.h
rename to arch/m68k/include/asm/checksum.h
index 494f9ae..87cabc3 100644
--- a/arch/m68k/include/asm/checksum_mm.h
+++ b/arch/m68k/include/asm/checksum.h
@@ -34,6 +34,8 @@ extern __wsum csum_partial_copy_nocheck(const void *src,
 					      void *dst, int len,
 					      __wsum sum);
 
+
+#ifdef CONFIG_MMU
 /*
  *	This is a version of ip_compute_csum() optimized for IP headers,
  *	which always checksum on 4 octet boundaries.
@@ -59,6 +61,9 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 		 : "memory");
 	return (__force __sum16)~sum;
 }
+#else
+__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+#endif
 
 /*
  *	Fold a partial checksum
@@ -67,6 +72,11 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
 static inline __sum16 csum_fold(__wsum sum)
 {
 	unsigned int tmp = (__force u32)sum;
+#ifdef CONFIG_COLDFIRE
+	tmp = (tmp & 0xffff) + (tmp >> 16);
+	tmp = (tmp & 0xffff) + (tmp >> 16);
+	return (__force __sum16)~tmp;
+#else
 	__asm__("swap %1\n\t"
 		"addw %1, %0\n\t"
 		"clrw %1\n\t"
@@ -74,6 +84,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		: "=&d" (sum), "=&d" (tmp)
 		: "0" (sum), "1" (tmp));
 	return (__force __sum16)~sum;
+#endif
 }
 
 
diff --git a/arch/m68k/include/asm/checksum_no.h b/arch/m68k/include/asm/checksum_no.h
deleted file mode 100644
index 8188348..0000000
--- a/arch/m68k/include/asm/checksum_no.h
+++ /dev/null
@@ -1,132 +0,0 @@
-#ifndef _M68K_CHECKSUM_H
-#define _M68K_CHECKSUM_H
-
-#include <linux/in6.h>
-
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 32-bit boundary
- */
-__wsum csum_partial(const void *buff, int len, __wsum sum);
-
-/*
- * the same as csum_partial, but copies from src while it
- * checksums
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-
-__wsum csum_partial_copy_nocheck(const void *src, void *dst,
-	int len, __wsum sum);
-
-
-/*
- * the same as csum_partial_copy, but copies from user space.
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-
-extern __wsum csum_partial_copy_from_user(const void __user *src,
-	void *dst, int len, __wsum sum, int *csum_err);
-
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
-
-/*
- *	Fold a partial checksum
- */
-
-static inline __sum16 csum_fold(__wsum sum)
-{
-	unsigned int tmp = (__force u32)sum;
-#ifdef CONFIG_COLDFIRE
-	tmp = (tmp & 0xffff) + (tmp >> 16);
-	tmp = (tmp & 0xffff) + (tmp >> 16);
-	return (__force __sum16)~tmp;
-#else
-	__asm__("swap %1\n\t"
-		"addw %1, %0\n\t"
-		"clrw %1\n\t"
-		"addxw %1, %0"
-		: "=&d" (sum), "=&d" (tmp)
-		: "0" (sum), "1" (sum));
-	return (__force __sum16)~sum;
-#endif
-}
-
-
-/*
- * computes the checksum of the TCP/UDP pseudo-header
- * returns a 16-bit checksum, already complemented
- */
-
-static inline __wsum
-csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
-		  unsigned short proto, __wsum sum)
-{
-	__asm__ ("addl  %1,%0\n\t"
-		 "addxl %4,%0\n\t"
-		 "addxl %5,%0\n\t"
-		 "clrl %1\n\t"
-		 "addxl %1,%0"
-		 : "=&d" (sum), "=&d" (saddr)
-		 : "0" (daddr), "1" (saddr), "d" (len + proto),
-		   "d"(sum));
-	return sum;
-}
-
-static inline __sum16
-csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
-		  unsigned short proto, __wsum sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr,daddr,len,proto,sum));
-}
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-
-extern __sum16 ip_compute_csum(const void *buff, int len);
-
-#define _HAVE_ARCH_IPV6_CSUM
-static __inline__ __sum16
-csum_ipv6_magic(const struct in6_addr *saddr, const struct in6_addr *daddr,
-		__u32 len, unsigned short proto, __wsum sum)
-{
-	register unsigned long tmp;
-	__asm__("addl %2@,%0\n\t"
-		"movel %2@(4),%1\n\t"
-		"addxl %1,%0\n\t"
-		"movel %2@(8),%1\n\t"
-		"addxl %1,%0\n\t"
-		"movel %2@(12),%1\n\t"
-		"addxl %1,%0\n\t"
-		"movel %3@,%1\n\t"
-		"addxl %1,%0\n\t"
-		"movel %3@(4),%1\n\t"
-		"addxl %1,%0\n\t"
-		"movel %3@(8),%1\n\t"
-		"addxl %1,%0\n\t"
-		"movel %3@(12),%1\n\t"
-		"addxl %1,%0\n\t"
-		"addxl %4,%0\n\t"
-		"clrl %1\n\t"
-		"addxl %1,%0"
-		: "=&d" (sum), "=&d" (tmp)
-		: "a" (saddr), "a" (daddr), "d" (len + proto),
-		  "0" (sum));
-
-	return csum_fold(sum);
-}
-
-#endif /* _M68K_CHECKSUM_H */
diff --git a/arch/m68knommu/lib/checksum.c b/arch/m68knommu/lib/checksum.c
index 269d83b..8bf012a 100644
--- a/arch/m68knommu/lib/checksum.c
+++ b/arch/m68knommu/lib/checksum.c
@@ -127,15 +127,6 @@ __wsum csum_partial(const void *buff, int len, __wsum sum)
 EXPORT_SYMBOL(csum_partial);
 
 /*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-__sum16 ip_compute_csum(const void *buff, int len)
-{
-	return (__force __sum16)~do_csum(buff,len);
-}
-
-/*
  * copy from fs while checksumming, otherwise like csum_partial
  */
 
