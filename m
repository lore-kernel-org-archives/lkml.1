Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZBCFHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZBCFHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZBCFHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:07:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbZBCFHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:07:09 -0500
Date: Tue, 3 Feb 2009 06:06:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Message-ID: <20090203050648.GA14076@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain> <1233614927.18767.121.camel@pasglop> <200902030000.18049.rjw@sisk.pl> <1233620590.18767.138.camel@pasglop> <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902021635240.3247@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> > 
> > IE, you should have something to ensure, before you turn interrupts off,
> > that nobody else is inside the AML interpreter. You already know there
> > are no other CPUs, so it's just a matter of making sure no other process
> > has scheduled while holding that mutex.
> > 
> > The easy way to do that is to do something like taking the mutex
> > yourself and then setting a flag so that the intepreter stops trying to
> > take it or release it itself, maybe just using the global system state.
> > 
> > Then release the mutex on resume.
> 
> Why do you think this improves on anything?
> 
> Basically, it turns the mutex into a non-entity - but if your whole 
> argument is that it might as well be a non-entity because nobody else can 
> take it anyway, then why not just leave it around?
> 
> IOW, if your argument boils down to "there can be no contention", then you 
> might as well say "just use the mutex, it will never block".
> 
> So the only thing you really need is to just disable the _debugging_ code 
> that mutexes have (if they get built with debugging in the first place).
> 
> I can't find the bothersome code anyway: I do find
> 
> 	DEBUG_LOCKS_WARN_ON(in_interrupt());
> 
> but that's just saying that you shouldn't be using mutexes from 
> interrupts, not from irq-off segments. There's probably something I'm 
> missing, like the preempt_check_resched() causing a schedule event with 
> irq's disabled, and the "might_sleep()" thing. But the latter should 
> already be disabled by the "system_state != SYSTEM_RUNNING" thing.

Mutexes should work just fine in irqs-off sections - they'll safely 
save/restore interrupts, even the debug variants.

We used to have code in the mutex code that unconditionally enabled 
interrupts (a spin_unlock_irq() iirc) - but we fixed that pretty
early on because it surprised some early boot code. Maybe this is
the case you remember?

	Ingo
