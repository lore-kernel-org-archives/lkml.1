Return-Path: <linux-kernel-owner+w=401wt.eu-S933619AbZHHHix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619AbZHHHix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 03:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933432AbZHHHiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 03:38:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57657 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbZHHHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 03:38:51 -0400
Message-ID: <99f2a13990d68c34c76c33581949aefd.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090808060531.GL9686@balbir.in.ibm.com>
References: <20090807221238.GJ9686@balbir.in.ibm.com>
    <39eafe409b85053081e9c6826005bb06.squirrel@webmail-b.css.fujitsu.com>
    <20090808060531.GL9686@balbir.in.ibm.com>
Date: Sat, 8 Aug 2009 16:38:46 +0900 (JST)
Subject: Re: Help Resource Counters Scale Better (v2)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, andi.kleen@intel.com,
       "Prarit Bhargava" <prarit@redhat.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-08
> 10:11:40]:
>
>> Balbir Singh wrote:

>> >  static inline bool res_counter_limit_check_locked(struct res_counter
>> > *cnt)
>> >  {
>> > -	if (cnt->usage < cnt->limit)
>> > +	unsigned long long usage =
>> percpu_counter_read_positive(&cnt->usage);
>> > +	if (usage < cnt->limit)
>> >  		return true;
>> >
>> Hmm. In memcg, this function is not used for busy pass but used for
>> important pass to check usage under limit (and continue reclaim)
>>
>> Can't we add res_clounter_check_locked_exact(), which use
>> percpu_counter_sum() later ?
>
> We can, but I want to do it in parts, once I add the policy for
> strict/no-strict checking. It is on my mind, but I want to work on the
> overhead, since I've heard from many people that we need to resolve
> this first.
>
ok.

>> >  	spin_lock_irqsave(&cnt->lock, flags);
>> > -	if (cnt->usage <= limit) {
>> > +	if (usage <= limit) {
>> >  		cnt->limit = limit;
>> >  		ret = 0;
>> >  	}
>>
>> For the same reason to check_limit, I want correct number here.
>> percpu_counter_sum() is better.
>>
>
> I'll add that when we do strict accounting. Are you suggesting that
> resource_counter_set_limit should use strict accounting?

yes, I think so.
..and..I'd like to add "mem_cgroup_reduce_usage" or some call
to do reclaim-on-demand, later.

I wonder it's ok to add error-tolerance to memcg but I want some
interface to do "sync". Especially when, we measure size of working set.

I like current your direction to achieve better performance.
But I  wonder how users can see synchronous numbers without tolerance,
it will be necessary in high-end users.

	goto undo;
>> > @@ -68,9 +76,7 @@ int res_counter_charge(struct res_counter *counter,
>> > unsigned long val,
>> >  	goto done;
>> >  undo:
>> >  	for (u = counter; u != c; u = u->parent) {
>> > -		spin_lock(&u->lock);
>> >  		res_counter_uncharge_locked(u, val);
>> > -		spin_unlock(&u->lock);
>> >  	}
>> >  done:

>> When using hierarchy, tolerance to root node will be bigger.
>> Please write this attention to the document.
>>
>
> No.. I don't think so..
>
> Irrespective of hierarchy, we do the following
>
> 1. Add, if the sum reaches batch count, we sum and save
>
> I don't think hierarchy should affect it.. no?
>
Hmm, maybe I'm misunderstanding. Let me brainstoming...

In following hierarchy,

   A/01
    /02
    /03/X
       /Y
       /Z
 sum of tolerance of X+Y+Z is limitted by torelance of 03.
 sum of tolerance of 01+02+03 is limited by tolerance of A

Ah, ok. I'm wrong. Hmm...


>
>>
>> >  	local_irq_restore(flags);
>> > @@ -79,10 +85,13 @@ done:
>> >
>> >  void res_counter_uncharge_locked(struct res_counter *counter,
>> unsigned
>> > long val)
>> >  {
>> > -	if (WARN_ON(counter->usage < val))
>> > -		val = counter->usage;
>> > +	unsigned long long usage;
>> > +
>> > +	usage = percpu_counter_read_positive(&counter->usage);
>> > +	if (WARN_ON((usage + counter->usage_tolerance * nr_cpu_ids) < val))
>> > +		val = usage;
>> Is this correct ? (or do we need this WARN_ON ?)
>> Hmm. percpu_counter is cpu-hotplug aware. Then,
>> nr_cpu_ids is not correct. but nr_onlie_cpus() is heavy..hmm.
>>
>
> OK.. so the deal is, even though it is aware, batch count is a
> heuristic and I don't want to do heavy math in it. nr_cpu_ids is
> larger, but also light weight in terms of computation.
>
yes...I wonder there is a _variable_ to show nr_online_cpus without
bitmap scan...


>> >  /*
>> > + * To help resource counters scale, we take a step back
>> > + * and allow the counters to be scalable and set a
>> > + * batch value such that every addition does not cause
>> > + * global synchronization. The side-effect will be visible
>> > + * on limit enforcement, where due to this fuzziness,
>> > + * we will lose out on inforcing a limit when the usage
>> > + * exceeds the limit. The plan however in the long run
>> > + * is to allow this value to be controlled. We will
>> > + * probably add a new control file for it.
>> > + */
>> > +#define MEM_CGROUP_RES_ERR_TOLERANCE (4 * PAGE_SIZE)
>>
>> Considering percpu counter's extra overhead. This number is too small,
>> IMO.
>>
>
> OK.. the reason I kept it that way is because on ppc64 PAGE_SIZE is
> now 64k. May be we should pick a standard size like 64k and stick with
> it. What do you think?
>
I think 64k is reasonanle as far as there is no monster machine with
4096 cpus...But even with 4096cpus
64k*4096 = 256M...then, small amount for monster machine..

Hmm...I think you can add CONFIG_MEMCG_PCPU_TOLERANCE and
set default value to 64k. (of course, you can do this in other patch)

On laptop/desktop, 4cpus
 4*64k=256k

On volume-zone server, 8-16,32cpus
 32*64k=2M

On high-end 64-256cpu machine in these days,
 256*64k=16M

maybe not so bad. I'm not sure how many 1024cpu machines will
be used in the the next ten years..

I want a percpu counter with flexible batching for minimizing tolerance.
It will be my homework.

Thanks,
-Kame


64kx256 = 16M ...maybe reasonable.


