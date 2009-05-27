Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZE0Fke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZE0Fke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZE0FkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:40:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56319 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbZE0FkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:40:19 -0400
Message-ID: <4A1CD17F.1000208@cn.fujitsu.com>
Date: Wed, 27 May 2009 13:37:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davem@davemloft.net, dada1@cosmosbay.com, zbr@ioremap.net,
       jeff.chua.linux@gmail.com, paulus@samba.org, jengelh@medozas.de,
       r000n@r000n.net, benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v7 expedited "big hammer" RCU grace periods
References: <20090522190525.GA13286@linux.vnet.ibm.com> <4A1A3C23.8090004@cn.fujitsu.com> <20090525164446.GD7168@linux.vnet.ibm.com> <4A1B3FFB.7090306@cn.fujitsu.com> <20090526012843.GF7168@linux.vnet.ibm.com> <20090526154625.GA8662@linux.vnet.ibm.com> <4A1C9DFF.70708@cn.fujitsu.com> <20090527043001.GD6882@linux.vnet.ibm.com>
In-Reply-To: <20090527043001.GD6882@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> OK, good point!  I do need to think about this.
> 
> In the meantime, where do you see a need to run
> synchronize_sched_expedited() from within a hotplug CPU notifier?
> 
> 						Thanx, Paul
> 

I don't worry about synchronize_sched_expedited() called
from within a hotplug CPU notifier:

1st synchronize_sched_expedited() is newly, nobody calls it before current.
2nd get_online_cpus() will not cause DEADLOCK in CPU notifier:
	get_online_cpus() finds itself owns the cpu_hotplug.lock, it will
	not take it again.

I worry DEADLOCK like this:(ABBA DEADLOCK)
> get_online_cpus() is a large lock, a lot's of lock in kernel is required
> after cpu_hotplug.lock.
> 
> _cpu_down()
> 	cpu_hotplug_begin()
> 		mutex_lock(&cpu_hotplug.lock)
> 	__raw_notifier_call_chain(CPU_DOWN_PREPARE)
> 		Lock a-kernel-lock.
> 
> It means when we have held a-kernel-lock, we can not call
> synchronize_sched_expedited(). get_online_cpus() narrows
> synchronize_sched_expedited()'s usages.

One thread calls _cpu_down() which do "mutex_lock(&cpu_hotplug.lock)"
and then do "Lock a-kernel-lock", other thread calls
synchronize_sched_expedited() with a-kernel-lock held,
ABBA DEADLOCK would happen:

thread 1                            |        thread 2
_cpu_down()                         |    Lock a-kernel-lock. 
  mutex_lock(&cpu_hotplug.lock)     |    synchronize_sched_expedited()
------------------------------------------------------------------------
  Lock a-kernel-lock.(wait thread2) |       mutex_lock(&cpu_hotplug.lock)
                                            (wait thread 1)


cpuset_lock() is an example of a-kernel-lock as described before.
cpuset_lock() is required in CPU notifier.

But some work in cpuset need get_online_cpus().
(cpuset_lock() and then get_online_cpus(), we can
not release cpuset_lock() temporarily)

The fix is putting this work done in workqueue.
(get_online_cpus() and then cpuset_lock());

Thanx.
Lai

