Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZKWLne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZKWLne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZKWLnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:43:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930AbZKWLnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:43:33 -0500
Date: Mon, 23 Nov 2009 12:43:39 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123114339.GB2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258976175.4531.299.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:36:15PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 12:22 +0100, Nick Piggin wrote:
> > Hi,
> > 
> > I wonder why it was decided to do newidle balancing in the NUMA
> > domain? And with newidle_idx == 0 at that.
> > 
> > This means that every time the CPU goes idle, every CPU in the
> > system gets a remote cacheline or two hit. Not very nice O(n^2)
> > behaviour on the interconnect. Not to mention trashing our
> > NUMA locality.
> > 
> > And then I see some proposal to do ratelimiting of newidle
> > balancing :( Seems like hack upon hack making behaviour much more
> > complex.
> > 
> > One "symptom" of bad mutex contention can be that increasing the
> > balancing rate can help a bit to reduce idle time (because it
> > can get the woken thread which is holding a semaphore to run ASAP
> > after we run out of runnable tasks in the system due to them 
> > hitting contention on that semaphore).
> > 
> > I really hope this change wasn't done in order to help -rt or
> > something sad like sysbench on MySQL.
> 
> IIRC this was kbuild and other spreading workloads that want this.
> 
> the newidle_idx=0 thing is because I frequently saw it make funny
> balance decisions based on old load numbers, like f_b_g() selecting a
> group that didn't even have tasks in anymore.

Well it is just a damping factor on runqueue flucturations. If the
group recently had load then the point of the idx is to account
for this. On the other hand, if we have other groups that are also
above the idx damped average, it would make sense to use them
instead. (ie. cull source groups with no pullable tasks).


> We went without newidle for a while, but then people started complaining
> about that kbuild time, and there is a x264 encoder thing that looses
> tons of throughput.

So... these were due to what? Other changes in domains balancing?
Changes in CFS? Something else? Or were they comparisons versus
other operating systems?

