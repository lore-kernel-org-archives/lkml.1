Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZKKM2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZKKM2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZKKM2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:28:42 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:47549 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbZKKM2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:28:40 -0500
Date: Wed, 11 Nov 2009 13:27:42 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG] sched_rt_periodic_timer vs cpu hotplug
Message-ID: <20091111122742.GB19103@osiris.boeblingen.de.ibm.com>
References: <20091111101801.GA19103@osiris.boeblingen.de.ibm.com>
 <1257935428.23203.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257935428.23203.82.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 11:30:28AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-11 at 11:18 +0100, Heiko Carstens wrote:
> > cpu_attach_domain calls (inlined) rq_attach_root. That function replaces a
> > runqueue's root_domain while holding its lock (&rq->lock).
> > 
> > Now the code snippet above from do_sched_rt_period_timer does access a
> > runqueue's root_domain _without_ holding its lock.
> > That way a concurrent cpu_up operation can easily change a runqueue's
> > root_domain pointer while it is still in use. Which is what happened here.
> > 
> > Just grabbing and releasing the lock for each iteration is probably not the
> > real fix, since the span mask could change between iterations. Which might
> > lead to strange effects.
> 
> Does something like the below fix it? Normal sched_domain bits also do
> sync_sched() for domain destruction as can be seen from
> detach_destroy_domains()..
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 91642c1..3b02339 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7918,6 +7923,8 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
>  
>  static void free_rootdomain(struct root_domain *rd)
>  {
> +	synchronize_sched();
> +

Looks good. It might take a few days for a final confirmation.

Thanks!
