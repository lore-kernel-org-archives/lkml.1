Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbZDHKo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbZDHKo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762944AbZDHKnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:43:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58819
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbZDHKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:43:48 -0400
Date: Wed, 08 Apr 2009 03:43:38 -0700 (PDT)
Message-Id: <20090408.034338.12312943.davem@davemloft.net>
To: giszo.k@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1 sparc64 boot failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <bbf811740904080338l6c23cd21r7d4d8bed73d6d8da@mail.gmail.com>
References: <bbf811740904080338l6c23cd21r7d4d8bed73d6d8da@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kovacs <giszo.k@gmail.com>
Date: Wed, 8 Apr 2009 12:38:19 +0200

> Hi,
> 
> I just tried to put the latest kernel (2.6.29.1) to my Sun Fire V250
> sparc server machine.
> 
> When I booted the system with the new kernel it just failed with the
> following error message:
> "kernel BUG at /usr/src/linux-2.6.29.1/arch/sparc/include/asm/tlb_64.h:48!"
> 
> The full boot log and kernel config is attached to the mail.

Known problem, patch already posted and submitted to -stable:

sparc64: Fix bug in ("sparc64: Flush TLB before releasing pages.")

[ No upstream commit, this regression was added only to 2.6.29.1 ]

Unfortunately I merged an earlier version of commit
b6816b706138c3870f03115071872cad824f90b4 ("sparc64: Flush TLB before
releasing pages.") than what I actually tested and merged upstream.

Simply diffing asm/tlb_64.h in Linus's tree vs. what ended up in
2.6.29.1 confirms this.

Sync things up to fix BUG() triggers some users are seeing.

Reported-by: Dennis Gilmore <dennis@ausil.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/tlb_64.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/tlb_64.h b/arch/sparc/include/asm/tlb_64.h
index 0aaa086..ee38e73 100644
--- a/arch/sparc/include/asm/tlb_64.h
+++ b/arch/sparc/include/asm/tlb_64.h
@@ -57,9 +57,9 @@ static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm, unsigned i
 
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
-- 
1.6.2.2

