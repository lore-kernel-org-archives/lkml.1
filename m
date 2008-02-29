Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbYB2VPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbYB2VPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYB2VO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:14:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYB2VO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:14:57 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080229145516.4d96aeaa.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy>  <20080229145516.4d96aeaa.pj@sgi.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 22:14:34 +0100
Message-Id: <1204319674.6243.145.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 14:55 -0600, Paul Jackson wrote:
> Like Ingo, I like the approach.
> 
> But I am concerned it won't work, as stated.
> 
> Unfortunately, my blithering ignorance of how one might want to
> distribute irq's across a system is making it difficult for me
> to say for sure if this works or not.
> 
> The thing about /dev/cpuset that I am afraid will get in the way
> with this use of cpusets to place irqs is that we can really only
> have a single purpose hierarchy below /dev/cpuset.
> 
> For example, lets say we have:
> 
>     /dev/cpuset
>         boot
> 	big_special_app
> 	a_few_isolated_rt_nodes
> 	batchscheduler
>             batch job 1
> 	    batch job 2
> 	    ...

I might just be new-fangled, but I have a /cgroup mount.
but I guess that's just different mount-point of cgroup, right?

> I guess, with your "cpuset: cpuset irq affinities" patch, we'd start
> off with /dev/cpuset/irqs listing the irqs available, and we could
> reasonably decide to move any or all irqs to /dev/cpuset/boot/irqs,
> by writing the numbers of those irqs to that file, one irq number
> per write(2) system call (as is the cpuset convention.)

Right.

> Do these irqs have any special hardware affinity?  Or are they
> just consumers of CPU cycles that can be jammed onto whatever CPU(s)
> we're willing to let be interrupted?

Depends a bit, the genirq layer seems to allow for irqs that can't be
freely placed. But most of them can be given a free mask - /me looks @
tglx/ingo.

> If for reason of desired hardware affinity, or perhaps for some other
> reason that I'm not aware of, we wanted to have the combined CPUs in
> both the 'boot' and 'big_special_app' handle some irq, then we'd be
> screwed.  We can't easily define, using the cpuset interface and its
> conventions, a distinct cpuset overlapping boot and big_special_app,
> to hold that irq.  Any such combining cpuset would have to be the
> common parent of both the combined cpusets, an annoying intrusion on
> the expected hierarchy.
> 
> If the actual set of CPUs we wanted to handle a particular irq wasn't
> even the union of any pre-existing set of cpusets, then we'd be even
> more screwed, unable even to force the issue by imposing additional
> intermediate combined cpusets to meet the need.

I see the issue. We don't support mv on cgroups, right? To easily create
common parents...

> If there is any potential for this to be a problem, then we should
> examine the possibility of making irqs their own cgroup, rather than
> piggy backing them on cpusets (which are now just one instance of a
> cgroup module.)

Hmm, but that would then be another controller based on cpus. Might be a
tad confusing. Might be needed. I'll ponder..

> Could you educate me a little, Peter, on what these irqs are and on
> the sorts of ways people might want to place them across CPUs?

I'm not sure I know what you're asking. IRQ are hardware notifiers and
do all kinds of things depending on the hardware. Network cards
typically use them to notify the CPU of incoming packets. Video cards
can do vsync notifiers, empty dma buffers, whatnot.

> > +	if (s->len > 0)
> > +		s->len += scnprintf(s->buf + s->len, s->buflen - s->len, " ");
> 
> The other 'vector' type cpuset file, "tasks", uses a newline '\n'
> field terminator, not a space ' ' separator.  Would '\n' work here,
> or is ' ' just too much the expected irq separator in such ascii lists?
> My preference is toward using the exact same vector syntax in each
> place, so that once someone has code that handles one, they can
> repurpose that code for another with minimum breakage.

I'm fine with whatever, I saw a ',' in the bitmap stuff, not really sure
how that ended up being a ' ' in the patch I send out... :-)

