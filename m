Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZDHFAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZDHFAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZDHFAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:00:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46166 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZDHFAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:00:24 -0400
Message-ID: <49DC2F5D.1010401@jp.fujitsu.com>
Date: Wed, 08 Apr 2009 14:00:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [6/28] x86: MCE: Add machine check exception count in
 /proc/interrupts
References: <20090407507.636692542@firstfloor.org> <20090407150747.21C711D046E@basil.firstfloor.org>
In-Reply-To: <20090407150747.21C711D046E@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> @@ -96,6 +97,12 @@
>  	seq_printf(p, "  Threshold APIC interrupts\n");
>  # endif
>  #endif
> +#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
> +	seq_printf(p, "%*s: ", prec, "MCE");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
> +	seq_printf(p, "  Machine check exceptions\n");
> +#endif
>  	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
>  #if defined(CONFIG_X86_IO_APIC)
>  	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));

How about unifying ifdefs?
The patched code will be:

#ifdef CONFIG_X86_MCE
        seq_printf(p, "%*s: ", prec, "TRM");
        for_each_online_cpu(j)
                seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
        seq_printf(p, "  Thermal event interrupts\n");
# ifdef CONFIG_X86_64
        seq_printf(p, "%*s: ", prec, "THR");
        for_each_online_cpu(j)
                seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
        seq_printf(p, "  Threshold APIC interrupts\n");
# endif
#endif
#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
        seq_printf(p, "%*s: ", prec, "MCE");
        for_each_online_cpu(j)
                seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
        seq_printf(p, "  Machine check exceptions\n");
#endif

> @@ -163,6 +170,9 @@
>  {
>  	u64 sum = irq_stats(cpu)->__nmi_count;
>  
> +#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
> +	sum += per_cpu(mce_exception_count, cpu);
> +#endif
>  #ifdef CONFIG_X86_LOCAL_APIC
>  	sum += irq_stats(cpu)->apic_timer_irqs;
>  	sum += irq_stats(cpu)->irq_spurious_count;

Ditto.


Thanks,
H.Seto
