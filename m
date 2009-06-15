Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbZFOI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbZFOI2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbZFOI15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:27:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53586 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827AbZFOI1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:27:55 -0400
Message-ID: <4A360603.7010505@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:27:47 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/16] x86, mce: mce.h cleanup
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder definitions.

 - static inline dummy mcheck_init() for !CONFIG_X86_MCE
 - gather defs for exception, threshold handler

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 365a594..5cdd8d1 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -109,6 +109,12 @@ struct mce_log {
 extern int mce_disabled;
 extern int mce_p5_enabled;
 
+#ifdef CONFIG_X86_MCE
+void mcheck_init(struct cpuinfo_x86 *c);
+#else
+static inline void mcheck_init(struct cpuinfo_x86 *c) {}
+#endif
+
 #ifdef CONFIG_X86_OLD_MCE
 extern int nr_mce_banks;
 void amd_mcheck_init(struct cpuinfo_x86 *c);
@@ -126,13 +132,9 @@ static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void enable_p5_mce(void) {}
 #endif
 
-/* Call the installed machine check handler for this CPU setup. */
-extern void (*machine_check_vector)(struct pt_regs *, long error_code);
-
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
-extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 /*
  * To support more than 128 would need to escape the predefined
@@ -169,8 +171,6 @@ DECLARE_PER_CPU(unsigned, mce_poll_count);
 
 extern atomic_t mce_entry;
 
-void do_machine_check(struct pt_regs *, long);
-
 typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
@@ -187,13 +187,20 @@ void mce_notify_process(void);
 DECLARE_PER_CPU(struct mce, injectm);
 extern struct file_operations mce_chrdev_ops;
 
-#ifdef CONFIG_X86_MCE
-void mcheck_init(struct cpuinfo_x86 *c);
-#else
-#define mcheck_init(c) do { } while (0)
-#endif
+/*
+ * Exception handler
+ */
+
+/* Call the installed machine check handler for this CPU setup. */
+extern void (*machine_check_vector)(struct pt_regs *, long error_code);
+void do_machine_check(struct pt_regs *, long);
+
+/*
+ * Threshold handler
+ */
 
 extern void (*mce_threshold_vector)(void);
+extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 /*
  * Thermal handler
-- 
1.6.3


