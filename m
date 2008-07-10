Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYGJFvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYGJFvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 01:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYGJFvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 01:51:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYGJFvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 01:51:35 -0400
Date: Wed, 9 Jul 2008 22:45:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Drivers for selfmade hardware
Message-Id: <20080709224557.45a85ff5.akpm@linux-foundation.org>
In-Reply-To: <200806292147.52112.mb@bu3sch.de>
References: <200806292147.52112.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 21:47:52 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> I'm wondering what the policy is for selfmade hardware
> or other hardware where only a few pieces exist. Is it desired
> to get drivers for this kind of hardware merged upstream into the
> mainline kernel?
> 
> I have a tiny driver that can be used to drive a modified
> Brooktree 8xx based card in 24-port GPIO mode.
> So the card can be used as a cheap digital PCI GPIO card.
> This hardware can be built with some soldering skills, a tiny
> soldering tip and a few hours of free time.
> 
> So what's the policy? Push to mainline or keep as seperate
> patch?
> 
> (The following patch is not complete, but just what I have for now
> to show you...)
> 
> ...
>
> +#ifdef CONFIG_PM
> +static int btgpio_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct btgpio *bg = pci_get_drvdata(pdev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	bg->saved_outen = bgread(BT848_GPIO_OUT_EN);
> +	bg->saved_data = bgread(BT848_GPIO_DATA);
> +
> +	bgwrite(0, BT848_INT_MASK);
> +	bgwrite(~0x0, BT848_INT_STAT);
> +	bgwrite(0x0, BT848_GPIO_OUT_EN);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	pci_save_state(pdev);
> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +	return 0;
> +}
> +
> +static int btgpio_resume(struct pci_dev *pdev)
> +{
> +	struct btgpio *bg = pci_get_drvdata(pdev);
> +	unsigned long flags;
> +	int err;
> +
> +	pci_set_power_state(pdev, 0);
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		return err;
> +	pci_restore_state(pdev);
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	bgwrite(0, BT848_INT_MASK);
> +	bgwrite(0, BT848_GPIO_REG_INP);
> +	bgwrite(bg->saved_outen, BT848_GPIO_OUT_EN);
> +	bgwrite(bg->saved_data, BT848_GPIO_DATA);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return 0;
> +}

#else
#define btgpio_suspend NULL
#define btgpio_resume NULL

> +#endif /* CONFIG_PM */
> +
> +static struct pci_device_id btgpio_pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT879) },
> +	{ 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, btgpio_pci_tbl);
> +
> +static struct pci_driver btgpio_pci_driver = {
> +	.name		= "btgpio",
> +	.id_table	= btgpio_pci_tbl,
> +	.probe		= btgpio_probe,
> +	.remove		= btgpio_remove,
> +#ifdef CONFIG_PM

dd

> +	.suspend	= btgpio_suspend,
> +	.resume		= btgpio_resume,
> +#endif

dd

> +};
> +

