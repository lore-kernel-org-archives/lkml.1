Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZHFM7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZHFM7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHFM7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:59:16 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:44623 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZHFM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:59:12 -0400
Date: Thu, 6 Aug 2009 14:59:09 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Phil Blundell <pb@handhelds.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 4/5] input: gpio-keys: switch to new
	dev_pm_ops
Message-ID: <20090806125909.GJ19257@buzzloop.caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de> <74d0deb30908051315l43b00731yb79f7937707068ec@mail.gmail.com> <20090805223342.GG19257@buzzloop.caiaq.de> <200908060251.55157.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908060251.55157.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:51:55AM +0200, Rafael J. Wysocki wrote:
> On Thursday 06 August 2009, Daniel Mack wrote:
> > On Wed, Aug 05, 2009 at 10:15:52PM +0200, pHilipp Zabel wrote:
> > > On Wed, Aug 5, 2009 at 8:29 PM, Daniel Mack<daniel@caiaq.de> wrote:
> > > > -static int gpio_keys_resume(struct platform_device *pdev)
> > > > +static int gpio_keys_resume(struct device *dev)
> > > >  {
> > > > -       struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
> > > > +       struct gpio_keys_platform_data *pdata = dev->platform_data;
> > > >        int i;
> > > >
> > > > -       if (device_may_wakeup(&pdev->dev)) {
> > > > +       if (device_may_wakeup(dev)) {
> > > >                for (i = 0; i < pdata->nbuttons; i++) {
> > > >                        struct gpio_keys_button *button = &pdata->buttons[i];
> > > >                        if (button->wakeup) {
> > > > @@ -251,19 +251,27 @@ static int gpio_keys_resume(struct platform_device *pdev)
> > > >
> > > >        return 0;
> > > >  }
> > > > +
> > > > +static struct dev_pm_ops gpio_keys_pm_ops = {
> > > > +       .suspend        = gpio_keys_suspend,
> > > > +       .freeze         = gpio_keys_suspend,
> > > > +       .resume         = gpio_keys_resume,
> > > > +       .thaw           = gpio_keys_resume,
> > > 
> > > I'm not sure I understand hibernation correctly, but isn't
> > > .freeze/.thaw about saving state and halting/resuming the device
> > > operation only?
> 
> It is.
> 
> > > It seems to me that enabling system wakeup functionality should go
> > > into .poweroff. (See <linux/pm.h>)
> 
> That's correct.
> 
> And .restore() plays the role of ".resume() from hibernation".

Hence, In case of this driver which only calls disable_irq/enable_irq,
setting .poweroff and .restore seems to suffice? So does the patch
below.

Thanks,
Daniel


>From afa35cebccf49a24613e711afb8009fb6aadce0e Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 5 Aug 2009 15:28:54 +0200
Subject: [PATCH 3/3] input: gpio-keys: switch to new dev_pm_ops

The callbacks for the implemented functions are .poweroff and .restore,
as they only care for {dis,en}able_irq(). Renamed the functions
to reflect that.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Phil Blundell <pb@handhelds.org>
Cc: linux-input@vger.kernel.org
---
 drivers/input/keyboard/gpio_keys.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index efed0c9..8e670d4 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -216,12 +216,12 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 
 
 #ifdef CONFIG_PM
-static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
+static int gpio_keys_poweroff(struct device *dev)
 {
-	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_keys_platform_data *pdata = dev->platform_data;
 	int i;
 
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
 			if (button->wakeup) {
@@ -234,12 +234,12 @@ static int gpio_keys_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int gpio_keys_resume(struct platform_device *pdev)
+static int gpio_keys_restore(struct device *dev)
 {
-	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_keys_platform_data *pdata = dev->platform_data;
 	int i;
 
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		for (i = 0; i < pdata->nbuttons; i++) {
 			struct gpio_keys_button *button = &pdata->buttons[i];
 			if (button->wakeup) {
@@ -251,19 +251,25 @@ static int gpio_keys_resume(struct platform_device *pdev)
 
 	return 0;
 }
+
+static struct dev_pm_ops gpio_keys_pm_ops = {
+	.poweroff	= gpio_keys_poweroff,
+	.restore	= gpio_keys_restore,
+};
+
+#define GPIO_KEYS_PM_OPS (&gpio_keys_pm_ops)
+
 #else
-#define gpio_keys_suspend	NULL
-#define gpio_keys_resume	NULL
+#define GPIO_KEYS_PM_OPS NULL
 #endif
 
 static struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
 	.remove		= __devexit_p(gpio_keys_remove),
-	.suspend	= gpio_keys_suspend,
-	.resume		= gpio_keys_resume,
 	.driver		= {
 		.name	= "gpio-keys",
 		.owner	= THIS_MODULE,
+		.pm	= GPIO_KEYS_PM_OPS,
 	}
 };
 
-- 
1.6.3.3

