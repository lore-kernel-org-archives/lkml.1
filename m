Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbXA2TuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbXA2TuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXA2TuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:50:11 -0500
Received: from mail.screens.ru ([213.234.233.54]:52601 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbXA2TuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:50:10 -0500
Date: Mon, 29 Jan 2007 22:49:38 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070129194938.GB233@tv-sign.ru>
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <Pine.LNX.4.64.0701291109310.29254@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701291109310.29254@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Christoph Lameter wrote:
>
> On Mon, 29 Jan 2007, Oleg Nesterov wrote:
> 
> > > > Even if smp_processor_id() was stable during the execution of cache_reap(),
> > > > this work_struct can be moved to another CPU if CPU_DEAD happens. We can't
> > > > avoid this, and this is correct.
> > > 
> > > Uhh.... This may not be correct in terms of how the slab operates.
> > 
> > But this is practically impossible to avoid. We can't delay CPU_DOWN until all
> > workqueues flush their cwq->worklist. This is livelockable, the work can re-queue
> > itself, and new works can be added since the dying CPU is still on cpu_online_map.
> > This means that some pending works will be processed on another CPU.
> 
> But we could delay CPU_DOWN in the handler for the slab until we know that 
> the cache_reaper is no longer running?

Hmm... I don't undestand this. We can delay CPU_DOWN if we cancel cache_reaper
like you did in the previous patch. Did you mean this? If yes - then yes :)

> > > > This means that __get_cpu_var(reap_work) returns a "wrong" struct delayed_work.
> > > > This is absolutely harmless right now, but may be it's better to use
> > > > container_of(unused, struct delayed_work, work).
> 
> There is more where that is coming from. cache_reap determines the current 
> cpu in order to find the correct per cpu cache and also determines the 
> current node. If you move cache_reap to another processor / node then it 
> will just clean that one and not do anything for the processor that you 
> wanted it to run for.

Worse, we can have 2 handlers running in parallel on the same CPU. But this
is fixed by your previous patch, I believe.

>                        If we change processors in the middle of the run
> then it may do some actions on one cpu and some on another....

Yep. For example, next_reap_node() will not be happy if we change CPU in
the middle. But this is _extremely_ unlikely, can only happen on CPU_DOWN,
and cache_reap() should not care about this.

> -static void cache_reap(struct work_struct *unused)
> +static void cache_reap(struct work_struct *w)
>  {
>  	struct kmem_cache *searchp;
>  	struct kmem_list3 *l3;
>  	int node = numa_node_id();
> +	struct delayed_work *work =
> +		container_of(w, struct delayed_work, work);
>
> ...
>
> +	schedule_delayed_work(work, round_jiffies_relative(REAPTIMEOUT_CPUC));

Actually, I was wrong. Yes, this should work, but only with your previous
patch. Otherwise, if the handler runs on the "wrong" CPU (this is not possible
since you added cancel_delayed_work()), we are in fact starting a second reaper
on the same CPU, not good.

Oleg.

