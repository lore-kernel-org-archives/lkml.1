Return-Path: <linux-kernel-owner+w=401wt.eu-S935897AbYEBS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897AbYEBS4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYEBS4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:56:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36195 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbYEBS4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:56:01 -0400
Subject: Re: questions on calc_delta_mine() in sched.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Blanchard <anton@au1.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <481B6175.6070207@austin.ibm.com>
References: <481A2BF6.2070406@austin.ibm.com>
	 <1209730442.6508.3.camel@lappy>  <1209731455.6508.8.camel@lappy>
	 <1209733807.6929.0.camel@lappy>  <481B6175.6070207@austin.ibm.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 20:55:39 +0200
Message-Id: <1209754539.6929.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 13:46 -0500, Joel Schopp wrote:
> > This one builds and... boots
> 
> I'll try to test in on my end.
> 
> > +	struct load_weight lw_cache[4];
> > +	int lw_cache_idx;
> > +
> >  	struct cfs_rq cfs;
> >  	struct rt_rq rt;
> >  
> > @@ -1438,8 +1441,24 @@ calc_delta_mine(unsigned long delta_exec
> >  {
> >  	u64 tmp;
> >  
> > -	if (unlikely(!lw->inv_weight))
> > -		lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
> > +	if (!lw->inv_weight) {
> 
> Yep, got to get rid of unlikely.
> 
> > +		struct rq *rq = cpu_rq(smp_processor_id());
> > +		unsigned long weight = lw->weight;
> > +		int i;
> > +
> > +		for (i = 0; i < ARRAY_SIZE(rq->lw_cache); i++) {
> > +			if (rq->lw_cache[i].weight == weight)
> > +				lw->inv_weight = rq->lw_cache[i].inv_weight;
> > +			goto got_inv;
> > +		}
> > +		if (unlikely(!weight))
> > +			weight++;
> > +		lw->inv_weight = 1 + (WMULT_CONST - weight/2) / weight;
> 
> I bet just dividing by weight + 1 unconditionally would be cheaper than 
> doing the test and shouldn't skew results too badly.

Yeah... probably - getting rid of that one case where it can happen is
on my todo list somewhere.

> > +		rq->lw_cache[rq->lw_cache_idx] = *lw;
> > +		rq->lw_cache_idx++;
> > +		rq->lw_cache_idx %= ARRAY_SIZE(rq->lw_cache);
> > +	}
> > + got_inv:
> 
> Doctor, I think the cure is worse than the disease.   I'd expect that even 
> if all these extra loads hit cache they should together be more expensive 
> than the divide they save.   Not that I have any better solutions myself.

Probably, but since you seemed in benchmarking mood I thought you might
as well give it a go ;-)

> I think a patch to get rid of unlikely and to change these two div64_64 to 
> 0s should be pushed up.  Not sure what we do about the divide.

Ok, I'll stick such a patch in to to-mingo queue ;-)

