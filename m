Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYDBOQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYDBOQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYDBOQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:16:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27566 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYDBOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Io8blQATDjb0iOekHyYsfssec6z/G6jO/q3qTG38YiCi9Wq9W1vG3i30bAEv5Rc9AvJzYqBjYob71s6fX6P+oAKWQtzld2Jm7e3BW5lhJop4/bdnDNebrcksaL/NL42c+IHAOyxrOWATihs2Qsv6DGgLv0QJCFzdcTA4BfJ/goE=
Date: Wed, 2 Apr 2008 18:16:32 +0400
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix tosakbd suspend
Message-ID: <20080402141632.GA19698@doriath.ww600.siemens.net>
References: <20080401144224.GA6436@USFSHXP-002051>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401144224.GA6436@USFSHXP-002051>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Dmitry Torokhov <dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/1, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Tue, Apr 01, 2008 at 04:27:38PM +0300, Dmitry wrote:
> > Hi, Dmitry,
> >
> > 2008/4/1, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > > Hi Dmitry,
> > >
> > >
> > >  On Tue, Apr 01, 2008 at 01:38:01AM +0400, Dmitry Baryshkov wrote:
> > >  > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > >  > ---
> > >  >  drivers/input/keyboard/tosakbd.c |    3 +++
> > >  >  1 files changed, 3 insertions(+), 0 deletions(-)
> > >  >
> > >  > diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
> > >  > index 3884d1e..306cbe8 100644
> > >  > --- a/drivers/input/keyboard/tosakbd.c
> > >  > +++ b/drivers/input/keyboard/tosakbd.c
> > >  > @@ -210,6 +210,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
> > >  >
> > >  >       del_timer_sync(&tosakbd->timer);
> > >  >
> > >
> > >
> > > What if interrupt comes here? The whole suspend path seems racy with
> > >  interrup handler/timer.
> >
> > What is the best way to fix it? Moving from suspend to suspend_late
> > seems to be a hack.
> > Should I call a bunch of disable_irq or just introduce an atomic flag?
> >
> 
> How about we take the lock in tosakbd_suspend, set flag indicating that the
> picece is suspended, do the discharge and then del_timer_sync()? If you change
> tosakbd_scankeyboard() to check for suspend flag and exit as soon as it sees it
> it should take care of the most of the issues I think. Something like this:

Fixed two minor glitches. Works for me. Please add it to your tree.

Subject: Input: tosakbd - fix suspend
Input: tosakbd - fix suspend

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/tosakbd.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
index 3884d1e..a247006 100644
--- a/drivers/input/keyboard/tosakbd.c
+++ b/drivers/input/keyboard/tosakbd.c
@@ -52,7 +52,7 @@ KEY_X, KEY_F, KEY_SPACE, KEY_APOSTROPHE, TOSA_KEY_MAIL, KEY_LEFT, KEY_DOWN, KEY_
 struct tosakbd {
 	unsigned int keycode[ARRAY_SIZE(tosakbd_keycode)];
 	struct input_dev *input;
-
+	int suspended;
 	spinlock_t lock; /* protect kbd scanning */
 	struct timer_list timer;
 };
@@ -133,6 +133,9 @@ static void tosakbd_scankeyboard(struct platform_device *dev)
 
 	spin_lock_irqsave(&tosakbd->lock, flags);
 
+	if (tosakbd->suspended)
+		goto out;
+
 	for (col = 0; col < TOSA_KEY_STROBE_NUM; col++) {
 		/*
 		 * Discharge the output driver capacitatance
@@ -174,6 +177,7 @@ static void tosakbd_scankeyboard(struct platform_device *dev)
 	if (num_pressed)
 		mod_timer(&tosakbd->timer, jiffies + SCAN_INTERVAL);
 
+ out:
 	spin_unlock_irqrestore(&tosakbd->lock, flags);
 }
 
@@ -200,6 +204,7 @@ static irqreturn_t tosakbd_interrupt(int irq, void *__dev)
 static void tosakbd_timer_callback(unsigned long __dev)
 {
 	struct platform_device *dev = (struct platform_device *)__dev;
+
 	tosakbd_scankeyboard(dev);
 }
 
@@ -207,6 +212,13 @@ static void tosakbd_timer_callback(unsigned long __dev)
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
 
@@ -215,6 +227,9 @@ static int tosakbd_suspend(struct platform_device *dev, pm_message_t state)
 
 static int tosakbd_resume(struct platform_device *dev)
 {
+	struct tosakbd *tosakbd = platform_get_drvdata(dev);
+
+	tosakbd->suspended = 0;
 	tosakbd_scankeyboard(dev);
 
 	return 0;
@@ -365,8 +380,8 @@ fail:
 	return error;
 }
 
-static int __devexit tosakbd_remove(struct platform_device *dev) {
-
+static int __devexit tosakbd_remove(struct platform_device *dev)
+{
 	int i;
 	struct tosakbd *tosakbd = platform_get_drvdata(dev);
 
-- 
1.5.4.4


-- 
With best wishes
Dmitry

