Return-Path: <linux-kernel-owner+w=401wt.eu-S1751394AbZL1SjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbZL1SjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 13:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZL1SjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 13:39:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:31246 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZL1SjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 13:39:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,463,1257148800"; 
   d="scan'208";a="759698098"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Len Brown" <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, "Alex Chiang" <achiang@hp.com>
References: <20091220191909.4274.63584.stgit@bob.kio>
Subject: [PATCH] Fix section mismatch error for acpi_early_processor_set_pdc()
Date: Mon, 28 Dec 2009 10:39:23 -0800
Message-Id: <4b38fb5b18912746ff@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang introduced acpi_early_processor_set_pdc() in commit:
 ACPI: processor: call _PDC early
 78f1699659963fff97975df44db6d5dbe7218e55

But this results in a section mismatch:

WARNING: drivers/acpi/acpi.o(.text+0xa9c1): Section mismatch in reference from the
function acpi_early_processor_set_pdc() to the variable .cpuinit.data:processor_idle_dmi_table
The function acpi_early_processor_set_pdc() references
the variable __cpuinitdata processor_idle_dmi_table.
This is often because acpi_early_processor_set_pdc lacks a __cpuinitdata
annotation or the annotation of processor_idle_dmi_table is wrong.

The only caller of acpi_early_processor_set_pdc() is acpi_bus_init() which
is an "__init" function. So the correct fix here is to mark
acpi_early_processor_set_pdc() "__init" too.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 30e4dc0..7d4ee39 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -151,7 +151,7 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-void acpi_early_processor_set_pdc(void)
+void __init acpi_early_processor_set_pdc(void)
 {
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM
