Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZC3Ly5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZC3Ly5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZC3Lyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:54:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZC3Lyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:54:46 -0400
Date: Mon, 30 Mar 2009 13:49:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090330114938.GB10070@elte.hu>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase> <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D099F0.3000807@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Impact: use dynamic allocator for most archs w/o
> CONFIG_HAVE_SETUP_PER_CPU_AREA
> 
> This patch makes most !CONFIG_HAVE_SETUP_PER_CPU_AREA archs use 
> dynamic percpu allocator.  The first chunk is allocated using 
> embedding helper and 8k is reserved for modules.  This ensures 
> that the new allocator behaves almost identically to the original 
> allocator as long as static percpu variables are concerned, so it 
> shouldn't introduce much breakage.
> 
> s390 and alpha use custom SHIFT_PERCPU_PTR() to work around 
> addressing range limit the addressing model imposes.  
> Unfortunately, this breaks if the address is specified using a 
> variable, so for now, the two archs aren't converted.
> 
> The following architectures are affected by this change.
> 
> * sh
> * arm
> * cris
> * mips
> * sparc(32)
> * blackfin
> * avr32
> * parisc
> * m32r
> * powerpc(32)
> 
> As this change makes the dynamic allocator the default one, 
> CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is replaced with its invert - 
> CONFIG_HAVE_LEGACY_PER_CPU_AREA, which is added to yet-to-be 
> converted archs.  These archs implement their own 
> setup_per_cpu_areas() and the conversion is not trivial.
> 
> * powerpc(64)
> * sparc(64)
> * ia64
> * alpha
> * s390
> 
> Boot and batch alloc/free tests on x86_32 with debug code (x86_32 
> doesn't use default first chunk initialization).  Compile tested 
> on sparc(32), powerpc(32), arm and alpha.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Bryan Wu <cooloney@kernel.org>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---

> Okay, this should keep s390 and alpha working till proper solution 
> is found.  Martin, can you please verify?  Ingo, please feel free 
> to push this upstream (or -next) once Martin acks.
>
>  arch/alpha/Kconfig     |    3 +++
>  arch/ia64/Kconfig      |    3 +++
>  arch/powerpc/Kconfig   |    3 +++
>  arch/s390/Kconfig      |    3 +++
>  arch/sparc/Kconfig     |    3 +++
>  arch/x86/Kconfig       |    3 ---
>  include/linux/percpu.h |   12 +++++++++---
>  init/main.c            |   24 ------------------------
>  kernel/module.c        |    6 +++---
>  mm/Makefile            |    2 +-
>  mm/allocpercpu.c       |   28 ++++++++++++++++++++++++++++
>  mm/percpu.c            |   40 +++++++++++++++++++++++++++++++++++++++-
>  12 files changed, 95 insertions(+), 35 deletions(-)

We also need the Ack from Davem for Sparc32, the Ack from Martin, an 
Ack from Ben for the PowerPC bits and an ack from Tony for the IA64 
bits. We also need the ack from Andrew and Rusty for the MM and 
module bits. Plus a final Reviewed-by of the all-architectures 
percpu allocator concepts from Christoph and Nick would be nice as 
well, just in case we missed some trick or failed to consider a 
complication.

We need these acks both for technical correctness and for the form 
of the proposed workflow - and the acks need to be in the commit 
logs as well. (i.e. we need another rebase once the dust settles)

I know this is a _lot_ of paperwork but this is the proper way to do 
it: the main gravity of impact is not on x86 anymore, and that 
impact is non-trivial on them, so we'll do whatever is most 
convenient to the architectures and maintainers affected.

It was fine and efficient to prototype this on x86 (which was the 
architecture historically most infested with legacy percpu 
complications), but the work flow spreads out and slows down from 
now on.

We may also need to split this up into per architecture bits if that 
is requested, so that they can merge and switch this allocator on at 
a pace that suits their own testing and merging schedules best. More 
complications beyond the s390 one might be discovered.

Furthermore, while i dont mind pulling it into tip/core if everyone 
agrees with that and can push it to -next as well, i think these 
bits are best suited for -mm from this point on, it is the tree best 
set up for more complex many-architecture merges.

The bits obviously look fine from an x86 perspective as well (they 
have essentially no impact there) so you can put in my ack for that 
in any case.

Thanks,

	Ingo
