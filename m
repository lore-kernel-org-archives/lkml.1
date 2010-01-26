Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307Ab0AZKTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0AZKTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460Ab0AZKTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:19:37 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:36004 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0AZKTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Aw3hLsGHQtpjE9I1ZkQDohozTcIZhNRNTz3AmN3s92F42iXAmh80L+7JvTfxNuh4L/
         T8HFK4y5B2ttmNa0r48PZ12H+xHnRhYzsKBxq6NsdF21p4cbNcwYlI5UO/yIjeJKzT33
         lkaStnjTDmjCmXwc7otp10qixg1MFa/zLZjn8=
MIME-Version: 1.0
In-Reply-To: <ce2c83091001260201j62a770d2r2379a9293f909d87@mail.gmail.com>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
	 <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
	 <20100126092234.77b363d4@mschwide.boeblingen.de.ibm.com>
	 <alpine.LFD.2.00.1001260946530.5926@localhost.localdomain>
	 <ce2c83091001260201j62a770d2r2379a9293f909d87@mail.gmail.com>
Date: Tue, 26 Jan 2010 18:19:32 +0800
Message-ID: <7b6bb4a51001260219q1a71537do9c3e7c7fa12a04de@mail.gmail.com>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel 
	debugger
From: Xiaotian Feng <xtfeng@gmail.com>
To: Dongdong Deng <libfetion@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 6:01 PM, Dongdong Deng <libfetion@gmail.com> wrote:
> On Tue, Jan 26, 2010 at 4:50 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Tue, 26 Jan 2010, Martin Schwidefsky wrote:
>>> On Mon, 25 Jan 2010 22:26:39 -0600
>>> Jason Wessel <jason.wessel@windriver.com> wrote:
>>>
>>> > This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4
>>> >
>>> > Spin locks were added to the clocksource_resume_watchdog() which cause
>>> > the kernel debugger to deadlock on an SMP system frequently.
>>> >
>>> > The kernel debugger can try for the lock, but if it fails it should
>>> > continue to touch the clocksource watchdog anyway, else it will trip
>>> > if the general kernel execution has been paused for too long.
>>> >
>>> > This introduces an possible race condition where the kernel debugger
>>> > might not process the list correctly if a clocksource is being added
>>> > or removed at the time of this call.  This race is sufficiently rare vs
>>> > having the kernel debugger hang the kernel
>>> >
>>> > CC: Thomas Gleixner <tglx@linutronix.de>
>>> > CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
>>> > CC: John Stultz <johnstul@us.ibm.com>
>>> > CC: Andrew Morton <akpm@linux-foundation.org>
>>> > CC: Magnus Damm <damm@igel.co.jp>
>>> > Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>>>
>>> The first question I would ask is why does the kernel deadlock? Can we
>>> have a backchain of a deadlock please?
>>
>> The problem arises when the kernel is stopped inside the watchdog code
>> with watchdog_lock held. When kgdb restarts execution then it touches
>> the watchdog to avoid that TSC gets marked unstable.
>>
>>> Hmm, there are all kinds of races if the watchdog code gets interrupted
>>> by the kernel debugger. Wouldn't it be better to just disable the
>>> watchdog while the kernel debugger is active?
>>
>> No, we can keep it and in most cases it clocksource_touch_watchdog()
>> helps to keep TSC alive. A simple "if (!trylock) return;" should solve
>> the deadlock problem for kgdb without opening a can of worms.
>
> Is it possible that we reset the clocksource watchdog during in
> clocksource_watchdog() ?
>
> From the code view, The action of reset clocksource watchdog is just
> set the CLOCK_SOURCE_WATCHDOG flag.
> thus if we reset it before using, I think the logic will be right.

Is this logic right for resume case?

>
>
> ---
>
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index e85c234..0590983 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -187,6 +187,8 @@ static DEFINE_SPINLOCK(watchdog_lock);
>  static cycle_t watchdog_last;
>  static int watchdog_running;
>
> +static int volatile clocksource_resume_watchdog;
> +
>  static int clocksource_watchdog_kthread(void *data);
>  static void __clocksource_change_rating(struct clocksource *cs, int rating);
>
> @@ -253,6 +255,11 @@ static void clocksource_watchdog(unsigned long data)
>        if (!watchdog_running)
>                goto out;
>
> +       if (unlikely(clocksource_resume_watchdog)) {
> +               clocksource_reset_watchdog();
> +               clocksource_resume_watchdog = 0;
> +       }
> +
>        wdnow = watchdog->read(watchdog);
>        wd_nsec = clocksource_cyc2ns((wdnow - watchdog_last) & watchdog->mask,
>                                     watchdog->mult, watchdog->shift);
> @@ -341,11 +348,7 @@ static inline void clocksource_reset_watchdog(void)
>
>  static void clocksource_resume_watchdog(void)
>  {
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&watchdog_lock, flags);
> -       clocksource_reset_watchdog();
> -       spin_unlock_irqrestore(&watchdog_lock, flags);
> +       clocksource_resume_watchdog = 1;
>  }
>
>  static void clocksource_enqueue_watchdog(struct clocksource *cs)
>
>
>
>>
>> Thanks,
>>
>>        tglx
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
