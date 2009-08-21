Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZHUTTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZHUTTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZHUTTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:19:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbZHUTTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:19:41 -0400
Date: Fri, 21 Aug 2009 21:17:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-tip-commits@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, catalin.marinas@arm.com,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, fweisbec@gmail.com,
       stable@kernel.org, srostedt@redhat.com, tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
	do_one_initcall()
Message-ID: <20090821191759.GA8607@elte.hu>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org> <20090821111450.GA32037@elte.hu> <20090821104820.60948082.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821104820.60948082.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 21 Aug 2009 13:14:50 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ...
> >
> > btw., it will just take two more features like kmemleak to 
> > trigger hard to debug stack overflows again on 32-bit. We are 
> > right at the edge and this situation is not really fixable in a 
> > reliable way anymore.
> > 
> > So i think we should be more drastic and solve the real problem: 
> > we should drop 4K stacks and 8K combo-stacks on 32-bit, and go 
> > exclusively to 8K split stacks on 32-bit.
> 
> We seem to have overrun an 8k stack in
> http://bugzilla.kernel.org/show_bug.cgi?id=14029

Btw., this is inapposite because 8K stacks on 32-bit are 'shared' - 
i.e. full process, softirq, hardirq and NMI context will nest on 
each other, into the same 8K stack.

What i suggested in my mail was to up the 4K stacks option to 8K, 
and to keep the separate IRQ/softirq stacks. (similar to 64-bit) 
This is quite different from the 8K shared-stack option on 32-bit.

Plus, i looked at the oops cited above, and it's in the idle thread. 
The idle thread does not do anything process level and if there's a 
stack overflow it generally does not trigger in the idle thread 
(because it has much less stack pressure).

Still, the stack could have overrun in IRQ context - but a more 
likely scenario would be some other memory corruption crippling the 
stack-overflow signature at the end of idle task's stack.

> Do we have a max-stack-depth tracer widget btw?

we do have an ftrace plugin for it, yes. But it has high cost (it 
traces all the time to find the maximum), so i'm not sure how 
realistic it would be to integrate it into the kerneloops daemon for 
example.

It could certainly be done - a sufficiently enabled kernel has to be 
built (perhaps a kernel-debug package) and the 
/debug/tracing/max_stack_trace value can be monitored for 'too much' 
values.

> > I.e. the stack size will be 'unified' too between 64-bit and 
> > 32-bit to a certain degree: process stacks will be 8K on both 
> > 64-bit and 32-bit x86, IRQ stacks will be separate. (on 64-bit 
> > we also have the IST stacks for certain exceptions that further 
> > isolates things)
> > 
> > This will simplify the 32-bit situation quite a bit and removes 
> > a contentious config option and makes the kernel more robust in 
> > general. 8K combo stacks are not safe due to irq nesting and 4K 
> > isolated stacks are not enough. 8K isolated stacks is the way to 
> > go.
> > 
> > Opinions?
> 
> I wouldn't lose any sleep over it.
> 
> I bet it would be sufficient to have 4k interrupt stacks though.
> 
> My main concern would be maintenance.  Over time we'll chew more 
> and more stack space and eventually we'll get into trouble again.  
> What means do we have for holding the line at 8k, and even 
> improving things?

We already have the '8K line'. People who see stack overflows 
_already_ go to the 8K stack kernel. The nasty thing about that is 
that while it might solve their immediate problem, 8K shared stack 
is still fragile in 'once in a blue moon' scenarios.

That's why i'm thinking about introducing the similar parameters all 
across on x86: 8K process stack on both 32-bit and 64-bit, and 8K 
(or larger) IRQ/softirq stacks.

This will have the added benefit of pushing the 'line of defense' 
into the 64-bit space - which generally gets much more (and much 
earlier) stress-testing in server shops - so we could find the 
nastier bugs before they hit the 32-bit desktop en masse.

	Ingo
