Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbYHZUdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbYHZUdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbYHZUdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:33:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56157 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYHZUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:33:32 -0400
Date: Tue, 26 Aug 2008 21:33:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power-supply: Add function to return system-wide power state
Message-ID: <20080826203327.GA26691@srcf.ucam.org>
References: <20080826200849.GA26114@srcf.ucam.org> <20080826200959.GB26114@srcf.ucam.org> <20080826202542.GA10090@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826202542.GA10090@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something like this?

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
index ea96ead..304df22 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -164,11 +164,16 @@ struct power_supply_info {
 
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
-
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);
 extern void power_supply_unregister(struct power_supply *psy);
 
+#ifdef CONFIG_POWER_SUPPLY
+extern int power_supply_is_system_supplied(void);
+#else
+static int power_supply_is_system_supplied(void) { return -ENOSYS; }
+#endif
+
 /* For APM emulation, think legacy userspace. */
 extern struct class *power_supply_class;
 


-- 
Matthew Garrett | mjg59@srcf.ucam.org
