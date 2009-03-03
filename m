Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZCCLRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZCCLRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZCCLRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:17:24 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34187 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZCCLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:17:24 -0500
Date: Tue, 3 Mar 2009 16:47:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/4] Memory controller soft limit reclaim on contention
	(v3)
Message-ID: <20090303111713.GQ11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090302120052.6FEC.A69D9226@jp.fujitsu.com> <20090302044406.GD11421@balbir.in.ibm.com> <20090303095833.D9FC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090303095833.D9FC.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-03-03 11:43:49]:

> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-03-02 12:08:01]:
> > 
> > > Hi Balbir,
> > > 
> > > > @@ -2015,9 +2016,12 @@ static int kswapd(void *p)
> > > >  		finish_wait(&pgdat->kswapd_wait, &wait);
> > > >  
> > > >  		if (!try_to_freeze()) {
> > > > +			struct zonelist *zl = pgdat->node_zonelists;
> > > >  			/* We can speed up thawing tasks if we don't call
> > > >  			 * balance_pgdat after returning from the refrigerator
> > > >  			 */
> > > > +			if (!order)
> > > > +				mem_cgroup_soft_limit_reclaim(zl, GFP_KERNEL);
> > > >  			balance_pgdat(pgdat, order);
> > > >  		}
> > > >  	}
> > > 
> > > kswapd's roll is increasing free pages until zone->pages_high in "own node".
> > > mem_cgroup_soft_limit_reclaim() free one (or more) exceed page in any node.
> > > 
> > > Oh, well.
> > > I think it is not consistency.
> > > 
> > > if mem_cgroup_soft_limit_reclaim() is aware to target node and its pages_high,
> > > I'm glad.
> > 
> > Yes, correct the role of kswapd is to keep increasing free pages until
> > zone->pages_high and the first set of pages to consider is the memory
> > controller over their soft limits. We pass the zonelist to ensure that
> > while doing soft reclaim, we focus on the zonelist associated with the
> > node. Kamezawa had concernes over calling the soft limit reclaim from
> > __alloc_pages_internal(), did you prefer that call path? 
> 
> I read your patch again.
> So, mem_cgroup_soft_limit_reclaim() caller place seems in balance_pgdat() is better.
> 
> Please imazine most bad scenario.
> CPU0 (kswapd) take to continue shrinking.
> CPU1 take another activity and charge memcg conteniously.
> At that time, balance_pgdat() don't exit very long time. then 
> mem_cgroup_soft_limit_reclaim() is never called.
> 

Yes, true... that is why I added the hooks in __alloc_pages_internal()
in the first two revisions, but Kamezawa objected to them. In the
scenario that you mention that balance_pgdat() is busy, if we are
under global system memory pressure, even after freeing memory from
soft limited cgroups, we don't have sufficient free memory. We need to
go reclaim from the whole system. An administrator can easily avoid
the above scenario by using hard limits on the cgroup running on CPU1.

> In ideal, if another cpu take another charge, kswapd should shrink 
> soft limit again.
>

Could you please elaborate further?
 
> 
> btw, I don't like "if (!order)" condition. memcg soft limit sould be
> always shrinked although 
> it's the order of because wakeup_kswapd() argument is merely hint.
> 
> another process want another order.
> 

Agreed, I'll remove the check.

> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

-- 
	Balbir
