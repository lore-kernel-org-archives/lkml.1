Return-Path: <linux-kernel-owner+w=401wt.eu-S1762884AbZFOPlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762884AbZFOPlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZFOPlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:41:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:51775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZFOPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:41:36 -0400
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, efault@gmx.de, npiggin@suse.de,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
	 <1245077165.6800.497.camel@laptop>
	 <Pine.LNX.4.64.0906151623570.5225@sister.anvils>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 17:41:26 +0200
Message-Id: <1245080486.6800.561.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 16:30 +0100, Hugh Dickins wrote:
> On Mon, 15 Jun 2009, Peter Zijlstra wrote:
> > 
> > The below would fix it, but that's getting rather ugly :-/,
> > alternatively I would have to introduce something like
> > pte_offset_map_irq() which would make the irq/nmi detection and leave
> > the regular code paths alone, however that would mean either duplicating
> > the gup_fast() pagewalk or passing down a pte function pointer, which
> > would only duplicate the gup_pte_range() bit, neither is really
> > attractive...
> 
> > Index: linux-2.6/arch/x86/include/asm/pgtable_32.h
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/include/asm/pgtable_32.h
> > +++ linux-2.6/arch/x86/include/asm/pgtable_32.h
> > @@ -49,7 +49,10 @@ extern void set_pmd_pfn(unsigned long, u
> >  #endif
> >  
> >  #if defined(CONFIG_HIGHPTE)
> > -#define __KM_PTE	(in_nmi() ? KM_NMI_PTE : KM_PTE0)
> > +#define __KM_PTE			\
> > +	(in_nmi() ? KM_NMI_PTE : 	\
> > +	 in_irq() ? KM_IRQ_PTE :	\
> > +	 KM_PTE0)
> >  #define pte_offset_map(dir, address)					\
> >  	((pte_t *)kmap_atomic_pte(pmd_page(*(dir)), __KM_PTE) +		\
> >  	 pte_index((address)))
> 
> Yes, that does look ugly!
> 
> I've not been following the background to this, 

We need/want to do a user-space stack walk from IRQ/NMI context. The NMI
bit means we cannot simply use __copy_from_user_inatomic() since that
will still fault (albeit not page), and the fault return path invokes
IRET which will terminate the NMI context.

Therefore I wrote a copy_from_user_nmi() variant that is based of of
__get_user_pages_fast() (a variant that doesn't fall back to the regular
GUP), but that means we get 2 kmap_atomic()s, one for HIGHPTE and one
for the user page.

So this introduces the pte map from IRQ context and one from NMI
context.

> but I've often
> wondered if a kmap_push() and kmap_pop() could be useful,
> allowing you to reuse the slot in between - any use here?

Yes, that would be much nicer, although less we would loose some of the
type validation that lives in -mm, (along with a massive overhaul of the
current kmap_atomic usage).

Hmm, if we give each explicit type an level and ensure the new push()'ed
type's level <= the previous one, we'd still have the full nesting
validation and such..

I'll look into doing this.

