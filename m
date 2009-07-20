Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZGTVZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZGTVZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZGTVZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:25:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35836 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753107AbZGTVZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:25:41 -0400
Date: Mon, 20 Jul 2009 17:25:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
In-Reply-To: <1248120392-8372-8-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0907201721340.5320-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Jason Wessel wrote:

> If the EHCI debug port is initialized and in use, the EHCI host
> controller driver must follow two rules.
> 
> 1) If the EHCI host driver issues a controller reset, the debug
>    controller driver re-initialization must get called after the reset
>    is completed.
> 
> 2) The EHCI host driver should ignore any requests to the physical
>    EHCI debug port when the EHCI debug port is in use.
> 
> The code to check for debug port was moved from the ehci_pci_reinit()
> to the EHCI host controller reset logic because it applies to any
> condition where EHCI host controller is getting reset.

> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -238,7 +238,33 @@ static int ehci_reset (struct ehci_hcd *ehci)
>  {
>  	int	retval;
>  	u32	command = ehci_readl(ehci, &ehci->regs->command);
> -
> +	u32	temp;
> +	struct pci_dev *pdev = to_pci_dev(ehci_to_hcd(ehci)->self.controller);
> +
> +	/* Special handling for the ehci debug port */
> +	ehci->debug = NULL;
> +	/* optional debug port, normally in the first BAR */
> +	temp = pci_find_capability(pdev, 0x0a);

This isn't going to work very well on systems with non-PCI EHCI
controllers.  Maybe you should leave debug-port detection in
ehci-pci.c.  The controller doesn't get reset very much in any case.

> +	if (temp) {
> +		pci_read_config_dword(pdev, temp, &temp);
> +		temp >>= 16;
> +		if ((temp & (3 << 13)) == (1 << 13)) {
> +			temp &= 0xfff;
> +			ehci->debug = ehci_to_hcd(ehci)->regs + temp;
> +			temp = ehci_readl(ehci, &ehci->debug->control);
> +			ehci_info(ehci, "debug port %d%s\n",
> +				  HCS_DEBUG_PORT(ehci->hcs_params),
> +				  (temp & DBGP_ENABLED)
> +				  ? " IN USE"
> +				  : "");
> +#ifdef CONFIG_EARLY_PRINTK_DBGP
> +			if (!dbgp_reset_prep() || !(temp & DBGP_ENABLED))
> +#else
> +			if (!(temp & DBGP_ENABLED))
> +#endif

This sort of thing is better handled by defining dhbp_reset_prep() as 
an inline routine or macro always returning 1 if 
CONFIG_EARLY_PRINTK_DBGP isn't set.

> @@ -253,6 +279,11 @@ static int ehci_reset (struct ehci_hcd *ehci)
>  	if (ehci_is_TDI(ehci))
>  		tdi_reset (ehci);
>  
> +#ifdef CONFIG_EARLY_PRINTK_DBGP
> +	/* Restore debug facilities if the controler was active */
> +	if (ehci->debug)
> +		dbgp_external_startup();
> +#endif

Similarly here, make dgbp_external_startup() an empty inline function 
or an empty macro.

Alan Stern

