Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbXKSOsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbXKSOsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXKSOsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:48:46 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49695 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbXKSOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:48:45 -0500
Date: Mon, 19 Nov 2007 20:31:26 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 1/2] sched: Minor cleanups
Message-ID: <20071119150126.GA24810@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119122828.GB28777@linux.vnet.ibm.com> <20071119130803.GA31491@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119130803.GA31491@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 02:08:03PM +0100, Ingo Molnar wrote:
> >  #define for_each_leaf_cfs_rq(rq, cfs_rq) \
> > -	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
> > +	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
> >  
> >  /* Do the two (enqueued) entities belong to the same group ? */
> >  static inline int
> > @@ -1126,7 +1126,10 @@ static void print_cfs_stats(struct seq_f
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> >  	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
> >  #endif
> > +
> > +	rcu_read_lock();
> >  	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
> >  		print_cfs_rq(m, cpu, cfs_rq);
> > +	rcu_read_unlock();
> 
> hm, why is this a cleanup?

Sorry for the wrong subject. It was supposed to include the above bug fix,
related to how we walk the task group list.

Thinking abt it now, I realize that print_cfs_rq() can potentially
sleep and hence it cannot be surrounded by rcu_read_lock()/unlock().

And as Dipankar just pointed me, sched_create/destroy_group aren't
serialized at all currently, so we need a mutex to protect them. The
same mutex can be then used when walking the list in print_cfs_stats() ..

Will send update patches soon ..


-- 
Regards,
vatsa
