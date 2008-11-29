Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbYK2OeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbYK2OeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 09:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYK2OeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 09:34:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37893 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYK2OeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 09:34:09 -0500
Date: Sat, 29 Nov 2008 15:33:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: sparseirq enabling v4
Message-ID: <20081129143327.GB10639@elte.hu>
References: <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org> <20081128163456.GB10487@elte.hu> <4930EB7F.1080307@kernel.org> <20081129100253.GD26691@elte.hu> <20081129105714.GB9643@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129105714.GB9643@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > very nice!
> > 
> > All the structural feedback i gave seems to be addressed properly, 
> > and the patch has shrunk and consolidated nicely. I think we can 
> > start splitting it up and applying it to tip/irq/sparseirq. We might 
> > notice a few more details when that happens, on a per patch basis.
> 
> Hi Ingo / Yinghai.
> 
> Was the concerns raised by Benjamin, davem, others addressed? Just 
> curious - I have never looked into this part of the kernel.

(Cc:-ed DaveM and BenH)

I cannot speak for them, but my concens have been addressed. AFAICT the 
feedback from non-x86 land centered around two main areas:

  1) the SPARSEIRQ generic IRQ layer changes were ugly and complex

  That was one of my worries too and it has all been made rather elegant, 
  simple and fast via the new irq_desc_ptrs[] approach. (It can also be a
  speedup on NUMA as irq->desc can now host the irq statistics counters,
  etc. - so there will be an incentive for architectures to switch over 
  to sparse irq_desc[], even if they do not plan to support 4096 CPUs or 
  more)

  2) that x86 should do this all via virtual IRQ remapping

  I think this was based on a misunderstanding of what x86 architecture 
  does currently and where it wants to go with these changes.

  Firstly, the x86 architecture already remaps interrupts in a number of 
  areas: it remaps them on certain 32-bit systems via the use of irq 
  compression, and it remaps them for virtual MSI irqs as well. (which 
  are virtual to begin with)

  But the problem is not the ability or inability to remap IRQs on x86 - 
  that can obviously be done (and is being done) in a number of areas 
  when we want to shape or compress the IRQ space more intelligently.

  The problem that is solved here is that we want to enable distros to 
  build a kernel with NR_CPUS and NR_IRQS set to really high numbers 
  (4096 for NR_CPUS and 16K for NR_IRQS), and hence the plain static size 
  of all NR_IRQS arrays in the core kernel become an issue (== megabytes 
  of RAM wasted even on a plain dual core system). No amount of virtual 
  IRQ remapping in architecture code can solve that problem - we had to
  reduce the size of those core kernel arrays.

If there were any other concerns that i missed, please let us know.

	Ingo
