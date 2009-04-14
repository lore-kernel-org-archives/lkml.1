Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZD3PvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZD3PvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbZD3Pmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbZD3PmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:05 -0400
Message-Id: <e67551afee4d58da3bbb0ae9c4f4f1b41af8c719.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Remis Lima Baima <remis.developer@googlemail.com>
Date: Tue, 14 Apr 2009 15:12:23 +0200
Subject: [PATCH 20/27] microblaze: use the generic lib/checksum.c
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+omSqEDl3QL9CT617aOSrOZtNwjTk95t5LChH
 qV7NGZemzMnFWhT2MxtRC3dCS7mDEtHnhzrfgTGbzJNvR/JORM
 dDMSyOlBKYTPjJwGKiQ+A==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the code to use the more generic lib/checksum.c implementation.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/microblaze/Kconfig        |    3 +
 arch/microblaze/lib/Makefile   |    2 +-
 arch/microblaze/lib/checksum.c |  163 ----------------------------------------
 3 files changed, 4 insertions(+), 164 deletions(-)
 delete mode 100644 arch/microblaze/lib/checksum.c

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 47c161a..0651179 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -52,6 +52,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config GENERIC_SYSCALL_TABLE
 	def_bool y
 
+config GENERIC_CSUM
+	def_bool y
+
 config PCI
 	depends on !MMU
 	def_bool n
diff --git a/arch/microblaze/lib/Makefile b/arch/microblaze/lib/Makefile
index d27126b..8b02023 100644
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
index 8093400..0000000
--- a/arch/microblaze/lib/checksum.c
+++ /dev/null
@@ -1,163 +0,0 @@
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
-#include <net/checksum.h>
-#include <asm/checksum.h>
-#include <linux/module.h>
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
-	unsigned int result = do_csum(buff, len);
-
-	/* add in old sum, and carry.. */
-	result += sum;
-	if (sum > result)
-		result += 1;
-	return result;
-}
-EXPORT_SYMBOL(csum_partial);
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-__sum16 ip_compute_csum(const unsigned char *buff, int len)
-{
-	return ~do_csum(buff, len);
-}
-EXPORT_SYMBOL(ip_compute_csum);
-
-/*
- * copy from fs while checksumming, otherwise like csum_partial
- */
-__wsum
-csum_partial_copy_from_user(const char __user *src, char *dst, int len,
-						int sum, int *csum_err)
-{
-	if (csum_err)
-		*csum_err = 0;
-	memcpy(dst, src, len);
-	return csum_partial(dst, len, sum);
-}
-EXPORT_SYMBOL(csum_partial_copy_from_user);
-
-/*
- * copy from ds while checksumming, otherwise like csum_partial
- */
-__wsum
-csum_partial_copy(const char *src, char *dst, int len, int sum)
-{
-	memcpy(dst, src, len);
-	return csum_partial(dst, len, sum);
-}
-EXPORT_SYMBOL(csum_partial_copy);
-- 
1.5.6.3


