Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYIVPoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYIVPoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYIVPoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:44:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33284 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYIVPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:44:14 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <33417579.1222098201726.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 23 Sep 2008 00:43:21 +0900 (JST)
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Re: Re: Re: [PATCH 4/13] memcg: force_empty moving account
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1222097568.16700.33.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <1222097568.16700.33.camel@lappy.programming.kicks-ass.net>
 <1222095363.16700.15.camel@lappy.programming.kicks-ass.net>
	 <1222093420.16700.2.camel@lappy.programming.kicks-ass.net>
	 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922200025.49ea6d70.kamezawa.hiroyu@jp.fujitsu.com>
	 <19184326.1222095015978.kamezawa.hiroyu@jp.fujitsu.com>
	 <28237198.1222095970373.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>> This force_empty is called only in following situation
>>  - there is no user threas in this cgroup.
>>  - a user tries to rmdir() this cgroup or explicitly type
>>    echo 1 > ../memory.force_empty.
>> 
>> force_empty() scans lru list of this cgroup and check page_cgroup on the
>> list one by one. Because there are no tasks in this group, force_empty can
>> see following racy condtions while scanning.
>> 
>>  - global lru tries to remove the page which pointed by page_cgroup 
>>    and it is not-on-LRU.
>
>So you either skip the page because it already got un-accounted, or you
>retry because its state is already updated to some new state.
>
>>  - the page is locked by someone.
>>    ....find some lock contetion with invalidation/truncate.
>
>Then you just contend the lock and get woken when you obtain?
>
>>  - in later patch, page_cgroup can be on pagevec(i added) and we have to dr
ain
>>    it to remove from LRU.
>
>Then unlock, drain, lock, no need to sleep some arbitrary amount of time
>[0-inf).
>
>> In above situation, force_empty() have to wait for some event proceeds.
>> 
>> Hmm...detecting busy situation in loop and sleep in out-side-of-loop
>> is better ? Anyway, ok, I'll rewrite this.
>
>The better solution is to wait for events in a non-polling fashion, for
>example by using wait_event().
>
Hmm,
spin_unlock -> wait_on_page_locked() -> break loop or spin_lock and retry
will be a candidates. I'll see how it looks.

>yield() might not actually wait at all, suppose you're the highest
>priority FIFO task on the system - if you used yield and rely on someone
>else to run you'll deadlock.
>
Oh, I missed that. ok. yield() here is bad.

>Also, depending on sysctl_sched_compat_yield, SCHED_OTHER tasks using
>yield() can behave radically different.
>
>> BTW, sched.c::yield() is for what purpose now ?
>
>There are some (lagacy) users of yield, sadly they are all incorrect,
>but removing them is non-trivial for various reasons.
>
>The -rt kernel has 2 sites where yield() is the correct thing to do. In
>both cases its where 2 SCHED_FIFO-99 tasks (migration and stop_machine)
>depend on each-other.
>

Thank you for kindly advices. I'll rewrite.

Regards,
-Kame

