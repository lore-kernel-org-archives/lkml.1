Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbYG1NnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbYG1NnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYG1NnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:43:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35875 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbYG1NnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:43:11 -0400
Date: Mon, 28 Jul 2008 15:42:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] i386: improve double fault handling
Message-ID: <20080728134252.GI5515@elte.hu>
References: <4880A912.76E4.0078.0@novell.com> <4881263B.7060700@zytor.com> <48846B02.76E4.0078.0@novell.com> <20080721110510.GC10782@elte.hu> <4885CEFE.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885CEFE.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 21.07.08 13:05 >>>
> >this still doesnt apply to latest -git. (or tip/master)
> 
> Indeed, tip/master had a __pa -> __phys_addr_const conversion that I 
> now sync-ed the patch with (without another round of testing):
> 
> Make the double fault handler use CPU-specific stacks. Add some 
> abstraction to simplify future change of other exception handlers to 
> go through task gates. Add a new notification of the event through the 
> die notifier chain, also providing some environmental adjustments so 
> that various infrastructural things work independent of the fact that 
> the fault and the callbacks are running on other then the normal 
> kernel stack.
> 
> Signed-Off-By: Jan Beulich <jbeulich@novell.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> 
> ---
>  arch/x86/kernel/cpu/common.c     |   17 +++++--
>  arch/x86/kernel/doublefault_32.c |   86 ++++++++++++++++++++++++---------------
>  arch/x86/kernel/smpboot.c        |   44 +++++++++++++++++++
>  arch/x86/kernel/traps_32.c       |   51 ++++++++++++++++++++++-
>  drivers/lguest/segments.c        |    3 -
>  include/asm-x86/kdebug.h         |    1 
>  include/asm-x86/processor.h      |    7 ++-
>  include/asm-x86/segment.h        |   15 ++++--
>  include/asm-x86/thread_info_32.h |    9 +++-
>  9 files changed, 187 insertions(+), 46 deletions(-)

I dont know.

All CPUs hitting a double fault simultaneously and corrupting each 
others' kernel stack is a theoretical possibility - but is handling it 
worth the complexity? It appears to me that a lock plus a short stub 
function that takes the lock (with no stack usage) would handle that 
much better.

Also, you seem to be setting things up to turn NMIs and MCEs into task 
gates too, right?

So i'm really uneasy about all this. Breakage in such rarely used code 
gets found very late, and has thus a high risk of losing debug 
information when we need it the most. (i.e. it works in the exact 
_opposite_ way of the intented goal of making things more robust - it 
makes things less robust)

Firstly, 64-bit does not use a task gate for double faults anymore. (but 
uses a separate IST stack for double faults)

Secondly, task gates are really a relic that should not be proliferated. 
Besides the complications in virtualized environments (if more common 
things like Big Real Mode are not supported well in virtual mode what do 
we expect of more esoteric features as task gates?) it does not get 
nearly as much testing on real silicon as other, more mainstream CPU 
features.

Thirdly, NMI based profiling is quite common, so by turning NMIs into 
task gates we'd slow that down quite a lot.

Also, the change to doublefault_fn is quite ugly - that inner block 
should be split out into a separate function.

Plus the notifier - why do we care about that? It's not like we can 
sanely kexec into a safe kernel from double faulting kernels in most 
cases. In real cases where i've seen double faults it was due to us 
corrupting kernel pagetables - kexec has no chance there. To recover 
from that we'd have to set up the TSS with a safe(r) cr3 as well - but 
your patch leaves _that_ untouched. (nor do we want to waste extra 
unswappable memory on such remote possibilities i think)

        Ingo
