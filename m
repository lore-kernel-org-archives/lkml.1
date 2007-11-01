Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXKAScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXKAScr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXKAScj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:32:39 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3519 "EHLO
	outbound5-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbXKASci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:32:38 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 1 Nov 2007 19:32:17 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
cc: akpm@linux-foundation.org, gcosta@redhat.com, travis@sgi.com
Subject: [PATCH v2] x86: show cpuinfo only for online CPUs
Message-ID: <20071101183217.GC5568@alberich.amd.com>
References: <20071101170206.GA7820@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20071101170206.GA7820@alberich.amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Nov 2007 18:32:17.0644 (UTC)
 FILETIME=[880052C0:01C81CB5]
X-WSS-ID: 6B34C43E24S1094745-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New version of the fix.
Now it works also in the non-SMP case.
Tested on x86_64.

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
 arch/x86/kernel/cpu/proc.c |    8 +++-----
 arch/x86/kernel/setup_64.c |    8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 066f8c6..3900e46 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -89,8 +89,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	int fpu_exception;
 
 #ifdef CONFIG_SMP
-	if (!cpu_online(n))
-		return 0;
 	n = c->cpu_index;
 #endif
 	seq_printf(m, "processor\t: %d\n"
@@ -177,14 +175,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
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
index ec59fcb..30d94d1 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1077,8 +1077,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 
 #ifdef CONFIG_SMP
-	if (!cpu_online(c->cpu_index))
-		return 0;
 	cpu = c->cpu_index;
 #endif
 
@@ -1170,15 +1168,15 @@ static int show_cpuinfo(struct seq_file *m, void *v)
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




