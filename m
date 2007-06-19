Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbXFSSdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbXFSSdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbXFSSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:33:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757713AbXFSSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:33:22 -0400
Date: Tue, 19 Jun 2007 11:31:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ben@fluff.org.uk
Cc: ben@fluff.org, linux-kernel@vger.kernel.org, sm5xx-devel@lists.berlios.de,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch #2 1/6] SM501: suspend support
Message-Id: <20070619113137.f6f8d6e5.akpm@linux-foundation.org>
In-Reply-To: <20070618210341.669263489@fluff.org.uk>
References: <20070618205620.284044146@fluff.org.uk>
	<20070618210341.669263489@fluff.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 21:56:21 +0100
ben@fluff.org.uk wrote:

> +/* power management support */
> +
> +static int sm501_plat_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct sm501_devdata *sm = platform_get_drvdata(pdev);
> +
> +	sm->in_suspend = 1;
> +	sm->pm_misc = readl(sm->regs + SM501_MISC_CONTROL);
> +
> +	sm501_dump_regs(sm);
> +	return 0;
> +}
> +
> +static int sm501_plat_resume(struct platform_device *pdev)
> +{
> +	struct sm501_devdata *sm = platform_get_drvdata(pdev);
> +
> +	sm501_dump_regs(sm);
> +	sm501_dump_gate(sm);
> +	sm501_dump_clk(sm);
> +
> +	/* check to see if we are in the same state as when suspended */
> +
> +	if (readl(sm->regs + SM501_MISC_CONTROL) != sm->pm_misc) {
> +		dev_info(sm->dev, "SM501_MISC_CONTROL changed over sleep\n");
> +		writel(sm->pm_misc, sm->regs + SM501_MISC_CONTROL);
> +
> +		/* our suspend causes the controller state to change,
> +		 * either by something attempting setup, power loss,
> +		 * or an external reset event on power change */
> +
> +		if (sm->platdata && sm->platdata->init) {
> +			sm501_init_regs(sm, sm->platdata->init);
> +		}
> +	}
> +
> +	/* dump our state from resume */
> +
> +	sm501_dump_regs(sm);
> +	sm501_dump_clk(sm);
> +
> +	sm->in_suspend = 0;
> +
> +	return 0;
> +}
> +
> +
>  /* Initialisation data for PCI devices */
>  
>  static struct sm501_initdata sm501_pci_initdata = {
> @@ -1126,6 +1207,8 @@ static struct platform_driver sm501_plat
>  	},
>  	.probe		= sm501_plat_probe,
>  	.remove		= sm501_plat_remove,
> +	.suspend	= sm501_plat_suspend,
> +	.resume		= sm501_plat_resume,
>  };

Do we want to compile this in if CONFIG_PM=n?
