Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958Ab0AGGdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0AGGdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496Ab0AGGdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:33:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48398 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0AGGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:33:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH] mips,mm: Reinstate move_pte optimization
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Ulrich Drepper <drepper@gmail.com>
In-Reply-To: <alpine.LSU.2.00.0912301437420.3369@sister.anvils>
References: <20091225083305.AA78.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.0912301437420.3369@sister.anvils>
Message-Id: <20100107151527.8784.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  7 Jan 2010 15:32:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to mips folks.

> If something like this or your replacment does go forward,
> then I think that test is better inside the "if (!page->mapping)"
> below.  Admittedly that adds even more mm-dependence here (relying
> on a zero page to have NULL page->mapping); but isn't page_to_pfn()
> one of those functions which is trivial on many configs but expensive
> on some?  Better call it only in the rare case that it's needed.
> 
> Though wouldn't it be even better not to use is_zero_pfn() at all?
> That was convenient in mm/memory.c because it had the pfn or pte right
> at hand, but here a traditional (page == ZERO_PAGE(address)) would be
> more efficient.
> 
> Which would save having to move is_zero_pfn() from mm/memory.c
> to include/linux/mm.h - I'd prefer to keep it private if we can.
> But for completeness, this would involve resurrecting the 2.6.19
> MIPS move_pte(), which makes sure mremap() move doesn't interfere
> with our assumptions.  Something like
> 
> #define __HAVE_ARCH_MOVE_PTE
> pte_t move_pte(pte_t pte, pgprot_t prot, unsigned long old_addr,
>                                          unsigned long new_addr)
> {
> 	if (pte_present(pte) && is_zero_pfn(pte_pfn(pte)))
> 		pte = mk_pte(ZERO_PAGE(new_addr), prot);
> 	return pte;
> }
> 
> in arch/mips/include/asm/pgtable.h.

I agree with resurrecting mips move_pte. At least your patch
passed my cross compile test :)

Ralf, can you please review following patch?


======================================================
Subject: [PATCH] mips,mm: Reinstate move_pte optimization
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

About three years ago, we removed mips specific move_pte by commit
701dfbc1cb (mm: mremap correct rmap accounting). because it is only
small optimization and it has bug.

However new zero-page thing doesn't have such problem and behavior
consistency of mremap have worth a bit.

This patch reinstate it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: Carsten Otte <cotte@de.ibm.com>
---
 arch/mips/include/asm/pgtable.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index 1854336..6ad2f73 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -387,6 +387,14 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 #endif
 
+#define __HAVE_ARCH_MOVE_PTE
+pte_t move_pte(pte_t pte, pgprot_t prot, unsigned long old_addr, unsigned long new_addr)
+{
+	if (pte_present(pte) && is_zero_pfn(pte_pfn(pte)))
+		pte = mk_pte(ZERO_PAGE(new_addr), prot);
+	return pte;
+}
+
 #include <asm-generic/pgtable.h>
 
 /*
-- 
1.6.5.2



