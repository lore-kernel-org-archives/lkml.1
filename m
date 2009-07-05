Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZGEQUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZGEQUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZGEQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:20:42 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:56837 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZGEQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CpBoXERCqL5sTbWHkkuIslyOKndzENPMeRwm6No0KRniW3D9SDy+HJKBX66HMKY2gM
         4UAbzwVHWhAH6uVzrFdx0pYl0wQfe94axEZ4psFEewrbgjCn6SpX+/MOUpG7Vq1IEtNI
         mJBvFruOUh2Ixxdd9qSCkOu2BTAabHeTvtwUM=
Date: Sun, 5 Jul 2009 20:20:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC -tip] x86,apic -- reduce disable_apic usage
Message-ID: <20090705162044.GC4791@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an attempt to bring more consistency for apic
presence check. I hope I covered all the code flows.
Though it's RFC. Please review and test if possible.

	-- Cyrill
---
Instead of messing with (cpu_has_apic|disable_apic)
to check if we have apic functional, better to distinguish
them by logical kind. cpu_has_apic -- to check if we may
use apic functionality, disable_apic -- to note that
apic was disabled via command line.

Other interesting (and a side one) issue I guess is that
X86_FEATURE_APIC feature bit is always cleared if apic
disabled via command line but not the reverse.

Eventually this allow us to save a few lines of code.

Also:

1) No need to clear bit twice in APIC_init_uniprocessor.
   cpu_has_apic check for boot_cpu_data bit anyway.
2) Don't check for disable_apic in print_all_ICs. It's
   already set. Always.
3) Don't set disable_apic if there is no MPS support built in
   with acpi enabled. Even having SMP built kernel we're
   protected by acpi_lapic check in smp_sanity_check.
   At least we should be.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c    |    3 +--
 arch/x86/kernel/apic/io_apic.c |    6 +++---
 arch/x86/kernel/setup.c        |    6 +-----
 3 files changed, 5 insertions(+), 10 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -1173,7 +1173,7 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value;
 	int i, j;
 
-	if (disable_apic) {
+	if (!cpu_has_apic) {
 		arch_disable_smp_support();
 		return;
 	}
@@ -1651,7 +1651,6 @@ int __init APIC_init_uniprocessor(void)
 	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
 		return -1;
 	}
 #endif
Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -1884,7 +1884,7 @@ __apicdebuginit(int) print_all_ICs(void)
 	print_PIC();
 
 	/* don't print out if apic is not there */
-	if (!cpu_has_apic || disable_apic)
+	if (!cpu_has_apic)
 		return 0;
 
 	print_all_local_APICs();
@@ -3261,7 +3261,7 @@ static int msi_compose_msg(struct pci_de
 	int err;
 	unsigned dest;
 
-	if (disable_apic)
+	if (!cpu_has_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
@@ -3714,7 +3714,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 	struct irq_cfg *cfg;
 	int err;
 
-	if (disable_apic)
+	if (!cpu_has_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
Index: linux-2.6.git/arch/x86/kernel/setup.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup.c
+++ linux-2.6.git/arch/x86/kernel/setup.c
@@ -795,12 +795,8 @@ void __init setup_arch(char **cmdline_p)
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
 
-	if (acpi_mps_check()) {
-#ifdef CONFIG_X86_LOCAL_APIC
-		disable_apic = 1;
-#endif
+	if (acpi_mps_check())
 		setup_clear_cpu_cap(X86_FEATURE_APIC);
-	}
 
 #ifdef CONFIG_PCI
 	if (pci_early_dump_regs)
