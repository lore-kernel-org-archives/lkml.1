Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZKDADv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZKDADv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZKDADu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:03:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35778 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZKDADt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:03:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 09:01:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 1/6] oom-killer: updates for classification of
 OOM
Message-Id: <20091104090116.fd319d1d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911031150500.11821@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091102162412.107ff8ac.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911031150500.11821@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 12:18:40 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Rewrite oom constarint to be up to date.
> > 
> > (1). Now, at badness calculation, oom_constraint and other information
> >    (which is available easily) are ignore. Pass them.
> > 
> > (2)Adds more classes of oom constraint as _MEMCG and _LOWMEM.
> >    This is just a change for interface and doesn't add new logic, at this stage.
> > 
> > (3) Pass nodemask to oom_kill. Now alloc_pages() are totally rewritten and
> >   it uses nodemask as its argument. By this, mempolicy doesn't have its own
> >   private zonelist. So, Passing nodemask to out_of_memory() is necessary.
> >   But, pagefault_out_of_memory() doesn't have enough information. We should
> >   visit this again, later.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  drivers/char/sysrq.c |    2 -
> >  fs/proc/base.c       |    4 +-
> >  include/linux/oom.h  |    8 +++-
> >  mm/oom_kill.c        |  101 +++++++++++++++++++++++++++++++++++++++------------
> >  mm/page_alloc.c      |    2 -
> >  5 files changed, 88 insertions(+), 29 deletions(-)
> > 
> > Index: mmotm-2.6.32-Nov2/include/linux/oom.h
> > ===================================================================
> > --- mmotm-2.6.32-Nov2.orig/include/linux/oom.h
> > +++ mmotm-2.6.32-Nov2/include/linux/oom.h
> > @@ -10,23 +10,27 @@
> >  #ifdef __KERNEL__
> >  
> >  #include <linux/types.h>
> > +#include <linux/nodemask.h>
> >  
> >  struct zonelist;
> >  struct notifier_block;
> >  
> >  /*
> > - * Types of limitations to the nodes from which allocations may occur
> > + * Types of limitations to zones from which allocations may occur
> >   */
> >  enum oom_constraint {
> >  	CONSTRAINT_NONE,
> > +	CONSTRAINT_LOWMEM,
> >  	CONSTRAINT_CPUSET,
> >  	CONSTRAINT_MEMORY_POLICY,
> > +	CONSTRAINT_MEMCG
> >  };
> >  
> >  extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
> >  extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
> >  
> > -extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
> > +extern void out_of_memory(struct zonelist *zonelist,
> > +		gfp_t gfp_mask, int order, nodemask_t *mask);
> >  extern int register_oom_notifier(struct notifier_block *nb);
> >  extern int unregister_oom_notifier(struct notifier_block *nb);
> >  
> > Index: mmotm-2.6.32-Nov2/mm/oom_kill.c
> > ===================================================================
> > --- mmotm-2.6.32-Nov2.orig/mm/oom_kill.c
> > +++ mmotm-2.6.32-Nov2/mm/oom_kill.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/notifier.h>
> >  #include <linux/memcontrol.h>
> >  #include <linux/security.h>
> > +#include <linux/mempolicy.h>
> >  
> >  int sysctl_panic_on_oom;
> >  int sysctl_oom_kill_allocating_task;
> > @@ -55,6 +56,8 @@ static int has_intersects_mems_allowed(s
> >   * badness - calculate a numeric value for how bad this task has been
> >   * @p: task struct of which task we should calculate
> >   * @uptime: current uptime in seconds
> > + * @constraint: type of oom_kill region
> > + * @mem: set if called by memory cgroup
> >   *
> >   * The formula used is relatively simple and documented inline in the
> >   * function. The main rationale is that we want to select a good task
> > @@ -70,7 +73,9 @@ static int has_intersects_mems_allowed(s
> >   *    of least surprise ... (be careful when you change it)
> >   */
> >  
> > -unsigned long badness(struct task_struct *p, unsigned long uptime)
> > +static unsigned long __badness(struct task_struct *p,
> > +		      unsigned long uptime, enum oom_constraint constraint,
> > +		      struct mem_cgroup *mem)
> >  {
> >  	unsigned long points, cpu_time, run_time;
> >  	struct mm_struct *mm;
> > @@ -193,30 +198,68 @@ unsigned long badness(struct task_struct
> >  	return points;
> >  }
> >  
> > +/* for /proc */
> > +unsigned long global_badness(struct task_struct *p, unsigned long uptime)
> > +{
> > +	return __badness(p, uptime, CONSTRAINT_NONE, NULL);
> > +}
> 
> I don't understand why this is necessary, CONSTRAINT_NONE should be 
> available to proc_oom_score() via linux/oom.h.  It would probably be 
> better to not rename badness() and use it directly.
> 
> > +
> > +
> >  /*
> >   * Determine the type of allocation constraint.
> >   */
> > -static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> > -						    gfp_t gfp_mask)
> > -{
> > +
> >  #ifdef CONFIG_NUMA
> > +static inline enum oom_constraint guess_oom_context(struct zonelist *zonelist,
> > +		gfp_t gfp_mask, nodemask_t *nodemask)
> 
> Why is this renamed from constrained_alloc()?  If the new code is really a 
> guess, we probably shouldn't be altering the oom killing behavior to kill 
> innocent tasks if it's wrong.
> 
No reasons. This just comes from my modification history.
I'll revert this part.


> > +{
> >  	struct zone *zone;
> >  	struct zoneref *z;
> >  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> > -	nodemask_t nodes = node_states[N_HIGH_MEMORY];
> > +	enum oom_constraint ret = CONSTRAINT_NONE;
> >  
> > -	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
> > -		if (cpuset_zone_allowed_softwall(zone, gfp_mask))
> > -			node_clear(zone_to_nid(zone), nodes);
> > -		else
> > +	/*
> > +	 * In numa environ, almost all allocation will be against NORMAL zone.
> > +	 * But some small area, ex)GFP_DMA for ia64 or GFP_DMA32 for x86-64
> > +	 * can cause OOM. We can use policy_zone for checking lowmem.
> > +	 */
> > +	if (high_zoneidx < policy_zone)
> > +		return CONSTRAINT_LOWMEM;
> > +	/*
> > +	 * Now, only mempolicy specifies nodemask. But if nodemask
> > +	 * covers all nodes, this oom is global oom.
> > +	 */
> > +	if (nodemask && !nodes_equal(node_states[N_HIGH_MEMORY], *nodemask))
> > +		ret = CONSTRAINT_MEMORY_POLICY;
> > +	/*
> > + 	 * If not __GFP_THISNODE, zonelist containes all nodes. And if
> > + 	 * zonelist contains a zone which isn't allowed under cpuset, we assume
> > + 	 * this allocation failure is caused by cpuset's constraint.
> > + 	 * Note: all nodes are scanned if nodemask=NULL.
> > + 	 */
> > +	for_each_zone_zonelist_nodemask(zone,
> > +			z, zonelist, high_zoneidx, nodemask) {
> > +		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
> >  			return CONSTRAINT_CPUSET;
> > +	}
> 
> This could probably be written as
> 
> 	int nid;
> 	if (nodemask)
> 		for_each_node_mask(nid, *nodemask)
> 			if (!__cpuset_node_allowed_softwall(nid, gfp_mask))
> 				return CONSTRAINT_CPUSET;
> 
> and then you don't need the struct zoneref or struct zone.

IIUC, typical allocation under cpuset is nodemask=NULL.
We'll have to scan zonelist.

The cpuset doesn't use nodemask at calling alloc_pages() because of its
softwall and hardwall feature and its nature of hierarchy.


Thanks,
-Kame




