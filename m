Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbXKARDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbXKARDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 13:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXKARC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 13:02:57 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:65429 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbXKARC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 13:02:56 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 1 Nov 2007 18:02:06 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
cc: akpm@linux-foundation.org, gcosta@redhat.com, travis@sgi.com
Subject: [PATCH] x86: show cpuinfo only for online CPUs
Message-ID: <20071101170206.GA7820@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Nov 2007 17:02:06.0342 (UTC)
 FILETIME=[EE9D2A60:01C81CA8]
X-WSS-ID: 6B34D91B24S1084049-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies on current Linus' git with Glauber's recent cpuinfo fix
(http://marc.info/?l=linux-kernel&m=119392088227245) applied.


Regards,

Andreas

-- 
[PATCH] x86: show cpuinfo only for online CPUs

Fix regressions introduced with 92cb7612aee39642d109b8d935ad265e602c0563.

It can happen that cpuinfo is displayed for CPUs that are not online or
even worse for CPUs not present at all. As an example, following was
shown for a "second" CPU of a single core K8 variant:

    processor       : 0
    vendor_id       : unknown
    cpu family      : 0
    model           : 0
    model name      : unknown
    stepping        : 0
    cache size      : 0 KB
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 0
    wp              : yes
    flags           :
    bogomips        : 0.00
    clflush size    : 0
    cache_alignment : 0
    address sizes   : 0 bits physical, 0 bits virtual
    power management:

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/proc.c |   13 ++++---------
 arch/x86/kernel/setup_64.c |   15 ++++-----------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 066f8c6..13cfd85 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -85,14 +85,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		/* nothing */
 	};
 	struct cpuinfo_x86 *c = v;
-	int i, n = 0;
+	int i, n = c->cpu_index;
 	int fpu_exception;
 
-#ifdef CONFIG_SMP
-	if (!cpu_online(n))
-		return 0;
-	n = c->cpu_index;
-#endif
 	seq_printf(m, "processor\t: %d\n"
 		"vendor_id\t: %s\n"
 		"cpu family\t: %d\n"
@@ -177,14 +172,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_possible_map);
-	if ((*pos) < NR_CPUS && cpu_possible(*pos))
+		*pos = first_cpu(cpu_online_map);
+	if ((*pos) < NR_CPUS && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
 }
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_possible_map);
+	*pos = next_cpu(*pos, cpu_online_map);
 	return c_start(m, pos);
 }
 static void c_stop(struct seq_file *m, void *v)
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index ec59fcb..480230a 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -998,7 +998,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
-	int cpu = 0;
+	int cpu = c->cpu_index;
 
 	/* 
 	 * These flag bits must match the definitions in <asm/cpufeature.h>.
@@ -1075,13 +1075,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		/* nothing */
 	};
 
-
-#ifdef CONFIG_SMP
-	if (!cpu_online(c->cpu_index))
-		return 0;
-	cpu = c->cpu_index;
-#endif
-
 	seq_printf(m,"processor\t: %u\n"
 		     "vendor_id\t: %s\n"
 		     "cpu family\t: %d\n"
@@ -1170,15 +1163,15 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_possible_map);
-	if ((*pos) < NR_CPUS && cpu_possible(*pos))
+		*pos = first_cpu(cpu_online_map);
+	if ((*pos) < NR_CPUS && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_possible_map);
+	*pos = next_cpu(*pos, cpu_online_map);
 	return c_start(m, pos);
 }
 
-- 
1.5.3.4





