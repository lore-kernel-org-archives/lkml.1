Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZLOHUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZLOHUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbZLOHUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:20:46 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:41326 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608AbZLOHUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:20:46 -0500
Date: Tue, 15 Dec 2009 08:20:41 +0100
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>,
       Peter Feuerer <peter@piie.net>
Subject: [PATCH] Check BIOS information whether it begins with string of
 table
Message-Id: <20091215082041.c886826b.peter@piie.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

please apply.

Thank you very much,
--peter

---
BIOS information is now checked whether it begins with the strings
 stored in the BIOS table. Previous method did a strcmp, what lead to
 problems if BIOS information has appended whitespaces.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/platform/x86/acerhdf.c |   46 ++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index a97fc4a..7b2384d 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.21"
+#define DRV_VER "0.5.22"
 
 /*
  * According to the Atom N270 datasheet,
@@ -165,12 +165,9 @@ static const struct bios_settings_t bios_tbl[] = {
 	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Gateway         ", "LT31            ", "v1.3103 ", 0x55, 0x58,
-		{0x10, 0x0f, 0x00} },
-	{"Gateway         ", "LT31            ", "v1.3201 ", 0x55, 0x58,
-		{0x10, 0x0f, 0x00} },
-	{"Gateway         ", "LT31            ", "v1.3302 ", 0x55, 0x58,
-		{0x10, 0x0f, 0x00} },
+	{"Gateway", "LT31", "v1.3103", 0x55, 0x58, {0x10, 0x0f, 0x00} },
+	{"Gateway", "LT31", "v1.3201", 0x55, 0x58, {0x10, 0x0f, 0x00} },
+	{"Gateway", "LT31", "v1.3302", 0x55, 0x58, {0x10, 0x0f, 0x00} },
 	/* Packard Bell */
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
@@ -495,13 +492,26 @@ static struct platform_driver acerhdf_driver = {
 	.remove = acerhdf_remove,
 };
 
+/* checks if str begins with start */
+static int str_starts_with(const char *str, const char *start)
+{
+	unsigned long str_len = 0, start_len = 0;
+
+	str_len = strlen(str);
+	start_len = strlen(start);
+
+	if (str_len >= start_len &&
+			!strncmp(str, start, start_len))
+		return 1;
+
+	return 0;
+}
 
 /* check hardware */
 static int acerhdf_check_hardware(void)
 {
 	char const *vendor, *version, *product;
-	int i;
-	unsigned long prod_len = 0;
+	const struct bios_settings_t *bt = NULL;
 
 	/* get BIOS data */
 	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
@@ -523,20 +533,20 @@ static int acerhdf_check_hardware(void)
 		kernelmode = 0;
 	}
 
-	prod_len = strlen(product);
-
 	if (verbose)
 		pr_info("BIOS info: %s %s, product: %s\n",
 			vendor, version, product);
 
 	/* search BIOS version and vendor in BIOS settings table */
-	for (i = 0; bios_tbl[i].version[0]; i++) {
-		if (strlen(bios_tbl[i].product) >= prod_len &&
-		    !strncmp(bios_tbl[i].product, product,
-			   strlen(bios_tbl[i].product)) &&
-		    !strcmp(bios_tbl[i].vendor, vendor) &&
-		    !strcmp(bios_tbl[i].version, version)) {
-			bios_cfg = &bios_tbl[i];
+	for (bt = bios_tbl; bt->vendor[0]; bt++) {
+		/*
+		 * check if actual hardware BIOS vendor, product and version
+		 * IDs start with the strings of BIOS table entry
+		 */
+		if (str_starts_with(vendor, bt->vendor) &&
+				str_starts_with(product, bt->product) &&
+				str_starts_with(version, bt->version)) {
+			bios_cfg = bt;
 			break;
 		}
 	}
-- 
1.6.5.4

