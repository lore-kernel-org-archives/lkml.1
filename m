Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZCDAHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZCDAHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbZCDAHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:07:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51777 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZCDAH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:07:29 -0500
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
In-Reply-To: <20090303111713.GQ11421@balbir.in.ibm.com>
References: <20090303095833.D9FC.A69D9226@jp.fujitsu.com> <20090303111713.GQ11421@balbir.in.ibm.com>
Message-Id: <20090304084928.FD57.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed,  4 Mar 2009 09:07:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir

> > > > kswapd's roll is increasing free pages until zone->pages_high in "own node".
> > > > mem_cgroup_soft_limit_reclaim() free one (or more) exceed page in any node.
> > > > 
> > > > Oh, well.
> > > > I think it is not consistency.
> > > > 
> > > > if mem_cgroup_soft_limit_reclaim() is aware to target node and its pages_high,
> > > > I'm glad.
> > > 
> > > Yes, correct the role of kswapd is to keep increasing free pages until
> > > zone->pages_high and the first set of pages to consider is the memory
> > > controller over their soft limits. We pass the zonelist to ensure that
> > > while doing soft reclaim, we focus on the zonelist associated with the
> > > node. Kamezawa had concernes over calling the soft limit reclaim from
> > > __alloc_pages_internal(), did you prefer that call path? 
> > 
> > I read your patch again.
> > So, mem_cgroup_soft_limit_reclaim() caller place seems in balance_pgdat() is better.
> > 
> > Please imazine most bad scenario.
> > CPU0 (kswapd) take to continue shrinking.
> > CPU1 take another activity and charge memcg conteniously.
> > At that time, balance_pgdat() don't exit very long time. then 
> > mem_cgroup_soft_limit_reclaim() is never called.
> > 
> 
> Yes, true... that is why I added the hooks in __alloc_pages_internal()
> in the first two revisions, but Kamezawa objected to them. In the
> scenario that you mention that balance_pgdat() is busy, if we are
> under global system memory pressure, even after freeing memory from
> soft limited cgroups, we don't have sufficient free memory. We need to
> go reclaim from the whole system. An administrator can easily avoid
> the above scenario by using hard limits on the cgroup running on CPU1.

I agree with soft limit implementation is difficult.

but I still don't like soft limit in __alloc_pages_internal().
if it does, kswapd reclaim the pages from global LRU *before*
shrinking soft limit.

again, linux reclaim policy is

	free < pages_low:  run kswapd
	free < pages_min:  foreground reclaim via __alloc_pages_internal()

then, if soft limit reclaim put into __alloc_pages_internal(),

	free < pages_low:  run kswapd
	free < pages_min:  soft limit reclaim and 
                           foreground reclaim via __alloc_pages_internal()

it seems unintetional behavior.

In addition, I still strongly oppose againt global lock although 
soft limit shrinking don't put into __alloc_pages_internal().
I think it doesn't depend on caller place.


