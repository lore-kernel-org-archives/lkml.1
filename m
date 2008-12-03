Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYLCCMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYLCCMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 21:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYLCCL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 21:11:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbYLCCLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 21:11:47 -0500
Date: Tue, 2 Dec 2008 18:10:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: philipl@overt.org
Cc: "linux kernel" <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       "Pierre Ossman" <drzeus@drzeus.cx>, "Frank Seidel" <fseidel@suse.de>,
       "Mathias Weyland" <weyland@library.ethz.ch>
Subject: Re: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers 
 (resend)
Message-Id: <20081202181043.8173d657.akpm@linux-foundation.org>
In-Reply-To: <60069.67.164.5.76.1228094870.squirrel@overt.org>
References: <60069.67.164.5.76.1228094870.squirrel@overt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008 20:27:50 -0500 (EST) philipl@overt.org wrote:

> The latest generation of laptops are shipping with a newer
> model of Ricoh chip where the firewire controller is the
> primary PCI function but a cardbus controller is also present.
> 
> The existing code assumes that if a cardbus controller is,
> present, then it must be the one to manipulate - but the real
> rule is that you manipulate PCI function 0. This patch adds an
> additional constraint that the target must be function 0.
> 
> Signed-off-by: Philip Langdale <philipl@overt.org>
> ---
> 
>   ricoh_mmc.c |   17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
> index a16d760..be9e7b3 100644
> --- a/drivers/mmc/host/ricoh_mmc.c
> +++ b/drivers/mmc/host/ricoh_mmc.c
> @@ -11,9 +11,10 @@
> 
>  /*
>   * This is a conceptually ridiculous driver, but it is required by the way
> - * the Ricoh multi-function R5C832 works. This chip implements firewire
> - * and four different memory card controllers. Two of those controllers are
> - * an SDHCI controller and a proprietary MMC controller. The linux SDHCI
> + * the Ricoh multi-function chips (R5CXXX) work. These chips implement
> + * the four main memory card controllers (SD, MMC, MS, xD) and one or both
> + * of cardbus or firewire. It happens that they implement SD and MMC
> + * support as separate controllers (and PCI functions). The linux SDHCI
>   * driver supports MMC cards but the chip detects MMC cards in hardware
>   * and directs them to the MMC controller - so the SDHCI driver never sees
>   * them. To get around this, we must disable the useless MMC controller.
> @@ -21,8 +22,10 @@
>   * a detection event occurs immediately, even if the MMC card is already
>   * in the reader.
>   *
> - * The relevant registers live on the firewire function, so this is unavoidably
> - * ugly. Such is life.
> + * It seems to be the case that the relevant PCI registers to deactivate the
> + * MMC controller live on PCI function 0, which might be the cardbus controller
> + * or the firewire controller, depending on the particular chip in question. As
> + * such, it makes what this driver has to do unavoidably ugly. Such is life.
>   */
> 
>  #include <linux/pci.h>

The above two hunks already are in linux-next.

> @@ -143,6 +146,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
>  		pci_get_device(PCI_VENDOR_ID_RICOH,
>  			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
> +		    PCI_FUNC(fw_dev->devfn) == 0 &&
>  		    pdev->bus == fw_dev->bus) {
>  			if (ricoh_mmc_disable(fw_dev) != 0)
>  				return -ENODEV;
> @@ -160,6 +164,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
>  	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
>  					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
>  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
> +		    PCI_FUNC(fw_dev->devfn) == 0 &&
>  		    pdev->bus == fw_dev->bus) {
>  			if (ricoh_mmc_disable(fw_dev) != 0)
>  				return -ENODEV;
> @@ -172,7 +177,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
> 
>  	if (!ctrlfound) {
>  		printk(KERN_WARNING DRIVER_NAME
> -		       ": Main firewire function not found. Cannot disable controller.\n");
> +		       ": Main Ricoh function not found. Cannot disable controller.\n");
>  		return -ENODEV;
>  	}

Those three are not.
