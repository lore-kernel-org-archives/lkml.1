Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZI3VtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZI3VtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZI3VtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:49:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46292 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbZI3VtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:49:09 -0400
Date: Wed, 30 Sep 2009 23:48:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       torvalds@osdl.org
Subject: Re: x86: mce: Please revert
	22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20090930214859.GA28638@elte.hu>
References: <20090930140904.GA6150@one.firstfloor.org> <20090930194049.GA17712@liondog.tnic> <20090930204643.GA24862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930204643.GA24862@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > On Wed, Sep 30, 2009 at 04:09:04PM +0200, Andi Kleen wrote:
> > > 
> > > Can someone please revert this incorrect commit that's in mainline
> > > now? 
> > > 
> > > Obviously kernels compiled with AMD support can still run on non
> > > AMD systems, so messages like this can never be removed at compile time.
> > > 
> > > -andi
> > > 
> > > Commit 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
> > > Author: Borislav Petkov <borislav.petkov@amd.com>
> > > Date:   Tue Jul 28 14:47:10 2009 +0200
> > > 
> > >     x86, mce: do not compile mcelog message on AMD
> > >     
> > >     Now that decoding is done in-kernel, suppress mcelog message part.
> > >     
> > >     CC: Andi Kleen <andi@firstfloor.org>
> > >     Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > > index b82866f..9bfe9d2 100644
> > > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > > @@ -222,7 +222,10 @@ static void print_mce_head(void)
> > >  static void print_mce_tail(void)
> > >  {
> > >         printk(KERN_EMERG "This is not a software problem!\n"
> > > -              "Run through mcelog --ascii to decode and contact your hardware vendor\n");
> > > +#if (!defined(CONFIG_EDAC) || !defined(CONFIG_CPU_SUP_AMD))
> > 
> > how about
> > 
> > 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> > 		pr_emerg("Run through mcelog --ascii to decode and contact your	hardware vendor\n");
> > 
> > instead?
> 
> Yeah, a runtime check like that would be fine - but i'd suggest 
> something more clearly and more specifically connected to in-kernel 
> decoding: please define a new x86_mce_can_decode_errors capability 
> flag or so.
> 
> Obviously the Intel CPU side should be fixed and improved to decode 
> MCE errors in the kernel too.
> 
> Please also fix that printk to say something like:
> 
>   "MCE error decoding not supported on this CPU: run through mcelog --ascii to decode\n"
> 
> Thanks,

I.e. something like the patch below. Completely untested.

Note, while looking at the interaction of decode_mce() with the other 
MCE code i also noticed a few other things and made the following 
cleanups/fixes:

 - Fixed the mce_decode() weak alias - a weak alias is really not good
   here, it should be a proper callback. A weak alias will be overriden
   if a piece of code is built into the kernel - not good, obviously.

 - The patch initializes the callback on AMD family 10h and 11h - a
   quick glance suggests that decoding of earlier models isnt supported?

 - Added the more correct fallback printk of:

	No support for human readable MCE decoding on this CPU type.
	Transcribe the message and run it through 'mcelog --ascii' to decode.

   On CPUs that dont have a decoder.

 - Made the surrounding code more readable.

Note that the callback allows us to have a default fallback - without 
having to check the CPU versions during the printout itself. When an 
EDAC module registers itself, it can install the decode-print function.

(there's no unregister needed as this is core code.)

	Ingo

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index b608a64..f52d219 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -133,6 +133,8 @@ static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void enable_p5_mce(void) {}
 #endif
 
+extern void (*x86_decode_mce_callback)(struct mce *m);
+
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 183c345..adc8e2a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -85,6 +85,18 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
+static void default_decode_mce(struct mce *m)
+{
+	pr_emerg("No support for human readable MCE decoding on this CPU type.\n");
+	pr_emerg("Transcribe the message and run it through 'mcelog --ascii' to decode.\n");
+}
+
+/*
+ * CPU/chipset specific EDAC code can register a callback here to print
+ * MCE errors in a human-readable form:
+ */
+void (*x86_decode_mce_callback)(struct mce *m) = default_decode_mce;
+EXPORT_SYMBOL(x86_decode_mce_callback);
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -165,46 +177,47 @@ void mce_log(struct mce *mce)
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
+		pr_emerg("RIP%s %02x:<%016Lx> ",
 		       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
 		       m->cs, m->ip);
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
+		pr_cont("MISC %llx ", m->misc);
+
+	pr_cont("\n");
+	pr_emerg("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 			m->cpuvendor, m->cpuid, m->time, m->socketid,
 			m->apicid);
 
-	decode_mce(m);
+	/*
+	 * Print out human-readable details about the MCE error,
+	 * (if the CPU has an implementation for that):
+	 */
+	x86_decode_mce_callback(m);
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
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 0c21c37..4fee380 100644
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
@@ -420,3 +420,15 @@ void decode_mce(struct mce *m)
 
 	amd_decode_err_code(m->status & 0xffff);
 }
+
+static __init int mce_amd_init(void)
+{
+	/*
+	 * We can decode MCEs for Opteron and later CPUs:
+	 */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && (boot_cpu_data.x86 >= 0x10))
+		x86_mce_decode_callback = amd_decode;
+
+	return 0;
+}
+early_initcall(mce_amd_init);
