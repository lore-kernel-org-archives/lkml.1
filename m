Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYADApV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYADApV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYADApH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:45:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:24886 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYADApF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:45:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=d7FjgCe1u4mU7tkK2CczKG7RMWqJqpIm1RJhjj12iKz3xiWzml0qI5fzbCsnO1YIO+Nlow4L9ClWGlnWWjOCfjEpBmqwurBoV6cbs18fJ8EPslmAZgec3tYMyADmgWZKDgBB5sqKZwH2Bw28h/H5ZIXgywewosVQm8X/jkBS4gE=
Date: Fri, 4 Jan 2008 03:32:35 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: [PATCH 1/2] pda_power: various cleanups
Message-ID: <20080104003235.GA12308@zarina>
References: <20080104002907.GA767@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080104002907.GA767@zarina>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- handle spurious interrupts correctly;
- get rid of pda_power_supplies array, use two variables instead;
- factor out psy_changed() function, it will be used for polling.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

Untested, just to show the idea.

 drivers/power/pda_power.c |  152 ++++++++++++++++++++++++++++-----------------
 1 files changed, 94 insertions(+), 58 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index d98622f..153e3b1 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -33,6 +33,16 @@ static struct resource *ac_irq, *usb_irq;
 static struct timer_list charger_timer;
 static struct timer_list supply_timer;
 
+enum {
+	PDA_PSY_OFFLINE = 0,
+	PDA_PSY_ONLINE = 1,
+	PDA_PSY_TO_CHANGE,
+};
+static int new_ac_status = -1;
+static int new_usb_status = -1;
+static int ac_status = -1;
+static int usb_status = -1;
+
 static int pda_power_get_property(struct power_supply *psy,
 				  enum power_supply_property psp,
 				  union power_supply_propval *val)
@@ -61,36 +71,43 @@ static char *pda_power_supplied_to[] = {
 	"backup-battery",
 };
 
-static struct power_supply pda_power_supplies[] = {
-	{
-		.name = "ac",
-		.type = POWER_SUPPLY_TYPE_MAINS,
-		.supplied_to = pda_power_supplied_to,
-		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
-		.properties = pda_power_props,
-		.num_properties = ARRAY_SIZE(pda_power_props),
-		.get_property = pda_power_get_property,
-	},
-	{
-		.name = "usb",
-		.type = POWER_SUPPLY_TYPE_USB,
-		.supplied_to = pda_power_supplied_to,
-		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
-		.properties = pda_power_props,
-		.num_properties = ARRAY_SIZE(pda_power_props),
-		.get_property = pda_power_get_property,
-	},
+static struct power_supply pda_psy_ac = {
+	.name = "ac",
+	.type = POWER_SUPPLY_TYPE_MAINS,
+	.supplied_to = pda_power_supplied_to,
+	.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
+	.properties = pda_power_props,
+	.num_properties = ARRAY_SIZE(pda_power_props),
 };
 
+static struct power_supply pda_psy_usb = {
+	.name = "usb",
+	.type = POWER_SUPPLY_TYPE_USB,
+	.supplied_to = pda_power_supplied_to,
+	.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
+	.properties = pda_power_props,
+	.num_properties = ARRAY_SIZE(pda_power_props),
+	.get_property = pda_power_get_property,
+};
+
+static void update_status(void)
+{
+	if (pdata->is_ac_online)
+		new_ac_status = !!pdata->is_ac_online();
+
+	if (pdata->is_usb_online)
+		new_usb_status = !!pdata->is_usb_online();
+}
+
 static void update_charger(void)
 {
 	if (!pdata->set_charge)
 		return;
 
-	if (pdata->is_ac_online && pdata->is_ac_online()) {
+	if (new_ac_status > 0) {
 		dev_dbg(dev, "charger on (AC)\n");
 		pdata->set_charge(PDA_POWER_CHARGE_AC);
-	} else if (pdata->is_usb_online && pdata->is_usb_online()) {
+	} else if (new_usb_status > 0) {
 		dev_dbg(dev, "charger on (USB)\n");
 		pdata->set_charge(PDA_POWER_CHARGE_USB);
 	} else {
@@ -99,31 +116,53 @@ static void update_charger(void)
 	}
 }
 
-static void supply_timer_func(unsigned long power_supply_ptr)
+static void psy_changed(void)
 {
-	void *power_supply = (void *)power_supply_ptr;
+	update_charger();
 
-	power_supply_changed(power_supply);
+	/*
+	 * Okay, charger set. Now wait a bit before notifying supplicants,
+	 * charge power should stabilize.
+	 */
+	mod_timer(&supply_timer,
+		  jiffies + msecs_to_jiffies(pdata->wait_for_charger));
 }
 
-static void charger_timer_func(unsigned long power_supply_ptr)
+static void supply_timer_func(unsigned long unused)
 {
-	update_charger();
+	if (ac_status == PDA_PSY_TO_CHANGE) {
+		ac_status = new_ac_status;
+		power_supply_changed(&pda_psy_ac);
+	}
 
-	/* Okay, charger set. Now wait a bit before notifying supplicants,
-	 * charge power should stabilize. */
-	supply_timer.data = power_supply_ptr;
-	mod_timer(&supply_timer,
-		  jiffies + msecs_to_jiffies(pdata->wait_for_charger));
+	if (usb_status == PDA_PSY_TO_CHANGE) {
+		usb_status = new_usb_status;
+		power_supply_changed(&pda_psy_usb);
+	}
+}
+
+static void charger_timer_func(unsigned long unused)
+{
+	update_status();
+	psy_changed();
 }
 
 static irqreturn_t power_changed_isr(int irq, void *power_supply)
 {
-	/* Wait a bit before reading ac/usb line status and setting charger,
-	 * because ac/usb status readings may lag from irq. */
-	charger_timer.data = (unsigned long)power_supply;
+	if (power_supply == &pda_psy_ac)
+		ac_status = PDA_PSY_TO_CHANGE;
+	else if (power_supply == &pda_psy_usb)
+		usb_status = PDA_PSY_TO_CHANGE;
+	else
+		return IRQ_NONE;
+
+	/*
+	 * Wait a bit before reading ac/usb line status and setting charger,
+	 * because ac/usb status readings may lag from irq.
+	 */
 	mod_timer(&charger_timer,
 		  jiffies + msecs_to_jiffies(pdata->wait_for_status));
+
 	return IRQ_HANDLED;
 }
 
@@ -142,6 +181,7 @@ static int pda_power_probe(struct platform_device *pdev)
 
 	pdata = pdev->dev.platform_data;
 
+	update_status();
 	update_charger();
 
 	if (!pdata->wait_for_status)
@@ -155,31 +195,26 @@ static int pda_power_probe(struct platform_device *pdev)
 
 	ac_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "ac");
 	usb_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "usb");
-	if (!ac_irq && !usb_irq) {
-		dev_err(dev, "no ac/usb irq specified\n");
-		ret = -ENODEV;
-		goto noirqs;
-	}
 
 	if (pdata->supplied_to) {
-		pda_power_supplies[0].supplied_to = pdata->supplied_to;
-		pda_power_supplies[1].supplied_to = pdata->supplied_to;
-		pda_power_supplies[0].num_supplicants = pdata->num_supplicants;
-		pda_power_supplies[1].num_supplicants = pdata->num_supplicants;
+		pda_psy_ac.supplied_to = pdata->supplied_to;
+		pda_psy_ac.num_supplicants = pdata->num_supplicants;
+		pda_psy_usb.supplied_to = pdata->supplied_to;
+		pda_psy_usb.num_supplicants = pdata->num_supplicants;
 	}
 
 	if (pdata->is_ac_online) {
-		ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
+		ret = power_supply_register(&pdev->dev, &pda_psy_ac);
 		if (ret) {
 			dev_err(dev, "failed to register %s power supply\n",
-				pda_power_supplies[0].name);
+				pda_psy_ac.name);
 			goto ac_supply_failed;
 		}
 
 		if (ac_irq) {
 			ret = request_irq(ac_irq->start, power_changed_isr,
 					  get_irq_flags(ac_irq), ac_irq->name,
-					  &pda_power_supplies[0]);
+					  &pda_psy_ac);
 			if (ret) {
 				dev_err(dev, "request ac irq failed\n");
 				goto ac_irq_failed;
@@ -188,18 +223,17 @@ static int pda_power_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->is_usb_online) {
-		ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
+		ret = power_supply_register(&pdev->dev, &pda_psy_usb);
 		if (ret) {
 			dev_err(dev, "failed to register %s power supply\n",
-				pda_power_supplies[1].name);
+				pda_psy_usb.name);
 			goto usb_supply_failed;
 		}
 
 		if (usb_irq) {
 			ret = request_irq(usb_irq->start, power_changed_isr,
 					  get_irq_flags(usb_irq),
-					  usb_irq->name,
-					  &pda_power_supplies[1]);
+					  usb_irq->name, &pda_psy_usb);
 			if (ret) {
 				dev_err(dev, "request usb irq failed\n");
 				goto usb_irq_failed;
@@ -211,15 +245,14 @@ static int pda_power_probe(struct platform_device *pdev)
 
 usb_irq_failed:
 	if (pdata->is_usb_online)
-		power_supply_unregister(&pda_power_supplies[1]);
+		power_supply_unregister(&pda_psy_usb);
 usb_supply_failed:
 	if (pdata->is_ac_online && ac_irq)
-		free_irq(ac_irq->start, &pda_power_supplies[0]);
+		free_irq(ac_irq->start, &pda_psy_ac);
 ac_irq_failed:
 	if (pdata->is_ac_online)
-		power_supply_unregister(&pda_power_supplies[0]);
+		power_supply_unregister(&pda_psy_ac);
 ac_supply_failed:
-noirqs:
 wrongid:
 	return ret;
 }
@@ -227,15 +260,18 @@ wrongid:
 static int pda_power_remove(struct platform_device *pdev)
 {
 	if (pdata->is_usb_online && usb_irq)
-		free_irq(usb_irq->start, &pda_power_supplies[1]);
+		free_irq(usb_irq->start, &pda_psy_usb);
 	if (pdata->is_ac_online && ac_irq)
-		free_irq(ac_irq->start, &pda_power_supplies[0]);
+		free_irq(ac_irq->start, &pda_psy_ac);
+
 	del_timer_sync(&charger_timer);
 	del_timer_sync(&supply_timer);
+
 	if (pdata->is_usb_online)
-		power_supply_unregister(&pda_power_supplies[1]);
+		power_supply_unregister(&pda_psy_usb);
 	if (pdata->is_ac_online)
-		power_supply_unregister(&pda_power_supplies[0]);
+		power_supply_unregister(&pda_psy_ac);
+
 	return 0;
 }
 
-- 
1.5.2.4

