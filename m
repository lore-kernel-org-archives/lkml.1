Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbXF0VER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbXF0VER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXF0VEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:04:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51377 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXF0VEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:04:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: [RFC][PATCH -mm] PM: Do not use saved_state from struct dev_pm_info on ARM (was: Re: patch pm-remove-saved_state-from-struct-dev_pm_info.patch added to gregkh-2.6 tree)
Date: Wed, 27 Jun 2007 23:11:03 +0200
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, david-b@pacbell.net, greg@kroah.com,
       pavel@ucw.cz, stern@rowland.harvard.edu, rmk@arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
References: <1181861863@kroah.com> <200706262300.08543.rjw@sisk.pl> <20070626210311.GC7814@suse.de>
In-Reply-To: <20070626210311.GC7814@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272311.04256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 26 June 2007 23:03, Greg KH wrote:
> On Tue, Jun 26, 2007 at 11:00:06PM +0200, Rafael J. Wysocki wrote:
> > On Friday, 15 June 2007 00:57, gregkh@suse.de wrote:
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >      Subject: PM: Remove saved_state from struct dev_pm_info
> > > 
> > > to my gregkh-2.6 tree.  Its filename is
> > > 
> > >      pm-remove-saved_state-from-struct-dev_pm_info.patch
> > > 
> > > This tree can be found at 
> > >     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> > > 
> > > 
> > > From rjw@sisk.pl  Thu Jun 14 15:47:15 2007
> > > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > To: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: PM: Remove saved_state from struct dev_pm_info
> > > Date: Wed, 13 Jun 2007 15:55:34 +0200
> > > Cc: Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
> > > Content-Disposition: inline
> > > Message-Id: <200706131555.37277.rjw@sisk.pl>
> > > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > The saved_state member of struct dev_pm_info, defined in include/linux/pm.h, is
> > > not used anywhere, so it can be removed.
> > 
> > Unfortunately this is wrong, as I've just found three drivers in the ARM tree
> > that use it.  I don't know why I didn't see them when I was creating the patch,
> > though. :-(
> 
> Why not just fix up the ARM drivers instead?

OK, let's try. :-)

The following patch has only been compilation tested.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of 'struct dev_pm_info' that's going to be removed is
used in arch/arm/common/locomo.c, arch/arm/common/sa1111.c and
arch/arm/mach-sa1100/neponset.c.  Change the code in there to use local
variables for saving the state of devices during suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/common/locomo.c        |   17 +++--------------
 arch/arm/common/sa1111.c        |   12 +++++++-----
 arch/arm/mach-sa1100/neponset.c |   15 ++++-----------
 3 files changed, 14 insertions(+), 30 deletions(-)

Index: linux-2.6.22-rc6/arch/arm/common/locomo.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/common/locomo.c	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.22-rc6/arch/arm/common/locomo.c	2007-06-27 21:48:15.000000000 +0200
@@ -553,20 +553,14 @@ struct locomo_save_data {
 	u16	LCM_GPE;
 	u16	LCM_ASD;
 	u16	LCM_SPIMD;
-};
+} locomo_saved_state;
 
 static int locomo_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
-	struct locomo_save_data *save;
+	struct locomo_save_data *save = &locomo_saved_state;
 	unsigned long flags;
 
-	save = kmalloc(sizeof(struct locomo_save_data), GFP_KERNEL);
-	if (!save)
-		return -ENOMEM;
-
-	dev->dev.power.saved_state = (void *) save;
-
 	spin_lock_irqsave(&lchip->lock, flags);
 
 	save->LCM_GPO     = locomo_readl(lchip->base + LOCOMO_GPO);	/* GPIO */
@@ -602,13 +596,9 @@ static int locomo_suspend(struct platfor
 static int locomo_resume(struct platform_device *dev)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
-	struct locomo_save_data *save;
+	struct locomo_save_data *save = &locomo_saved_state;
 	unsigned long r;
 	unsigned long flags;
-	
-	save = (struct locomo_save_data *) dev->dev.power.saved_state;
-	if (!save)
-		return 0;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
@@ -628,7 +618,6 @@ static int locomo_resume(struct platform
 	locomo_writel(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
-	kfree(save);
 
 	return 0;
 }
Index: linux-2.6.22-rc6/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/common/sa1111.c	2007-06-25 21:07:24.000000000 +0200
+++ linux-2.6.22-rc6/arch/arm/common/sa1111.c	2007-06-27 21:43:50.000000000 +0200
@@ -811,6 +811,8 @@ struct sa1111_save_data {
 
 #ifdef CONFIG_PM
 
+static struct sa1111_save_data *sa1111_saved_state;
+
 static int sa1111_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct sa1111 *sachip = platform_get_drvdata(dev);
@@ -822,7 +824,7 @@ static int sa1111_suspend(struct platfor
 	save = kmalloc(sizeof(struct sa1111_save_data), GFP_KERNEL);
 	if (!save)
 		return -ENOMEM;
-	dev->dev.power.saved_state = save;
+	sa1111_saved_state = save;
 
 	spin_lock_irqsave(&sachip->lock, flags);
 
@@ -878,7 +880,7 @@ static int sa1111_resume(struct platform
 	unsigned long flags, id;
 	void __iomem *base;
 
-	save = (struct sa1111_save_data *)dev->dev.power.saved_state;
+	save = sa1111_saved_state;
 	if (!save)
 		return 0;
 
@@ -923,7 +925,7 @@ static int sa1111_resume(struct platform
 
 	spin_unlock_irqrestore(&sachip->lock, flags);
 
-	dev->dev.power.saved_state = NULL;
+	sa1111_saved_state = NULL;
 	kfree(save);
 
 	return 0;
@@ -958,8 +960,8 @@ static int sa1111_remove(struct platform
 		platform_set_drvdata(pdev, NULL);
 
 #ifdef CONFIG_PM
-		kfree(pdev->dev.power.saved_state);
-		pdev->dev.power.saved_state = NULL;
+		kfree(sa1111_saved_state);
+		sa1111_saved_state = NULL;
 #endif
 	}
 
Index: linux-2.6.22-rc6/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/mach-sa1100/neponset.c	2007-06-25 21:07:25.000000000 +0200
+++ linux-2.6.22-rc6/arch/arm/mach-sa1100/neponset.c	2007-06-27 21:43:50.000000000 +0200
@@ -185,28 +185,21 @@ static int __devinit neponset_probe(stru
 /*
  * LDM power management.
  */
+static unsigned int neponset_saved_state;
+
 static int neponset_suspend(struct platform_device *dev, pm_message_t state)
 {
 	/*
 	 * Save state.
 	 */
-	if (!dev->dev.power.saved_state)
-		dev->dev.power.saved_state = kmalloc(sizeof(unsigned int), GFP_KERNEL);
-	if (!dev->dev.power.saved_state)
-		return -ENOMEM;
-
-	*(unsigned int *)dev->dev.power.saved_state = NCR_0;
+	neponset_saved_state = NCR_0;
 
 	return 0;
 }
 
 static int neponset_resume(struct platform_device *dev)
 {
-	if (dev->dev.power.saved_state) {
-		NCR_0 = *(unsigned int *)dev->dev.power.saved_state;
-		kfree(dev->dev.power.saved_state);
-		dev->dev.power.saved_state = NULL;
-	}
+	NCR_0 = neponset_saved_state;
 
 	return 0;
 }
