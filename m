Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYABNqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYABNqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYABNqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:46:12 -0500
Received: from crazy.xmat.net ([91.121.11.163]:63749 "EHLO
	tchaikovsky.artsenscene.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071AbYABNqL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:46:11 -0500
To: david-b@pacbell.net
Subject: Re: [patch 2.6.24-rc6-mm 8/9] gpiolib: pca9539 i2c gpio expander support
X-IlohaMail-Blah: khali@gcu-squad.org
X-IlohaMail-Method: mail() [mem]
X-IlohaMail-Dummy: moo
X-Mailer: IlohaMail/0.8.14 (On: mail.gcu-squad.org)
Message-ID: <FJSgZoJ0.1199281558.1924640.khali@gcu-squad.org>
In-Reply-To: <200712281958.53694.david-b@pacbell.net>
From: "Jean Delvare" <khali@linux-fr.org>
Bounce-To: "Jean Delvare" <khali@linux-fr.org>
CC: "eric miao" <eric.y.miao@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Date: Wed, 02 Jan 2008 14:46:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David, hi Eric,

Le 29/12/2007, "David Brownell" <david-b@pacbell.net> a écrit:
>From: eric miao <eric.miao@marvell.com>
>
>This adds a new-style I2C driver with basic support for the sixteen
>bit PCA9539 GPIO expanders.  These chips have multiple registers,
>push-pull output drivers, and (not supported by this patch) pin
>change interrupts.
>
>Board-specific code must provide "pca9539_platform_data" with each
>chip's "i2c_board_info".  That provides the GPIO numbers to be used
>by that chip, and callbacks for board-specific setup/teardown logic.
>
>Derived from drivers/i2c/chips/pca9539.c (which has no current known
>users).  This is faster and simpler; it uses 16-bit register access,
>and caches the OUTPUT and DIRECTION registers for fast access.
>
>Signed-off-by: eric miao <eric.miao@marvell.com>
>Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
>---
> drivers/gpio/Kconfig        |   10 +
> drivers/gpio/Makefile       |    1
> drivers/gpio/pca9539.c      |  264 ++++++++++++++++++++++++++
> include/linux/i2c/pca9539.h |   18 +++
> 4 files changed, 293 insertions(+)

Random comments:

>+static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
>+{
>+	struct pca9539_chip *chip;
>+	uint16_t reg_val;
>+	int ret;
>+
>+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
>+
>+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
>+	if (ret < 0) {
>+		/* NOTE:  diagnostic already omitted; that's the
>+		 * best we can do here.
>+		 */
>+		return 0;
>+	}

I guess that you really mean "emitted" here, not "omitted"?

More importantly, I don't agree that it's the best we can do here.
Maybe it was already discussed before and there's a good reason to not
report errors from "get" functions at the gpio-core level, but I
can't see it. Whether a read error should be considered as "0" or
"1" (or neither) should be a decision left to the user of the GPIO
chip, rather than to each GPIO driver.

>+
>+	return (reg_val & (1u << off)) ? 1 : 0;
>+}

>+static int __devinit pca9539_probe(struct i2c_client *client)
>+{
>+ (...)
>+	if (pdata->setup) {
>+		ret = pdata->setup(client, chip->gpio_chip.base,
>+				chip->gpio_chip.ngpio, pdata->context);
>+		if (ret < 0)
>+			dev_dbg(&client->dev, "setup failed, %d\n", ret);

Should be at least dev_warn() and maybe even dev_err().

>+	}
>+ (...)
>+}
>+
>+static int pca9539_remove(struct i2c_client *client)
>+{
>+ (...)
>+	if (pdata->teardown) {
>+		ret = pdata->teardown(client, chip->gpio_chip.base,
>+				chip->gpio_chip.ngpio, pdata->context);
>+		if (ret < 0)
>+			dev_dbg(&client->dev, "teardown failed, %d\n", ret);

Same thing here.

>+	}
>+
>+	ret = gpiochip_remove(&chip->gpio_chip);
>+	if (ret) {
>+		dev_err(&client->dev, "failed remove gpio_chip\n");

This error message could certainly be reworded to sound better. Also, for
consistency you should include the value of "ret" in the message.

>+		return ret;
>+	}
>+
>+	kfree(chip);
>+	return 0;
>+}

--
Jean Delvare
