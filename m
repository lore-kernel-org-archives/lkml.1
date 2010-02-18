Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0BRWsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:48:17 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49753 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751085Ab0BRWsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:48:15 -0500
Date: Fri, 19 Feb 2010 01:48:12 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: Cosmetic improvements for error handling in
 gpiochip_add()
Message-ID: <20100218224812.GA11975@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully it makes the code look nicer and makes it easier to extend
this function.

Suggested-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Tue, Feb 09, 2010 at 10:16:44AM -0700, Grant Likely wrote:
[...]
> Rather than doing an else block which will need to be reworked if/when
> any additional code is added to the bottom of this routine, please
> rework the if() block to bail on failure instead of implicitly falling
> through to the return statement.

Here it is.

Andrew,

Please either fold this patch into
  gpiolib-introduce-chip-addition-removal-notifier.patch
or, actually these changes can stay in its own patch for better
sparation of cosmitc/real changes.

Thanks!

 drivers/gpio/gpiolib.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 375c03a..f227c1f 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1099,17 +1099,23 @@ int gpiochip_add(struct gpio_chip *chip)
 
 unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status == 0)
-		status = gpiochip_export(chip);
+
+	if (status)
+		goto fail;
+
+	status = gpiochip_export(chip);
+	if (status)
+		goto fail;
+
+	blocking_notifier_call_chain(&gpio_notifier, GPIO_NOTIFY_CHIP_ADDED,
+				     chip);
+
+	return 0;
 fail:
 	/* failures here can mean systems won't boot... */
-	if (status)
-		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
-			chip->base, chip->base + chip->ngpio - 1,
-			chip->label ? : "generic");
-	else
-		blocking_notifier_call_chain(&gpio_notifier,
-					     GPIO_NOTIFY_CHIP_ADDED, chip);
+	pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
+		chip->base, chip->base + chip->ngpio - 1,
+		chip->label ? : "generic");
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
-- 
1.6.5.7

