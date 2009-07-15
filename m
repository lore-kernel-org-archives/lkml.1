Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbZGOMGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbZGOMGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZGOMGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:06:53 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37909 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754145AbZGOMGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:06:52 -0400
Date: Wed, 15 Jul 2009 14:08:03 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC][PATCH 0/8] Use EDF to throttle RT task groups
Message-ID: <20090715120802.GD2659@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis> <1247135773.9777.357.camel@twins> <20090709135117.GR14563@gandalf.sssup.it> <1247644212.7500.202.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247644212.7500.202.camel@twins>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed, Jul 15, 2009 09:50:12AM +0200
>
> On Thu, 2009-07-09 at 15:51 +0200, Fabio Checconi wrote:
> 
> > I was thinking about doing things gradually: first extend throttling
> > to handle generic periods, then extend the push-pull logic (I think you
> > are referring to it with load-balancing) to fully support it, and then
> > think about global EDF.  I think it would be difficult to do all the
> > things at one time.
> 
> Agreed.
> 
> > About minimal concurrency group scheduling, I am not sure of how we
> > would handle CPUs hot insertion/extraction, or how the allocation would
> > be done efficiently (avoiding bin-packing issues) online inside the kernel.
> 
> Right, since the current interface specifies bandwidth in a single-cpu
> normalized fashion, adding/removing cpus will only affect the total
> bandwidth available, but should not affect the bandwidth calculations.
> 
> So it should not break anything, but it sure might surprise, then again,
> hotplug is an explicit action on behalf of the admin, so he pretty much
> gets what he asked for :-)
> 

Even the proper assignment of runtimes and periods is in the hands of who
runs the system, so the effectiveness of admission control already depends 
on the userspace.


> I might have to re-read that mim-concurrency G-EDF paper again, but I
> failed to spot the bin-packing issue.
> 

In the paper you cited, the Conclusion section lists the support for
dynamic systems and for joining/leaving of tasks as a future work; I
think that handling (de-)fragmentation and allocation of cpu bandwidth
when tasks and groups are created/destroyed might be quite complex from
within the kernel.

I'd prefer to have the mechanims enforcing the bandwidth allocation
inside the kernel, and, eventually, an interface allowing the userspace
to specify nontrivial allocation schemes, like the one in the paper.


> > To adapt the current load-balancer to the choices of the deadline-based
> > scheduler I was thinking about using a cpupri-like structure per task_group,
> > but now I'm not able to estimate the resulting overhead...
> 
> Right, per task_group sounds about the right level for the FIFO
> balancer. It gets a little more complicated due to having a dynamic
> number of vcpus being served at any one time though.
> 
> This will also lead to extra task migrations, but sure, whatever works
> first, then make it better.
> 

This will also be interesting to evaluate the cost of other hierarchical
global schedulers, since implementing them with partitioned queues will
require similar techniques to migrate tasks...


> > Do you think that this gradual approach makes sense?
> 
> Yeah it does ;-)
