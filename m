Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbYFIOVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbYFIOVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbYFIOSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760400AbYFIOSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:53 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
Date: Mon,  9 Jun 2008 11:16:54 -0300
Message-Id: <1213021018-14159-12-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-11-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do it, instead of keeping in io_apic_32.c. This is the way x86_64 already does.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_32.c    |    6 +-----
 arch/x86/kernel/io_apic_32.c |    2 +-
 arch/x86/kernel/smpboot.c    |    3 ++-
 include/asm-x86/hw_irq.h     |    3 ---
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index fa8cf79..a06442a 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1277,11 +1277,7 @@ int __init APIC_init_uniprocessor(void)
 #endif
 		localise_nmi_watchdog();
 	end_local_APIC_setup();
-#ifdef CONFIG_X86_IO_APIC
-	if (smp_found_config)
-		if (!skip_ioapic_setup && nr_ioapics)
-			setup_IO_APIC();
-#endif
+
 	setup_boot_clock();
 
 	return 0;
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 7fc071f..cb79ce3 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1606,7 +1606,7 @@ void /*__init*/ print_PIC(void)
 
 #endif  /*  0  */
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c4bb997..49d2900 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1179,13 +1179,14 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	setup_local_APIC();
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_IO_APIC
 	/*
 	 * Enable IO APIC before setting up error vector
 	 */
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
 #endif
+
 	end_local_APIC_setup();
 
 	map_cpu_to_logical_apicid();
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 18f067c..31b56cd 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -66,10 +66,7 @@ extern void disable_IO_APIC(void);
 extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
 extern void setup_ioapic_dest(void);
-
-#ifdef CONFIG_X86_64
 extern void enable_IO_APIC(void);
-#endif
 
 /* IPI functions */
 extern void send_IPI_self(int vector);
-- 
1.5.4.5

