Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZG1RUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZG1RUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbZG1RSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:49 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36274 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZG1RSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:18 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DP-04-A2M-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 13/26] x86/oprofile: Implement multiplexing setup/shutdown functions
Date: Tue, 28 Jul 2009 19:07:13 +0200
Message-ID: <1248800846-25422-14-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:49.0337 (UTC) FILETIME=[54FE0890:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements nmi_setup_mux() and nmi_shutdown_mux() functions
to setup/shutdown multiplexing. Multiplexing code in nmi_int.c is now
much more separated.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   76 ++++++++++++++++++++++--------------------
 1 files changed, 40 insertions(+), 36 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 02b57b8..674fa37 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -106,9 +106,35 @@ inline int op_x86_phys_to_virt(int phys)
 	return __get_cpu_var(switch_index) + phys;
 }
 
+static void nmi_shutdown_mux(void)
+{
+	int i;
+	for_each_possible_cpu(i) {
+		kfree(per_cpu(cpu_msrs, i).multiplex);
+		per_cpu(cpu_msrs, i).multiplex = NULL;
+		per_cpu(switch_index, i) = 0;
+	}
+}
+
+static int nmi_setup_mux(void)
+{
+	size_t multiplex_size =
+		sizeof(struct op_msr) * model->num_virt_counters;
+	int i;
+	for_each_possible_cpu(i) {
+		per_cpu(cpu_msrs, i).multiplex =
+			kmalloc(multiplex_size, GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).multiplex)
+			return 0;
+	}
+	return 1;
+}
+
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
+static inline void nmi_shutdown_mux(void) { }
+static inline int nmi_setup_mux(void) { return 1; }
 
 #endif
 
@@ -120,51 +146,27 @@ static void free_msrs(void)
 		per_cpu(cpu_msrs, i).counters = NULL;
 		kfree(per_cpu(cpu_msrs, i).controls);
 		per_cpu(cpu_msrs, i).controls = NULL;
-
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-		kfree(per_cpu(cpu_msrs, i).multiplex);
-		per_cpu(cpu_msrs, i).multiplex = NULL;
-#endif
 	}
 }
 
 static int allocate_msrs(void)
 {
-	int success = 1;
 	size_t controls_size = sizeof(struct op_msr) * model->num_controls;
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	size_t multiplex_size = sizeof(struct op_msr) * model->num_virt_counters;
-#endif
 
 	int i;
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
-								GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).counters) {
-			success = 0;
-			break;
-		}
+							GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).counters)
+			return 0;
 		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
-								GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).controls) {
-			success = 0;
-			break;
-		}
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-		per_cpu(cpu_msrs, i).multiplex =
-				kmalloc(multiplex_size, GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).multiplex) {
-			success = 0;
-			break;
-		}
-#endif
+							GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).controls)
+			return 0;
 	}
 
-	if (!success)
-		free_msrs();
-
-	return success;
+	return 1;
 }
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
@@ -218,11 +220,15 @@ static int nmi_setup(void)
 	int cpu;
 
 	if (!allocate_msrs())
-		return -ENOMEM;
+		err = -ENOMEM;
+	else if (!nmi_setup_mux())
+		err = -ENOMEM;
+	else
+		err = register_die_notifier(&profile_exceptions_nb);
 
-	err = register_die_notifier(&profile_exceptions_nb);
 	if (err) {
 		free_msrs();
+		nmi_shutdown_mux();
 		return err;
 	}
 
@@ -314,9 +320,6 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	per_cpu(switch_index, cpu) = 0;
-#endif
 }
 
 static void nmi_shutdown(void)
@@ -326,6 +329,7 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	nmi_shutdown_mux();
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
-- 
1.6.3.3


