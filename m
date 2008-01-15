Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbYAOMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbYAOMVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYAOMVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:21:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60788 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYAOMVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:21:12 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1200393685.5887.113.camel@johannes.berg>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>  <1200307896.5887.42.camel@johannes.berg>
	 <1200393685.5887.113.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:21:01 +0100
Message-Id: <1200399661.26045.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 11:41 +0100, Johannes Berg wrote:
> Ok, I checked all users of the create*workqueue() API now.
> 
> Turns out that there are many users that give a dynamic string as the
> workqueue name (only the first three are relevant for the problem at
> hand because the others are single-threaded):

I'm not sure the single threadedness of a workqueue matters here.

> drivers/connector/cn_queue.c
> drivers/media/video/ivtv/ivtv-driver.c
> drivers/message/i2o/driver.c
> 
> drivers/i2c/chips/m41t00.c drivers/infiniband/core/mad.c
> drivers/message/fusion/mptfc.c drivers/net/qla3xxx.c
> drivers/scsi/hosts.c drivers/scsi/qla4xxx/ql4_os.c
> drivers/scsi/scsi_transport_fc.c drivers/spi/mpc52xx_psc_spi.c
> drivers/spi/omap2_mcspi.c drivers/spi/spi_bitbang.c
> drivers/spi/spi_txx9.c drivers/spi/spi_imx.c drivers/spi/pxa2xx_spi.c
> drivers/spi/spi_bfin5xx.c drivers/power/ds2760_battery.c
> net/mac80211/ieee80211.c
> 
> 
> That's not really the problem though.
> 
> TBH, when writing the workqueue deadlock detection code I wasn't aware
> that it is not allowed to use the same key with different names.
> 
> To make sure now:
> 	same key - different name	- BAD
> 	same key - same name		- OK
> 	different key - same name	- OK

Strictly speaking one can do that, although I would recommend against it
- it leads to confusion as to which lock got into trouble when looking
at lockdep/stat output.

> 	different key - different name	- OK
> 
> Correct?

Yeah.

> The root problem here seems to be that I use the same name as for the
> workqueue for the lockdep_map and other code uses a non-static workqueue
> name. Using the workqueue name for the lock is good for knowing which
> workqueue ran into trouble though.

Indeed, and also using a different key allows the workqueue to have
different lock dependencies as well. The trouble is, lockdep works at
the class level, a class with multiple names just doesn't make sense,
and reporting will get it wrong (although it may appear to work
correctly in the trivial cases).

> mac80211 for example wants to allocate a (single-threaded) workqueue for
> each hardware that is plugged in and wants to call it by the hardware
> name.

Right, that would require a new key for each instance.

> Anyway, the patch below should help. I hope the patch compiles, I don't
> have a lockdep-enabled system at hand right now (irqtrace is still not
> supported on powerpc and my 64-bit powerpc isn't running a kernel with
> my irqtrace support patch at the moment).

Tssk :-)

> If you think the patch is a correct way to solve the problem I'll submit
> it formally and it should then be included in 2.6.24 to avoid
> regressions with the workqueue API (the workqueue lockup detection was
> merged early in 2.6.24.)

The patch looks ok, one important thing to note is that it means that
all workqueues instantiated by the same __create_workqueue() call-site
share lock dependency chains - I'm unsure if that might get us into
trouble or not.

> Who should I send it to in that case?

Me and Ingo :-)

> Dave, do you know if you had connector, ivtv or i2o in the kernel (just
> to make sure my analysis was correct)? And can you reproduce the
> problem, and if so, can you try if this patch helps?
> 
> johannes
> 
> 
> ---
>  include/linux/workqueue.h |   14 +++++++++++---
>  kernel/workqueue.c        |    5 +++--
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> --- everything.orig/include/linux/workqueue.h	2008-01-15 02:10:55.098131131 +0100
> +++ everything/include/linux/workqueue.h	2008-01-15 02:26:37.428130426 +0100
> @@ -149,19 +149,27 @@ struct execute_work {
>  
>  extern struct workqueue_struct *
>  __create_workqueue_key(const char *name, int singlethread,
> -		       int freezeable, struct lock_class_key *key);
> +		       int freezeable, struct lock_class_key *key,
> +		       const char *lock_name);
>  
>  #ifdef CONFIG_LOCKDEP
>  #define __create_workqueue(name, singlethread, freezeable)	\
>  ({								\
>  	static struct lock_class_key __key;			\
> +	const char *__lock_name;				\
> +								\
> +	if (__builtin_constant_p(name))				\
> +		__lock_name = (name);				\
> +	else							\
> +		__lock_name = #name;				\
>  								\
>  	__create_workqueue_key((name), (singlethread),		\
> -			       (freezeable), &__key);		\
> +			       (freezeable), &__key,		\
> +			       __lock_name);			\
>  })
>  #else
>  #define __create_workqueue(name, singlethread, freezeable)	\
> -	__create_workqueue_key((name), (singlethread), (freezeable), NULL)
> +	__create_workqueue_key((name), (singlethread), (freezeable), NULL, NULL)
>  #endif
>  
>  #define create_workqueue(name) __create_workqueue((name), 0, 0)
> --- everything.orig/kernel/workqueue.c	2008-01-15 02:15:13.578132867 +0100
> +++ everything/kernel/workqueue.c	2008-01-15 02:18:40.518138455 +0100
> @@ -722,7 +722,8 @@ static void start_workqueue_thread(struc
>  struct workqueue_struct *__create_workqueue_key(const char *name,
>  						int singlethread,
>  						int freezeable,
> -						struct lock_class_key *key)
> +						struct lock_class_key *key,
> +						const char *lock_name)
>  {
>  	struct workqueue_struct *wq;
>  	struct cpu_workqueue_struct *cwq;
> @@ -739,7 +740,7 @@ struct workqueue_struct *__create_workqu
>  	}
>  
>  	wq->name = name;
> -	lockdep_init_map(&wq->lockdep_map, name, key, 0);
> +	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
>  	wq->singlethread = singlethread;
>  	wq->freezeable = freezeable;
>  	INIT_LIST_HEAD(&wq->list);
> 
> 

