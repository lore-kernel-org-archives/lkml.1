Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYBKAXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYBKAXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYBKAXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:23:07 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43062 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756718AbYBKAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:23:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=U4YA6zfp0SmQpNLQN3DsPJ6ozgyP6QCs3fpVvxkVSebOUT5mZTz8ZhtGv5S520pUaZNpEVEydTi5SV6FvWVoNRtYlkoNnr7GdL0DNkJBISnQy4URzzfjCmVv7+pCgFf1dBn8Am3ub2WhW0jNnpPeaaevoveZ80tJh7GQWeDuhg0=  ;
X-YMail-OSG: 16Tpp2QVM1nrhBiXSm0.i8LUQ8f45qzEWxkpWN4cM5cp8Y9xadt1saA7Med7fj5mvEIjuYNT4Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc1 1/3] gpiolib: better rmmod infrastructure
Date: Sun, 10 Feb 2008 16:22:10 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802101622.10937.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

As long as one or more GPIOs on a gpio chip are used its driver should not 
be unloaded.  The existing mechanism (gpiochip_remove failure) doesn't
address that, since rmmod can no longer be made to fail by having the
cleanup code report errors.  Module usecounts are the solution.

Assuming standard "initialize struct to zero" policies, this change won't
affect SOC platform drivers.  However, drivers for external chips (on I2C
and SPI busses) should be updated if they can be built as modules.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
[ gpio_ensure_requested() needs to update module usecounts too ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c     |   15 ++++++++++++---
 include/asm-generic/gpio.h |    2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

--- g26.orig/drivers/gpio/gpiolib.c	2008-02-10 16:06:30.000000000 -0800
+++ g26/drivers/gpio/gpiolib.c	2008-02-10 16:18:35.000000000 -0800
@@ -68,6 +68,9 @@ static void gpio_ensure_requested(struct
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
 		desc_set_label(desc, "[auto]");
+		if (!try_module_get(desc->chip->owner))
+			pr_err("GPIO-%d: module can't be gotten \n",
+					(int)(desc - gpio_desc));
 	}
 }
 
@@ -177,6 +180,9 @@ int gpio_request(unsigned gpio, const ch
 	if (desc->chip == NULL)
 		goto done;
 
+	if (!try_module_get(desc->chip->owner))
+		goto done;
+
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled.
 	 */
@@ -184,8 +190,10 @@ int gpio_request(unsigned gpio, const ch
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		desc_set_label(desc, label ? : "?");
 		status = 0;
-	} else
+	} else {
 		status = -EBUSY;
+		module_put(desc->chip->owner);
+	}
 
 done:
 	if (status)
@@ -209,9 +217,10 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags))
+	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
 		desc_set_label(desc, NULL);
-	else
+		module_put(desc->chip->owner);
+	} else
 		WARN_ON(extra_checks);
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
--- g26.orig/include/asm-generic/gpio.h	2008-02-10 16:06:30.000000000 -0800
+++ g26/include/asm-generic/gpio.h	2008-02-10 16:18:30.000000000 -0800
@@ -17,6 +17,7 @@
 #endif
 
 struct seq_file;
+struct module;
 
 /**
  * struct gpio_chip - abstract a GPIO controller
@@ -48,6 +49,7 @@ struct seq_file;
  */
 struct gpio_chip {
 	char			*label;
+	struct module		*owner;
 
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
