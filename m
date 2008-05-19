Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbYESPre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbYESPre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759912AbYESPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:46:59 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41273 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759803AbYESPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:46:58 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: move smp_found_config
Date: Mon, 19 May 2008 19:47:03 +0400
Message-ID: <20080519154703.15071.4948.stgit@thinkpad>
In-Reply-To: <20080519154656.15071.96979.stgit@thinkpad>
References: <20080519154656.15071.96979.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/apic_32.c           |    3 +++
 arch/x86/kernel/apic_64.c           |    3 +++
 arch/x86/kernel/mpparse.c           |    8 ++++----
 arch/x86/mach-visws/mpparse.c       |    5 ++---
 arch/x86/mach-voyager/voyager_smp.c |    5 -----
 5 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index c0dd696..4ed4a2b 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -79,6 +79,9 @@ int apic_verbosity;
 
 int pic_mode;
 
+/* Have we found an MP table */
+int smp_found_config;
+
 static unsigned int calibration_result;
 
 static int lapic_next_event(unsigned long delta,
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 30f3f6a..10fde03 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -56,6 +56,9 @@ EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
  */
 int apic_verbosity;
 
+/* Have we found an MP table */
+int smp_found_config;
+
 static struct resource lapic_resource = {
 	.name = "Local APIC",
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b72c046..d67cd76 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -32,9 +32,6 @@
 #include <mach_mpparse.h>
 #endif
 
-/* Have we found an MP table */
-int smp_found_config;
-
 /*
  * Various Linux-internal data structures created from the
  * MP-table.
@@ -639,7 +636,9 @@ static void __init __get_smp_config(unsigned early)
 		 * override the defaults.
 		 */
 		if (!smp_read_mpc(phys_to_virt(mpf->mpf_physptr), early)) {
+#ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
+#endif
 			printk(KERN_ERR
 			       "BIOS bug, MP table errors detected!...\n");
 			printk(KERN_ERR "... disabling SMP support. "
@@ -706,8 +705,9 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 		    !mpf_checksum((unsigned char *)bp, 16) &&
 		    ((mpf->mpf_specification == 1)
 		     || (mpf->mpf_specification == 4))) {
-
+#ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 1;
+#endif
 			mpf_found = mpf;
 #ifdef CONFIG_X86_32
 			printk(KERN_INFO "found SMP MP-table at [%p] %08lx\n",
diff --git a/arch/x86/mach-visws/mpparse.c b/arch/x86/mach-visws/mpparse.c
index b7d063e..a2fb78c 100644
--- a/arch/x86/mach-visws/mpparse.c
+++ b/arch/x86/mach-visws/mpparse.c
@@ -8,9 +8,6 @@
 #include "cobalt.h"
 #include "mach_apic.h"
 
-/* Have we found an MP table */
-int smp_found_config;
-
 extern unsigned int __cpuinitdata maxcpus;
 
 /*
@@ -74,7 +71,9 @@ void __init find_smp_config(void)
 	if (ncpus > maxcpus)
 		ncpus = maxcpus;
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	smp_found_config = 1;
+#endif
 	while (ncpus--)
 		MP_processor_info(mp++);
 
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 8acbf0c..6d33541 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -59,11 +59,6 @@ __u32 voyager_quad_processors = 0;
  * activity count.  Finally exported by i386_ksyms.c */
 static int voyager_extended_cpus = 1;
 
-/* Have we found an SMP box - used by time.c to do the profiling
-   interrupt for timeslicing; do not set to 1 until the per CPU timer
-   interrupt is active */
-int smp_found_config = 0;
-
 /* Used for the invalidate map that's also checked in the spinlock */
 static volatile unsigned long smp_invalidate_needed;
 

