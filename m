Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZCQQAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZCQQAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbZCQQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:00:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbZCQQAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:00:19 -0400
Date: Tue, 17 Mar 2009 08:48:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jesper Krogh <jesper@krogh.cc>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <20090317081412.GA24115@elte.hu>
Message-ID: <alpine.LFD.2.00.0903170831020.3082@localhost.localdomain>
References: <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc>
 <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain> <20090317081412.GA24115@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Mar 2009, Ingo Molnar wrote:
> 
> Cool. Will you apply it yourself (in the merge window) or should 
> we pick it up?

I'll commit it.  I already split it into two commits - one for the trivial 
startup problem that John had, one for the "estimate error and exit when 
smaller than 500ppm" part.

> Incidentally, yesterday i wrote a PIT auto-calibration routine 
> (see WIP patch below).
> 
> The core idea is to use _all_ thousands of measurement points 
> (not just two) to calculate the frequency ratio, with a built-in 
> noise detector which drops out of the loop if the observed noise 
> goes below ~10 ppm.

I suspect that reaching 10 ppm is going to take too long in general. 
Considering that I found a machine where reaching 500ppm took 16ms, 
getting to 10ppm would take almost a second. That's a long time at bootup, 
considering that people want the whole boot to take about that time ;)

I also do think it's a bit unnecessarily complicated. We really only care 
about the end points - obviously we can end up being unlucky and get a 
very noisy end-point due to something like SMI or virtualization, but if 
that happens, we're really just better off failing quickly instead, and 
we'll go on to the slower calibration routines.

On real hardware without SMI or virtualization overhead, the delays 
_should_ be very stable. On my main machine, for example, the PIT read 
really seems very stable at about 2.5us (which matches the expectation 
that one 'inb' should take roughly one microsecond pretty closely). So 
that should be the default case, and the case that the fast calibration is 
designed for.

For the other cases, we really can just exit and do something else.

> It's WIP because it's not working yet (or at all?): i couldnt 
> get the statistical model right - it's too noisy at 1000-2000 
> ppm and the frequency result is off by 5000 ppm.

I suspect your measurement overhead is getting noticeable. You do all 
those divides, but even more so, you do all those traces. Also, it looks 
like you do purely local pairwise analysis at subsequent PIT modelling 
points, which can't work - you need to average over a long time to 
stabilize it.

So you _can_ do something like what you do, but you'd need to find a 
low-noise start and end point, and do analysis over that longer range 
instead of trying to do it over individual cases. 

> I also like yours more because it's simpler.

In fact, it's much simpler than what we used to do. No real assumptions 
about how quickly we can read the PIT, no need for magic values ("we can 
distinguish a slow virtual environment from real hardware by the fact that 
we can do at least 50 PIT reads in one cycle"), no nothing. Just a simple 
"is it below 500ppm yet?".

(Well, technically, it compares to 1 in 2048 rather than 500 in a million, 
since that is much cheaper, so it's really looking for "better than 
488ppm")

		Linus
