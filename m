Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYDVAPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYDVAPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbYDVAPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:15:39 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:52920 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbYDVAPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:15:38 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D2E27.1000309@avtrex.com>
Date: Mon, 21 Apr 2008 17:15:35 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/6] Probe watch registers and report configuration.
References: <480D2151.2020701@avtrex.com>
In-Reply-To: <480D2151.2020701@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 00:15:36.0192 (UTC) FILETIME=[FCBE5000:01C8A40D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This portion of the patch add probing for the watch registers.  The probing
code is in watch.c, here we add a call to that code.

Also /proc/cpu info is modified to print out the watch register information.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/cpu-probe.c |    3 +++
 arch/mips/kernel/proc.c      |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 89c3304..c3308d3 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -678,6 +678,9 @@ static void __cpuinit decode_configs(struct cpuinfo_mips *c)
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

