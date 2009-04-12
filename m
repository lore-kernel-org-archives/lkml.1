Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZDLR67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZDLR67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZDLR63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:58:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZDLR60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:58:26 -0400
Date: Sun, 12 Apr 2009 17:57:57 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090412165058.724788431@openvz.org>
References: <20090412165058.724788431@openvz.org>
Subject: [tip:x86/apic] x86: apic - introduce dummy apic operations
Message-ID: <tip-08306ce61d6848e6fbf74fa4cc693c3fb29e943f@git.kernel.org>
Git-Commit-ID: 08306ce61d6848e6fbf74fa4cc693c3fb29e943f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 17:58:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08306ce61d6848e6fbf74fa4cc693c3fb29e943f
Gitweb:     http://git.kernel.org/tip/08306ce61d6848e6fbf74fa4cc693c3fb29e943f
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 12 Apr 2009 20:47:41 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 19:23:53 +0200

x86: apic - introduce dummy apic operations

Impact: refactor, speed up and robustize code

In case if apic was disabled by kernel option
or by hardware limits we can use dummy operations
in apic->write to simplify the ack_APIC_irq() code.

At the lame time the patch fixes the missed EOI in
do_IRQ function (which has place if kernel is compiled
as X86-32 and interrupt without handler happens where
apic was not asked to be disabled via kernel option).

Note that native_apic_write_dummy() consists of
WARN_ON_ONCE to catch any buggy writes on enabled
APICs. Could be removed after some time of testing.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090412165058.724788431@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h |    3 ++-
 arch/x86/kernel/apic/apic.c |   24 ++++++++++++++++++++++++
 arch/x86/kernel/irq.c       |   10 ++--------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..2bd5a46 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -212,6 +212,7 @@ static inline void ack_x2APIC_irq(void)
 }
 #endif
 
+extern void apic_disable(void);
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC(void);
@@ -252,7 +253,7 @@ static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
 static inline void disable_local_APIC(void) { }
-
+static inline void apic_disable(void) { }
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c3be10f..9b849d4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -232,6 +232,24 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+/*
+ * bare function to substitute write operation
+ * and it's _that_ fast :)
+ */
+void native_apic_write_dummy(u32 reg, u32 v)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+}
+
+/*
+ * right after this call apic->write doesn't do anything
+ * note that there is no restore operation it works one way
+ */
+void apic_disable(void)
+{
+	apic->write = native_apic_write_dummy;
+}
+
 void native_apic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
@@ -1582,6 +1600,12 @@ void __init init_apic_mappings(void)
 	 */
 	if (boot_cpu_physical_apicid == -1U)
 		boot_cpu_physical_apicid = read_apic_id();
+
+	/* lets check if we may to NOP'ify apic operations */
+	if (!cpu_has_apic) {
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 6603492..fd57bf3 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -27,7 +27,6 @@ void ack_bad_irq(unsigned int irq)
 	if (printk_ratelimit())
 		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
 	 * We _must_ ack these because every local APIC has only N
@@ -37,9 +36,7 @@ void ack_bad_irq(unsigned int irq)
 	 * completely.
 	 * But only ack when the APIC is enabled -AK
 	 */
-	if (cpu_has_apic)
-		ack_APIC_irq();
-#endif
+	ack_APIC_irq();
 }
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
@@ -214,10 +211,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
-		if (!disable_apic)
-			ack_APIC_irq();
-#endif
+		ack_APIC_irq();
 
 		if (printk_ratelimit())
 			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
