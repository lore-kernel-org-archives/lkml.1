Return-Path: <linux-kernel-owner+w=401wt.eu-S936844AbYEUSUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936844AbYEUSUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936098AbYEUSUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:20:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:54343 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936045AbYEUSUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:20:23 -0400
Message-ID: <483467E1.6090808@ct.jp.nec.com>
Date: Wed, 21 May 2008 11:20:17 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merging nmi 32/64 to nmi.c v2
References: <20080521163051.GB6932@cvg>
In-Reply-To: <20080521163051.GB6932@cvg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> This is a second attempt to merge nmi-32/64 to nmi.c

Hi Cyrill,

cool work!

> Summary changes:
> 
...
> - last_irq_sums and alert_counter was defined as static arrays in 32bit
>   mode, so they were changed to per_cpu variables

This was already done, see http://lkml.org/lkml/2008/5/2/525.
But it doesn't affect the unified file.

> +#ifdef CONFIG_X86_64
> +static unsigned ignore_nmis;
> +
> +asmlinkage notrace __kprobes void
> +do_nmi(struct pt_regs *regs, long error_code)
> +{
> +	nmi_enter();
> +	add_pda(__nmi_count,1);
> +	if (!ignore_nmis)
> +		default_do_nmi(regs);
> +	nmi_exit();
> +}
> +
> +void stop_nmi(void)
> +{
> +	acpi_nmi_disable();
> +	ignore_nmis++;
> +}
> +
> +void restart_nmi(void)
> +{
> +	ignore_nmis--;
> +	acpi_nmi_enable();
> +}
> +#endif /* CONFIG_X86_64 */

I'm guessing we can move these functions to traps_64.c.
I've tried to move these functions from traps_32.c to nmi_32.c,
but it caused build error on some 32bit configs.

thanks,
Hiroshi Shimamoto
