Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYKRRME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYKRRME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYKRRLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:11:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYKRRLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:11:52 -0500
Date: Tue, 18 Nov 2008 12:11:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
In-Reply-To: <20081118144053.0072d54c@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811181157260.13418@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
 <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
 <1226696221.7685.8148.camel@twins> <Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
 <1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
 <Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
 <20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
 <20081118144053.0072d54c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008, Alan Cox wrote:

> > You will touch the wait queue always when finishing the last pending 
> > request --- just to find out that there is no one waiting on it.
> 
> Why ? If my fast path for this something like
> 
> 	if (unlikely(foo->unload_pending) && count == 0)
> 		wake_up(..)
> 
> chances are that I can put unload_pending somewhere in a cache line with
> other stuff (certainly for L2) and it will get predicted well.

This makes a code branch that is very rarely tested and a potential bug. 
Every such rarely executed branch is a danger and even a silly typo in the 
code can hide there for many years without being noticed.

These rare branches are inevitable at some places, I just don't see a 
reason why make deliberately more of them.

> > And besides cache line, there is coding and testing overhead with wait 
> > queues.
> 
> If you want correctness you don't want busy waiting with yields - as Ingo
> pointed out already thats a bug in itself with hard realtime.

So, I say msleep(1) instead of yield(). What are the counterarguments to 
msleep?

> > So what are the reasons why you (and others) are against active waiting? 
> > All you are saying is that my reasons are wrong, but you haven't single 
> > example when active waiting causes trouble. If there is a workload when 
> 
> Untrue - I've given very clear reasons twice, and Ingo has given you
> more. If you don't wish to accept the answers that is your problem not
> mine, just expect such hacks to get a NAK and not make the kernel.

If it is only a matter of coding style and there is no valid reason why 
msleep(1) when unloading the driver would hurt. Just say it "we have this 
coding policy, we want the code to look like a state machine independent 
on the timer".

But don't invent pseudoreasons, such that: the system boots 30 seconds, 
shuts down in 5 seconds, and that 1ms-10ms sleep on shutdown is bad for 
virtualization and power consumption and performance and whatever --- even 
if it actually happens only to one user in a few years.

Mikulas

> Alan
> --
> "I can only provide the information, I can't make you hear it."
> 		- Shelley Bainter
> 
