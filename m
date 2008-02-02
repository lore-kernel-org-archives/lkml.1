Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYBBG1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYBBG1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 01:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbYBBG1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 01:27:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46047 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbYBBG1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 01:27:38 -0500
Message-ID: <47A40D54.70509@garzik.org>
Date: Sat, 02 Feb 2008 01:27:32 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: PCI: Remove users of pci_enable_device_bars()
References: <200802020506.m1256FVn024064@hera.kernel.org>
In-Reply-To: <200802020506.m1256FVn024064@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Commit:     0948391641918b95d8d96c15089eb5ac156850b3

>     PCI: Remove users of pci_enable_device_bars()
>     
>     This patch converts users of pci_enable_device_bars() to the new
>     pci_enable_device_{io,mem} interface.
>     
>     The new API fits nicely, except maybe for the QLA case where a bit of
>     code re-organization might be a good idea but I prefer sticking to the
>     simple patch as I don't have hardware to test on.
>     
>     I'll also need some feedback on the cs5520 change.
>     
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

> --- a/drivers/ata/pata_cs5520.c
> +++ b/drivers/ata/pata_cs5520.c
> @@ -229,7 +229,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
>  		return -ENOMEM;
>  
>  	/* Perform set up for DMA */
> -	if (pci_enable_device_bars(pdev, 1<<2)) {
> +	if (pci_enable_device_io(pdev)) {
>  		printk(KERN_ERR DRV_NAME ": unable to configure BAR2.\n");
>  		return -ENODEV;
>  	}
> diff --git a/drivers/ide/pci/cs5520.c b/drivers/ide/pci/cs5520.c
> index 6ec00b8..10adc49 100644
> --- a/drivers/ide/pci/cs5520.c
> +++ b/drivers/ide/pci/cs5520.c
> @@ -156,8 +156,14 @@ static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_devic
>  	ide_setup_pci_noise(dev, d);
>  
>  	/* We must not grab the entire device, it has 'ISA' space in its
> -	   BARS too and we will freak out other bits of the kernel */
> -	if (pci_enable_device_bars(dev, 1<<2)) {
> +	 * BARS too and we will freak out other bits of the kernel
> +	 *
> +	 * pci_enable_device_bars() is going away. I replaced it with
> +	 * IO only enable for now but I'll need confirmation this is
> +	 * allright for that device. If not, it will need some kind of
> +	 * quirk. --BenH.
> +	 */
> +	if (pci_enable_device_io(dev)) {
>  		printk(KERN_WARNING "%s: Unable to enable 55x0.\n", d->name);
>  		return -ENODEV;
>  	}

So...  did the feedback mentioned in the commit log ever appear?  :)

	Jeff



