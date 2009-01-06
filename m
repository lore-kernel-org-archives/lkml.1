Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZAFTCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZAFTCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZAFTCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:02:10 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:5005 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZAFTCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:02:08 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: =?iso-8859-2?q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 2.6.28 1/3] PCI-quirks: Unhide MCH5/6 memory controller configuration device
Date: Tue, 6 Jan 2009 12:02:03 -0700
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
References: <20081223215030.GA32525@rere.qmqm.pl> <20090105202829.GB26115@rere.qmqm.pl> <20090105203006.GC26115@rere.qmqm.pl>
In-Reply-To: <20090105203006.GC26115@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901061202.04321.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 01:30:06 pm Micha³ Miros³aw wrote:
> Some BIOSes hide 'overflow' device (dev #6) for i82875P/PE chipsets.
> The same happens for i82865P/PE. Add a quirk to enable this device.
> This allows i82875 EDAC driver to bind to chipset's dev #6 and not
> dev #0 as the latter is used by AGP driver.
> 
> After testing this patch for couple of days on my laptop (i82856P)
> it looks like something is resetting device 0 (MCH) config register
> 0xF4 to zero and effectively disabling the device again. The delay
> looks random to me.

The BIOS left the device hidden.  When you enable it with the quirk,
the fact that it mysteriously gets disabled later seems like a pretty
clear indication that something else we don't know about is using the
device.  Since there's no synchronization between the "something else"
and the i82875p_edac.c driver, it seems like you're introducing the
possibility for problems.

I don't know anything about the EDAC driver.  Is the value it provides
really worth the possible problems with this approach?  Maybe it is,
but I don't want to be the one to debug a random interaction that
causes a problem.

Bjorn

> I can easily update the register using 
> 'hexedit /sys/bus/pci/devices/0000\:00\:00.0/config' and see
> correct values in lspci output afterwards. This is probably
> BIOS's fault. This changes nothing as far as i82875P EDAC driver
> is concerned as it has the same assumption that BIOS is well behaved.
> 
> In case some really broken BIOS is found, this can be wrapped around
> some new Kconfig #ifdef.
> 
> Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index a47db02..0ca02c7 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1787,6 +1787,28 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>  			PCI_DEVICE_ID_NX2_5709S,
>  			quirk_brcm_570x_limit_vpd);
>  
> +/* Originally in EDAC sources for i82875P:
> + * Intel tells BIOS developers to hide device 6 which
> + * configures the overflow device access containing
> + * the DRBs - this is where we expose device 6.
> + * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
> + */
> +static void __devinit quirk_unhide_mch_dev6(struct pci_dev *dev)
> +{
> +	u8 reg;
> +
> +	if (pci_read_config_byte(dev, 0xF4, &reg) == 0 && !(reg & 0x02)) {
> +		dev_info(&dev->dev, "Enabling MCH 'Overflow' Device\n");
> +		pci_write_config_byte(dev, 0xF4, reg | 0x02);
> +	}
> +}
> +
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
> +                       quirk_unhide_mch_dev6);
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
> +                       quirk_unhide_mch_dev6);
> +
> +
>  #ifdef CONFIG_PCI_MSI
>  /* Some chipsets do not support MSI. We cannot easily rely on setting
>   * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


