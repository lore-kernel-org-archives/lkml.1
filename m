Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZBFAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZBFAWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZBFAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:22:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbZBFAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:22:31 -0500
Date: Thu, 5 Feb 2009 16:21:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-input@vger.kernel.org, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] input: add a DMI table for the i8042.reset option;
 make MSI Wind U-100 work
Message-Id: <20090205162157.572f15bb.akpm@linux-foundation.org>
In-Reply-To: <20090204191728.7ed66e58@infradead.org>
References: <20090204191540.2d6abd87@infradead.org>
	<20090204191728.7ed66e58@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 19:17:28 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> There are several DMI tables in the i8042 (keyboard) driver already,
> but not one for the i8042.reset option. This patch adds such an option
> (which also sets the nonfatal flag so that if the reset fails, the keyboard
> still works).
> 
> Two users for this table are added as well, the MSI Wind U-100 and the
> LG X110. The MSI Wind also needs to be in the "don't trust the pnp data"
> for the touchpad to work on my machine.

x86_64 allnoconfig:

drivers/input/serio/i8042-x86ia64io.h:458: warning: 'i8042_dmi_reset_table' defined but not used


From: Andrew Morton <akpm@linux-foundation.org>

drivers/input/serio/i8042-x86ia64io.h:458: warning: 'i8042_dmi_reset_table' defined but not used

Fix this by moving both i8042_dmi_nopnp_tablep[] and i8042_dmi_reset_table[]
into a section which requires CONFIG_PNP and CONFIG_X86.  Give their
usage sites the same treatment.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-x86ia64io.h |   79 +++++++++++-------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff -puN drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix drivers/input/serio/i8042-x86ia64io.h
--- a/drivers/input/serio/i8042-x86ia64io.h~input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work-fix
+++ a/drivers/input/serio/i8042-x86ia64io.h
@@ -369,26 +369,6 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
-#ifdef CONFIG_PNP
-static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
-	{
-		.ident = "Intel MBO Desktop D845PESV",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
-		},
-	},
-	{
-		.ident = "MSI Wind U-100",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{ }
-};
-#endif
-
 /*
  * Some Wistron based laptops need us to explicitly enable the 'Dritek
  * keyboard extension' to make their extra keys start generating scancodes.
@@ -455,25 +435,6 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
-static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
-	{
-		.ident = "MSI Wind U-100",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
-		},
-	},
-	{
-		.ident = "LG Electronics X110",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_NAME, "X110"),
-			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
-		},
-	},
-	{ }
-};
-
-
 #endif /* CONFIG_X86 */
 
 #ifdef CONFIG_PNP
@@ -492,6 +453,44 @@ static int i8042_pnp_aux_irq;
 static char i8042_pnp_kbd_name[32];
 static char i8042_pnp_aux_name[32];
 
+#ifdef CONFIG_X86
+static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
+	{
+		.ident = "Intel MBO Desktop D845PESV",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+		},
+	},
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{ }
+};
+
+static struct dmi_system_id __initdata i8042_dmi_reset_table[] = {
+	{
+		.ident = "MSI Wind U-100",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "U-100"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
+		},
+	},
+	{
+		.ident = "LG Electronics X110",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X110"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "LG Electronics Inc."),
+		},
+	},
+	{ }
+};
+#endif
+
 static int i8042_pnp_kbd_probe(struct pnp_dev *dev, const struct pnp_device_id *did)
 {
 	if (pnp_port_valid(dev, 0) && pnp_port_len(dev, 0) == 1)
@@ -588,12 +587,12 @@ static int __init i8042_pnp_init(void)
 #ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_nopnp_table))
 		i8042_nopnp = 1;
-#endif
 
 	if (dmi_check_system(i8042_dmi_reset_table)) {
 		i8042_reset = 1;
 		i8042_nonfatal = 1;
 	}
+#endif
 
 	if (i8042_nopnp) {
 		printk(KERN_INFO "i8042: PNP detection disabled\n");
_

