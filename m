Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbYAMT0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbYAMT0B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 14:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYAMTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 14:25:53 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:54179 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYAMTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 14:25:52 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible recursive locking, 2.6.24-rc7
Date: Sun, 13 Jan 2008 21:25:31 +0200
Message-Id: <20080113192408.M31322@visp.net.lb>
In-Reply-To: <1200249866.7999.48.camel@lappy>
References: <20080113155142.M6056@visp.net.lb> <1200241360.7999.29.camel@lappy> <1200249866.7999.48.camel@lappy>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I cannot reproduce, it is happened with rtorrent just randomly. But i will
patch and keep watching.

On Sun, 13 Jan 2008 19:44:26 +0100, Peter Zijlstra wrote
> On Sun, 2008-01-13 at 17:22 +0100, Peter Zijlstra wrote:
> > On Sun, 2008-01-13 at 17:51 +0200, Denys Fedoryshchenko wrote:
> > > Hi, got in dmesg
> > > Not sure where to send (there is TCP), so sending netdev@ and kernel@
> > 
> > It's epoll, this is a known issue and will be fixed soon. Thanks for
> > reporting.
> 
> If its easy for you to reproduce, would you mind giving the following
> patch a spin?
> 
> ---
> 
> Subject: lockdep: annotate epoll
> 
> On Sat, 2008-01-05 at 13:35 -0800, Davide Libenzi wrote:
> 
> > I remember I talked with Arjan about this time ago. Basically, since 1) 
> > you can drop an epoll fd inside another epoll fd 2) callback-based wakeups 
> > are used, you can see a wake_up() from inside another wake_up(), but they 
> > will never refer to the same lock instance.
> > Think about:
> > 
> > 	dfd = socket(...);
> > 	efd1 = epoll_create();
> > 	efd2 = epoll_create();
> > 	epoll_ctl(efd1, EPOLL_CTL_ADD, dfd, ...);
> > 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
> > 
> > When a packet arrives to the device underneath "dfd", the net code will 
> > issue a wake_up() on its poll wake list. Epoll (efd1) has installed a 
> > callback wakeup entry on that queue, and the wake_up() performed by the 
> > "dfd" net code will end up in ep_poll_callback(). At this point epoll 
> > (efd1) notices that it may have some event ready, so it needs to wake up 
> > the waiters on its poll wait list (efd2). So it calls ep_poll_safewake() 
> > that ends up in another wake_up(), after having checked about the 
> > recursion constraints. That are, no more than EP_MAX_POLLWAKE_NESTS, to 
> > avoid stack blasting. Never hit the same queue, to avoid loops like:
> > 
> > 	epoll_ctl(efd2, EPOLL_CTL_ADD, efd1, ...);
> > 	epoll_ctl(efd3, EPOLL_CTL_ADD, efd2, ...);
> > 	epoll_ctl(efd4, EPOLL_CTL_ADD, efd3, ...);
> > 	epoll_ctl(efd1, EPOLL_CTL_ADD, efd4, ...);
> > 
> > The code "if (tncur->wq == wq || ..." prevents re-entering the same 
> > queue/lock.
> 
> Since the epoll code is very careful to not nest same instance locks
> allow the recursion.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  fs/eventpoll.c       |    2 +-
>  include/linux/wait.h |   16 ++++++++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/eventpoll.c
> ===================================================================
> --- linux-2.6.orig/fs/eventpoll.c
> +++ linux-2.6/fs/eventpoll.c
> @@ -353,7 +353,7 @@ static void ep_poll_safewake(struct poll
>  	spin_unlock_irqrestore(&psw->lock, flags);
> 
>  	/* Do really wake up now */
> -	wake_up(wq);
> +	wake_up_nested(wq, 1 + wake_nests);
> 
>  	/* Remove the current task from the list */
>  	spin_lock_irqsave(&psw->lock, flags);
> Index: linux-2.6/include/linux/wait.h
> ===================================================================
> --- linux-2.6.orig/include/linux/wait.h
> +++ linux-2.6/include/linux/wait.h
> @@ -161,6 +161,22 @@ wait_queue_head_t *FASTCALL(bit_waitqueu
>  #define	wake_up_locked(x)		__wake_up_locked((x),
>  TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE) #define 
> wake_up_interruptible_sync(x)   __wake_up_sync((x),
> TASK_INTERRUPTIBLE, 1)
> 
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +/*
> + * macro to avoid include hell
> + */
> +#define wake_up_nested(x, s)						\
> +do {									\
> +	unsigned long flags;						\
> +									\
> +	spin_lock_irqsave_nested(&(x)->lock, flags, (s));		\
> +	wake_up_locked(x); 						\
> +	spin_unlock_irqrestore(&(x)->lock, flags);			\
> +} while (0)
> +#else
> +#define wake_up_nested(x, s)		wake_up(x)
> +#endif
> +
>  #define __wait_event(wq, condition) 					\
>  do {									\
>  	DEFINE_WAIT(__wait);						\


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

