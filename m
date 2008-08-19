Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYHSJqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYHSJqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYHSJqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:46:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYHSJqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:46:03 -0400
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <48AA65A5.8020408@goop.org>
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu>
	 <20080819012816.GA7897@elte.hu>  <48AA65A5.8020408@goop.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 11:45:54 +0200
Message-Id: <1219139154.10800.380.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 23:18 -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >   
> >> nice stuff!
> >>
> >> I suspect the extra cost might be worth it for two reasons: 1) we 
> >> could optimize the cross-call implementation further 2) on systems 
> >> where TLB flushes actually matter, the ability to overlap multiple TLB 
> >> flushes to the same single CPU might improve workloads.
> >>
> >> FYI, i've created a new -tip topic for your patches, tip/x86/tlbflush. 
> >> It's based on tip/irq/sparseirq (there are a good deal of dependencies 
> >> with that topic).
> >>     
> >
> > i threw it into -tip testing for a while - triggered the lockdep warning 
> > on 64-bit below.
> >
> > 	Ingo
> >
> > ------------>
> > checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> >
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.27-rc3-tip #1
> > ---------------------------------------------
> > swapper/0 is trying to acquire lock:
> >  (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e
> >
> > but task is already holding lock:
> >  (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e
> >   
> 
> I think this might be a spurious "holding multiple locks in the same
> class" bug.  All the queue locks are presumably in the same class, and
> ipi_call_lock_irq() wants to hold them all to lock out any IPIs. 
> Spurious because this is the only place which holds more than one queue
> lock, and it always locks 0->N.
> 
> I guess the fix is to use an outer lock and use spin_lock_nested() (now
> that it exists).  Something along these lines?

spin_lock_nested() has existed for a long time, but you are now using
spin_lock_nest_lock(), which is a totally different annotation



