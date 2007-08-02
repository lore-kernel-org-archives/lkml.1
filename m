Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXHBBh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXHBBh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXHBBhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:37:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:41032 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbXHBBhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:37:10 -0400
Subject: What archs need flush_tlb_page() in handle_pte_fault() ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux Arch list <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 11:37:01 +1000
Message-Id: <1186018621.5495.558.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heya !

In my page table accessor spring cleaning, one of my targets is
flush_tlb_page(). At this stage, it's only called by generic code in one
place (in addition to the asm-generic bits that use it to implement
missing accessors, but I'm taking care of those spearately) :

In handle_pte_fault(), when the PTE is present -and-
ptep_set_access_flags() returns false -and- it's a write fault, we do a
flush_tlb_page().

ptep_set_access_flags() returning false typically means we don't
actually need to call update_mmu_cache() and haven't updated the PTE.

Now, I would like to understand what archs actually need that. If we
have lazy _PAGE_DIRTY handling, then ptep_set_access_flags() would have
done the flush already. I can imagine people may want to avoid the SMP
IPI in that case and only lazily flush on that CPU but that doesn't seem
to be what i386 does today.

In any case, I believe that this flush could be moved to inside
ptep_set_access_flags() for archs that need it, thus totally removing
the else { ... } clause in handle_pte_fault(). Archs that want to be
smart can do a local flush inside ptep_set_access_flags() if !changed &&
dirty, it all gets under arch control, and that last flush_tlb_page()
can be removed from generic code.

Now, before I actually remove it, I need to understand what archs
actually -need- that flush, so I can move it to their respective
ptep_set_access_flags() implementations.

I don't see i386 needing it unless I missed something.

For now, I'll assume nobody needs it. So please tell me if your arch
does and I'll make sure my patch has it fixed up properly.

Thanks !
Ben.


