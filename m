Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYFCKyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYFCKyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYFCKyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:54:36 -0400
Received: from www.tglx.de ([62.245.132.106]:37272 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYFCKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:54:35 -0400
Date: Tue, 3 Jun 2008 12:54:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 5/7] disable AMD/ATI legacy boot interrupt generation
In-Reply-To: <12124107073972-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031246180.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107073972-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
>  
>  /*
> + * disable boot interrupts on AMD and ATI chipsets
> + */
> +#define PCI_X_MISC			0x40
> +#define  PCI_X_AMD813X_NIOAMODE		(1<<0)

new line before the function and consistent spacing

> +static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
> +{
> +	u32 pci_x_misc;
> +
> +	if (nobootirqquirk)
> +		return;
> +
> +	pci_read_config_dword(dev, PCI_X_MISC, &pci_x_misc);
> +	pci_x_misc &= ~PCI_X_AMD813X_NIOAMODE;
> +	pci_write_config_dword(dev, PCI_X_MISC, pci_x_misc);
> +
> +	printk(KERN_INFO "disabled boot interrupts on PCI device "
> +			"0x%04x:0x%04x\n", dev->vendor, dev->device);
> +}
> +#undef PCI_X_MISC
> +#undef PCI_X_AMD813X_NIOAMODE

why #undef ?

> +
> +#define PCI_AMD8111_PCI_IRQ_ROUTING	0x56
> +static void quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
> +{
> +	u16 pci_irq_routing;
> +
> +	if (nobootirqquirk)
> +		return;
> +
> +	pci_read_config_word(dev, PCI_AMD8111_PCI_IRQ_ROUTING,
> +						&pci_irq_routing);
> +	if (!pci_irq_routing) {
> +		printk(KERN_INFO "boot interrupts on PCI "
> +				"device 0x%04x:0x%04x were "
> +				"already disabled\n",
> +				dev->vendor, dev->device);
> +		return;
> +	}
> +	pci_write_config_word(dev, PCI_AMD8111_PCI_IRQ_ROUTING, 0);
> +	printk(KERN_INFO "disabled boot interrupts on PCI device "
> +			"0x%04x:0x%04x\n", dev->vendor, dev->device);
> +}
> +#undef PCI_AMD8111_PCI_IRQ_ROUTING
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8111_SMBUS, 	quirk_disable_amd_8111_boot_interrupt);
> +
> +#define PCI_AMD_SB700S_FEATURES_ENABLE	0x64
> +#define  PCI_AMD_SB700S_PIC_ENABLE	(1<<0)
> +#define PIC_PCI_INTR_INDEX		0xC00
> +#define PIC_PCI_INTR_DATA		0xC01
> +#define CLEAR_PIC_IRQ_ROUTING(irq)					\
> +	outb(irq, PIC_PCI_INTR_INDEX);					\
> +	outb(0x00, PIC_PCI_INTR_DATA);

Please use an inline function

> +static void quirk_disable_amd_sb700s_boot_interrupt(struct pci_dev *dev)
> +{
> +	u32 feature_enable;
> +	u32 saved_feature_enable;
> +
> +	if (nobootirqquirk)
> +		return;
> +
> +	pci_read_config_dword(dev, PCI_AMD_SB700S_FEATURES_ENABLE,
> +						&feature_enable);
> +	saved_feature_enable = feature_enable;
> +	feature_enable |= PCI_AMD_SB700S_PIC_ENABLE;
> +	pci_write_config_dword(dev, PCI_AMD_SB700S_FEATURES_ENABLE,
> +						feature_enable);
> +
> +	CLEAR_PIC_IRQ_ROUTING(0x0);
> +	CLEAR_PIC_IRQ_ROUTING(0x1);
> +	CLEAR_PIC_IRQ_ROUTING(0x2);
> +	CLEAR_PIC_IRQ_ROUTING(0x3);
> +	CLEAR_PIC_IRQ_ROUTING(0x4);
> +	CLEAR_PIC_IRQ_ROUTING(0x9);
> +	CLEAR_PIC_IRQ_ROUTING(0xA);
> +	CLEAR_PIC_IRQ_ROUTING(0xB);
> +	CLEAR_PIC_IRQ_ROUTING(0xC);

  	int i, irqs[] = {0x0,.....0x0c};

	for (i = 0; i < ARRAY_SIZE(irqs); i++) {
	    outb(...);
	    outb(...);
	}
	  
  perhaps ?

> +
> +	pci_write_config_dword(dev, PCI_AMD_SB700S_FEATURES_ENABLE,
> +						saved_feature_enable);
> +
> +	printk(KERN_INFO "disabled boot interrupts on PCI device "
> +			"0x%04x:0x%04x\n", dev->vendor, dev->device);
> +}
> +#undef PCI_AMD_SB700S_FEATURES_ENABLE
> +#undef PCI_AMD_SB700S_PIC_ENABLE
> +#undef PIC_PCI_INTR_INDEX
> +#undef PIC_PCI_INTR_DATA
> +#undef CLEAR_PIC_IRQ_ROUTING

grmbl

> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI,   PCI_DEVICE_ID_ATI_IXP600_SMBUS, 	quirk_disable_amd_sb700s_boot_interrupt);
> +
> +/*
>   * disabled boot interrupts on HT-1000
>   */
>  static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
> -- 
> 1.5.2.4
> 
> -- 
> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
> 
