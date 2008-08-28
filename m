Return-Path: <linux-kernel-owner+w=401wt.eu-S1757810AbYH1WCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810AbYH1WCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbYH1WCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:02:38 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:56711 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbYH1WCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:02:38 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48B7207C.8060407@avtrex.com>
Date: Thu, 28 Aug 2008 15:02:36 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/6] MIPS: Probe watch registers and report configuration.
References: <48B71ADD.601@avtrex.com>
In-Reply-To: <48B71ADD.601@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2008 22:02:36.0747 (UTC) FILETIME=[C7E961B0:01C90959]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Probe for watch register characteristics, and report them in
/proc/cpuinfo.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/cpu-probe.c |    2 ++
 arch/mips/kernel/proc.c      |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 335a6ae..d0d07b8 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -21,6 +21,7 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/system.h>
+#include <asm/watch.h>
 
 /*
  * Not all of the MIPS CPUs have the "wait" instruction available. Moreover,
@@ -685,6 +686,7 @@ static inline void spram_config(void) {}
 static inline void cpu_probe_mips(struct cpuinfo_mips *c)
 {
 	decode_configs(c);
+	mips_probe_watch_registers(c);
 	switch (c->processor_id & 0xff00) {
 	case PRID_IMP_4KC:
 		c->cputype = CPU_4KC;
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index 36f0653..11402f5 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -50,8 +50,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "tlb_entries\t\t: %d\n", cpu_data[n].tlbsize);
 	seq_printf(m, "extra interrupt vector\t: %s\n",
 	              cpu_has_divec ? "yes" : "no");
-	seq_printf(m, "hardware watchpoint\t: %s\n",
-	              cpu_has_watch ? "yes" : "no");
+	seq_printf(m, "hardware watchpoint\t: %s",
+		   cpu_has_watch ? "yes, " : "no\n");
+	if (cpu_has_watch)
+		seq_printf(m,
+			   "count: %d, address mask: 0x%04x, irw mask 0x%02x\n",
+			   cpu_data[n].watch_reg_count,
+			   cpu_data[n].watch_reg_mask,
+			   cpu_data[n].watch_reg_irw);
 	seq_printf(m, "ASEs implemented\t:%s%s%s%s%s%s\n",
 		      cpu_has_mips16 ? " mips16" : "",
 		      cpu_has_mdmx ? " mdmx" : "",
-- 
1.5.5.1

