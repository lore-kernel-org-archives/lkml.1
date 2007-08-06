Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXHFGiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXHFGiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXHFGhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:37:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:59003 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbXHFGhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:37:51 -0400
Subject: Re: What archs need flush_tlb_page() in handle_pte_fault() ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux Arch list <linux-arch@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <1186018621.5495.558.camel@localhost.localdomain>
References: <1186018621.5495.558.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 16:37:42 +1000
Message-Id: <1186382262.938.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 11:37 +1000, Benjamin Herrenschmidt wrote:
> Heya !
> 
> In my page table accessor spring cleaning, one of my targets is
> flush_tlb_page(). At this stage, it's only called by generic code in one
> place (in addition to the asm-generic bits that use it to implement
> missing accessors, but I'm taking care of those spearately) :

 .../...

No reply, so I suppose I can rip it out ? :-)

Thus any reason why that patch wouln't fly ? (not for 2.6.23 of course)

This removes the last occurence of flush_tlb_page() from generic code,
thus making this hook now optional for architectures that don't use
the helpers in asm-generic/pgtable.h

I couldn't find a case where this is actually needed, but I may well
have missed something. If I did though, please tell me what. If an
architecture need that call for obscure reason, it could be simply
folded in that architecture's implementation ptep_set_access_flags().

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/mm/memory.c
===================================================================
--- linux-work.orig/mm/memory.c	2007-08-06 16:32:12.000000000 +1000
+++ linux-work/mm/memory.c	2007-08-06 16:34:07.000000000 +1000
@@ -2609,15 +2609,6 @@ static inline int handle_pte_fault(struc
 	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
 		update_mmu_cache(vma, address, entry);
 		lazy_mmu_prot_update(entry);
-	} else {
-		/*
-		 * This is needed only for protection faults but the arch code
-		 * is not yet telling us if this is a protection fault or not.
-		 * This still avoids useless tlb flushes for .text page faults
-		 * with threads.
-		 */
-		if (write_access)
-			flush_tlb_page(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);


