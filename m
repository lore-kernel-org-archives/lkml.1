Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0BITgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:36:53 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54637 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 33/35] x86: according to nr_cpu_ids to decide if need to leave
 logical flat
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should use nr_cpu_ids instead of num_processor, in case we have hotplug cpus.

if current only have 8 cpus is up, but if we will have more cpus that
will be hot added later, we should use physical flat at first.

nr_cpu_ids is the total cpus that could be supported.

-v2: per linus, chenage default_setup_apic_routing to _init, and call it for uni_processor

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c     |    2 --
 arch/x86/kernel/apic/probe_32.c |   20 ++++++++++++++++++--
 arch/x86/kernel/apic/probe_64.c |    6 +++++-
 arch/x86/kernel/smpboot.c       |    2 --
 4 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a85f216..e97f18b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1641,9 +1641,7 @@ int __init APIC_init_uniprocessor(void)
 #endif
 
 	enable_IR_x2apic();
-#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
-#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 1a6559f..d657558 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -52,7 +52,7 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-void default_setup_apic_routing(void)
+static void local_default_setup_apic_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
 	printk(KERN_INFO
@@ -103,7 +103,7 @@ struct apic apic_default = {
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
-	.setup_apic_routing		= default_setup_apic_routing,
+	.setup_apic_routing		= local_default_setup_apic_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
@@ -212,6 +212,22 @@ void __init generic_bigsmp_probe(void)
 #endif
 }
 
+void __init default_setup_apic_routing(void)
+{
+#ifdef CONFIG_X86_BIGSMP
+	/*
+	 * make sure we go to bigsmp according to real nr_cpu_ids
+	 */
+	if (!cmdline_apic && apic == &apic_default) {
+		if (nr_cpu_ids > 8) {
+			apic = &apic_bigsmp;
+			printk(KERN_INFO "Overriding APIC driver with %s\n",
+			       apic->name);
+		}
+	}
+#endif
+}
+
 void __init generic_apic_probe(void)
 {
 	if (!cmdline_apic) {
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 450fe20..7dce6f9 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -67,7 +67,11 @@ void __init default_setup_apic_routing(void)
 	}
 #endif
 
-	if (apic == &apic_flat && num_processors > 8)
+	/*
+	 * not just num_processors, we could have hotplug cpus plugged
+	 * in later
+	 */
+	if (apic == &apic_flat && nr_cpu_ids > 8)
 			apic = &apic_physflat;
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6c69693..da99eef 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1087,9 +1087,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	set_cpu_sibling_map(0);
 
 	enable_IR_x2apic();
-#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
-#endif
 
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
-- 
1.6.4.2

