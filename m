Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZLOBwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZLOBwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZLOBwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:52:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60838 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZLOBwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:52:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B26EBB0.3090507@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 10:51:44 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: [PATCH] x86, mce: rework output of MCE banks ownership information
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of MCE banks ownership information on boot tend
to be long on new processor which has many banks:

  CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18 SHD:19 SHD:20 SHD:21

This message can fill up the console output when the number
of cpus is large.

This patch suppress this info message on boot, and introduce
debug message in shorter format instead, like:

  CPU 1 MCE banks map: ssCC PCss ssPP ssss ssss ss

  where: s: shared, C: checked by cmci, P: checked by poll.

This patch still keep the info when ownership is updated.
E.g. when a cpu take over the ownership from hot-removed cpu,
both message will be shown:

  CPU 1 MCE banks map updated: CMCI:6 CMCI:7 CMCI:10 CMCI:11
  CPU 1 MCE banks map: ssCC PCCC ssPP ssCC ssss ss

v2:
  - stop changing the level of message on update
  - change the number of banks message on boot to debug level

v3:
  - avoid use of pr_cont with pr_debug in print_banks_map()

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c       |    6 +++---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   30 ++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..8d6afea 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1229,11 +1229,11 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 
 	b = cap & MCG_BANKCNT_MASK;
 	if (!banks)
-		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
+		pr_debug("mce: CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
-		printk(KERN_WARNING
-		       "MCE: Using only %u machine check banks out of %u\n",
+		pr_warning(
+			"MCE: Using only %u machine check banks out of %u\n",
 			MAX_NR_BANKS, b);
 		b = MAX_NR_BANKS;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 7c78563..234e473 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -64,12 +64,26 @@ static void intel_threshold_interrupt(void)
 	mce_notify_irq();
 }
 
+static void print_banks_map(int banks)
+{
+	char buf[32 + MAX_NR_BANKS * 5 / 4]; /* 72 if MAX_NR_BANKS == 32 */
+	int i, n, ln = sizeof(buf);
+
+	n = snprintf(buf, ln, "CPU %d MCE banks map:", smp_processor_id());
+	for (i = 0; i < banks; i++) {
+		n += snprintf(&buf[n], ln - n, "%s%s", (i % 4) ? "" : " ",
+			test_bit(i, __get_cpu_var(mce_banks_owned)) ? "C" :
+			test_bit(i, __get_cpu_var(mce_poll_banks)) ? "P" : "s");
+	}
+	pr_debug("%s\n", buf);
+}
+
 static void print_update(char *type, int *hdr, int num)
 {
 	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
+		pr_info("CPU %d MCE banks map updated:", smp_processor_id());
 	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
+	pr_cont(" %s:%d", type, num);
 }
 
 /*
@@ -85,6 +99,7 @@ static void cmci_discover(int banks, int boot)
 	int i;
 
 	spin_lock_irqsave(&cmci_discover_lock, flags);
+
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -95,7 +110,7 @@ static void cmci_discover(int banks, int boot)
 
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
+			if (test_and_clear_bit(i, owned) && !boot)
 				print_update("SHD", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
@@ -107,16 +122,19 @@ static void cmci_discover(int banks, int boot)
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & CMCI_EN) {
-			if (!test_and_set_bit(i, owned) || boot)
+			if (!test_and_set_bit(i, owned) && !boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
+	if (hdr || boot)
+		print_banks_map(banks);
+
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
-- 
1.6.5.6


