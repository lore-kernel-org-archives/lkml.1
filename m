Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXLSAoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXLSAoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXLSAnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:43:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43998 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbXLSAnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:43:52 -0500
Date: Wed, 19 Dec 2007 09:38:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memcgroup: work better with tmpfs
Message-Id: <20071219093840.7d466c2b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0712182215460.29209@blonde.wat.veritas.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 22:19:22 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:
> 1. Why is spin_lock_irqsave rather than spin_lock needed on mz->lru_lock?
> If it is needed, doesn't mem_cgroup_isolate_pages need to use it too?
> 
When I wrote a patch to treat lru_lock (it was not per-zone yet.), I got a
comment to use irqsafe version. So I wonder there is some plan which needs
irq safe locking.
About mem_cgroup_isolate_pages(), zone->lock is acquired with irq-disable 
before it is called. Then, it's not necesary there.

But as you say, it looks we can do it without irq-disable, now.


> 2. There's mem_cgroup_charge and mem_cgroup_cache_charge (wouldn't the
> former be better called mem_cgroup_charge_mapped? why does the latter
> test MEM_CGROUP_TYPE_ALL instead of MEM_CGROUP_TYPE_CACHED? I still don't
> understand your enums there).  But there's only mem_cgroup_uncharge.
> So when, for example, an add_to_page_cache fails, the uncharge may not
> balance the charge?
>
Ah...it seems bug. We should add type handling in uncharge. 
Then, changing control_type after start using mem_cgroup seems dangerous.
(Default is ALL now.)

Maybe following will be fix.

- allow changing contorl_type only when there is no task.
- run force_empty when control_type is changed. and drop all charges.

This will change current behavior but I think it's reasonable.
How do you think ?

> 3. mem_cgroup_charge_common has rcu_read_lock/unlock around its
> rcu_dereference; mem_cgroup_cache_charge does not: is that right?
> 
As you say, it seems bug. (sigh, my bug..)
I'd like to fix.

> 4. That page_assign_page_cgroup in free_hot_cold_page, what case is that
> handling?  Wouldn't there be a leak if it ever happens?  I've been running
> with a BUG_ON(page->page_cgroup) there and not hit it - should it perhaps
> be a "Bad page state" case?

I agree with you.

Thank you for review !

Regards
-Kame

