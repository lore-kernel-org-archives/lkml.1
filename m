Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZCBEod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZCBEod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 23:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZCBEoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 23:44:24 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46668 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZCBEoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 23:44:24 -0500
Date: Mon, 2 Mar 2009 10:14:06 +0530
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
Message-ID: <20090302044406.GD11421@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain> <20090301063041.31557.86588.sendpatchset@localhost.localdomain> <20090302120052.6FEC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090302120052.6FEC.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-03-02 12:08:01]:

> Hi Balbir,
> 
> > @@ -2015,9 +2016,12 @@ static int kswapd(void *p)
> >  		finish_wait(&pgdat->kswapd_wait, &wait);
> >  
> >  		if (!try_to_freeze()) {
> > +			struct zonelist *zl = pgdat->node_zonelists;
> >  			/* We can speed up thawing tasks if we don't call
> >  			 * balance_pgdat after returning from the refrigerator
> >  			 */
> > +			if (!order)
> > +				mem_cgroup_soft_limit_reclaim(zl, GFP_KERNEL);
> >  			balance_pgdat(pgdat, order);
> >  		}
> >  	}
> 
> kswapd's roll is increasing free pages until zone->pages_high in "own node".
> mem_cgroup_soft_limit_reclaim() free one (or more) exceed page in any node.
> 
> Oh, well.
> I think it is not consistency.
> 
> if mem_cgroup_soft_limit_reclaim() is aware to target node and its pages_high,
> I'm glad.
>

Yes, correct the role of kswapd is to keep increasing free pages until
zone->pages_high and the first set of pages to consider is the memory
controller over their soft limits. We pass the zonelist to ensure that
while doing soft reclaim, we focus on the zonelist associated with the
node. Kamezawa had concernes over calling the soft limit reclaim from
__alloc_pages_internal(), did you prefer that call path? 

-- 
	Balbir
