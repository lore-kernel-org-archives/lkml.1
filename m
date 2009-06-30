Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbZF3GPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbZF3GPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZF3GP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:15:29 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:47289 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZF3GP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:15:28 -0400
Date: Tue, 30 Jun 2009 02:15:26 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 3/5] power_supply: add an 'error' sysfs device that displays
 raw errors OLPC battery
Message-ID: <20090630021526.3591239c@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Grab the error code from EC_BAT_ERRCODE and let the user see it (rather
than attempting to decode it as we do with PROP_HEALTH) with a separate
error sysfs file.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/power/olpc_battery.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index d2df0db..c955a86 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -373,6 +373,30 @@ static struct bin_attribute olpc_bat_eeprom = {
 	.read = olpc_bat_eeprom_read,
 };
 
+/* Allow userspace to see the specific error value pulled from the EC */
+
+static ssize_t olpc_bat_error_read(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	uint8_t ec_byte;
+	ssize_t ret;
+
+	ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", ec_byte);
+}
+
+static struct device_attribute olpc_bat_error = {
+	.attr = {
+		.name = "error",
+		.mode = S_IRUGO,
+	},
+	.show = olpc_bat_error_read,
+	.store = NULL,
+};
+
 /*********************************************************************
  *		Initialisation
  *********************************************************************/
@@ -436,8 +460,14 @@ static int __init olpc_bat_init(void)
 	if (ret)
 		goto eeprom_failed;
 
+	ret = device_create_file(olpc_bat.dev, &olpc_bat_error);
+	if (ret)
+		goto error_failed;
+
 	goto success;
 
+error_failed:
+	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
 eeprom_failed:
 	power_supply_unregister(&olpc_bat);
 battery_failed:
@@ -450,6 +480,7 @@ success:
 
 static void __exit olpc_bat_exit(void)
 {
+	device_remove_file(olpc_bat.dev, &olpc_bat_error);
 	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
 	power_supply_unregister(&olpc_bat);
 	power_supply_unregister(&olpc_ac);
-- 
1.5.6.5

