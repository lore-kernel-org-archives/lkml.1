Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZH1HhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZH1HhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZH1HhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:37:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36302 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZH1HhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:37:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 16:35:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
Message-Id: <20090828163523.e51678be.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090828072007.GH4889@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
	<20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090828072007.GH4889@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 12:50:08 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28 13:23:21]:
> 
> > This patch tries to modify softlimit handling in memcg/res_counter.
> > There are 2 reasons in general.
> > 
> >  1. soft_limit can use only against sub-hierarchy root.
> >     Because softlimit tree is sorted by usage, putting prural groups
> >     under hierarchy (which shares usage) will just adds noise and unnecessary
> >     mess. This patch limits softlimit feature only to hierarchy root.
> >     This will make softlimit-tree maintainance better. 
> > 
> >  2. In these days, it's reported that res_counter can be bottleneck in
> >     massively parallel enviroment. We need to reduce jobs under spinlock.
> >     The reason we check softlimit at res_counter_charge() is that any member
> >     in hierarchy can have softlimit.
> >     But by chages in "1", only hierarchy root has soft_limit. We can omit
> >     hierarchical check in res_counter.
> > 
> > After this patch, soft limit is avaliable only for root of sub-hierarchy.
> > (Anyway, softlimit for hierarchy children just makes users confused, hard-to-use)
> >
> 
> 
> I need some time to digest this change, if the root is a hiearchy root
> then only root can support soft limits? I think the change makes it
> harder to use soft limits. Please help me understand better. 
> 
I poitned out this issue many many times while you wrote patch.

memcg has "sub tree". hierarchy here means "sub tree" with use_hierarchy =1.

Assume


	/cgroup/Users/use_hierarchy=0
		  Gold/ use_hierarchy=1 
		     Bob
		     Mike
		  Silver/use_hierarchy=1
		     
		/System/use_hierarchy=1
	
In flat, there are 3 sub trees.
	/cgroup/Users/Gold   (Gold has /cgroup/Users/Gold/Bog, /cgroup/Users/Gold/Mike)
	/cgroup/Users/Silver .....
	/cgroup/System	     .....

Then, subtrees means a group which inherits charges by use_hierarchy=1

In current implementation, softlimit can be set to arbitrary cgroup. 
Then, following ops are allowed.
==
	/cgroup/Users/Gold softlimit= 1G
	/cgroup/Users/Gold/Bob  softlimit=800M
	/cgroup/Users/Gold/Mike softlimit=800M
==

Then, how your RB-tree for softlimit management works ?

When softlimit finds /cgroup/Users/Gold/, it will reclaim memory from
all 3 groups by hierarchical_reclaim. If softlimit finds
/cgroup/Users/Gold/Bob, reclaim from Bob means recalaim from Gold.

Then, to keep the RB-tree neat, you have to extract all related cgroups and
re-insert them all, every time.
(But current code doesn't do that. It's broken.)

Current soft-limit RB-tree will be easily broken i.e. not-sorted correctly
if used under use_hierarchy=1.

My patch disallows set softlimit to Bob and Mike, just allows against Gold
because there can be considered as the same class, hierarchy.

Thanks,
-Kame










