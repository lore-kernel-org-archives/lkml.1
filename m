Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0BBHyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:54:39 -0500
Received: from iksaif.net ([88.191.73.63]:50265 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab0BBHwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:12 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 13/28] asus-laptop: stop using read_status and store_status for GPS
Date: Tue,  2 Feb 2010 08:38:56 +0100
Message-Id: <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |   56 ++++++++++++++++++++++-------------
 1 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index cee751e..ea51d7e 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -331,26 +331,9 @@ static int write_acpi_int(acpi_handle handle, const char *method, int val)
 	return write_acpi_int_ret(handle, method, val, NULL);
 }
 
-static int read_gps_status(struct asus_laptop *asus)
-{
-	unsigned long long status;
-	acpi_status rv = AE_OK;
-
-	rv = acpi_evaluate_integer(gps_status_handle, NULL, NULL, &status);
-	if (ACPI_FAILURE(rv))
-		pr_warning("Error reading GPS status\n");
-	else
-		return status ? 1 : 0;
-
-	return (asus->status & GPS_ON) ? 1 : 0;
-}
-
 /* Generic LED functions */
 static int read_status(struct asus_laptop *asus, int mask)
 {
-	if (mask == GPS_ON)
-		return read_gps_status(asus);
-
 	return (asus->status & mask) ? 1 : 0;
 }
 
@@ -979,21 +962,52 @@ static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 
 /*
  * GPS
+ * TODO: use rfkill
  */
+static int asus_gps_status(struct asus_laptop *asus)
+{
+	unsigned long long status;
+	acpi_status rv = AE_OK;
+
+	rv = acpi_evaluate_integer(gps_status_handle, NULL, NULL, &status);
+	if (ACPI_FAILURE(rv)) {
+		pr_warning("Error reading GPS status\n");
+		return -ENODEV;
+	}
+	return !!status;
+}
+
+static int asus_gps_switch(struct asus_laptop *asus, int status)
+{
+	acpi_handle handle = status ? gps_on_handle : gps_off_handle;
+
+	if (write_acpi_int(handle, NULL, 0x02))
+		return -ENODEV;
+	return 0;
+}
+
 static ssize_t show_gps(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct asus_laptop *asus = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", read_status(asus, GPS_ON));
+	return sprintf(buf, "%d\n", asus_gps_status(asus));
 }
 
 static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
-	struct asus_laptop *asus = dev_get_drvdata(dev);
+ 	struct asus_laptop *asus = dev_get_drvdata(dev);
+	int rv, value;
+	int ret;
 
-	return store_status(asus, buf, count, NULL, GPS_ON);
+	rv = parse_arg(buf, count, &value);
+	if (rv <= 0)
+		return -EINVAL;
+	ret = asus_gps_switch(asus, !!value);
+	if (ret)
+		return ret;
+	return rv;
 }
 
 /*
@@ -1451,7 +1465,7 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 		set_light_sens_level(asus, asus->light_level);
 
 	/* GPS is on by default */
-	write_status(asus, NULL, 1, GPS_ON);
+	asus_gps_switch(asus, 1);
 	return result;
 }
 
-- 
1.6.6.1

