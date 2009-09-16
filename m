Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZIPFIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZIPFIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZIPFIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:08:18 -0400
Received: from mail-yw0-f197.google.com ([209.85.211.197]:57709 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZIPFIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:08:17 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 01:08:17 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sAzskZR7lh5B2SQGa6gTqgeR34moGffnP83vtKdsKJCRrONwHY0mANmeDqRS8R3RJo
         WYOCW4B64UShdl+IUAGczwDYsVOMV37VBcCXZIKjQAvG6AvOSNT2wHmnDlvzNwbThLeh
         KDAUSy3Mr3Lq1XaQ0h4sFsxBHjXyAXK8+PFyg=
Date: Tue, 15 Sep 2009 22:02:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] input/keyboard: add ADP5588 QWERTY I2C Keyboard
	Input device driver
Message-ID: <20090916050236.GF2756@core.coreip.homeip.net>
References: <20090915062050.GB10232@core.coreip.homeip.net> <1253062178-18196-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253062178-18196-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 08:49:38PM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> v2
> 	- merge my and Dmitry's clean up fixes
> 

Looks good, I'd also like to add this instead of recalcularing delay
every time:

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 892a532..d48c808 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -63,7 +63,7 @@ struct adp5588_kpad {
 	struct i2c_client *client;
 	struct input_dev *input;
 	struct delayed_work work;
-	unsigned revid;
+	unsigned long delay;
 	unsigned short keycode[ADP5588_KEYMAPSIZE];
 };
 
@@ -119,9 +119,7 @@ static irqreturn_t adp5588_irq(int irq, void *handle)
 	 * REVID < 4
 	 */
 
-	schedule_delayed_work(&kpad->work,
-			WA_DELAYED_READOUT_REVID(kpad->revid) ?
-			(unsigned long) msecs_to_jiffies(30) : 0);
+	schedule_delayed_work(&kpad->work, kpad->delay);
 
 	return IRQ_HANDLED;
 }
@@ -164,6 +162,7 @@ static int __devinit adp5588_probe(struct i2c_client *client,
 	struct adp5588_kpad *kpad;
 	struct adp5588_kpad_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *input;
+	unsigned int revid;
 	int ret, i;
 	int error;
 
@@ -210,7 +209,9 @@ static int __devinit adp5588_probe(struct i2c_client *client,
 		goto err_free_mem;
 	}
 
-	kpad->revid = (u8) ret & ADP5588_DEVICE_ID_MASK;
+	revid = (u8) ret & ADP5588_DEVICE_ID_MASK;
+	if (WA_DELAYED_READOUT_REVID(revid))
+		kpad->delay = msecs_to_jiffies(30);
 
 	input->name = client->name;
 	input->phys = "adp5588-keys/input0";
@@ -221,7 +222,7 @@ static int __devinit adp5588_probe(struct i2c_client *client,
 	input->id.bustype = BUS_I2C;
 	input->id.vendor = 0x0001;
 	input->id.product = 0x0001;
-	input->id.version = kpad->revid;
+	input->id.version = revid;
 
 	input->keycodesize = sizeof(kpad->keycode[0]);
 	input->keycodemax = pdata->keymapsize;
@@ -247,8 +248,8 @@ static int __devinit adp5588_probe(struct i2c_client *client,
 	}
 
 	error = request_irq(client->irq, adp5588_irq,
-		IRQF_TRIGGER_FALLING | IRQF_DISABLED,
-		client->dev.driver->name, kpad);
+			    IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			    client->dev.driver->name, kpad);
 	if (error) {
 		dev_err(&client->dev, "irq %d busy?\n", client->irq);
 		goto err_unreg_dev;
@@ -261,9 +262,7 @@ static int __devinit adp5588_probe(struct i2c_client *client,
 	device_init_wakeup(&client->dev, 1);
 	i2c_set_clientdata(client, kpad);
 
-	dev_info(&client->dev, "Rev.%d keypad, irq %d\n",
-		kpad->revid, client->irq);
-
+	dev_info(&client->dev, "Rev.%d keypad, irq %d\n", revid, client->irq);
 	return 0;
 
  err_free_irq:

-- 
Dmitry
