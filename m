Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbXEUTXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbXEUTXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765200AbXEUTVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46290 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765087AbXEUTVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:14 -0400
Message-Id: <20070521191702.322661000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
       rmk@arm.linux.org.uk, Lennert Buytenhek <kernel@wantstofly.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 08/69] iop: fix iop_getttimeoffset
Content-Disposition: inline; filename=iop-fix-iop_getttimeoffset.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

Fix a typo which causes a necessary cpwait to be missed on iop3xx, Michael
Brunner <mibru@gmx.de>

Save a register in the assembly routine, rmk

Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 arch/arm/plat-iop/time.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.21.1.orig/arch/arm/plat-iop/time.c
+++ linux-2.6.21.1/arch/arm/plat-iop/time.c
@@ -32,22 +32,22 @@ static unsigned long next_jiffy_time;
 
 unsigned long iop_gettimeoffset(void)
 {
-	unsigned long offset, temp1, temp2;
+	unsigned long offset, temp;
 
 	/* enable cp6, if necessary, to avoid taking the overhead of an
 	 * undefined instruction trap
 	 */
 	asm volatile (
 	"mrc	p15, 0, %0, c15, c1, 0\n\t"
-	"ands	%1, %0, #(1 << 6)\n\t"
+	"tst	%0, #(1 << 6)\n\t"
 	"orreq	%0, %0, #(1 << 6)\n\t"
 	"mcreq	p15, 0, %0, c15, c1, 0\n\t"
-#ifdef CONFIG_XSCALE
+#ifdef CONFIG_CPU_XSCALE
 	"mrceq	p15, 0, %0, c15, c1, 0\n\t"
 	"moveq	%0, %0\n\t"
 	"subeq	pc, pc, #4\n\t"
 #endif
-	: "=r"(temp1), "=r"(temp2) : : "cc");
+	: "=r"(temp) : : "cc");
 
 	offset = next_jiffy_time - read_tcr1();
 

-- 
