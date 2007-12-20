Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbXLTQBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbXLTQBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXLTQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:01:26 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59703 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbXLTQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:01:24 -0500
Date: Thu, 20 Dec 2007 16:00:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memcgroup: work better with tmpfs
In-Reply-To: <20071219093840.7d466c2b.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0712201553010.6414@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
 <20071219093840.7d466c2b.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, KAMEZAWA Hiroyuki wrote:
> On Tue, 18 Dec 2007 22:19:22 +0000 (GMT)
> Hugh Dickins <hugh@veritas.com> wrote:
> > 1. Why is spin_lock_irqsave rather than spin_lock needed on mz->lru_lock?
> > If it is needed, doesn't mem_cgroup_isolate_pages need to use it too?
> > 
> When I wrote a patch to treat lru_lock (it was not per-zone yet.), I got a
> comment to use irqsafe version. So I wonder there is some plan which needs
> irq safe locking.

It might have come about because struct zone's lru_lock really does need
the irq disabled (because of things that happen at I/O completion time).
But I don't think struct mem_cgroup_per_zone's lru_lock needs it.

> About mem_cgroup_isolate_pages(), zone->lock is acquired with irq-disable 
> before it is called. Then, it's not necesary there.

Ah, yes, I completely missed that, thank you.

> 
> But as you say, it looks we can do it without irq-disable, now.
> 
> 
> > 2. There's mem_cgroup_charge and mem_cgroup_cache_charge (wouldn't the
> > former be better called mem_cgroup_charge_mapped? why does the latter
> > test MEM_CGROUP_TYPE_ALL instead of MEM_CGROUP_TYPE_CACHED? I still don't
> > understand your enums there).  But there's only mem_cgroup_uncharge.
> > So when, for example, an add_to_page_cache fails, the uncharge may not
> > balance the charge?
> >
> Ah...it seems bug. We should add type handling in uncharge. 
> Then, changing control_type after start using mem_cgroup seems dangerous.
> (Default is ALL now.)
> 
> Maybe following will be fix.
> 
> - allow changing contorl_type only when there is no task.
> - run force_empty when control_type is changed. and drop all charges.
> 
> This will change current behavior but I think it's reasonable.
> How do you think ?

Perhaps... my grasp on this is much too weak to be sure:
I'm pretty sceptical about changing control_type altogether.
Let me reply to Balbir, who still sees no issue there.

Hugh
