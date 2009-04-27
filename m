Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZD0Gkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZD0Gkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZD0GkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:40:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbZD0GkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:40:11 -0400
Message-ID: <49F5532A.5000802@kernel.org>
Date: Sun, 26 Apr 2009 23:39:38 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use dmi check in apic_is_clustered with 64bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


will have system with 2 and more sockets 8cores/2thread.
do treat them as multi chassis.

use dmi check instead.

[ Impact: do not make unstable TSC on wrongly ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |   86 ++++++++++++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -2142,31 +2142,14 @@ static void apic_pm_activate(void) { }
 #endif	/* CONFIG_PM */
 
 #ifdef CONFIG_X86_64
-/*
- * apic_is_clustered_box() -- Check if we can expect good TSC
- *
- * Thus far, the major user of this is IBM's Summit2 series:
- *
- * Clustered boxes may have unsynced TSC problems if they are
- * multi-chassis. Use available data to take a good guess.
- * If in doubt, go HPET.
- */
-__cpuinit int apic_is_clustered_box(void)
+
+static int __cpuinit apic_cluster_num(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
 	u16 *bios_cpu_apicid;
 	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
 
-	/*
-	 * there is not this kind of box with AMD CPU yet.
-	 * Some AMD box with quadcore cpu and 8 sockets apicid
-	 * will be [4, 0x23] or [8, 0x27] could be thought to
-	 * vsmp box still need checking...
-	 */
-	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
-		return 0;
-
 	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
@@ -2202,18 +2185,67 @@ __cpuinit int apic_is_clustered_box(void
 			++zeros;
 	}
 
-	/* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
-	 * not guaranteed to be synced between boards
-	 */
-	if (is_vsmp_box() && clusters > 1)
+	return clusters;
+}
+
+static int __cpuinitdata multi_checked;
+static int __cpuinitdata multi;
+
+static int __cpuinit set_multi(const struct dmi_system_id *d)
+{
+	if (multi)
+		return 0;
+	printk(KERN_INFO "APIC: %s detected, Multi Chassis\n", d->ident);
+	multi = 1;
+	return 0;
+}
+
+static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
+	{
+		.callback = set_multi,
+		.ident = "IBM System Summit2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Summit2"),
+		},
+	},
+	{}
+};
+
+static void __cpuinit dmi_check_multi(void)
+{
+	if (multi_checked)
+		return;
+
+	dmi_check_system(multi_dmi_table);
+	multi_checked = 1;
+}
+
+/*
+ * apic_is_clustered_box() -- Check if we can expect good TSC
+ *
+ * Thus far, the major user of this is IBM's Summit2 series:
+ * Clustered boxes may have unsynced TSC problems if they are
+ * multi-chassis.
+ * Use DMI to check them
+ */
+__cpuinit int apic_is_clustered_box(void)
+{
+	dmi_check_multi();
+	if (multi)
 		return 1;
 
+	if (!is_vsmp_box())
+		return 0;
+
 	/*
-	 * If clusters > 2, then should be multi-chassis.
-	 * May have to revisit this when multi-core + hyperthreaded CPUs come
-	 * out, but AFAIK this will work even for them.
+	 * ScaleMP vSMPowered boxes have one cluster per board and TSCs are
+	 * not guaranteed to be synced between boards
 	 */
-	return (clusters > 2);
+	if (apic_cluster_num() > 1)
+		return 1;
+
+	return 0;
 }
 #endif
 
