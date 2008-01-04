Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbYADBl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbYADBl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYADBlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:41:21 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38840 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751983AbYADBlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:41:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ysUhB9+YdAC2+22PsCPIiOimqf2m0uoniCBjoeOdmvBCZetV4HCo20qBgzm3PDXTnddGZAcT1CseXyJy9F7KKl2huiYQptP/qS/t5gPNglTL3Rrv32NcH8v6bAo6OVByh0cwJFIURqdFjM4nZmaI91KVnKcTD4AzeYDtSzcmOPY=  ;
X-YMail-OSG: HVE1rhQVM1kUUQCxjhfjkUCgzuChgNMXBv4Ug5Xw_25XQSceXSz8vv620eadB65ZKKJlocxlIA--
From: David Brownell <david-b@pacbell.net>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [patch 2.6.24-rc6-mm 8/9] gpiolib: pca9539 i2c gpio expander support
Date: Thu, 3 Jan 2008 17:41:16 -0800
User-Agent: KMail/1.9.6
Cc: "eric miao" <eric.y.miao@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
References: <FJSgZoJ0.1199281558.1924640.khali@gcu-squad.org>
In-Reply-To: <FJSgZoJ0.1199281558.1924640.khali@gcu-squad.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801031741.17663.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02 Janvier 2008, Jean Delvare a écrit:
> 
> Hi David, hi Eric,
> 
> Le 29/12/2007, "David Brownell" <david-b@pacbell.net> a écrit:
> >From: eric miao <eric.miao@marvell.com>
> >
> >This adds a new-style I2C driver with basic support for the sixteen
> >bit PCA9539 GPIO expanders.
> >
> >			... 
> 
> Random comments:
> 
> >+static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
> >+{
> >+		...
> >+
> >+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
> >+	if (ret < 0) {
> >+		/* NOTE:  diagnostic already omitted; that's the
> >+		 * best we can do here.
> >+		 */
> >+		return 0;
> >+	}
> 
> I guess that you really mean "emitted" here, not "omitted"?

Yeah, typo.


> More importantly, I don't agree that it's the best we can do here.
> Maybe it was already discussed before and there's a good reason to not
> report errors from "get" functions at the gpio-core level,

Yes there is.  It's by explicit request.  Expecting drivers to cope
with per-bit errors is at best unrealistic.  This was decided well
over a year ago ... nobody wants to see bit-banging code that spends
more time trying to figure out how to recover from "can't happen"
errors than getting real work done.  (None of the SOC-specific GPIO
interfaces being replaced by this generic one returned errors either.)

That said, with things like I2C there actually *could* be errors;
which are impossible with valid parameters to SOC-level GPIOs.
That might argue for gpio_{get,set}_value_cansleep() calls being
able to return fault codes that would be nonsense on the more
widely used gpio_{get,set}_value() alls.

But such a change would be for a different set of patches.  This
set does not change *any* driver programming interface.  At all.


> >+static int __devinit pca9539_probe(struct i2c_client *client)
> >+{
> >+ (...)
> >+	if (pdata->setup) {
> >+		ret = pdata->setup(client, chip->gpio_chip.base,
> >+				chip->gpio_chip.ngpio, pdata->context);
> >+		if (ret < 0)
> >+			dev_dbg(&client->dev, "setup failed, %d\n", ret);
> 
> Should be at least dev_warn() and maybe even dev_err().

It's not treated as an error (i.e. abort the probe); warning
is right.

Hmm, I thought both this issue and the previous one had been
fixed already ... oh, it was the pcf857x driver that fixed that.
Never mind.  ;)


> >+	}
> >+ (...)
> >+}
> >+
> >+static int pca9539_remove(struct i2c_client *client)
> >+{
> >+ (...)
> >+	if (pdata->teardown) {
> >+		ret = pdata->teardown(client, chip->gpio_chip.base,
> >+				chip->gpio_chip.ngpio, pdata->context);
> >+		if (ret < 0)
> >+			dev_dbg(&client->dev, "teardown failed, %d\n", ret);
> 
> Same thing here.

That was supposed to be dev_err() then "return ret" !


> >+	}
> >+
> >+	ret = gpiochip_remove(&chip->gpio_chip);
> >+	if (ret) {
> >+		dev_err(&client->dev, "failed remove gpio_chip\n");
> 
> This error message could certainly be reworded to sound better. Also, for
> consistency you should include the value of "ret" in the message.

Right.  So, pretty much like the appended.  (Which I'll merge into
refreshed version of this patch.)


--- a/drivers/gpio/pca9539.c
+++ b/drivers/gpio/pca9539.c
@@ -118,7 +118,7 @@ static int pca9539_gpio_get_value(struct
 
 	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
 	if (ret < 0) {
-		/* NOTE:  diagnostic already omitted; that's the
+		/* NOTE:  diagnostic already emitted; that's the
 		 * best we can do here.
 		 */
 		return 0;
@@ -205,7 +205,7 @@ static int __devinit pca9539_probe(struc
 		ret = pdata->setup(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0)
-			dev_dbg(&client->dev, "setup failed, %d\n", ret);
+			dev_warn(&client->dev, "setup failed, %d\n", ret);
 	}
 
 	i2c_set_clientdata(client, chip);
@@ -225,13 +225,17 @@ static int pca9539_remove(struct i2c_cli
 	if (pdata->teardown) {
 		ret = pdata->teardown(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0)
-			dev_dbg(&client->dev, "teardown failed, %d\n", ret);
+		if (ret < 0) {
+			dev_err(&client->dev, "%s failed, %d\n",
+					"teardown", ret);
+			return ret;
+		}
 	}
 
 	ret = gpiochip_remove(&chip->gpio_chip);
 	if (ret) {
-		dev_err(&client->dev, "failed remove gpio_chip\n");
+		dev_err(&client->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
 		return ret;
 	}
 

