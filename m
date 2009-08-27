Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbZH0MeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbZH0MeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZH0MeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:34:12 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:35059 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbZH0MeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:34:11 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] sched: Avoid division by zero - really
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jes@sgi.com, jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <4A9679EC.1030108@gmail.com>
References: <1250855934.7538.30.camel@twins>
	 <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org>
	 <1251227486.7538.1174.camel@twins>  <4A94FD58.8060207@kernel.org>
	 <1251371336.18584.77.camel@twins>  <4A9679EC.1030108@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Aug 2009 14:32:53 +0200
Message-Id: <1251376373.18584.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 14:19 +0200, Eric Dumazet wrote:
> Peter Zijlstra a écrit :
> > When re-computing the shares for each task group's cpu representation we
> > need the ratio of weight on each cpu vs the total weight of the sched
> > domain.
> > 
> > Since load-balancing is loosely (read not) synchronized, the weight of
> > individual cpus can change between doing the sum and calculating the
> > ratio.
> > 
> > The previous patch dealt with only one of the race scenarios, this patch
> > side steps them all by saving a snapshot of all the individual cpu
> > weights, thereby always working on a consistent set.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  kernel/sched.c |   50 +++++++++++++++++++++++++++++---------------------
> >  1 files changed, 29 insertions(+), 21 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 0e76b17..4591054 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -1515,30 +1515,29 @@ static unsigned long cpu_avg_load_per_task(int cpu)
> >  
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> >  
> > +struct update_shares_data {
> > +	unsigned long rq_weight[NR_CPUS];
> > +};
> > +
> > +static DEFINE_PER_CPU(struct update_shares_data, update_shares_data);
> 
> ouch... thats quite large IMHO, up to 4096*8 = 32768 bytes per cpu...
> 
> Now we have nice dynamic per cpu allocations, we could use it here,
> and use nr_cpus instead of NR_CPUS as the array size ?

Possibly, but I guess that should include stuff like
static_sched_{domain,group} too, since they seem to have the same
problem.

