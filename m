Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbXIVFh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbXIVFh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 01:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXIVFhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 01:37:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:42388 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbXIVFhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 01:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EbysVvftsgeXQlWPcC3hY/Ue3vZNJrKMo/O3JnT9TNLtnbh+357CSOrYdIQqDEZmhCWQfqhWzNlL8s+Nd3GtaSdjW4keC0GQWX7tVb9YyARlS3gINQe30iJMwQpRT10Rf4KA9eeLZmkS0guOhIHSYNF+WceV/IMtQ1c8raubedU=
Message-ID: <86802c440709212237p5aee8e41y385cb85b7cd2e165@mail.gmail.com>
Date: Fri, 21 Sep 2007 22:37:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [patches] [PATCH] [12/50] x86_64: Untable __init references between IO data
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070921223210.AD1FD13DCD@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709221231.836138000@suse.de>
	 <20070921223210.AD1FD13DCD@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Andi Kleen <ak@suse.de> wrote:
>
> Earlier patch added IO APIC setup into local APIC setup. This caused
> modpost warnings. Fix them by untangling setup_local_APIC() and splitting
> it into smaller functions. The IO APIC initialization is only called
> for the BP init.
>
> Also removed some outdated debugging code and minor cleanup.
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  arch/x86_64/kernel/apic.c    |   46 ++++++++++++++++++++-----------------------
>  arch/x86_64/kernel/smpboot.c |    8 +++++++
>  include/asm-x86_64/apic.h    |    1
>  3 files changed, 31 insertions(+), 24 deletions(-)
>
> Index: linux/arch/x86_64/kernel/apic.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/apic.c
> +++ linux/arch/x86_64/kernel/apic.c
> @@ -323,7 +323,7 @@ void __init init_bsp_APIC(void)
>
>  void __cpuinit setup_local_APIC (void)
>  {
> -       unsigned int value, maxlvt;
> +       unsigned int value;
>         int i, j;
>
>         value = apic_read(APIC_LVR);
> @@ -417,33 +417,22 @@ void __cpuinit setup_local_APIC (void)
>         else
>                 value = APIC_DM_NMI | APIC_LVT_MASKED;
>         apic_write(APIC_LVT1, value);
> +}
>
> +void __cpuinit lapic_setup_esr(void)

static ?

> +{
> +       unsigned maxlvt = get_maxlvt();
> +       apic_write(APIC_LVTERR, ERROR_APIC_VECTOR);
>         /*
> -        * Now enable IO-APICs, actually call clear_IO_APIC
> -        * We need clear_IO_APIC before enabling vector on BP
> +        * spec says clear errors after enabling vector.
>          */
> -       if (!smp_processor_id())
> -       if (!skip_ioapic_setup && nr_ioapics)
> -               enable_IO_APIC();
> -
> -       {
> -               unsigned oldvalue;
> -               maxlvt = get_maxlvt();
> -               oldvalue = apic_read(APIC_ESR);
> -               value = ERROR_APIC_VECTOR;      // enables sending errors
> -               apic_write(APIC_LVTERR, value);
> -               /*
> -                * spec says clear errors after enabling vector.
> -                */
> -               if (maxlvt > 3)
> -                       apic_write(APIC_ESR, 0);
> -               value = apic_read(APIC_ESR);
> -               if (value != oldvalue)
> -                       apic_printk(APIC_VERBOSE,
> -                       "ESR value after enabling vector: %08x, after %08x\n",
> -                       oldvalue, value);
> -       }
> +       if (maxlvt > 3)
> +               apic_write(APIC_ESR, 0);
> +}
>
> +void __cpuinit end_local_APIC_setup(void)
> +{
> +       lapic_setup_esr();
>         nmi_watchdog_default();
>         setup_apic_nmi_watchdog(NULL);
>         apic_pm_activate();
> @@ -1178,6 +1167,15 @@ int __init APIC_init_uniprocessor (void)
>
>         setup_local_APIC();
>
> +       /*
> +        * Now enable IO-APICs, actually call clear_IO_APIC
> +        * We need clear_IO_APIC before enabling vector on BP

here it is uniprocessor...
so
+        * We need clear_IO_APIC before enabling error vector

> +        */
> +       if (!skip_ioapic_setup && nr_ioapics)
> +               enable_IO_APIC();

could it cause modpost warning too?

> +
> +       end_local_APIC_setup();
> +
>         if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
>                 setup_IO_APIC();
>         else
> Index: linux/arch/x86_64/kernel/smpboot.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/smpboot.c
> +++ linux/arch/x86_64/kernel/smpboot.c
> @@ -211,6 +211,7 @@ void __cpuinit smp_callin(void)
>
>         Dprintk("CALLIN, before setup_local_APIC().\n");
>         setup_local_APIC();
> +       end_local_APIC_setup();
>
>         /*
>          * Get our bogomips.
> @@ -870,6 +871,13 @@ void __init smp_prepare_cpus(unsigned in
>          */
>         setup_local_APIC();
>
> +       /*
> +        * Enable IO APIC before setting up error vector
> +        */
> +       if (!skip_ioapic_setup && nr_ioapics)
> +               enable_IO_APIC();
> +       end_local_APIC_setup();
> +
>         if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
>                 panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
>                       GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_id);
> Index: linux/include/asm-x86_64/apic.h
> ===================================================================
> --- linux.orig/include/asm-x86_64/apic.h
> +++ linux/include/asm-x86_64/apic.h
> @@ -73,6 +73,7 @@ extern void cache_APIC_registers (void);
>  extern void sync_Arb_IDs (void);

sync_Arb_IDs is still left there?

YH
