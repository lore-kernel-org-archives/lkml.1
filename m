Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYHZUKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYHZUKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbYHZUKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:10:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37428 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbYHZUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:10:03 -0400
Date: Tue, 26 Aug 2008 21:09:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] power-supply: Add function to return system-wide power state
Message-ID: <20080826200959.GB26114@srcf.ucam.org>
References: <20080826200849.GA26114@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826200849.GA26114@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend, I screwed up the Cc)

Certain drivers benefit from knowing whether the system is on ac or 
battery, for instance when determining which backlight registers to 
read. This adds a simple call to determine whether there's an online 
power supply other than any batteries.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

The name is a bit odd, but seems to fit in with the existing naming 
scheme.

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index cb1ccb4..6a687da 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -87,6 +87,31 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 	return error;
 }
 
+static int __power_supply_is_system_supplied(struct device *dev, void *data)
+{
+	union power_supply_propval ret = {0,};
+	struct power_supply *psy = dev_get_drvdata(dev);
+
+	if (psy->type != POWER_SUPPLY_TYPE_BATTERY) {
+		if (psy->get_property(psy,
+				       POWER_SUPPLY_PROP_ONLINE, &ret))
+			return 0;
+		if (ret.intval)
+			return ret.intval;
+	}
+	return 0;
+}
+
+int power_supply_is_system_supplied()
+{
+	int error;
+
+	error = class_for_each_device(power_supply_class, NULL, NULL,
+				      __power_supply_is_system_supplied);
+
+	return error;
+}
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	int rc = 0;
@@ -148,6 +173,7 @@ static void __exit power_supply_class_exit(void)
 
 EXPORT_SYMBOL_GPL(power_supply_changed);
 EXPORT_SYMBOL_GPL(power_supply_am_i_supplied);
+EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
 EXPORT_SYMBOL_GPL(power_supply_register);
 EXPORT_SYMBOL_GPL(power_supply_unregister);
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index ea96ead..3e67d0c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -164,6 +164,7 @@ struct power_supply_info {
 
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
+extern int power_supply_is_system_supplied(void);
 
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
