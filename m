Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYDAOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYDAOmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYDAOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:42:35 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:56799 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbYDAOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LQeJ5R3UkE7LGqX9KId8vl7OJCDhGDw2CGwCGpBX4pivNXbFH/fhC0Us0hqIe4nhGg5y4z5esSwkZfGnTPGw2yPmTJwLsHZcZKUCM8ZRUvsZU7+4J7gGwkfOZpCW5ABNijeXiKWqRflYbJe3lHwc5IqN2PPdsEftsQBrCqFZiok=
Date: Tue, 1 Apr 2008 10:42:25 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix tosakbd suspend
Message-ID: <20080401144224.GA6436@USFSHXP-002051>
References: <20080331213801.GA9372@doriath.ww600.siemens.net> <20080401034903.GB18041@anvil.corenet.prv> <bc64b4640804010627n172be3fbi9a43eb392c487358@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640804010627n172be3fbi9a43eb392c487358@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 04:27:38PM +0300, Dmitry wrote:
> Hi, Dmitry,
> 
> 2008/4/1, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > Hi Dmitry,
> >
> >
> >  On Tue, Apr 01, 2008 at 01:38:01AM +0400, Dmitry Baryshkov wrote:
> >  > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> >  > ---
> >  >  drivers/input/keyboard/tosakbd.c |    3 +++
> >  >  1 files changed, 3 insertions(+), 0 deletions(-)
> >  >
> >  > diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
> >  > index 3884d1e..306cbe8 100644
> >  > --- a/drivers/input/keyboard/tosakbd.c
> >  > +++ b/drivers/input/keyboard/tosakbd.c
> >  > @@ -210,6 +210,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
> >  >
> >  >       del_timer_sync(&tosakbd->timer);
> >  >
> >
> >
> > What if interrupt comes here? The whole suspend path seems racy with
> >  interrup handler/timer.
> 
> What is the best way to fix it? Moving from suspend to suspend_late
> seems to be a hack.
> Should I call a bunch of disable_irq or just introduce an atomic flag?
> 

How about we take the lock in tosakbd_suspend, set flag indicating that the
picece is suspended, do the discharge and then del_timer_sync()? If you change
tosakbd_scankeyboard() to check for suspend flag and exit as soon as it sees it
it should take care of the most of the issues I think. Something like this:

Subject: Input: tosakbd - fix suspend
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Input: tosakbd - fix suspend

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/tosakbd.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: linux/drivers/input/keyboard/tosakbd.c
===================================================================
--- linux.orig/drivers/input/keyboard/tosakbd.c
+++ linux/drivers/input/keyboard/tosakbd.c
@@ -52,7 +52,7 @@ KEY_X, KEY_F, KEY_SPACE, KEY_APOSTROPHE,
 struct tosakbd {
 	unsigned int keycode[ARRAY_SIZE(tosakbd_keycode)];
 	struct input_dev *input;
-
+	int suspeneded;
 	spinlock_t lock; /* protect kbd scanning */
 	struct timer_list timer;
 };
@@ -133,6 +133,9 @@ static void tosakbd_scankeyboard(struct 
 
 	spin_lock_irqsave(&tosakbd->lock, flags);
 
+	if (tosakbd->suspended)
+		goto out;
+
 	for (col = 0; col < TOSA_KEY_STROBE_NUM; col++) {
 		/*
 		 * Discharge the output driver capacitatance
@@ -174,6 +177,7 @@ static void tosakbd_scankeyboard(struct 
 	if (num_pressed)
 		mod_timer(&tosakbd->timer, jiffies + SCAN_INTERVAL);
 
+ out:
 	spin_unlock_irqrestore(&tosakbd->lock, flags);
 }
 
@@ -200,6 +204,7 @@ static irqreturn_t tosakbd_interrupt(int
 static void tosakbd_timer_callback(unsigned long __dev)
 {
 	struct platform_device *dev = (struct platform_device *)__dev;
+
 	tosakbd_scankeyboard(dev);
 }
 
@@ -207,6 +212,13 @@ static void tosakbd_timer_callback(unsig
 static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct tosakbd *tosakbd = platform_get_drvdata(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&tosakbd->lock, flags);
+	PGSR1 = (PGSR1 & ~TOSA_GPIO_LOW_STROBE_BIT);
+	PGSR2 = (PGSR2 & ~TOSA_GPIO_HIGH_STROBE_BIT);
+	tosakbd->suspended = 1;
+	spin_unlock_irqrestore(&tosakbd->lock, flags);
 
 	del_timer_sync(&tosakbd->timer);
 
@@ -215,6 +227,7 @@ static int tosakbd_suspend(struct platfo
 
 static int tosakbd_resume(struct platform_device *dev)
 {
+	tosakbd->suspended = 0;
 	tosakbd_scankeyboard(dev);
 
 	return 0;
@@ -365,8 +378,8 @@ fail:
 	return error;
 }
 
-static int __devexit tosakbd_remove(struct platform_device *dev) {
-
+static int __devexit tosakbd_remove(struct platform_device *dev)
+{
 	int i;
 	struct tosakbd *tosakbd = platform_get_drvdata(dev);
 
-- 
Dmitry
