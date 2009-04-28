Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZD1WV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZD1WV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZD1WVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:21:10 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:53053 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZD1WVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:21:08 -0400
Date: Wed, 29 Apr 2009 03:16:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix leak of swap accounting as stale swap cache under
	memcg
Message-ID: <20090428214606.GB12698@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090427181259.6efec90b.kamezawa.hiroyu@jp.fujitsu.com> <20090427101323.GK4454@balbir.in.ibm.com> <20090427203535.4e3f970b.d-nishimura@mtf.biglobe.ne.jp> <661de9470904271217t7ef9e300x1e40bbf0362ca14f@mail.gmail.com> <20090428085753.a91b6007.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090428085753.a91b6007.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-28 08:57:53]:

> On Tue, 28 Apr 2009 00:47:31 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Thanks for the detailed explanation of the possible race conditions. I
> > am beginning to wonder why we don't have any hooks in add_to_swap.*.
> > for charging a page. If the page is already charged and if it is a
> > context issue (charging it to the right cgroup) that is already
> > handled from what I see. Won't that help us solve the !PageCgroupUsed
> > issue?
> > 
> 
> For adding hook to add_to_swap_cache, we need to know which cgroup the swap cache
> should be charged. Then, we have to remove CONFIG_CGROUP_MEM_RES_CTRL_SWAP_EXT
> and enable memsw control always.
> 
> When using swap_cgroup, we'll know which cgroup the new swap cache should be charged.
> Then, the new page readed in will be charged to recorded cgroup in swap_cgroup.
> One bad thing of this method is a cgroup which swap_cgroup point to is different from
> a cgroup which the task calls do_swap_fault(). This means that a page-fault by a
> task can cause memory-reclaim under another cgroup and moreover, OOM.
> I don't think it's sane behavior. So, current design of swap accounting waits until the
> page is mapped.
>
 
I know (that is why we removed the hooks from the original memcg at
some point). Why can't we mark the page here as swap pending to be
mapped, so that we don't lose them. As far as OOM is concerned, I
think they'll get relocated again when they are mapped (as per the
current implementation), the ones that don't are stale and can be
easily reclaimed.


-- 
	Balbir
