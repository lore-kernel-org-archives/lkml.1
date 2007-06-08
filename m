Return-Path: <linux-kernel-owner+w=401wt.eu-S1030233AbXFHIAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233AbXFHIAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938467AbXFHHZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55400 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938470AbXFHHZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:53 -0400
Message-Id: <20070608072238.195533000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 51/54] SPARC64: Fix _PAGE_EXEC_4U check in sun4u I-TLB miss handler.
Content-Disposition: inline; filename=sparc64-fix-_page_exec_4u-check-in-sun4u-i-tlb-miss-handler.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

It was using an immediate _PAGE_EXEC_4U value in an 'and'
instruction to perform the test.  This doesn't work because
the immediate field is signed 13-bit, this the mask being
tested against the PTE was 0x1000 sign-extended to 32-bits
instead of just plain 0x1000.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/itlb_miss.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21.4.orig/arch/sparc64/kernel/itlb_miss.S
+++ linux-2.6.21.4/arch/sparc64/kernel/itlb_miss.S
@@ -11,12 +11,12 @@
 /* ITLB ** ICACHE line 2: TSB compare and TLB load	*/
 	bne,pn	%xcc, tsb_miss_itlb		! Miss
 	 mov	FAULT_CODE_ITLB, %g3
-	andcc	%g5, _PAGE_EXEC_4U, %g0		! Executable?
+	sethi	%hi(_PAGE_EXEC_4U), %g4
+	andcc	%g5, %g4, %g0			! Executable?
 	be,pn	%xcc, tsb_do_fault
 	 nop					! Delay slot, fill me
 	stxa	%g5, [%g0] ASI_ITLB_DATA_IN	! Load TLB
 	retry					! Trap done
-	nop
 
 /* ITLB ** ICACHE line 3: 				*/
 	nop

-- 
