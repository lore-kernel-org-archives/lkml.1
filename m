Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0BRB7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:59:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:37357 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178Ab0BRB7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:59:45 -0500
Date: Thu, 18 Feb 2010 01:59:03 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org, tony.luck@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       tony.luck@intel.com
In-Reply-To: <1265793639-15071-34-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-34-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] smp: Use nr_cpus= to set nr_cpu_ids early
Message-ID: <tip-2b633e3fac5efada088b57d31e65401f22bcc18f@git.kernel.org>
Git-Commit-ID: 2b633e3fac5efada088b57d31e65401f22bcc18f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 01:59:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b633e3fac5efada088b57d31e65401f22bcc18f
Gitweb:     http://git.kernel.org/tip/2b633e3fac5efada088b57d31e65401f22bcc18f
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 10 Feb 2010 01:20:37 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 17:30:22 -0800

smp: Use nr_cpus= to set nr_cpu_ids early

On x86, before prefill_possible_map(), nr_cpu_ids will be NR_CPUS aka
CONFIG_NR_CPUS.

Add nr_cpus= to set nr_cpu_ids. so we can simulate cpus <=8 are installed on
normal config.

-v2: accordging to Christoph, acpi_numa_init should use nr_cpu_ids in stead of
     NR_CPUS.
-v3: add doc in kernel-parameters.txt according to Andrew.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1265793639-15071-34-git-send-email-yinghai@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/ia64/kernel/acpi.c             |    4 ++--
 arch/x86/kernel/smpboot.c           |    7 ++++---
 drivers/acpi/numa.c                 |    4 ++--
 init/main.c                         |   14 ++++++++++++++
 5 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..51bceb0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1772,6 +1772,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
 
+	nr_cpus=	[SMP] Maximum number of processors that	an SMP kernel
+			could support.  nr_cpus=n : n >= 1 limits the kernel to
+			supporting 'n' processors. Later in runtime you can not
+			use hotplug cpu feature to put more cpu back to online.
+			just like you compile the kernel NR_CPUS=n
+
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
 	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 40574ae..605a08b 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -881,8 +881,8 @@ __init void prefill_possible_map(void)
 
 	possible = available_cpus + additional_cpus;
 
-	if (possible > NR_CPUS)
-		possible = NR_CPUS;
+	if (possible > nr_cpu_ids)
+		possible = nr_cpu_ids;
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max((possible - available_cpus), 0));
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..eff2fe1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1213,11 +1213,12 @@ __init void prefill_possible_map(void)
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
 
-	if (possible > CONFIG_NR_CPUS) {
+	/* nr_cpu_ids could be reduced via nr_cpus= */
+	if (possible > nr_cpu_ids) {
 		printk(KERN_WARNING
 			"%d Processors exceeds NR_CPUS limit of %d\n",
-			possible, CONFIG_NR_CPUS);
-		possible = CONFIG_NR_CPUS;
+			possible, nr_cpu_ids);
+		possible = nr_cpu_ids;
 	}
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 7ad48df..b872546 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -279,9 +279,9 @@ int __init acpi_numa_init(void)
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				      acpi_parse_x2apic_affinity, NR_CPUS);
+				     acpi_parse_x2apic_affinity, nr_cpu_ids);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				      acpi_parse_processor_affinity, NR_CPUS);
+				     acpi_parse_processor_affinity, nr_cpu_ids);
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
diff --git a/init/main.c b/init/main.c
index 8451878..05b5283 100644
--- a/init/main.c
+++ b/init/main.c
@@ -149,6 +149,20 @@ static int __init nosmp(char *str)
 
 early_param("nosmp", nosmp);
 
+/* this is hard limit */
+static int __init nrcpus(char *str)
+{
+	int nr_cpus;
+
+	get_option(&str, &nr_cpus);
+	if (nr_cpus > 0 && nr_cpus < nr_cpu_ids)
+		nr_cpu_ids = nr_cpus;
+
+	return 0;
+}
+
+early_param("nr_cpus", nrcpus);
+
 static int __init maxcpus(char *str)
 {
 	get_option(&str, &setup_max_cpus);
