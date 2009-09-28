Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZI1Rqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZI1Rqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZI1Rqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:46:50 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:51903 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZI1Rqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PBCW+JLinN06RP4Gdn9LqL7uxxH71U3RxBFASaAgIa2YSMWTVNXQvRPDjvc+SyCfzp
         KWjsRQ0wDj/CX64/WC1S/HbYouJT+gw+1CN59sdm2dfUp/CTz6Ekm5zVZEy+MC9UzpHH
         OpGPN8V1Ew8cTyectTTvKLSJT1KwYeYdQjCbk=
MIME-Version: 1.0
In-Reply-To: <20090928160757.GD5264@lenovo>
References: <4ABF0DE0.1030400@kernel.org> <20090927080605.GA4984@lenovo>
	 <4ABF2262.3090905@kernel.org> <20090927085406.GB4984@lenovo>
	 <20090927102805.GC4984@lenovo> <20090927144008.GD4984@lenovo>
	 <20090927174219.GA14280@lenovo> <20090928160757.GD5264@lenovo>
Date: Mon, 28 Sep 2009 10:46:54 -0700
Message-ID: <86802c440909281046o5fa0032do3497087d173cbf82@mail.gmail.com>
Subject: Re: [PATCH] x86: add show_lapic=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 9:07 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Yinghai, if you still need show_lapic=1 by default the
> acceptable solution (I guess) could be that we accept
> show_lapic=all as well. So a user may safely put it without
> knowing how many apics he has.
>
> Does it look acceptable for you? Something like (tested) below.
> Also I think maybe we should better extend apic= option itself instead
> of intruducing new one?
>
> Anyway, what you think? (again, if you like this patch -- SOB it, Ack it,
> or whatever you want).
> ---
> [PATCH -tip] x86,apic: limit apic dumping, introduce show_lapic setup option
>
> In case if a system has a large number of cpus printing apics
> contents may consume a long time period.
>
> We limit such an output by 1 apic by default. But to have an
> ability to see all apics or some part of them we introduce
> "show_lapic" setup option which allow us to limit/unlimit
> the number of APICs being dumped.
>
> Example: apic=debug show_lapic=5, or apic=debug show_lapic=all
>
> Also move apic_verbosity checking upper that way so helper routines
> do not need to inspect it at all.
>
> Suggested-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/apic/io_apic.c |   47 +++++++++++++++++++++++++++--------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
>
> Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
> @@ -1599,9 +1599,6 @@ __apicdebuginit(void) print_IO_APIC(void
>        struct irq_desc *desc;
>        unsigned int irq;
>
> -       if (apic_verbosity == APIC_QUIET)
> -               return;
> -
>        printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
>        for (i = 0; i < nr_ioapics; i++)
>                printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
> @@ -1708,9 +1705,6 @@ __apicdebuginit(void) print_APIC_field(i
>  {
>        int i;
>
> -       if (apic_verbosity == APIC_QUIET)
> -               return;
> -
>        printk(KERN_DEBUG);
>
>        for (i = 0; i < 8; i++)
> @@ -1724,9 +1718,6 @@ __apicdebuginit(void) print_local_APIC(v
>        unsigned int i, v, ver, maxlvt;
>        u64 icr;
>
> -       if (apic_verbosity == APIC_QUIET)
> -               return;
> -
>        printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
>                smp_processor_id(), hard_smp_processor_id());
>        v = apic_read(APIC_ID);
> @@ -1824,13 +1815,19 @@ __apicdebuginit(void) print_local_APIC(v
>        printk("\n");
>  }
>
> -__apicdebuginit(void) print_all_local_APICs(void)
> +__apicdebuginit(void) print_local_APICs(int maxcpu)
>  {
>        int cpu;
>
> +       if (!maxcpu)
> +               return;
> +
>        preempt_disable();
> -       for_each_online_cpu(cpu)
> +       for_each_online_cpu(cpu) {
> +               if (cpu >= maxcpu)
> +                       break;
>                smp_call_function_single(cpu, print_local_APIC, NULL, 1);
> +       }
>        preempt_enable();
>  }
>
> @@ -1839,7 +1836,7 @@ __apicdebuginit(void) print_PIC(void)
>        unsigned int v;
>        unsigned long flags;
>
> -       if (apic_verbosity == APIC_QUIET || !nr_legacy_irqs)
> +       if (!nr_legacy_irqs)
>                return;
>
>        printk(KERN_DEBUG "\nprinting PIC contents\n");
> @@ -1866,21 +1863,41 @@ __apicdebuginit(void) print_PIC(void)
>        printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
>  }
>
> -__apicdebuginit(int) print_all_ICs(void)
> +static int __initdata show_lapic = 1;
> +static __init int setup_show_lapic(char *arg)
> +{
> +       int num = -1;
> +
> +       if (strcmp(arg, "all") == 0) {
> +               show_lapic = CONFIG_NR_CPUS;

NR_CPUS or nr_cpu_ids?

YH
