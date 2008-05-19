Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYESXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYESXL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbYESXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:11:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbYESXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:11:17 -0400
Date: Mon, 19 May 2008 16:10:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
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
In-Reply-To: <Pine.LNX.4.64.0805192217430.15410@blonde.site>
Message-ID: <alpine.LFD.1.10.0805191528550.32253@woody.linux-foundation.org>
References: <E1JxGth-0001te-S4@closure.thunk.org> <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com> <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com> <1211047916.27447.314.camel@koto.keithp.com>
 <482F24C6.2050705@frugalware.org> <20080517184626.GA16496@mit.edu> <Pine.LNX.4.64.0805192217430.15410@blonde.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2008, Hugh Dickins wrote:
> 
> This comes from an assumption in 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
> mprotect: prevent alteration of the PAT bits, that PTE_MASK is what it's
> supposed to be: whereas it's been wrong forever with PAE, staying 32-bit
> where 64-bit is needed.

Can we *please* just fix PTE_MASK?

And can we agree to never EVER use that PAGE_MASK thing (which was only 
ever meant to work on *addresses*) for any pte operations (including the 
definition of PTE_MASK)? Because PAGE_MASK is very much the word-size, and 
in 32-bit PAE, the page table entry is bigger.

IOE, PTE_MASK should be a "pteval_t". And it should have absolutely 
*nothing* to do with PAGE_MASK. EVER.

IOW, maybe something like this?

And no, I haven't tested this at all. But it should make PTE_MASK have
 (a) the right type ("pteval_t", not "long" - the latter is pure and utter 
     crap)
 (b) the right value (proper mask, not a sign-extended long - again, the 
     latter is pure and utter crap)

but for all I know there might be some broken code that depends on the 
current incorrect and totally broken #defines, so this needs testing and 
thinking about.

It also causes these warnings on 32-bit PAE:

	  AS      arch/x86/kernel/head_32.o
	arch/x86/kernel/head_32.S: Assembler messages:
	arch/x86/kernel/head_32.S:225: Warning: left operand is a bignum; integer 0 assumed
	arch/x86/kernel/head_32.S:609: Warning: left operand is a bignum; integer 0 assumed

and I do not see why (the end result seems to be identical).

Ingo, comments?

Oh, and those #define's should be moved from <asm/page.h> to 
<asm/pgtable.h>, I think. They have nothing to do with pages (despite the 
name of "physical_page_mask", and really are meaningful only in the 
context of some kind of page table entry.

		Linus

---
 include/asm-x86/page.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
index b381f4a..34b4845 100644
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -10,8 +10,8 @@
 
 #ifdef __KERNEL__
 
-#define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
-#define PTE_MASK		(_AT(long, PHYSICAL_PAGE_MASK))
+#define PHYSICAL_PAGE_MASK	(__PHYSICAL_MASK & ~__PHYSICAL_LOW_BITS)
+#define PTE_MASK		(_AT(pteval_t, PHYSICAL_PAGE_MASK))
 
 #define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
 #define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
@@ -24,6 +24,7 @@
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
+#define __PHYSICAL_LOW_BITS	_AT(phys_addr_t, (PAGE_SIZE-1))
 #define __PHYSICAL_MASK		_AT(phys_addr_t, (_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
 #define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
 
