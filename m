Return-Path: <linux-kernel-owner+w=401wt.eu-S1765938AbYCSUSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765938AbYCSUSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYCSTjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201AbYCSTi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:56 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 67/79] [PATCH] merge native_smp_cpus_done
Date: Wed, 19 Mar 2008 14:26:02 -0300
Message-Id: <12059478771019-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478732976-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

They look similar enough, and are merged. Only difference
(zap_low_mapping for i386) is inside ifdef

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   21 ++++++++++++++++++++-
 arch/x86/kernel/smpboot_32.c |   21 ---------------------
 arch/x86/kernel/smpboot_64.c |   18 ------------------
 3 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b214d8d..26118b4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -880,7 +880,6 @@ do_rest:
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-
 	/*
 	 * Starting actual IPI sequence...
 	 */
@@ -1017,6 +1016,26 @@ void __init native_smp_prepare_boot_cpu(void)
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }
 
+void __init native_smp_cpus_done(unsigned int max_cpus)
+{
+	/*
+	 * Cleanup possible dangling ends...
+	 */
+	smpboot_restore_warm_reset_vector();
+
+	Dprintk("Boot done.\n");
+
+	impress_friends();
+	smp_checks();
+#ifdef CONFIG_X86_IO_APIC
+	setup_ioapic_dest();
+#endif
+	check_nmi_watchdog();
+#ifdef CONFIG_X86_32
+	zap_low_mappings();
+#endif
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
 {
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 5d27b1d..75fb506 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -215,24 +215,3 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	mb();
 	smp_boot_cpus(max_cpus);
 }
-
-extern void impress_friends(void);
-extern void smp_checks(void);
-
-void __init native_smp_cpus_done(unsigned int max_cpus)
-{
-	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
-
-	Dprintk("Boot done.\n");
-
-	impress_friends();
-	smp_checks();
-#ifdef CONFIG_X86_IO_APIC
-	setup_ioapic_dest();
-#endif
-	check_nmi_watchdog();
-	zap_low_mappings();
-}
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index f77299b..f4363a3 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -212,21 +212,3 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 }
-
-extern void impress_friends(void);
-extern void smp_checks(void);
-
-/*
- * Finish the SMP boot.
- */
-void __init native_smp_cpus_done(unsigned int max_cpus)
-{
-	smpboot_restore_warm_reset_vector();
-
-	Dprintk("Boot done.\n");
-
-	impress_friends();
-	smp_checks();
-	setup_ioapic_dest();
-	check_nmi_watchdog();
-}
-- 
1.5.0.6

