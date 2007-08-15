Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXHOMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXHOMwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbXHOMvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:51:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbXHOMvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:51:07 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/25][V3] add native_apic read and write functions, as well as boot clocks ones
Date: Wed, 15 Aug 2007 09:49:26 -0300
Message-Id: <11871822421713-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11871822342754-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <11871822244170-git-send-email-gcosta@redhat.com> <11871822342754-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Time for the apic handling functions to get their native counterparts.
Also, put the native hook for the boot clocks functions in the apic.h header

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/apic.c    |    2 +-
 arch/x86_64/kernel/smpboot.c |    8 +++++++-
 include/asm-x86_64/apic.h    |   13 +++++++++++--
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 900ff38..2d233ef 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -1193,7 +1193,7 @@ int __init APIC_init_uniprocessor (void)
 		setup_IO_APIC();
 	else
 		nr_ioapics = 0;
-	setup_boot_APIC_clock();
+	setup_boot_clock();
 	check_nmi_watchdog();
 	return 0;
 }
diff --git a/arch/x86_64/kernel/smpboot.c b/arch/x86_64/kernel/smpboot.c
index f99ced6..12d653d 100644
--- a/arch/x86_64/kernel/smpboot.c
+++ b/arch/x86_64/kernel/smpboot.c
@@ -338,7 +338,7 @@ void __cpuinit start_secondary(void)
 	check_tsc_sync_target();
 
 	Dprintk("cpu %d: setting up apic clock\n", smp_processor_id()); 	
-	setup_secondary_APIC_clock();
+	setup_secondary_clock();
 
 	Dprintk("cpu %d: enabling apic timer\n", smp_processor_id());
 
@@ -468,6 +468,12 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	num_starts = 2;
 
 	/*
+	 * Paravirt wants a startup IPI hook here to set up the
+	 * target processor state.
+	 */
+	startup_ipi_hook(phys_apicid, (unsigned long) start_rip,
+		         (unsigned long) init_rsp);
+	/*
 	 * Run STARTUP IPI loop.
 	 */
 	Dprintk("#startup loops: %d.\n", num_starts);
diff --git a/include/asm-x86_64/apic.h b/include/asm-x86_64/apic.h
index 85125ef..de17908 100644
--- a/include/asm-x86_64/apic.h
+++ b/include/asm-x86_64/apic.h
@@ -38,16 +38,25 @@ struct pt_regs;
  * Basic functions accessing APICs.
  */
 
-static __inline void apic_write(unsigned long reg, unsigned int v)
+static __inline void native_apic_write(unsigned long reg, unsigned int v)
 {
 	*((volatile unsigned int *)(APIC_BASE+reg)) = v;
 }
 
-static __inline unsigned int apic_read(unsigned long reg)
+static __inline unsigned int native_apic_read(unsigned long reg)
 {
 	return *((volatile unsigned int *)(APIC_BASE+reg));
 }
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define apic_write(reg, v) native_apic_write(reg, v)
+#define apic_read(reg)  native_apic_read(reg)
+#define setup_boot_clock(void)	setup_boot_APIC_clock(void)
+#define setup_secondary_clock(void) setup_secondary_APIC_clock(void)
+#endif
+
 extern void apic_wait_icr_idle(void);
 extern unsigned int safe_apic_wait_icr_idle(void);
 
-- 
1.4.4.2

