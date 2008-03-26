Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbYCZWxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbYCZWxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYCZWx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:53:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47836 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYCZWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:53:26 -0400
Date: Wed, 26 Mar 2008 23:54:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080326225407.GA9378@elf.ucw.cz>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326130052.GF2170@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > CONFIG_AGP=y
> > CONFIG_AGP_AMD64=y
> > CONFIG_AGP_INTEL=y
> > # CONFIG_AGP_SIS is not set
> > CONFIG_AGP_VIA=y
> > CONFIG_DRM=y
> > # CONFIG_DRM_TDFX is not set
> > 
> > ...do I need to enable something more?
> 
> Should have worked then. Ok modulo bugs. Maybe the ordering
> is wrong now (AGP resume would need to run before anything
> using the IOMMU)

So agp_amd64_resume() is responsible for reiniting iommu on new amd64
boxes?

It is registered as normal pci driver:

static struct pci_driver agp_amd64_pci_driver = {
	.name		= "agpgart-amd64",
	.id_table	= agp_amd64_pci_table,
	.probe		= agp_amd64_probe,
	.remove		= agp_amd64_remove,
#ifdef CONFIG_PM
	.suspend	= agp_amd64_suspend,
	.resume		= agp_amd64_resume,
#endif
};

...should it be modified to run early, as other pci devices (USB
controllers) may rely on this?

I did this... I'll verify it in 10 hours or so. If someone has amd64
system with >=4G ram, there should be hibernation problems. This
should fix it:

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index d8200ac..4e85178 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -594,12 +594,14 @@ static int agp_amd64_suspend(struct pci_
 
 static int agp_amd64_resume(struct pci_dev *pdev)
 {
+	printk("agp_amd64: resume\n");
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
 	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA)
 		nforce3_agp_init(pdev);
 
+	printk("agp_amd64: 8151 configure\n");
 	return amd_8151_configure();
 }
 
@@ -733,8 +735,8 @@ static struct pci_driver agp_amd64_pci_d
 	.probe		= agp_amd64_probe,
 	.remove		= agp_amd64_remove,
 #ifdef CONFIG_PM
-	.suspend	= agp_amd64_suspend,
-	.resume		= agp_amd64_resume,
+	.suspend_late	= agp_amd64_suspend,
+	.resume_early	= agp_amd64_resume,
 #endif
 };
 


								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
