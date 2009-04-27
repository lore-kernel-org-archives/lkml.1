Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZD0RCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZD0RCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZD0RCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:02:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:33835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844AbZD0RCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:02:24 -0400
Date: Mon, 27 Apr 2009 17:00:48 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kiran@scalex86.org, yinghai@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, kiran@scalex86.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49F5532A.5000802@kernel.org>
References: <49F5532A.5000802@kernel.org>
Subject: [tip:x86/apic] x86: Use dmi check in apic_is_clustered() on 64-bit to mark the TSC unstable
Message-ID: <tip-e0e42142bab96404de535cceb85d6533d5ad7942@git.kernel.org>
Git-Commit-ID: e0e42142bab96404de535cceb85d6533d5ad7942
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 27 Apr 2009 17:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0e42142bab96404de535cceb85d6533d5ad7942
Gitweb:     http://git.kernel.org/tip/e0e42142bab96404de535cceb85d6533d5ad7942
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 26 Apr 2009 23:39:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Apr 2009 09:23:52 +0200

x86: Use dmi check in apic_is_clustered() on 64-bit to mark the TSC unstable

We will have systems with 2 and more sockets 8cores/2thread,
but we treat them as multi chassis - while they could have
a stable TSC domain.

Use DMI check instead.

[ Impact: do not turn possibly stable TSCs off incorrectly ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
LKML-Reference: <49F5532A.5000802@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |   86 +++++++++++++++++++++++++++++-------------
 1 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 1386dbe..28f747d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2138,31 +2138,14 @@ static void apic_pm_activate(void) { }
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
 
@@ -2198,18 +2181,67 @@ __cpuinit int apic_is_clustered_box(void)
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
 
