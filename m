Return-Path: <linux-kernel-owner+w=401wt.eu-S934596AbXHYTjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596AbXHYTjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 15:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbXHYTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 15:39:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764229AbXHYTjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 15:39:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Problem with CFS V20 and Suspend2/tuxonice
Date: Sat, 25 Aug 2007 21:49:44 +0200
User-Agent: KMail/1.9.5
Cc: David Rodriguez <livuxman@gmail.com>, linux-kernel@vger.kernel.org
References: <1946b54f0708250423k75d5797fuc5b032be7e143f26@mail.gmail.com> <1946b54f0708250429y570a1620y2796d0ff8abb02eb@mail.gmail.com> <20070825190142.GA15888@elte.hu>
In-Reply-To: <20070825190142.GA15888@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708252149.45482.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 August 2007 21:01, Ingo Molnar wrote:
> 
> * David Rodriguez <livuxman@gmail.com> wrote:
> 
> > I'm using 2.6.22.5 with cfs v20.3 and suspend2 2.2.10.2. With that 
> > combination, suspend is not working anymore (with cfs v19 was 
> > working). Stops on suspend in "Suspending tasks" Looking at cfs patch, 
> > I managed to change the migration_thread, adding again the 
> > try_to_freeze() removed in last patch and now the suspend finished, 
> > but resume not work. Of course I don't know why that was removed, and 
> > rewriting it is not a solution, but I want to report it.
> 
> could you try the patch below, does it fix this problem?
> 
> 	Ingo
> 
> Index: linux-cfs-2.6.22.5.q/kernel/sched.c
> ===================================================================
> --- linux-cfs-2.6.22.5.q.orig/kernel/sched.c
> +++ linux-cfs-2.6.22.5.q/kernel/sched.c
> @@ -5043,6 +5043,8 @@ static int migration_thread(void *data)
>  		struct migration_req *req;
>  		struct list_head *head;
>  
> +		try_to_freeze();
> +
>  		spin_lock_irq(&rq->lock);
>  
>  		if (cpu_is_offline(cpu)) {
> @@ -5399,6 +5401,7 @@ migration_call(struct notifier_block *nf
>  		p = kthread_create(migration_thread, hcpu, "migration/%d", cpu);
>  		if (IS_ERR(p))
>  			return NOTIFY_BAD;
> +		p->flags |= PF_NOFREEZE;

Yeah.

In 2.6.23-rc all kernel threads are PF_NOFREEZE by default.

>  		kthread_bind(p, cpu);
>  		/* Must be high prio: stop_machine expects to yield to it. */
>  		rq = task_rq_lock(p, &flags);
> -

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
