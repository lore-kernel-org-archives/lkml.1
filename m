Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074Ab0ASXzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0ASXzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410Ab0ASXzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:55:42 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43767 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0ASXzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:55:41 -0500
Date: Tue, 19 Jan 2010 16:55:41 -0700
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: processor: restrict early _PDC to opt-in platforms
Message-ID: <20100119235541.GL11010@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 78f1699 (ACPI: processor: call _PDC early) blindly walks
the namespace and calls _PDC on every processor object it finds.

This change may cause issues on platforms that declare dummy
values for SSDTs on non-present processors (disabled in MADT).
When we call _PDC and dynamically attempt to execute the AML
Load() op on these dummy SSDTs, there's no telling what might
happen.

Rather than finding every platform that has bogus SSDTs, restrict
early _PDC calls to platforms that are known to need early
evaluation of _PDC.

This is a minimal, temporary fix (given the context of the
current release cycle). A real solution of checking the MADT for
non-present processors will be written for the next merge window.

References:

	http://bugzilla.kernel.org/show_bug.cgi?id=14710
	http://bugzilla.kernel.org/show_bug.cgi?id=14954

Signed-off-by: Alex Chiang <achiang@hp.com>
---
Tested on my HP Envy 15. I don't have a DVxT; so I based this
patch on the dmidecode output attached in bz14710.

 processor_pdc.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
---
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 30e4dc0..f336437 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -144,6 +144,29 @@ void acpi_processor_set_pdc(acpi_handle handle)
 }
 EXPORT_SYMBOL_GPL(acpi_processor_set_pdc);
 
+static int early_pdc_optin;
+static int set_early_pdc_optin(const struct dmi_system_id *id)
+{
+	early_pdc_optin = 1;
+	return 0;
+}
+
+static struct dmi_system_id __cpuinitdata early_pdc_optin_table[] = {
+	{
+	set_early_pdc_optin, "HP Envy", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Envy") }, NULL},
+	{
+	set_early_pdc_optin, "HP Pavilion dv6", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv6") }, NULL},
+	{
+	set_early_pdc_optin, "HP Pavilion dv7", {
+	DMI_MATCH(DMI_BIOS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv7") }, NULL},
+	{},
+};
+
 static acpi_status
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
@@ -159,6 +182,13 @@ void acpi_early_processor_set_pdc(void)
 	 */
 	dmi_check_system(processor_idle_dmi_table);
 
+	/*
+	 * Allow systems to opt-in to early _PDC evaluation.
+	 */
+	dmi_check_system(early_pdc_optin_table);
+	if (!early_pdc_optin)
+		return;
+
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
