Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXFESsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXFESsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbXFESsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:48:31 -0400
Received: from www.osadl.org ([213.239.205.134]:49819 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759489AbXFESsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:48:30 -0400
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070605173949.GA27618@ms2.inr.ac.ru>
References: <20070507144351.GA12302@ms2.inr.ac.ru>
	 <20070523072609.GC6859@elte.hu> <20070523115159.GA30251@ms2.inr.ac.ru>
	 <1181060711.4404.114.camel@chaos>  <20070605173949.GA27618@ms2.inr.ac.ru>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 20:48:26 +0200
Message-Id: <1181069306.4404.145.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 21:39 +0400, Alexey Kuznetsov wrote:
> Hello!
> 
> > Hmm, what means not expected ? -ESRCH is returned, when the owner task
> > is not found. 
> 
> This is not supposed to happen with robust futexes.

Hmm, right.

> > This does not really explain, why you do prevent the -ESRCH return value
> > in the next cycle,
> 
> Because right curval is refetched, it already has FUTEX_OWNER_DIED bit set
> and we succesfully take the lock.

Ok, handle_futex_death() is punching the OWNER_DIED bit into the futex
without the hash bucket lock. We might as well grab the hash bucket lock
right there to avoid this. I look for a sane solution.

> > The rtmutex code only returns -EDEADLK, when the lock is already held by
> > the task
> 
> This case.

Sorry, I was not clear here: not the user space lock, the rtmutex must
be held or a deadlock situation against another rtmutex must be
detected. There is no way that the exiting code assigns the owner ship
of the rtmutex. It solely calls rtmutex_unlock() which makes the highest
priority waiter the _PENDING_ owner, which means the pending owner needs
to acquire it for real. 

> You need run only tst-robustpi8 in loop. It should be triggered quickly,
> a few of minutes on 8-way smp here.

My largest box is a 4 way and it runs since hours in a while true loop.

> If you want, I can insert some debugging printks, which you need,
> and run the test here.

I fix up some things in the code first and then I'll add a couple of
debugs to nail this EDEADLK problem.

	tglx


