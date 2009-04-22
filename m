Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZDVDZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZDVDZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 23:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZDVDZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 23:25:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40054 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbZDVDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 23:25:33 -0400
Message-ID: <49EE8E10.9060400@jp.fujitsu.com>
Date: Wed, 22 Apr 2009 12:25:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86, mce: Add options for corrected errors (no_cmci/dont_log_ce/ignore_ce)
References: <49EBCDB0.7000505@jp.fujitsu.com>	<49EBCF87.4090608@jp.fujitsu.com> <87myabpyrn.fsf@basil.nowhere.org> <49EC3AC0.8070109@jp.fujitsu.com>
In-Reply-To: <49EC3AC0.8070109@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the updated one.
Thanks in advance!

H.Seto


This patch introduces three boot options to control handling
for corrected errors.

The "mce=no_cmci" boot option disables cmci feature.
Since cmci is a new feature so having boot controls to disable
it will be a help if the hardware is misbehaving.

The "mce=dont_log_ce" boot option disables logging for corrected
errors.  All reported corrected errors will be cleared silently.
This option will be useful if you never care corrected errors.

The "mce=ignore_ce" boot option disables features for corrected
errors, i.e. polling timer and cmci.  All corrected events are
not cleared and kept in bank MSRs.  Usually this disablement
is not recommended, however it will be a help if there are some
conflict with the BIOS or hardware monitoring applications etc.,
that clears corrected events in banks instead of OS.

And trivial cleanup (space -> tab) for doc is included.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 Documentation/x86/x86_64/boot-options.txt |   36 ++++++++++++++++++++++++-----
 arch/x86/include/asm/mce.h                |    2 +
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   20 ++++++++++++++-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    3 ++
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 34c1304..04834ad 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -5,12 +5,36 @@ only the AMD64 specific ones are listed here.
 
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
+		Intel processor supports.  Usually this disablement is
+		not recommended, but it might be handy if your hardware
+		is misbehaving.
+		Note that you'll get more problems without CMCI than with
+		due to the shared banks, i.e. you might get duplicated
+		error logs.
+   mce=dont_log_ce
+		Don't make logs for corrected errors.  All events reported
+		as corrected are silently cleared by OS.
+		This option will be useful if you have no interest in any
+		of corrected errors.
+   mce=ignore_ce
+		Disable features for corrected errors, e.g. polling timer
+		and CMCI.  All events reported as corrected are not cleared
+		by OS and remained in its error banks.
+		Usually this disablement is not recommended, however if
+		there is an agent checking/clearing corrected errors
+		(e.g. BIOS or hardware monitoring applications), conflicting
+		with OS's error handling, and you cannot deactivate the agent,
+		then this option will be a help.
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
index 563933e..a8a6cd5 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -104,6 +104,8 @@ extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 #define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
 
 #ifdef CONFIG_X86_MCE_INTEL
+extern int mce_cmci_disabled;
+extern int mce_ignore_ce;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 33d612e..6abefe3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -41,6 +41,9 @@
 atomic_t mce_entry;
 
 static int mce_dont_init;
+static int mce_dont_log_ce;
+int mce_cmci_disabled;
+int mce_ignore_ce;
 
 /*
  * Tolerant levels:
@@ -240,7 +243,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * have anything to do with the actual error location.
 		 */
 
-		mce_log(&m);
+		if (!mce_dont_log_ce)
+			mce_log(&m);
 		add_taint(TAINT_MACHINE_CHECK);
 
 		/*
@@ -633,6 +637,9 @@ static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 
+	if (mce_ignore_ce)
+		return;
+
 	/* data race harmless because everyone sets to the same value */
 	if (!next_interval)
 		next_interval = check_interval * HZ;
@@ -841,7 +848,10 @@ static int __init mcheck_disable(char *str)
 __setup("nomce", mcheck_disable);
 
 /*
- * mce=off disables machine check
+ * mce=off Disables machine check
+ * mce=no_cmci Disables CMCI
+ * mce=dont_log_ce Clears corrected events silently, no log created for CEs.
+ * mce=ignore_ce Disables polling and CMCI, corrected events are not cleared.
  * mce=TOLERANCELEVEL (number, see above)
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
@@ -850,6 +860,12 @@ static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
 		mce_dont_init = 1;
+	else if (!strcmp(str, "no_cmci"))
+		mce_cmci_disabled = 1;
+	else if (!strcmp(str, "dont_log_ce"))
+		mce_dont_log_ce = 1;
+	else if (!strcmp(str, "ignore_ce"))
+		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0]))
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..a88bad9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -109,6 +109,9 @@ static int cmci_supported(int *banks)
 {
 	u64 cap;
 
+	if (mce_cmci_disabled || mce_ignore_ce)
+		return 0;
+
 	/*
 	 * Vendor check is not strictly needed, but the initial
 	 * initialization is vendor keyed and this
-- 
1.6.2.2


