Return-Path: <linux-kernel-owner+w=401wt.eu-S1161072AbXBBA4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072AbXBBA4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXBBA4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:56:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161072AbXBBA4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:56:06 -0500
Date: Thu, 1 Feb 2007 16:55:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [SLAB] Shutdown cache_reaper when cpu goes down
Message-Id: <20070201165553.848fab65.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0702011111560.8307@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702011111560.8307@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 11:13:29 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> Shutdown the cache_reaper if the cpu is brought down and set the 
> cache_reap.func to NULL. Otherwise hotplug shuts down the reaper for good.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.20-rc6-mm2/mm/slab.c
> ===================================================================
> --- linux-2.6.20-rc6-mm2.orig/mm/slab.c	2007-01-29 14:27:34.199229828 -0600
> +++ linux-2.6.20-rc6-mm2/mm/slab.c	2007-01-30 13:55:57.936838878 -0600
> @@ -1271,6 +1271,18 @@ static int __cpuinit cpuup_callback(stru
>  		start_cpu_timer(cpu);
>  		break;
>  #ifdef CONFIG_HOTPLUG_CPU
> +  	case CPU_DOWN_PREPARE:
> +		/*
> +		 * Shutdown cache reaper. Note that the cache_chain_mutex is
> +		 * held so that cache_reap() cannot modify reap_work
> +		 * concurrently.
> +		*/
> +		cancel_rearming_delayed_work(&per_cpu(reap_work, cpu));
> +		per_cpu(reap_work, cpu).work.func = NULL;
> +  		break;
> +  	case CPU_DOWN_FAILED:
> +		start_cpu_timer(cpu);
> +  		break;
>  	case CPU_DEAD:
>  		/*
>  		 * Even if all the cpus of a node are down, we don't free the

Is this bug unique to the changes in -mm, or is it in mainline?
