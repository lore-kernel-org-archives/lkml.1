Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbZJCG55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbZJCG55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 02:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZJCG54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 02:57:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:49240 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZJCG5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 02:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=b5ot1w+RoH0Pnp4M8ZOphZy2XEp+h3hpYbrFw/3vp88tYuLzTyuR2tGMdtaJPxHK1K
         8+DUBWACc9egEIJYi/IrvvfjrB1do1sdRZ211vxS9/uWTyZ0X5r0O1NeWVanI1o2AB3E
         eH9GdA4NHLIgygjFWH2QByfBuz+FDbTIKCIBI=
Date: Sat, 3 Oct 2009 08:57:52 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic
Message-ID: <20091003065752.GA8935@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
 <20091001144637.GB11410@aftab>
 <20091001150046.GA21476@elte.hu>
 <20091001152140.GC11410@aftab>
 <20091001153250.GA25885@elte.hu>
 <20091002132101.GA28682@aftab>
 <20091002133148.GD28682@aftab>
 <20091002133954.GA29390@elte.hu>
 <20091002182659.GA16436@aftab>
 <20091002184714.GA21509@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091002184714.GA21509@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 08:47:14PM +0200, Ingo Molnar wrote:
> No, the locking was all that i meant. Using atomic_notifier would solve 
> that. Make the default decoder low-prio, that way there's no need to do 
> the callback save/restore sequence either.

Ok, how's that for starters, it has been only compile-tested and it
looks straight-forward enough to me...

--
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index f1363b7..9bb1756 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -214,5 +214,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c);
 
 void mce_log_therm_throt_event(__u64 status);
 
+int mce_register_decoder_notifier(struct notifier_block *nb);
+int mce_unregister_decoder_notifier(struct notifier_block *nb);
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b1598a9..e767cce 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -85,18 +85,36 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-static void default_decode_mce(struct mce *m)
+static ATOMIC_NOTIFIER_HEAD(mce_decoder_chain);
+
+/*
+ * CPU/chipset specific EDAC code can register a notifier call here to print
+ * MCE errors in a human-readable form.
+ */
+int mce_register_decoder_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&mce_decoder_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_register_decoder_notifier);
+
+int mce_unregister_decoder_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&mce_decoder_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_unregister_decoder_notifier);
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
+};
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -204,9 +222,9 @@ static void print_mce(struct mce *m)
 
 	/*
 	 * Print out human-readable details about the MCE error,
-	 * (if the CPU has an implementation for that):
+	 * (if the CPU has an implementation for that)
 	 */
-	x86_mce_decode_callback(m);
+	atomic_notifier_call_chain(&mce_decoder_chain, 0, m);
 }
 
 static void print_mce_head(void)
@@ -1420,6 +1438,8 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	mce_cpu_features(c);
 	mce_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
+
+	mce_register_decoder_notifier(&mce_dec_nb);
 }
 
 /*
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 713ed7d..aa0061e 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -363,8 +363,10 @@ static inline void amd_decode_err_code(unsigned int ec)
 		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
 }
 
-static void amd_decode_mce(struct mce *m)
+static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
+			   void *data)
 {
+	struct mce *m = (struct mce *)data;
 	struct err_regs regs;
 	int node, ecc;
 
@@ -420,20 +422,23 @@ static void amd_decode_mce(struct mce *m)
 	}
 
 	amd_decode_err_code(m->status & 0xffff);
+
+	return NOTIFY_STOP;
 }
 
+static struct notifier_block amd_mce_dec_nb = {
+	.notifier_call	= amd_decode_mce,
+	.priority	= 100,
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
+		mce_register_decoder_notifier(&amd_mce_dec_nb);
 
 	return 0;
 }
@@ -442,7 +447,7 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
-	x86_mce_decode_callback = orig_mce_callback;
+	mce_unregister_decoder_notifier(&amd_mce_dec_nb);
 }
 
 MODULE_DESCRIPTION("AMD MCE decoder");


-- 
Regards/Gruss,
    Boris.
