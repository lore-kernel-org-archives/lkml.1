Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbZIDFta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbZIDFta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 01:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZIDFt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 01:49:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45239 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZIDFt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 01:49:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Sep 2009 14:47:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [mmotm][experimental][PATCH] coalescing charge
Message-Id: <20090904144732.6d41e353.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090904141157.4640ec1e.nishimura@mxp.nes.nec.co.jp>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
	<20090904131835.ac2b8cc8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904141157.4640ec1e.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 14:11:57 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> A few more comments.
> 
> On Fri, 4 Sep 2009 13:18:35 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Thu, 3 Sep 2009 14:17:27 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > > =
> > > > This is a code for batched charging using percpu cache.
> > > > At charge, memcg charges 64pages and remember it in percpu cache.
> > > > Because it's cache, drain/flushed if necessary.
> > > > 
> > > > This version uses public percpu area , not per-memcg percpu area.
> > > >  2 benefits of public percpu area.
> > > >  1. Sum of stocked charge in the system is limited to # of cpus
> > > >     not to the number of memcg. This shows better synchonization.
> > > >  2. drain code for flush/cpuhotplug is very easy (and quick)
> > > > 
> > > > The most important point of this patch is that we never touch res_counter
> > > > in fast path. The res_counter is system-wide shared counter which is modified
> > > > very frequently. We shouldn't touch it as far as we can for avoid false sharing.
> > > > 
> > > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > It looks basically good. I'll do some tests with all patches applied.
> > > 
> > thanks.
> > 
> it seems that these patches make rmdir stall again...
> This batched charge patch seems not to be the (only) suspect, though.
> 
I reporduced. I doubt charge/uncharge patch is bad...I'll check it.
(And maybe very easily happen ;(

Thanks,
-Kame




> > > > @@ -1288,23 +1364,25 @@ static int __mem_cgroup_try_charge(struc
> > > >  		return 0;
> > > >  
> > > >  	VM_BUG_ON(css_is_removed(&mem->css));
> > > > +	if (mem_cgroup_is_root(mem))
> > > > +		goto done;
> > > > +	if (consume_stock(mem))
> > > > +		goto charged;
> > > >  
> IMHO, it would be better to check consume_stock() every time in the while loop below,
> because someone might have already refilled the stock while the current context
> sleeps in reclaiming memory.
> 
> > > >  	while (1) {
> > > >  		int ret = 0;
> > > >  		unsigned long flags = 0;
> > > >  
> > > > -		if (mem_cgroup_is_root(mem))
> > > > -			goto done;
> > > > -		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
> > > > +		ret = res_counter_charge(&mem->res, CHARGE_SIZE, &fail_res);
> > > >  		if (likely(!ret)) {
> > > >  			if (!do_swap_account)
> > > >  				break;
> > > > -			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
> > > > +			ret = res_counter_charge(&mem->memsw, CHARGE_SIZE,
> > > >  							&fail_res);
> > > >  			if (likely(!ret))
> > > >  				break;
> > > >  			/* mem+swap counter fails */
> > > > -			res_counter_uncharge(&mem->res, PAGE_SIZE);
> > > > +			res_counter_uncharge(&mem->res, CHARGE_SIZE);
> > > >  			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
> > > >  			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
> > > >  									memsw);
> How about changing pre-charge size according to the loop count ?
> IMHO, it would be better to disable pre-charge at least in nr_retries==0 case,
> i.e. it is about to causing oom.
> 
> 
> P.S. I will not be so active next week.
> 
> Thanks,
> Daisuke Nishimura.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

