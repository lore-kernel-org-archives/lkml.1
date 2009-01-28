Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZA1Xv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZA1Xv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbZA1XoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:37463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbZA1Xn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:59 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 019/114] x86: clean up apic->acpi_madt_oem_check methods
Date: Wed, 28 Jan 2009 23:41:25 +0000
Message-Id: <1233186180-29883-20-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: refactor code

x86 subarchitectures each defined a "acpi_madt_oem_check()" method,
which could be an inline function, or an extern, or a static function,
and which was also the name of a genapic field.

Untangle this namespace spaghetti by setting ->acpi_madt_oem_check()
to NULL on those subarchitectures that have no detection quirks,
and rename the other ones (summit, es7000) that do.

Also change default_acpi_madt_oem_check() to handle NULL entries,
and clean its control flow up as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/mpparse.h            |    2 +-
 arch/x86/include/asm/genapic.h                   |    2 +-
 arch/x86/include/asm/mach-default/mach_mpparse.h |    2 +-
 arch/x86/include/asm/mach-generic/mach_mpparse.h |    2 +-
 arch/x86/include/asm/summit/mpparse.h            |    2 +-
 arch/x86/kernel/acpi/boot.c                      |    3 +-
 arch/x86/kernel/genapic_64.c                     |    2 +-
 arch/x86/mach-generic/bigsmp.c                   |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mach-generic/es7000.c                   |    6 ++--
 arch/x86/mach-generic/numaq.c                    |    8 +------
 arch/x86/mach-generic/probe.c                    |   24 ++++++++++++---------
 arch/x86/mach-generic/summit.c                   |    2 +-
 13 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/es7000/mpparse.h b/arch/x86/include/asm/es7000/mpparse.h
index c1629b0..30692c4 100644
--- a/arch/x86/include/asm/es7000/mpparse.h
+++ b/arch/x86/include/asm/es7000/mpparse.h
@@ -9,7 +9,7 @@ extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
 extern void setup_unisys(void);
 
 #ifndef CONFIG_X86_GENERICARCH
-extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
+extern int default_acpi_madt_oem_check(char *oem_id, char *oem_table_id);
 extern int mps_oem_check(struct mpc_table *mpc, char *oem, char *productid);
 #endif
 
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 26c5e82..108abdf 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -103,7 +103,7 @@ extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 extern struct genapic apic_x2apic_cluster;
 extern struct genapic apic_x2apic_phys;
-extern int acpi_madt_oem_check(char *, char *);
+extern int default_acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
 
diff --git a/arch/x86/include/asm/mach-default/mach_mpparse.h b/arch/x86/include/asm/mach-default/mach_mpparse.h
index c70a263..8fa0177 100644
--- a/arch/x86/include/asm/mach-default/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-default/mach_mpparse.h
@@ -8,7 +8,7 @@ mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 }
 
 /* Hook from generic ACPI tables.c */
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static inline int default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/mach-generic/mach_mpparse.h b/arch/x86/include/asm/mach-generic/mach_mpparse.h
index 9444ab8..f497d96 100644
--- a/arch/x86/include/asm/mach-generic/mach_mpparse.h
+++ b/arch/x86/include/asm/mach-generic/mach_mpparse.h
@@ -4,6 +4,6 @@
 
 extern int mps_oem_check(struct mpc_table *, char *, char *);
 
-extern int acpi_madt_oem_check(char *, char *);
+extern int default_acpi_madt_oem_check(char *, char *);
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_MPPARSE_H */
diff --git a/arch/x86/include/asm/summit/mpparse.h b/arch/x86/include/asm/summit/mpparse.h
index 380e86c..555ed82 100644
--- a/arch/x86/include/asm/summit/mpparse.h
+++ b/arch/x86/include/asm/summit/mpparse.h
@@ -27,7 +27,7 @@ static inline int mps_oem_check(struct mpc_table *mpc, char *oem,
 }
 
 /* Hook from generic ACPI tables.c */
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static inline int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strncmp(oem_id, "IBM", 3) &&
 	    (!strncmp(oem_table_id, "SERVIGIL", 8)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 4cb5964..314fe0d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -239,7 +239,8 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 		       madt->address);
 	}
 
-	acpi_madt_oem_check(madt->header.oem_id, madt->header.oem_table_id);
+	default_acpi_madt_oem_check(madt->header.oem_id,
+				    madt->header.oem_table_id);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index 2b98638..060945b 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -68,7 +68,7 @@ void apic_send_IPI_self(int vector)
 	__send_IPI_shortcut(APIC_DEST_SELF, vector, APIC_DEST_PHYSICAL);
 }
 
-int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	int i;
 
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 13e82bc..22c3608 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -61,7 +61,7 @@ struct genapic apic_bigsmp = {
 
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
-	.acpi_madt_oem_check		= acpi_madt_oem_check,
+	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index d5fec76..cfec349 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -28,7 +28,7 @@ struct genapic apic_default = {
 
 	.name				= "default",
 	.probe				= probe_default,
-	.acpi_madt_oem_check		= acpi_madt_oem_check,
+	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 4a404ea..23fe6f1 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -57,7 +57,7 @@ mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 
 #ifdef CONFIG_ACPI
 /* Hook from generic ACPI tables.c */
-static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	unsigned long oem_addr = 0;
 	int check_dsdt;
@@ -81,7 +81,7 @@ static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return ret;
 }
 #else
-static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 0;
 }
@@ -104,7 +104,7 @@ struct genapic apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
-	.acpi_madt_oem_check		= acpi_madt_oem_check,
+	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
 	.apic_id_registered		= apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index fa486ca..9691b4e 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -31,12 +31,6 @@ static int probe_numaq(void)
 	return found_numaq;
 }
 
-/* Hook from generic ACPI tables.c */
-static int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	return 0;
-}
-
 static void vector_allocation_domain(int cpu, cpumask_t *retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
@@ -54,7 +48,7 @@ struct genapic apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
-	.acpi_madt_oem_check		= acpi_madt_oem_check,
+	.acpi_madt_oem_check		= NULL,
 	.apic_id_registered		= apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index 82bf0f5..a21e2b1 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -128,20 +128,24 @@ int __init mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 	return 0;
 }
 
-int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	int i;
+
 	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
-			if (!cmdline_apic) {
-				apic = apic_probe[i];
-				if (x86_quirks->update_genapic)
-					x86_quirks->update_genapic();
-				printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-				       apic->name);
-			}
-			return 1;
+		if (!apic_probe[i]->acpi_madt_oem_check)
+			continue;
+		if (!apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id))
+			continue;
+
+		if (!cmdline_apic) {
+			apic = apic_probe[i];
+			if (x86_quirks->update_genapic)
+				x86_quirks->update_genapic();
+			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
+			       apic->name);
 		}
+		return 1;
 	}
 	return 0;
 }
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 479c1d4..0eea9fb 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -41,7 +41,7 @@ struct genapic apic_summit = {
 
 	.name				= "summit",
 	.probe				= probe_summit,
-	.acpi_madt_oem_check		= acpi_madt_oem_check,
+	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
 	.apic_id_registered		= apic_id_registered,
 
 	.int_delivery_mode		= INT_DELIVERY_MODE,
-- 
1.6.0.2

