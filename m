Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXA2TaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXA2TaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 14:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXA2TaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 14:30:24 -0500
Received: from mail.screens.ru ([213.234.233.54]:34348 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXA2TaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 14:30:23 -0500
Date: Mon, 29 Jan 2007 22:29:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070129192957.GA233@tv-sign.ru>
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <Pine.LNX.4.64.0701291102240.29254@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701291102240.29254@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Christoph Lameter wrote:
>
> On Mon, 29 Jan 2007, Oleg Nesterov wrote:
> 
> > >                                      The slab would need a notification 
> > > that the workqueue for a processor was shutdown in order to set work.func 
> > > = NULL.
> > 
> > The slab has a notification: CPU_XXX events. It should cancel a pending per
> > cpu "reap_work timer".
> 
> Ahh. Okay then the following patch would fix it?
> 
> Shutdown cache_reaper when cpu goes down
> 
> Shutdown the cache_reaper in slab.c if the cpu is brought down
> and set the cache_reap.func to NULL. Otherwise hotplug shuts
> down the reaper for good.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.20-rc6/mm/slab.c
> ===================================================================
> --- linux-2.6.20-rc6.orig/mm/slab.c	2007-01-24 20:19:28.000000000 -0600
> +++ linux-2.6.20-rc6/mm/slab.c	2007-01-29 13:08:05.773928988 -0600
> @@ -1269,6 +1269,10 @@ static int __cpuinit cpuup_callback(stru
>  		break;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	case CPU_DOWN_PREPARE:
> +		/* Shutdown cache reaper */
> +		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
> +		per_cpu(reap_work, cpu).work.func = NULL;
> +
>  		mutex_lock(&cache_chain_mutex);
>  		break;
>  	case CPU_DOWN_FAILED:

Then CPU_DOWN_FAILED should do start_cpu_timer(cpu).

Oleg.

