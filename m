Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYFCToG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYFCToG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYFCTnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:43:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:38617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYFCTnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:43:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,585,1204531200"; 
   d="scan'208";a="390005119"
Date: Tue, 3 Jun 2008 12:43:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, j.mell@t-online.de,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       lguest <lguest@ozlabs.org>, andi@firstfloor.org
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080603194351.GD25114@linux-os.sc.intel.com>
References: <200806011101.06491.j.mell@t-online.de> <1212340262.5802.8.camel@odie.local> <20080602213136.GA25114@linux-os.sc.intel.com> <1212499410.2955.2.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212499410.2955.2.camel@odie.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 03:23:30PM +0200, Simon Holm Thøgersen wrote:
> > [patch] x86: fix blocking call (math_state_restore()) condition in __switch_to
> > 
> > Add tsk_used_math() checks to prevent calling math_state_restore()
> > which can sleep in the case of !tsk_used_math(). This prevents
> > making a blocking call in __switch_to().
> > 
> > Apparently "fpu_counter > 5" check is not enough, as in some signal handling
> > and fork/exec scenarios, fpu_counter > 5 and !tsk_used_math() is possible.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> Hi Suresh,
> 
> and thanks for looking into this. The patch did not fix the issue, but

Ok. You are probably running into different issue (please see below).
Above patch fixes a real issue and I think it should fix the fpu
corruption issue encountered by Jürgen. I will wait for Jürgen's test
results before pushing the above patch.

> I'm wondering if it is lguest calling math_state_restore in
> drivers/lguest/x86/core.c that could be the problem?

I def see a problem. In lguest_arch_run_guest(), MSR_IA32_SYSENTER_CS is not
restored before making the math_state_restore() call. As the
math_state_restore() can now block, this can cause issues. Appending
patch should fix this issue and from your oops report, it is not very
clear if the below patch should help fix your issue or not. Can you
please try the below appended patch.

> 
> Regardless of whether that is the issue, I think you (and everybody
> else) will be able to reproduce the issue by running lguest on a 32-bit
> system with CONFIG_PREEMPT=y and CONFIG_DEBUG_SPINLOCKS_SLEEP=y (I'm
> also using CONFIG_DEBUG_PREEMPT=y but I don't think that matter). If you
> download http://xm-test.xensource.com/ramdisks/initrd-1.1-i386.img and
> run
> 
> Documentation/lguest/lguest 64 vmlinux --block=initrd-1.1-i386.img
> 
> it will very likely trigger the backtraces I'm getting.

If the below patch doesn't help fix your issue, then I will try to reproduce
it locally here.

thanks,
suresh
---

[patch] x86, lguest: Restore MSR_IA32_SYSENTER_CS before math_state_restore()

Restore MSR_IA32_SYSENTER_CS before making the blocking math_state_restore()
in lguest_arch_run_guest()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 5126d5d..9279ce7 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -191,6 +191,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * was doing. */
 	run_guest_once(cpu, lguest_pages(raw_smp_processor_id()));
 
+	/* Restore SYSENTER if it's supposed to be on. */
+	if (boot_cpu_has(X86_FEATURE_SEP))
+		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+
 	/* Note that the "regs" structure contains two extra entries which are
 	 * not really registers: a trap number which says what interrupt or
 	 * trap made the switcher code come back, and an error code which some
@@ -203,13 +207,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	if (cpu->regs->trapnum == 14)
 		cpu->arch.last_pagefault = read_cr2();
 	/* Similarly, if we took a trap because the Guest used the FPU,
-	 * we have to restore the FPU it expects to see. */
+	 * we have to restore the FPU it expects to see. math_state_restore() can
+	 * re-enable interrupts and block. */
 	else if (cpu->regs->trapnum == 7)
 		math_state_restore();
-
-	/* Restore SYSENTER if it's supposed to be on. */
-	if (boot_cpu_has(X86_FEATURE_SEP))
-		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 }
 
 /*H:130 Now we've examined the hypercall code; our Guest can make requests.
