Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbYAOS7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbYAOS7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYAOS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:59:47 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:19227 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYAOS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:59:46 -0500
Message-ID: <478D0298.9060103@ct.jp.nec.com>
Date: Tue, 15 Jan 2008 10:59:36 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: move warning message of polling idle and HT enabled
References: <478BB226.6090105@ct.jp.nec.com> <20080114190904.GA2288@elte.hu> <478C1475.7060706@ct.jp.nec.com> <20080115132607.GE7025@elte.hu> <478D01E4.8010000@ct.jp.nec.com>
In-Reply-To: <478D01E4.8010000@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86: move warning message of polling idle and HT enabled

The warning message at idle_setup() is never shown because smp_num_sibling hasn't
been updated at this point yet.

Move this polling idle and HT enabled warning to select_idle_routine().
I also implement this warning on 64-bit kernel.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/process_32.c |   18 ++++++++++++------
 arch/x86/kernel/process_64.c |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 69a69c3..d52c032 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -287,17 +287,27 @@ static void mwait_idle(void)
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
+	static int selected;
+
+	if (selected)
+		return;
+#ifdef CONFIG_X86_SMP
+	if (pm_idle == poll_idle && smp_num_siblings > 1) {
+		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+			" performance may degrade.\n");
+	}
+#endif
 	if (cpu_has(c, X86_FEATURE_MWAIT)) {
-		printk("monitor/mwait feature present.\n");
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
 		 */
 		if (!pm_idle) {
-			printk("using mwait in idle threads.\n");
+			printk(KERN_INFO "using mwait in idle threads.\n");
 			pm_idle = mwait_idle;
 		}
 	}
+	selected = 1;
 }
 
 static int __init idle_setup(char *str)
@@ -305,10 +315,6 @@ static int __init idle_setup(char *str)
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-#ifdef CONFIG_X86_SMP
-		if (smp_num_siblings > 1)
-			printk("WARNING: polling idle and HT enabled, performance may degrade.\n");
-#endif
 	} else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
 	else
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5e12edd..8cff606 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -282,20 +282,27 @@ static void mwait_idle(void)
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-	static int printed;
+	static int selected;
+
+	if (selected)
+		return;
+#ifdef CONFIG_X86_SMP
+	if (pm_idle == poll_idle && smp_num_siblings > 1) {
+		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+			" performance may degrade.\n");
+	}
+#endif
 	if (cpu_has(c, X86_FEATURE_MWAIT)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
 		 */
 		if (!pm_idle) {
-			if (!printed) {
-				printk(KERN_INFO "using mwait in idle threads.\n");
-				printed = 1;
-			}
+			printk(KERN_INFO "using mwait in idle threads.\n");
 			pm_idle = mwait_idle;
 		}
 	}
+	selected = 1;
 }
 
 static int __init idle_setup(char *str)
-- 
1.5.3.6

