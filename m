Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbXA2S2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbXA2S2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXA2S2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:28:09 -0500
Received: from mail.screens.ru ([213.234.233.54]:50149 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbXA2S2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:28:08 -0500
Date: Mon, 29 Jan 2007 21:27:42 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070129182742.GA158@tv-sign.ru>
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Christoph Lameter wrote:
>
> On Mon, 29 Jan 2007, Oleg Nesterov wrote:
> 
> > > > This is wrong. Suppose we have a CPU_UP,CPU_DOWN,CPU_UP sequence. The last
> > > > CPU_UP will not restart a per-cpu "cache_reap timer".
> > > 
> > > Why?
> > 
> > Because the last CPU_UP calls start_cpu_timer(), but since ->work.func != NULL
> > we don't do schedule_delayed_work_on(). I think (if I am right) this is a slab's
> > bug.
> 
> The CPU_DOWN would need to set work.func == NULL for this to work. But 
> then the slab does not shut down the work queues for the processor. Isnt 
> this another issue with workqueues?

I think no, please see below. Actually, this is more related to timers for
this particular case.

>                                      The slab would need a notification 
> that the workqueue for a processor was shutdown in order to set work.func 
> = NULL.

The slab has a notification: CPU_XXX events. It should cancel a pending per
cpu "reap_work timer".

> > I think cache_reap() is not alone, and this is not its fault.
> > 
> > But please note another minor problem,
> > 
> > 	void cache_reap(struct work_struct *unused)
> > 	{
> > 		...
> > 
> > 		schedule_delayed_work(&__get_cpu_var(reap_work), ...);
> > 	}
> > 
> > Even if smp_processor_id() was stable during the execution of cache_reap(),
> > this work_struct can be moved to another CPU if CPU_DEAD happens. We can't
> > avoid this, and this is correct.
> 
> Uhh.... This may not be correct in terms of how the slab operates.

But this is practically impossible to avoid. We can't delay CPU_DOWN until all
workqueues flush their cwq->worklist. This is livelockable, the work can re-queue
itself, and new works can be added since the dying CPU is still on cpu_online_map.
This means that some pending works will be processed on another CPU.

delayed_work is even worse, the timer can migrate as well.

The first problem (smp_processor_id() is not stable) could be solved if we
use freezer or with the help of not-yet-implemented scalable lock_cpu_hotplug.

> > This means that __get_cpu_var(reap_work) returns a "wrong" struct delayed_work.
> > This is absolutely harmless right now, but may be it's better to use
> > container_of(unused, struct delayed_work, work).
> 
> Well seems that we have a set of unresolved issues with workqueues and cpu 
> hotplug.

Yes.

Oleg.


