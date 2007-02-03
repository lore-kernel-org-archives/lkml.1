Return-Path: <linux-kernel-owner+w=401wt.eu-S1946273AbXBCCkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946273AbXBCCkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946266AbXBCCkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:40:33 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53335 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946264AbXBCCk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:40:26 -0500
Message-Id: <20070203024247.842644000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:36 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       "David S. Miller" <davem@sunset.davemloft.net>
Subject: [patch 32/59] SPARC64: Set g4/g5 properly in sun4v dtlb-prot handling.
Content-Disposition: inline; filename=sparc64-set-g4-g5-properly-in-sun4v-dtlb-prot-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: David S. Miller <davem@sunset.davemloft.net>

Mirror the logic in the sun4u handler, we have to update
both registers even when we branch out to window fault
fixup handling.

The way it works is that if we are in etrap processing a
fault already, g4/g5 holds the original fault information.
If we take a window spill fault while doing etrap, then
we put the window spill fault info into g4/g5 and this is
what the top-level fault handler ends up processing first.

Then we retry the originally faulting instruction, and
process the original fault at that time.

This is all necessary because of how constrained the trap
registers are in these code paths.  These cases trigger
very rarely, so even if there is some performance implication
it's doesn't happen very often.  In fact the rarity is why
it took so long to trigger and find this particular bug.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 arch/sparc64/kernel/sun4v_tlb_miss.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/arch/sparc64/kernel/sun4v_tlb_miss.S
+++ linux-2.6.19.2/arch/sparc64/kernel/sun4v_tlb_miss.S
@@ -142,9 +142,9 @@ sun4v_dtlb_prot:
 	rdpr	%tl, %g1
 	cmp	%g1, 1
 	bgu,pn	%xcc, winfix_trampoline
-	 nop
-	ba,pt	%xcc, sparc64_realfault_common
 	 mov	FAULT_CODE_DTLB | FAULT_CODE_WRITE, %g4
+	ba,pt	%xcc, sparc64_realfault_common
+	 nop
 
 	/* Called from trap table:
 	 * %g4:	vaddr

--
