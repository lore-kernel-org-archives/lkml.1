Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbYIVPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbYIVPdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYIVPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:33:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYIVPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:33:08 -0400
Subject: Re: Re: Re: [PATCH 4/13] memcg: force_empty moving account
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <28237198.1222095970373.kamezawa.hiroyu@jp.fujitsu.com>
References: <1222095363.16700.15.camel@lappy.programming.kicks-ass.net>
	 <1222093420.16700.2.camel@lappy.programming.kicks-ass.net>
	 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922200025.49ea6d70.kamezawa.hiroyu@jp.fujitsu.com>
	 <19184326.1222095015978.kamezawa.hiroyu@jp.fujitsu.com>
	 <28237198.1222095970373.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 17:32:48 +0200
Message-Id: <1222097568.16700.33.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 00:06 +0900, kamezawa.hiroyu@jp.fujitsu.com wrote:
> ----- Original Message -----
> >On Mon, 2008-09-22 at 23:50 +0900, kamezawa.hiroyu@jp.fujitsu.com wrote:
> >> ----- Original Message -----
> >> >> +			spin_lock_irqsave(&mz->lru_lock, flags);
> >> >> +		} else {
> >> >> +			unlock_page(page);
> >> >> +			put_page(page);
> >> >> +		}
> >> >> +		if (atomic_read(&mem->css.cgroup->count) > 0)
> >> >> +			break;
> >> >>  	}
> >> >>  	spin_unlock_irqrestore(&mz->lru_lock, flags);
> >> >
> >> >do _NOT_ use yield() ever! unless you know what you're doing, and
> >> >probably not even then.
> >> >
> >> >NAK!
> >> Hmm, sorry. cond_resched() is ok ?
> >
> >depends on what you want to do, please explain what you're trying to do.
> >
> Sorry again.
> 
> This force_empty is called only in following situation
>  - there is no user threas in this cgroup.
>  - a user tries to rmdir() this cgroup or explicitly type
>    echo 1 > ../memory.force_empty.
> 
> force_empty() scans lru list of this cgroup and check page_cgroup on the
> list one by one. Because there are no tasks in this group, force_empty can
> see following racy condtions while scanning.
> 
>  - global lru tries to remove the page which pointed by page_cgroup 
>    and it is not-on-LRU.

So you either skip the page because it already got un-accounted, or you
retry because its state is already updated to some new state.

>  - the page is locked by someone.
>    ....find some lock contetion with invalidation/truncate.

Then you just contend the lock and get woken when you obtain?

>  - in later patch, page_cgroup can be on pagevec(i added) and we have to drain
>    it to remove from LRU.

Then unlock, drain, lock, no need to sleep some arbitrary amount of time
[0-inf).

> In above situation, force_empty() have to wait for some event proceeds.
> 
> Hmm...detecting busy situation in loop and sleep in out-side-of-loop
> is better ? Anyway, ok, I'll rewrite this.

The better solution is to wait for events in a non-polling fashion, for
example by using wait_event().

yield() might not actually wait at all, suppose you're the highest
priority FIFO task on the system - if you used yield and rely on someone
else to run you'll deadlock.

Also, depending on sysctl_sched_compat_yield, SCHED_OTHER tasks using
yield() can behave radically different.

> BTW, sched.c::yield() is for what purpose now ?

There are some (lagacy) users of yield, sadly they are all incorrect,
but removing them is non-trivial for various reasons.

The -rt kernel has 2 sites where yield() is the correct thing to do. In
both cases its where 2 SCHED_FIFO-99 tasks (migration and stop_machine)
depend on each-other.

