Return-Path: <linux-kernel-owner+w=401wt.eu-S937398AbYEBXqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937398AbYEBXqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935888AbYEBXpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:45:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55173 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935723AbYEBXpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:45:21 -0400
Message-ID: <481BA78F.50202@ct.jp.nec.com>
Date: Fri, 02 May 2008 16:45:19 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_32: move do_nmi() to nmi_32.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

on x86_64 do_nmi() is in nmi_64.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/nmi_32.c   |   30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/traps_32.c |   32 +-------------------------------
 include/asm-x86/nmi.h      |    3 ++-
 3 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 69bdae5..641d2d9 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -398,6 +398,36 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	return rc;
 }
 
+static unsigned ignore_nmis;
+
+notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
+{
+	int cpu;
+
+	nmi_enter();
+
+	cpu = smp_processor_id();
+
+	++nmi_count(cpu);
+
+	if (!ignore_nmis)
+		default_do_nmi(regs);
+
+	nmi_exit();
+}
+
+void stop_nmi(void)
+{
+	acpi_nmi_disable();
+	ignore_nmis++;
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+	acpi_nmi_enable();
+}
+
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 7fad084..b1793ad 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -787,7 +787,7 @@ void notrace __kprobes die_nmi(struct pt_regs *regs, const char *msg)
 	do_exit(SIGSEGV);
 }
 
-static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -827,36 +827,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	reassert_nmi();
 }
 
-static int ignore_nmis;
-
-notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
-{
-	int cpu;
-
-	nmi_enter();
-
-	cpu = smp_processor_id();
-
-	++nmi_count(cpu);
-
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	acpi_nmi_disable();
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-	acpi_nmi_enable();
-}
-
 #ifdef CONFIG_KPROBES
 void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index 1e36302..9fd90b6 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -37,13 +37,14 @@ static inline void unset_nmi_pm_callback(struct pm_dev *dev)
 #endif /* CONFIG_PM */
 
 #ifdef CONFIG_X86_64
-extern void default_do_nmi(struct pt_regs *);
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern void nmi_watchdog_default(void);
 #else
 #define nmi_watchdog_default() do {} while (0)
 #endif
 
+extern void default_do_nmi(struct pt_regs *);
+
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int unknown_nmi_panic;
-- 
1.5.4.1

