Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYHUXd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYHUXd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYHUXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:33:11 -0400
Received: from gw.goop.org ([64.81.55.164]:52889 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbYHUXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:33:10 -0400
Message-ID: <48ADFB33.8010204@goop.org>
Date: Thu, 21 Aug 2008 16:33:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Nixon <alex.nixon@citrix.com>
Subject: Re: [PATCH] x86: fix probe_nr_irqs for xen
References: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1219349409-15698-1-git-send-email-yhlu.kernel@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> otherwise Xen is _completely_ unusable with 5 or more VCPUs.
> ( when !CONFIG_HAVE_SPARSE_IRQ)
>
> based on Alex's patch
>
> also add +1 offset after redir_entries
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Alex Nixon <alex.nixon@citrix.com>
>   

Looks good to me.  We can fix this in a better way later.

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> Index: linux-2.6/arch/x86/kernel/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/io_apic.c
> +++ linux-2.6/arch/x86/kernel/io_apic.c
> @@ -3625,16 +3625,21 @@ int __init probe_nr_irqs(void)
>  {
>  	int idx;
>  	int nr = 0;
> +#ifndef CONFIG_XEN
> +	int nr_min = 32;
> +#else
> +	int nr_min = NR_IRQS;
> +#endif
>  
>  	for (idx = 0; idx < nr_ioapics; idx++)
> -		nr += io_apic_get_redir_entries(idx);
> +		nr += io_apic_get_redir_entries(idx) + 1;
>  
>  	/* double it for hotplug and msi and nmi */
>  	nr <<= 1;
>  
>  	/* something wrong ? */
> -	if (nr < 32)
> -		nr = 32;
> +	if (nr < nr_min)
> +		nr = nr_min;
>  
>  	return nr;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

