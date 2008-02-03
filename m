Return-Path: <linux-kernel-owner+w=401wt.eu-S936167AbYBCHlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936167AbYBCHlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbYBCHlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:41:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52695 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758880AbYBCHlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:41:21 -0500
Message-ID: <47A56FEE.9000900@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 15:40:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix compile warning building without CONFIG_SYSCTL
References: <47A55CA4.9090804@cn.fujitsu.com> <20080203071251.GB19020@elte.hu> <47A56DDA.9000907@cn.fujitsu.com>
In-Reply-To: <47A56DDA.9000907@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

building without CONFIG_SYSCTL:

arch/x86/kernel/nmi_64.c:50: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined

This patch also fixes nmi_32.c

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 arch/x86/kernel/nmi_32.c |   21 +++++++++------------
 arch/x86/kernel/nmi_64.c |   21 +++++++++------------
 2 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index edd4136..6a0aa70 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -46,9 +46,6 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
@@ -391,15 +388,6 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	return rc;
 }
 
-int do_nmi_callback(struct pt_regs * regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
@@ -453,6 +441,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif
 
+int do_nmi_callback(struct pt_regs *regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
 void __trigger_all_cpu_backtrace(void)
 {
 	int i;
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index fb99484..9a4fde7 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -46,9 +46,6 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
 {
@@ -394,15 +391,6 @@ asmlinkage __kprobes void do_nmi(struct pt_regs * regs, long error_code)
 	nmi_exit();
 }
 
-int do_nmi_callback(struct pt_regs * regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 void stop_nmi(void)
 {
 	acpi_nmi_disable();
@@ -464,6 +452,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif
 
+int do_nmi_callback(struct pt_regs *regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
 void __trigger_all_cpu_backtrace(void)
 {
 	int i;
-- 
1.5.4.rc3
