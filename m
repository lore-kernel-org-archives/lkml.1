Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZFJDep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZFJDep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZFJDda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:30 -0400
Received: from kroah.org ([198.145.64.141]:56605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZFJDd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:29 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:41 2009
Message-Id: <20090610002341.250450671@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:35 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/60] sparc64: Flush TLB before releasing pages.
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sparc64-flush-tlb-before-releasing-pages.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 86ee79c3dbd48d7430fd81edc1da3516c9f6dabc ]

tlb_flush_mmu() needs to flush pending TLB entries before
processing the mmu_gather ->pages list.

Noticed by Benjamin Herrenschmidt.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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


