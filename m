Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZEFHfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZEFHfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZEFHe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:34:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZEFHe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:34:58 -0400
Date: Wed, 6 May 2009 09:34:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb,early_printk: unregister early usb before
	rest_init()
Message-ID: <20090506073456.GC17457@elte.hu>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com> <1241575205-12199-3-git-send-email-jason.wessel@windriver.com> <1241575205-12199-4-git-send-email-jason.wessel@windriver.com> <1241575205-12199-5-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241575205-12199-5-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> The early_printk EHCI debug driver can hang the system or cause
> unpredictable results because two separate APIs will attempt to write
> to the mapped PCI region.
> 
> The safe route is to unregister the early USB console at the end of
> the core kernel init, which is before the PCI initialization.  Later,
> after the USB initialization completes it is then possible to register
> the console against the usb debug device and receive the printk
> messages that were missed in the period between early printk
> availability and the USB console device.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  arch/x86/kernel/early_printk.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index e38c467..ef177d4 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -952,4 +952,26 @@ static int __init setup_early_printk(char *buf)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_EARLY_PRINTK_DBGP
> +/*
> + * The early console must get unregistered prior to the ECHI
> + * controller getting reset else the debug device cannot be used until
> + * a subsequent EHCI reset, or the kernel hangs.
> + */
> +static int __init usb_early_debug_cleanup(void)
> +{
> +	if (early_dbgp_console.index >= 0 &&
> +		early_dbgp_console.flags & CON_PRINTBUFFER) {
> +		console_stop(early_console);
> +		unregister_console(early_console);
> +		early_dbgp_console.index = -1;
> +		early_dbgp_console.flags = 0;
> +		ehci_debug = NULL;
> +		printk(KERN_INFO "Early USB console unregistered\n");
> +	}
> +	return 0;
> +}
> +postcore_initcall(usb_early_debug_cleanup);
> +#endif /* CONFIG_EARLY_PRINTK_DBGP */

We already have CON_BOOT which allows the unregistering of early 
consoles, via disable_boot_consoles() initcall in kernel/printk.c.

The hang should be solved differently: either by calling 
disable_boot_consoles() explicitly after console_init() - or by 
introducing another CON_ flag that marks the console for early 
forced unregistering.

	Ingo
