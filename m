Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbZJPM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbZJPM4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZJPM4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:56:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50598 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbZJPM4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:56:31 -0400
Date: Fri, 16 Oct 2009 12:55:19 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20091003065752.GA8935@liondog.tnic>
References: <20091003065752.GA8935@liondog.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/mce] mce, edac: Use an atomic notifier for MCEs decoding
Message-ID: <tip-fb2531953fd8855abdcf458459020fd382c5deca@git.kernel.org>
Git-Commit-ID: fb2531953fd8855abdcf458459020fd382c5deca
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 12:55:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb2531953fd8855abdcf458459020fd382c5deca
Gitweb:     http://git.kernel.org/tip/fb2531953fd8855abdcf458459020fd382c5deca
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 7 Oct 2009 13:20:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 12:24:45 +0200

mce, edac: Use an atomic notifier for MCEs decoding

Add an atomic notifier which ensures proper locking when conveying
MCE info to EDAC for decoding. The actual notifier call overrides a
default, negative priority notifier.

Note: make sure we register the default decoder only once since
mcheck_init() runs on each CPU.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20091003065752.GA8935@liondog.tnic>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mce.h       |    3 ++-
 arch/x86/kernel/cpu/mcheck/mce.c |   29 ++++++++++++++++++++---------
 drivers/edac/edac_mce_amd.c      |   21 ++++++++++++---------
 3 files changed, 34 insertions(+), 19 deletions(-)

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
index b1598a9..15ba9c9 100644
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
@@ -1420,6 +1428,9 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	mce_cpu_features(c);
 	mce_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
+
+	if (raw_smp_processor_id() == 0)
+		atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
 }
 
 /*
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 713ed7d..689cc6a 100644
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
 
@@ -420,20 +421,22 @@ static void amd_decode_mce(struct mce *m)
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
+		atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 
 	return 0;
 }
@@ -442,7 +445,7 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
-	x86_mce_decode_callback = orig_mce_callback;
+	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 }
 
 MODULE_DESCRIPTION("AMD MCE decoder");
