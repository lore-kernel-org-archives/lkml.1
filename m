Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZCCCoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZCCCoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZCCCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:43:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42900 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZCCCn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:43:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 4/4] Memory controller soft limit reclaim on contention (v3)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090302044406.GD11421@balbir.in.ibm.com>
References: <20090302120052.6FEC.A69D9226@jp.fujitsu.com> <20090302044406.GD11421@balbir.in.ibm.com>
Message-Id: <20090303095833.D9FC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue,  3 Mar 2009 11:43:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-03-02 12:08:01]:
> 
> > Hi Balbir,
> > 
> > > @@ -2015,9 +2016,12 @@ static int kswapd(void *p)
> > >  		finish_wait(&pgdat->kswapd_wait, &wait);
> > >  
> > >  		if (!try_to_freeze()) {
> > > +			struct zonelist *zl = pgdat->node_zonelists;
> > >  			/* We can speed up thawing tasks if we don't call
> > >  			 * balance_pgdat after returning from the refrigerator
> > >  			 */
> > > +			if (!order)
> > > +				mem_cgroup_soft_limit_reclaim(zl, GFP_KERNEL);
> > >  			balance_pgdat(pgdat, order);
> > >  		}
> > >  	}
> > 
> > kswapd's roll is increasing free pages until zone->pages_high in "own node".
> > mem_cgroup_soft_limit_reclaim() free one (or more) exceed page in any node.
> > 
> > Oh, well.
> > I think it is not consistency.
> > 
> > if mem_cgroup_soft_limit_reclaim() is aware to target node and its pages_high,
> > I'm glad.
> 
> Yes, correct the role of kswapd is to keep increasing free pages until
> zone->pages_high and the first set of pages to consider is the memory
> controller over their soft limits. We pass the zonelist to ensure that
> while doing soft reclaim, we focus on the zonelist associated with the
> node. Kamezawa had concernes over calling the soft limit reclaim from
> __alloc_pages_internal(), did you prefer that call path? 

I read your patch again.
So, mem_cgroup_soft_limit_reclaim() caller place seems in balance_pgdat() is better.

Please imazine most bad scenario.
CPU0 (kswapd) take to continue shrinking.
CPU1 take another activity and charge memcg conteniously.
At that time, balance_pgdat() don't exit very long time. then 
mem_cgroup_soft_limit_reclaim() is never called.

In ideal, if another cpu take another charge, kswapd should shrink 
soft limit again.


btw, I don't like "if (!order)" condition. memcg soft limit sould be
always shrinked although 
it's the order of because wakeup_kswapd() argument is merely hint.

another process want another order.



