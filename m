Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZATMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZATMHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbZATMHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:07:13 -0500
Received: from ns.suse.de ([195.135.220.2]:59306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330AbZATMHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:07:11 -0500
Date: Tue, 20 Jan 2009 13:07:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: optimise page fault entry
Message-ID: <20090120120709.GF19505@wotan.suse.de>
References: <20090120032426.GE16304@wotan.suse.de> <20090120100946.GA7886@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120100946.GA7886@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 11:09:46AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi,
> > 
> > Sorry for the delay with this. The kernel ended up unbootable for me 
> > when I last dusted off the patch, so I couldn't test it and then 
> > promptly got sidetracked with other things.
> > 
> > Anyway, this one is tested with a boot, some basic segfault sigbus etc 
> > tests, and passes various of the mmap and mprotect etc. ltp tests.
> > 
> > Ingo, would you merge this into the x86 tree, please? (unless Linus has 
> > any objections to this version)
> 
> -tip testing found a 32-bit boot regression, caused by this patch. The 
> bootup hangs early, during the WP write-test check:
> 
> [    0.004000]       .data : 0xc0691f05 - 0xc09c746c   (3285 kB)
> [    0.004000]       .text : 0xc0100000 - 0xc0691f05   (5703 kB)
> [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...
> 
> i've excluded x86/mm from tip/master for now, you can find the broken tree 
> in the tip/tip.x86.mm.broken [v2.6.29-rc2-1069-g583f1b9] branch that i 
> just pushed out:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tip.x86.mm.broken

Gah, I knew I should have tested with 32-bit. Sorry, I had actually tested
it at some point, so I must have dropped this hunk along the way :(

 
> Also, a patch structure sidenote, the diffstat is rather large:
> 
>  arch/x86/mm/fault.c |  436 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 255 insertions(+), 181 deletions(-)
> 
> this shuffles 300 lines of highly critical x86 code around - which makes 
> me nervous. A finegrained, bisectable series would be far more debuggable. 
> Had we such a lineup i could have auto-bisected it for you already - while 
> now you have to see which bit of the ~500 lines of code flux broke the 
> 32-bit WP test.
> 
> This hang might be easy to find and fix (the WP detect logic is simple), 
> but other failure modes might be less debuggable and this codepath deals 
> with a lot of obscure details like CPU errata. So it would be really nice 
> to have a finegrained splitup of this patch.
 
I guess breaking out the shuffling of parameters (where this bug lies),
breaking out functions from do_page_fault, and added branch annotations
could be done.... that would still leave a fair hunk in the breakout
patch, which I didn't see a really pleasing way to split out.

> Three separate testsystems triggered this hang so it should be readily 
> reproducible.

Yes, thanks,
Nick

---
 arch/x86/mm/fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -828,7 +828,7 @@ void __kprobes do_page_fault(struct pt_r
 			return;
 
 		/* Can handle a stale RO->RW TLB */
-		if (spurious_fault(address, error_code))
+		if (spurious_fault(error_code, address))
 			return;
 
 		/*

