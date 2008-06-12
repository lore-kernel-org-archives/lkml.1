Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYFLIJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYFLIJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYFLIJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:09:23 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:37097 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYFLIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:09:22 -0400
Message-ID: <4850D9AC.3040706@aitel.hist.no>
Date: Thu, 12 Jun 2008 10:09:16 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: 7eggert@gmx.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jakub Jozwicki <jozwicki@aster.pl>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sched_yield() on 2.6.25
References: <aCBfw-3Cv-23@gated-at.bofh.it> <aCBfw-3Cv-21@gated-at.bofh.it>	 <aCJd6-3IF-11@gated-at.bofh.it> <aCRaM-8cM-33@gated-at.bofh.it>	 <20080611152807.0682218F62@be1.lrz> <c384c5ea0806111545g6e6128bek519ce6022a301339@mail.gmail.com>
In-Reply-To: <c384c5ea0806111545g6e6128bek519ce6022a301339@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leon Woestenberg wrote:
[...]
> That's not the definition of sched_yield(). See the earlier emails,
> and the quote above.
>
> As the code after sched_yield() has to be executed the thread will be
> rescheduled soon (or even immediately) anyway.
>
> The users not understanding the limited scope where sched_yield()
> behaves deterministicly, seem to think that _yield() will yield() AND
> lower the thread's dynamic priority for SCHED_OTHER. Is downgrading
> the dynamic priority a behavioral option?
>   
That can be done of course, but that too will cause breakage.
Consider a multithreaded app mistakenly relying on sched_yield.

Priority downgrading might work really well as long as this app runs alone,
the yielding thread stops and the others progress, so sched_yield works
for "userspace locking". And it works so well, the app uses it a lot.

Then someone recompiles the distro or runs some other kinds of cpu hogs
that drives the load well above 1. Users expect the apps to run a little
slower because of this. But a load of 5 still ought to give you 1/5
of the cpu - and with today's CPU's that might still be better than
a 5-year old machine. Interactive software should almost not notice,
as it don't use the cpu that much anyway - and it gets priority over
cpu hogs when it occationally needs to do something.

But now this multithreaded app practically
stops because it yields a lot - an everytime it lowers its priority
below not only its own other threads, but below the various
cpu hogs as well. (Compilers gets dynamic boosts too, as they
wait a little for the disk now and then. A parallel compile still
keeps the total load high.)

I remember seeing openoffice taking 5min to start some years ago,
with a compile going on. Of course there were other problems
like swapping and a smaller computer, but other apps were merely slow,
not that glacial.
> On the other hand, I don't think anything should encourage the use of
> sched_yield() outside of the rare SCHED_FIFO/RR case.
>   
Exactly. There seems to be no way to make sched_yield work "as expected"
for all the ways it is abused, so better use something else.

Helge Hafting




