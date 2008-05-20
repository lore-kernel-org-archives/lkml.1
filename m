Return-Path: <linux-kernel-owner+w=401wt.eu-S1758707AbYETEQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707AbYETEQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYETEQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:16:25 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60402 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYETEQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:16:25 -0400
Date: Tue, 20 May 2008 05:14:14 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 onX61s laptop
In-Reply-To: <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805200434590.14297@blonde.site>
References: <E1JxGth-0001te-S4@closure.thunk.org>
 <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>
 <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
 <1211047916.27447.314.camel@koto.keithp.com> <482F24C6.2050705@frugalware.org>
 <20080517184626.GA16496@mit.edu> <Pine.LNX.4.64.0805192217430.15410@blonde.site>
 <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Linus Torvalds wrote:
> On Mon, 19 May 2008, Hugh Dickins wrote:
> > 
> > This comes from an assumption in 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
> > mprotect: prevent alteration of the PAT bits, that PTE_MASK is what it's
> > supposed to be: whereas it's been wrong forever with PAE, staying 32-bit
> > where 64-bit is needed.
> 
> Can we *please* just fix PTE_MASK?

That's very much what I'd prefer too.  Jeremy has patches in Ingo's
tree to do that, which have been tested - though perhaps not in
combination with the PAT pte_modify changes.  I did check that they're
not incompatible in theory, but I sure better try them out later today.

> And can we agree to never EVER use that PAGE_MASK thing (which was only 
> ever meant to work on *addresses*) for any pte operations (including the 
> definition of PTE_MASK)? Because PAGE_MASK is very much the word-size, and 
> in 32-bit PAE, the page table entry is bigger.
> 
> IOE, PTE_MASK should be a "pteval_t". And it should have absolutely 
> *nothing* to do with PAGE_MASK. EVER.

Yes, Jeremy makes it a pteval_t.  (My builds and Ingo's builds succeed,
but I've not worked out how that goes down in assembly: there was an
_AT macro in there before, which you've kept too - Jeremy?)

> IOW, maybe something like this?
> 
> And no, I haven't tested this at all. But it should make PTE_MASK have
>  (a) the right type ("pteval_t", not "long" - the latter is pure and utter 
>      crap)
>  (b) the right value (proper mask, not a sign-extended long - again, the 
>      latter is pure and utter crap)
> 
> but for all I know there might be some broken code that depends on the 
> current incorrect and totally broken #defines, so this needs testing and 
> thinking about.

Yes, I'm highly resistant to taking untested patches here.  The two-liner
I sent last night was about my fifth attempt to get it working, and I did
start off from a small PTE_MASK correction which didn't work at all.  It
looked rather like yours, I guess I missed the  __PHYSICAL_LOW_BITS part.
Jeremy's goes a lot further, he'll know the gotchas better.

> It also causes these warnings on 32-bit PAE:
> 
> 	  AS      arch/x86/kernel/head_32.o
> 	arch/x86/kernel/head_32.S: Assembler messages:
> 	arch/x86/kernel/head_32.S:225: Warning: left operand is a bignum; integer 0 assumed
> 	arch/x86/kernel/head_32.S:609: Warning: left operand is a bignum; integer 0 assumed
> 
> and I do not see why (the end result seems to be identical).
> 
> Ingo, comments?
> 
> Oh, and those #define's should be moved from <asm/page.h> to 
> <asm/pgtable.h>, I think. They have nothing to do with pages (despite the 
> name of "physical_page_mask", and really are meaningful only in the 
> context of some kind of page table entry.

Jeremy still has them in asm/page.h.  Like your subsequent pte bit
cleanups, that can be added later: the important thing is to get X
working again on 32-bit NX systems.

Hugh
