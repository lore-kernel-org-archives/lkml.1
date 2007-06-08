Return-Path: <linux-kernel-owner+w=401wt.eu-S938250AbXFHHW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938250AbXFHHW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937994AbXFHHRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:43 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33212 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937986AbXFHHRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:41 -0400
Message-Id: <20070608071545.142299000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Heiko Carstens <heiko.carstens@de.ibm.com>, schwidefsky@de.ibm.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 14/32] s390: Fix TCP/UDP pseudo header checksum computation.
Content-Disposition: inline; filename=02-network.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git commit f994aae1bd8e4813d59a2ed64d17585fe42d03fc changed the
function declaration of csum_tcpudp_nofold. Argument types were
changed from unsigned long to __be32 (unsigned int). Therefore we
lost the implicit type conversion that zeroed the upper half of the
registers that are used to pass parameters. Since the inline assembly
relied on this we ended up adding random values and wrong checksums
were created.
Showed only up on machines with more than 4GB since gcc produced code
where the registers that are used to pass 'saddr' and 'daddr' previously
contained addresses before calling this function.
Fix this by using 32 bit arithmetics and convert code to C, since gcc
produces better code than these hand-optimized versions.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 include/asm-s390/checksum.h |   59 +++++++++++---------------------------------
 1 file changed, 15 insertions(+), 44 deletions(-)

--- linux-2.6.20.13.orig/include/asm-s390/checksum.h
+++ linux-2.6.20.13/include/asm-s390/checksum.h
@@ -121,50 +121,21 @@ csum_tcpudp_nofold(__be32 saddr, __be32 
                    unsigned short len, unsigned short proto,
                    __wsum sum)
 {
-#ifndef __s390x__
-	asm volatile(
-		"	alr	%0,%1\n" /* sum += saddr */
-		"	brc	12,0f\n"
-		"	ahi	%0,1\n"  /* add carry */
-		"0:"
-		: "+&d" (sum) : "d" (saddr) : "cc");
-	asm volatile(
-		"	alr	%0,%1\n" /* sum += daddr */
-		"	brc	12,1f\n"
-		"	ahi	%0,1\n"  /* add carry */
-		"1:"
-		: "+&d" (sum) : "d" (daddr) : "cc");
-	asm volatile(
-		"	alr	%0,%1\n" /* sum += len + proto */
-		"	brc	12,2f\n"
-		"	ahi	%0,1\n"  /* add carry */
-		"2:"
-		: "+&d" (sum)
-		: "d" (len + proto)
-		: "cc");
-#else /* __s390x__ */
-	asm volatile(
-		"	lgfr	%0,%0\n"
-		"	algr	%0,%1\n"  /* sum += saddr */
-		"	brc	12,0f\n"
-		"	aghi	%0,1\n"   /* add carry */
-		"0:	algr	%0,%2\n"  /* sum += daddr */
-		"	brc	12,1f\n"
-		"	aghi	%0,1\n"   /* add carry */
-		"1:	algfr	%0,%3\n"  /* sum += len + proto */
-		"	brc	12,2f\n"
-		"	aghi	%0,1\n"   /* add carry */
-		"2:	srlg	0,%0,32\n"
-		"	alr	%0,0\n"   /* fold to 32 bits */
-		"	brc	12,3f\n"
-		"	ahi	%0,1\n"   /* add carry */
-		"3:	llgfr	%0,%0"
-		: "+&d" (sum)
-		: "d" (saddr), "d" (daddr),
-		  "d" (len + proto)
-		: "cc", "0");
-#endif /* __s390x__ */
-	return sum;
+	__u32 csum = (__force __u32)sum;
+
+	csum += (__force __u32)saddr;
+	if (csum < (__force __u32)saddr)
+		csum++;
+
+	csum += (__force __u32)daddr;
+	if (csum < (__force __u32)daddr)
+		csum++;
+
+	csum += len + proto;
+	if (csum < len + proto)
+		csum++;
+
+	return (__force __wsum)csum;
 }
 
 /*

-- 
