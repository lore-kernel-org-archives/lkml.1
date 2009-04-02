Return-Path: <linux-kernel-owner+w=401wt.eu-S934985AbZDBHEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbZDBHEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762926AbZDBHD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:03:26 -0400
Received: from sous-sol.org ([216.99.217.87]:49086 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751539AbZDBHDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:03:25 -0400
Date: Wed, 1 Apr 2009 23:57:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Jake Edge <jake@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>, davem@davemloft.net
Subject: [PATCH 47/45] sparc64: Flush TLB before releasing pages.
Message-ID: <20090402065753.GC18394@sequoia.sous-sol.org>
References: <20090331231045.719396245@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090331231045.719396245@sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit a552a42cfa91ab653128dff89a70c8dde7fed042 ]

tlb_flush_mmu() needs to flush pending TLB entries before
processing the mmu_gather ->pages list.

Noticed by Benjamin Herrenschmidt.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/sparc/include/asm/tlb_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/tlb_64.h
+++ b/arch/sparc/include/asm/tlb_64.h
@@ -58,6 +58,8 @@ static inline struct mmu_gather *tlb_gat
 static inline void tlb_flush_mmu(struct mmu_gather *mp)
 {
 	if (mp->need_flush) {
+		if (!mp->fullmm)
+			flush_tlb_pending();
 		free_pages_and_swap_cache(mp->pages, mp->pages_nr);
 		mp->pages_nr = 0;
 		mp->need_flush = 0;
@@ -78,8 +80,6 @@ static inline void tlb_finish_mmu(struct
 
 	if (mp->fullmm)
 		mp->fullmm = 0;
-	else
-		flush_tlb_pending();
 
 	/* keep the page table cache within bounds */
 	check_pgt_cache();
