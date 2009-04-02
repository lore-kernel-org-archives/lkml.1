Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbZDBE6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbZDBE6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZDBE6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:58:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51719 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZDBE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:58:24 -0400
Message-ID: <49D445E6.4080202@jp.fujitsu.com>
Date: Thu, 02 Apr 2009 13:58:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH -tip 3/3] x86, mce: Add new option mce=no_cmci and mce=ignore_ce
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu> <49D183B0.6060306@jp.fujitsu.com> <20090401150711.GA20037@elte.hu> <49D44285.9070808@jp.fujitsu.com>
In-Reply-To: <49D44285.9070808@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a couple of boot option for x86_64 mce.

The "mce=no_cmci" boot option disables cmci feature.
Since cmci is a new feature so having boot controls to disable
it will be a help if the hardware is misbehaving.

The "mce=ignore_ce" boot option disables features for corrected
errors, i.e. polling timer and cmci.  Usually this disablement
is not recommended, however it will be a help if there are some
conflict with the BIOS or hardware monitoring applications etc.

And trivial cleanup (space -> tab) for doc is included.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/x86/x86_64/boot-options.txt |   22 ++++++++++++++++------
 arch/x86/include/asm/mce.h                |    2 ++
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   11 +++++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    3 +++
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 34c1304..730b09b 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -5,12 +5,22 @@ only the AMD64 specific ones are listed here.
 
 Machine check
 
-   mce=off disable machine check
-   mce=bootlog Enable logging of machine checks left over from booting.
-               Disabled by default on AMD because some BIOS leave bogus ones.
-               If your BIOS doesn't do that it's a good idea to enable though
-               to make sure you log even machine check events that result
-               in a reboot. On Intel systems it is enabled by default.
+   mce=off
+		Disable machine check
+   mce=no_cmci
+		Disable CMCI(Corrected Machine Check Interrupt) that
+		Intel processor supports.
+   mce=ignore_ce
+		Disable features for corrected errors, e.g. polling timer
+		and CMCI.  Usually this disablement is not recommended,
+		however it will be a help if there are some conflict with
+		BIOS or hardware monitoring applications etc.
+   mce=bootlog
+		Enable logging of machine checks left over from booting.
+		Disabled by default on AMD because some BIOS leave bogus ones.
+		If your BIOS doesn't do that it's a good idea to enable though
+		to make sure you log even machine check events that result
+		in a reboot. On Intel systems it is enabled by default.
    mce=nobootlog
 		Disable boot machine check logging.
    mce=tolerancelevel (number)
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 563933e..065858c 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -104,6 +104,8 @@ extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 #define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
 
 #ifdef CONFIG_X86_MCE_INTEL
+extern int cmci_disabled;
+extern int ignore_ce;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 33d612e..bd0fce3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -41,6 +41,8 @@
 atomic_t mce_entry;
 
 static int mce_dont_init;
+int cmci_disabled;
+int ignore_ce;
 
 /*
  * Tolerant levels:
@@ -633,6 +635,9 @@ static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 
+	if (ignore_ce)
+		return;
+
 	/* data race harmless because everyone sets to the same value */
 	if (!next_interval)
 		next_interval = check_interval * HZ;
@@ -842,6 +847,8 @@ __setup("nomce", mcheck_disable);
 
 /*
  * mce=off disables machine check
+ * mce=no_cmci disables CMCI
+ * mce=ignore_ce disables polling for corrected errors and also CMCI
  * mce=TOLERANCELEVEL (number, see above)
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
@@ -850,6 +857,10 @@ static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
 		mce_dont_init = 1;
+	else if (!strcmp(str, "no_cmci"))
+		cmci_disabled = 1;
+	else if (!strcmp(str, "ignore_ce"))
+		ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0]))
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..64c0dd9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -109,6 +109,9 @@ static int cmci_supported(int *banks)
 {
 	u64 cap;
 
+	if (cmci_disabled | ignore_ce)
+		return 0;
+
 	/*
 	 * Vendor check is not strictly needed, but the initial
 	 * initialization is vendor keyed and this
-- 
1.6.2.1

