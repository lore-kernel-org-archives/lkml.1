Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbXG0Bee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbXG0Bee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXG0BeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:34:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:1720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbXG0BeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,585,1175497200"; 
   d="scan'208";a="271149501"
Date: Thu, 26 Jul 2007 18:34:23 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: "Li, Tong N" <tong.n.li@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
In-Reply-To: <1185487225.3122.11.camel@tongli.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> 
 <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> 
 <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>  <20070725192442.GC4463@elte.hu>
  <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>  <20070726213154.GA26569@elte.hu>
 <1185487225.3122.11.camel@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to clarify that I'm not trying to push this particular code to 
the kernel. I'm a researcher. My intent was to point out that we have a 
problem in the scheduler and my dwrr algorithm can potentially help fix 
it. The patch itself was merely a proof-of-concept. I'd be thrilled if the 
algorithm can be proven useful in the real world. I appreciate the people 
who have given me comments. Since then, I've revised my algorithm/code. 
Now it doesn't require global locking but retains strong fairness 
properties (which I was able to prove mathematically).

Thank you,

   tong

On Thu, 26 Jul 2007, Li, Tong N wrote:

> On Thu, 2007-07-26 at 23:31 +0200, Ingo Molnar wrote:
>> * Tong Li <tong.n.li@intel.com> wrote:
>>
>>>> you need to measure it over longer periods of time. Its not worth
>>>> balancing for such a thing in any high-frequency manner. (we'd trash
>>>> the cache constantly migrating tasks back and forth.)
>>>
>>> I have some data below, but before that, I'd like to say, at the same
>>> load balancing rate, my proposed approach would allow us to have
>>> fairness on the order of seconds. I'm less concerned about trashing
>>> the cache. The important thing is to have a knob that allow users to
>>> trade off fairness and performance based on their needs. [...]
>>
>> such a knob already exists to a certain degree, but i havent tested its
>> full effects on SMP fairness yet. If you pull my scheduler tree:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
>>
>> and if you enable CONFIG_SCHED_DEBUG, then all the sched-domain
>> parameters become runtime tunable under /proc/sys/cpu*.
>>
>> Could you try to increase the cross-CPU rebalancing frequency and see
>> how it impacts the precision of your measurement? Tune 'min_interval'
>> and 'max_interval' down to increase the frequency of rebalancing.
>>
>> 	Ingo
>
> Yes, I'll do it when I find time. If anyone is willing to do the
> testing, please let me know and I can post my benchmark. On the other
> hand, I don't think tuning the existing knobs will help solve the
> problem. The root of the problem is that the current load balancing
> doesn't take into account how much time each task has been running and
> how much it's entitled. This is why I'm proposing a new approach for
> solving it. The new approach, as I said, will be much more fair/accurate
> than the current one even without tuning those balancing intervals
> (i.e., it's able to provide good fairness even if balancing is less
> frequent).
>
>  tong
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
