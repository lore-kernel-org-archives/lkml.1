Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXA2Mzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXA2Mzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 07:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXA2Mzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 07:55:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:58053 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXA2Mzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 07:55:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IHlMcfo3qp1NiqoyGHv6YaEhHEo5bctAulO3RisOws2z8eaQsPRyR3B7cwTh+hMPsWOVAwddYeFdqFyn1f+8iIgDesNMDn/5LkTUOSZvv6IYKnsjDX6fK4W8tdiqFHPXisutVVHgulhPdg0scG/knZ61so0w5+b2iXYnx6AYZA4=
Message-ID: <195c7a900701290455o3ff9fc15k305637f8ced24caf@mail.gmail.com>
Date: Mon, 29 Jan 2007 13:55:41 +0100
From: "roucaries bastien" <roucaries.bastien@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: Bcm43xx oops after suspend to disk
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "bcm43xx devel" <Bcm43xx-dev@lists.berlios.de>
In-Reply-To: <20070129115842.GA4928@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net>
	 <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>
	 <45BA246B.6030505@lwfinger.net> <20070129115842.GA4928@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > >> Do you have the log stuff that precedes this part? In particular, was
> > >> there a assertion that failed?
> > >>
> > > It is oops on resume and no asseertion failled this boot. However I
> > > have usually a lot of
> > > bcm43xx: ASSERTION FAILED (radio_attenuation < 10) at:
> > > drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1496:bcm43xx_find_lopair()
> >
> > Those are well known and do not affect this problem.
> >
> > > Moreover after the first oops I have a second oops (Surelly a
> > > consequence of the first).
> >
> > I think that is right.
> >
> > Unfortunately, I cannot test for this problem on my system as it doesn't suspend at all.
>
> Can you try to debug that? swsusp is very easy to get going these
> days. And with minimum drivers, it tends to work very reliably. Any
> help I can provide?

I don't think so. Larry sends me a patch I will test it this week
(perhaps tomorow or thursday). Thank you

index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -4244,30 +4244,12 @@ static int bcm43xx_suspend(struct pci_de
 {
        struct net_device *net_dev = pci_get_drvdata(pdev);
        struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-       int err;

        dprintk(KERN_INFO PFX "Suspending...\n");
-
-       netif_device_detach(net_dev);
-       bcm->was_initialized = 0;
-       if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
-               bcm->was_initialized = 1;
-               ieee80211softmac_stop(net_dev);
-               err = bcm43xx_disable_interrupts_sync(bcm);
-               if (unlikely(err)) {
-                       dprintk(KERN_ERR PFX "Suspend failed.\n");
-                       return -EAGAIN;
-               }
-               bcm->firmware_norelease = 1;
-               bcm43xx_free_board(bcm);
-               bcm->firmware_norelease = 0;
-       }
-       bcm43xx_chipset_detach(bcm);
-
-       pci_save_state(pdev);
-       pci_disable_device(pdev);
-       pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
+       bcm43xx_debugfs_remove_device(bcm);
+       unregister_netdev(net_dev);
+       bcm43xx_detach_board(bcm);
+       free_ieee80211softmac(net_dev);
        dprintk(KERN_INFO PFX "Device suspended.\n");

        return 0;
@@ -4275,32 +4257,9 @@ static int bcm43xx_suspend(struct pci_de

 static int bcm43xx_resume(struct pci_dev *pdev)
 {
-       struct net_device *net_dev = pci_get_drvdata(pdev);
-       struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-       int err = 0;
-
        dprintk(KERN_INFO PFX "Resuming...\n");

-       pci_set_power_state(pdev, 0);
-       err = pci_enable_device(pdev);
-       if (err) {
-               printk(KERN_ERR PFX "Failure with pci_enable_device!\n");
-               return err;
-       }
-       pci_restore_state(pdev);
-
-       bcm43xx_chipset_attach(bcm);
-       if (bcm->was_initialized)
-               err = bcm43xx_init_board(bcm);
-       if (err) {
-               printk(KERN_ERR PFX "Resume failed!\n");
-               return err;
-       }
-       netif_device_attach(net_dev);
-
-       dprintk(KERN_INFO PFX "Device resumed.\n");
-
-       return 0;
+       return bcm43xx_init_one(pdev, NULL);
 }

 #endif                         /* CONFIG_PM */







Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -4244,30 +4244,12 @@ static int bcm43xx_suspend(struct pci_de
 {
        struct net_device *net_dev = pci_get_drvdata(pdev);
        struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-       int err;

        dprintk(KERN_INFO PFX "Suspending...\n");
-
-       netif_device_detach(net_dev);
-       bcm->was_initialized = 0;
-       if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
-               bcm->was_initialized = 1;
-               ieee80211softmac_stop(net_dev);
-               err = bcm43xx_disable_interrupts_sync(bcm);
-               if (unlikely(err)) {
-                       dprintk(KERN_ERR PFX "Suspend failed.\n");
-                       return -EAGAIN;
-               }
-               bcm->firmware_norelease = 1;
-               bcm43xx_free_board(bcm);
-               bcm->firmware_norelease = 0;
-       }
-       bcm43xx_chipset_detach(bcm);
-
-       pci_save_state(pdev);
-       pci_disable_device(pdev);
-       pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
+       bcm43xx_debugfs_remove_device(bcm);
+       unregister_netdev(net_dev);
+       bcm43xx_detach_board(bcm);
+       free_ieee80211softmac(net_dev);
        dprintk(KERN_INFO PFX "Device suspended.\n");

        return 0;
@@ -4275,32 +4257,9 @@ static int bcm43xx_suspend(struct pci_de

 static int bcm43xx_resume(struct pci_dev *pdev)
 {
-       struct net_device *net_dev = pci_get_drvdata(pdev);
-       struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-       int err = 0;
-
        dprintk(KERN_INFO PFX "Resuming...\n");

-       pci_set_power_state(pdev, 0);
-       err = pci_enable_device(pdev);
-       if (err) {
-               printk(KERN_ERR PFX "Failure with pci_enable_device!\n");
-               return err;
-       }
-       pci_restore_state(pdev);
-
-       bcm43xx_chipset_attach(bcm);
-       if (bcm->was_initialized)
-               err = bcm43xx_init_board(bcm);
-       if (err) {
-               printk(KERN_ERR PFX "Resume failed!\n");
-               return err;
-       }
-       netif_device_attach(net_dev);
-
-       dprintk(KERN_INFO PFX "Device resumed.\n");
-
-       return 0;
+       return bcm43xx_init_one(pdev, NULL);
 }

 #endif                         /* CONFIG_PM */

> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
