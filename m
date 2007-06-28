Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbXF1Plx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbXF1Plx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbXF1Pll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:41:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbXF1Plj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:41:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH -mm] PM: Do not use saved_state from struct dev_pm_info on ARM (was: Re: patch pm-remove-saved_state-from-struct-dev_pm_info.patch added to gregkh-2.6 tree)
Date: Thu, 28 Jun 2007 17:48:40 +0200
User-Agent: KMail/1.9.5
Cc: david-b@pacbell.net, pavel@ucw.cz, stern@rowland.harvard.edu,
       rmk@arm.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
References: <1181861863@kroah.com> <20070626210311.GC7814@suse.de> <200706272311.04256.rjw@sisk.pl>
In-Reply-To: <200706272311.04256.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281748.41473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 June 2007 23:11, Rafael J. Wysocki wrote:
> On Tuesday, 26 June 2007 23:03, Greg KH wrote:
> > On Tue, Jun 26, 2007 at 11:00:06PM +0200, Rafael J. Wysocki wrote:
> > > On Friday, 15 June 2007 00:57, gregkh@suse.de wrote:
> > > > 
> > > > This is a note to let you know that I've just added the patch titled
> > > > 
> > > >      Subject: PM: Remove saved_state from struct dev_pm_info
> > > > 
> > > > to my gregkh-2.6 tree.  Its filename is
> > > > 
> > > >      pm-remove-saved_state-from-struct-dev_pm_info.patch
> > > > 
> > > > This tree can be found at 
> > > >     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> > > > 
> > > > 
> > > > From rjw@sisk.pl  Thu Jun 14 15:47:15 2007
> > > > From: "Rafael J. Wysocki" <rjw@sisk.pl>
> > > > To: Andrew Morton <akpm@linux-foundation.org>
> > > > Subject: PM: Remove saved_state from struct dev_pm_info
> > > > Date: Wed, 13 Jun 2007 15:55:34 +0200
> > > > Cc: Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>
> > > > Content-Disposition: inline
> > > > Message-Id: <200706131555.37277.rjw@sisk.pl>
> > > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > The saved_state member of struct dev_pm_info, defined in include/linux/pm.h, is
> > > > not used anywhere, so it can be removed.
> > > 
> > > Unfortunately this is wrong, as I've just found three drivers in the ARM tree
> > > that use it.  I don't know why I didn't see them when I was creating the patch,
> > > though. :-(
> > 
> > Why not just fix up the ARM drivers instead?
> 
> OK, let's try. :-)
> 
> The following patch has only been compilation tested.
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The saved_state member of 'struct dev_pm_info' that's going to be removed is
> used in arch/arm/common/locomo.c, arch/arm/common/sa1111.c and
> arch/arm/mach-sa1100/neponset.c.  Change the code in there to use local
> variables for saving the state of devices during suspend.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Russell says that the affected drivers were coded to support multiple instances
of the same device which the $subject patch doesn't take into account (still,
as far as the neponset is concerned, I think that there can be only one
instance of NCR_0 in the system).

Updated (compilation tested) patch follows.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

The saved_state member of 'struct dev_pm_info' that's going to be removed is
used in arch/arm/common/locomo.c, arch/arm/common/sa1111.c and
arch/arm/mach-sa1100/neponset.c.  Change the code in there to use the drivers'
own per-device data structures or static variables for saving the state of
devices during suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/common/locomo.c        |    9 +++++++--
 arch/arm/common/sa1111.c        |   13 ++++++++-----
 arch/arm/mach-sa1100/neponset.c |   15 ++++-----------
 3 files changed, 19 insertions(+), 18 deletions(-)

Index: linux-2.6.22-rc6/arch/arm/common/locomo.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/common/locomo.c
+++ linux-2.6.22-rc6/arch/arm/common/locomo.c
@@ -60,6 +60,9 @@ struct locomo {
 	unsigned int irq;
 	spinlock_t lock;
 	void __iomem *base;
+#ifdef CONFIG_PM
+	void *saved_state;
+#endif
 };
 
 struct locomo_dev_info {
@@ -565,7 +568,7 @@ static int locomo_suspend(struct platfor
 	if (!save)
 		return -ENOMEM;
 
-	dev->dev.power.saved_state = (void *) save;
+	lchip->saved_state = save;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
@@ -606,7 +609,7 @@ static int locomo_resume(struct platform
 	unsigned long r;
 	unsigned long flags;
 	
-	save = (struct locomo_save_data *) dev->dev.power.saved_state;
+	save = lchip->saved_state;
 	if (!save)
 		return 0;
 
@@ -628,6 +631,8 @@ static int locomo_resume(struct platform
 	locomo_writel(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
+
+	lchip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
Index: linux-2.6.22-rc6/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/common/sa1111.c
+++ linux-2.6.22-rc6/arch/arm/common/sa1111.c
@@ -51,6 +51,9 @@ struct sa1111 {
 	int		irq;
 	spinlock_t	lock;
 	void __iomem	*base;
+#ifdef CONFIG_PM
+	void		*saved_state;
+#endif
 };
 
 /*
@@ -822,7 +825,7 @@ static int sa1111_suspend(struct platfor
 	save = kmalloc(sizeof(struct sa1111_save_data), GFP_KERNEL);
 	if (!save)
 		return -ENOMEM;
-	dev->dev.power.saved_state = save;
+	sachip->saved_state = save;
 
 	spin_lock_irqsave(&sachip->lock, flags);
 
@@ -878,7 +881,7 @@ static int sa1111_resume(struct platform
 	unsigned long flags, id;
 	void __iomem *base;
 
-	save = (struct sa1111_save_data *)dev->dev.power.saved_state;
+	save = sachip->saved_state;
 	if (!save)
 		return 0;
 
@@ -923,7 +926,7 @@ static int sa1111_resume(struct platform
 
 	spin_unlock_irqrestore(&sachip->lock, flags);
 
-	dev->dev.power.saved_state = NULL;
+	sachip->saved_state = NULL;
 	kfree(save);
 
 	return 0;
@@ -958,8 +961,8 @@ static int sa1111_remove(struct platform
 		platform_set_drvdata(pdev, NULL);
 
 #ifdef CONFIG_PM
-		kfree(pdev->dev.power.saved_state);
-		pdev->dev.power.saved_state = NULL;
+		kfree(sachip->saved_state);
+		sachip->saved_state = NULL;
 #endif
 	}
 
Index: linux-2.6.22-rc6/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6.22-rc6.orig/arch/arm/mach-sa1100/neponset.c
+++ linux-2.6.22-rc6/arch/arm/mach-sa1100/neponset.c
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
