Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZHTMBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZHTMBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZHTMBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:01:30 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:34557 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZHTMB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:01:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ELVXWlL/mmJ9mzgVSp+FlH7oMAbn0lcq13joLaQV7xOdoNW7TyavL5yVqE4nuK35Zr
         ngn1A+hQcLB+lAkXEYSy4ihznHbCrNy4ykrICTT/mVr4w70vcDQIyOWYy+wazfZlAq8n
         Foh6GovHu7dHotyeZj0KnjDKH8pqw2Aq5H8pw=
Date: Thu, 20 Aug 2009 14:01:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/6] workqueue: add support for lazy workqueues
Message-ID: <20090820120124.GB6069@nowhere>
References: <1250763604-24355-1-git-send-email-jens.axboe@oracle.com> <1250763604-24355-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250763604-24355-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 12:20:00PM +0200, Jens Axboe wrote:
> Lazy workqueues are like normal workqueues, except they don't
> start a thread per CPU by default. Instead threads are started
> when they are needed, and exit when they have been idle for
> some time.
> 
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  include/linux/workqueue.h |    5 ++
>  kernel/workqueue.c        |  152 ++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 147 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index f14e20e..b2dd267 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -32,6 +32,7 @@ struct work_struct {
>  #ifdef CONFIG_LOCKDEP
>  	struct lockdep_map lockdep_map;
>  #endif
> +	unsigned int cpu;
>  };
>  
>  #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
> @@ -172,6 +173,7 @@ enum {
>  	WQ_F_SINGLETHREAD	= 1,
>  	WQ_F_FREEZABLE		= 2,
>  	WQ_F_RT			= 4,
> +	WQ_F_LAZY		= 8,
>  };
>  
>  #ifdef CONFIG_LOCKDEP
> @@ -198,6 +200,7 @@ enum {
>  	__create_workqueue((name), WQ_F_SINGLETHREAD | WQ_F_FREEZABLE)
>  #define create_singlethread_workqueue(name)	\
>  	__create_workqueue((name), WQ_F_SINGLETHREAD)
> +#define create_lazy_workqueue(name)	__create_workqueue((name), WQ_F_LAZY)
>  
>  extern void destroy_workqueue(struct workqueue_struct *wq);
>  
> @@ -211,6 +214,8 @@ extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
>  
>  extern void flush_workqueue(struct workqueue_struct *wq);
>  extern void flush_scheduled_work(void);
> +extern void workqueue_set_lazy_timeout(struct workqueue_struct *wq,
> +			unsigned long timeout);
>  
>  extern int schedule_work(struct work_struct *work);
>  extern int schedule_work_on(int cpu, struct work_struct *work);
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 02ba7c9..d9ccebc 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -61,11 +61,17 @@ struct workqueue_struct {
>  	struct list_head list;
>  	const char *name;
>  	unsigned int flags;	/* WQ_F_* flags */
> +	unsigned long lazy_timeout;
> +	unsigned int core_cpu;
>  #ifdef CONFIG_LOCKDEP
>  	struct lockdep_map lockdep_map;
>  #endif
>  };
>  
> +/* Default lazy workqueue timeout */
> +#define WQ_DEF_LAZY_TIMEOUT	(60 * HZ)
> +
> +
>  /* Serializes the accesses to the list of workqueues. */
>  static DEFINE_SPINLOCK(workqueue_lock);
>  static LIST_HEAD(workqueues);
> @@ -81,6 +87,8 @@ static const struct cpumask *cpu_singlethread_map __read_mostly;
>   */
>  static cpumask_var_t cpu_populated_map __read_mostly;
>  
> +static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu);
> +
>  /* If it's single threaded, it isn't in the list of workqueues. */
>  static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
>  {
> @@ -141,11 +149,29 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
>  static void __queue_work(struct cpu_workqueue_struct *cwq,
>  			 struct work_struct *work)
>  {
> +	struct workqueue_struct *wq = cwq->wq;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&cwq->lock, flags);
> -	insert_work(cwq, work, &cwq->worklist);
> -	spin_unlock_irqrestore(&cwq->lock, flags);
> +	/*
> +	 * This is a lazy workqueue and this particular CPU thread has
> +	 * exited. We can't create it from here, so add this work on our
> +	 * static thread. It will create this thread and move the work there.
> +	 */
> +	if ((wq->flags & WQ_F_LAZY) && !cwq->thread) {



Isn't this part racy? If a work has just been queued but the thread
hasn't had yet enough time to start until we get there...?


> +		struct cpu_workqueue_struct *__cwq;
> +
> +		local_irq_save(flags);
> +		__cwq = wq_per_cpu(wq, wq->core_cpu);
> +		work->cpu = smp_processor_id();
> +		spin_lock(&__cwq->lock);
> +		insert_work(__cwq, work, &__cwq->worklist);
> +		spin_unlock_irqrestore(&__cwq->lock, flags);
> +	} else {
> +		spin_lock_irqsave(&cwq->lock, flags);
> +		work->cpu = smp_processor_id();
> +		insert_work(cwq, work, &cwq->worklist);
> +		spin_unlock_irqrestore(&cwq->lock, flags);
> +	}
>  }

