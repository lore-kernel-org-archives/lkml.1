Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbXGaQHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbXGaQHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbXGaQH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:07:28 -0400
Received: from ns.suse.de ([195.135.220.2]:50861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655AbXGaQH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:07:26 -0400
To: Joe Korty <joe.korty@ccur.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: Re: [PATCH] expand /proc/interrupts to include missing vectors, v3
References: <20070726180522.GA1486@tsunami.ccur.com>
	<46A8EE78.4040702@zytor.com>
	<1185816797.3170.1.camel@sven.thebigcorporation.com>
	<20070730123206.abeab890.akpm@linux-foundation.org>
	<20070731001718.GA14295@tsunami.ccur.com>
	<20070731141941.GA3112@tsunami.ccur.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 Jul 2007 19:02:01 +0200
In-Reply-To: <20070731141941.GA3112@tsunami.ccur.com>
Message-ID: <p73wswgpkvq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty <joe.korty@ccur.com> writes:
> 	spurious interrupts
> 
> A threshold interrupt occurs when ECC memory correction
> is occuring at too high a frequency. 

It's configurable and the default is off. Also 
it's only on AMD hardware.

Your description is a little misleading.

> Thresholds are used
> by the ECC hardware as occasional ECC failures are part
> of normal operation,

Not really.


> ===================================================================
> --- 2.6.23-rc1-git7.orig/arch/i386/kernel/apic.c	2007-07-30 19:08:05.000000000 -0400
> +++ 2.6.23-rc1-git7/arch/i386/kernel/apic.c	2007-07-30 19:08:07.000000000 -0400
> @@ -1280,6 +1280,7 @@
>  	printk(KERN_INFO "spurious APIC interrupt on CPU#%d, "
>  	       "should never happen.\n", smp_processor_id());
>  	irq_exit();
> +	__get_cpu_var(irq_stat).irq_spur_counts++;

Wouldn't it be safer on preemptible kernels to have that inside
the irq_exit? 

>  }
>  
>  /*
> Index: 2.6.23-rc1-git7/arch/i386/kernel/cpu/mcheck/p4.c
> ===================================================================
> --- 2.6.23-rc1-git7.orig/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-30 19:08:05.000000000 -0400
> +++ 2.6.23-rc1-git7/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-30 19:08:07.000000000 -0400
> @@ -62,6 +62,7 @@
>  	irq_enter();
>  	vendor_thermal_interrupt(regs);
>  	irq_exit();
> +	__get_cpu_var(irq_stat).irq_thermal_counts++;
>  }
>  
>  /* P4/Xeon Thermal regulation detect and init */
> Index: 2.6.23-rc1-git7/arch/i386/kernel/irq.c
> ===================================================================
> --- 2.6.23-rc1-git7.orig/arch/i386/kernel/irq.c	2007-07-30 19:08:05.000000000 -0400
> +++ 2.6.23-rc1-git7/arch/i386/kernel/irq.c	2007-07-31 09:40:58.000000000 -0400
> @@ -284,14 +284,41 @@
>  		seq_printf(p, "NMI: ");
>  		for_each_online_cpu(j)
>  			seq_printf(p, "%10u ", nmi_count(j));
> -		seq_putc(p, '\n');
> +		seq_printf(p, "  Non-maskable interrupts\n");
>  #ifdef CONFIG_X86_LOCAL_APIC
>  		seq_printf(p, "LOC: ");
>  		for_each_online_cpu(j)
>  			seq_printf(p, "%10u ",
>  				per_cpu(irq_stat,j).apic_timer_irqs);
> -		seq_putc(p, '\n');
> +		seq_printf(p, "  Local interrupts\n");
>  #endif
> +#ifdef CONFIG_SMP
> +		seq_printf(p, "RES: ");

I think it would be better to use 5-6 char identifiers even
when it whacks the columns a bit; otherwise
nobody will know what it means. e.g. SCHED here. 

Also there you should update proc(5) and send a patch
to the manpage maintainer.

> Index: 2.6.23-rc1-git7/arch/x86_64/kernel/apic.c
> ===================================================================
> --- 2.6.23-rc1-git7.orig/arch/x86_64/kernel/apic.c	2007-07-30 19:08:05.000000000 -0400
> +++ 2.6.23-rc1-git7/arch/x86_64/kernel/apic.c	2007-07-30 19:08:07.000000000 -0400
> @@ -1118,6 +1118,7 @@
>  asmlinkage void smp_spurious_interrupt(void)
>  {
>  	unsigned int v;
> +

Don't add white space.


-Andi
