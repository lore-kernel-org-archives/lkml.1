Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYHSJ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYHSJ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYHSJ2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:28:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbYHSJ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:28:21 -0400
Date: Tue, 19 Aug 2008 11:27:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819092754.GE28713@elte.hu>
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <20080819012816.GA7897@elte.hu> <48AA65A5.8020408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA65A5.8020408@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I think this might be a spurious "holding multiple locks in the same 
> class" bug.  All the queue locks are presumably in the same class, and 
> ipi_call_lock_irq() wants to hold them all to lock out any IPIs. 
> Spurious because this is the only place which holds more than one 
> queue lock, and it always locks 0->N.
> 
> I guess the fix is to use an outer lock and use spin_lock_nested() 
> (now that it exists).  Something along these lines?

this is not a good idea:

> +/* Hold queues_lock when taking more than one queue[].lock at once */
> +static DEFINE_SPINLOCK(queues_lock);

because it adds an artificial extra spinlock for no good reason and 
weakens the lock dependency checking as well.

Just add a lock class descriptor to each call_function_queue lock, so 
that lockdep can see that it's truly all in the correct order.

I.e. dont turn lockdep off artificially.

	Ingo
