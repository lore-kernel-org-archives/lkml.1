Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0APDKK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756Ab0APDKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:10:00 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33981 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab0APDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:07:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 33/37] use nr_cpus= to set nr_cpu_ids early
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on x86, before prefill_possible_map(), nr_cpu_ids will be NR_CPUS aka CONFIG_NR_CPUS

add nr_cpus= to set nr_cpu_ids. so we can simulate cpus <=8 are installed on
normal config.

-v2: accordging to Christoph, acpi_numa_init should use nr_cpu_ids in stead of
     NR_CPUS.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/ia64/kernel/acpi.c   |    4 ++--
 arch/x86/kernel/smpboot.c |    7 ++++---
 drivers/acpi/numa.c       |    4 ++--
 init/main.c               |   14 ++++++++++++++
 4 files changed, 22 insertions(+), 7 deletions(-)

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
-- 
1.6.4.2

