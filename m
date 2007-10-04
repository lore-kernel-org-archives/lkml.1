Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbXJDAcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbXJDAcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 20:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbXJDAcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 20:32:05 -0400
Received: from ozlabs.org ([203.10.76.45]:40737 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbXJDAcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 20:32:02 -0400
Subject: RE: Network slowdown due to CFS
From: Rusty Russell <rusty@rustcorp.com.au>
To: davids@webmaster.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
References: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 10:31:49 +1000
Message-Id: <1191457909.8268.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 09:49 -0700, David Schwartz wrote:
> > * Jarek Poplawski <jarkao2@o2.pl> wrote:
> >
> > > BTW, it looks like risky to criticise sched_yield too much: some
> > > people can misinterpret such discussions and stop using this at all,
> > > even where it's right.
> 
> > Really, i have never seen a _single_ mainstream app where the use of
> > sched_yield() was the right choice.
> 
> It can occasionally be an optimization. You may have a case where you can do
> something very efficiently if a lock is not held, but you cannot afford to
> wait for the lock to be released. So you check the lock, if it's held, you
> yield and then check again. If that fails, you do it the less optimal way
> (for example, dispatching it to a thread that *can* afford to wait).

This used to be true, and still is if you want to be portable.  But the
point of futexes was precisely to attack this use case: whereas
sched_yield() says "I'm waiting for something, but I won't tell you
what" the futex ops tells the kernel what you're waiting for.

While the time to do a futex op is slightly slower than sched_yield(),
futexes win in so many cases that we haven't found a benchmark where
yield wins.  Yield-lose cases include:
1) There are other unrelated process that yield() ends up queueing
   behind.
2) The process you're waiting for doesn't conveniently sleep as soon as
   it releases the lock, so you wait for longer than intended,
3) You race between the yield and the lock being dropped.

In summary: spin N times & futex seems optimal.  The value of N depends
on the number of CPUs in the machine and other factors, but N=1 has
shown itself pretty reasonable.

Hope that helps,
Rusty.

