Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbXHBClm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbXHBClm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 22:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbXHBCle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 22:41:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbXHBCld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 22:41:33 -0400
Date: Thu, 2 Aug 2007 04:41:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070802024132.GD15595@wotan.suse.de>
References: <20070802021525.GC15595@wotan.suse.de> <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708011922500.3582@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 07:31:26PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 2 Aug 2007, Nick Piggin wrote:
> > 
> > lmbench 3 lat_ctx context switching time with 2 processes bound to a
> > single core increases by between 25%-35% on my Core2 system (didn't do
> > enough runs to get more significance, but it is around 30%). The problem
> > bisected to the main CFS commit.
> 
> One thing to check out is whether the lmbench numbers are "correct". 
> Especially on SMP systems, the lmbench numbers are actually *best* when 
> the two processes run on the same CPU, even though that's not really at 
> all the best scheduling - it's just that it artificially improves lmbench 
> numbers because of the close cache affinity for the pipe data structures.

Yes, I bound them to a single core.


> So when running the lmbench scheduling benchmarks on SMP, it actually 
> makes sense to run them *pinned* to one CPU, because then you see the true 
> scheduler performance. Otherwise you easily get noise due to balancing 
> issues, and a clearly better scheduler can in fact generate worse 
> numbers for lmbench.
> 
> Did you do that? It's at least worth testing. I'm not saying it's the case 
> here, but it's one reason why lmbench3 has the option to either keep 
> processes on the same CPU or force them to spread out (and both cases are 
> very interesting for scheduler testing, and tell different things: the 
> "pin them to the same CPU" shows the latency on one runqueue, while the 
> "pin them to different CPU's" shows the latency of a remote wakeup).
> 
> IOW, while we used the lmbench scheduling benchmark pretty extensively in 
> early scheduler tuning, if you select the defaults ("let the system just 
> schedule processes on any CPU") the end result really isn't necessarily a 
> very meaningful value: getting the best lmbench numbers actually requires 
> you to do things that tend to be actively *bad* in real life.
> 
> Of course, a perfect scheduler would notice when two tasks are *so* 
> closely related and only do synchronous wakups, that it would keep them on 
> the same core, and get the best possible scores for lmbench, while not 
> doing that for other real-life situations. So with a *really* smart 
> scheduler, lmbench numbers would always be optimal, but I'm not sure 
> aiming for that kind of perfection is even worth it!

Agreed with all your comments on multiprocessor balancing, but that
was eliminated in these tests. I remote wakeup latency is another thing
I want to test, but it isn't so interesting until the serial regression
is fixed.
