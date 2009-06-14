Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbZFNMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbZFNMCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbZFNMBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52658 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbZFNMBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 05/17] Blackfin: convert to generic checksum code
Date: Sun, 14 Jun 2009 08:01:06 -0400
Message-Id: <1244980878-2124-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin port only implemented an optimized version of the
csum_tcpudp_nofold function, so convert everything else to the new
generic code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                |    3 +
 arch/blackfin/include/asm/checksum.h |   72 +----------------
 arch/blackfin/lib/Makefile           |    2 +-
 arch/blackfin/lib/checksum.c         |  145 ----------------------------------
 4 files changed, 8 insertions(+), 214 deletions(-)
 delete mode 100644 arch/blackfin/lib/checksum.c

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 26e4858..fef8209 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -28,6 +28,9 @@ config BLACKFIN
 	select HAVE_OPROFILE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
+config GENERIC_CSUM
+	def_bool y
+
 config GENERIC_BUG
 	def_bool y
 	depends on BUG
diff --git a/arch/blackfin/include/asm/checksum.h b/arch/blackfin/include/asm/checksum.h
index 793581f..44837a9 100644
--- a/arch/blackfin/include/asm/checksum.h
+++ b/arch/blackfin/include/asm/checksum.h
@@ -2,65 +2,12 @@
 #define _BFIN_CHECKSUM_H
 
 /*
- * MODIFIED FOR BFIN April 30, 2001 akbar.hussain@lineo.com
- *
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
-__wsum csum_partial_copy(const void *src, void *dst,
-			       int len, __wsum sum);
-
-/*
- * the same as csum_partial_copy, but copies from user space.
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-
-extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
-					  int len, __wsum sum, int *csum_err);
-
-#define csum_partial_copy_nocheck(src, dst, len, sum)	\
-	csum_partial_copy((src), (dst), (len), (sum))
-
-__sum16 ip_fast_csum(unsigned char *iph, unsigned int ihl);
-
-/*
- *	Fold a partial checksum
- */
-
-static inline __sum16 csum_fold(__wsum sum)
-{
-	while (sum >> 16)
-		sum = (sum & 0xffff) + (sum >> 16);
-	return ((~(sum << 16)) >> 16);
-}
-
-/*
  * computes the checksum of the TCP/UDP pseudo-header
  * returns a 16-bit checksum, already complemented
  */
 
 static inline __wsum
-csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+__csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
 		   unsigned short proto, __wsum sum)
 {
 	unsigned int carry;
@@ -83,19 +30,8 @@ csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
 
 	return (sum);
 }
+#define csum_tcpudp_nofold __csum_tcpudp_nofold
 
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
-
-extern __sum16 ip_compute_csum(const void *buff, int len);
+#include <asm-generic/checksum.h>
 
-#endif				/* _BFIN_CHECKSUM_H */
+#endif
diff --git a/arch/blackfin/lib/Makefile b/arch/blackfin/lib/Makefile
index 635288f..42c47dc 100644
--- a/arch/blackfin/lib/Makefile
+++ b/arch/blackfin/lib/Makefile
@@ -5,7 +5,7 @@
 lib-y := \
 	ashldi3.o ashrdi3.o lshrdi3.o \
 	muldi3.o divsi3.o udivsi3.o modsi3.o umodsi3.o \
-	checksum.o memcpy.o memset.o memcmp.o memchr.o memmove.o \
+	memcpy.o memset.o memcmp.o memchr.o memmove.o \
 	strcmp.o strcpy.o strncmp.o strncpy.o \
 	umulsi3_highpart.o smulsi3_highpart.o \
 	ins.o outs.o
diff --git a/arch/blackfin/lib/checksum.c b/arch/blackfin/lib/checksum.c
deleted file mode 100644
index cd605e7..0000000
--- a/arch/blackfin/lib/checksum.c
+++ /dev/null
@@ -1,145 +0,0 @@
-/*
- * File:         arch/blackfin/lib/checksum.c
- * Based on:     none - original work
- * Author:
- *
- * Created:
- * Description:  An implementation of the TCP/IP protocol suite for the LINUX
- *               operating system.  INET is implemented using the  BSD Socket
- *               interface as the means of communication with the user level.
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <linux/module.h>
-#include <net/checksum.h>
-#include <asm/checksum.h>
-
-#ifdef CONFIG_IP_CHECKSUM_L1
-static unsigned short do_csum(const unsigned char *buff, int len)__attribute__((l1_text));
-#endif
-
-static unsigned short do_csum(const unsigned char *buff, int len)
-{
-	register unsigned long sum = 0;
-	int swappem = 0;
-
-	if (1 & (unsigned long)buff) {
-		sum = *buff << 8;
-		buff++;
-		len--;
-		++swappem;
-	}
-
-	while (len > 1) {
-		sum += *(unsigned short *)buff;
-		buff += 2;
-		len -= 2;
-	}
-
-	if (len > 0)
-		sum += *buff;
-
-	/*  Fold 32-bit sum to 16 bits */
-	while (sum >> 16)
-		sum = (sum & 0xffff) + (sum >> 16);
-
-	if (swappem)
-		sum = ((sum & 0xff00) >> 8) + ((sum & 0x00ff) << 8);
-
-	return sum;
-
-}
-
-/*
- *	This is a version of ip_compute_csum() optimized for IP headers,
- *	which always checksum on 4 octet boundaries.
- */
-__sum16 ip_fast_csum(unsigned char *iph, unsigned int ihl)
-{
-	return (__force __sum16)~do_csum(iph, ihl * 4);
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
-__wsum csum_partial(const void *buff, int len, __wsum sum)
-{
-	/*
-	 * Just in case we get nasty checksum data...
-	 * Like 0xffff6ec3 in the case of our IPv6 multicast header.
-	 * We fold to begin with, as well as at the end.
-	 */
-	sum = (sum & 0xffff) + (sum >> 16);
-
-	sum += do_csum(buff, len);
-
-	sum = (sum & 0xffff) + (sum >> 16);
-
-	return sum;
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
-
-__wsum
-csum_partial_copy_from_user(const void __user *src, void *dst,
-			    int len, __wsum sum, int *csum_err)
-{
-	if (csum_err)
-		*csum_err = 0;
-	memcpy(dst, (__force void *)src, len);
-	return csum_partial(dst, len, sum);
-}
-EXPORT_SYMBOL(csum_partial_copy_from_user);
-
-/*
- * copy from ds while checksumming, otherwise like csum_partial
- */
-
-__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
-{
-	memcpy(dst, src, len);
-	return csum_partial(dst, len, sum);
-}
-EXPORT_SYMBOL(csum_partial_copy);
-- 
1.6.3.1

