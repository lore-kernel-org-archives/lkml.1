Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYCVV6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYCVV6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYCVV6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:58:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbYCVV6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:58:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Friday, 21 March 2008 10:57:20 -0700 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080206165045.89b809cc.akpm@linux-foundation.org>
	<1202345893.8525.33.camel@peace.smo.corp.google.com>
	<alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	<20080207162203.3e3cf5ab@Varda>
	<alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	<alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	<20080207165455.04ec490b@Varda>
	<alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	<alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	<1204314904.4850.23.camel@peace.smo.corp.google.com>
	<20080304070016.903E127010A@magilla.localdomain>
	<1204660376.9768.1.camel@bobble.smo.corp.google.com>
	<20080305040826.D0E6127010A@magilla.localdomain>
	<1204830243.20004.31.camel@bobble.smo.corp.google.com>
	<20080311075020.A93DB26F991@magilla.localdomain>
	<1205269507.23124.57.camel@bobble.smo.corp.google.com>
	<20080311213507.5BCDF26F991@magilla.localdomain>
	<1205455050.19551.16.camel@bobble.smo.corp.google.com>
	<20080321071846.1B22B26F9A7@magilla.localdomain>
	<1206122240.14638.31.camel@bobble.smo.corp.google.com>
X-Shopping-List: (1) Gaelic Beef chains
   (2) Felonious compasses
   (3) Flammable consoles
   (4) Callous bees
   (5) Prevalent honey
Message-Id: <20080322215829.D69D026F9A7@magilla.localdomain>
Date: Sat, 22 Mar 2008 14:58:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would really like to just ignore the 2-cpu scenario and just have two
> versions, the UP version and the n-way SMP version.  It would make life,
> and maintenance, simpler.

Like I've said, it's only something to investigate for best performance.
If the conditional code is encapsulated well, it will be simple to add
another variant later and experiment with it.

> Okay, I'll go back over this and make sure I got it right.  It's
> interesting, though, that my current patch (written without this
> particular bit of knowledge) actually performs no differently from the
> existing mechanism.

Except for correctness in scenarios other than the one you are testing. :-)

> 	Testing was performed using a heavily-modified version of the test
> 	that originally showed the problem.  The test sets ITIMER_PROF (if
> 	not run with "nohang" in the name of the executable) [...]

There are several important scenarios you did not test.
Analysis of combinations of all these variables is needed.
1. Tests with a few threads, like as many threads as CPUs or only 2x as many.
2. Tests with a process CPU timer set for a long expiration time.
   i.e. a timer set, but that never goes off in your entire run.
   (This is what a non-infinity RLIMIT_CPU limit does.)
   With the old code, a long enough timer and a small enough number
   of threads will never trigger a "rebalance".

> Actually, after looking at the code again and thinking about it a bit,
> it appears that the signal_struct.it_*_incr field holds the actual
> interval as set by setitimer.  Initially the it_*_expires field holds
> the expiration time as set by setitimer, but after the timer fires the
> first time that value becomes <firing time>+it_*_incr.  In other words,
> the first time it fires at the value set by setitimer() but from then on
> it fires at a time indicated by whatever the time was the last time the
> timer fired plus the value in it_*_incr.  This time is stored in
> signal_struct.it_*_expires.

That's correct.  The it_*_expires fields store itimerval.it_value (the
current timer) and the it_*_incr fields store itimerval.it_interval (the
timer reload setting).

> I guess I could be wrong about this, but it appears to be what the code
> is doing.  If my analysis is correct, I really don't need a new field,
> since the old fields work just fine.

The analysis above is correct but your conclusion here is wrong.
The current value of an itimer is a user feature, not just a piece
of internal bookkeeping.

getitimer returns in it_value the amount of time until the itimer
fires, regardless of whether or not it will reload after it fires or
with what value it will be reloaded.  In a setitimer call, the
it_value sets the time at which the itimer must fire, regardless of
the reload setting in it_interval.  Consider the case where
it_interval={0,0}; it_value is still meaningful.  

Your code causes any timer_settime or timer_delete call on a process
CPU timer or any setrlimit call on RLIMIT_CPU to suddenly change the
itimer setting just as if the user had made some setitimer call that
was never made or intended.  That's wrong.


Thanks,
Roland
