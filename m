Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZLOXaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZLOXaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZLOXaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:30:21 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52792 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbZLOXaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:30:20 -0500
Message-ID: <4B281C05.7050404@sgi.com>
Date: Tue, 15 Dec 2009 15:30:13 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: rework output of MCE banks ownership information
References: <4B26EBB0.3090507@jp.fujitsu.com>
In-Reply-To: <4B26EBB0.3090507@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86, mce: rework output of MCE banks ownership information
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

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

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

v3: (again)
  - avoid use of pr_cont with pr_debug in print_banks_map()

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c       |    6 +--
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   53 ++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 13 deletions(-)

--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1215,11 +1215,11 @@
 
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
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -14,6 +14,8 @@
 #include <asm/msr.h>
 #include <asm/mce.h>
 
+#define	MCE_BUFF_LEN	120
+
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
  * the CPU to raise an interrupt when a corrected machine check happened.
@@ -64,13 +66,39 @@
 	mce_notify_irq();
 }
 
-static void print_update(char *type, int *hdr, int num)
+#ifdef DEBUG_KERNEL
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
+static void print_update(char *type, int *hdr, int num, char *buf)
 {
 	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
+		*hdr += snprintf(buf, MCE_BUFF_LEN,
+			"CPU %d MCE banks map updated:", smp_processor_id());
+
+	snprintf(&buf[*hdr], MCE_BUFF_LEN - *hdr, " %s:%d", type, num);
+}
+
+#else	/* !DEBUG_KERNEL */
+static inline void print_banks_map(int banks)
+{
+}
+
+static inline void print_update(char *type, int *hdr, int num, char *buf)
+{
 }
+#endif
 
 /*
  * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
@@ -83,8 +111,10 @@
 	unsigned long flags;
 	int hdr = 0;
 	int i;
+	char buf[MCE_BUFF_LEN];
 
 	spin_lock_irqsave(&cmci_discover_lock, flags);
+
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -95,8 +125,8 @@
 
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
-				print_update("SHD", &hdr, i);
+			if (test_and_clear_bit(i, owned) && !boot)
+				print_update("SHD", &hdr, i, buf);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
@@ -107,16 +137,19 @@
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & CMCI_EN) {
-			if (!test_and_set_bit(i, owned) || boot)
-				print_update("CMCI", &hdr, i);
+			if (!test_and_set_bit(i, owned) && !boot)
+				print_update("CMCI", &hdr, i, buf);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
-		printk(KERN_CONT "\n");
+		pr_debug("%s\n", buf);
+	if (hdr || boot)
+		print_banks_map(banks);
+
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*

