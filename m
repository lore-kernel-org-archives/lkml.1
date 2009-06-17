Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbZFQRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbZFQRC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbZFQRCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:02:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:58686 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbZFQRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=JdMdqWgpAB6xuQjcFzKmnxTF80BB1/9c+2cG4NFAIwb5Kl8XGtJQOy2o1wAqJ8Qu23
         lcLB7fGVFxIXNFELr52q2NcxD6DpZ23daGPQwXn4Zgm097pbXCvh1qHQ3vgWkcK4DCSl
         QgjsWnKVqAWLNJFMcA9FmNbDdZkUDBUysZd00=
Message-ID: <4A392098.9060205@gmail.com>
Date: Wed, 17 Jun 2009 18:58:00 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux@arm.linux.org.uk,
       linux-m68k@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 13/14] Pramfs: Write Protection
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> > > +/* init_mm.page_table_lock must be held before calling! */
> > > +static void pram_page_writeable(unsigned long addr, int rw)
> > > +{
> > > + ? ? ? pgd_t *pgdp;
> > > + ? ? ? pud_t *pudp;
> > > + ? ? ? pmd_t *pmdp;
> > > + ? ? ? pte_t *ptep;
> > > +
> > > + ? ? ? pgdp = pgd_offset_k(addr);
> > > + ? ? ? if (!pgd_none(*pgdp)) {
> > > + ? ? ? ? ? ? ? pudp = pud_offset(pgdp, addr);
> > > + ? ? ? ? ? ? ? if (!pud_none(*pudp)) {
> > > + ? ? ? ? ? ? ? ? ? ? ? pmdp = pmd_offset(pudp, addr);
> > > + ? ? ? ? ? ? ? ? ? ? ? if (!pmd_none(*pmdp)) {
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte_t pte;
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ptep = pte_offset_kernel(pmdp, addr);
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte = *ptep;
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? if (pte_present(pte)) {
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte = rw ? pte_mkwrite(pte) :
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? pte_wrprotect(pte);
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? set_pte(ptep, pte);
> > > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? }
> > > + ? ? ? ? ? ? ? ? ? ? ? }
> > > + ? ? ? ? ? ? ? }
> > > + ? ? ? }
> > > +}
> > 
> > Wow.  Don't we want to do this pte walking in mm/ someplace?
> > 
> > Do you really intend to protect just the PTE in question rather than
> > the entire physical page, regardless of which PTE is talking to it?
> > Maybe I'm missing something.
> > 
> follow_pfn() ought to be fine for this, optionally follow_pte() could be
> exported and used.


Ok I can create a new exported function follow_pte().

> > > +#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_H8300) || \
> > > + ? ? ? defined(CONFIG_BLACKFIN)
> > > + ? ? ? /*
> > > + ? ? ? ?* FIXME: so far only these archs have flush_tlb_kernel_page(),
> > > + ? ? ? ?* for the rest just use flush_tlb_kernel_range(). Not ideal
> > > + ? ? ? ?* to use _range() because many archs just flush the whole TLB.
> > > + ? ? ? ?*/
> > > + ? ? ? if (end <= start + PAGE_SIZE)
> > > + ? ? ? ? ? ? ? flush_tlb_kernel_page(start);
> > > + ? ? ? else
> > > +#endif
> > > + ? ? ? ? ? ? ? flush_tlb_kernel_range(start, end);
> > > +}
> > 
> > Why not just fix flush_tlb_range()?
> > 
> > If an arch has a flush_tlb_kernel_page() that works then it stands to
> > reason that the flush_tlb_kernel_range() shouldn't work with minimal
> > effort, no?
> 
> flush_tlb_kernel_page() is a new one to me, it doesn't have any mention
> in Documentation/cachetlb.txt anyways.
> 
> Many of the flush_tlb_kernel_range() implementations do ranged checks
> with tunables to determine whether it is more expensive to selectively
> flush vs just blowing the entire TLB away.
> 
> Likewise, there is no reason why those 4 architectures can not just shove
> that if (end <= start + PAGE_SIZE) check in the beginning of their
> flush_tlb_kernel_range() and fall back on flush_tlb_kernel_page() for
> those cases. Hiding this in generic code is definitely not the way to go.

Ok I'll change that function at arch level and I'll remove the ifdef, I'll call only flush_tlb_kernel_page(), but I'd like to know what is the opinion of the arch maintainers to do that.
(Who is the maintainer of H8300 arch?)

Marco
