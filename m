Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbZC1Vb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbZC1Vb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760935AbZC1V3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:29:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760932AbZC1V33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:29:29 -0400
Date: Sat, 28 Mar 2009 21:28:52 GMT
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49CB3F24.8040804@jp.fujitsu.com>
References: <49CB3F24.8040804@jp.fujitsu.com>
Subject: [tip:x86/mce2] x86, mce: Add mce_threshold option for intel cmci
Message-ID: <tip-0b66224ac2fd303cd2858bf313058c555a555642@git.kernel.org>
Git-Commit-ID: 0b66224ac2fd303cd2858bf313058c555a555642
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 28 Mar 2009 21:28:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b66224ac2fd303cd2858bf313058c555a555642
Gitweb:     http://git.kernel.org/tip/0b66224ac2fd303cd2858bf313058c555a555642
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 26 Mar 2009 17:39:00 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Mar 2009 13:03:39 +0100

x86, mce: Add mce_threshold option for intel cmci

Impact: add new boot option

This patch adds a kernel parameter "mce_threshold=n" to enable us
to change the default threshold for CMCI (Corrected Machine Check
Interrupt) that recent Intel processor supports.

And it also supports CMCI disabling by setting mce_threshold=0.
It would be useful if your hardware does something wrong and/or
if polling by timer is preferred than the threshold interrupt.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <49CB3F24.8040804@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt       |    5 +++
 arch/x86/include/asm/msr-index.h          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   56 +++++++++++++++++++++++++++--
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 28de395..e387534 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1242,6 +1242,11 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
 
+	mce_threshold=	[X86-64,intel] Default CMCI threshold
+			Should be unsigned integer. Setting 0 disables cmci.
+			Format: <integer>
+			Default: 1
+
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2dbd231..b2b6329 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -81,6 +81,7 @@
 #define MSR_IA32_MC0_CTL2		0x00000280
 #define CMCI_EN			(1ULL << 30)
 #define CMCI_THRESHOLD_MASK		0xffffULL
+#define CMCI_THRESHOLD_VAL_MASK		0x7fffULL
 
 #define MSR_P6_PERFCTR0			0x000000c1
 #define MSR_P6_PERFCTR1			0x000000c2
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index 57df3d3..f261490 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -103,8 +103,6 @@ static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
  */
 static DEFINE_SPINLOCK(cmci_discover_lock);
 
-#define CMCI_THRESHOLD 1
-
 static int cmci_supported(int *banks)
 {
 	u64 cap;
@@ -135,6 +133,51 @@ static void intel_threshold_interrupt(void)
 	mce_notify_user();
 }
 
+/*
+ * Default threshold, setting 0 disables cmci
+ */
+static unsigned long threshold_limit = 1;
+
+static int __init mcheck_threshold(char *str)
+{
+	int val;
+
+	get_option(&str, &val);
+	if (val < 0) {
+		printk(KERN_INFO "mce_threshold argument ignored.\n");
+		return 0;
+	}
+	threshold_limit = val;
+
+	return 1;
+}
+__setup("mce_threshold=", mcheck_threshold);
+
+void static cmci_set_threshold(int bank)
+{
+	u64 val, limit, max, new;
+
+	rdmsrl(MSR_IA32_MC0_CTL2 + bank, val);
+	limit = val & CMCI_THRESHOLD_VAL_MASK;
+
+	/* Thresholding available? */
+	if (!limit)
+		return;
+	/* Return if no need to change */
+	if (limit == threshold_limit)
+		return;
+
+	/* Find the maximum threshold value */
+	max = (val & ~CMCI_THRESHOLD_MASK) | CMCI_THRESHOLD_VAL_MASK;
+	wrmsrl(MSR_IA32_MC0_CTL2 + bank, max);
+	rdmsrl(MSR_IA32_MC0_CTL2 + bank, max);
+	max &= CMCI_THRESHOLD_VAL_MASK;
+	max = (threshold_limit > max ? max : threshold_limit);
+
+	new = (val & ~CMCI_THRESHOLD_MASK) | max;
+	wrmsrl(MSR_IA32_MC0_CTL2 + bank, new);
+}
+
 static void print_update(char *type, int *hdr, int num)
 {
 	if (*hdr == 0)
@@ -143,6 +186,9 @@ static void print_update(char *type, int *hdr, int num)
 	printk(KERN_CONT " %s:%d", type, num);
 }
 
+/* Used to determine whether thresholding is available or not */
+#define CMCI_THRESHOLD_FIRST 1
+
 /*
  * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
  * on this CPU. Use the algorithm recommended in the SDM to discover shared
@@ -154,6 +200,9 @@ static void cmci_discover(int banks, int boot)
 	int hdr = 0;
 	int i;
 
+	if (!threshold_limit)
+		return;
+
 	spin_lock(&cmci_discover_lock);
 	for (i = 0; i < banks; i++) {
 		u64 val;
@@ -171,7 +220,7 @@ static void cmci_discover(int banks, int boot)
 			continue;
 		}
 
-		val |= CMCI_EN | CMCI_THRESHOLD;
+		val |= CMCI_EN | CMCI_THRESHOLD_FIRST;
 		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
 		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
 
@@ -180,6 +229,7 @@ static void cmci_discover(int banks, int boot)
 			if (!test_and_set_bit(i, owned) || boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			cmci_set_threshold(i);
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
