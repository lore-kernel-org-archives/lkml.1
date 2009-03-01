Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZCARAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZCARAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 12:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZCARAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 12:00:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:46346 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbZCARAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 12:00:22 -0500
Date: Sun, 1 Mar 2009 18:00:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: recursive slqb_lock
Message-ID: <20090301170015.GC26905@wotan.suse.de>
References: <20090226053450.GA31108@localhost> <20090301150725.GB26905@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301150725.GB26905@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 04:07:25PM +0100, Nick Piggin wrote:
> On Thu, Feb 26, 2009 at 01:34:50PM +0800, Wu Fengguang wrote:
> > Hi Nick,
> > 
> > I got a lockdep warning. It looks like the slqb_lock will be taken
> > twice in the call chain:
> > 
> >         s_start()  => take slqb_lock
> >           s_show()
> >             gather_stats()  => take slqb_lock again
> 
> Hey, thanks for this. The following patch should fix it.
> 
> --
> Fix the lockdep error reported by Fengguang where down_read slqb_lock
> is taken twice, with the possibility for a deadlock.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> Index: linux-2.6/mm/slqb.c
> ===================================================================
> --- linux-2.6.orig/mm/slqb.c	2009-03-02 02:05:16.000000000 +1100
> +++ linux-2.6/mm/slqb.c	2009-03-02 02:05:45.000000000 +1100
> @@ -3079,7 +3079,9 @@ static void __gather_stats(void *arg)
>  	spin_unlock(&gather->lock);
>  }
>  
> -static void gather_stats(struct kmem_cache *s, struct stats_gather *stats)
> +/* must be called with slqb_lock held */
> +static void gather_stats_locked(struct kmem_cache *s,
> +				struct stats_gather *stats)
>  {
>  #ifdef CONFIG_NUMA
>  	int node;
> @@ -3089,8 +3091,6 @@ static void gather_stats(struct kmem_cac
>  	stats->s = s;
>  	spin_lock_init(&stats->lock);
>  
> -	down_read(&slqb_lock); /* hold off hotplug */
> -
>  	on_each_cpu(__gather_stats, stats, 1);
>  
>  #ifdef CONFIG_NUMA
> @@ -3119,10 +3119,15 @@ static void gather_stats(struct kmem_cac
>  	}
>  #endif
>  
> -	up_read(&slqb_lock);
> -
>  	stats->nr_objects = stats->nr_slabs * s->objects;
>  }
> +
> +static void gather_stats(struct kmem_cache *s, struct stats_gather *stats)
> +{
> +	down_read(&slqb_lock); /* hold off hotplug */
> +	gather_stats(s, stats);
> +	up_read(&slqb_lock);
> +}

Oops, I didn't test it. That call should be to gather_stats_locked of
course.
