Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYGVFJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYGVFJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYGVFJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:09:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:35070 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYGVFJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PwBu3cF6FHVEglA2h3dscNiLgvox4ws+hXLk/P3S+dcp+hXTkylivQJ2MGHRb87O7l
         zapq/EPxQaxYfr1J1j0cHuYnb9iPcnj/jOwYgWE54oNzHB1mo9Xo9RmiW9Os9xnkGQ3q
         IysqGmq+In1VqM5FwGtu3pkVS5copvSBxbx+g=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: add apic probe for genapic 64bit v2
Date: Mon, 21 Jul 2008 22:08:21 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807211836.27282.yhlu.kernel@gmail.com>
In-Reply-To: <200807211836.27282.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807212208.22116.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so remove uv, x2apic related code from genapic_64.c to their specific
genapic files

v2: fix compiling when CONFIG_ACPI is not set

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/genapic_64.c        |   85 +++++++++++-------------------------
 arch/x86/kernel/genapic_flat_64.c   |   26 +++++++++++
 arch/x86/kernel/genx2apic_cluster.c |   11 ++++
 arch/x86/kernel/genx2apic_phys.c    |   21 ++++++++
 arch/x86/kernel/genx2apic_uv_x.c    |   32 +++++++++++++
 include/asm-x86/genapic_64.h        |    1 
 6 files changed, 116 insertions(+), 60 deletions(-)

Index: linux-2.6/arch/x86/kernel/genapic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_64.c
+++ linux-2.6/arch/x86/kernel/genapic_64.c
@@ -16,62 +16,37 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/hardirq.h>
-#include <linux/dmar.h>
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 
-#ifdef CONFIG_ACPI
-#include <acpi/acpi_bus.h>
-#endif
-
-DEFINE_PER_CPU(int, x2apic_extra_bits);
+extern struct genapic apic_flat;
+extern struct genapic apic_physflat;
+extern struct genapic apic_x2xpic_uv_x;
+extern struct genapic apic_x2apic_phys;
+extern struct genapic apic_x2apic_cluster;
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
-static int x2apic_phys = 0;
-
-static int set_x2apic_phys_mode(char *arg)
-{
-	x2apic_phys = 1;
-	return 0;
-}
-early_param("x2apic_phys", set_x2apic_phys_mode);
-
-static enum uv_system_type uv_system_type;
+static struct genapic *apic_probe[] __initdata = {
+	&apic_x2apic_uv_x,
+	&apic_x2apic_phys,
+	&apic_x2apic_cluster,
+	&apic_physflat,
+	NULL,
+};
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
 void __init setup_apic_routing(void)
 {
-	if (uv_system_type == UV_NON_UNIQUE_APIC)
-		genapic = &apic_x2apic_uv_x;
-	else if (cpu_has_x2apic && intr_remapping_enabled) {
-		if (x2apic_phys)
-			genapic = &apic_x2apic_phys;
-		else
-			genapic = &apic_x2apic_cluster;
-	} else
-#ifdef CONFIG_ACPI
-	/*
-	 * Quirk: some x86_64 machines can only use physical APIC mode
-	 * regardless of how many processors are present (x86_64 ES7000
-	 * is an example).
-	 */
-	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
-			(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
-		genapic = &apic_physflat;
-	else
-#endif
-
-	if (max_physical_apicid < 8)
-		genapic = &apic_flat;
-	else
-		genapic = &apic_physflat;
-
-	printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+	if (genapic == &apic_flat) {
+		if (max_physical_apicid >= 8)
+			genapic = &apic_physflat;
+		printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+	}
 }
 
 /* Same for both flat and physical. */
@@ -83,23 +58,15 @@ void apic_send_IPI_self(int vector)
 
 int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	if (!strcmp(oem_id, "SGI")) {
-		if (!strcmp(oem_table_id, "UVL"))
-			uv_system_type = UV_LEGACY_APIC;
-		else if (!strcmp(oem_table_id, "UVX"))
-			uv_system_type = UV_X2APIC;
-		else if (!strcmp(oem_table_id, "UVH"))
-			uv_system_type = UV_NON_UNIQUE_APIC;
+	int i;
+
+	for (i = 0; apic_probe[i]; ++i) {
+		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
+			genapic = apic_probe[i];
+			printk(KERN_INFO "Setting APIC routing to %s.\n",
+				genapic->name);
+			return 1;
+		}
 	}
 	return 0;
 }
-
-enum uv_system_type get_uv_system_type(void)
-{
-	return uv_system_type;
-}
-
-int is_uv_system(void)
-{
-	return uv_system_type != UV_NONE;
-}
Index: linux-2.6/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6/arch/x86/kernel/genapic_flat_64.c
@@ -21,6 +21,15 @@
 #include <asm/genapic.h>
 #include <mach_apicdef.h>
 
+#ifdef CONFIG_ACPI
+#include <acpi/acpi_bus.h>
+#endif
+
+static int __init flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return 1;
+}
+
 static cpumask_t flat_target_cpus(void)
 {
 	return cpu_online_map;
@@ -138,6 +147,7 @@ static unsigned int phys_pkg_id(int inde
 
 struct genapic apic_flat =  {
 	.name = "flat",
+	.acpi_madt_oem_check = flat_acpi_madt_oem_check,
 	.int_delivery_mode = dest_LowestPrio,
 	.int_dest_mode = (APIC_DEST_LOGICAL != 0),
 	.target_cpus = flat_target_cpus,
@@ -160,6 +170,21 @@ struct genapic apic_flat =  {
  * We cannot use logical delivery in this case because the mask
  * overflows, so use physical mode.
  */
+static int __init physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+#ifdef CONFIG_ACPI
+	/*
+	 * Quirk: some x86_64 machines can only use physical APIC mode
+	 * regardless of how many processors are present (x86_64 ES7000
+	 * is an example).
+	 */
+	if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
+		return 1;
+#endif
+
+	return 0;
+}
 
 static cpumask_t physflat_target_cpus(void)
 {
@@ -206,6 +231,7 @@ static unsigned int physflat_cpu_mask_to
 
 struct genapic apic_physflat =  {
 	.name = "physical flat",
+	.acpi_madt_oem_check = physflat_acpi_madt_oem_check,
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = physflat_target_cpus,
Index: linux-2.6/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/genx2apic_cluster.c
@@ -4,12 +4,22 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/dmar.h>
+
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 
 DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
+static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (cpu_has_x2apic && intr_remapping_enabled)
+		return 1;
+
+	return 0;
+}
+
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
 static cpumask_t x2apic_target_cpus(void)
@@ -135,6 +145,7 @@ static void init_x2apic_ldr(void)
 
 struct genapic apic_x2apic_cluster = {
 	.name = "cluster x2apic",
+	.acpi_madt_oem_check = x2apic_acpi_madt_oem_check,
 	.int_delivery_mode = dest_LowestPrio,
 	.int_dest_mode = (APIC_DEST_LOGICAL != 0),
 	.target_cpus = x2apic_target_cpus,
Index: linux-2.6/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6/arch/x86/kernel/genx2apic_phys.c
@@ -4,10 +4,30 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/dmar.h>
+
 #include <asm/smp.h>
 #include <asm/ipi.h>
 #include <asm/genapic.h>
 
+DEFINE_PER_CPU(int, x2apic_extra_bits);
+
+static int x2apic_phys;
+
+static int set_x2apic_phys_mode(char *arg)
+{
+	x2apic_phys = 1;
+	return 0;
+}
+early_param("x2apic_phys", set_x2apic_phys_mode);
+
+static int __init x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (cpu_has_x2apic && intr_remapping_enabled && x2apic_phys)
+		return 1;
+
+	return 0;
+}
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
@@ -122,6 +142,7 @@ void init_x2apic_ldr(void)
 
 struct genapic apic_x2apic_phys = {
 	.name = "physical x2apic",
+	.acpi_madt_oem_check = x2apic_acpi_madt_oem_check,
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = x2apic_target_cpus,
Index: linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
@@ -27,6 +27,33 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/bios.h>
 
+static enum uv_system_type uv_system_type;
+
+static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (!strcmp(oem_id, "SGI")) {
+		if (!strcmp(oem_table_id, "UVL"))
+			uv_system_type = UV_LEGACY_APIC;
+		else if (!strcmp(oem_table_id, "UVX"))
+			uv_system_type = UV_X2APIC;
+		else if (!strcmp(oem_table_id, "UVH")) {
+			uv_system_type = UV_NON_UNIQUE_APIC;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+enum uv_system_type get_uv_system_type(void)
+{
+	return uv_system_type;
+}
+
+int is_uv_system(void)
+{
+	return uv_system_type != UV_NONE;
+}
+
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
 
@@ -153,7 +180,7 @@ static unsigned int get_apic_id(unsigned
 	return id;
 }
 
-static long set_apic_id(unsigned int id)
+static unsigned long set_apic_id(unsigned int id)
 {
 	unsigned long x;
 
@@ -182,6 +209,7 @@ static void uv_send_IPI_self(int vector)
 
 struct genapic apic_x2apic_uv_x = {
 	.name = "UV large system",
+	.acpi_madt_oem_check = uv_acpi_madt_oem_check,
 	.int_delivery_mode = dest_Fixed,
 	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
 	.target_cpus = uv_target_cpus,
@@ -433,3 +461,5 @@ void __cpuinit uv_cpu_init(void)
 	if (get_uv_system_type() == UV_NON_UNIQUE_APIC)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
+
+
Index: linux-2.6/include/asm-x86/genapic_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/genapic_64.h
+++ linux-2.6/include/asm-x86/genapic_64.h
@@ -14,6 +14,7 @@
 
 struct genapic {
 	char *name;
+	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
