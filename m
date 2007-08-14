Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXHNVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXHNVCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXHNVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:02:14 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:43961 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbXHNVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:02:13 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, clameter@sgi.com,
       bob.picco@hp.com, nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       mel@skynet.ie, akpm@linux-foundation.org,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <20070814192306.GB32553@vino.hallyn.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	 <20070813201215.GA16908@vino.hallyn.com>
	 <1187103831.6281.24.camel@localhost>
	 <20070814180339.GA32553@vino.hallyn.com>
	 <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 14 Aug 2007 17:01:15 -0400
Message-Id: <1187125275.6281.122.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 14:23 -0500, Serge E. Hallyn wrote:
> Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > On Tue, 2007-08-14 at 13:03 -0500, Serge E. Hallyn wrote:
> > > Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > > > On Mon, 2007-08-13 at 15:12 -0500, Serge E. Hallyn wrote:
> > > > > Quoting Dhaval Giani (dhaval@linux.vnet.ibm.com):
> > > > > > Hi,
> > > > > > 
> > > > > > On mounting cpusets using containers, I have been hitting the following
> > > > > > bug.
> > > > > > 
> > > > > > 
> > > > > > -----------[ cut here ]------------
> > > > > > kernel BUG at kernel/cpuset.c:331!
> > > > <snip>
> > > > > > CONFIG_HIGHMEM=y
> > > > > > CONFIG_X86_PAE=y
> > > > > > # CONFIG_NUMA is not set
> > > > > > CONFIG_ARCH_POPULATES_NODE_MAP=y
> > > > > > CONFIG_SELECT_MEMORY_MODEL=y
> > > > > > CONFIG_FLATMEM_MANUAL=y
> > > > > > # CONFIG_DISCONTIGMEM_MANUAL is not set
> > > > > > # CONFIG_SPARSEMEM_MANUAL is not set
> > > > > > CONFIG_FLATMEM=y
> > > > > > CONFIG_FLAT_NODE_MEM_MAP=y
> > > > > > # CONFIG_SPARSEMEM_STATIC is not set
> > > > > > CONFIG_SPLIT_PTLOCK_CPUS=4
> > > > > > CONFIG_RESOURCES_64BIT=y
> > > > > > CONFIG_ZONE_DMA_FLAG=1
> > > > <snip>
> > > > > 
> > > > > Yeah, I'm seeing the same thing.  Oddly, my node_states[N_NORMAL_MEMORY]
> > > > > and node_states[N_HIGH_MEMORY] are empty, while node_states[N_ONLINE]
> > > > > contains my single cpu (on i386 kvm image).
> > > > > 
> > > > > -serge
> > > > 
> > > > Yes, you'll definitely hit that BUG if the N_HIGH_MEMORY mask is empty.
> > > > So far, I can't see how this could be, tho'.  __build_all_zonelists()
> > > > should be called for non-NUMA as well as NUMA.  It iterates over "all
> > > 
> > > Yup, and it is, and some debug statements insist that
> > > node_set_state(nid, N_HIGH_MEMORY) is being called for cpu 0,
> > > and the state is in fact being correctly set.
> > > 
> > > So it must get cleared later...
> > 
> > OK.  That helps.  I'll see what I can find...
> 
> Well apparently I lied?  I don't think it's getting cleared in node_states.
> I'm doing:
> 
> static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
> {
>         int nid=0;
>         printk(KERN_NOTICE "%s: at top, node %d is %d\n",
>                 __FUNCTION__, nid, node_state(nid, N_HIGH_MEMORY));
>         while (cs && !nodes_intersects(cs->mems_allowed,
>                                         node_states[N_HIGH_MEMORY])) {
>                 printk(KERN_NOTICE "%s: in loop\n", __FUNCTION__);
>                 cs = cs->parent;
>         }
>         if (cs) {
>                 printk(KERN_NOTICE "%s: cs was true\n", __FUNCTION__);
>                 nodes_and(*pmask, cs->mems_allowed,
>                                         node_states[N_HIGH_MEMORY]);
>         }
>         else
>         {
>                 printk(KERN_NOTICE "%s: cs was false\n", __FUNCTION__);
>                 *pmask = node_states[N_HIGH_MEMORY];
>         }
>         printk(KERN_NOTICE "%s: at bottom, node %d is %d\n",
>                 __FUNCTION__, nid, node_state(nid, N_HIGH_MEMORY));
>         printk(KERN_NOTICE "%s: at bottom, in pmask node %d is %d\n",
>                 __FUNCTION__, nid, node_isset(nid, *pmask));
>         BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
> }
> 
> and getting:
> 
> guarantee_online_mems: in loop
> guarantee_online_mems: cs was false

The above message indicates that you went off the top of the cpuset
hierarchy w/o finding a non-empty intersection with
node_states[N_HIGH_MEMORY].  The top cpuset should include all nodes
with memory--and there has to be at least one, right?.  See
cpuset_init_smp().  That would indicate that node_states[N_HIGH_MEMORY]
was empty when cpuset_init_smp() was called or when you entered
guarantee_online_mems().  One can't tell because you didn't include the
"at top" message [are you seeing it?] and node_state() always returns
true for node zero on non-NUMA platforms [!(MAX_NUMANODES > 1)].

If you're still investigating, I'd suggest a printk in
cpuset_init_smp().  And use node_isset() directly, instead of
node_state.  Or you can really look beneath the covers of nodemask_t and
print 'node_states[N_HIGH_MEMORY].bits[0]' using a hex format.  

I should note that this works on my ia64 NUMA platform and other folks'
x86_64 platforms.  So, it's looking like an i386 specific issue.

> guarantee_online_mems: at bottom, node 0 is 1
> guarantee_online_mems: at bottom, in pmask node 0 is 0
> 
> 
> So I'm guess that
> 	*pmask = node_states[N_HIGH_MEMORY];
> isn't doing what it was intended to do?  

Should just do the structure assignment, right?  That's used pretty
heavily throughout the mem policy and cpuset sources.  

Hmmm, including to initialize the top cpuset's mems_allowed.  If that
assignment failed, as well, it might indicate that the compiler is
having difficulty handling the indexed array of structs?  

Try the patch below to see if the changes the behavior.  I didn't change
all of the struct assignments.  Just the ones involving the indexed
node_state array element.


> That or I've got node_state()
> wrong...

Uh, no.  you're using it correctly.  But as I mentioned above, for
MAX_NUMANODES <= 1, node_state() just does "return node == 0;"  Better
to use node_isset() directly for this case.

Lee

===========================================================
PATCH -- use memcpy() for node_state[] assignment

to see if this fixes the i386 cpusets empty mems_allowed 
problem.

N.B., compile-tested only on ia64.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 kernel/cpuset.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: Linux/kernel/cpuset.c
===================================================================
--- Linux.orig/kernel/cpuset.c	2007-08-14 16:28:27.000000000 -0400
+++ Linux/kernel/cpuset.c	2007-08-14 16:37:27.000000000 -0400
@@ -327,7 +327,7 @@ static void guarantee_online_mems(const 
 		nodes_and(*pmask, cs->mems_allowed,
 					node_states[N_HIGH_MEMORY]);
 	else
-		*pmask = node_states[N_HIGH_MEMORY];
+		memcpy(pmask, &node_states[N_HIGH_MEMORY], sizeof(*pmask));
 	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
 }
 
@@ -1396,7 +1396,8 @@ static void common_cpu_mem_hotplug_unplu
 
 	guarantee_online_cpus_mems_in_subtree(&top_cpuset);
 	top_cpuset.cpus_allowed = cpu_online_map;
-	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	memcpy(&top_cpuset.mems_allowed, &node_states[N_HIGH_MEMORY],
+			sizeof(top_cpuset.mems_allowed));
 
 	mutex_unlock(&callback_mutex);
 	container_unlock();
@@ -1445,7 +1446,8 @@ void cpuset_track_online_nodes(void)
 void __init cpuset_init_smp(void)
 {
 	top_cpuset.cpus_allowed = cpu_online_map;
-	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	memcpy(&top_cpuset.mems_allowed, &node_states[N_HIGH_MEMORY],
+			sizeof(top_cpuset.mems_allowed));
 
 	hotcpu_notifier(cpuset_handle_cpuhp, 0);
 }


