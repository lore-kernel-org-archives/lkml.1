Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbZFKJtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbZFKJtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762061AbZFKJtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:49:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:45228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762111AbZFKJtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:49:15 -0400
Date: Thu, 11 Jun 2009 09:48:44 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A30ACDF.5030408@jp.fujitsu.com>
References: <4A30ACDF.5030408@jp.fujitsu.com>
Subject: [tip:branch?] x86, mce: Add boot options for corrected errors
Message-ID: <tip-62fdac5913f71f8f200bd2c9bd59a02e9a1498e9@git.kernel.org>
Git-Commit-ID: 62fdac5913f71f8f200bd2c9bd59a02e9a1498e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 09:48:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62fdac5913f71f8f200bd2c9bd59a02e9a1498e9
Gitweb:     http://git.kernel.org/tip/62fdac5913f71f8f200bd2c9bd59a02e9a1498e9
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 11 Jun 2009 16:06:07 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Jun 2009 11:42:18 +0200

x86, mce: Add boot options for corrected errors

This patch introduces three boot options (no_cmci, dont_log_ce
and ignore_ce) to control handling for corrected errors.

The "mce=no_cmci" boot option disables the CMCI feature.

Since CMCI is a new feature so having boot controls to disable
it will be a help if the hardware is misbehaving.

The "mce=dont_log_ce" boot option disables logging for corrected
errors. All reported corrected errors will be cleared silently.
This option will be useful if you never care about corrected
errors.

The "mce=ignore_ce" boot option disables features for corrected
errors, i.e. polling timer and cmci.  All corrected events are
not cleared and kept in bank MSRs.

Usually this disablement is not recommended, however it will be
a help if there are some conflict with the BIOS or hardware
monitoring applications etc., that clears corrected events in
banks instead of OS.

[ And trivial cleanup (space -> tab) for doc is included. ]

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <4A30ACDF.5030408@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/x86/x86_64/boot-options.txt |   36 ++++++++++++++++++++++++-----
 arch/x86/include/asm/mce.h                |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c          |   19 +++++++++++++-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    3 ++
 4 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 0ee5e3b..fa2bed0 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -7,12 +7,36 @@ Machine check
 
    Please see Documentation/x86/x86_64/machinecheck for sysfs runtime tunables.
 
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
    mce=tolerancelevel[,monarchtimeout] (number,number)
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 82978ad..540a466 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -119,6 +119,8 @@ extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 #define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
 
 #ifdef CONFIG_X86_MCE_INTEL
+extern int mce_cmci_disabled;
+extern int mce_ignore_ce;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 6a3127e..fabba15 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -84,6 +84,9 @@ static int			rip_msr;
 static int			mce_bootlog = -1;
 static int			monarch_timeout = -1;
 static int			mce_panic_timeout;
+static int			mce_dont_log_ce;
+int				mce_cmci_disabled;
+int				mce_ignore_ce;
 int				mce_ser;
 
 static char			trigger[128];
@@ -526,7 +529,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG)) {
+		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
 			add_taint(TAINT_MACHINE_CHECK);
 		}
@@ -1307,6 +1310,9 @@ static void mce_init_timer(void)
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(next_interval);
 
+	if (mce_ignore_ce)
+		return;
+
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
@@ -1517,7 +1523,10 @@ static struct miscdevice mce_log_device = {
 };
 
 /*
- * mce=off disables machine check
+ * mce=off Disables machine check
+ * mce=no_cmci Disables CMCI
+ * mce=dont_log_ce Clears corrected events silently, no log created for CEs.
+ * mce=ignore_ce Disables polling and CMCI, corrected events are not cleared.
  * mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
  *	monarchtimeout is how long to wait for other CPUs on machine
  *	check, or 0 to not wait
@@ -1532,6 +1541,12 @@ static int __init mcheck_enable(char *str)
 		str++;
 	if (!strcmp(str, "off"))
 		mce_disabled = 1;
+	else if (!strcmp(str, "no_cmci"))
+		mce_cmci_disabled = 1;
+	else if (!strcmp(str, "dont_log_ce"))
+		mce_dont_log_ce = 1;
+	else if (!strcmp(str, "ignore_ce"))
+		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0])) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index b7c5a24..046087e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -57,6 +57,9 @@ static int cmci_supported(int *banks)
 {
 	u64 cap;
 
+	if (mce_cmci_disabled || mce_ignore_ce)
+		return 0;
+
 	/*
 	 * Vendor check is not strictly needed, but the initial
 	 * initialization is vendor keyed and this
