Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYIYUeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYIYUeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYIYUeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:34:09 -0400
Received: from mail.vyatta.com ([76.74.103.46]:48891 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbYIYUeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:34:07 -0400
Date: Thu, 25 Sep 2008 13:34:03 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Corey Minyard <minyard@acm.org>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
Message-ID: <20080925133403.400be032@speedy>
In-Reply-To: <48DBE4D3.9060809@acm.org>
References: <20080924172827.GA1573@minyard.local>
	<20080924124006.6bb41b49@extreme>
	<48DAA71C.5030000@acm.org>
	<20080925152936.GF6725@linux.vnet.ibm.com>
	<20080925083431.3fa0f9c3@extreme>
	<48DBE4D3.9060809@acm.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 14:21:55 -0500
Corey Minyard <minyard@acm.org> wrote:

> Stephen Hemminger wrote:
> > On Thu, 25 Sep 2008 08:29:36 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >
> >   
> >> On Wed, Sep 24, 2008 at 03:46:20PM -0500, Corey Minyard wrote:
> >>     
> >>> Stephen Hemminger wrote:
> >>>       
> >>>>   
> >>>>         
> >>>>>   static inline void udp_lib_unhash(struct sock *sk)
> >>>>>  {
> >>>>> -	write_lock_bh(&udp_hash_lock);
> >>>>> -	if (sk_del_node_init(sk)) {
> >>>>> +	spin_lock_bh(&udp_hash_wlock);
> >>>>> +	if (sk_del_node_rcu(sk)) {
> >>>>>  		inet_sk(sk)->num = 0;
> >>>>>  		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> >>>>>  	}
> >>>>> -	write_unlock_bh(&udp_hash_lock);
> >>>>> +	spin_unlock_bh(&udp_hash_wlock);
> >>>>> +	synchronize_sched();
> >>>>>     
> >>>>>           
> >>>> Could this be synchronize_rcu? You are using rcu_read_lock() protected 
> >>>> sections.
> >>>>   
> >>>>         
> >>> I meant to comment on that.  I wasn't sure which to use, so I chose the 
> >>> more conservative approach.  synchronize_rcu() might be appropriate.
> >>>       
> >> You do indeed need to match the update-side and read-side primitives:
> >>
> >> 	Update-side				Read-side
> >>
> >> 	synchronize_rcu()			rcu_read_lock()
> >> 	call_rcu()				rcu_read_unlock()
> >>
> >> 	call_rcu_bh()				rcu_read_lock_bh()
> >> 						rcu_read_unlock_bh()
> >>
> >> 	synchronize_sched()			preempt_disable()
> >> 						preempt_enable()
> >> 						[and anything else
> >> 						 that disables either
> >> 						 preemption or irqs]
> >>
> >> 	synchronize_srcu()			srcu_read_lock()
> >> 						srcu_read_unlock()
> >>
> >>
> >> Mixing RCU or RCU-SCHED with RCU-BH will fail in Classic RCU systems,
> >> while mixing RCU or RCU-BH with RCU-SCHED will fail in preemptable RCU
> >> systems.  Mixing SRCU with any of the other flavors of RCU will fail
> >> on any system.
> >>
> >> So please match them up correctly!
> >>     
> Ok, will do.  I read more on this, and I think I understand the issues 
> better.
> 
> >>     
> >
> > Also, for consistency with other parts of networking code, don't introduce
> > the synchronize_sched() or synchronize_srcu() pattern to network protocols
> > unless there is a no other way to achieve the desired result.
> >   
> Do you mean synchronize_rcu(), too?  It seems to be used in the net 
> code.  To avoid that I'd need to add a struct rcu_head to struct sock.  
> Would that be preferable?
> 

synchhonize_rcu or call_rcu_bh is fine. But I worry that if the other
stricter types are used, then we would have to audit all the other RCU
usage in networking to make sure nesting was correct.
