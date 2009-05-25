Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZEYQVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZEYQVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZEYQVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:21:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46162 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZEYQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:21:34 -0400
Date: Mon, 25 May 2009 09:21:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Benjamin LaHaise <bcrl@lhnet.ca>, Denys Fedoryschenko <denys@visp.net.lb>,
       netdev@vger.kernel.org, linux kernel <linux-kernel@vger.kernel.org>,
       damien.wyart@free.fr
Subject: Re: regression: unregister_netdev() unusably slow
Message-ID: <20090525162142.GC7168@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090524192150.GE24757@kvack.org> <200905250023.31056.denys@visp.net.lb> <20090524213744.GG24757@kvack.org> <4A19BF39.4000305@cosmosbay.com> <20090524214433.GH24757@kvack.org> <4A19C50B.9040304@cosmosbay.com> <20090524221240.GI24757@kvack.org> <4A19CE8B.3070302@cosmosbay.com> <20090525000050.GJ24757@kvack.org> <4A1A2AFA.8020605@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A1A2AFA.8020605@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 07:22:02AM +0200, Eric Dumazet wrote:
> Benjamin LaHaise a écrit :
> > On Mon, May 25, 2009 at 12:47:39AM +0200, Eric Dumazet wrote:
> >> There is a strong dependancy against HZ
> >> BTW, I am using TREE_RCU
> > 
> > I'm using CLASSIC_RCU.  The bisect just completed, and it points to RCU.  
> > It makes some degree of sense since I'm testing on an otherwise idle 
> > machine.  That said, where is fixing it going to make sense?  I'm not 
> > opposed to having device unregister take a few timer ticks, but there 
> > has to be some way of exposing parallelism to the system, and since the 
> > synchronize_net() calls are done under rntl_lock(), none is possible at 
> > present.  Hrm.
> 
> Thanks Ben, this bisection indeed confirms how nasty synchronize_rcu() is :)

Yet another step in my learning what is required of RCU, it seems!  ;-)

> Time to include Paul and lkml in the discussion, and find a better solution than 
> one provided in February.

One approach would be to convert the offending synchronize_rcu() to
call_rcu(), but if this were straightforward, I would guess that you would
have already done this.  But if the code following the synchronize_rcu()
does nothing but free up old data structures, this is an easy fix.
If there are statistics or other state involved, then call_rcu() might
not be the right tool for the job.

Another approach is to apply the patch at:

	http://lkml.org/lkml/2009/5/22/332

Then replace the offending synchronize_rcu() with synchronize_rcu_expedited().
This code is still a bit on the experimental side, but tests have been
going quite well, so, unlike a week or two ago, it is definitely worth
trying out.

Do either of these approaches work for you?

							Thanx, Paul

> > 		-ben
> > 
> > bf51935f3e988e0ed6f34b55593e5912f990750a is first bad commit
> > commit bf51935f3e988e0ed6f34b55593e5912f990750a
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Tue Feb 17 06:01:30 2009 -0800
> > 
> >     x86, rcu: fix strange load average and ksoftirqd behavior
> >     
> >     Damien Wyart reported high ksoftirqd CPU usage (20%) on an
> >     otherwise idle system.
> >     
> >     The function-graph trace Damien provided:
> > ...
> > diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> > 
> > index a546f55..bd4da2a 100644
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -104,9 +104,6 @@ void cpu_idle(void)
> >  			check_pgt_cache();
> >  			rmb();
> >  
> > -			if (rcu_pending(cpu))
> > -				rcu_check_callbacks(cpu, 0);
> > -
> >  			if (cpu_is_offline(cpu))
> >  				play_dead();
> >  
> > 
> > --
> 
> Paul, this commit makes net device unregister very slow (more than 100 ms
>  if CONFIG_NO_HZ is set), while it used to be pretty fast in previous kernels.
> 
> Quoting Ben : 
> " I just ran a few L2TP tests against 2.6.30-rc7, and it looks like network 
>   device deletion has become unusably slow.  At least in 2.6.27.10, deleting 
>   1000 network interfaces takes less than 2 seconds of real time.  The same 
>   test run under 2.6.30-rc7 is taking hundreds of seconds to delete 1000 
>   interfaces at a rate of about 5 per second.  The interfaces all share the 
>   same local ip address, but each have a single route to a unique client 
>   ip address."
> 
> Device unregister is a synchronize_rcu() abuser (three calls to dismantle
> a vlan...) so delaying rcu callbacks can be pretty expensive for it.
> 
> I wonder if the real root of the problem was not discovered in the meantime,
> by commit 64ca5ab913f1594ef316556e65f5eae63ff50cee
> rcu: increment quiescent state counter in ksoftirqd()
> 
> Maybe this commit solved Damien Wyart problem as well, and we can revert
> commit bf51935f3e988e0ed6f34b55593e5912f990750a ?
> 
> Thank you
> 
