Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYC0UbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYC0UbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbYC0UbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:31:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932AbYC0UbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:31:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: iommu breaks usb after resume
Date: Thu, 27 Mar 2008 21:30:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <20080320111429.GA14764@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz>
In-Reply-To: <20080326225407.GA9378@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803272130.38375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of March 2008, Pavel Machek wrote:
> Hi!
> 
> > > CONFIG_AGP=y
> > > CONFIG_AGP_AMD64=y
> > > CONFIG_AGP_INTEL=y
> > > # CONFIG_AGP_SIS is not set
> > > CONFIG_AGP_VIA=y
> > > CONFIG_DRM=y
> > > # CONFIG_DRM_TDFX is not set
> > > 
> > > ...do I need to enable something more?
> > 
> > Should have worked then. Ok modulo bugs. Maybe the ordering
> > is wrong now (AGP resume would need to run before anything
> > using the IOMMU)
> 
> So agp_amd64_resume() is responsible for reiniting iommu on new amd64
> boxes?
> 
> It is registered as normal pci driver:
> 
> static struct pci_driver agp_amd64_pci_driver = {
> 	.name		= "agpgart-amd64",
> 	.id_table	= agp_amd64_pci_table,
> 	.probe		= agp_amd64_probe,
> 	.remove		= agp_amd64_remove,
> #ifdef CONFIG_PM
> 	.suspend	= agp_amd64_suspend,
> 	.resume		= agp_amd64_resume,
> #endif
> };
> 
> ...should it be modified to run early, as other pci devices (USB
> controllers) may rely on this?
> 
> I did this... I'll verify it in 10 hours or so. If someone has amd64
> system with >=4G ram, there should be hibernation problems. This
> should fix it:
> 
> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index d8200ac..4e85178 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -594,12 +594,14 @@ static int agp_amd64_suspend(struct pci_
>  
>  static int agp_amd64_resume(struct pci_dev *pdev)
>  {
> +	printk("agp_amd64: resume\n");
>  	pci_set_power_state(pdev, PCI_D0);
>  	pci_restore_state(pdev);
>  
>  	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA)
>  		nforce3_agp_init(pdev);
>  
> +	printk("agp_amd64: 8151 configure\n");
>  	return amd_8151_configure();
>  }
>  
> @@ -733,8 +735,8 @@ static struct pci_driver agp_amd64_pci_d
>  	.probe		= agp_amd64_probe,
>  	.remove		= agp_amd64_remove,
>  #ifdef CONFIG_PM
> -	.suspend	= agp_amd64_suspend,
> -	.resume		= agp_amd64_resume,
> +	.suspend_late	= agp_amd64_suspend,
> +	.resume_early	= agp_amd64_resume,
>  #endif
>  };

Okay, a couple of questions:

(1) Are you sure that the .suspend() and .resume() callbacks will just work
    with interrupts disabled?

(2) Even if they work, is it sufficient to just move them to the "late" and
    "early" parts?  That is, isn't there anything using the iommu in the
    "early" and "late" callbacks of the other devices?

Rafael
