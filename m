Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbXEOWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbXEOWBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbXEOWBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:01:05 -0400
Received: from mail.screens.ru ([213.234.233.54]:41780 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbXEOWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:01:04 -0400
Date: Wed, 16 May 2007 02:00:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       David Howells <dhowells@redhat.com>, Gautham Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070515220024.GA615@tv-sign.ru>
References: <20070503204226.GA212@tv-sign.ru> <464475EB.3000408@gmail.com> <20070511134714.GA191@tv-sign.ru> <46448965.7070500@gmail.com> <20070511145345.GA240@tv-sign.ru> <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46496EC1.3090109@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15, Tejun Heo wrote:
>
> Oleg Nesterov wrote:
> 
> > So, try_to_grab_pending() should check "VALID && pointers equal" atomically.
> > We can't do "if (VALID && cwq == get_wq_data(work))". We should do something
> > like this
> > 
> > 	(((long)cwq) | VALID | PENDING) == atomic_long_read(&work->data)
> > 
> > Yes? I need to think more about this.
> 
> I don't think the test for PENDING should be atomic too.  cwq pointer
> and VALID is one package.  PENDING lives its own life as a atomic bit
> switch.

Yes sure, it should not be atomic. But (VALID && !PENDING) == BUG, so we
can't just "kill" PENDING form the check above.

> > BTW, in _theory_, spinlock() is not a read barrier, yes?
> 
> It actually is.
> 
> > From Documentation/memory-barriers.txt
> > 
> >      Memory operations that occur before a LOCK operation may appear to happen
> >      after it completes.
> 
> Which means that spin_lock() isn't a write barrier.

yes, it is not very clear which "Memory operations" memory-barriers.txt
describes.

>                                                       lock is read
> barrier, unlock is write barrier.

(To avoid a possible confusion: I am not arguing, I am trying to understand,
 and please also note "in _theory_" above)

Is it so? Shoudn't we document this if it is true?

>                                    Otherwise, locking doesn't make much
> sense.

Why? Could you please give a code example we have which relies on this?

>     If we're going the barrier way, I think we're better off with
> explicit smp_wmb().  It's only barrier() on x86/64.

Yes. But note that we don't have any reason to do set_wq_data() under
cwq->lock (this is also true for wake_up(->more_work) btw), so it makes
sense to do this change anyway. And "wmb + spin_lock" looks a bit strange,
I _suspect_ spin_lock() means a full barrier on most platforms.

Could you also look at
	http://marc.info/?t=116275561700001&r=1

and, in particular,
	http://marc.info/?l=linux-kernel&m=116281136122456

Thanks!

Oleg.

