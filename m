Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZJBOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZJBOCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbZJBOCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:02:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:47845 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbZJBOCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:02:17 -0400
Date: Fri, 2 Oct 2009 14:01:14 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu, borislav.petkov@amd.com
In-Reply-To: <20091001141432.GA11410@aftab>
References: <20091001141432.GA11410@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: EDAC: MCE: Fix MCE decoding callback logic
Message-ID: <tip-f436f8bb73138bc74eb1c6527723e00988ad8a8a@git.kernel.org>
Git-Commit-ID: f436f8bb73138bc74eb1c6527723e00988ad8a8a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 14:01:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f436f8bb73138bc74eb1c6527723e00988ad8a8a
Gitweb:     http://git.kernel.org/tip/f436f8bb73138bc74eb1c6527723e00988ad8a8a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 1 Oct 2009 16:14:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Oct 2009 15:42:18 +0200

x86: EDAC: MCE: Fix MCE decoding callback logic

Make decoding of MCEs happen only on AMD hardware by registering a
non-default callback only on CPU families which support it.

While looking at the interaction of decode_mce() with the other MCE
code i also noticed a few other things and made the following
cleanups/fixes:

 - Fixed the mce_decode() weak alias - a weak alias is really not
   good here, it should be a proper callback. A weak alias will be
   overriden if a piece of code is built into the kernel - not
   good, obviously.

 - The patch initializes the callback on AMD family 10h and 11h.

 - Added the more correct fallback printk of:

	No support for human readable MCE decoding on this CPU type.
	Transcribe the message and run it through 'mcelog --ascii' to decode.

   On CPUs that dont have a decoder.

 - Made the surrounding code more readable.

Note that the callback allows us to have a default fallback -
without having to check the CPU versions during the printout
itself. When an EDAC module registers itself, it can install the
decode-print function.

(there's no unregister needed as this is core code.)

version -v2 by Borislav Petkov:

 - add K8 to the set of supported CPUs

 - always build in edac_mce_amd since we use an early_initcall now

 - fix checkpatch warnings

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <20091001141432.GA11410@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/mce.h       |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c |   58 +++++++++++++++++++++++--------------
 drivers/edac/Makefile            |    2 +-
 drivers/edac/edac_mce_amd.c      |   15 +++++++++-
 4 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index b608a64..f1363b7 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -133,6 +133,8 @@ static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void enable_p5_mce(void) {}
 #endif
 
+extern void (*x86_mce_decode_callback)(struct mce *m);
+
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 183c345..b1598a9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -85,6 +85,18 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
+static void default_decode_mce(struct mce *m)
+{
+	pr_emerg("No human readable MCE decoding support on this CPU type.\n");
+	pr_emerg("Run the message through 'mcelog --ascii' to decode.\n");
+}
+
+/*
+ * CPU/chipset specific EDAC code can register a callback here to print
+ * MCE errors in a human-readable form:
+ */
+void (*x86_mce_decode_callback)(struct mce *m) = default_decode_mce;
+EXPORT_SYMBOL(x86_mce_decode_callback);
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -165,46 +177,46 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
-void __weak decode_mce(struct mce *m)
-{
-	return;
-}
-
 static void print_mce(struct mce *m)
 {
-	printk(KERN_EMERG
-	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
+	pr_emerg("CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
+
 	if (m->ip) {
-		printk(KERN_EMERG "RIP%s %02x:<%016Lx> ",
-		       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
-		       m->cs, m->ip);
+		pr_emerg("RIP%s %02x:<%016Lx> ",
+			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+				m->cs, m->ip);
+
 		if (m->cs == __KERNEL_CS)
 			print_symbol("{%s}", m->ip);
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 	}
-	printk(KERN_EMERG "TSC %llx ", m->tsc);
+
+	pr_emerg("TSC %llx ", m->tsc);
 	if (m->addr)
-		printk(KERN_CONT "ADDR %llx ", m->addr);
+		pr_cont("ADDR %llx ", m->addr);
 	if (m->misc)
-		printk(KERN_CONT "MISC %llx ", m->misc);
-	printk(KERN_CONT "\n");
-	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-			m->cpuvendor, m->cpuid, m->time, m->socketid,
-			m->apicid);
+		pr_cont("MISC %llx ", m->misc);
+
+	pr_cont("\n");
+	pr_emerg("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
 
-	decode_mce(m);
+	/*
+	 * Print out human-readable details about the MCE error,
+	 * (if the CPU has an implementation for that):
+	 */
+	x86_mce_decode_callback(m);
 }
 
 static void print_mce_head(void)
 {
-	printk(KERN_EMERG "\nHARDWARE ERROR\n");
+	pr_emerg("\nHARDWARE ERROR\n");
 }
 
 static void print_mce_tail(void)
 {
-	printk(KERN_EMERG "This is not a software problem!\n"
-	       "Run through mcelog --ascii to decode and contact your hardware vendor\n");
+	pr_emerg("This is not a software problem!\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -218,6 +230,7 @@ static atomic_t mce_fake_paniced;
 static void wait_for_panic(void)
 {
 	long timeout = PANIC_TIMEOUT*USEC_PER_SEC;
+
 	preempt_disable();
 	local_irq_enable();
 	while (timeout-- > 0)
@@ -285,6 +298,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 static int msr_to_offset(u32 msr)
 {
 	unsigned bank = __get_cpu_var(injectm.bank);
+
 	if (msr == rip_msr)
 		return offsetof(struct mce, ip);
 	if (msr == MSR_IA32_MCx_STATUS(bank))
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 7a473bb..8701cd7 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -18,7 +18,7 @@ edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
 endif
 
 ifdef CONFIG_CPU_SUP_AMD
-edac_core-objs  += edac_mce_amd.o
+obj-$(CONFIG_X86_MCE)			+= edac_mce_amd.o
 endif
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 0c21c37..83a01a1 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -362,7 +362,7 @@ static inline void amd_decode_err_code(unsigned int ec)
 		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
 }
 
-void decode_mce(struct mce *m)
+static void amd_decode_mce(struct mce *m)
 {
 	struct err_regs regs;
 	int node, ecc;
@@ -420,3 +420,16 @@ void decode_mce(struct mce *m)
 
 	amd_decode_err_code(m->status & 0xffff);
 }
+
+static int __init mce_amd_init(void)
+{
+	/*
+	 * We can decode MCEs for Opteron and later CPUs:
+	 */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
+	    (boot_cpu_data.x86 >= 0xf))
+		x86_mce_decode_callback = amd_decode_mce;
+
+	return 0;
+}
+early_initcall(mce_amd_init);
