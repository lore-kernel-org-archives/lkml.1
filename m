Return-Path: <linux-kernel-owner+w=401wt.eu-S1751506AbYHQT0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbYHQT0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYHQTZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:25:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:30218 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbYHQTZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JD7irnQdWTb7y9QukIxmwskb1cDk95SAmAQy7GD5fHh+vLDpkhoRUY+tTcZuURCa/y
         K122PLhkf2zPu/4toLqTEYWtGOa0FlQYdoGRYjmbkSnPRHaJ6SkjkYFpbrpDoAe2EssM
         bM9lYcPoFvKqmibRnrKNdihkXxMsw8xfOFyqE=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] max7301: fix the race between chip addition and pins reconfiguration
Date: Sun, 17 Aug 2008 23:24:18 +0400
Message-Id: <1219001058-25107-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small race and code ugliness in max7301: pins are
reconfigured after the chip is registered. Swap these calls
so that the device is registered in correct state.

Also this fixes the comile-time warning about unchecked gpiochip_remove.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Juergen Beisert <j.beisert@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 drivers/gpio/max7301.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/max7301.c b/drivers/gpio/max7301.c
index 39c795a..c34f408 100644
--- a/drivers/gpio/max7301.c
+++ b/drivers/gpio/max7301.c
@@ -255,10 +255,6 @@ static int __devinit max7301_probe(struct spi_device *spi)
 	ts->chip.dev = &spi->dev;
 	ts->chip.owner = THIS_MODULE;
 
-	ret = gpiochip_add(&ts->chip);
-	if (ret)
-		goto exit_destroy;
-
 	/*
 	 * tristate all pins in hardware and cache the
 	 * register values for later use.
@@ -269,17 +265,19 @@ static int __devinit max7301_probe(struct spi_device *spi)
 		max7301_write(spi, 0x08 + i, 0xAA);
 		ts->port_config[i] = 0xAA;
 		for (j = 0; j < 4; j++) {
-			int idx = ts->chip.base + (i - 1) * 4 + j;
-			ret = gpio_direction_input(idx);
+			int offset = (i - 1) * 4 + j;
+			ret = max7301_direction_input(&ts->chip, offset);
 			if (ret)
-				goto exit_remove;
-			gpio_free(idx);
+				goto exit_destroy;
 		}
 	}
+
+	ret = gpiochip_add(&ts->chip);
+	if (ret)
+		goto exit_destroy;
+
 	return ret;
 
-exit_remove:
-	gpiochip_remove(&ts->chip);
 exit_destroy:
 	dev_set_drvdata(&spi->dev, NULL);
 	mutex_destroy(&ts->lock);
-- 
1.5.6.3

