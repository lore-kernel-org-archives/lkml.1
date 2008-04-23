Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYDWHue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYDWHue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYDWHuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:50:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54772 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYDWHuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:50:21 -0400
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, sam@ravnborg.org
In-Reply-To: <20080423074933.GB12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com>
	 <1208890227-24808-2-git-send-email-jens.axboe@oracle.com>
	 <1208895423.7115.290.camel@twins> <20080423060725.GT12774@kernel.dk>
	 <1208932320.7115.319.camel@twins>  <20080423074933.GB12774@kernel.dk>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 09:50:19 +0200
Message-Id: <1208937019.7115.326.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 09:49 +0200, Jens Axboe wrote:
> On Wed, Apr 23 2008, Peter Zijlstra wrote:
> > On Wed, 2008-04-23 at 08:07 +0200, Jens Axboe wrote:
> > > On Tue, Apr 22 2008, Peter Zijlstra wrote:
> > > > On Tue, 2008-04-22 at 20:50 +0200, Jens Axboe wrote:
> > > > 
> > > > > +int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> > > > > +			     int retry, int wait)
> > > > > +{
> > > > > +	unsigned long flags;
> > > > > +	/* prevent preemption and reschedule on another processor */
> > > > > +	int me = get_cpu();
> > > > > +
> > > > > +	/* Can deadlock when called with interrupts disabled */
> > > > > +	WARN_ON(wait && irqs_disabled());
> > > > 
> > > > With this fallback to wait the above condition isn't sufficient.
> > > 
> > > What deadlock are you concerned with here? Would making cfd_fallback
> > > per-cpu make you feel better?
> > 
> >   CPU0					  CPU1
> > 
> > local_irq_disable()			local_irq_disable()
> > 
> > 					smp_call_function_single(0,..,0)
> > 					  test_and_set_bit_lock()
> > 					  send IPI
> > smp_call_function_single(1,..,0)
> >   while(test_and_set_bit_lock())
> >     cpu_relax();
> > 
> > 
> > This will spin forever, because it needs to handle the IPI in order to
> > free the cfd_fallback thingy, but can't for its waiting for it.
> > 
> > That particular deadlock can indeed be solved by making cfd_fallback
> > per-cpu.
> 
> Right, that is the case I was thinking of. I added per-cpu fallbacks to
> cover that case.

Great, thanks!

> > But if you were to use multiple smp_call_function*() calls under a
> > single IRQ disabled, then that would not be sufficient. Now I can't
> > directly come up with a good reason to need to do that, but still.
> > 
> > You'd need somethine like:
> > 
> > local_irq_disable()
> > 
> > smp_call_function_single(n, func_a,..,0)
> > smp_call_function_single(m, func_b,..,0)
> > 
> > local_irq_enable()
> > 
> > And invite 3 cpus to the party while under memory pressure and you get
> > deadlock potential.
> > 
> > [ if it were both the same function, you'd want to use
> >   smp_call_function() and provide a mask; if it were the same cpu you'd
> >   want to call a function doing both ]
> 
> I think that is plenty far off into theoretical country that we can get
> by with just documenting this limitation. Nobody is doing that currently
> in the kernel, and I see no practical use case for it.

Agreed.

