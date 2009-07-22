Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZGVRUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZGVRUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZGVRUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:20:50 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:33408 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZGVRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:20:49 -0400
Date: Wed, 22 Jul 2009 19:20:45 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/3] pda-power: add set_charged functionaltity
Message-ID: <20090722172045.GH13236@buzzloop.caiaq.de>
References: <1247759044-4747-1-git-send-email-daniel@caiaq.de> <20090720182752.GA20602@oksana.dev.rtsoft.ru> <20090720183711.GF19257@buzzloop.caiaq.de> <20090720190034.GA24617@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720190034.GA24617@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 11:00:34PM +0400, Anton Vorontsov wrote:
> > Hmm. I thought about that too, but didn't find a way to access the
> > single members of the pda-power device and find the right one to
> > access. They're registered on a string base and matched magically once
> > the battery monitor is probed when found on the one-wire bus. Any
> > proposal how an interface could look like that does that?
> > 
> > All I need is a way to pass this information from my platform code down
> > to the battery driver.
> 
> Yes, I see the problem, but I don't have a solution off-hand. :-/
> 
> Let me think about it for awhile.

What about something like the patch below?

The platform code interface would look like

	struct power_supply *psy =
		power_support_get_by_name("ds2760.0");
	if (psy)
		power_supply_set_battery_charged(psy);

Couldn't test it yet as my hardware is missing, but I would still like
to hear your comments about it :)

Daniel



commit 1a865b0023619c93de095fdb35823e57a496fc0b
Author: Daniel Mack <daniel@caiaq.de>
Date:   Thu Jul 16 15:54:46 2009 +0200

    pwoer_supply: get_by_name and set_charged functionaltity
    
    This adds a function to get a power_supply device from the class of
    registered devices by name reference. It can be used to find a specific
    battery to call power_supply_set_battery_charged() on.
    
    Some battery drivers might need that information to calibrate
    themselves.
    
    Signed-off-by: Daniel Mack <daniel@caiaq.de>
    Cc: Ian Molton <spyro@f2s.com>
    Cc: Anton Vorontsov <cbou@mail.ru>
    Cc: Matt Reimer <mreimer@vpop.net>

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 58f10ac..ddb4800 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -117,6 +117,34 @@ int power_supply_is_system_supplied(void)
 }
 EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
 
+int power_supply_set_battery_charged(struct power_supply *psy)
+{
+	if (psy->type == POWER_SUPPLY_TYPE_BATTERY && psy->set_charged) {
+		psy->set_charged(psy);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(power_supply_set_battery_charged);
+
+static int power_supply_match_device_by_name(struct device *dev, void *data)
+{
+	const char *name = data;
+	struct power_supply *psy = dev_get_drvdata(dev);
+
+	return strcmp(psy->name, name) == 0;
+}
+
+struct power_supply *power_supply_get_by_name(char *name)
+{
+	struct device *dev = class_find_device(power_supply_class, NULL, name,
+					power_supply_match_device_by_name);
+
+	return dev ? dev_get_drvdata(dev) : NULL;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_by_name);
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	int rc = 0;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 594c494..49f3296 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -126,6 +126,7 @@ struct power_supply {
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
 	void (*external_power_changed)(struct power_supply *psy);
+	void (*set_charged)(struct power_supply *psy);
 
 	/* For APM emulation, think legacy userspace. */
 	int use_for_apm;
@@ -165,8 +166,10 @@ struct power_supply_info {
 	int use_for_apm;
 };
 
+extern struct power_supply *power_supply_get_by_name(char *name);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
+extern int power_supply_set_battery_charged(struct power_supply *psy);
 
 #if defined(CONFIG_POWER_SUPPLY) || defined(CONFIG_POWER_SUPPLY_MODULE)
 extern int power_supply_is_system_supplied(void);
