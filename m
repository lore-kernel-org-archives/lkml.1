Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXHOQZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXHOQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761600AbXHOQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:25:06 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:44915 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761413AbXHOQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:25:00 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, bob.picco@hp.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie,
       akpm@linux-foundation.org, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <20070815143125.GA11582@vino.hallyn.com>
References: <20070813201215.GA16908@vino.hallyn.com>
	 <1187103831.6281.24.camel@localhost>
	 <20070814180339.GA32553@vino.hallyn.com>
	 <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
	 <20070814204951.GA2065@vino.hallyn.com>
	 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	 <1187127685.6281.139.camel@localhost>
	 <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	 <1187185392.5422.13.camel@localhost>
	 <20070815143125.GA11582@vino.hallyn.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 15 Aug 2007 12:23:47 -0400
Message-Id: <1187195028.5422.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 09:31 -0500, Serge E. Hallyn wrote:
> Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > On Tue, 2007-08-14 at 14:56 -0700, Christoph Lameter wrote:
> > > On Tue, 14 Aug 2007, Lee Schermerhorn wrote:
> > > 
> > > > > Ok then you did not have a NUMA system configured. So its okay for the 
> > > > > dummies to ignore the stuff. CONFIG_NODES_SHIFT is a constant and does not 
> > > > > change. The first bit is always set.
> > > > 
> > > > The first bit [node 0] is only set for the N_ONLINE [and N_POSSIBLE]
> > > > mask.  We could add the static init for the other masks, but since
> > > > non-numa platforms are going through the __build_all_zonelists, they
> > > > might as well set the MEMORY bits explicitly.  Or, maybe you'll
> > > > disagree ;-).
> > > 
> > > The bitmaps can be completely ignored if !NUMA.
> > > 
> > > In the non NUMA case we define
> > > 
> > > static inline int node_state(int node, enum node_states state)
> > > {
> > >         return node == 0;
> > > }
> > > 
> > > So its always true for node 0. The "bit" is set.
> > 
> > The issue is with the N_*_MEMORY masks.  They don't get initialized
> > properly because node_set_state() is a no-op if !NUMA.  So, where we
> > look for intersections with or where we AND with the N_*_MEMORY masks we
> > get the empty set.
> > 
> > > 
> > > We are trying to get cpusets to work with !NUMA?

Sounds reasonable.  

> > 
> > 
> > Well, yes.  In Serge's case, he's trying to use cpusets with !NUMA.
> > He'll have to comment on the reasons for that.  Looking at all of the
> 
> So I can lock a container to a cpu on a non-numa machine.
> 
> > #ifdefs and init/Kconfig, CPUSET does not depend on NUMA--only SMP and
> > CONTAINERS [altho' methinks CPUSET should select CONTAINERS rather than
> > depend on it...].  So, you can use cpusets to partition of cpus in
> > non-NUMA configs.
> > 
> > In the more general case, tho', I'm looking at all uses of the
> > node_online_map and for_each_online_node, for instances where they
> > should be replaced with one of the *_MEMORY masks.  IMO, generic code
> > that is compiled independent of any CONFIG option, like NUMA,  should
> > just work, independent of the config.  Currently, as Serge has shown,
> > this is not the case.  So, I think we should fix the *_MEMORY maps to be
> > correctly populated in both the NUMA and !NUMA cases.  A couple of
> > options:
> > 
> > 1) just use node_set() when populating the masks,
> > 
> > 2) initialize all masks to include at least cpu/node 0 in the !NUMA
> > case.
> > 
> > Serge chose #1 to fix his problem.  I followed his lead to fix the other
> > 2 places where node_set_state() was being used to initialize the NORMAL
> > memory node mask and the CPU node mask.  This will add a few unnecessary
> > instructions to !NUMA configs, so we could change to #2.
> > 
> > Thoughts?
> 
> Paul, is the mems stuff in cpusets only really useful for NUMA cases?
> (I think it is... but am not sure)  If so I suppose one alternative
> could be to just disable that when !NUMA.  But disabling cpusets when
> !NUMA is completely wrong.
> 
> I personally would think that 1) is still the best option.  Otherwise
> the action
> 
> 	echo $SOME_CPU > /cpusets/set1/cpu
> 	echo $SOME_CPU > /cpusets/set1/mems
> 
> works on a numa machine, and is wrong on a non-numa machine.  With
> option 1, the second part doesn't actually restrict the memory, but
> at least /cpusets/set1/mems exists and $SOME_CPU doesn't have to be 0 to
> be valid.

Well, you really shouldn't be writing cpu ids to the cpuset mems file.
Rather, it takes node ids.  And on !NUMA configs, only node 0 exists.

Can you actually write a !0 cpuid to the mems file with the current
option #1 patch [that uses node_set() to populate the node_states[]]?
It should allow something like:

	echo 0,1<and maybe others> >/cpusets/set1/mems

As long as one of the specified node ids has memory, it will silently
ignore any that don't.

If you're up for it, you could try the following patch to statically
initialize the node state masks, in place of the "option 1" patch.  Be
aware, tho', that I've only tested on my ia64 NUMA platform.  I did
compile it [page_alloc.c] without error under allnoconfig.

Lee

-----------------
PATCH	Initialize N_*_MEMORY and N_CPU masks for non-NUMA config

Against:  2.6.23-rc2-mm2

Statically initialize the N_*_MEMORY and N_CPU node state masks
for !NUMA configurations.  This static initialization is required
because the node_set_state() function becomes a no-op for !NUMA.
Other generic code assumes that these masks are set correctly.

Note that in NUMA configurations, these masks will be populated
correctly, so don't bother with static initialization.  No sense
in making assumptions that could be broken down the road, resulting
in extra work for someone to debug.  Unlikely, perhaps, but who
needs the aggravation...

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: Linux/mm/page_alloc.c
===================================================================
--- Linux.orig/mm/page_alloc.c	2007-08-15 10:01:23.000000000 -0400
+++ Linux/mm/page_alloc.c	2007-08-15 10:05:41.000000000 -0400
@@ -52,7 +52,14 @@
  */
 nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_POSSIBLE] = NODE_MASK_ALL,
-	[N_ONLINE] = { { [0] = 1UL } }
+	[N_ONLINE] = { { [0] = 1UL } },
+#ifndef CONFIG_NUMA
+	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
+#ifdef CONFIG_HIGHMEM
+	[N_HIGH_MEMORY] = { { [0] = 1UL } },
+#endif
+	[N_CPU] = { { [0] = 1UL } },
+#endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
 


