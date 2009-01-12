Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZALM2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZALM2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZALM2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:28:01 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:17041 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZALM2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:28:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OvxGVbNW3/C+SEXCtcvBuYOiS+Wkv4qM2T4envBh9LIUwbClck3czm2Np6LyQm+yzX
         zpn6kzZ1+6m3e9Ahpl/9s+pPUfSyJNxuljbgRa04/nQ9PShwljjS+1wCOwsveZ++uuau
         qN1b3ddXQn1TG/PeyHwUOiSAthVv1DC3XCipU=
Message-ID: <a4423d670901120427q502ae9b6uded2e55a91c2a7cc@mail.gmail.com>
Date: Mon, 12 Jan 2009 15:27:59 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.28-rc6: hpet: object is on stack, but not annotated
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@suse.cz>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       shaohua.li@intel.com
In-Reply-To: <20090112115934.GA24266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670811240839q54e6b7afxfc49d28b3ea127cb@mail.gmail.com>
	 <a4423d670811241014n2b2192beh931d374bf063894f@mail.gmail.com>
	 <alpine.LFD.2.00.0811241916560.3301@localhost.localdomain>
	 <20081204111621.GA2466@elf.ucw.cz>
	 <a4423d670901120240m6ee29951ucc1c0f16c27d398c@mail.gmail.com>
	 <1231761143.4371.0.camel@laptop> <20090112115934.GA24266@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/12 Ingo Molnar <mingo@elte.hu>:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> > > (No, introducing WARN_ON()s is not fine; it spams kerneloops.org at
>> > > least...)
>> >
>> > The warning is still here on 2.6.29-rc1. It taints the kernel.
>>
>> Does this fix it?
Yes, it does. Thanks Peter.
>
> i've applied it to tip/timers/urgent and will send it to Linus if it
> passes Alexander's testing too. Below is the prettified commit.
Yes, please.
>
> Thanks guys,
>
>        Ingo
> -------------->
> From b1f1006971b6f8d330c6e8ecf240f51c9eb67f4d Mon Sep 17 00:00:00 2001
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon, 12 Jan 2009 12:52:23 +0100
> Subject: [PATCH] locking, hpet: annotate false positive warning
>
> Alexander Beregalov reported that this warning is caused by the HPET code:
>
>> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>> ODEBUG: object is on stack, but not annotated
>> ------------[ cut here ]------------
>> WARNING: at lib/debugobjects.c:251 __debug_object_init+0x2a4/0x352()
>
>> Bisected down to 26afe5f2fbf06ea0765aaa316640c4dd472310c0
>> (x86: HPET_MSI Initialise per-cpu HPET timers)
>
> The commit is fine - but the on-stack workqueue entry needs annotation.
>
> Reported-and-bisected-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/hpet.c    |    2 +-
>  include/linux/workqueue.h |    6 ++++++
>  2 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index cd759ad..bb2e0f0 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -628,7 +628,7 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
>
>        switch (action & 0xf) {
>        case CPU_ONLINE:
> -               INIT_DELAYED_WORK(&work.work, hpet_work);
> +               INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
>                init_completion(&work.complete);
>                /* FIXME: add schedule_work_on() */
>                schedule_delayed_work_on(cpu, &work.work, 0);
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index b362911..47151c8 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -118,6 +118,12 @@ struct execute_work {
>                init_timer(&(_work)->timer);                    \
>        } while (0)
>
> +#define INIT_DELAYED_WORK_ON_STACK(_work, _func)               \
> +       do {                                                    \
> +               INIT_WORK(&(_work)->work, (_func));             \
> +               init_timer_on_stack(&(_work)->timer);           \
> +       } while (0)
> +
>  #define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)                     \
>        do {                                                    \
>                INIT_WORK(&(_work)->work, (_func));             \
>
