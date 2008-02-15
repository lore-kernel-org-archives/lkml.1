Return-Path: <linux-kernel-owner+w=401wt.eu-S1765596AbYBONet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765596AbYBONet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYBONem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:34:42 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38082 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbYBONel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:34:41 -0500
Date: Fri, 15 Feb 2008 14:33:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 04/14] [ISDN] HiSax bkm_a4t: convert to PCI hotplug API
Message-ID: <20080215133348.GH1178@uranus.ravnborg.org>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org> <a73a5a9ab1ec204f77ff99677030b0d206c0abbb.1203031878.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a73a5a9ab1ec204f77ff99677030b0d206c0abbb.1203031878.git.jeff@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 11:46:11PM -0400, Jeff Garzik wrote:
> Signed-off-by: Jeff Garzik <jeff@garzik.org>
> ---
>  drivers/isdn/hisax/Kconfig   |    4 +-
>  drivers/isdn/hisax/Makefile  |    3 +-
>  drivers/isdn/hisax/bkm_a4t.c |  115 ++++++++++++++++++++++++++++--------------
>  drivers/isdn/hisax/config.c  |   27 ++++------
>  4 files changed, 92 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/isdn/hisax/Kconfig b/drivers/isdn/hisax/Kconfig
> index 7832d8b..e7808f5 100644
> --- a/drivers/isdn/hisax/Kconfig
> +++ b/drivers/isdn/hisax/Kconfig
> @@ -286,8 +286,8 @@ config HISAX_HSTSAPHIR
>  	  settings.
>  
>  config HISAX_BKM_A4T
> -	bool "Telekom A4T card"
> -	depends on PCI && PCI_LEGACY
> +	tristate "Telekom A4T card"
> +	depends on PCI
>  	help
>  	  This enables HiSax support for the Telekom A4T card.
>  
> diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
> index b0b09e9..42bfc2f 100644
> --- a/drivers/isdn/hisax/Makefile
> +++ b/drivers/isdn/hisax/Makefile
> @@ -15,7 +15,9 @@ obj-$(CONFIG_HISAX_ST5481)		+= hisax_st5481.o
>  obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
>  obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
>  obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
> +obj-$(CONFIG_HISAX_BKM_A4T)		+= bkm_a4t_pci.o libhisax.o
>  
> +bkm_a4t_pci-objs			:= bkm_a4t.o jade.o
Could we please use:
> +bkm_a4t_pci-y			:= bkm_a4t.o jade.o

> +static int __devinit
>  setup_bkm_a4t(struct IsdnCard *card)

One single line like you do here:

> +
> +static int __devinit a4t_pci_init_one(struct pci_dev *pdev,
> +				      const struct pci_device_id *ent)

> +
> +static struct pci_device_id a4t_pci_table[] = {
> +	{ PCI_VENDOR_ID_ZORAN, PCI_DEVICE_ID_ZORAN_36120,
> +	  PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_A4T, },
> +
> +	{ }		/* terminate list */
> +};
const?

> +
> +static struct pci_driver a4t_pci_driver = {
> +	.name		= "bkm_a4t",
> +	.id_table	= a4t_pci_table,
> +	.probe		= a4t_pci_init_one,
> +	.remove		= hisax_pci_remove_one,
> +};
const?

> +module_param_named(protocol, a4t_protocol, int, 0444);
> +MODULE_PARM_DESC(protocol, "Values 0 (default) through 4. See ISDN_PTYPE_xxx in linux/isdnif.h");
> +
> +MODULE_DEVICE_TABLE(pci, a4t_pci_table);
> +MODULE_DESCRIPTION("ISDN HiSax BKM A4T PCI driver");
> +MODULE_LICENSE("GPL");

I thought this stuff belongs to top of file - not bottom.

	Sam
