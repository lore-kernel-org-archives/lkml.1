Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbYD3U1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbYD3U1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbYD3U04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:26:56 -0400
Received: from mail.queued.net ([207.210.101.209]:4990 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbYD3U0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:26:55 -0400
Date: Wed, 30 Apr 2008 16:30:08 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH 2/4] power_supply: add eeprom dump file to olpc_battery's
 sysfs
Message-ID: <20080430163008.4be68cb3@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows you to dump 0x60 bytes from the battery's EEPROM (starting
at address 0x20).  Note that it does an EC command for each byte, so
it's pretty slow.  OTOH, if you want to grab just a single byte from
somewhere in the EEPROM, you can do something like:

dd bs=1 count=1 skip=16 if=/sys/class/power_supply/olpc-battery/eeprom | od -x

Userspace battery collection/logging information needs this.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c |   49 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 9d9dd09..e5ecf27 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -283,6 +283,48 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
 
+/* EEPROM reading goes completely around the power_supply API, sadly */
+
+#define EEPROM_START	0x20
+#define EEPROM_END	0x80
+#define EEPROM_SIZE	(EEPROM_END - EEPROM_START)
+
+static ssize_t olpc_bat_eeprom_read(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	uint8_t ec_byte;
+	int ret, end;
+
+	if (off >= EEPROM_SIZE)
+		return 0;
+	if (off + count > EEPROM_SIZE)
+		count = EEPROM_SIZE - off;
+
+	end = EEPROM_START + off + count;
+	for (ec_byte = EEPROM_START + off; ec_byte < end; ec_byte++) {
+		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1,
+				&buf[ec_byte - EEPROM_START], 1);
+		if (ret) {
+			printk(KERN_ERR "olpc-battery:  EC command "
+					"EC_BAT_EEPROM @ 0x%x failed -"
+					" %d!\n", ec_byte, ret);
+			return -EIO;
+		}
+	}
+
+	return count;
+}
+
+static struct bin_attribute olpc_bat_eeprom = {
+	.attr = {
+		.name = "eeprom",
+		.mode = S_IRUGO,
+		.owner = THIS_MODULE,
+	},
+	.size = 0,
+	.read = olpc_bat_eeprom_read,
+};
+
 /*********************************************************************
  *		Initialisation
  *********************************************************************/
@@ -336,8 +378,14 @@ static int __init olpc_bat_init(void)
 	if (ret)
 		goto battery_failed;
 
+	ret = device_create_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
+	if (ret)
+		goto eeprom_failed;
+
 	goto success;
 
+eeprom_failed:
+	power_supply_unregister(&olpc_bat);
 battery_failed:
 	power_supply_unregister(&olpc_ac);
 ac_failed:
@@ -348,6 +396,7 @@ success:
 
 static void __exit olpc_bat_exit(void)
 {
+	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
 	power_supply_unregister(&olpc_bat);
 	power_supply_unregister(&olpc_ac);
 	platform_device_unregister(bat_pdev);
-- 
1.5.5

