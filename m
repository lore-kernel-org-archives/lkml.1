Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620Ab0ADQWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0ADQWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522Ab0ADQWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:22:00 -0500
Received: from percival.namespace.at ([77.244.242.130]:39078 "EHLO
	percival.namespace.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab0ADQV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:21:59 -0500
Date: Mon, 4 Jan 2010 17:21:14 +0100
From: Christian Hofstaedtler <ch@zeha.at>
To: x86@kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       bruce.w.allan@intel.com, tglx@linutronix.de, hpa@zytor.com,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100104162114.GA30113@percival.namespace.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100103150300.170dedee@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Hofstaedtler <ch+git@zeha.at>

The Intel DP55KG mainboard cannot reboot using the keyboard controller,
but ACPI works fine. Auto-select ACPI for this board.

Signed-off-by: Christian Hofstaedtler <ch@zeha.at>
---
 arch/x86/kernel/reboot.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1545bc0..b7fcf59 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -427,6 +427,19 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
+/*
+ * Some Intel mainboards need reboot=a to actually reboot
+ */
+static int __init set_acpi_reboot(const struct dmi_system_id *d)
+{
+	if (reboot_type != BOOT_ACPI) {
+		reboot_type = BOOT_ACPI;
+		printk(KERN_INFO "%s hardware detected. "
+		       "Selecting ACPI-method for reboots.\n", d->ident);
+	}
+	return 0;
+}
+
 static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 	{	/* Handle problems with rebooting on Apple MacBook5 */
 		.callback = set_pci_reboot,
@@ -452,6 +465,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on Intel DP55KG mainboard */
+		.callback = set_acpi_reboot,
+		.ident = "Intel DP55KG Mainboard",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "DP55KG"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.4.4

