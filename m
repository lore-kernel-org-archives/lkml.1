Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902Ab0AYVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0AYVnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260Ab0AYVlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:41:13 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13727 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0AYVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:41:09 -0500
Subject: [PATCH 06/12] ACPI: processor: remove early _PDC optin quirks
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 25 Jan 2010 14:41:08 -0700
Message-ID: <20100125214108.28510.57323.stgit@bob.kio>
In-Reply-To: <20100125213221.28510.74078.stgit@bob.kio>
References: <20100125213221.28510.74078.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we check for physically present processors before blindly
evaluating _PDC, we no longer need to maintain a DMI opt-in table
nor a kernel param.

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/kernel-parameters.txt |    4 ----
 drivers/acpi/processor_core.c       |   37 -----------------------------------
 2 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 826b6e1..736d456 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -199,10 +199,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			acpi_display_output=video
 			See above.
 
-	acpi_early_pdc_eval	[HW,ACPI] Evaluate processor _PDC methods
-				early. Needed on some platforms to properly
-				initialize the EC.
-
 	acpi_irq_balance [HW,ACPI]
 			ACPI will balance active IRQs
 			default in APIC mode
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index e8b1246..05874ba 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -341,36 +341,6 @@ void acpi_processor_set_pdc(acpi_handle handle)
 }
 EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
 
-static int early_pdc_optin;
-static int set_early_pdc_optin(const struct dmi_system_id *id)
-{
-	early_pdc_optin = 1;
-	return 0;
-}
-
-static int param_early_pdc_optin(char *s)
-{
-	early_pdc_optin = 1;
-	return 1;
-}
-__setup("acpi_early_pdc_eval", param_early_pdc_optin);
-
-static struct dmi_system_id __cpuinitdata early_pdc_optin_table[] = {
-	{
-	set_early_pdc_optin, "HP Envy", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "HP Envy") }, NULL},
-	{
-	set_early_pdc_optin, "HP Pavilion dv6", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv6") }, NULL},
-	{
-	set_early_pdc_optin, "HP Pavilion dv7", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
-	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv7") }, NULL},
-	{},
-};
-
 static acpi_status
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
@@ -396,13 +366,6 @@ void acpi_early_processor_set_pdc(void)
 	 */
 	dmi_check_system(processor_idle_dmi_table);
 
-	/*
-	 * Allow systems to opt-in to early _PDC evaluation.
-	 */
-	dmi_check_system(early_pdc_optin_table);
-	if (!early_pdc_optin)
-		return;
-
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);

