Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZGACcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZGACcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZGACbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:31:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:29001 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbZGACbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,320,1243839600"; 
   d="scan'208";a="704014439"
Message-ID: <4A4ACA6B.4050705@intel.com>
Date: Tue, 30 Jun 2009 19:31:07 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: [RFC v6][PATCH 3/4] intel_txt: Intel(R) TXT Sx shutdown support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for graceful handling of sleep states (S3/S4/S5) after an Intel(R) TXT launch.

Without this patch, attempting to place the system in one of the ACPI sleep
states (S3/S4/S5) will cause the TXT hardware to treat this as an attack and
will cause a system reset, with memory locked.  Not only may the subsequent
memory scrub take some time, but the platform will be unable to enter the
requested power state.

This patch calls back into the tboot so that it may properly and securely clean
up system state and clear the secrets-in-memory flag, after which it will place
the system into the requested sleep state using ACPI information passed by the kernel.


 arch/x86/kernel/smpboot.c     |    2 ++
 drivers/acpi/acpica/hwsleep.c |    3 +++
 kernel/cpu.c                  |    7 ++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Shane Wang <shane.wang@intel.com>

---

diff -uprN -X linus-2.6.git-0629/Documentation/dontdiff linus-2.6.git-0629/arch/x86/kernel/smpboot.c linus-2.6.git-0629-txt/arch/x86/kernel/smpboot.c
--- linus-2.6.git-0629/arch/x86/kernel/smpboot.c	2009-06-29 21:57:17.000000000 -0700
+++ linus-2.6.git-0629-txt/arch/x86/kernel/smpboot.c	2009-06-30 16:09:10.000000000 -0700
@@ -62,6 +62,7 @@
 #include <asm/vmi.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
+#include <asm/tboot.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
@@ -1317,6 +1318,7 @@ void play_dead_common(void)
 void native_play_dead(void)
 {
 	play_dead_common();
+	tboot_shutdown(TB_SHUTDOWN_WFS);
 	wbinvd_halt();
 }
 
diff -uprN -X linus-2.6.git-0629/Documentation/dontdiff linus-2.6.git-0629/drivers/acpi/acpica/hwsleep.c linus-2.6.git-0629-txt/drivers/acpi/acpica/hwsleep.c
--- linus-2.6.git-0629/drivers/acpi/acpica/hwsleep.c	2009-06-29 21:57:18.000000000 -0700
+++ linus-2.6.git-0629-txt/drivers/acpi/acpica/hwsleep.c	2009-06-30 16:07:51.000000000 -0700
@@ -45,6 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "actables.h"
+#include <asm/tboot.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
@@ -342,6 +343,8 @@ acpi_status asmlinkage acpi_enter_sleep_
 
 	ACPI_FLUSH_CPU_CACHE();
 
+	tboot_sleep(sleep_state, pm1a_control, pm1b_control);
+
 	/* Write #2: Write both SLP_TYP + SLP_EN */
 
 	status = acpi_hw_write_pm1_control(pm1a_control, pm1b_control);
diff -uprN -X linus-2.6.git-0629/Documentation/dontdiff linus-2.6.git-0629/kernel/cpu.c linus-2.6.git-0629-txt/kernel/cpu.c
--- linus-2.6.git-0629/kernel/cpu.c	2009-06-29 21:57:26.000000000 -0700
+++ linus-2.6.git-0629-txt/kernel/cpu.c	2009-06-30 16:01:58.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <asm/tboot.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -376,7 +377,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error;
+	int cpu, first_cpu, error, num_cpus = 0;
 
 	error = stop_machine_create();
 	if (error)
@@ -391,6 +392,7 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
+		num_cpus++;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpumask_set_cpu(cpu, frozen_cpus);
@@ -401,6 +403,9 @@ int disable_nonboot_cpus(void)
 			break;
 		}
 	}
+	/* ensure all CPUs have gone into wait-for-SIPI */
+	error |= tboot_wait_for_aps(num_cpus);
+
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
 		/* Make sure the CPUs won't be enabled by someone else */

