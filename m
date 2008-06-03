Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYFCKkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYFCKkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYFCKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:40:25 -0400
Received: from www.tglx.de ([62.245.132.106]:33969 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYFCKkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:40:25 -0400
Date: Tue, 3 Jun 2008 12:40:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 3/7] disable legacy boot interrupt generation
In-Reply-To: <12124107072533-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031238070.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107072533-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 6173be5..8f09f8f 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -1377,6 +1377,34 @@ int nobootirqquirk_setup(char *str)
>  __setup("nobootirqquirk", nobootirqquirk_setup);
>  
>  /*
> + * On some chipsets we can disable the generation of legacy INTx boot
> + * interrupts.
> + */
> +#define PCI_IOAPIC_ALTERNATE_BASE_ADDRESS	0x40
> +#define INTEL_6300_ESB_BOOT_INTERRUPT_ENABLE	(1<<14)

new line

> +static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
> +{
> +	u16 cnf;
> +
> +	if (nobootirqquirk)
> +		return;
> +
> +	pci_read_config_word(dev, PCI_IOAPIC_ALTERNATE_BASE_ADDRESS, &cnf);
> +	/* this disables the boot interrupt even though it reads ENABLE */

And why cant we use a name for that constant which makes this obvious
w/o a comment ?

> +	cnf |= INTEL_6300_ESB_BOOT_INTERRUPT_ENABLE;
> +	pci_write_config_word(dev, PCI_IOAPIC_ALTERNATE_BASE_ADDRESS, cnf);
> +
> +	printk(KERN_INFO "disabled boot interrupt on device 0x%04x:0x%04x\n",
> +		dev->vendor, dev->device);
> +}
> +#undef PCI_IOAPIC_ALTERNATE_BASE_ADDRESS

Why #undef ?

> +/*
> + * IO-APIC1 on 6300ESB generates boot interrupts, see intel order no
> + * 300641-004US, section 5.7.3.
> + */
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10, 	quirk_disable_intel_boot_interrupt);
> +
> +/*
>   * Boot interrupts on some chipsets cannot be turned off. For these chipsets,
>   * remap the original interrupt in the linux kernel to the boot interrupt, so
>   * that a PCI device's interrupt handler is installed on the boot interrupt
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index c675399..b89616d 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2309,6 +2309,7 @@
>  #define PCI_DEVICE_ID_INTEL_ESB_4	0x25a4
>  #define PCI_DEVICE_ID_INTEL_ESB_5	0x25a6
>  #define PCI_DEVICE_ID_INTEL_ESB_9	0x25ab
> +#define PCI_DEVICE_ID_INTEL_ESB_10	0x25ac
>  #define PCI_DEVICE_ID_INTEL_82820_HB	0x2500
>  #define PCI_DEVICE_ID_INTEL_82820_UP_HB	0x2501
>  #define PCI_DEVICE_ID_INTEL_82850_HB	0x2530
> -- 
> 1.5.2.4
> 
> -- 
> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
> 
