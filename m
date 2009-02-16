Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZBPICV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZBPICV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZBPICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:02:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:41593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbZBPICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:02:11 -0500
Message-ID: <49991D32.6070409@kernel.org>
Date: Mon, 16 Feb 2009 00:00:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make APIC_init_uniprocessor() more like smp_prepare_cpus()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

1. move localise_nmi_watchdgoe() later
2. change setup_boot_APIC_clock to setup_boot_clock for 64bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -1656,32 +1656,28 @@ int __init APIC_init_uniprocessor(void)
 #ifdef CONFIG_X86_IO_APIC
 	/*
 	 * Now enable IO-APICs, actually call clear_IO_APIC
-	 * We need clear_IO_APIC before enabling vector on BP
+	 * We need clear_IO_APIC before enabling error vector
 	 */
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
-
-	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
-		localise_nmi_watchdog();
-#else
-	localise_nmi_watchdog();
 #endif
+
 	end_local_APIC_setup();
 
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
-# ifdef CONFIG_X86_64
-	else
+	else {
 		nr_ioapics = 0;
-# endif
+		localise_nmi_watchdog();
+	}
+#else
+	localise_nmi_watchdog();
 #endif
 
+	setup_boot_clock();
 #ifdef CONFIG_X86_64
-	setup_boot_APIC_clock();
 	check_nmi_watchdog();
-#else
-	setup_boot_clock();
 #endif
 
 	return 0;
