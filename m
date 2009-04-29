Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZD2L5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZD2L5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZD2L5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:57:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbZD2L5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:57:19 -0400
Date: Wed, 29 Apr 2009 13:56:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: rdreier@cisco.com, hpa@zytor.com, tglx@linutronix.de, h.mitake@gmail.com,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
Message-ID: <20090429115654.GC11586@elte.hu>
References: <49EE37AF.4020507@zytor.com> <20090421.173123.191021055.davem@davemloft.net> <adak55438gp.fsf_-_@cisco.com> <20090428.221228.217954247.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428.221228.217954247.davem@davemloft.net>
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


(Linus Cc:-ed)

* David Miller <davem@davemloft.net> wrote:

> From: Roland Dreier <rdreier@cisco.com>
> Date: Tue, 28 Apr 2009 12:05:10 -0700
> 
> > As discussed in <http://lkml.org/lkml/2009/4/19/164> and follow-ups,
> > readq()/writeq() for 32-bit x86 are implemented as two readl()/writel()
> > operations.  This is not atomic (in the sense that another MMIO
> > operation from another CPU or thread can be done in the middle of the
> > two read/writes), and may not access the two halves of the register in
> > the correct order to work with hardware.
> > 
> > Rather than silently providing a 32-bit fallback that leaves a
> > possibility for strange driver bugs, it's better to provide readq()
> > and writeq() only for 64-bit architectures, and have a compile failure
> > on 32-bit architectures that forces driver authors to think about what
> > the correct solution is.
> > 
> > This essentially reverts 2c5643b1 ("x86: provide readq()/writeq() on
> > 32-bit too") and follow-on commits.  If in the future someone wants to
> > provide a generic solution for all 32-bit architectures, that's great,
> > but there's not much point in providing (arguably broken)
> > implementations for only one architecture, since any portable driver
> > will have to implement fallbacks for other architectures anyway.
> > 
> > Signed-off-by: Roland Dreier <rolandd@cisco.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>
[...]
> > We never seemed to reach closure on this.  I would strongly 
> > suggest merging something like this, and then if someone has a 
> > grand plan to unify all fallbacks, we can add that when it shows 
> > up.  As it stands, the x86-32 situation is not progress towards 
> > that grand unified plans, and does nothing that I can tell 
> > beyond setting a trap for drivers.

I still have no particularly strong opinion on this - other the 
reluctance i expressed already in the previous threads. My arguments 
are not reflected (and not addressed) in the changelog AFAICS, so 
let me repeat them here:

Firstly, it doesnt really matter in practice because such use is 
very rare and non-spinlocked access to IO regions is even rarer.

What caused 2c5643b1 was that right now we have ugly per driver
#defines and inlines for readq/writeq. See:

  git grep 'define.*readq' drivers/

for a rough estimation of what the current practices are. The 32-bit 
wrapper we added 6 months ago is the obvious implementation on x86 
and that it matches existing wrappers.

Atomicity of a 64-bit IO space access on 32-bit platforms, on an 
unknown-bitness transport (it might even be a 64-bit PCI device 
bridged over a 32-bit bridge) is obviously not guaranteed.

Not even 64-bit-on-64-bit is really guaranteed to be atomic. The 
bitness here is what the CPU runs its _own_ code in (and how it 
accesses its cached memory space) - it does not transform over to 
the uncached IO bus.

So trying to suggest that 64-bit readq/writeq when running on a 
64-bit kernel is somehow atomic (or can be made atomic) is really 
wrong IMO. The 32-bit wrapper is simply the expression of how the 
CPU would do a 64-bit access even in 64-bit mode anyway [if the 
transport is 32-bit].

aligned 32-bit access can be assumed atomic to a certain degree by 
virtue of PCI being 32 bit or better - but assuming any 64-bit 
IO-space read/write atomicity is wrong on many levels.

Driver authors will have to think about it anyway _even on 64-bit_, 
regardless of the existence of a 32-bit fallback.

A driver and hw _might_ be quirky and might require atomicity or 
might define a different order of access ... but then _that_ driver 
should become ugly, not all the others, right?

So my (slight) preference would be to keep the default generic 
implementation and not make any atomicity guarantees - we never made 
any. _If_ you want atomicity then provide a readq_atomic() / 
writeq_atomic() facility, with various higher level checks that make 
it sure that the IO transport is really atomic. (i dont see this 
happening any time soon for anything else but some really rare 
high-end IO transport.)

For the common case of there not being any atomicity assumption on 
the driver case it should result in cleaner code. (assuming all 
other 64-bit architectures implement a fallback too)

But ... i might be wrong about it, so i've Cc:-ed Linus who usually 
has a rather strong opinion about IO APIs. I'll apply the patch if 
Linus acks it (or Linus might take it straight out of email).

Thanks,

	Ingo
