Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZJ3OpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZJ3OpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbZJ3OpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:45:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51626 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbZJ3OpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:45:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bQ8/gAB1qZc1U+xmMU7p9
Date: Fri, 30 Oct 2009 07:45:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Alexander Shishkin <virtuoso@slind.org>,
       Ladislav Michl <ladis@linux-mips.org>
Subject: Re: linux-next: manual merge of the omap tree with Linus' tree
Message-ID: <20091030144517.GS7180@atomide.com>
References: <20091030114642.61bbeb2c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030114642.61bbeb2c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [091029 17:46]:
> Hi all,
> 
> Today's linux-next merge of the omap tree got a conflict in
> arch/arm/mach-omap1/serial.c between commit
> c33da3a80074094303d643a90ef589330b491270 ("omap1: Fix redundant UARTs pin
> muxing that can break other hardware support") from Linus' tree and
> commits 84f90c9cc81d8db172d4f768fc4010f508897366 ("omap: Change low-level
> serial init to use ioremap") and acb1aed4a5f23c545073b0d65302e5949f239fa0
> ("omap: Eliminate OMAP_MAX_NR_PORTS") from the omap tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

Thanks, will rebase omap for-next patches today.

Regards,

Tony

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-omap1/serial.c
> index d23979b,f82f66e..0000000
> --- a/arch/arm/mach-omap1/serial.c
> +++ b/arch/arm/mach-omap1/serial.c
> @@@ -130,7 -120,17 +120,15 @@@ void __init omap_serial_init(void
>   		serial_platform_data[2].uartclk = OMAP1510_BASE_BAUD * 16;
>   	}
>   
> - 	for (i = 0; i < OMAP_MAX_NR_PORTS; i++) {
> + 	for (i = 0; i < ARRAY_SIZE(serial_platform_data) - 1; i++) {
>  -		unsigned char reg;
>  -
> + 		/* Static mapping, never released */
> + 		serial_platform_data[i].membase =
> + 			ioremap(serial_platform_data[i].mapbase, SZ_2K);
> + 		if (!serial_platform_data[i].membase) {
> + 			printk(KERN_ERR "Could not ioremap uart%i\n", i);
> + 			continue;
> + 		}
> + 
>   		switch (i) {
>   		case 0:
>   			uart1_ck = clk_get(NULL, "uart1_ck");
