Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZFWAmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZFWAmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbZFWAld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:41:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:35750 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbZFWAlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,272,1243839600"; 
   d="scan'208";a="157341054"
Message-ID: <4A4024BE.5090206@intel.com>
Date: Mon, 22 Jun 2009 17:41:34 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: [RFC v5][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt shutdown
 support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for graceful handling of kernel reboots after an Intel(R) TXT launch.

Without this patch, attempting to reboot or halt the system will cause the
TXT hardware to lock memory upon system restart because the secrets-in-memory
flag that was set on launch was never cleared.  This will in turn cause BIOS
to execute a TXT Authenticated Code Module (ACM) that will scrub all of memory
and then unlock it.  Depending on the amount of memory in the system and its type,
this may take some time.

This patch creates a 1:1 address mapping to the tboot module and then calls back
into tboot so that it may properly and securely clean up system state and clear
the secrets-in-memory flag.  When it has completed these steps, the tboot module
will reboot or halt the system.


 arch/x86/kernel/reboot.c |   14 ++++++++++++--
 init/main.c              |    3 +++
 2 files changed, 15 insertions(+), 2 deletions(-)

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Shane Wang <shane.wang@intel.com>

---

diff -uprN -X linus-2.6.git/Documentation/dontdiff linus-2.6.git/arch/x86/kernel/reboot.c linus-2.6.git-txt/arch/x86/kernel/reboot.c
--- linus-2.6.git/arch/x86/kernel/reboot.c	2009-06-19 13:32:12.000000000 -0700
+++ linus-2.6.git-txt/arch/x86/kernel/reboot.c	2009-06-19 18:37:11.000000000 -0700
@@ -24,6 +24,8 @@
 # include <asm/iommu.h>
 #endif
 
+#include <asm/tboot.h>
+
 /*
  * Power off function, if any
  */
@@ -460,6 +462,8 @@ static void native_machine_emergency_res
 	if (reboot_emergency)
 		emergency_vmx_disable_all();
 
+	tboot_shutdown(TB_SHUTDOWN_REBOOT);
+
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
@@ -525,11 +529,13 @@ static void native_machine_emergency_res
 
 void native_machine_shutdown(void)
 {
-	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
+#endif
+
+	/* Stop the cpus and apics */
+#ifdef CONFIG_SMP
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
@@ -586,6 +592,8 @@ static void native_machine_halt(void)
 	/* stop other cpus and apics */
 	machine_shutdown();
 
+	tboot_shutdown(TB_SHUTDOWN_HALT);
+
 	/* stop this cpu */
 	stop_this_cpu(NULL);
 }
@@ -597,6 +605,8 @@ static void native_machine_power_off(voi
 			machine_shutdown();
 		pm_power_off();
 	}
+	/* a fallback in case there is no PM info available */
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
 struct machine_ops machine_ops = {
diff -uprN -X linus-2.6.git/Documentation/dontdiff linus-2.6.git/init/main.c linus-2.6.git-txt/init/main.c
--- linus-2.6.git/init/main.c	2009-06-19 13:32:20.000000000 -0700
+++ linus-2.6.git-txt/init/main.c	2009-06-19 18:37:11.000000000 -0700
@@ -72,6 +72,7 @@
 #include <asm/io.h>
 #include <asm/bugs.h>
 #include <asm/setup.h>
+#include <asm/tboot.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
@@ -720,6 +721,8 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
+	tboot_create_trampoline();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }

