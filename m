Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZJGLVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZJGLVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbZJGLVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:21:00 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:17911
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758410AbZJGLU7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:20:59 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz14c3L655Nzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KR565G-04-AU4-02
X-M-MSG: 
Date: Wed, 7 Oct 2009 13:20:38 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <x86@aftab>, <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] mce, edac: use an atomic notifier for MCEs decoding
Message-ID: <20091007112038.GA2505@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 07 Oct 2009 11:20:01.0363 (UTC) FILETIME=[1C696A30:01CA4740]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an atomic notifier which ensures proper locking when conveying MCE
info to EDAC for decoding. The actual notifier call overrides a default,
negative priority notifier.

Note: make sure we register the default decoder only once since
mcheck_init() runs on each CPU.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20091003065752.GA8935@liondog.tnic>
---
 arch/x86/include/asm/mce.h       |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c |   30 +++++++++++++++++++++---------
 drivers/edac/edac_mce_amd.c      |   23 ++++++++++++++---------
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f1363b7..227a72d 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -108,6 +108,8 @@ struct mce_log {
 #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
 #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
 
+extern struct atomic_notifier_head x86_mce_decoder_chain;
+
 #ifdef __KERNEL__
 
 #include <linux/percpu.h>
@@ -213,6 +215,5 @@ extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 void intel_init_thermal(struct cpuinfo_x86 *c);
 
 void mce_log_therm_throt_event(__u64 status);
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..09c2e2e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -85,18 +85,26 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-static void default_decode_mce(struct mce *m)
+/*
+ * CPU/chipset specific EDAC code can register a notifier call here to print
+ * MCE errors in a human-readable form.
+ */
+ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
+EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
+
+static int default_decode_mce(struct notifier_block *nb, unsigned long val,
+			       void *data)
 {
 	pr_emerg("No human readable MCE decoding support on this CPU type.\n");
 	pr_emerg("Run the message through 'mcelog --ascii' to decode.\n");
+
+	return NOTIFY_STOP;
 }
 
-/*
- * CPU/chipset specific EDAC code can register a callback here to print
- * MCE errors in a human-readable form:
- */
-void (*x86_mce_decode_callback)(struct mce *m) = default_decode_mce;
-EXPORT_SYMBOL(x86_mce_decode_callback);
+static struct notifier_block mce_dec_nb = {
+	.notifier_call = default_decode_mce,
+	.priority      = -1,
+};
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -204,9 +212,9 @@ static void print_mce(struct mce *m)
 
 	/*
 	 * Print out human-readable details about the MCE error,
-	 * (if the CPU has an implementation for that):
+	 * (if the CPU has an implementation for that)
 	 */
-	x86_mce_decode_callback(m);
+	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
 }
 
 static void print_mce_head(void)
@@ -1420,6 +1428,10 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	mce_cpu_features(c);
 	mce_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
+
+	if (raw_smp_processor_id() == 0)
+		atomic_notifier_chain_register(&x86_mce_decoder_chain,
+					       &mce_dec_nb);
 }
 
 /*
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 713ed7d..6ee7529 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -3,7 +3,6 @@
 
 static bool report_gart_errors;
 static void (*nb_bus_decoder)(int node_id, struct err_regs *regs);
-static void (*orig_mce_callback)(struct mce *m);
 
 void amd_report_gart_errors(bool v)
 {
@@ -363,8 +362,10 @@ static inline void amd_decode_err_code(unsigned int ec)
 		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
 }
 
-static void amd_decode_mce(struct mce *m)
+static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
+			   void *data)
 {
+	struct mce *m = (struct mce *)data;
 	struct err_regs regs;
 	int node, ecc;
 
@@ -420,20 +421,23 @@ static void amd_decode_mce(struct mce *m)
 	}
 
 	amd_decode_err_code(m->status & 0xffff);
+
+	return NOTIFY_STOP;
 }
 
+static struct notifier_block amd_mce_dec_nb = {
+	.notifier_call	= amd_decode_mce,
+};
+
 static int __init mce_amd_init(void)
 {
 	/*
 	 * We can decode MCEs for Opteron and later CPUs:
 	 */
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
-	    (boot_cpu_data.x86 >= 0xf)) {
-		/* safe the default decode mce callback */
-		orig_mce_callback = x86_mce_decode_callback;
-
-		x86_mce_decode_callback = amd_decode_mce;
-	}
+	    (boot_cpu_data.x86 >= 0xf))
+		atomic_notifier_chain_register(&x86_mce_decoder_chain,
+					       &amd_mce_dec_nb);
 
 	return 0;
 }
@@ -442,7 +446,8 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
-	x86_mce_decode_callback = orig_mce_callback;
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain,
+					 &amd_mce_dec_nb);
 }
 
 MODULE_DESCRIPTION("AMD MCE decoder");
-- 
1.6.4.3


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

