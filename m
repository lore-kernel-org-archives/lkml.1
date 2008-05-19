Return-Path: <linux-kernel-owner+w=401wt.eu-S1763395AbYESV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763395AbYESV1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbYESV1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:27:38 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43061 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbYESV1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:27:37 -0400
Date: Mon, 19 May 2008 22:25:51 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Theodore Tso <tytso@mit.edu>
cc: Gabriel C <nix.or.die@googlemail.com>, Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       bugme-daemon@bugzilla.kernel.org, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 onX61s laptop
In-Reply-To: <20080517184626.GA16496@mit.edu>
Message-ID: <Pine.LNX.4.64.0805192217430.15410@blonde.site>
References: <E1JxGth-0001te-S4@closure.thunk.org>
 <924EFEDD5F540B4284297C4DC59F3DEE01119AFE@orsmsx423.amr.corp.intel.com>
 <20080517154131.GA7651@mit.edu> <924EFEDD5F540B4284297C4DC59F3DEE01119B07@orsmsx423.amr.corp.intel.com>
 <1211047916.27447.314.camel@koto.keithp.com> <482F24C6.2050705@frugalware.org>
 <20080517184626.GA16496@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Theodore Tso wrote:
> On Sat, May 17, 2008 at 08:32:38PM +0200, Gabriel C wrote:
> > > 
> > > Which repository is commit 1c12c4cf in?
> > 
> > It is in linus-git tree , http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
> 
> ...post 2.6.26-rc2-git3.  For Linux kernels 2.6.26-rc2-git4 and
> newer, you need to revert this commit or the X Server shipped with
> Ubuntu Gutsy will die horribly when run on an X61s laptop with the
> Intel 965GM video chipset.
> 
> So the question is what's the right fix to keep the kernel compatible
> with the X server, besides just reverting the commit entirely?

[PATCH] x86: fix mprotect's NX handling on PAE

2.6.26-rc3 with CONFIG_X86_PAE may leave the NX bit set when PROT_EXEC
is intending to clear it, causing irqbalance and others to segfault,
and X startup to fail.

This comes from an assumption in 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
mprotect: prevent alteration of the PAT bits, that PTE_MASK is what it's
supposed to be: whereas it's been wrong forever with PAE, staying 32-bit
where 64-bit is needed.

Jeremy Fitzhardinge already has patches to fix that in Ingo's tree;
but if they're not considered 2.6.26 material, or people want a quick
two-liner to get working, here's a shorter hack to fix up pte_modify.

I apologize to those we've broken, and to Venki Pallipadi: it was I who
persuaded him to change his working patch to make that false assumption.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/asm-x86/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 2.6.26-rc3/include/asm-x86/pgtable.h	2008-05-19 11:19:03.000000000 +0100
+++ linux/include/asm-x86/pgtable.h	2008-05-19 21:51:08.000000000 +0100
@@ -57,8 +57,8 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
-#define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
-			 _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _PAGE_CHG_MASK	(((pteval_t) PTE_MASK & ~_PAGE_NX) | 		\
+			 _PAGE_PCD | _PAGE_PWT | _PAGE_ACCESSED | _PAGE_DIRTY)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
