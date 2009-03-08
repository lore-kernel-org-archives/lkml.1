Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZCHDGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZCHDGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 22:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZCHDGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 22:06:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53069 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZCHDGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 22:06:24 -0500
Message-ID: <49B335F6.2030509@cn.fujitsu.com>
Date: Sun, 08 Mar 2009 11:05:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu_barrier VS cpu_hotplug: make rcu_barrier can be	called
 on CPU_DEAD
References: <49B2526C.5070503@cn.fujitsu.com> <20090307172019.GG10625@linux.vnet.ibm.com>
In-Reply-To: <20090307172019.GG10625@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Sat, Mar 07, 2009 at 06:54:36PM +0800, Lai Jiangshan wrote:
>> cpu hotplug notifier_call for CPU_DEAD are very complex, some notifier_call
>> may call rcu_barrier(), if this notifier_call is called earlier than
>> rcu_cpu_notify(), it is buggy.
>>
>> _cpu_down() -->
>> 	some_cpu_hotplug_notify() -->
>> 		case CPU_DEAD: rcu_barrier()
>> 	rcu_cpu_notify() -->
>> 		rcu_offline_cpu()
>>
>> When rcu_barrier() is called, rcu_barrier() does not know how to finish
>> his work: rcu callbacks in dead cpu have not been migrated to online cpu,
>> so rcu_barrier() cannot wait for these rcu callbacks, but rcu_barrier()
>> should wait for all queued rcu callbacks.
> 
> Hmmm...
> 
> What should happen in this case is that rcu_offline_cpu() moves the
> rcu_barrier() callback to a surviving CPU, and then the rcu_barrier()

It's not about the rcu_barrier() callback, It's about rcu callbacks
in dead cpu. rcu_barrier() should also wait for these rcu callbacks
to complete. But these rcu callbacks are not migrated to online cpu,
rcu_barrier() cannot wait for them.

Thanks, Lai.


> should complete just fine at the end of a subsequent grace period.
> In fact, this is why it is so important to keep RCU callbacks ordered
> through CPU-hotplug operations.
> 
> Or do you have a test that demonstrates a failure in this case?
> If so, please share!
> 
