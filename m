Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYD2Bdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYD2Bdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYD2Bd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:33:29 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:46954 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYD2Bd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:33:28 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48167AE4.8050208@avtrex.com>
Date: Mon, 28 Apr 2008 18:33:24 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] Probe watch registers and report configuration.
References: <48167832.3090103@avtrex.com>
In-Reply-To: <48167832.3090103@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 01:33:24.0840 (UTC) FILETIME=[045DB680:01C8A999]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe watch registers and report configuration.

Probe for watch register characteristics, and report them in /proc/cpuinfo.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/cpu-probe.c |    4 ++++
 arch/mips/kernel/proc.c      |   10 ++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 89c3304..1563049 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -21,6 +21,7 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/system.h>
+#include <asm/watch.h>
 
 /*
  * Not all of the MIPS CPUs have the "wait" instruction available. Moreover,
@@ -678,6 +679,9 @@ static void __cpuinit decode_configs(struct cpuinfo_mips *c)
 static inline void cpu_probe_mips(struct cpuinfo_mips *c)
 {
 	decode_configs(c);
+#if defined(CONFIG_HARDWARE_WATCHPOINTS)
+	mips_probe_watch_registers(c);
+#endif
 	switch (c->processor_id & 0xff00) {
 	case PRID_IMP_4KC:
 		c->cputype = CPU_4KC;
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index 36f0653..e2f716c 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -50,8 +50,18 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "tlb_entries\t\t: %d\n", cpu_data[n].tlbsize);
 	seq_printf(m, "extra interrupt vector\t: %s\n",
 	              cpu_has_divec ? "yes" : "no");
+#ifdef CONFIG_HARDWARE_WATCHPOINTS
+	seq_printf(m, "hardware watchpoint\t: %s",
+		   cpu_has_watch ? "yes" : "no\n");
+	if (cpu_has_watch)
+		seq_printf(m, ", count: %d, address mask: 0x%04x, irw mask 0x%02x\n",
+			   cpu_data[n].watch_reg_count,
+			   cpu_data[n].watch_reg_mask,
+			   cpu_data[n].watch_reg_irw);
+#else
 	seq_printf(m, "hardware watchpoint\t: %s\n",
 	              cpu_has_watch ? "yes" : "no");
+#endif
 	seq_printf(m, "ASEs implemented\t:%s%s%s%s%s%s\n",
 		      cpu_has_mips16 ? " mips16" : "",
 		      cpu_has_mdmx ? " mdmx" : "",
-- 
1.5.5

