Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZEYFWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZEYFWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZEYFWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:22:20 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39240 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZEYFWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:22:19 -0400
Message-ID: <4A1A2AFA.8020605@cosmosbay.com>
Date: Mon, 25 May 2009 07:22:02 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@lhnet.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Denys Fedoryschenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux kernel <linux-kernel@vger.kernel.org>, damien.wyart@free.fr
Subject: Re: regression: unregister_netdev() unusably slow
References: <20090524192150.GE24757@kvack.org> <200905250023.31056.denys@visp.net.lb> <20090524213744.GG24757@kvack.org> <4A19BF39.4000305@cosmosbay.com> <20090524214433.GH24757@kvack.org> <4A19C50B.9040304@cosmosbay.com> <20090524221240.GI24757@kvack.org> <4A19CE8B.3070302@cosmosbay.com> <20090525000050.GJ24757@kvack.org>
In-Reply-To: <20090525000050.GJ24757@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 25 May 2009 07:22:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise a écrit :
> On Mon, May 25, 2009 at 12:47:39AM +0200, Eric Dumazet wrote:
>> There is a strong dependancy against HZ
>> BTW, I am using TREE_RCU
> 
> I'm using CLASSIC_RCU.  The bisect just completed, and it points to RCU.  
> It makes some degree of sense since I'm testing on an otherwise idle 
> machine.  That said, where is fixing it going to make sense?  I'm not 
> opposed to having device unregister take a few timer ticks, but there 
> has to be some way of exposing parallelism to the system, and since the 
> synchronize_net() calls are done under rntl_lock(), none is possible at 
> present.  Hrm.

Thanks Ben, this bisection indeed confirms how nasty synchronize_rcu() is :)

Time to include Paul and lkml in the discussion, and find a better solution than 
one provided in February.

> 
> 		-ben
> 
> bf51935f3e988e0ed6f34b55593e5912f990750a is first bad commit
> commit bf51935f3e988e0ed6f34b55593e5912f990750a
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Tue Feb 17 06:01:30 2009 -0800
> 
>     x86, rcu: fix strange load average and ksoftirqd behavior
>     
>     Damien Wyart reported high ksoftirqd CPU usage (20%) on an
>     otherwise idle system.
>     
>     The function-graph trace Damien provided:
> ...
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> 
> index a546f55..bd4da2a 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -104,9 +104,6 @@ void cpu_idle(void)
>  			check_pgt_cache();
>  			rmb();
>  
> -			if (rcu_pending(cpu))
> -				rcu_check_callbacks(cpu, 0);
> -
>  			if (cpu_is_offline(cpu))
>  				play_dead();
>  
> 
> --

Paul, this commit makes net device unregister very slow (more than 100 ms
 if CONFIG_NO_HZ is set), while it used to be pretty fast in previous kernels.

Quoting Ben : 
" I just ran a few L2TP tests against 2.6.30-rc7, and it looks like network 
  device deletion has become unusably slow.  At least in 2.6.27.10, deleting 
  1000 network interfaces takes less than 2 seconds of real time.  The same 
  test run under 2.6.30-rc7 is taking hundreds of seconds to delete 1000 
  interfaces at a rate of about 5 per second.  The interfaces all share the 
  same local ip address, but each have a single route to a unique client 
  ip address."

Device unregister is a synchronize_rcu() abuser (three calls to dismantle
a vlan...) so delaying rcu callbacks can be pretty expensive for it.

I wonder if the real root of the problem was not discovered in the meantime,
by commit 64ca5ab913f1594ef316556e65f5eae63ff50cee
rcu: increment quiescent state counter in ksoftirqd()

Maybe this commit solved Damien Wyart problem as well, and we can revert
commit bf51935f3e988e0ed6f34b55593e5912f990750a ?

Thank you

