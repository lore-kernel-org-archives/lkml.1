Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbYHOTgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbYHOTgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYHOTgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:36:43 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:42025 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311AbYHOTgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:36:42 -0400
Date: Fri, 15 Aug 2008 21:36:23 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Nate Case <ncase@xes-inc.com>, Andrew Morton <akpm@linux-foundation.org>
cc: rpurdie@rpsys.net, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] leds-pca955x: Add proper error handling and fix	bogus
 memory handling
In-Reply-To: <1218572298.20206.35.camel@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0808152126230.12259@titan.stealer.net>
References: <1210972198.13845.540.camel@localhost.localdomain>  <alpine.LNX.1.10.0808080041460.16201@titan.stealer.net>  <alpine.LNX.1.10.0808080852000.16201@titan.stealer.net>  <alpine.LNX.1.10.0808080924560.16201@titan.stealer.net>
 <1218572298.20206.35.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
X-Spam-Bar: --
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 15 Aug 2008 19:36:39 +0000
	Bayes: 0.0001 Tokens: new, 343; hammy, 7; neutral, 7; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
X-Spam-Signature: 31c9fa0c5871baded5dbe69fd776e1d927f3a205
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008, Nate Case wrote:

> On Fri, 2008-08-08 at 09:27 +0200, Sven Wegener wrote:
> > Check the return value of led_classdev_register and unregister all
> > registered
> > devices, if registering one device fails. Also the dynamic memory
> > handling is
> > totally bogus. You can't allocate multiple chunks via kzalloc() and
> > expect them
> > to be in order later.
> > 
> > Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> 
> Acked-by: Nate Case <ncase@xes-inc.com>
> 
> Thanks for the fix.  It looks correct and I tested it on my board with a
> pca9553.  I also confirmed that the original driver would in fact kernel
> Oops if compiled as a module and you rmmod it.  With this fix, I can
> repeatedly insmod/rmmod successfully.

Thanks for testing!

Andrew, could you please update the patch in -mm with the one below. It
contains the below fixes, that were applied after you added it to -mm,
and is identical to the one Nate tested.

- Another 32 -> sizeof() conversion
- Move the unregister code to where we also free the memory on failure
- cancel_work_sync() when unregistering on failure

>From 2f8a666be724f272236cd724d1bc5e280675bc3e Mon Sep 17 00:00:00 2001
From: Sven Wegener <sven.wegener@stealer.net>
Date: Thu, 7 Aug 2008 22:25:01 +0000
Subject: [PATCH] leds-pca955x: Add proper error handling and fix bogus memory handling

Check the return value of led_classdev_register and unregister all registered
devices, if registering one device fails. Also the dynamic memory handling is
totally bogus. You can't allocate multiple chunks via kzalloc() and expect them
to be in order later.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Nate Case <ncase@xes-inc.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/leds-pca955x.c |   70 +++++++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 146c069..f508729 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -248,11 +248,10 @@ static int __devinit pca955x_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct pca955x_led *pca955x;
-	int i;
-	int err = -ENODEV;
 	struct pca955x_chipdef *chip;
 	struct i2c_adapter *adapter;
 	struct led_platform_data *pdata;
+	int i, err;
 
 	chip = &pca955x_chipdefs[id->driver_data];
 	adapter = to_i2c_adapter(client->dev.parent);
@@ -282,43 +281,41 @@ static int __devinit pca955x_probe(struct i2c_client *client,
 		}
 	}
 
+	pca955x = kzalloc(sizeof(*pca955x) * chip->bits, GFP_KERNEL);
+	if (!pca955x)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, pca955x);
+
 	for (i = 0; i < chip->bits; i++) {
-		pca955x = kzalloc(sizeof(struct pca955x_led), GFP_KERNEL);
-		if (!pca955x) {
-			err = -ENOMEM;
-			goto exit;
-		}
+		pca955x[i].chipdef = chip;
+		pca955x[i].client = client;
+		pca955x[i].led_num = i;
 
-		pca955x->chipdef = chip;
-		pca955x->client = client;
-		pca955x->led_num = i;
 		/* Platform data can specify LED names and default triggers */
 		if (pdata) {
 			if (pdata->leds[i].name)
-				snprintf(pca955x->name, 32, "pca955x:%s",
-							pdata->leds[i].name);
+				snprintf(pca955x[i].name,
+					 sizeof(pca955x[i].name), "pca955x:%s",
+					 pdata->leds[i].name);
 			if (pdata->leds[i].default_trigger)
-				pca955x->led_cdev.default_trigger =
+				pca955x[i].led_cdev.default_trigger =
 					pdata->leds[i].default_trigger;
 		} else {
-			snprintf(pca955x->name, 32, "pca955x:%d", i);
+			snprintf(pca955x[i].name, sizeof(pca955x[i].name),
+				 "pca955x:%d", i);
 		}
-		spin_lock_init(&pca955x->lock);
 
-		pca955x->led_cdev.name = pca955x->name;
-		pca955x->led_cdev.brightness_set =
-				pca955x_led_set;
+		spin_lock_init(&pca955x[i].lock);
 
-		/*
-		 * Client data is a pointer to the _first_ pca955x_led
-		 * struct
-		 */
-		if (i == 0)
-			i2c_set_clientdata(client, pca955x);
+		pca955x[i].led_cdev.name = pca955x[i].name;
+		pca955x[i].led_cdev.brightness_set = pca955x_led_set;
 
-		INIT_WORK(&(pca955x->work), pca955x_led_work);
+		INIT_WORK(&pca955x[i].work, pca955x_led_work);
 
-		led_classdev_register(&client->dev, &(pca955x->led_cdev));
+		err = led_classdev_register(&client->dev, &pca955x[i].led_cdev);
+		if (err < 0)
+			goto exit;
 	}
 
 	/* Turn off LEDs */
@@ -336,23 +333,32 @@ static int __devinit pca955x_probe(struct i2c_client *client,
 	pca955x_write_psc(client, 1, 0);
 
 	return 0;
+
 exit:
+	while (i--) {
+		led_classdev_unregister(&pca955x[i].led_cdev);
+		cancel_work_sync(&pca955x[i].work);
+	}
+
+	kfree(pca955x);
+	i2c_set_clientdata(client, NULL);
+
 	return err;
 }
 
 static int __devexit pca955x_remove(struct i2c_client *client)
 {
 	struct pca955x_led *pca955x = i2c_get_clientdata(client);
-	int leds = pca955x->chipdef->bits;
 	int i;
 
-	for (i = 0; i < leds; i++) {
-		led_classdev_unregister(&(pca955x->led_cdev));
-		cancel_work_sync(&(pca955x->work));
-		kfree(pca955x);
-		pca955x = pca955x + 1;
+	for (i = 0; i < pca955x->chipdef->bits; i++) {
+		led_classdev_unregister(&pca955x[i].led_cdev);
+		cancel_work_sync(&pca955x[i].work);
 	}
 
+	kfree(pca955x);
+	i2c_set_clientdata(client, NULL);
+
 	return 0;
 }
 
