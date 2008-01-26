Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYAZTRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYAZTRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 14:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYAZTRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 14:17:09 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51346 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYAZTRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 14:17:08 -0500
Date: Sat, 26 Jan 2008 20:17:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126191717.GA25701@uranus.ravnborg.org>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479B03AE.3090600@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 04:55:58AM -0500, Jeff Garzik wrote:
> WANG Cong wrote:
> >diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
> >index acb9370..437ebd0 100644
> >--- a/drivers/video/kyro/fbdev.c
> >+++ b/drivers/video/kyro/fbdev.c
> >@@ -90,7 +90,9 @@ static int nomtrr __devinitdata = 0;
> > 
> > /* PCI driver prototypes */
> > static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id 
> > *ent);
> >+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
> > static void kyrofb_remove(struct pci_dev *pdev);
> >+#endif
> > 
> > static struct fb_videomode kyro_modedb[] __devinitdata = {
> > 	{
> >@@ -754,6 +756,7 @@ out_unmap:
> > 	return -EINVAL;
> > }
> > 
> >+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
> > static void __devexit kyrofb_remove(struct pci_dev *pdev)
> > {
> > 	struct fb_info *info = pci_get_drvdata(pdev);
> >@@ -783,6 +786,7 @@ static void __devexit kyrofb_remove(struct pci_dev 
> >*pdev)
> > 	pci_set_drvdata(pdev, NULL);
> > 	framebuffer_release(info);
> > }
> >+#endif
> 
> 
> Quite strange -- due to __devexit_p() and the __devexit marker, ifdefs 
> should not be needed.
> 
> I would look into why that isn't working as designed in these cases...

I checked up on the synclink.c warning.
We have the following code:

static void synclink_remove_one (struct pci_dev *dev);

...

static struct pci_driver synclink_pci_driver = {
        .remove         = __devexit_p(synclink_remove_one),
};

...

static void __devexit synclink_remove_one (struct pci_dev *dev)
{
}

And I double checked the preprocessed source to check
that we applied the __attribute__((__used__)) to the function.

Investigating a bit more I realized that gcc looses the
__used__ attribution due to the prototype.
So there are two correct fixes:
a) move the function up so we do not need the forward
   declaration
b) add a __devexit to the forward decalration too.

I strongly prefer the first version and this is the
correct fix for these cases.

Do we have a gcc bug here - I did not see a definitive answer in gcc docs?

	Sam
