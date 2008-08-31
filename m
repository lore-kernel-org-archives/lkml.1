Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYHaSS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYHaSS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYHaSSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:18:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbYHaSSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:18:50 -0400
Message-ID: <48BAE082.3000300@colorfullife.com>
Date: Sun, 31 Aug 2008 20:18:42 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, rostedt@goodmis.org,
       peterz@infradead.org, benh@kernel.crashing.org, davem@davemloft.net,
       tony.luck@intel.com
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <48B919C2.1040809@cn.fujitsu.com> <48B94BF4.9090103@colorfullife.com> <20080830143438.GF7107@linux.vnet.ibm.com> <48BA7944.8070402@colorfullife.com> <20080831172001.GA7015@linux.vnet.ibm.com> <48BAD89E.20206@colorfullife.com> <20080831175514.GE7015@linux.vnet.ibm.com>
In-Reply-To: <20080831175514.GE7015@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Sun, Aug 31, 2008 at 07:45:02PM +0200, Manfred Spraul wrote:
>   
>> Paul E. McKenney wrote:
>>     
>>> Assuming that the ordering of processing pending irqs and marking the
>>> CPU offline in cpu_online_mask can be resolved as noted above, it should
>>> work fine -- if a CPU's bit is clear, we can safely ignore it.  The race
>>> can be resolved by checking the CPU's bit in force_quiescent_state().
>>>
>>> Or am I missing something?
>>>   
>>>       
>> Yes, that would work:
>> Rule 1: after CPU_DEAD, a cpu is gone. The cpu is quiet, rcu callbacks must 
>> be moved to other cpus, ...
>> Rule 2: if a cpu is not listed in cpu_online_mask, then it can be 
>> considered as outside a read-side critical section.
>>
>> The problem with rule 2 is that it means someone [force_quiescent_state()] 
>> must poll the cpu_online_mask and look for changes.
>> I'd really prefer a notifier. CPU_DYING is nearly the correct thing, it 
>> only has to be moved down 3 lines ;-)
>> (I want to kill the bitmaps, not add a hierarchical bitmap polling system!)
>>     
>
> But some later CPU_DYING notifier might decide that the CPU cannot be
> removed after all, which would mean bringing the CPU back.  And then
> whatever the CPU was needed for might have actually happened in the
> meantime, which does not sound good to me...
>   
CPU_DYING must not fail, the current code doesn't support that.

--
    Manfred
