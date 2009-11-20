Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZKTLHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZKTLHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZKTLHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:07:20 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55821 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZKTLHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:07:19 -0500
Message-ID: <4B067868.9070902@monstr.eu>
Date: Fri, 20 Nov 2009 12:07:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] microblaze: Fix level interrupt ACKing
References: <1258469019-3863-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1258469019-3863-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

steve@digidescorp.com wrote:
> Level interrupts need to be ack'd in the unmask handler, as in powerpc. 
> Among other issues, this bug causes the system clock to appear to run at 
> double-speed.

Can you send me any step-by-step manual how to demonstrate me this 
fault? If system clock runs at double-speed, then I should be able able 
to see that time is two times faster. Or do you mean different behavior?

Thanks,
Michal



> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> --- a/arch/microblaze/kernel/intc.c	2009-06-02 15:26:28.000000000 -0500
> +++ b/arch/microblaze/kernel/intc.c	2009-06-02 15:27:39.000000000 -0500
> @@ -41,8 +41,16 @@ unsigned int nr_irq;
>  
>  static void intc_enable_or_unmask(unsigned int irq)
>  {
> +	unsigned long mask = 1 << irq;
>  	pr_debug("enable_or_unmask: %d\n", irq);
> -	out_be32(INTC_BASE + SIE, 1 << irq);
> +	out_be32(INTC_BASE + SIE, mask);
> +
> +	/* ack level irqs because they can't be acked during
> +	 * ack function since the handle_level_irq function
> +	 * acks the irq before calling the interrupt handler
> +	 */
> +	if (irq_desc[irq].status & IRQ_LEVEL)
> +		out_be32(INTC_BASE + IAR, mask);
>  }
>  
>  static void intc_disable_or_mask(unsigned int irq)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
