Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910Ab0ALMKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0ALMKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 07:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224Ab0ALMKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 07:10:30 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48323 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab0ALMK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 07:10:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 12 Jan 2010 04:09:02 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on x86, before prefill_possible_map(), nr_cpu_ids will be NR_CPUS aka CONFIG_NR_CPUS

add nr_cpus= to set nr_cpu_ids. so we can simulate cpus <=8 on normal config.
instead of change NR_CPUS directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/ia64/kernel/acpi.c   |    4 ++--
 arch/x86/kernel/smpboot.c |    7 ++++---
 init/main.c               |   14 ++++++++++++++
 3 files changed, 20 insertions(+), 5 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
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
Index: linux-2.6/arch/ia64/kernel/acpi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6/arch/ia64/kernel/acpi.c
@@ -883,8 +883,8 @@ __init void prefill_possible_map(void)
 
 	possible = available_cpus + additional_cpus;
 
-	if (possible > NR_CPUS)
-		possible = NR_CPUS;
+	if (possible > nr_cpu_ids)
+		possible = nr_cpu_ids;
 
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max((possible - available_cpus), 0));
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
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
