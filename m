Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZGPByf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZGPByf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZGPBye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:54:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:52942 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbZGPByd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:54:33 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
In-Reply-To: <20090715135620.GD7298@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <20090715135620.GD7298@wotan.suse.de>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 11:54:15 +1000
Message-Id: <1247709255.27937.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 15:56 +0200, Nick Piggin wrote:
> On Wed, Jul 15, 2009 at 05:49:47PM +1000, Benjamin Herrenschmidt wrote:
> > Upcoming paches to support the new 64-bit "BookE" powerpc architecture
> > will need to have the virtual address corresponding to PTE page when
> > freeing it, due to the way the HW table walker works.
> > 
> > Basically, the TLB can be loaded with "large" pages that cover the whole
> > virtual space (well, sort-of, half of it actually) represented by a PTE
> > page, and which contain an "indirect" bit indicating that this TLB entry
> > RPN points to an array of PTEs from which the TLB can then create direct
> > entries.
> 
> RPN is PFN in ppc speak, right?

Ah right, real page number in ppc slang :-)

> > Thus, in order to invalidate those when PTE pages are deleted,
> > we need the virtual address to pass to tlbilx or tlbivax instructions.
> 
> Interesting arrangement. So are these last level ptes modifieable
> from userspace or something? If not, I wonder if you could manage
> them as another level of pointers with the existing pagetable
> functions?

I don't understand what you mean. Basically, the TLB contains PMD's.
There's nothing to change to the existing page table layout :-) But
because they appear as large page TLB entries that cover the virtual
space covered by a PMD, they need to be invalidated using virtual
addresses when PMDs are removed.

> > The old trick of sticking it somewhere in the PTE page struct page sucks
> > too much, the address is almost readily available in all call sites and
> > almost everybody implemets these as macros, so we may as well add the
> > argument everywhere. I added it to the pmd and pud variants for consistency.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> > I would like to merge the new support that depends on this in 2.6.32,
> > so unless there's major objections, I'd like this to go in early during
> > the merge window. We can sort out separately how to carry the patch
> > around in -next until then since the powerpc tree will have a dependency
> > on it.
> 
> Can't see any problem with that.

Thanks, can I get an Ack then ? :-)

Cheers,
Ben.


