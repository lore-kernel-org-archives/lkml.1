Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbZJNKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbZJNKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZJNKZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:25:26 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:34773 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbZJNKZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UpnP/OYxRQJ3aPu9HgKXLh5ac1NZreJE/ta79eWKNNaA83sOqcr2qexhtZSe0qJrhl
         buw7Lt+2XQbP5ZdNHASQucNUqgHIcECnr2hRUn/+vPuU+UYoyq5l5RAq7QfSn+ezXkEX
         8Hp4l/g6xt4Opu4rvJA3eNT9KfR9pA9aVN8nw=
MIME-Version: 1.0
In-Reply-To: <20091014101336.GA25108@redhat.com>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
	 <20091014101336.GA25108@redhat.com>
Date: Wed, 14 Oct 2009 03:24:49 -0700
Message-ID: <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>
Subject: Re: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 3:13 AM, Gleb Natapov <gleb@redhat.com> wrote:
> On Wed, Oct 14, 2009 at 02:21:22AM -0700, Leonidas . wrote:
>> On Tue, Oct 13, 2009 at 11:36 PM, Leonidas . <leonidas137@gmail.com> wrote:
>> > Hi List,
>> >
>> > I am working on a profiler kind of module, the exported apis of my
>> > module can be
>> > called from process context and interrupt context as well. Depending on the
>> > context I am called in, I need to call sleepable/nonsleepable variants
>> > of my internal
>> > bookkeeping functions.
>> >
>> > I am aware of in_interrupt() call which can be used to check current
>> > context and take action
>> > accordingly.
>> >
>> > Is there any api which can help figure out whether we are executing
>> > while hold a spinlock? I.e
>> > an api which can help figure out sleepable/nonsleepable context? If it
>> > is not there, what can
>> > be done for writing the same? Any pointers will be helpful.
>> >
>> > -Leo.
>> >
>>
>>   While searching through the sources, I found this,
>>
>>   97/*
>>   98 * Are we running in atomic context?  WARNING: this macro cannot
>>   99 * always detect atomic context; in particular, it cannot know about
>>  100 * held spinlocks in non-preemptible kernels.  Thus it should not be
>>  101 * used in the general case to determine whether sleeping is possible.
>>  102 * Do not use in_atomic() in driver code.
>>  103 */
>>  104#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) !=
>> PREEMPT_INATOMIC_BASE)
>>  105
>>
>> this just complicates the matter, right? This does not work in general
>> case but I think this
>> will always work if the kernel is preemptible.
>>
>> Is there no way to write a generic macro?
>>
>>
> Attached patch make in_atomic() to work for non-preemptable kernels too.
> Doesn't look to big or scary.
>
> Disclaimer: tested only inside kvm guest 64bit, haven't measured overhead.
>
> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 6d527ee..a6b6040 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -92,12 +92,11 @@
>  */
>  #define in_nmi()       (preempt_count() & NMI_MASK)
>
> +#define PREEMPT_CHECK_OFFSET 1
>  #if defined(CONFIG_PREEMPT)
>  # define PREEMPT_INATOMIC_BASE kernel_locked()
> -# define PREEMPT_CHECK_OFFSET 1
>  #else
>  # define PREEMPT_INATOMIC_BASE 0
> -# define PREEMPT_CHECK_OFFSET 0
>  #endif
>
>  /*
> @@ -116,12 +115,11 @@
>  #define in_atomic_preempt_off() \
>                ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
>
> +#define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
>  #ifdef CONFIG_PREEMPT
>  # define preemptible() (preempt_count() == 0 && !irqs_disabled())
> -# define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
>  #else
>  # define preemptible() 0
> -# define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
>  #endif
>
>  #if defined(CONFIG_SMP) || defined(CONFIG_GENERIC_HARDIRQS)
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index 72b1a10..7d039ca 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -82,14 +82,24 @@ do { \
>
>  #else
>
> -#define preempt_disable()              do { } while (0)
> -#define preempt_enable_no_resched()    do { } while (0)
> -#define preempt_enable()               do { } while (0)
> +#define preempt_disable() \
> +do { \
> +       inc_preempt_count(); \
> +       barrier(); \
> +} while (0)
> +
> +#define preempt_enable() \
> +do { \
> +       barrier(); \
> +       dec_preempt_count(); \
> +} while (0)
> +
> +#define preempt_enable_no_resched()    preempt_enable()
>  #define preempt_check_resched()                do { } while (0)
>
> -#define preempt_disable_notrace()              do { } while (0)
> -#define preempt_enable_no_resched_notrace()    do { } while (0)
> -#define preempt_enable_notrace()               do { } while (0)
> +#define preempt_disable_notrace()              preempt_disable()
> +#define preempt_enable_no_resched_notrace()    preempt_enable()
> +#define preempt_enable_notrace()               preempt_enable()
>
>  #endif
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1535f38..841e0d0 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2556,10 +2556,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
>  #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
>        p->oncpu = 0;
>  #endif
> -#ifdef CONFIG_PREEMPT
>        /* Want to start with kernel preemption disabled. */
>        task_thread_info(p)->preempt_count = 1;
> -#endif
>        plist_node_init(&p->pushable_tasks, MAX_PRIO);
>
>        put_cpu();
> @@ -6943,11 +6941,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
>        spin_unlock_irqrestore(&rq->lock, flags);
>
>        /* Set the preempt count _outside_ the spinlocks! */
> -#if defined(CONFIG_PREEMPT)
>        task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
> -#else
> -       task_thread_info(idle)->preempt_count = 0;
> -#endif
>        /*
>         * The idle tasks have their own, simple scheduling class:
>         */
> diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
> index 39f1029..6e2659d 100644
> --- a/lib/kernel_lock.c
> +++ b/lib/kernel_lock.c
> @@ -93,6 +93,7 @@ static inline void __lock_kernel(void)
>  */
>  static inline void __lock_kernel(void)
>  {
> +       preempt_disable();
>        _raw_spin_lock(&kernel_flag);
>  }
>  #endif
> --
>                        Gleb.
>

Unbelievable! I was just thinking about the logic to achieve the same, and
someone has already done this. Thanks for the patch.

Actually, in my case, I dont think I will be able to patch and rebuild
the kernel.
Also, my use case is also much simpler, I just want to call kmalloc
depending on
the context I am running in, by giving appropriate flags.

So, I am doing something like this:

if(preemptible())
    flags = (in_atomic() == 0) ? GFP_KERNEL : GFP_ATOMIC;
else
     /*Cant afford failing, dont care abt emergency pool depleting etc*/
    flags = GFP_ATOMIC

kmalloc(size, flags);

I am aware that, in_atomic() should not be used by drivers/modules
except core kernel,
but there is no other provision, I cant change the interfaces of the
function calls or have
two copies of functions i.e. sleepable/nonsleepable since the profiler
I am porting is
originally written for BSD.

-Leo.
