Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbYEPWj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbYEPWj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYEPWjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:39:46 -0400
Received: from www.tglx.de ([62.245.132.106]:50022 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYEPWjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:39:45 -0400
Date: Sat, 17 May 2008 00:38:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 2.6.26
Message-ID: <alpine.LFD.1.10.0805170037180.3255@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, 

please pull the latest x86 fixes from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	tglx

------------------>
Avi Kivity (1):
      x86: fix crash on cpu hotplug on pat-incapable machines

Ingo Molnar (1):
      x86: remove mwait capability C-state check

Thomas Gleixner (1):
      x86: disable mwait for AMD family 10H/11H CPUs

 arch/x86/kernel/process.c |   36 +++++++++++++++++++++++++++---------
 arch/x86/mm/pat.c         |    2 +-
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 67e9b4a..ba370dc 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -99,15 +99,6 @@ static void mwait_idle(void)
 		local_irq_enable();
 }
 
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-	if (force_mwait)
-		return 1;
-	/* Any C1 states supported? */
-	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
 /*
  * On SMP it's slightly faster (but much more power-consuming!)
  * to poll the ->work.need_resched flag instead of waiting for the
@@ -119,6 +110,33 @@ static void poll_idle(void)
 	cpu_relax();
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
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index bcb1a8e..de3a998 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -28,7 +28,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_wc_enabled = 1;
 
-void __init pat_disable(char *reason)
+void __cpuinit pat_disable(char *reason)
 {
 	pat_wc_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
