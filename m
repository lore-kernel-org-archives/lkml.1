Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZKJJl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZKJJl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZKJJl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:41:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:40133 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZKJJl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:41:26 -0500
Subject: Re: [RFC,PATCH] mutex: mutex_is_owner() helper
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4AF8A40B.10708@gmail.com>
References: <4AF19D06.3060401@gmail.com> <20091104154015.GA32567@elte.hu>
	 <4AF1B7A7.6030902@gmail.com> <1257792987.4108.364.camel@laptop>
	 <4AF8A40B.10708@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Nov 2009 10:41:21 +0100
Message-ID: <1257846081.4648.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 00:21 +0100, Eric Dumazet wrote:
> Peter Zijlstra a écrit :
> > On Wed, 2009-11-04 at 18:19 +0100, Eric Dumazet wrote:
> >> BTW, I was thinking of a mutex_yield() implementation, but could not
> >> cook it without hard thinking, maybe you already have some nice
> >> implementation ?
> > 
> > Why? Yield sets off alarm bells, since 99.9%, and possibly more, of its
> > uses are wrong.
> 
> If I remember well, I had problems doing "modprobe dummy numdummies=30000",
> because it creates 30000 netdevices, and thanks to hotplug starts 30000 udev
> that all wait that my modprobe is finished... Nice to see load average going
> so big by the way :)

lol :-) With a bit of luck udev will spawn a python interpreter for each
of those things too..

> I tried following patch without success, because rtnl_unlock()/rtnl_lock()
> is too fast (awaken process(es) ha(s/ve) no chance to get the lock, as we
> take it immediately after releasing it)

Right, due to lock-stealing.

> diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
> index 37dcfdc..108c4fa 100644
> --- a/drivers/net/dummy.c
> +++ b/drivers/net/dummy.c
> @@ -138,8 +138,12 @@ static int __init dummy_init_module(void)
>  	rtnl_lock();
>  	err = __rtnl_link_register(&dummy_link_ops);
>  
> -	for (i = 0; i < numdummies && !err; i++)
> +	for (i = 0; i < numdummies && !err; i++) {
>  		err = dummy_init_one();
> +		rtnl_unlock();
> +		msleep(1);
> +		rtnl_lock();
> +	}
>  	if (err < 0)
>  		__rtnl_link_unregister(&dummy_link_ops);
>  	rtnl_unlock();
> 
> But if hotplug is disabled, this force a useless msleep(1) * 30000 -> this is bit slow
> 
> Yes, this code is stupid, but I use it to stress network stack
> with insane number of devices, to spot scalability problems.

Right...

> mutex_yield() could help in this situation.

Agreed, except I don't like the name, but I could be tained from
sched_yield().

> mutex is said to be FIFO, but its not exactly true : A new comer can take the mutex
> even if 10000 threads are waiting on mutex...

Yep, lock-stealing, you don't want to see the regression reports if you
'fix' that :-)

> I wont mention other problems, because mutex_{try}lock() has no timedwait variant

Nobody needed it I guess.. also I never quite understood the need for
timedwait, either you need to get the work done or you don't, not maybe.

Use mutex_lock_interruptible() and set a timer or something.

> , and funny code doing :
> 
> if (!rtnl_trylock())
> 	return restart_syscall();
> 
> Making 30000 processes running/fighting to get the mutex :(

Funny definition of funny ;-) That's some seriously fugly code there.


