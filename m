Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0BVTL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:11:27 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30591 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab0BVTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:21 -0500
Subject: [PATCH v2 03/12] ACPI: processor: export acpi_get_cpuid()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date: Mon, 22 Feb 2010 12:11:19 -0700
Message-ID: <20100222191119.19752.16739.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename static get_cpu_id() to acpi_get_cpuid() and export it.

This change also gives us an opportunity to remove the
#ifndef CONFIG_SMP from processor_driver.c and into a header file
where it properly belongs.

Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/processor_driver.c |   10 ++++------
 include/acpi/processor.h        |    8 ++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index d2f285b..404fab4 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -359,10 +359,7 @@ static inline int acpi_processor_remove_fs(struct acpi_device *device)
 
 /* Use the acpiid in MADT to map cpus in case of SMP */
 
-#ifndef CONFIG_SMP
-static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id) { return -1; }
-#else
-
+#ifdef CONFIG_SMP
 static struct acpi_table_madt *madt;
 
 static int map_lapic_id(struct acpi_subtable_header *entry,
@@ -494,7 +491,7 @@ exit:
 	return apic_id;
 }
 
-static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id)
+int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 {
 	int i;
 	int apic_id = -1;
@@ -511,6 +508,7 @@ static int get_cpu_id(acpi_handle handle, int type, u32 acpi_id)
 	}
 	return -1;
 }
+EXPORT_SYMBOL_GPL(acpi_get_cpuid);
 #endif
 
 /* --------------------------------------------------------------------------
@@ -577,7 +575,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		device_declaration = 1;
 		pr->acpi_id = value;
 	}
-	cpu_index = get_cpu_id(pr->handle, device_declaration, pr->acpi_id);
+	cpu_index = acpi_get_cpuid(pr->handle, device_declaration, pr->acpi_id);
 
 	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 	if (!cpu0_initialized && (cpu_index == -1) &&
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index c642f55..8ebb89a 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -322,6 +322,14 @@ static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 
 /* in processor_core.c */
 void acpi_processor_set_pdc(acpi_handle handle);
+#ifdef CONFIG_SMP
+int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
+#else
+static inline int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+{
+	return -1;
+}
+#endif
 
 /* in processor_throttling.c */
 int acpi_processor_tstate_has_changed(struct acpi_processor *pr);

