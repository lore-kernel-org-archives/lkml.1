Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbZATKKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbZATKKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZATKKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:10:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbZATKKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:10:04 -0500
Date: Tue, 20 Jan 2009 11:09:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: optimise page fault entry
Message-ID: <20090120100946.GA7886@elte.hu>
References: <20090120032426.GE16304@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120032426.GE16304@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> Hi,
> 
> Sorry for the delay with this. The kernel ended up unbootable for me 
> when I last dusted off the patch, so I couldn't test it and then 
> promptly got sidetracked with other things.
> 
> Anyway, this one is tested with a boot, some basic segfault sigbus etc 
> tests, and passes various of the mmap and mprotect etc. ltp tests.
> 
> Ingo, would you merge this into the x86 tree, please? (unless Linus has 
> any objections to this version)

-tip testing found a 32-bit boot regression, caused by this patch. The 
bootup hangs early, during the WP write-test check:

[    0.004000]       .data : 0xc0691f05 - 0xc09c746c   (3285 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0691f05   (5703 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...

i've excluded x86/mm from tip/master for now, you can find the broken tree 
in the tip/tip.x86.mm.broken [v2.6.29-rc2-1069-g583f1b9] branch that i 
just pushed out:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tip.x86.mm.broken

Also, a patch structure sidenote, the diffstat is rather large:

 arch/x86/mm/fault.c |  436 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 255 insertions(+), 181 deletions(-)

this shuffles 300 lines of highly critical x86 code around - which makes 
me nervous. A finegrained, bisectable series would be far more debuggable. 
Had we such a lineup i could have auto-bisected it for you already - while 
now you have to see which bit of the ~500 lines of code flux broke the 
32-bit WP test.

This hang might be easy to find and fix (the WP detect logic is simple), 
but other failure modes might be less debuggable and this codepath deals 
with a lot of obscure details like CPU errata. So it would be really nice 
to have a finegrained splitup of this patch.

Three separate testsystems triggered this hang so it should be readily 
reproducible.

Thanks,

	Ingo
