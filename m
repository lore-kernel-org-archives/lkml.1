Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYCKBfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYCKBfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbYCKBe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:34:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:15396 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbYCKBe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:34:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,477,1199692800"; 
   d="scan'208";a="261807428"
Date: Mon, 10 Mar 2008 18:34:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Haskins <ghaskins@novell.com>, suresh.b.siddha@intel.com,
       ego@in.ibm.com, rjw@sisk.pl, dmitry.adamushko@gmail.com, mingo@elte.hu,
       oleg@sign.ru, yi.y.yang@intel.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [PATCH v2] keep rd->online and cpu_online_map in sync
Message-ID: <20080311013456.GD15909@linux-os.sc.intel.com>
References: <20080310221014.GB27329@linux-os.sc.intel.com> <20080310215813.10968.960.stgit@novell1.haskins.net> <20080310163613.65a7313c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310163613.65a7313c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 04:36:13PM -0700, Andrew Morton wrote:
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5881,7 +5881,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  		spin_unlock_irq(&rq->lock);
> >  		break;
> >  
> > -	case CPU_DOWN_PREPARE:
> > +	case CPU_DYING:
> > +	case CPU_DYING_FROZEN:
> >  		/* Update our root-domain */
> >  		rq = cpu_rq(cpu);
> >  		spin_lock_irqsave(&rq->lock, flags);
> 
> Does this make
> cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch
> (below) obsolete,

Yes. I would like to Ack for the
keep-rd-online-and-cpu_online_map-in-sync.patch, as it is more cleaner.


> or do we want both?  

No. I don't think so. Gautham, do you agree?

thanks,
suresh

> 
> --- a/kernel/sched.c~cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio
> +++ a/kernel/sched.c
> @@ -7096,8 +7096,16 @@ void __init sched_init_smp(void)
>  	if (cpus_empty(non_isolated_cpus))
>  		cpu_set(smp_processor_id(), non_isolated_cpus);
>  	put_online_cpus();
> -	/* XXX: Theoretical race here - CPU may be hotplugged now */
> -	hotcpu_notifier(update_sched_domains, 0);
> +	/*
> +	 * XXX: Theoretical race here - CPU may be hotplugged now
> +	 *
> +	 * We register the notifier with priority 11, which means that
> +	 * update_sched_domains() will be called just before migration_call().
> +	 *
> +	 * This is necessary to ensure that the rt wake up logic works fine
> +	 * and the rq->rd->online_map remains in sync with the cpu_online_map.
> +	 */
> +	hotcpu_notifier(update_sched_domains, 11);
>  
>  	/* Move init over to a non-isolated CPU */
>  	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
> _
> 
