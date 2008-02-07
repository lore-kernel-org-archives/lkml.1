Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbYBGSD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbYBGSD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 13:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbYBGSDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 13:03:06 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:43203 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612AbYBGSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 13:03:04 -0500
Message-ID: <47AB47C1.1070208@qualcomm.com>
Date: Thu, 07 Feb 2008 10:02:41 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] CPU isolation extensions
References: <47AA9807.7090402@qualcomm.com>	<20080206215805.17a0c919.akpm@linux-foundation.org> <20080207015954.92cd3878.pj@sgi.com>
In-Reply-To: <20080207015954.92cd3878.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Andrew wrote:
>>  (and bear in mind that Paul has a track record of being wrong
>>  on this :))
> 
> heh - I saw that <grin>.
> 
> Max - Andrew's about right, as usual.  You answered my initial
> questions on this patch set adequately, but hard real time is
> not my expertise, so in the final analysis, other than my saying
> I don't have any more objections, my input doesn't mean much
> either way.

I honestly think this one is no brainer and I do not think this one will hurt Paul's track record :).
Paul initially disagreed with me and that's when he was wrong ;-))
 
Andrew, I looked at this in detail and here is an explanation that 
I sent to Paul a few days ago (a bit shortened/updated version).

--------
I thought some more about your proposal to use sched_load_balance flag in cpusets instead of extending 
cpu_isolated_map. I looked at the cpusets, cgroups and here are my thoughts on this.
Here is the list of issues with sched_load_balance flag from CPU isolation perspective:
-- 
(1) Boot time isolation is not possible. There is currently no way to setup a cpuset at
boot time. For example we won't be able to isolate cpus from irqs and workqueues at boot.
Not a major issue but still an inconvenience.

-- 
(2) There is currently no easy way to figure out what cpuset a cpu belongs to in order to query 
it's sched_load_balance flag. In order to do that we need a method that iterates all active cpusets 
and checks their cpus_allowed masks. This implies holding cgroup and cpuset mutexes. It's not clear 
whether it's ok to do that from the the contexts CPU isolation happens in (apic, sched, workqueue). 
It seems that cgroup/cpuset api is designed from top down access. ie adding a cpu to a set and then 
recomputing domains. Which makes perfect sense for the common cpuset usecase but is not what cpu 
isolation needs.
In other words I think it's much simpler and cleaner to use the cpu_isolated_map for isolation
purposes. No locks, no races, etc.

-- 
(3) cpusets are a bit too dynamic  :) . What I mean by this is that sched_load_balance flag
can be changed at any time without bringing a CPU offline. What that means is that we'll
need some notifier mechanisms for killing and restarting workqueue threads when that flag changes. 
Also we'd need some logic that makes sure that a user does not disable load balancing on all cpus 
because that effectively will kill workqueues on all the cpus.
This particular case is already handled very nicely in my patches. Isolated bit can be set
only when cpu is offline and it cannot be set on the first online cpu. Workqueus and other
subsystems already handle cpu hotplug events nicely and can easily ignore isolated cpus when
they come online.

--
#1 is probably unfixable. #2 and #3 can be fixed but at the expense of extra complexity across
the board. I seriously doubt that I'll be able to push that through the reviews ;-).

Also personally I still think cpusets and cpu isolation attack two different problems. cpusets is about 
partitioning cpus and memory nodes, and managing tasks. Most of the cgroups/cpuset APIs are designed to 
deal with tasks. 
CPU isolation is much simpler and is at the lower layer. It deals with IRQs, kernel per cpu threads, etc. 
The only intersection I see is that both features affect scheduling domains. CPU isolation is again 
simple here it uses existing logic in sched.c it does not change anything in this area. 

---------

Andrew, hopefully that clarifies it. Let me know if you're not convinced.

Max
