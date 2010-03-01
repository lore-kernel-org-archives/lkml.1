Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0CAGFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 01:05:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53896 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0CAGFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 01:05:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YyWTV4ljezJczyDAke351sqYYI1Vs0kA7X0IABxmEyAQL52MhIzdXEPNpcdS0j8YS2
         +Yu+wEdSXB31h5FWd5RSOpeb4jSSt3UAQoIq3aeRpWvBzFtZuG9c9TVoH0WZR6bDV3Wh
         tb6Mmp150ROU0lDiaYDgsH7gIrkBTjQE8Vbu4=
MIME-Version: 1.0
Date: Mon, 1 Mar 2010 11:57:38 +0600
Message-ID: <b9df5fa11002282157x3c0eec13q4ad404bbe2f227d7@mail.gmail.com>
Subject: [PATCH] acpi: Put acpi_battery_get/set_alarm into 
	CONFIG_ACPI_SYSFS_POWER
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 acpi_battery_get/set_alarm is only used when CONFIG_ACPI_SYSFS_POWER=y. So
put this two functions under CONFIG_ACPI_SYSFS_POWER by shifting it upward.

We were warned by the following warnings:

drivers/acpi/sbs.c:399: warning: ‘acpi_battery_get_alarm’ defined but not used
drivers/acpi/sbs.c:406: warning: ‘acpi_battery_set_alarm’ defined but not used

Also fixes a checkpatch warning in acpi_ac_get_present.

ERROR: space prohibited after that '&' (ctx:WxW)
#13: FILE: drivers/acpi/sbs.c:405:
+				 0x13, (u8 *) & status);
 				              ^

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-33/drivers/acpi/sbs.c	2010-02-26 16:30:32.000000000 +0600
+++ linux-project/drivers/acpi/sbs.c	2010-03-01 11:02:32.000000000 +0600
@@ -396,6 +396,20 @@ static int acpi_battery_get_state(struct
 	return result;
 }

+static int acpi_ac_get_present(struct acpi_sbs *sbs)
+{
+	int result;
+	u16 status;
+
+	result = acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER,
+				 0x13, (u8 *) &status);
+	if (!result)
+		sbs->charger_present = (status >> 15) & 0x1;
+	return result;
+}
+
+#ifdef CONFIG_ACPI_SYSFS_POWER
+
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -432,19 +446,6 @@ static int acpi_battery_set_alarm(struct
 	return ret;
 }

-static int acpi_ac_get_present(struct acpi_sbs *sbs)
-{
-	int result;
-	u16 status;
-
-	result = acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER,
-				 0x13, (u8 *) & status);
-	if (!result)
-		sbs->charger_present = (status >> 15) & 0x1;
-	return result;
-}
-
-#ifdef CONFIG_ACPI_SYSFS_POWER
 static ssize_t acpi_battery_alarm_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
