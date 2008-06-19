Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYFSVgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYFSVgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYFSVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:45 -0400
Received: from mail.suse.de ([195.135.220.2]:38221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbYFSVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:43 -0400
Date: Thu, 19 Jun 2008 14:30:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch 15/15] x86: disable mwait for AMD family 10H/11H CPUs
Message-ID: <20080619213014.GP20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-disable-mwait-for-amd-family-10h-11h-cpus.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

back-ported from upstream commit e9623b35599fcdbc00c16535cbefbb4d5578f4ab by Vegard Nossum


The previous revert of 0c07ee38c9d4eb081758f5ad14bbffa7197e1aec left
out the mwait disable condition for AMD family 10H/11H CPUs.

Andreas Herrman said:

It depends on the CPU. For AMD CPUs that support MWAIT this is wrong.
Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings then
depend on a clock divisor and current Pstate of the core.

If all cores of a processor are in halt state (C1) the processor can
enter the C1E (C1 enhanced) state. If mwait is used this will never
happen.

Thus HLT saves more power than MWAIT here.

It might be best to switch off the mwait flag for these AMD CPU
families like it was introduced with commit
f039b754714a422959027cb18bb33760eb8153f0 (x86: Don't use MWAIT on AMD
Family 10)

Re-add the AMD families 10H/11H check and disable the mwait usage for
those.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/process_32.c |   29 ++++++++++++++++++++++++++++-
 arch/x86/kernel/process_64.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -259,6 +259,33 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
+/*
+ * mwait selection logic:
+ *
+ * It depends on the CPU. For AMD CPUs that support MWAIT this is
+ * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
+ * then depend on a clock divisor and current Pstate of the core. If
+ * all cores of a processor are in halt state (C1) the processor can
+ * enter the C1E (C1 enhanced) state. If mwait is used this will never
+ * happen.
+ *
+ * idle=mwait overrides this decision and forces the usage of mwait.
+ */
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		switch(c->x86) {
+		case 0x10:
+		case 0x11:
+			return 0;
+		}
+	}
+	return 1;
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int selected;
@@ -271,7 +298,7 @@ void __cpuinit select_idle_routine(const
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -254,6 +254,33 @@ static void mwait_idle(void)
 	}
 }
 
+/*
+ * mwait selection logic:
+ *
+ * It depends on the CPU. For AMD CPUs that support MWAIT this is
+ * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
+ * then depend on a clock divisor and current Pstate of the core. If
+ * all cores of a processor are in halt state (C1) the processor can
+ * enter the C1E (C1 enhanced) state. If mwait is used this will never
+ * happen.
+ *
+ * idle=mwait overrides this decision and forces the usage of mwait.
+ */
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		switch(c->x86) {
+		case 0x10:
+		case 0x11:
+			return 0;
+		}
+	}
+	return 1;
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int selected;
@@ -266,7 +293,7 @@ void __cpuinit select_idle_routine(const
 			" performance may degrade.\n");
 	}
 #endif
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait

-- 
