Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbZKWMQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbZKWMQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZKWMQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:16:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:47218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930AbZKWMQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:16:22 -0500
Date: Mon, 23 Nov 2009 13:16:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123121628.GD2287@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258976175.4531.299.camel@laptop> <20091123114339.GB2287@wotan.suse.de> <1258977045.4531.317.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258977045.4531.317.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:50:45PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 12:43 +0100, Nick Piggin wrote:
> > On Mon, Nov 23, 2009 at 12:36:15PM +0100, Peter Zijlstra wrote:
> 
> > > IIRC this was kbuild and other spreading workloads that want this.
> > > 
> > > the newidle_idx=0 thing is because I frequently saw it make funny
> > > balance decisions based on old load numbers, like f_b_g() selecting a
> > > group that didn't even have tasks in anymore.
> > 
> > Well it is just a damping factor on runqueue flucturations. If the
> > group recently had load then the point of the idx is to account
> > for this. On the other hand, if we have other groups that are also
> > above the idx damped average, it would make sense to use them
> > instead. (ie. cull source groups with no pullable tasks).
> 
> Right, thing is, I'm still catching up from being gone, and haven't
> actually read and tought through the whole rate-limiting thing :-(
> 
> If you see a better way to accomplish things, please holler.

Well, not with adding another hack on top of newidle becuase it
is too aggressive because it was turned on where it shouldn't
be :)

Within an LLC we really want to be quite aggressive at moving
tasks around in order to minimise idle time.

*Perhaps* another type of balancing mode which is rate limited.
However...

 
> > > We went without newidle for a while, but then people started complaining
> > > about that kbuild time, and there is a x264 encoder thing that looses
> > > tons of throughput.
> > 
> > So... these were due to what? Other changes in domains balancing?
> > Changes in CFS? Something else? Or were they comparisons versus
> > other operating systems?
> 
> Comparison to Con's latest single-rq spread like there's no cache
> affinity BFS thing.
 
Seems like a bit of a knee jerk reaction here. sched domains balancing
seems to have been _relatively_ good for quite a long time without lots
of changes. And lots of users (distros, apparently google) still haven't
got a handle on CFS performance problems so I would have really rathered
introducing such extra changes far far more slowly.

(ie. wait, until CFS is more sorted and at least gone through some
maturity and deployment in distros).

I can easily make test cases where performance goes up by actually some
orders of magnitude by making the balancing totally aggressive over all
domains. And actually even we have some report of a (closed source)
java app having slowdowns due to this. Thing is, such workloads if they
require such frequent cross-numa-node balancing are maybe not really
scalable anyway.

kbuild -- this is frequent communications, short lived tasks, so it
is a good case for more aggressive balancing at the expense of NUMA
affinity. But this is probably further over to that side than a lot
of other workloads, so if our defaults aren't the *best* for kbuild
(ie. not quite aggressive enough) then I think that is probably a
good sign.

How large was the kbuild improvement? Was O(1) tried as well?

