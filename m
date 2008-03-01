Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbYCADBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbYCADBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 22:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYCADBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 22:01:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:43902 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbYCADBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 22:01:36 -0500
Subject: Re: [PATCH 1/3] firewire: fw-ohci: PPC PMac platform code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
	 <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 13:59:52 +1100
Message-Id: <1204340392.15052.455.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +#ifdef CONFIG_PPC_PMAC
> +	/* Necessary on some machines if fw-ohci was loaded/ unloaded before */
> +	if (machine_is(powermac)) {
> +		struct device_node *ofn = pci_device_to_OF_node(dev);
> +
> +		if (ofn) {
> +			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 1);
> +			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 1);
> +		}
> +	}
> +#endif /* CONFIG_PPC_PMAC */

I -think- that the hunk above can be removed if you just call
pci_enable_device(). I have a hook in the arch pcibios_enable_device()
that detects the internal firewire and does the calls. Can you verify it
works ?

> +#ifdef CONFIG_PPC_PMAC
> +	/* On UniNorth, power down the cable and turn off the chip clock
> +	 * to save power on laptops */
> +	if (machine_is(powermac)) {
> +		struct device_node* ofn = pci_device_to_OF_node(dev);
> +
> +		if (ofn) {
> +			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
> +			pmac_call_feature(PMAC_FTR_1394_CABLE_POWER, ofn, 0, 0);
> +		}
> +	}
> +#endif /* CONFIG_PPC_PMAC */

Unfortunately, I don't have the pending hook here for disable so you
need to keep that one for now.

>  	kfree(&ohci->card);
>  
>  	fw_notify("Removed fw-ohci device.\n");
> @@ -2211,6 +2241,16 @@ static int pci_suspend(struct pci_dev *p
>  	if (err)
>  		fw_error("pci_set_power_state failed with %d\n", err);
>  
> +/* PowerMac suspend code comes last */
> +#ifdef CONFIG_PPC_PMAC
> +	if (machine_is(powermac)) {
> +		struct device_node *ofn = pci_device_to_OF_node(pdev);
> +
> +		if (ofn)
> +			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
> +	}
> +#endif /* CONFIG_PPC_PMAC */

I wonder why we don't do the cable power thingy here...

Cheers,
Ben.


