Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYKKRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYKKRSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKKRSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:18:36 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:52538 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYKKRSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:18:35 -0500
Date: Tue, 11 Nov 2008 22:45:55 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: vatsa@in.ibm.com, Gregory Haskins <gregory.haskins@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
Message-ID: <20081111171555.GU4646@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>, vatsa@in.ibm.com,
	Gregory Haskins <gregory.haskins@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gautham R Shenoy <ego@in.ibm.com>, Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com> <20081110183326.562.37718.stgit@drishya.in.ibm.com> <1226411019.7685.1767.camel@twins> <491991BE.9080405@gmail.com> <20081111152126.GF3593@linux.vnet.ibm.com> <1226417174.7685.1898.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1226417174.7685.1898.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-11-11 16:26:14]:

> On Tue, 2008-11-11 at 20:51 +0530, Srivatsa Vaddagiri wrote:
> > On Tue, Nov 11, 2008 at 09:07:58AM -0500, Gregory Haskins wrote:
> > > > Would it make sense to place the preferred_wakeup_cpu stuff in the
> > > > root_domain structure we already have?
> > > >   
> > > 
> > > From the description, this is exactly what the root-domains were created
> > > to solve.
> > > 
> > > Vaidyanathan,  just declare your object in "struct root_domain" and
> > > initialize it in init_rootdomain() in kernel/sched.c, and then access it
> > > via rq->rd to take advantage of this infrastructure.  It will
> > > automatically follow any partitioning that happens to be configured.
> > 
> > If I understand correctly, we may want to have more than one preferred
> > cpu in a given sched domain, taking into account node topology i.e if a
> > given sched domain encompasses two nodes, then we may like to designate
> > 2 preferred wakeup_cpu's, one per node. If that is the case, then
> > root_domain may not be of use here?
> 
> Agreed, in which case this sched_domain_attr stuff might work out better
> - but I'm not sure I fully get that.. will stare at that a bit more.

The current code that I posted assumes one preferred_wakeup_cpu per
partitioned domain.  Moving the variable to root_domain is a good idea
for this implementation.

In future when we need one preferred_wakeup_cpu per node per
partitioned domain, we will need a array for each partitioned domain.
Having the array in root_domain is better than having it in dattr.

Depending upon experimental results, we may choose to have only one
preferred_wakeup_cpu per partitioned domain.  When the system
utilisation is quite low, it is better to move all movable tasks from
each node to a selected node (0).  This will freeup all CPUs in other
nodes.  Just that we need to consider cache hotness and cross-node
memory access more carefully before crossing a node boundary for
consolidation.

--Vaidy
 
