Return-Path: <linux-kernel-owner+w=401wt.eu-S933221AbZFQM2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbZFQM2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbZFQM2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:28:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762661AbZFQM2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:28:42 -0400
Date: Wed, 17 Jun 2009 14:28:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
Message-ID: <20090617122812.GD13316@elte.hu>
References: <20090615181555.GA11248@elte.hu> <1245089943.13761.19334.camel@twins> <20090615182549.GD11248@elte.hu> <1245090608.13761.19349.camel@twins> <20090615184217.GG11248@elte.hu> <1245091674.6741.180.camel@laptop> <20090615185259.GK11248@elte.hu> <1245092433.6741.201.camel@laptop> <20090616081348.GC16229@elte.hu> <1245224675.13761.21598.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245224675.13761.21598.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-06-16 at 10:13 +0200, Ingo Molnar wrote:
> 
> > > By removing the types it becomes very difficult to verify the max 
> > > depth. I really don't like removing them.
> > 
> > The fact that it implies an atomic section pretty much limits its 
> > depth in practice, doesnt it?
> > 
> > All we need to track in the debug code is 
> > max-{syscall,softirq,hardirq,nmi}. The sum of these 4 counts 
> > must be smaller than the max - even if (as you are right to 
> > point out) we dont hit that magic combo that truly maximizes the 
> > depth.
> 
> Right, so the thing I'd worry about is someone adding 
> kmap_atomic() to an interrupt context that didn't have interrupts 
> disabled and then managing to nest that a few times.
> 
> Suppose you put it in some IO completion handler, and someone has 
> 4 IO controllers installed and all 4 IO interrupts come in at the 
> 'same' time.
> 
> With types you could warn on similarly to what we do today, but 
> with the simple push/pop that might be a lot harder.

Yes, fixed-purpose allocations are easier to warn about - they imply 
more constraints, no doubt about that.

But we could warn about using kmap-atomic with in irq context with 
irqs enabled and thus exclude the case you are worried about?

> Anyway, with the whole cr2 fiddling bit being discussed this seems 
> to become redundant.

It's not just the cr2 fiddling but also conversion of pagefault 
returns from IRET to RET. The kmap_atomic API change is a nice 
cleanup in itself.

	Ingo
