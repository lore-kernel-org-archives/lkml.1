Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXDKNEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXDKNEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXDKNEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:04:43 -0400
Received: from av1.karneval.cz ([81.27.192.123]:29032 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXDKNEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:04:41 -0400
Message-id: <2189310342910921713@karneval.cz>
Subject: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <corentincj@iksaif.net>
Cc: <sziwan@users.sourceforge.net>
Cc: <acpi4asus-user@lists.sourceforge.net>
Cc: <len.brown@intel.com>
Cc: <linux-acpi@vger.kernel.org>
Date: Wed, 11 Apr 2007 15:04:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

asus_acpi, support F2JE model

also augment the driver to support switching LCD status even if no function
for getting lcd status exists in DSDT.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 54f13ae12fa0a3e3fc02dda6225baa3436f1e93a
tree 70c08fc62a1a2f08ac8cc8f4cf5796a1d6f34764
parent 0156510dee9d326af2ec52cf8b1a388ce9a839e9
author Jiri Slaby <jirislaby@gmail.com> Wed, 11 Apr 2007 15:03:26 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 11 Apr 2007 15:03:26 +0200

 drivers/acpi/asus_acpi.c |   37 +++++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index 0a9ea00..2363578 100644
--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -123,6 +123,7 @@ struct asus_hotk {
 		A2x,		//A2500H
 		A4G,		//A4700G
 		D1x,		//D1
+		F2x,		//F2JE
 		L2D,		//L2000D
 		L3C,		//L3800C
 		L3D,		//L3400D
@@ -150,6 +151,7 @@ struct asus_hotk {
 
 /* Here we go */
 #define A1x_PREFIX "\\_SB.PCI0.ISA.EC0."
+#define F2x_PREFIX "\\_SB.PCI0.SBRG.EC0."
 #define L3C_PREFIX "\\_SB.PCI0.PX40.ECD0."
 #define M1A_PREFIX "\\_SB.PCI0.PX40.EC0."
 #define P30_PREFIX "\\_SB.PCI0.LPCB.EC0."
@@ -206,6 +208,16 @@ static struct model_data model_conf[END_MODEL] = {
 	 .display_get = "\\INFB"},
 
 	{
+	 .name = "F2x",
+	 .mt_wled = "WLED",
+	 .mt_bt_switch = "BLED",
+	 .mt_lcd_switch = F2x_PREFIX "_Q10",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV",
+	 .display_set = "SDSP",
+	 .display_get = "\\ADVG"},
+
+	{
 	 .name = "L2D",
 	 .mt_mled = "MLED",
 	 .mled_status = "\\SGP6",
@@ -706,6 +718,8 @@ static int get_lcd_state(void)
 {
 	int lcd = 0;
 
+	BUG_ON(!hotk->methods->lcd_status);
+
 	if (hotk->model != L3H) {
 		/* We don't have to check anything if we are here */
 		if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
@@ -748,11 +762,17 @@ static int get_lcd_state(void)
 
 static int set_lcd_state(int value)
 {
-	int lcd = 0;
 	acpi_status status = 0;
 
-	lcd = value ? 1 : 0;
-	if (lcd != get_lcd_state()) {
+	if (!value && !hotk->methods->lcd_status) {
+		printk(KERN_ERR "Asus ACPI: You must pass nonzero value to "
+				"switch LCD status for this model\n");
+		return -EINVAL;
+	}
+
+	/* pay attention to lazy evaluation, we don't want to reach
+	   get_lcd_state if lcd_status is empty string */
+	if (!hotk->methods->lcd_status || !!value != get_lcd_state()) {
 		/* switch */
 		if (hotk->model != L3H) {
 			status =
@@ -778,7 +798,10 @@ static int
 proc_read_lcd(char *page, char **start, off_t off, int count, int *eof,
 	      void *data)
 {
-	return sprintf(page, "%d\n", get_lcd_state());
+	return hotk->methods->lcd_status ?
+		sprintf(page, "%d\n", get_lcd_state()) :
+		sprintf(page, "n/a (but 1 may be written to switch LCD "
+				"state)\n");
 }
 
 static int
@@ -1007,7 +1030,7 @@ static int asus_hotk_add_fs(struct acpi_device *device)
 	 * We need both read node and write method as LCD switch is also accessible
 	 * from keyboard 
 	 */
-	if (hotk->methods->mt_lcd_switch && hotk->methods->lcd_status) {
+	if (hotk->methods->mt_lcd_switch) {
 		asus_proc_add(PROC_LCD, &proc_write_lcd, &proc_read_lcd, mode,
 			      device);
 	}
@@ -1040,7 +1063,7 @@ static int asus_hotk_remove_fs(struct acpi_device *device)
 			remove_proc_entry(PROC_LEDD, acpi_device_dir(device));
 		if (hotk->methods->mt_bt_switch)
 			remove_proc_entry(PROC_BT, acpi_device_dir(device));
-		if (hotk->methods->mt_lcd_switch && hotk->methods->lcd_status)
+		if (hotk->methods->mt_lcd_switch)
 			remove_proc_entry(PROC_LCD, acpi_device_dir(device));
 		if ((hotk->methods->brightness_up
 		     && hotk->methods->brightness_down)
@@ -1091,6 +1114,8 @@ static int asus_model_match(char *model)
 		return L8L;
 	else if (strncmp(model, "L4R", 3) == 0)
 		return L4R;
+	else if (strncmp(model, "F2JE", 4) == 0)
+		return F2x;
 	else if (strncmp(model, "M6N", 3) == 0 || strncmp(model, "W3N", 3) == 0)
 		return M6N;
 	else if (strncmp(model, "M6R", 3) == 0 || strncmp(model, "A3G", 3) == 0)
