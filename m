Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYEDQhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYEDQhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYEDQh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:37:27 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:52743 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752140AbYEDQhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:37:25 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 17/56] microblaze_v2: checksum support
Date: Sun,  4 May 2008 13:41:06 +0200
Message-Id: <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/checksum.c    |  166 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/checksum.h |  101 ++++++++++++++++++++++
 2 files changed, 267 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/checksum.c
 create mode 100644 include/asm-microblaze/checksum.h

diff --git a/arch/microblaze/lib/checksum.c b/arch/microblaze/lib/checksum.c
new file mode 100644
index 0000000..1f4646f
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
+ *		specify d0 and d1 as scratch registers. Letting gcc choose these
+ *      registers itself solves the problem.
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
+static unsigned long do_csum(const unsigned char *buff, int len)
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
+unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl)
+{
+	return ~do_csum(iph, ihl*4);
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
+unsigned int csum_partial(const unsigned char *buff, int len, unsigned int sum)
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
+unsigned short ip_compute_csum(const unsigned char *buff, int len)
+{
+	return ~do_csum(buff, len);
+}
+EXPORT_SYMBOL(ip_compute_csum);
+
+/*
+ * copy from fs while checksumming, otherwise like csum_partial
+ */
+unsigned int
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
+unsigned int
+csum_partial_copy(const char *src, char *dst, int len, int sum)
+{
+	memcpy(dst, src, len);
+	return csum_partial(dst, len, sum);
+}
+EXPORT_SYMBOL(csum_partial_copy);
diff --git a/include/asm-microblaze/checksum.h b/include/asm-microblaze/checksum.h
new file mode 100644
index 0000000..fc05cca
--- /dev/null
+++ b/include/asm-microblaze/checksum.h
@@ -0,0 +1,101 @@
+/*
+ * include/asm-microblaze/checksum.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_CHECKSUM_H
+#define _ASM_MICROBLAZE_CHECKSUM_H
+
+#include <linux/in6.h>
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
+unsigned int csum_partial(const unsigned char *buff, int len,
+						unsigned int sum);
+
+/*
+ * the same as csum_partial, but copies from src while it
+ * checksums
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+unsigned int csum_partial_copy(const char *src, char *dst, int len, int sum);
+
+/*
+ * the same as csum_partial_copy, but copies from user space.
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern unsigned int csum_partial_copy_from_user(const char *src, char *dst,
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
+extern unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl);
+
+/*
+ *	Fold a partial checksum
+ */
+static inline unsigned int csum_fold(unsigned int sum)
+{
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return ~sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline unsigned int
+csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr, unsigned short len,
+		unsigned short proto, unsigned int sum)
+{
+	__asm__("add %0, %4, %1\n\t"
+		"addc %0, %4, %2\n\t"
+		"addc %0, %4, %3\n\t"
+		"addc %0, %4, r0\n\t"
+		: "=d" (sum)
+		: "d" (saddr), "d" (daddr), "d" (len + proto),
+		"0"(sum));
+
+	return sum;
+}
+
+static inline unsigned short int
+csum_tcpudp_magic(unsigned long saddr, unsigned long daddr, unsigned short len,
+		unsigned short proto, unsigned int sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+extern unsigned short ip_compute_csum(const unsigned char *buff, int len);
+
+#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
-- 
1.5.4.GIT

