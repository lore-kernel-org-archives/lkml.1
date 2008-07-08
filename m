Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYGHMrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYGHMrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbYGHMp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:45:59 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27558 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759429AbYGHMp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:45:56 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 18/58] microblaze_v5: checksum support
Date: Tue,  8 Jul 2008 13:59:18 +0200
Message-Id: <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-generic/checksum.h    |   80 ++++++++++++++++++
 include/asm-microblaze/checksum.h |   34 ++++++++
 lib/Makefile                      |    2 +
 lib/checksum.c                    |  166 +++++++++++++++++++++++++++++++++++++
 4 files changed, 282 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/checksum.h
 create mode 100644 include/asm-microblaze/checksum.h
 create mode 100644 lib/checksum.c

diff --git a/include/asm-generic/checksum.h b/include/asm-generic/checksum.h
new file mode 100644
index 0000000..7dfb920
--- /dev/null
+++ b/include/asm-generic/checksum.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_GENERIC_CHECKSUM_H
+#define _ASM_GENERIC_CHECKSUM_H
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
+#endif /* _ASM_GENERIC_CHECKSUM_H */
diff --git a/include/asm-microblaze/checksum.h b/include/asm-microblaze/checksum.h
new file mode 100644
index 0000000..2da3744
--- /dev/null
+++ b/include/asm-microblaze/checksum.h
@@ -0,0 +1,34 @@
+/*
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
+
+#include <asm-generic/checksum.h>
+
+#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
diff --git a/lib/Makefile b/lib/Makefile
index 74b0cfb..6f48c04 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -72,6 +72,8 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_LMB) += lmb.o
 
+obj-$(CONFIG_GENERIC_CSUM) += checksum.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/checksum.c b/lib/checksum.c
new file mode 100644
index 0000000..0060873
--- /dev/null
+++ b/lib/checksum.c
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
+#include <asm-generic/checksum.h>
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
-- 
1.5.4.GIT

