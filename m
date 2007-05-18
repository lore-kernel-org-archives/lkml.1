Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXERH2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXERH2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXERH2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:28:42 -0400
Received: from mx2.go2.pl ([193.17.41.42]:49197 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753689AbXERH2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:28:41 -0400
Date: Fri, 18 May 2007 09:35:17 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070518073517.GB1573@ff.dom.local>
References: <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516185203.GB81@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 10:52:03PM +0400, Oleg Nesterov wrote:
...
> Ah, but this is something different. Both lock/unlock are full barriers,
> but they protect only one direction. A memory op must not leak out of the
> critical section, but it may leak in.
> 
> 	A = B;		// 1
> 	lock();		// 2
> 	C = D;		// 3
> 
> this can be re-ordered to
> 
> 	lock();		// 2
> 	C = D;		// 3
> 	A = B;		// 1
> 
> but 2 and 3 must not be re-ordered.
> 
> To be sure, I contacted Paul E. McKenney privately, and his reply is
> 
> 	> No.  See for example IA64 in file include/asm-ia64/spinlock.h,
> 	> line 34 for spin_lock() and line 92 for spin_unlock().  The
> 	> spin_lock() case uses a ,acq completer, which will allow preceding
> 	> reads to be reordered into the critical section.  The spin_unlock()
> 	> uses the ,rel completer, which will allow subsequent writes to be
> 	> reordered into the critical section.  The locking primitives are
> 	> guaranteed to keep accesses bound within the critical section, but
> 	> are free to let outside accesses be reordered into the critical
> 	> section.
> 	>
> 	> Download the Itanium Volume 2 manual:
> 	>
> 	>         http://developer.intel.com/design/itanium/manuals/245318.htm
> 	>
> 	> Table 2.3 on page 2:489 (physical page 509) shows an example of how
> 	> the rel and acq completers work.

Hi,

I managed to find some time to look at this all once more,
and here is my current opinion:

1. I think this above mentioned lock vs. barrier behavior is
in compliance with memory-barriers.txt, and BTW I'd like to
thank and congratulate David Howells of very good style
(and beautiful pictures).

2. IMHO the current solution with smp barriers is very good:
these barriers are really needed and they should be enough.
Oleg repeats all the time he hates barriers, but I think
it's wrong approach - they should be seen as something
natural for programming modern processors and trying to
change the code only to avoid them is wrong (unless it
could be done with some minor changes).

3. The alternative solution without barriers, based on the
idea of Tejun Heo and presented in the patch proposal from
2007-05-13, could be probably a little faster (for some
processors), after some changes:

- I think, instead of separate __set_bit and __clear_bit,
WORK_STRUCT_QUEUED bit should be changed during set_wq_data
(additional parameter or new variant eg: set_wq_data_queued),
and similarly something like  work_clear_pending_queued -
so, without additional operations instead of these barriers.

- changing this if condition in try_to_grab_pending.

But there is a question - is this worth of one (last) bit
occupied only for optimisation (but not always)?

So, maybe it would be better to think about solving those
other problems in workqueue, mentioned by Oleg somewhere?

Regards,
Jarek P.
