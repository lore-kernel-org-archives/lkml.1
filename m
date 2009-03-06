Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZCFOxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZCFOxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZCFOxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:53:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43460 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZCFOxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:53:23 -0500
Date: Fri, 6 Mar 2009 15:50:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com
Subject: Re: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090306145002.GA5828@redhat.com>
References: <20090304121249.GA9855@linux.vnet.ibm.com> <20090304121937.GE9855@linux.vnet.ibm.com> <20090305162329.GA5294@redhat.com> <20090306032122.GA32316@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306032122.GA32316@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06, Gautham R Shenoy wrote:
>
> On Thu, Mar 05, 2009 at 05:23:29PM +0100, Oleg Nesterov wrote:
> > On 03/04, Arun R Bharadwaj wrote:
> > >
> > > +++ linux.trees.git/kernel/sched.c
> > > @@ -4009,6 +4009,11 @@ static struct {
> > >  	.load_balancer = ATOMIC_INIT(-1),
> > >  };
> > >
> > > +inline int get_nohz_load_balancer(void)
> >
> > inline?
> > 
> > > +{
> > > +	return atomic_read(&nohz.load_balancer);
> > > +}
> >
> > Shouldn't we reset .load_balancer when this CPU is CPU_DOWN'ed ?
> > Otherwise the timer can migrate to the dead CPU.
>
> In the select_nohz_load_balancer() code, we check if this CPU is in the
> cpu_active_map. If no, then this CPU relinquishes being the idle
> load balancer.

I don't understand this code, but I am not sure select_nohz_load_balancer()
is always called on cpu_down() path before migrate_timers/migrate_hrtimers.

If this is true, then there is no problem.

> Also, the timer migration code in the CPU down path would
> migrate any timers queued onto this CPU, right ?

Yes, but if .load_balancer is not cleared before the timer migration,
mod_timer() can move the timer to the dead CPU after migration.

Oleg.

