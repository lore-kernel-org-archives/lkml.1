Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbZCRVwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbZCRVwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbZCRVnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:31 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757876AbZCRVn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:28 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 18/57] microblaze_v7: checksum support
Date: Wed, 18 Mar 2009 21:30:45 +0100
Message-Id: <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/checksum.h |   98 +++++++++++++++++++
 arch/microblaze/lib/checksum.c         |  166 ++++++++++++++++++++++++++++++++
 2 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/checksum.h
 create mode 100644 arch/microblaze/lib/checksum.c

diff --git a/arch/microblaze/include/asm/checksum.h b/arch/microblaze/include/asm/checksum.h
new file mode 100644
index 0000000..92b3076
--- /dev/null
+++ b/arch/microblaze/include/asm/checksum.h
@@ -0,0 +1,98 @@
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
+#include <linux/in6.h>
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
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
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+extern __wsum csum_partial(const void *buff, int len, __wsum sum);
+
+/*
+ * the same as csum_partial, but copies from src while it
+ * checksums
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern __wsum csum_partial_copy(const char *src, char *dst, int len, int sum);
+
+/*
+ * the same as csum_partial_copy, but copies from user space.
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern __wsum csum_partial_copy_from_user(const char *src, char *dst,
+					int len, int sum, int *csum_err);
+
+#define csum_partial_copy_nocheck(src, dst, len, sum)	\
+	csum_partial_copy((src), (dst), (len), (sum))
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ *
+ */
+extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+
+/*
+ *	Fold a partial checksum
+ */
+static inline __sum16 csum_fold(unsigned int sum)
+{
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return ~sum;
+}
+
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+extern __sum16 ip_compute_csum(const unsigned char *buff, int len);
+
+#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
diff --git a/arch/microblaze/lib/checksum.c b/arch/microblaze/lib/checksum.c
new file mode 100644
index 0000000..ac7c214
--- /dev/null
+++ b/arch/microblaze/lib/checksum.c
@@ -0,0 +1,166 @@
+/*
+ * arch/microblaze/lib/checksum.c
+ *
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ *
+ * INET		An implementation of the TCP/IP protocol suite for the LINUX
+ *		operating system.  INET is implemented using the  BSD Socket
+ *		interface as the means of communication with the user level.
+ *
+ *		IP/TCP/UDP checksumming routines
+ *
+ * Authors:	Jorge Cwik, <jorge@laser.satlink.net>
+ *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
+ *		Tom May, <ftom@netcom.com>
+ *		Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
+ *		Lots of code moved from tcp.c and ip.c; see those files
+ *		for more names.
+ *
+ * 03/02/96	Jes Sorensen, Andreas Schwab, Roman Hodek:
+ *		Fixed some nasty bugs, causing some horrible crashes.
+ *		A: At some points, the sum (%0) was used as
+ *		length-counter instead of the length counter
+ *		(%1). Thanks to Roman Hodek for pointing this out.
+ *		B: GCC seems to mess up if one uses too many
+ *		data-registers to hold input values and one tries to
+ *		specify d0 and d1 as scratch registers. Letting gcc
+ *		choose these registers itself solves the problem.
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ */
+
+/* Revised by Kenneth Albanowski for m68knommu. Basic problem: unaligned access
+ kills, so most of the assembly has to go. */
+
+#include <net/checksum.h>
+#include <asm/checksum.h>
+#include <linux/module.h>
+
+static inline unsigned short from32to16(unsigned long x)
+{
+	/* add up 16-bit and 16-bit for 16+c bit */
+	x = (x & 0xffff) + (x >> 16);
+	/* add up carry.. */
+	x = (x & 0xffff) + (x >> 16);
+	return x;
+}
+
+static unsigned int do_csum(const unsigned char *buff, int len)
+{
+	int odd, count;
+	unsigned long result = 0;
+
+	if (len <= 0)
+		goto out;
+	odd = 1 & (unsigned long) buff;
+	if (odd) {
+		result = *buff;
+		len--;
+		buff++;
+	}
+	count = len >> 1;		/* nr of 16-bit words.. */
+	if (count) {
+		if (2 & (unsigned long) buff) {
+			result += *(unsigned short *) buff;
+			count--;
+			len -= 2;
+			buff += 2;
+		}
+		count >>= 1;		/* nr of 32-bit words.. */
+		if (count) {
+			unsigned long carry = 0;
+			do {
+				unsigned long w = *(unsigned long *) buff;
+				count--;
+				buff += 4;
+				result += carry;
+				result += w;
+				carry = (w > result);
+			} while (count);
+			result += carry;
+			result = (result & 0xffff) + (result >> 16);
+		}
+		if (len & 2) {
+			result += *(unsigned short *) buff;
+			buff += 2;
+		}
+	}
+	if (len & 1)
+		result += (*buff << 8);
+	result = from32to16(result);
+	if (odd)
+		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
+out:
+	return result;
+}
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ */
+__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	return (__force __sum16)~do_csum(iph,ihl*4);
+}
+
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+__wsum csum_partial(const void *buff, int len, __wsum sum)
+{
+	unsigned int result = do_csum(buff, len);
+
+	/* add in old sum, and carry.. */
+	result += sum;
+	if (sum > result)
+		result += 1;
+	return result;
+}
+EXPORT_SYMBOL(csum_partial);
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+__sum16 ip_compute_csum(const unsigned char *buff, int len)
+{
+	return ~do_csum(buff, len);
+}
+EXPORT_SYMBOL(ip_compute_csum);
+
+/*
+ * copy from fs while checksumming, otherwise like csum_partial
+ */
+__wsum
+csum_partial_copy_from_user(const char __user *src, char *dst, int len,
+						int sum, int *csum_err)
+{
+	if (csum_err)
+		*csum_err = 0;
+	memcpy(dst, src, len);
+	return csum_partial(dst, len, sum);
+}
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+
+/*
+ * copy from ds while checksumming, otherwise like csum_partial
+ */
+__wsum
+csum_partial_copy(const char *src, char *dst, int len, int sum)
+{
+	memcpy(dst, src, len);
+	return csum_partial(dst, len, sum);
+}
+EXPORT_SYMBOL(csum_partial_copy);
-- 
1.5.5.1

