Return-Path: <linux-kernel-owner+w=401wt.eu-S938360AbXG3FXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938360AbXG3FXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXG3FXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:23:02 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57788 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbXG3FXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:23:00 -0400
Subject: Re: v2.6.23-rc1-rt6-dw1
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1185765740.2636.2.camel@imap.mvista.com>
References: <1185765740.2636.2.camel@imap.mvista.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 29 Jul 2007 22:20:31 -0700
Message-Id: <1185772831.2686.6.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +/*
> + * trigger a reschedule on all other CPUs:
> + */
> +extern void smp_send_reschedule_allbutself(void);
> +
> +/*
> + * trigger a reschedule on all other CPUs:
> + */
> +extern void smp_send_reschedule_allbutself(void);
> +

just to make sure the C compiler doesn't forget it ?
or maybe the parser is suffering from memory lapse ? ;)

>  
> -#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> +#if defined(CONFIG_DEBUG_SPINLOCK_SLEEP) || defined(CONFIG_DEBUG_PREEMPT)

why this change? the change is for spinlock debugging.. why add preempt
to this?


>    void __might_sleep(char *file, int line);
>  # define might_sleep() \
>  	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
> @@ -198,6 +198,7 @@ extern void add_taint(unsigned);
>  /* Values used for system_state */
>  extern enum system_states {
>  	SYSTEM_BOOTING,
> +	SYSTEM_BOOTING_SCHEDULER_OK,

what is this used for? your patch doesn't add users of this...

>  	SYSTEM_RUNNING,
>  	SYSTEM_HALT,
>  	SYSTEM_POWER_OFF,
> --- linux-2.6.22.orig/init/main.c
> +++ linux-2.6.22/init/main.c
> @@ -438,6 +438,8 @@ static void noinline __init_refok rest_i
>  {
>  	int pid;
>  
> +	system_state = SYSTEM_BOOTING_SCHEDULER_OK;
> +
>  	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
> --- linux-2.6.22.orig/lib/kernel_lock.c
> +++ linux-2.6.22/lib/kernel_lock.c
> @@ -35,22 +35,25 @@ DECLARE_MUTEX(kernel_sem);
>   * about recursion, both due to the down() and due to the enabling of
>   * preemption. schedule() will re-check the preemption flag after
>   * reacquiring the semaphore.
> + *
> + * Called with interrupts disabled.
>   */
>  int __lockfunc __reacquire_kernel_lock(void)
>  {
>  	struct task_struct *task = current;
>  	int saved_lock_depth = task->lock_depth;
>  
> +	local_irq_enable();

eh... if interrupts are off here that's a bad bug. Why work around it?

>  	BUG_ON(saved_lock_depth < 0);
>  
>  	task->lock_depth = -1;
> -	__preempt_enable_no_resched();
>  
>  	down(&kernel_sem);
>  
> -	preempt_disable();
>  	task->lock_depth = saved_lock_depth;
>  
> +	local_irq_disable();
> +

same here..

>  int __lockfunc __reacquire_kernel_lock(void)
>  {
> -	while (!_raw_spin_trylock(&kernel_flag)) {
> -		if (test_thread_flag(TIF_NEED_RESCHED))
> -			return -EAGAIN;
> -		cpu_relax();
> -	}
> +	local_irq_enable();
> +	_raw_spin_lock(&kernel_flag);
> +	local_irq_disable();

are you sure you want this semantics change?



