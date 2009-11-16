Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZKPVHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZKPVHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZKPVH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:07:29 -0500
Received: from relay2.sgi.com ([192.48.179.30]:51149 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753879AbZKPVHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:07:24 -0500
Message-Id: <20091116210727.456553000@alcatraz.americas.sgi.com>
References: <20091116210718.412792000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Nov 2009 15:07:20 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] x86: Limit the number of per cpu MCE bootup messages
Content-Disposition: inline; filename=limit_mce_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of per cpu MCE messages by using pr_debug.
This prevents filling up the console output with repetitious
messages when the number of cpus is large.

Remove the need for KERN_CONT so it does not add an extraneous
newline in the booting cpu sequence.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c       |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   20 ++++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1215,10 +1215,10 @@
 
 	b = cap & MCG_BANKCNT_MASK;
 	if (!banks)
-		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
+		pr_debug("mce: CPU supports %d MCE banks\n", b);
 
 	if (b > MAX_NR_BANKS) {
-		printk(KERN_WARNING
+		pr_warning(
 		       "MCE: Using only %u machine check banks out of %u\n",
 			MAX_NR_BANKS, b);
 		b = MAX_NR_BANKS;
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -64,12 +64,15 @@
 	mce_notify_irq();
 }
 
-static void print_update(char *type, int *hdr, int num)
+static void print_update(char *type, int *hdr, int num, char *buf, int len)
 {
-	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
+	int n = *hdr;
+
+	if (n == 0)
+		n = snprintf(buf, len, "CPU %d MCA banks", smp_processor_id());
+
+	n += snprintf(&buf[n], len - n, " %s:%d", type, num);
+	*hdr = n;
 }
 
 /*
@@ -83,6 +86,7 @@
 	unsigned long flags;
 	int hdr = 0;
 	int i;
+	char buf[120];
 
 	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
@@ -96,7 +100,7 @@
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
 			if (test_and_clear_bit(i, owned) || boot)
-				print_update("SHD", &hdr, i);
+				print_update("SHD", &hdr, i, buf, sizeof(buf));
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
@@ -108,7 +112,7 @@
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & CMCI_EN) {
 			if (!test_and_set_bit(i, owned) || boot)
-				print_update("CMCI", &hdr, i);
+				print_update("CMCI", &hdr, i, buf, sizeof(buf));
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
@@ -116,7 +120,7 @@
 	}
 	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
-		printk(KERN_CONT "\n");
+		pr_debug("%s\n", buf);
 }
 
 /*

-- 
