Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYIYPaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYIYPaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYIYP3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:29:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38899 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbYIYP3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:29:52 -0400
Date: Thu, 25 Sep 2008 08:29:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Corey Minyard <minyard@acm.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
Message-ID: <20080925152936.GF6725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080924172827.GA1573@minyard.local> <20080924124006.6bb41b49@extreme> <48DAA71C.5030000@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DAA71C.5030000@acm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 03:46:20PM -0500, Corey Minyard wrote:
> Stephen Hemminger wrote:
>>   
>>>   static inline void udp_lib_unhash(struct sock *sk)
>>>  {
>>> -	write_lock_bh(&udp_hash_lock);
>>> -	if (sk_del_node_init(sk)) {
>>> +	spin_lock_bh(&udp_hash_wlock);
>>> +	if (sk_del_node_rcu(sk)) {
>>>  		inet_sk(sk)->num = 0;
>>>  		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
>>>  	}
>>> -	write_unlock_bh(&udp_hash_lock);
>>> +	spin_unlock_bh(&udp_hash_wlock);
>>> +	synchronize_sched();
>>>     
>>
>> Could this be synchronize_rcu? You are using rcu_read_lock() protected 
>> sections.
>>   
> I meant to comment on that.  I wasn't sure which to use, so I chose the 
> more conservative approach.  synchronize_rcu() might be appropriate.

You do indeed need to match the update-side and read-side primitives:

	Update-side				Read-side

	synchronize_rcu()			rcu_read_lock()
	call_rcu()				rcu_read_unlock()

	call_rcu_bh()				rcu_read_lock_bh()
						rcu_read_unlock_bh()

	synchronize_sched()			preempt_disable()
						preempt_enable()
						[and anything else
						 that disables either
						 preemption or irqs]

	synchronize_srcu()			srcu_read_lock()
						srcu_read_unlock()


Mixing RCU or RCU-SCHED with RCU-BH will fail in Classic RCU systems,
while mixing RCU or RCU-BH with RCU-SCHED will fail in preemptable RCU
systems.  Mixing SRCU with any of the other flavors of RCU will fail
on any system.

So please match them up correctly!

							Thanx, Paul
