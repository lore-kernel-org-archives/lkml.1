Return-Path: <linux-kernel-owner+w=401wt.eu-S1763201AbZBETuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763201AbZBETuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763037AbZBETtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:49:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763024AbZBETtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:49:42 -0500
Date: Thu, 5 Feb 2009 20:49:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205194932.GB3129@elte.hu>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902051921150.30938@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> On Thu, 5 Feb 2009, Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > Ingo Molnar wrote:
> > >> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > >>   
> > >>> I'm looking at unifying the 32 and 64-bit versions of pud_bad.
> > >>>
> > >>> 32-bits defines it as:
> > >>>
> > >>> static inline int pud_bad(pud_t pud)
> > >>> {
> > >>> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _KERNPG_TABLE | _PAGE_USER)) != 0;
> > >>> }
> > >>>
> > >>> and 64 as:
> > >>>
> > >>> static inline int pud_bad(pud_t pud)
> > >>> {
> > >>> 	return (pud_val(pud) & ~(PTE_PFN_MASK | _PAGE_USER)) != _KERNPG_TABLE;
> > >>> }
> > >>>
> > >>>
> > >>> I'm inclined to go with the 64-bit version, but I'm wondering if 
> > >>> there's something subtle I'm missing here.
> > >>>     
> > >>
> > >> Why go with the 64-bit version? The 32-bit check looks more compact and 
> > >> should result in smaller code.
> > >>   
> > >
> > > Well, its stricter.  But I don't really understand what condition its  
> > > actually testing for.
> > 
> > Well it tests: "beyond the bits covered by PTE_PFN|_PAGE_USER, the rest 
> > must only be _KERNPG_TABLE".
> > 
> > The _KERNPG_TABLE bits are disjunct from PTE_PFN|_PAGE_USER bits, so this 
> > makes sense.
> > 
> > But the 32-bit check does the exact same thing but via a single binary 
> > operation: it checks whether any bits outside of those bits are zero -
> > just via a simpler test that compiles to more compact code.
> 
> Simpler and more compact, but not as strict: in particular, a value of
> 0 or 1 is identified as bad by that 64-bit test, but not by the 32-bit.

yes, indeed you are right - the 64-bit test does not allow the KERNPG_TABLE 
bits to go zero.

Those are the present, rw, accessed and dirty bits. Do they really matter 
that much? If a toplevel entry goes !present or readonly, we notice that 
_fast_, without any checks. If it goes !access or !dirty - does that matter?

These checks are done all the time, and even a single instruction can count. 
The bits that are checked are enough to notice random memory corruption.

( albeit these days with large RAM sizes pagetable corruption is quite rare 
  and only happens if it's specifically corrupting the pagetable - and then 
  it's not just a single bit. Most of the memory corruption goes into the 
  pagecache. )

	Ingo
