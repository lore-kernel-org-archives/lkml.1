Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbYCSUWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbYCSUWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbYCSTjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYCSTis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:48 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 69/79] [PATCH] get rid of smp_boot_cpus
Date: Wed, 19 Mar 2008 14:26:04 -0300
Message-Id: <1205947885365-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478813309-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This patch get rid of smp_boot_cpus(), since it does not
boot any cpu anymore. Its code is split in a way to make
it closer to x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 14db038..d153d84 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -172,21 +172,19 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	return 0;
 }
 
-/*
- * Cycle through the processors sending APIC IPIs to boot each.
- */
-static void __init smp_boot_cpus(unsigned int max_cpus)
+/* These are wrappers to interface to the new boot process.  Someone
+   who understands all this stuff should rewrite it properly. --RR 15/Jul/02 */
+void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
+ 	nmi_watchdog_default();
+ 	cpu_callin_map = cpumask_of_cpu(0);
+ 	mb();
+
 	/*
 	 * Setup boot CPU information
 	 */
 	smp_store_cpu_info(0); /* Final full version of the data */
-	printk(KERN_INFO "CPU%d: ", 0);
-	print_cpu_info(&cpu_data(0));
-
-	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
 	boot_cpu_logical_apicid = logical_smp_processor_id();
-
 	current_thread_info()->cpu = 0;
 
 	set_cpu_sibling_map(0);
@@ -197,25 +195,19 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 		return;
 	}
 
+	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
+
 	connect_bsp_APIC();
 	setup_local_APIC();
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
-
 	setup_portio_remap();
 
 	smpboot_setup_io_apic();
 
+	printk(KERN_INFO "CPU%d: ", 0);
+	print_cpu_info(&cpu_data(0));
 	setup_boot_clock();
 }
 
-/* These are wrappers to interface to the new boot process.  Someone
-   who understands all this stuff should rewrite it properly. --RR 15/Jul/02 */
-void __init native_smp_prepare_cpus(unsigned int max_cpus)
-{
-	nmi_watchdog_default();
-	cpu_callin_map = cpumask_of_cpu(0);
-	mb();
-	smp_boot_cpus(max_cpus);
-}
-- 
1.5.0.6

