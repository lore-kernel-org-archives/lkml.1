Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbXJADnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbXJADnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 23:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXJADnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 23:43:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33352 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbXJADnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 23:43:03 -0400
Date: Sun, 30 Sep 2007 20:42:52 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20070930204252.45e20bb4.pj@sgi.com>
In-Reply-To: <200709301335.00441.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200709300521.03356.nickpiggin@yahoo.com.au>
	<20070930110753.19b03388.pj@sgi.com>
	<200709301335.00441.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> Moreover, sched_load_balance doesn't really sound like a good name
> for asking for a partition. 

Yup - it's not a good name for asking for a partition.

That's because it isn't asking for a partition.

It's asking for load balancing over the CPUs in the cpuset so marked.

> It's more like you're just asking to have better
> load balancing over that set,

Yup - it's asking for load balancing over that set.  That is why it is
called that.  There's no idea here of better or worse load balancing,
that's an internal kernel scheduler subtlety -- it's just a request that
load balancing be done.

That is what is visible to user space: whether or not tasks get moved
from overloaded CPUs to underloaded, though still allowed, CPUs.

This is visible to user space in two ways:
  1) as task movemement, which may or may not be what is desired, and
  2) as kernel CPU cycles spent, because load balancing costs CPU cycles
     that increase more than linearly with the number of CPUs being
     balanced.

The user doesn't give a hoot what a 'sched domain' is.  They care to
manage (1) whether their tasks might move under a load imbalance, and
(2) how many CPU cycles the kernel spends providing this service.

> You would do this by creating partitioning cpusets which carve up the
> root cpuset (basically -- have multiple roots).

You would do this with the current, single rooted cpuset (and now
cgroup) mechanism by having multiple immediate child cpusets of the
root cpuset, which partition the system CPUs.  There is no need to
invent some bastardized multiple root structure.

> You can't (easily) do this now because you have so many tasks in the
> root cpuset that it is impossible to know whether or not you
> actually want to load balance them.

I don't know what proposal you are reacting to here.  Clearly not this
patch that I have proposed, as it is trivially easy to indicate whether
you want to load balance the root cpuset - by setting or clearing the
'sched_load_balance' flag in the root cpuset. 

How could it possibly get any more direct that that?

> Neither approach is really fundamentally more or less powerful than
> the other, but what I object to in yours is adding these flags which
> don't allow the admin to specify what they want, but to specify how they
> want it done.

My approach doesn't do that - perhaps we aren't communicating.

We are in complete agreement that the admin should specify what they
want, and leave it to the kernel to figure out how to do it.

> Rather than require the admin to know the intricate details about
> how and why the scheduler load balancing gets broken, and when they
> might or might not need to use this flag, they can just specify what they
> want to be done, and the kernel can choose the optimal strategy.

Excellent -- I'm glad you like my approach </sarcasm>

> No, I'm insisting that *no* single administrative point of control
> determines the sched domains. Not directly. The kernel should.
> cpusets API should be rich enough that the kernel can derive tihs
> information from what the admin has intended.

We are in complete agreement in insisting on this.

In short:

    The kernel schedulers dynamic sched domains are --not-- the service
    being provided to the user.  "Sched domains" are just the kernel
    internal mechanism.

    The service being provided is dynamic load balancing of tasks from
    overloaded CPUs to underloaded CPUs.

    Some users will want to disable load balancing on some cpusets, because
    either:
      (1) it's too expensive to balance really large cpusets unless really
	  needed, or
      (2) real time users don't want to waste the CPU cycles doing
	  balancing even on small cpusets.

If you think I repeated everything two or three times above ... good,
you're right - I did.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
