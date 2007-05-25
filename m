Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbXEYNIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbXEYNIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXEYNIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:08:44 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:34929 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbXEYNIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:08:44 -0400
Message-ID: <4656DF0C.9090306@sw.ru>
Date: Fri, 25 May 2007 17:05:16 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, tingy@cs.umass.edu,
       wli@holomorphy.com, ckrm-tech@lists.sourceforge.net, efault@gmx.de,
       pwil3058@bigpond.net.au, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, Guillaume Chazarain <guichaz@yahoo.fr>,
       tong.n.li@intel.com, containers@lists.osdl.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC] [PATCH 0/3] Add group fairness to CFS
References: <20070523164859.GA6595@in.ibm.com>	<3d8471ca0705231112rfac9cfbt9145ac2da8ec1c85@mail.gmail.com>	<20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr>	<20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu>
In-Reply-To: <20070525082951.GA25280@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> 
> 
>>Can you repeat your tests with this patch pls? With the patch applied, 
>>I am now getting the same split between nice 0 and nice 10 task as 
>>CFS-v13 provides (90:10 as reported by top )
>>
>> 5418 guest     20   0  2464  304  236 R   90  0.0   5:41.40 3 hog
>> 5419 guest     30  10  2460  304  236 R   10  0.0   0:43.62 3 nice10hog
> 
> 
> btw., what are you thoughts about SMP?
> 
> it's a natural extension of your current code. I think the best approach 
> would be to add a level of 'virtual CPU' objects above struct user. (how 
> to set the attributes of those objects is open - possibly combine it 
> with cpusets?)

> That way the scheduler would first pick a "virtual CPU" to schedule, and 
> then pick a user from that virtual CPU, and then a task from the user. 

don't you mean the vice versa:
first use to scheduler, then VCPU (which is essentially a runqueue or rbtree),
then a task from VCPU?

this is the approach we use in OpenVZ and if you don't mind
I would propose to go this way for fair-scheduling in mainstream.
It has it's own advantages and disatvantages.

This is not the easy way to go and I can outline the problems/disadvantages
which appear on this way:
- tasks which bind to CPU mask will bind to virtual CPUs.
  no problem with user tasks, but some kernel threads
  use this to do CPU-related management (like cpufreq).
  This can be fixed using SMP IPI actually.
- VCPUs should no change PCPUs very frequently,
  otherwise there is some overhead. Solvable.

Advantages:
- High precision and fairness.
- Allows to use different group scheduling algorithms
  on top of VCPU concept.
  OpenVZ uses fairscheduler with CPU limiting feature allowing
  to set maximum CPU time given to a group of tasks.

> To make group accounting scalable, the accounting object attached to the 
> user struct should/must be per-cpu (per-vcpu) too. That way we'd have a 
> clean hierarchy like:
> 
>   CPU #0 => VCPU A [ 40% ] + VCPU B [ 60% ]
>   CPU #1 => VCPU C [ 30% ] + VCPU D [ 70% ]

how did you select these 40%:60% and 30%:70% split?

>   VCPU A => USER X [ 10% ] + USER Y [ 90% ]
>   VCPU B => USER X [ 10% ] + USER Y [ 90% ]
>   VCPU C => USER X [ 10% ] + USER Y [ 90% ]
>   VCPU D => USER X [ 10% ] + USER Y [ 90% ]
> 
> the scheduler first picks a vcpu, then a user from a vcpu. (the actual 
> external structure of the hierarchy should be opaque to the scheduler 
> core, naturally, so that we can use other hierarchies too)
> 
> whenever the scheduler does accounting, it knows where in the hierarchy 
> it is and updates all higher level entries too. This means that the 
> accounting object for USER X is replicated for each VCPU it participates 
> in.

So if 2 VCPUs running on 2 physical CPUs do accounting the have to update the same
user X accounting information which is not per-[v]cpu?

> SMP balancing is straightforward: it would fundamentally iterate through 
> the same hierarchy and would attempt to keep all levels balanced - i 
> abstracted away its iterators already.

Thanks,
Kirill
