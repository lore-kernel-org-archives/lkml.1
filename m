Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXD2IPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXD2IPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXD2IPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:15:33 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932929AbXD2IPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:15:30 -0400
Date: Sun, 29 Apr 2007 01:15:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: vmstat: use our own timer events
Message-Id: <20070429011518.259448ba.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 22:09:04 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> vmstat is currently using the cache reaper to periodically bring the
> statistics up to date. The cache reaper does only exists in SLUB
> as a way to provide compatibility with SLAB. This patch removes
> the vmstat calls from the slab allocators and provides its own
> handling.
> 
> The advantage is also that we can use a different frequency for the
> updates. Refreshing vm stats is a pretty fast job so we can run this
> every second and stagger this by only one tick. This will lead to
> some overlap in large systems. F.e a system running at 250 HZ with
> 1024 processors will have 4 vm updates occurring at once.
> 
> However, the vm stats update only accesses per node information.
> It is only necessary to stagger the vm statistics updates per
> processor in each node. Vm counter updates occurring on distant
> nodes will not cause cacheline contention.
> 
> We could implement an alternate approach that runs the first processor
> on each node at the second and then each of the other processor on a
> node on a subsequent tick. That may be useful to keep a large amount
> of the second free of timer activity. Maybe the timer folks will have
> some feedback on this one?

The one-per-second timer interrupt will upset the people who are really
aggressive about power consumption (eg, OLPC).  Perhaps there isn't (yet)
an intersection between those people and SMP.

However a knob to set the frequency would be nice, if it's not too
expensive to implement.  Presumably anyone who cares enough will come along
and add one, but then they have to wait for a long period for that change
to propagate out to their users, which is a bit sad for something which we
already knew about.

Having each CPU touch every zone looks a bit expensive - I'd have thought
that it would be showing up a little on your monster NUMA machines?

> @@ -648,11 +664,21 @@ static int __cpuinit vmstat_cpuup_callba
>  		unsigned long action,
>  		void *hcpu)
>  {
> +	long cpu = (long)hcpu;
> +
>  	switch (action) {
> -	case CPU_UP_PREPARE:
> -	case CPU_UP_PREPARE_FROZEN:
> -	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
> +	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
> +		start_cpu_timer(cpu);
> +		break;
> +	case CPU_DOWN_PREPARE:
> +	case CPU_DOWN_PREPARE_FROZEN:
> +		cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
> +		per_cpu(vmstat_work, cpu).work.func = NULL;
> +	case CPU_DOWN_FAILED:
> +	case CPU_DOWN_FAILED_FROZEN:
> +		start_cpu_timer(cpu);
> +		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		refresh_zone_stat_thresholds();

Oh dear.  Some of these new notifier types are added by a patch which is a
few hundred patches later than slub.  I can park this patch after that one,
but that introduces a risk that later slub patches will also get
disconnected.

Oh well, we'll see how things go.
