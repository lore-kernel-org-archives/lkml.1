Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYFCKqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYFCKqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYFCKqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:46:37 -0400
Received: from www.tglx.de ([62.245.132.106]:41005 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbYFCKqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:46:35 -0400
Date: Tue, 3 Jun 2008 12:46:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olaf Dabrunz <od@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>, Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 4/7] disable broadcomm legacy boot interrupt generation
In-Reply-To: <12124107072891-git-send-email-od@suse.de>
Message-ID: <alpine.LFD.1.10.0806031240120.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <12124107072891-git-send-email-od@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
>  /*
> + * disabled boot interrupts on HT-1000
> + */
> +static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
> +{
> +	u32 feature_enable;
> +	u32 saved_feature_enable;

  u32 a,b;

> +	u8 irq;
> +
> +	if (nobootirqquirk)
> +		return;
> +
> +	pci_read_config_dword(dev, 0x64,
> +		       &feature_enable);

one line. 

Can we please have a useful constant for 0x64 ?

> +	saved_feature_enable = feature_enable;
> +	feature_enable |= (1<<0);

What does (1<<0) ? Please use a #define with a understandable name.

> +	pci_write_config_dword(dev, 0x64, feature_enable);

  	pci_write_config_dword(dev, 0x64, feature_enable | WHATEVERTHISMEANS);

That way you dont need an extra variable.

> +	for (irq = 0x10; irq < 0x10 + 32; irq++) {
> +		outb(irq, 0xC00);
> +		outb(0x00, 0xC01);

  #defines for magic port constants please

> +	}
> +
> +	pci_write_config_dword(dev, 0x64, saved_feature_enable);
> +
> +	printk(KERN_INFO "disabled boot interrupts on PCI device 0x%04x:0x%04x\n",
> +		       dev->vendor, dev->device);
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS,   PCI_DEVICE_ID_SERVERWORKS_HT1000SB, 	quirk_disable_broadcom_boot_interrupt);
> +
> +/*
>   * On some chipsets we can disable the generation of legacy INTx boot
>   * interrupts.
>   */
> -- 
> 1.5.2.4
> 
> -- 
> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
> 
