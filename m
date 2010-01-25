Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580Ab0AYVlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0AYVlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014Ab0AYVlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:41:07 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:38019 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab0AYVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:41:05 -0500
Subject: [PATCH 05/12] ACPI: processor: add internal
	processor_physically_present()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Jan 2010 14:41:03 -0700
Message-ID: <20100125214103.28510.69941.stgit@bob.kio>
In-Reply-To: <20100125213221.28510.74078.stgit@bob.kio>
References: <20100125213221.28510.74078.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect if a processor is physically present before evaluating _PDC.

We want this because some BIOS will provide a _PDC even for processors
that are not present. These bogus _PDC methods then attempt to load
non-existent tables, which causes problems.

Avoid those bogus landmines.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_core.c |   42 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ca12d70..e8b1246 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -194,6 +194,45 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
 #endif
 
+static bool processor_physically_present(acpi_handle handle)
+{
+	int cpuid, type;
+	u32 acpi_id;
+	acpi_status status;
+	acpi_object_type acpi_type;
+	unsigned long long tmp;
+	union acpi_object object = { 0 };
+	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
+
+	status = acpi_get_type(handle, &acpi_type);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	switch (acpi_type) {
+	case ACPI_TYPE_PROCESSOR:
+		status = acpi_evaluate_object(handle, NULL, NULL, &buffer);
+		if (ACPI_FAILURE(status))
+			return false;
+		acpi_id = object.processor.proc_id;
+		break;
+	case ACPI_TYPE_DEVICE:
+		status = acpi_evaluate_integer(handle, "_UID", NULL, &tmp);
+		if (ACPI_FAILURE(status))
+			return false;
+		acpi_id = tmp;
+		break;
+	default:
+		return false;
+	}
+
+	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
+	cpuid = acpi_get_cpuid(handle, type, acpi_id);
+
+	if (cpuid == -1)
+		return false;
+
+	return true;
+}
 
 static void acpi_set_pdc_bits(u32 *buf)
 {
@@ -335,6 +374,9 @@ static struct dmi_system_id __cpuinitdata early_pdc_optin_table[] = {
 static acpi_status
 early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
+	if (processor_physically_present(handle) == false)
+		return AE_OK;
+
 	acpi_processor_set_pdc(handle);
 	return AE_OK;
 }

