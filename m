Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZKQSkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZKQSkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZKQSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:40:32 -0500
Received: from relay1.sgi.com ([192.48.179.29]:42049 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753639AbZKQSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:40:31 -0500
Message-ID: <4B02EE1D.6020302@sgi.com>
Date: Tue, 17 Nov 2009 10:40:29 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86, mce: rework output of MCE banks ownership information
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210727.456553000@alcatraz.americas.sgi.com> <20091116212251.GB2221@elte.hu> <4B01C59A.9050507@sgi.com> <4B024C76.9050005@jp.fujitsu.com>
In-Reply-To: <4B024C76.9050005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

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
E.g. if a cpu take over the ownership from hot-removed cpu,
both message will be shown:

  CPU 1 MCE banks map updated: CMCI:6 CMCI:7 CMCI:10 CMCI:11
  CPU 1 MCE banks map: ssCC PCCC ssPP ssCC ssss ss

v2:
  - stop changing the level of message on update
  - change the number of banks message on boot to debug level

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

  - Modified to not use pr_cont().

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c       |    6 +--
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   63 +++++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 14 deletions(-)

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
@@ -64,14 +64,50 @@
 	mce_notify_irq();
 }
 
-static void print_update(char *type, int *hdr, int num)
+#define	MCE_MSG_LEN	120
+
+#ifdef DEBUG_KERNEL
+static void print_banks_map(int banks, char *buf)
+{
+	int i, n;
+
+	n = snprintf(buf, MCE_MSG_LEN, "CPU %d MCE banks map:",
+							smp_processor_id());
+	for (i = 0; i < banks; i++) {
+		n += snprintf(&buf[n], MCE_MSG_LEN - n,
+			"%s%s", (i % 4) ? "" : " ",
+			test_bit(i, __get_cpu_var(mce_banks_owned)) ? "C" :
+			test_bit(i, __get_cpu_var(mce_poll_banks)) ? "P" : "s");
+	}
+
+	/* (indicate if message buffer overflowed) */
+	pr_debug("%s%s\n", buf, n < MCE_MSG_LEN ? "" : "..." );
+}
+
+static void print_update(char *type, int *hdr, int num, char *buf)
+{
+	int n = *hdr;
+
+	if (n == 0)
+		n = snprintf(buf, MCE_MSG_LEN,
+			"CPU %d MCE banks map updated:", smp_processor_id());
+
+	n += snprintf(&buf[n], MCE_MSG_LEN - n, " %s:%d", type, num);
+	*hdr = n;
+}
+
+#else /* !DEBUG_KERNEL */
+
+static inline void print_banks_map(int banks, char *buf)
+{
+}
+
+static inline void print_update(char *type, int *hdr, int num, char *buf)
 {
-	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
 }
 
+#endif
+
 /*
  * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
  * on this CPU. Use the algorithm recommended in the SDM to discover shared
@@ -83,8 +119,10 @@
 	unsigned long flags;
 	int hdr = 0;
 	int i;
+	char buf[MCE_MSG_LEN];
 
 	spin_lock_irqsave(&cmci_discover_lock, flags);
+
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -95,8 +133,8 @@
 
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
-				print_update("SHD", &hdr, i);
+			if (test_and_clear_bit(i, owned) && !boot)
+				print_update("SHD", &hdr, i, buf);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
@@ -107,16 +145,19 @@
 
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
+		pr_debug("%s%s\n", buf, hdr < MCE_MSG_LEN ? "" : "...");
+	if (hdr || boot)
+		print_banks_map(banks, buf);
+
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*

