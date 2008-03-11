Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYCKEj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYCKEj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYCKEjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:39:51 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:39199 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750847AbYCKEju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:39:50 -0400
Date: Tue, 11 Mar 2008 10:09:48 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, rjw@sisk.pl,
       dmitry.adamushko@gmail.com, mingo@elte.hu, oleg@sign.ru,
       yi.y.yang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v2] keep rd->online and cpu_online_map in sync
Message-ID: <20080311043948.GA9254@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080310221014.GB27329@linux-os.sc.intel.com> <20080310215813.10968.960.stgit@novell1.haskins.net> <20080310163613.65a7313c.akpm@linux-foundation.org> <20080311013456.GD15909@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311013456.GD15909@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 06:34:56PM -0700, Suresh Siddha wrote:
> On Mon, Mar 10, 2008 at 04:36:13PM -0700, Andrew Morton wrote:
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -5881,7 +5881,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> > >  		spin_unlock_irq(&rq->lock);
> > >  		break;
> > >  
> > > -	case CPU_DOWN_PREPARE:
> > > +	case CPU_DYING:
> > > +	case CPU_DYING_FROZEN:
> > >  		/* Update our root-domain */
> > >  		rq = cpu_rq(cpu);
> > >  		spin_lock_irqsave(&rq->lock, flags);
> > 
> > Does this make
> > cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch
> > (below) obsolete,
> 
> Yes. I would like to Ack for the
> keep-rd-online-and-cpu_online_map-in-sync.patch, as it is more cleaner.
> 
> 
> > or do we want both?  
> 
> No. I don't think so. Gautham, do you agree?

Yup I agree! Greg's patch is better since i clears the
bit *just* before we take the cpu down. That way we won't mess with the 
ordering. 

But I would still prefer that we update the sched_domains early on 
after cpu-hotplug rather than doing it after the subsystems have run 
their notifiers.

Will send a seperate patch for that one.
> 
> thanks,
> suresh
> 
> > 
> > --- a/kernel/sched.c~cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio
> > +++ a/kernel/sched.c
> > @@ -7096,8 +7096,16 @@ void __init sched_init_smp(void)
> >  	if (cpus_empty(non_isolated_cpus))
> >  		cpu_set(smp_processor_id(), non_isolated_cpus);
> >  	put_online_cpus();
> > -	/* XXX: Theoretical race here - CPU may be hotplugged now */
> > -	hotcpu_notifier(update_sched_domains, 0);
> > +	/*
> > +	 * XXX: Theoretical race here - CPU may be hotplugged now
> > +	 *
> > +	 * We register the notifier with priority 11, which means that
> > +	 * update_sched_domains() will be called just before migration_call().
> > +	 *
> > +	 * This is necessary to ensure that the rt wake up logic works fine
> > +	 * and the rq->rd->online_map remains in sync with the cpu_online_map.
> > +	 */
> > +	hotcpu_notifier(update_sched_domains, 11);
> >  
> >  	/* Move init over to a non-isolated CPU */
> >  	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
> > _
> > 

-- 
Thanks and Regards
gautham
