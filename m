Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbXDKJdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbXDKJdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXDKJdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:33:53 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:25809 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXDKJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:33:52 -0400
Message-id: <22473653910004885@karneval.cz>
Subject: [PATCH 1/1] ACPI: asus_acpi, support F2JE model
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <corentincj@iksaif.net>
Cc: <sziwan@users.sourceforge.net>
Cc: <acpi4asus-user@lists.sourceforge.net>
Cc: <len.brown@intel.com>
Cc: <linux-acpi@vger.kernel.org>
Date: Wed, 11 Apr 2007 11:33:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

asus_acpi, support F2JE model

also augment the driver to support switching LCD status even if no function
for getting lcd status doesn't exist in DSDT.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 4e55effd524fffae1113c301d63d4cd5280264ab
tree 96d1c15a7ee82558bcbf1bb4b6e66c435781758d
parent 0156510dee9d326af2ec52cf8b1a388ce9a839e9
author Jiri Slaby <jirislaby@gmail.com> Wed, 11 Apr 2007 11:28:34 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 11 Apr 2007 11:28:34 +0200

 drivers/acpi/asus_acpi.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/asus_acpi.c b/drivers/acpi/asus_acpi.c
index 0a9ea00..e9c1630 100644
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
@@ -206,6 +208,17 @@ static struct model_data model_conf[END_MODEL] = {
 	 .display_get = "\\INFB"},
 
 	{
+	 .name = "F2x",
+	 .mt_wled = "WLED",
+	 .mt_bt_switch = "BLED",
+	 .mt_lcd_switch = F2x_PREFIX "_Q10",
+	 .lcd_status = "",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV",
+	 .display_set = "SDSP",
+	 .display_get = "\\ADVG"},
+
+	{
 	 .name = "L2D",
 	 .mt_mled = "MLED",
 	 .mled_status = "\\SGP6",
@@ -706,6 +719,8 @@ static int get_lcd_state(void)
 {
 	int lcd = 0;
 
+	BUG_ON(!*hotk->methods->lcd_status);
+
 	if (hotk->model != L3H) {
 		/* We don't have to check anything if we are here */
 		if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
@@ -748,11 +763,17 @@ static int get_lcd_state(void)
 
 static int set_lcd_state(int value)
 {
-	int lcd = 0;
 	acpi_status status = 0;
 
-	lcd = value ? 1 : 0;
-	if (lcd != get_lcd_state()) {
+	if (!value && !*hotk->methods->lcd_status) {
+		printk(KERN_ERR "You must pass nonzero value to switch LCD "
+				"status for this model\n");
+		return -EINVAL;
+	}
+
+	/* pay attention to lazy evaluation, we don't want to reach
+	   get_lcd_state if lcd_status is empty string */
+	if (!*hotk->methods->lcd_status || !!value != get_lcd_state()) {
 		/* switch */
 		if (hotk->model != L3H) {
 			status =
@@ -778,7 +799,9 @@ static int
 proc_read_lcd(char *page, char **start, off_t off, int count, int *eof,
 	      void *data)
 {
-	return sprintf(page, "%d\n", get_lcd_state());
+	return *hotk->methods->lcd_status ?
+		sprintf(page, "%d\n", get_lcd_state()) :
+		sprintf(page, "n/a (but 1 may be written to switch LCD)\n");
 }
 
 static int
@@ -1091,6 +1114,8 @@ static int asus_model_match(char *model)
 		return L8L;
 	else if (strncmp(model, "L4R", 3) == 0)
 		return L4R;
+	else if (strncmp(model, "F2JE", 4) == 0)
+		return F2x;
 	else if (strncmp(model, "M6N", 3) == 0 || strncmp(model, "W3N", 3) == 0)
 		return M6N;
 	else if (strncmp(model, "M6R", 3) == 0 || strncmp(model, "A3G", 3) == 0)
