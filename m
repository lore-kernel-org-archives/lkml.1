Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0CAQEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:04:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:56593 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0CAQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:04:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OLVSSpr2RlX6R0fkCJi345u1lfY11UwPafhIgcmfCbdctZ1lOuhCKE/5xkQQ6DIPjS
         s1s3A5300eza2aZ9UMr9y9LbjJZ+aUNN0Dk/o3NqvWSRy0rPrvq3knkWp2PesVfTYznA
         BPqbUnqI1jircAiIKCQD/y4aroDn2bCX95qUQ=
MIME-Version: 1.0
Date: Mon, 1 Mar 2010 10:04:19 -0600
Message-ID: <808c8e9d1003010804r331d39a6g9cf520cb27595e75@mail.gmail.com>
Subject: [PATCH] gpio: cs5535-gpio: fix input direction
From: Ben Gardner <gardner.ben@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio: cs5535-gpio: fix input direction

The cs5535-gpio driver's get() function was returning the output value.
This means that the GPIO pins would never work as an input, even if configured
as an input.
The driver should return the READ_BACK value, which is the sensed line value.
To make that work when the direction is 'output', INPUT_ENABLE needs to be set.

In addition, the driver was not disabling OUTPUT_ENABLE when the
direction is set to 'input'. That would cause the GPIO to continue to
drive the pin if the direction was ever set to output.

This issue was noticed when attempting to use the gpiolib driver to read
an external input. I had previously been using the char/cs5535-gpio driver.

This patch should also be applied to 2.6.33.x, as that is the first version
that contains the gpio/cs5535-gpio driver.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
CC: Andres Salomon <dilinger@collabora.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
This patch replaces the following patches:
cs5535_gpio-gpio_chipget-should-return-the-input-value.patch
olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch

References:
http://lkml.org/lkml/2010/2/27/253
http://lkml.org/lkml/2010/2/23/311
http://lkml.org/lkml/2010/2/26/335

 drivers/gpio/cs5535-gpio.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 0fdbe94..0c3c498 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -154,7 +154,7 @@ static int chip_gpio_request(struct gpio_chip *c,
unsigned offset)

 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
+	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
 }

 static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
@@ -172,6 +172,7 @@ static int chip_direction_input(struct gpio_chip
*c, unsigned offset)

 	spin_lock_irqsave(&chip->lock, flags);
 	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
 	spin_unlock_irqrestore(&chip->lock, flags);

 	return 0;
@@ -184,6 +185,7 @@ static int chip_direction_output(struct gpio_chip
*c, unsigned offset, int val)

 	spin_lock_irqsave(&chip->lock, flags);

+	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
 	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
 	if (val)
 		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
-- 
1.6.4
