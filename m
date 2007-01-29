Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbXA2T0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbXA2T0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXA2T0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:26:05 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:45024 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752543AbXA2T0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:26:04 -0500
Date: Mon, 29 Jan 2007 11:25:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <20070129182742.GA158@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0701291109310.29254@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Oleg Nesterov wrote:

> > > Even if smp_processor_id() was stable during the execution of cache_reap(),
> > > this work_struct can be moved to another CPU if CPU_DEAD happens. We can't
> > > avoid this, and this is correct.
> > 
> > Uhh.... This may not be correct in terms of how the slab operates.
> 
> But this is practically impossible to avoid. We can't delay CPU_DOWN until all
> workqueues flush their cwq->worklist. This is livelockable, the work can re-queue
> itself, and new works can be added since the dying CPU is still on cpu_online_map.
> This means that some pending works will be processed on another CPU.

But we could delay CPU_DOWN in the handler for the slab until we know that 
the cache_reaper is no longer running?

> > > This means that __get_cpu_var(reap_work) returns a "wrong" struct delayed_work.
> > > This is absolutely harmless right now, but may be it's better to use
> > > container_of(unused, struct delayed_work, work).

There is more where that is coming from. cache_reap determines the current 
cpu in order to find the correct per cpu cache and also determines the 
current node. If you move cache_reap to another processor / node then it 
will just clean that one and not do anything for the processor that you 
wanted it to run for. If we change processors in the middle of the run
then it may do some actions on one cpu and some on another....

Having said that here is the patch that insures that makes cache_reap no 
longer use per_cpu to access the work structure. This may be a cleanup on
its own but it will not address your issues.



Use parameter passed to cache_reap to determine pointer to work structure

Use the pointer passed to cache_reap to determine the work
pointer and consolidate exit paths.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6/mm/slab.c
===================================================================
--- linux-2.6.20-rc6.orig/mm/slab.c	2007-01-29 13:08:05.000000000 -0600
+++ linux-2.6.20-rc6/mm/slab.c	2007-01-29 13:17:01.695680898 -0600
@@ -4021,18 +4021,17 @@ void drain_array(struct kmem_cache *cach
  * If we cannot acquire the cache chain mutex then just give up - we'll try
  * again on the next iteration.
  */
-static void cache_reap(struct work_struct *unused)
+static void cache_reap(struct work_struct *w)
 {
 	struct kmem_cache *searchp;
 	struct kmem_list3 *l3;
 	int node = numa_node_id();
+	struct delayed_work *work =
+		container_of(w, struct delayed_work, work);
 
-	if (!mutex_trylock(&cache_chain_mutex)) {
+	if (!mutex_trylock(&cache_chain_mutex))
 		/* Give up. Setup the next iteration. */
-		schedule_delayed_work(&__get_cpu_var(reap_work),
-				      round_jiffies_relative(REAPTIMEOUT_CPUC));
-		return;
-	}
+		goto out;
 
 	list_for_each_entry(searchp, &cache_chain, next) {
 		check_irq_on();
@@ -4075,9 +4074,9 @@ next:
 	mutex_unlock(&cache_chain_mutex);
 	next_reap_node();
 	refresh_cpu_vm_stats(smp_processor_id());
+out:
 	/* Set up the next iteration */
-	schedule_delayed_work(&__get_cpu_var(reap_work),
-		round_jiffies_relative(REAPTIMEOUT_CPUC));
+	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));
 }
 
 #ifdef CONFIG_PROC_FS
