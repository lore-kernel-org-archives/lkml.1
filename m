Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYHMIwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYHMIwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYHMIwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:52:40 -0400
Received: from mga06.intel.com ([134.134.136.21]:45841 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbYHMIwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:52:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,200,1217833200"; 
   d="scan'208";a="428800861"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <1218180605.8625.64.camel@twins>
References: <1217489463.25608.157.camel@ymzhang>
	 <1217489949.8157.78.camel@twins> <1217490560.25608.168.camel@ymzhang>
	 <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
	 <1217828278.25608.206.camel@ymzhang>
	 <20080804055339.GB5444@linux.vnet.ibm.com> <1217831171.9016.42.camel@twins>
	 <20080804070508.GA4028@linux.vnet.ibm.com> <1217833939.9016.47.camel@twins>
	 <1912217169.25608.228.camel@ymzhang>  <1218180605.8625.64.camel@twins>
Content-Type: text/plain
Date: Tue, 13 Aug 2030 16:50:42 +0800
Message-Id: <1912841442.25608.284.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-08-08 at 09:30 +0200, Peter Zijlstra wrote:
> On Tue, 2030-08-06 at 11:26 +0800, Zhang, Yanmin wrote:
> > On Mon, 2008-08-04 at 09:12 +0200, Peter Zijlstra wrote:
> > > On Mon, 2008-08-04 at 12:35 +0530, Dhaval Giani wrote:
> > > > On Mon, Aug 04, 2008 at 08:26:11AM +0200, Peter Zijlstra wrote:
> > > > > On Mon, 2008-08-04 at 11:23 +0530, Dhaval Giani wrote:
> > > > > 
> > > > > > Peter, vatsa, any ideas?
> > > > > 
> > > > > ---
> > > > > 
> > > > > Revert:
> > > > >   a7be37ac8e1565e00880531f4e2aff421a21c803  sched: revert the revert of: weight calculations
> > > > >   c9c294a630e28eec5f2865f028ecfc58d45c0a5a  sched: fix calc_delta_asym()
> > > > >   ced8aa16e1db55c33c507174c1b1f9e107445865  sched: fix calc_delta_asym, #2
> > > > > 
> > > > 
> > > > Did we not fix those? :) 
> > > 
> > > Works for me,.. just guessing here.
> > I did more investigation on 16-core tigerton.
> > 
> > Firstly, let's focus on CONFIG_GROUP_SCHED=n. With 2.6.26, the result
> > has little difference
> > between with and without CONFIG_GROUP_SCHED.
> > 
> > 1) I tried different sched_features and found AFFINE_WAKEUPS has big
> > impact on volanoMark. Other
> > features have little impact.
> > 
> > 2) With kernel 2.6.26, if disabling AFFINE_WAKEUPS, the result is
> > 260000; if enabling AFFINE_WAKEUPS,
> > the result is 515000, so the improvement caused by AFFINE_WAKEUPS is
> > about 100%. With kernel 2.6.27-rc1,
> > the improvement is only about 25%.
> > 
> > 3) I turned on CONFIG_SCHETSTATS in kernel and collect
> > ttwu_move_affine. Mostly, collect ttwu_move_affine,
> > then recollect it after 30 seconds and calculate the difference. With
> > 2.6.26, I got below data:
> 
> <snip data>
> 
> > So with kernel 2.6.27-rc1, the successful wakeup_affine is about
> > double of the one of 2.6.27-rc1
> > on domain 0, but about 10 times on domain 1. That means more tasks are
> > woken up on waker cpus.
> > 
> > Does that mean it doesn't follow cache-hot checking?
> 
> I'm a bit puzzled, but you're right - I too noticed that volanomark is
> _very_ sensitive to affine wakeups.
> 
> I'll try and find what changed in that code for GROUP=n.
I collect more data and find CPU_NEWLY_IDLE balance schedstat looks abnormal.
Comparing with 2.6.26, 2.6.27-rc1 has more successful move_tasks among cpu runqueue. I
instrument kernel and find that, with 2.6.26, mostly task is hot when kernel tries to
move it to another cpu. But with 2.6.27-rc1, task is often moved successfully.
If I set /proc/sys/kernel/sched_migration_cost=1500000 (default is 500000), volanoMark
result is improved significantly, near to the result of 2.6.26. Above testing set
CONFIG_GROUP_SCHED=n. So perhaps some key data structures are changed with 2.6.27-rc1
to create more cache misses. With 2.6.26, cpu idle is about 6~7%. With 2.6.27-rc1, cpu idle
is about 1%. I compare the 2 kernels and couldn't find what data structure change makes it.

As for CONFIG_GROUP_SCHED=y, oprofile shows tg_shares_up consumes about 8% cpu utilization
on my 16-core tigerton. If I enlarge /proc/sys/kernel/sched_shares_ratelimit, it doesn't help
volanoMark result. I check the group schedule codes and got an idea to improve it. Add
share_percent, a new var in task_group->sched_entity[i] to record the percent this task group
occupies in the parent group. share_percent is updated in walk_tg_tree. In account_entity_enqueue,
if the task entity has parent, we could just use share_percent and se->load.weight to calculate
a new weight and add the new weight to parent entity weight, in the end to runqueue load weight.
So when sched_shares_ratelimit is enlarged, various load balances still could work well. I think
volanoMark could benefit from it.

BTW, with CONFIG_GROUP_SCHED=y, hackbench has about 80% regression on my 8core+multi_thread
Montvale Itanium machine and Tulsa machines. It seems mutli-thread machines has the regression.

-yanmin


