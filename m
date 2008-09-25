Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYIYTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYIYTro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYIYTrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:47:33 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:40051 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbYIYTrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:47:32 -0400
Date: Thu, 25 Sep 2008 14:21:55 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
In-reply-to: <20080925083431.3fa0f9c3@extreme>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Message-id: <48DBE4D3.9060809@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080924172827.GA1573@minyard.local>
 <20080924124006.6bb41b49@extreme>	<48DAA71C.5030000@acm.org>
 <20080925152936.GF6725@linux.vnet.ibm.com> <20080925083431.3fa0f9c3@extreme>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Thu, 25 Sep 2008 08:29:36 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>
>   
>> On Wed, Sep 24, 2008 at 03:46:20PM -0500, Corey Minyard wrote:
>>     
>>> Stephen Hemminger wrote:
>>>       
>>>>   
>>>>         
>>>>>   static inline void udp_lib_unhash(struct sock *sk)
>>>>>  {
>>>>> -	write_lock_bh(&udp_hash_lock);
>>>>> -	if (sk_del_node_init(sk)) {
>>>>> +	spin_lock_bh(&udp_hash_wlock);
>>>>> +	if (sk_del_node_rcu(sk)) {
>>>>>  		inet_sk(sk)->num = 0;
>>>>>  		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>>>>>  	}
>>>>> -	write_unlock_bh(&udp_hash_lock);
>>>>> +	spin_unlock_bh(&udp_hash_wlock);
>>>>> +	synchronize_sched();
>>>>>     
>>>>>           
>>>> Could this be synchronize_rcu? You are using rcu_read_lock() protected 
>>>> sections.
>>>>   
>>>>         
>>> I meant to comment on that.  I wasn't sure which to use, so I chose the 
>>> more conservative approach.  synchronize_rcu() might be appropriate.
>>>       
>> You do indeed need to match the update-side and read-side primitives:
>>
>> 	Update-side				Read-side
>>
>> 	synchronize_rcu()			rcu_read_lock()
>> 	call_rcu()				rcu_read_unlock()
>>
>> 	call_rcu_bh()				rcu_read_lock_bh()
>> 						rcu_read_unlock_bh()
>>
>> 	synchronize_sched()			preempt_disable()
>> 						preempt_enable()
>> 						[and anything else
>> 						 that disables either
>> 						 preemption or irqs]
>>
>> 	synchronize_srcu()			srcu_read_lock()
>> 						srcu_read_unlock()
>>
>>
>> Mixing RCU or RCU-SCHED with RCU-BH will fail in Classic RCU systems,
>> while mixing RCU or RCU-BH with RCU-SCHED will fail in preemptable RCU
>> systems.  Mixing SRCU with any of the other flavors of RCU will fail
>> on any system.
>>
>> So please match them up correctly!
>>     
Ok, will do.  I read more on this, and I think I understand the issues 
better.

>>     
>
> Also, for consistency with other parts of networking code, don't introduce
> the synchronize_sched() or synchronize_srcu() pattern to network protocols
> unless there is a no other way to achieve the desired result.
>   
Do you mean synchronize_rcu(), too?  It seems to be used in the net 
code.  To avoid that I'd need to add a struct rcu_head to struct sock.  
Would that be preferable?

Thanks,

-corey
