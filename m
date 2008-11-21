Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYKUCpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYKUCpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 21:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYKUCpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 21:45:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60356 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYKUCph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:45:37 -0500
Date: Fri, 21 Nov 2008 11:44:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] memcg : mem+swap controlelr core
Message-Id: <20081121114452.43c9de93.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49261F87.50209@cn.fujitsu.com>
References: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
	<20081114191949.926bf99d.kamezawa.hiroyu@jp.fujitsu.com>
	<49261F87.50209@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 10:40:07 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > @@ -513,12 +531,25 @@ static int __mem_cgroup_try_charge(struc
> >  		css_get(&mem->css);
> >  	}
> >  
> > +	while (1) {
> 
> This loop will never break out if memory.limit_in_bytes is too low.
> 
> Actually, when I set the limit to 0 and moved a task into the cgroup and let
> the task allocate a page, then the whole system froze, and I had to reset
> my machine.
> 
> And small memory.limit will make the process stuck:
> # mkdir /memcg/0
> # echo 40K > /memcg/0/memory.limit_in_bytes
> # echo $$ > tasks
> # ls
> (stuck)
> 
Ok, I'll check/post a patch today for both.
Thank you for reporting.

Maybe some clean up is needed around logic for "give up" or "continue" 

-Kame

> (another console)
> # echo 100K > /memcg/0/memory.limit_in_bytes
> (then the above 'ls' can continue)
> 
> > +		int ret;
> > +		bool noswap = false;
> >  
> > -	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE))) {
> > +		ret = res_counter_charge(&mem->res, PAGE_SIZE);
> > +		if (likely(!ret)) {
> > +			if (!do_swap_account)
> > +				break;
> > +			ret = res_counter_charge(&mem->memsw, PAGE_SIZE);
> > +			if (likely(!ret))
> > +				break;
> > +			/* mem+swap counter fails */
> > +			res_counter_uncharge(&mem->res, PAGE_SIZE);
> > +			noswap = true;
> > +		}
> >  		if (!(gfp_mask & __GFP_WAIT))
> >  			goto nomem;
> >  
> > -		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
> > +		if (try_to_free_mem_cgroup_pages(mem, gfp_mask, noswap))
> >  			continue;
> >  
> >  		/*
> > @@ -527,8 +558,13 @@ static int __mem_cgroup_try_charge(struc
> >  		 * moved to swap cache or just unmapped from the cgroup.
> >  		 * Check the limit again to see if the reclaim reduced the
> >  		 * current usage of the cgroup before giving up
> > +		 *
> >  		 */
> > -		if (res_counter_check_under_limit(&mem->res))
> > +		if (!do_swap_account &&
> > +			res_counter_check_under_limit(&mem->res))
> > +			continue;
> > +		if (do_swap_account &&
> > +			res_counter_check_under_limit(&mem->memsw))
> >  			continue;
> >  
> >  		if (!nr_retries--) {
> 
> 
> 

