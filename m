Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZD3AE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZD3AE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZD3AEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:04:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44035 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZD3AEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:04:47 -0400
Date: Thu, 30 Apr 2009 09:03:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix leak of swap accounting as stale swap cache under
 memcg
Message-Id: <20090430090313.24d14d52.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090428214606.GB12698@balbir.in.ibm.com>
References: <20090427181259.6efec90b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090427101323.GK4454@balbir.in.ibm.com>
	<20090427203535.4e3f970b.d-nishimura@mtf.biglobe.ne.jp>
	<661de9470904271217t7ef9e300x1e40bbf0362ca14f@mail.gmail.com>
	<20090428085753.a91b6007.kamezawa.hiroyu@jp.fujitsu.com>
	<20090428214606.GB12698@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 03:16:06 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-04-28 08:57:53]:
> 
> > On Tue, 28 Apr 2009 00:47:31 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > Thanks for the detailed explanation of the possible race conditions. I
> > > am beginning to wonder why we don't have any hooks in add_to_swap.*.
> > > for charging a page. If the page is already charged and if it is a
> > > context issue (charging it to the right cgroup) that is already
> > > handled from what I see. Won't that help us solve the !PageCgroupUsed
> > > issue?
> > > 
> > 
> > For adding hook to add_to_swap_cache, we need to know which cgroup the swap cache
> > should be charged. Then, we have to remove CONFIG_CGROUP_MEM_RES_CTRL_SWAP_EXT
> > and enable memsw control always.
> > 
> > When using swap_cgroup, we'll know which cgroup the new swap cache should be charged.
> > Then, the new page readed in will be charged to recorded cgroup in swap_cgroup.
> > One bad thing of this method is a cgroup which swap_cgroup point to is different from
> > a cgroup which the task calls do_swap_fault(). This means that a page-fault by a
> > task can cause memory-reclaim under another cgroup and moreover, OOM.
> > I don't think it's sane behavior. So, current design of swap accounting waits until the
> > page is mapped.
> >
>  
> I know (that is why we removed the hooks from the original memcg at
> some point). Why can't we mark the page here as swap pending to be
> mapped, so that we don't lose them. As far as OOM is concerned, I
> think they'll get relocated again when they are mapped (as per the
> current implementation), the ones that don't are stale and can be
> easily reclaimed.

My point is "we need a help of global LRU".
To implement softlimit, we *have to* fix this without global LRU's help.
I have much more simple patch. pls see it.


Thanks,
-Kame

