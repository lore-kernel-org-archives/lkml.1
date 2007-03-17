Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXCQE6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXCQE6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 00:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbXCQE6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 00:58:17 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:56313 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933334AbXCQE6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 00:58:16 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 15:57:53 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703171351.47399.kernel@kolivas.org> <200703170740.07530.a1426z@gawab.com>
In-Reply-To: <200703170740.07530.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703171557.53700.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 15:40, Al Boldi wrote:
> Con Kolivas wrote:
> > On Saturday 17 March 2007 08:55, Al Boldi wrote:
> > > With X nice'd at -10, and 11 hogs loading the cpu, interactivity looks
> > > good until the default timeslice/quota is exhausted and slows down.
> > > Maybe adjusting this according to nice could help.
> >
> > Not sure what you mean by that. It's still a fair distribution system,
> > it's just that nice -10 has quite a bit more cpu allocated than nice 0.
> > Eventually if you throw enough load at it it will slow down too.
>
> I mean #DEF_TIMESLICE seems like an initial quota, which gets reset with
> each major rotation.  Increasing this according to nice may give it more
> room for an interactivity boost, before being expired.  Alternatively, you
> may just reset the rotation, if the task didn't use it's quota within one
> full major rotation, effectively skipping the expiry toll.

DEF_TIMESLICE is a value used for smp balancing and has no effect on quota so 
I doubt you mean that value. The quota you're describing of not resetting is 
something like the sleep average idea of current systems where you accumulate 
bonus points by sleeping when you would be running and redeem them later. 
This is exactly the system I'm avoiding using in rsdl as you'd have to decide 
just how much sleep time it could accumulate, and over how long it would run 
out, and so on. ie that's the interactivity estimator. This is the system 
that destroys any guarantee of cpu percentage, and ends up leading to periods 
of relative starvation, is open to tuning that can either be too short or too 
long depending on the values you chose and so on.

> > > It may also be advisable to fix latencies according to nice, and adjust
> > > timeslices instead.  This may help scaleability a lot, as there are
> > > some timing sensitive apps that may crash under high load.
> >
> > You will find that is the case already with this version. Even under
> > heavy load if you were to be running one server niced (say httpd nice 19
> > in the presence of mysql nice 0) the latencies would be drastically
> > reduced compared to mainline behaviour. I am aware this becomes an issue
> > for some heavily loaded servers because some servers run multithreaded
> > while others do not, forcing the admins to nice their multithreaded ones.
>
> The thing is, latencies are currently dependent on the number of tasks in
> the run-queue; i.e. more rq-tasks means higher latencies, yet fixed
> timeslices according to nice.  Just switching this the other way around, by
> fixing latencies according to nice, and adjusting the timeslices depending
> on rq-load, may yield a much more scalable system.

That is not really feasible to implement. How can you guarantee latencies when 
the system is overloaded? If you have 1000 tasks all trying to get scheduled 
in say 10ms you end up running for only 10 microseconds at a time. That will 
achieve the exact opposite whereby as the load increases the runtime gets 
shorter and shorter till cpu cache trashing and no real work occurs.

> Thanks!
>
> --
> Al

-- 
-ck
