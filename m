Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbXHJWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbXHJWAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXHJWAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:00:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXHJWAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:00:02 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/25 -v2] add native_apic read and write functions, as well as boot clocks ones
Date: Fri, 10 Aug 2007 16:12:18 -0300
Message-Id: <11867731882768-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867731831138-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com>
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

