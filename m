Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZCHRP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZCHRP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 13:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZCHRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 13:15:16 -0400
Received: from gw.goop.org ([64.81.55.164]:47830 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZCHRPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 13:15:15 -0400
Message-ID: <49B3FD1F.9010000@goop.org>
Date: Sun, 08 Mar 2009 10:15:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 01/13] [VOYAGER] x86: add {safe,hard}_smp_processor_id
 to smp_ops
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com> <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
In-Reply-To: <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Not having apics, Voyager can't use the default apic implementation of
> these, it has to read from a special port in the VIC to get the
> processor ID, so abstract these functions in smp_ops to allow voyager
> to live simultaneously with the apic code.
>   

These aren't performance-sensitive at all, are they?  smp_ops is not 
subject to patching/inlining optimisations happen to more hotpath pvops.

Is safe_smp_processor_id needed at all?  It's only got two callers, and 
x86-64 just implements it as smp_processor_id().

> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 035582a..0dfb8c0 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -450,6 +450,11 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static int xen_hard_smp_processor_id(void)
> +{
> +	return read_apic_id();
> +}
> +
>  static const struct smp_ops xen_smp_ops __initdata = {
>  	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
>  	.smp_prepare_cpus = xen_smp_prepare_cpus,
> @@ -465,6 +470,8 @@ static const struct smp_ops xen_smp_ops __initdata = {
>  
>  	.send_call_func_ipi = xen_smp_send_call_function_ipi,
>  	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
> +	.hard_smp_processor_id = xen_hard_smp_processor_id,
> +	.safe_smp_processor_id = apic_safe_smp_processor_id,
>   

Hm, there's no meaningful apic-based implementation for these under 
Xen.  DomU has no access to apics, and Dom0's vcpus don't have any fixed 
relationship to physical cpu apics.  They should both just return 
smp_processor_id(), I guess.

    J
