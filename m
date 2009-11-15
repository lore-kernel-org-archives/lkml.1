Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbZKOWsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbZKOWsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 17:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZKOWsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 17:48:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:29456 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZKOWsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 17:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y7phGt1WcqjyMdtAS3DWzswqcEVR8CLQvYk+JbNoi1Lk1QNohbzaEOFoNwbHd4vMfi
         h3Wi2vzGRiyZ1ex1jSTmv0YiKJLydJPRhU3DSL/h6FMOX2C4Om6LHxJ3GxDbkOeASq72
         2tv8Ct8Qu12yST29P7nHe+chzaXxie+a7inBM=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] leds-gpio: fix possible crash on OF device unbinding
Date: Mon, 16 Nov 2009 01:48:32 +0300
Message-Id: <1258325312-19166-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are leds present in the OF tree, but the GPIOs for (some) of
them are unavailable, led_data doesn't get populated with correct
devices. Then, on device unbinding, one can crash the kernel.

Workaround this by setting led->gpio to invalid value early.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/leds/leds-gpio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 7467980..e5225d2 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -78,6 +78,8 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 {
 	int ret, state;
 
+	led_dat->gpio = -1;
+
 	/* skip leds that aren't available */
 	if (!gpio_is_valid(template->gpio)) {
 		printk(KERN_INFO "Skipping unavailable LED gpio %d (%s)\n",
-- 
1.6.5

