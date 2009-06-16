Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZFPMj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZFPMj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZFPMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:39:47 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:44935 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbZFPMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:39:46 -0400
X-Trace: 212856105/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.117.171/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.117.171
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0FANAvN0pQKXWr/2dsb2JhbACBT9FLgkuBQgU
X-IronPort-AV: E=Sophos;i="4.42,228,1243810800"; 
   d="scan'208";a="212856105"
Date: Tue, 16 Jun 2009 13:38:43 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
In-Reply-To: <20090616081348.GC16229@elte.hu>
Message-ID: <Pine.LNX.4.64.0906161312440.552@sister.anvils>
References: <1245080486.6800.561.camel@laptop> <1245089065.13761.19316.camel@twins>
 <20090615181555.GA11248@elte.hu> <1245089943.13761.19334.camel@twins>
 <20090615182549.GD11248@elte.hu> <1245090608.13761.19349.camel@twins>
 <20090615184217.GG11248@elte.hu> <1245091674.6741.180.camel@laptop>
 <20090615185259.GK11248@elte.hu> <1245092433.6741.201.camel@laptop>
 <20090616081348.GC16229@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2009-06-15 at 20:52 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > On Mon, 2009-06-15 at 20:42 +0200, Ingo Molnar wrote:
> > > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > On Mon, 2009-06-15 at 20:25 +0200, Ingo Molnar wrote:
> > > > > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > 
> > > > > > > but ... look at the APIs i propose above. We dont need _any_ 
> > > > > > > 'types'.
> > > > > > > 
> > > > > > > That type enumeration is basically an open-coded allocator. If we do 
> > > > > > > a _real_ allocator (a balanced stack of atomic kmaps) we dont need 
> > > > > > > any of those indices, and all the potential for mismatch goes away 
> > > > > > > as well - a stack nests trivially with IRQ and NMI and arbitrary 
> > > > > > > other contexts.
> > > > > > 
> > > > > > You want types because:
> > > > > >  - they encode the intent, and can be verified
> > > > > >  - they help keep track of the max nesting depth
> > > > > > 
> > > > > > In the proposed implementation all type code basically falls away 
> > > > > > no ! CONFIG_DEBUG_VM, but is kept around for robustness.
> > > > > 
> > > > > But much of the fragility of the types (and their clumsiness - for 
> > > > > example in highpte ops we have to know at which level of the 
> > > > > pagetables we are, and use the right kind of index) is _precisely_ 
> > > > > because we have the types ...
> > > > 
> > > > How will you manage the max depth?
> > > 
> > > 	if (++depth == MAX_DEPTH) {
> > > 		print_all_entries_and_nasty_warning();
> > > 		 /* hope we'll live long enough for the syslog to touch disk */
> > > 		depth = 0;
> > > 	}
> > 
> > That will only trigger if we hit it, which will be _very_ rare.
> > 
> > > unbalanced kmap is a bad bug - the easier we make it to catch, 
> > > the better. The system wouldnt survive anyway.
> > 
> > My proposed patch validates strict balance of types. But I can 
> > easily add the above as well.
> > 
> > By removing the types it becomes very difficult to verify the max 
> > depth. I really don't like removing them.
> 
> The fact that it implies an atomic section pretty much limits its 
> depth in practice, doesnt it?
> 
> All we need to track in the debug code is 
> max-{syscall,softirq,hardirq,nmi}. The sum of these 4 counts must be 
> smaller than the max - even if (as you are right to point out) we 
> dont hit that magic combo that truly maximizes the depth.
> 
> And note that in practice many of the current types are exclusive to 
> each other - so using the stack would _reduce_ the amount of 
> kmap-atomic space we need.

I'll briefly resurface into the discussion before submerging again ;)

I like very much the direction you're taking this, Ingo.

Yes, that is how I've sometimes thought we should go - though when
making the kmap_push/kmap_pop suggestion to Peter yesterday, I wasn't
expecting him to make that revolution, just provide a way to save a
current KM_type mapping and restore it later, so he can safely use
the standard primitives like pte_offset_map() within.

I wasn't expecting in_nmi() and in_irq() tests still to be there,
even if only when debug.  I can understand Peter's lockdep background
wanting to retain the checking and KM_types, but if we're actually
going to overhaul this area, I'd love just to get rid of them.

Yes, that should reduce the amount of kmap_atomic space needed;
though I've not thought how we keep track of the maximum needed
as the kernel goes on developing.

There might be a very few places where we expect to kmap_atomic A,
kmap_atomic B, kunmap_atomic A, kunmap_atomic B?

Something else to throw in: what if they were not just atomic,
but also replaced the current sleeping kmaps? i.e. a task context
carries around its own stack of these.

I've always rejected that as introducing a pretty terrible overhead
just where we don't want it; but maybe you're ingenious enough to
devise ways of amortizing that cost.

It would be nice to delete mm/highmem.c is we could.  Ah, but there
are probably places where one task passes a kmap address to another?

Hugh
