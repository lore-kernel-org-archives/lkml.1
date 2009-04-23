Return-Path: <linux-kernel-owner+w=401wt.eu-S1759028AbZDWHq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028AbZDWHq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZDWHbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:31:10 -0400
Received: from sous-sol.org ([216.99.217.87]:50561 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756537AbZDWHbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:31:09 -0400
Message-Id: <20090423072622.133694187@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>
Subject: [patch 052/100] sparc64: Fix bug in ("sparc64: Flush TLB before releasing pages.")
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=sparc64-fix-bug-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David Miller <davem@davemloft.net>

[ No upstream commit, this regression was added only to 2.6.29.1 ]

Unfortunately I merged an earlier version of commit
b6816b706138c3870f03115071872cad824f90b4 ("sparc64: Flush TLB before
releasing pages.") than what I actually tested and merged upstream.

Simply diffing asm/tlb_64.h in Linus's tree vs. what ended up in
2.6.29.1 confirms this.

Sync things up to fix BUG() triggers some users are seeing.

Reported-by: Dennis Gilmore <dennis@ausil.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/sparc/include/asm/tlb_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/tlb_64.h
+++ b/arch/sparc/include/asm/tlb_64.h
@@ -57,9 +57,9 @@ static inline struct mmu_gather *tlb_gat
 
 static inline void tlb_flush_mmu(struct mmu_gather *mp)
 {
+	if (!mp->fullmm)
+		flush_tlb_pending();
 	if (mp->need_flush) {
-		if (!mp->fullmm)
-			flush_tlb_pending();
 		free_pages_and_swap_cache(mp->pages, mp->pages_nr);
 		mp->pages_nr = 0;
 		mp->need_flush = 0;

