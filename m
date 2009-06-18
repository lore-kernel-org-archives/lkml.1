Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbZFRSB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbZFRSB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZFRSBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:01:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFRSA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:00:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 08/11] microblaze: use the generic lib/checksum.c
Date: Thu, 18 Jun 2009 19:55:32 +0200
Message-Id: <612591dcc1943bc8d518d6447b37df26053068fb.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/nmCZPTbHEOeA5Bj3M+7/QeyhOQoY9i6FTG0y
 g/FeXyJmWZxINfB83GlfZ6LvJo/OFQgG0G0kAE09HmGuC6SqJO
 mDxwYQ2aGdMT3e1yfMSRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remis Lima Baima <remis.developer@googlemail.com>

The microblaze checksum code is mostly identical to
the asm-generic+lib version, so use that instead.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/microblaze/Kconfig                |    3 +
 arch/microblaze/include/asm/checksum.h |  134 ++++++------------------
 arch/microblaze/lib/Makefile           |    2 +-
 arch/microblaze/lib/checksum.c         |  172 --------------------------------
 4 files changed, 38 insertions(+), 273 deletions(-)
 rewrite arch/microblaze/include/asm/checksum.h (69%)
 delete mode 100644 arch/microblaze/lib/checksum.c

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 8b4de19..8ee1c85 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -56,6 +56,9 @@ config GENERIC_GPIO
 config GENERIC_SYSCALL_TABLE
 	def_bool y
 
+config GENERIC_CSUM
+	def_bool y
+
 config PCI
 	def_bool n
 
diff --git a/arch/microblaze/include/asm/checksum.h b/arch/microblaze/include/asm/checksum.h
dissimilarity index 69%
index 97ea46b..128bf03 100644
--- a/arch/microblaze/include/asm/checksum.h
+++ b/arch/microblaze/include/asm/checksum.h
@@ -1,100 +1,34 @@
-/*
- * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_CHECKSUM_H
-#define _ASM_MICROBLAZE_CHECKSUM_H
-
-#include <linux/in6.h>
-
-/*
- * computes the checksum of the TCP/UDP pseudo-header
- * returns a 16-bit checksum, already complemented
- */
-static inline __wsum
-csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
-		   unsigned short proto, __wsum sum)
-{
-	__asm__("add %0, %0, %1\n\t"
-		"addc %0, %0, %2\n\t"
-		"addc %0, %0, %3\n\t"
-		"addc %0, %0, r0\n\t"
-		: "+&d" (sum)
-		: "d" (saddr), "d" (daddr), "d" (len + proto));
-
-	return sum;
-}
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
-extern __wsum csum_partial(const void *buff, int len, __wsum sum);
-
-/*
- * the same as csum_partial, but copies from src while it
- * checksums
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-extern __wsum csum_partial_copy(const void *src, void *dst, int len,
-								__wsum sum);
-
-/*
- * the same as csum_partial_copy, but copies from user space.
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
-					int len, __wsum sum, int *csum_err);
-
-#define csum_partial_copy_nocheck(src, dst, len, sum)	\
-	csum_partial_copy((src), (dst), (len), (sum))
-
-/*
- *	This is a version of ip_compute_csum() optimized for IP headers,
- *	which always checksum on 4 octet boundaries.
- *
- */
-extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
-
-/*
- *	Fold a partial checksum
- */
-static inline __sum16 csum_fold(__wsum csum)
-{
-	u32 sum = (__force u32)csum;
-	sum = (sum & 0xffff) + (sum >> 16);
-	sum = (sum & 0xffff) + (sum >> 16);
-	return (__force __sum16)~sum;
-}
-
-static inline __sum16
-csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
-		  unsigned short proto, __wsum sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
-}
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-extern __sum16 ip_compute_csum(const void *buff, int len);
-
-#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_CHECKSUM_H
+#define _ASM_MICROBLAZE_CHECKSUM_H
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+#define csum_tcpudp_nofold	csum_tcpudp_nofold
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
+{
+	__asm__("add %0, %0, %1\n\t"
+		"addc %0, %0, %2\n\t"
+		"addc %0, %0, %3\n\t"
+		"addc %0, %0, r0\n\t"
+		: "+&d" (sum)
+		: "d" (saddr), "d" (daddr), "d" (len + proto));
+
+	return sum;
+}
+
+#include <asm-generic/checksum.h>
+
+#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
diff --git a/arch/microblaze/lib/Makefile b/arch/microblaze/lib/Makefile
index 71c8cb6..b579db0 100644
--- a/arch/microblaze/lib/Makefile
+++ b/arch/microblaze/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile
 #
 
-lib-y :=  memset.o checksum.o
+lib-y :=  memset.o
 
 ifeq ($(CONFIG_OPT_LIB_ASM),y)
 lib-y += fastcopy.o
diff --git a/arch/microblaze/lib/checksum.c b/arch/microblaze/lib/checksum.c
deleted file mode 100644
index f08e745..0000000
--- a/arch/microblaze/lib/checksum.c
+++ /dev/null
@@ -1,172 +0,0 @@
-/*
- *
- * INET		An implementation of the TCP/IP protocol suite for the LINUX
- *		operating system.  INET is implemented using the  BSD Socket
- *		interface as the means of communication with the user level.
- *
- *		IP/TCP/UDP checksumming routines
- *
- * Authors:	Jorge Cwik, <jorge@laser.satlink.net>
- *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
- *		Tom May, <ftom@netcom.com>
- *		Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
- *		Lots of code moved from tcp.c and ip.c; see those files
- *		for more names.
- *
- * 03/02/96	Jes Sorensen, Andreas Schwab, Roman Hodek:
- *		Fixed some nasty bugs, causing some horrible crashes.
- *		A: At some points, the sum (%0) was used as
- *		length-counter instead of the length counter
- *		(%1). Thanks to Roman Hodek for pointing this out.
- *		B: GCC seems to mess up if one uses too many
- *		data-registers to hold input values and one tries to
- *		specify d0 and d1 as scratch registers. Letting gcc
- *		choose these registers itself solves the problem.
- *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- */
-
-/* Revised by Kenneth Albanowski for m68knommu. Basic problem: unaligned access
- kills, so most of the assembly has to go. */
-
-#include <linux/module.h>
-#include <net/checksum.h>
-
-#include <asm/byteorder.h>
-
-static inline unsigned short from32to16(unsigned long x)
-{
-	/* add up 16-bit and 16-bit for 16+c bit */
-	x = (x & 0xffff) + (x >> 16);
-	/* add up carry.. */
-	x = (x & 0xffff) + (x >> 16);
-	return x;
-}
-
-static unsigned int do_csum(const unsigned char *buff, int len)
-{
-	int odd, count;
-	unsigned long result = 0;
-
-	if (len <= 0)
-		goto out;
-	odd = 1 & (unsigned long) buff;
-	if (odd) {
-		result = *buff;
-		len--;
-		buff++;
-	}
-	count = len >> 1;		/* nr of 16-bit words.. */
-	if (count) {
-		if (2 & (unsigned long) buff) {
-			result += *(unsigned short *) buff;
-			count--;
-			len -= 2;
-			buff += 2;
-		}
-		count >>= 1;		/* nr of 32-bit words.. */
-		if (count) {
-			unsigned long carry = 0;
-			do {
-				unsigned long w = *(unsigned long *) buff;
-				count--;
-				buff += 4;
-				result += carry;
-				result += w;
-				carry = (w > result);
-			} while (count);
-			result += carry;
-			result = (result & 0xffff) + (result >> 16);
-		}
-		if (len & 2) {
-			result += *(unsigned short *) buff;
-			buff += 2;
-		}
-	}
-	if (len & 1)
-		result += (*buff << 8);
-	result = from32to16(result);
-	if (odd)
-		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
-out:
-	return result;
-}
-
-/*
- *	This is a version of ip_compute_csum() optimized for IP headers,
- *	which always checksum on 4 octet boundaries.
- */
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
-{
-	return (__force __sum16)~do_csum(iph, ihl*4);
-}
-EXPORT_SYMBOL(ip_fast_csum);
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
-__wsum csum_partial(const void *buff, int len, __wsum wsum)
-{
-	unsigned int sum = (__force unsigned int)wsum;
-	unsigned int result = do_csum(buff, len);
-
-	/* add in old sum, and carry.. */
-	result += sum;
-	if (sum > result)
-		result += 1;
-	return (__force __wsum)result;
-}
-EXPORT_SYMBOL(csum_partial);
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-__sum16 ip_compute_csum(const void *buff, int len)
-{
-	return (__force __sum16)~do_csum(buff, len);
-}
-EXPORT_SYMBOL(ip_compute_csum);
-
-/*
- * copy from fs while checksumming, otherwise like csum_partial
- */
-__wsum
-csum_partial_copy_from_user(const void __user *src, void *dst, int len,
-						__wsum sum, int *csum_err)
-{
-	int missing;
-
-	missing = __copy_from_user(dst, src, len);
-	if (missing) {
-		memset(dst + len - missing, 0, missing);
-		*csum_err = -EFAULT;
-	} else
-		*csum_err = 0;
-
-	return csum_partial(dst, len, sum);
-}
-EXPORT_SYMBOL(csum_partial_copy_from_user);
-
-/*
- * copy from ds while checksumming, otherwise like csum_partial
- */
-__wsum
-csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
-{
-	memcpy(dst, src, len);
-	return csum_partial(dst, len, sum);
-}
-EXPORT_SYMBOL(csum_partial_copy);
-- 
1.6.3.1

