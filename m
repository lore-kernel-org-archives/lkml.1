Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYHHDlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYHHDlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYHHDlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:41:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYHHDlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:41:02 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1218164391.17642.14.camel@obelisk.thedillows.org>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
	 <1218159490.2553.13.camel@jaswinder.satnam>
	 <1218164391.17642.14.camel@obelisk.thedillows.org>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 09:09:20 +0530
Message-Id: <1218166760.2540.18.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Thu, 2008-08-07 at 22:59 -0400, David Dillow wrote:
> > 
> > Do you think we still need above comments ?
> 
> No, the comments will be unneeded, but you don't need an extra function
> to handle this, and I'm not real keen about the release_firmware_all()
> interface -- it doesn't match up with the get/put semantics of the
> reference count.
> 
> I don't like releasing the firmware before the pci_unregister_driver()
> call. I worry about ordering issues during cleanup, though I'll admit I
> have not yet researched if it will be a problem. In any event, if you're
> going to request it once per adapter in typhoon_init_one(), then it
> should be in the per-device struct, and released in
> typhoon_remove_one().
> 

Here is updated patch :

diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 2a26ba5..1638e87 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -2615,6 +2615,9 @@ typhoon_remove_one(struct pci_dev *pdev)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 	typhoon_reset(tp->ioaddr, NoWait);
+
+	release_firmware(typhoon_fw);
+
 	pci_iounmap(pdev, tp->ioaddr);
 	pci_free_consistent(pdev, sizeof(struct typhoon_shared),
 			    tp->shared, tp->shared_dma);
@@ -2645,8 +2648,6 @@ typhoon_init(void)
 static void __exit
 typhoon_cleanup(void)
 {
-	release_firmware_all(typhoon_fw);
-
 	pci_unregister_driver(&typhoon_driver);
 }
 


> Drop the typhoon patches, and once you fix the problems in the core,
> I'll respin the patch in a style I'm comfortable with. It will also need
> to be tested before it goes upstream.
> 

I can understand you are very worried about typhoon.
But this is only first version of patches. This will goto David
WoodHouse tree and he will again revise it.

And driver is yours you can change it as per your comfort, No one can
stop you or typhoon ;)

Thank you,

Jaswinder Singh.

