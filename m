Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbZBSVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbZBSVvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZBSVvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:51:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:47969 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbZBSVvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:51:36 -0500
Message-ID: <499DD40F.40102@kernel.org>
Date: Thu, 19 Feb 2009 13:50:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: enable x2apic early at the first point
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug.

otherwise will get panic from early_acpi_boot_init()
also make disable_x2apic global, so could use it it x2_apic_xxx.c
and can get warning if preenabled system using nox2apic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c           |    3 +--
 arch/x86/kernel/apic/x2apic_cluster.c |    5 ++++-
 arch/x86/kernel/apic/x2apic_phys.c    |    5 ++++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
 drivers/pci/dmar.c                    |    3 ++-
 5 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_cluster.c
@@ -14,8 +14,11 @@ DEFINE_PER_CPU(u32, x86_cpu_to_logical_a
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (cpu_has_x2apic)
+	if (cpu_has_x2apic && !disable_x2apic) {
+		x2apic = 1;
+		enable_x2apic();
 		return 1;
+	}
 
 	return 0;
 }
Index: linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
@@ -21,8 +21,11 @@ early_param("x2apic_phys", set_x2apic_ph
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (cpu_has_x2apic && x2apic_phys)
+	if (cpu_has_x2apic && !disable_x2apic && x2apic_phys) {
+		x2apic = 1;
+		enable_x2apic();
 		return 1;
+	}
 
 	return 0;
 }
Index: linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -41,8 +41,10 @@ static int uv_acpi_madt_oem_check(char *
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
-		else if (!strcmp(oem_table_id, "UVH")) {
+		else if (!strcmp(oem_table_id, "UVH") && !disable_x2apic) {
 			uv_system_type = UV_NON_UNIQUE_APIC;
+			x2apic = 1;
+			enable_x2apic();
 			return 1;
 		}
 	}
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -116,11 +116,10 @@ __setup("apicpmtimer", setup_apicpmtimer
 int x2apic;
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
-static int disable_x2apic;
+int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
 	disable_x2apic = 1;
-	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -472,7 +472,8 @@ void __init detect_intel_iommu(void)
 		 * is added, we will not need this any more.
 		 */
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
-		if (ret && cpu_has_x2apic && dmar->flags & 0x1)
+		if (ret && cpu_has_x2apic && !disable_x2apic &&
+			 dmar->flags & 0x1)
 			printk(KERN_INFO
 			       "Queued invalidation will be enabled to support "
 			       "x2apic and Intr-remapping.\n");
