Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXA2WOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXA2WOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbXA2WOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:14:33 -0500
Received: from mail.screens.ru ([213.234.233.54]:56194 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbXA2WOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:14:32 -0500
Date: Tue, 30 Jan 2007 01:14:08 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070129221408.GA269@tv-sign.ru>
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <Pine.LNX.4.64.0701291109310.29254@schroedinger.engr.sgi.com> <20070129194938.GB233@tv-sign.ru> <Pine.LNX.4.64.0701291224340.32740@schroedinger.engr.sgi.com> <20070129210550.GA247@tv-sign.ru> <Pine.LNX.4.64.0701291346110.548@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701291346110.548@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Christoph Lameter wrote:
>
> On Tue, 30 Jan 2007, Oleg Nesterov wrote:
> 
> > Now we have 2 additional events, CPU_LOCK_ACQUIRE/CPU_LOCK_RELEASE,
> > so cpuup_callback() can use them to lock/unlock cache_chain_mutex,
> > but this is not related.
> 
> Then we wont need to do the mutex_lock/unlock in CPU_DOWN_XX 
> anymore, right? Which brings us to this form of the patch:

Yes, if CPU_LOCK_ACQUIRE takes cache_chain_mutex, we don't need to do so
on CPU_DOWN_PREPARE. I didn't know cpuup_callback() was already converted,
sorry for the confusion!

Note: with the patch below we are doing cancel_rearming_delayed_work()
under cache_chain_mutex. This is ok since cache_reap() does mutex_trylock(),
so deadlock is not possible. However, this means that mutex_trylock() becomes
mandatory for cache_reap(), probably a little comment will be good.

> Shutdown cache_reaper when cpu goes down
> 
> Shutdown the cache_reaper in slab.c if the cpu is brought down
> and set the cache_reap.func to NULL. Otherwise hotplug shuts
> down the reaper for good.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.20-rc6-mm2/mm/slab.c
> ===================================================================
> --- linux-2.6.20-rc6-mm2.orig/mm/slab.c	2007-01-29 14:27:34.199229828 -0600
> +++ linux-2.6.20-rc6-mm2/mm/slab.c	2007-01-29 15:47:18.293962726 -0600
> @@ -1271,6 +1271,14 @@ static int __cpuinit cpuup_callback(stru
>  		start_cpu_timer(cpu);
>  		break;
>  #ifdef CONFIG_HOTPLUG_CPU
> +  	case CPU_DOWN_PREPARE:
> +		/* Shutdown cache reaper */
> +		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
> +		per_cpu(reap_work, cpu).work.func = NULL;
> +  		break;
> +  	case CPU_DOWN_FAILED:
> +		start_cpu_timer(cpu);
> +  		break;
>  	case CPU_DEAD:
>  		/*
>  		 * Even if all the cpus of a node are down, we don't free the

