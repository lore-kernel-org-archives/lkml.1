Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYE2MM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYE2MM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYE2MMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:12:49 -0400
Received: from gw.goop.org ([64.81.55.164]:57261 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYE2MMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:12:48 -0400
Message-ID: <483E9D9B.9030202@goop.org>
Date: Thu, 29 May 2008 13:12:11 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function
 calls
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1212051504-12561-3-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> @@ -122,6 +109,17 @@ static int xen_smp_intr_init(unsigned int cpu)
>  		goto fail;
>  	per_cpu(debug_irq, cpu) = rc;
>  
> +	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
> +	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
> +				    cpu,
> +				    xen_call_function_single_interrupt,
> +				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
> +				    callfunc_name,
> +				    NULL);
> +	if (rc < 0)
> +		goto fail;
> +	per_cpu(callfuncsingle_irq, cpu) = rc;
>   

Tiny nit: could you shift this up below the other callfunc registration, 
so they appear next to each other in /proc?

> +void xen_smp_send_call_function_ipi(cpumask_t mask)
> +{
> +	int cpu;
> +
> +	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
> +
> +	/* Make sure other vcpus get a chance to run if they need to. */
> +	for_each_cpu_mask(cpu, mask) {
> +		if (xen_vcpu_stolen(cpu)) {
> +			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
> +			break;
> +		}
> +	}
>   

I think you should just drop this loop for now; I want to do some 
measurements before putting it in.

Thanks,
    J
