Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbXGSKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbXGSKF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbXGSJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:23 -0400
Received: from mail.suse.de ([195.135.220.2]:35360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbXGSJzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:11 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: B.Steinbrink@gmx.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/58] x86: Always probe the NMI watchdog
Message-Id: <20070719095505.4430614E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: [** iso-8859-1 charset **] BjörnSteinbrink <B.Steinbrink@gmx.de>

The performance counter allocator relies on the nmi watchdog being
probed, so we have to do that even if the watchdog is not enabled.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/perfctr-watchdog.c |   11 +++++------
 arch/i386/kernel/nmi.c                  |    3 +++
 arch/x86_64/kernel/nmi.c                |    3 +++
 include/asm-i386/nmi.h                  |    1 +
 include/asm-x86_64/nmi.h                |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

Index: linux/arch/i386/kernel/cpu/perfctr-watchdog.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ linux/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -603,7 +603,7 @@ static struct wd_ops intel_arch_wd_ops =
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
 };
 
-static void probe_nmi_watchdog(void)
+void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
@@ -641,17 +641,16 @@ static void probe_nmi_watchdog(void)
 
 int lapic_watchdog_init(unsigned nmi_hz)
 {
-	if (!wd_ops) {
-		probe_nmi_watchdog();
-		if (!wd_ops)
-			return -1;
+	if (!wd_ops)
+		return -1;
 
+	/* hack to make sure that we only try to reserver the perfctrs once */
+	if (smp_processor_id() == 0)
 		if (!wd_ops->reserve()) {
 			printk(KERN_ERR
 				"NMI watchdog: cannot reserve perfctrs\n");
 			return -1;
 		}
-	}
 
 	if (!(wd_ops->setup(nmi_hz))) {
 		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -248,6 +248,9 @@ void setup_apic_nmi_watchdog (void *unus
 	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
 		return;
 
+	/* always probe the watchdog, the perfctr allocator requires that */
+	probe_nmi_watchdog();
+
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		__get_cpu_var(wd_enabled) = 1; /* enable it before to avoid race with handler */
Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -255,6 +255,9 @@ void setup_apic_nmi_watchdog(void *unuse
 	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
 		return;
 
+	/* always probe the watchdog, the perfctr allocator requires that */
+	probe_nmi_watchdog();
+
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		__get_cpu_var(wd_enabled) = 1;
Index: linux/include/asm-i386/nmi.h
===================================================================
--- linux.orig/include/asm-i386/nmi.h
+++ linux/include/asm-i386/nmi.h
@@ -18,6 +18,7 @@
 int do_nmi_callback(struct pt_regs *regs, int cpu);
 
 extern int nmi_watchdog_enabled;
+extern void probe_nmi_watchdog(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
Index: linux/include/asm-x86_64/nmi.h
===================================================================
--- linux.orig/include/asm-x86_64/nmi.h
+++ linux/include/asm-x86_64/nmi.h
@@ -45,6 +45,7 @@ extern int panic_on_timeout;
 extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
+extern void probe_nmi_watchdog(void);
 extern int check_nmi_watchdog(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
