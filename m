Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZEIUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZEIUCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZEIUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 16:02:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:32529 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZEIUCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 16:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LlClicDvFZIltS0HZYZV38Sn9duCp+lfZsFsRAuz3/UFWvwtJzzy2y0goiBCqRDXpL
         /M8I2WaXfJ9gowAsCH6ldOieSVxDGaG+xRBPs4+go9iYqTxF3GezlciLhu4vHn63j5Rf
         6GXlpk5bSRttwqccZkK8UitKtaSBGSAzuF/+w=
Date: Sat, 9 May 2009 13:01:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Message-ID: <20090509200118.GB1617@dtor-d630.eng.vmware.com>
References: <4A04E5EA.7000103@samsung.com> <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 10:57:47PM +0530, Trilok Soni wrote:
> Hi Kim,
> 
> On Sat, May 9, 2009 at 7:39 AM, Kim Kyuwon <q1.kim@samsung.com> wrote:
> > The Maxim MAX7359 is a I2C interfaced key switch controller which provides
> > microprocessors with management of up to 64 key switches.
> > This patch adds support for the MAX7359 key switch controller.
> >
> > Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
> 
> 
> Thanks for implementing review comments. Please add
> 
> Reviewed-by: Trilok Soni <soni.trilok@gmail.com>
> 

Looks good, thank you Kim. I will keep it in my tree for now until I
figure out what to do with KEY() macro for matrix keyboards (should not
be long though).

Trilok, I also wanted to thank you for doing reviews of the drivers
posted on the linux-input, it is much appreciated.

-- 
Dmitry

P.S. I made a bunch of random changes, mostly to streamline the probe
code (below), hopfully I did not break anything.

diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index 918386c..280edc3 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -70,12 +70,9 @@ static int max7359_write_reg(struct i2c_client *client, u8 reg, u8 val)
 {
 	int ret = i2c_smbus_write_byte_data(client, reg, val);
 
-	if (ret >= 0)
-		return 0;
-
-	dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
-						__func__, reg, val, ret);
-
+	if (ret < 0)
+		dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
+			__func__, reg, val, ret);
 	return ret;
 }
 
@@ -85,7 +82,7 @@ static int max7359_read_reg(struct i2c_client *client, int reg)
 
 	if (ret < 0)
 		dev_err(&client->dev, "%s: reg 0x%x, err %d\n",
-						__func__, reg, ret);
+			__func__, reg, ret);
 	return ret;
 }
 
@@ -93,17 +90,16 @@ static void max7359_build_keycode(struct max7359_keypad *keypad)
 {
 	struct max7359_keypad_platform_data *pdata = keypad->pdata;
 	struct input_dev *input_dev = keypad->input_dev;
-	unsigned int *key;
 	int i;
 
-	key = pdata->key_map;
-	for (i = 0; i < pdata->key_map_size; i++, key++) {
-		int row = ((*key) >> 28) & 0xf;
-		int col = ((*key) >> 24) & 0xf;
-		short code = (*key) & 0xffff;
+	for (i = 0; i < pdata->key_map_size; i++) {
+		unsigned int key = pdata->key_map[i];
+		int row = (key >> 28) & 0xf;
+		int col = (key >> 24) & 0xf;
+		unsigned short code = key & 0xffff;
 
 		keypad->keycodes[(row << 3) + col] = code;
-		set_bit(code, input_dev->keybit);
+		__set_bit(code, input_dev->keybit);
 	}
 }
 
@@ -125,7 +121,8 @@ static void max7359_worker(struct work_struct *work)
 	release = val & 0x40;
 
 	input_report_key(keypad->input_dev,
-		max7359_lookup_matrix_keycode(keypad, row, col), !release);
+			 max7359_lookup_matrix_keycode(keypad, row, col),
+			 !release);
 	input_sync(keypad->input_dev);
 
 	enable_irq(keypad->irq);
@@ -141,9 +138,6 @@ static irqreturn_t max7359_interrupt(int irq, void *dev_id)
 	if (!work_pending(&keypad->work)) {
 		disable_irq_nosync(keypad->irq);
 		schedule_work(&keypad->work);
-	} else {
-		dev_warn(&keypad->client->dev,
-				"Another job is currently pending \n");
 	}
 
 	return IRQ_HANDLED;
@@ -204,71 +198,59 @@ static int __devinit max7359_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct max7359_keypad *keypad;
-	struct max7359_keypad_platform_data *pdata;
+	struct max7359_keypad_platform_data *pdata = client->dev.platform_data;
 	struct input_dev *input_dev;
 	int ret;
+	int error;
 
-	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
-	if (keypad == NULL) {
-		dev_err(&client->dev, "failed to allocate driver data\n");
-		return -ENOMEM;
+	if (!client->irq) {
+		dev_err(&client->dev, "The irq number should not be zero\n");
+		return -EINVAL;
 	}
 
-	keypad->client = client;
-	pdata = keypad->pdata = client->dev.platform_data;
-	i2c_set_clientdata(client, keypad);
-
 	/* Detect MAX7359: The initial Keys FIFO value is '0x3F' */
 	ret = max7359_read_reg(client, MAX7359_REG_KEYFIFO);
 	if (ret < 0) {
 		dev_err(&client->dev, "failed to detect device\n");
-		goto failed_free;
-	} else {
-		dev_info(&client->dev, "keys FIFO is 0x%02x"
-				", succeeded in detecting device\n", ret);
+		return -ENODEV;
 	}
 
-	/* Initialize MAX7359 */
-	max7359_initialize(client);
+	dev_dbg(&client->dev, "keys FIFO is 0x%02x\n", ret);
 
-	/* Create and register the input driver. */
+	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		dev_err(&client->dev, "failed to allocate input device\n");
-		ret = -ENOMEM;
-		goto failed_free;
+	if (!keypad || !input_dev) {
+		dev_err(&client->dev, "failed to allocate memory\n");
+		error = -ENOMEM;
+		goto failed_free_mem;
 	}
 
+	keypad->client = client;
+	keypad->pdata = pdata;
+	keypad->input_dev = input_dev;
+	keypad->irq = client->irq;
+	INIT_WORK(&keypad->work, max7359_worker);
+
 	input_dev->name = client->name;
 	input_dev->id.bustype = BUS_I2C;
 	input_dev->open = max7359_open;
 	input_dev->close = max7359_close;
 	input_dev->dev.parent = &client->dev;
 
-	input_set_drvdata(input_dev, keypad);
-
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
 	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
 	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
 	input_dev->keycode = keypad->keycodes;
 
-	keypad->input_dev = input_dev;
+	input_set_drvdata(input_dev, keypad);
 
 	max7359_build_keycode(keypad);
 
-	INIT_WORK(&keypad->work, max7359_worker);
-
-	keypad->irq = client->irq;
-	if (!keypad->irq) {
-		dev_err(&client->dev, "The irq number should not be zero\n");
-		goto failed_free_dev;
-	}
-
-	ret = request_irq(keypad->irq, max7359_interrupt,
-				IRQF_TRIGGER_LOW, client->name, keypad);
-	if (ret) {
+	error = request_irq(keypad->irq, max7359_interrupt,
+			    IRQF_TRIGGER_LOW, client->name, keypad);
+	if (error) {
 		dev_err(&client->dev, "failed to register interrupt\n");
-		goto failed_free_dev;
+		goto failed_free_mem;
 	}
 
 	/* Register the input device */
@@ -278,16 +260,18 @@ static int __devinit max7359_probe(struct i2c_client *client,
 		goto failed_free_irq;
 	}
 
+	/* Initialize MAX7359 */
+	max7359_initialize(client);
+
+	i2c_set_clientdata(client, keypad);
 	device_init_wakeup(&client->dev, 1);
 
 	return 0;
 
 failed_free_irq:
 	free_irq(keypad->irq, keypad);
-failed_free_dev:
+failed_free_mem:
 	input_free_device(input_dev);
-failed_free:
-	i2c_set_clientdata(client, NULL);
 	kfree(keypad);
 	return ret;
 }
