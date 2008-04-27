Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYD0FWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYD0FWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbYD0FW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:22:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48518 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYD0FW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:22:28 -0400
Date: Sun, 27 Apr 2008 06:22:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: cooloney@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] blackfin checksum annotations
Message-ID: <20080427052226.GP5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/blackfin/lib/checksum.c    |   21 ++++++++++-----------
 include/asm-blackfin/checksum.h |   29 ++++++++++++++---------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/blackfin/lib/checksum.c b/arch/blackfin/lib/checksum.c
index 42768e0..5c87505 100644
--- a/arch/blackfin/lib/checksum.c
+++ b/arch/blackfin/lib/checksum.c
@@ -72,9 +72,9 @@ static unsigned short do_csum(const unsigned char *buff, int len)
  *	This is a version of ip_compute_csum() optimized for IP headers,
  *	which always checksum on 4 octet boundaries.
  */
-unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl)
+__sum16 ip_fast_csum(unsigned char *iph, unsigned int ihl)
 {
-	return ~do_csum(iph, ihl * 4);
+	return (__force __sum16)~do_csum(iph, ihl * 4);
 }
 
 /*
@@ -89,7 +89,7 @@ unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl)
  *
  * it's best to have buff aligned on a 32-bit boundary
  */
-unsigned int csum_partial(const unsigned char *buff, int len, unsigned int sum)
+__wsum csum_partial(const void *buff, int len, __wsum sum)
 {
 	/*
 	 * Just in case we get nasty checksum data...
@@ -109,22 +109,22 @@ unsigned int csum_partial(const unsigned char *buff, int len, unsigned int sum)
  * this routine is used for miscellaneous IP-like checksums, mainly
  * in icmp.c
  */
-unsigned short ip_compute_csum(const unsigned char *buff, int len)
+__sum16 ip_compute_csum(const void *buff, int len)
 {
-	return ~do_csum(buff, len);
+	return (__force __sum16)~do_csum(buff, len);
 }
 
 /*
  * copy from fs while checksumming, otherwise like csum_partial
  */
 
-unsigned int
-csum_partial_copy_from_user(const unsigned char *src, unsigned char *dst,
-			    int len, int sum, int *csum_err)
+__wsum
+csum_partial_copy_from_user(const void __user *src, void *dst,
+			    int len, __wsum sum, int *csum_err)
 {
 	if (csum_err)
 		*csum_err = 0;
-	memcpy(dst, src, len);
+	memcpy(dst, (__force void *)src, len);
 	return csum_partial(dst, len, sum);
 }
 
@@ -132,8 +132,7 @@ csum_partial_copy_from_user(const unsigned char *src, unsigned char *dst,
  * copy from ds while checksumming, otherwise like csum_partial
  */
 
-unsigned int csum_partial_copy(const unsigned char *src, unsigned char *dst,
-			       int len, int sum)
+__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
 {
 	memcpy(dst, src, len);
 	return csum_partial(dst, len, sum);
diff --git a/include/asm-blackfin/checksum.h b/include/asm-blackfin/checksum.h
index 2638f25..699fa3e 100644
--- a/include/asm-blackfin/checksum.h
+++ b/include/asm-blackfin/checksum.h
@@ -15,7 +15,7 @@
  *
  * it's best to have buff aligned on a 32-bit boundary
  */
-unsigned int csum_partial(const unsigned char *buff, int len, unsigned int sum);
+__wsum csum_partial(const void *buff, int len, __wsum sum);
 
 /*
  * the same as csum_partial, but copies from src while it
@@ -25,8 +25,8 @@ unsigned int csum_partial(const unsigned char *buff, int len, unsigned int sum);
  * better 64-bit) boundary
  */
 
-unsigned int csum_partial_copy(const unsigned char *src, unsigned char *dst,
-			       int len, int sum);
+__wsum csum_partial_copy(const void *src, void *dst,
+			       int len, __wsum sum);
 
 /*
  * the same as csum_partial_copy, but copies from user space.
@@ -35,20 +35,19 @@ unsigned int csum_partial_copy(const unsigned char *src, unsigned char *dst,
  * better 64-bit) boundary
  */
 
-extern unsigned int csum_partial_copy_from_user(const unsigned char *src,
-						unsigned char *dst, int len,
-						int sum, int *csum_err);
+extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
+					  int len, __wsum sum, int *csum_err);
 
 #define csum_partial_copy_nocheck(src, dst, len, sum)	\
 	csum_partial_copy((src), (dst), (len), (sum))
 
-unsigned short ip_fast_csum(unsigned char *iph, unsigned int ihl);
+__sum16 ip_fast_csum(unsigned char *iph, unsigned int ihl);
 
 /*
  *	Fold a partial checksum
  */
 
-static inline unsigned int csum_fold(unsigned int sum)
+static inline __sum16 csum_fold(__wsum sum)
 {
 	while (sum >> 16)
 		sum = (sum & 0xffff) + (sum >> 16);
@@ -60,9 +59,9 @@ static inline unsigned int csum_fold(unsigned int sum)
  * returns a 16-bit checksum, already complemented
  */
 
-static inline unsigned int
-csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr, unsigned short len,
-		   unsigned short proto, unsigned int sum)
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
 {
 
 	__asm__ ("%0 = %0 + %1;\n\t"
@@ -84,9 +83,9 @@ csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr, unsigned short len,
 	return (sum);
 }
 
-static inline unsigned short int
-csum_tcpudp_magic(unsigned long saddr, unsigned long daddr, unsigned short len,
-		  unsigned short proto, unsigned int sum)
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
 {
 	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
 }
@@ -96,6 +95,6 @@ csum_tcpudp_magic(unsigned long saddr, unsigned long daddr, unsigned short len,
  * in icmp.c
  */
 
-extern unsigned short ip_compute_csum(const unsigned char *buff, int len);
+extern __sum16 ip_compute_csum(const unsigned char *buff, int len);
 
 #endif				/* _BFIN_CHECKSUM_H */
-- 
1.5.3.GIT

