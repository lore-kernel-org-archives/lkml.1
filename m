Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbZFQHI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbZFQHI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZFQHIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:08:15 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56014 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZFQHIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:08:14 -0400
Date: Wed, 17 Jun 2009 16:07:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Marco <marco.stornelli@gmail.com>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 13/14] Pramfs: Write protection
Message-ID: <20090617070725.GC5208@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jared Hulbert <jaredeh@gmail.com>,
	Marco <marco.stornelli@gmail.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Embedded <linux-embedded@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Daniel Walker <dwalker@soe.ucsc.edu>
References: <4A33A835.901@gmail.com> <6934efce0906161935x65c2a31br4bf1d35493e7b77c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0906161935x65c2a31br4bf1d35493e7b77c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 07:35:24PM -0700, Jared Hulbert wrote:
> > +/* init_mm.page_table_lock must be held before calling! */
> > +static void pram_page_writeable(unsigned long addr, int rw)
> > +{
> > + ? ? ? pgd_t *pgdp;
> > + ? ? ? pud_t *pudp;
> > + ? ? ? pmd_t *pmdp;
> > + ? ? ? pte_t *ptep;
> > +
> > + ? ? ? pgdp = pgd_offset_k(addr);
> > + ? ? ? if (!pgd_none(*pgdp)) {
> > + ? ? ? ? ? ? ? pudp = pud_offset(pgdp, addr);
> > + ? ? ? ? ? ? ? if (!pud_none(*pudp)) {
> > + ? ? ? ? ? ? ? ? ? ? ? pmdp = pmd_offset(pudp, addr);
> > + ? ? ? ? ? ? ? ? ? ? ? if (!pmd_none(*pmdp)) {
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte_t pte;
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ptep = pte_offset_kernel(pmdp, addr);
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte = *ptep;
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? if (pte_present(pte)) {
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte = rw ? pte_mkwrite(pte) :
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte_wrprotect(pte);
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? set_pte(ptep, pte);
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? }
> > + ? ? ? ? ? ? ? ? ? ? ? }
> > + ? ? ? ? ? ? ? }
> > + ? ? ? }
> > +}
> 
> Wow.  Don't we want to do this pte walking in mm/ someplace?
> 
> Do you really intend to protect just the PTE in question rather than
> the entire physical page, regardless of which PTE is talking to it?
> Maybe I'm missing something.
> 
follow_pfn() ought to be fine for this, optionally follow_pte() could be
exported and used.

> > +#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_H8300) || \
> > + ? ? ? defined(CONFIG_BLACKFIN)
> > + ? ? ? /*
> > + ? ? ? ?* FIXME: so far only these archs have flush_tlb_kernel_page(),
> > + ? ? ? ?* for the rest just use flush_tlb_kernel_range(). Not ideal
> > + ? ? ? ?* to use _range() because many archs just flush the whole TLB.
> > + ? ? ? ?*/
> > + ? ? ? if (end <= start + PAGE_SIZE)
> > + ? ? ? ? ? ? ? flush_tlb_kernel_page(start);
> > + ? ? ? else
> > +#endif
> > + ? ? ? ? ? ? ? flush_tlb_kernel_range(start, end);
> > +}
> 
> Why not just fix flush_tlb_range()?
> 
> If an arch has a flush_tlb_kernel_page() that works then it stands to
> reason that the flush_tlb_kernel_range() shouldn't work with minimal
> effort, no?

flush_tlb_kernel_page() is a new one to me, it doesn't have any mention
in Documentation/cachetlb.txt anyways.

Many of the flush_tlb_kernel_range() implementations do ranged checks
with tunables to determine whether it is more expensive to selectively
flush vs just blowing the entire TLB away.

Likewise, there is no reason why those 4 architectures can not just shove
that if (end <= start + PAGE_SIZE) check in the beginning of their
flush_tlb_kernel_range() and fall back on flush_tlb_kernel_page() for
those cases. Hiding this in generic code is definitely not the way to go.
