Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbYFQXug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbYFQXug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYFQXuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:50:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:27286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYFQXuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:50:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,661,1204531200"; 
   d="scan'208";a="579034327"
Date: Tue, 17 Jun 2008 16:50:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
       rusty@rustcorp.com.au
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Message-ID: <20080617235022.GA23370@linux-os.sc.intel.com>
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com> <1213611339.2495.11.camel@odie.local> <20080616174948.GB7788@linux-os.sc.intel.com> <1213651283.2495.46.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1213651283.2495.46.camel@odie.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 02:21:23PM -0700, Simon Holm Thøgersen wrote:
> > Can you please upload it some where? I will also try with another guest
> > image meanwhile.
> >
> [access provided to Suresh in private email]

Simon, Thanks.

Simon, Patrick, I am able to reproduce the oops in __switch_to()
with lguest.  My debug showed that there is atleast one lguest specific
issue (which should be present in 2.6.25 and before aswell) and it got
exposed with a kernel oops with the recent fpu dynamic allocation patches.

In addition to the previous possible scenario (with fpu_counter), in the
presence of lguest, it is possible that the cpu's TS bit it still set and the
lguest launcher task's thread_info has TS_USEDFPU still set.

This is because of the way the lguest launcher handling the guest's TS bit.
(look at lguest_set_ts() in lguest_arch_run_guest()). This can result
in a DNA fault while doing unlazy_fpu() in __switch_to(). This will
end up causing a DNA fault in the context of new process thats
getting context switched in (as opossed to handling DNA fault in the context
of lguest launcher/helper process).

This is wrong in both pre and post 2.6.25 kernels. In the recent
2.6.26-rc series, this is showing up as NULL pointer dereferences or
sleeping function called from atomic context(__switch_to()), as
we free and dynamically allocate the FPU context for the newly
created threads. Older kernels might show some FPU corruption for processes
running inside of lguest.

With the appended patch, my test system is running for more than 50 mins
now. So atleast some of your oops (hopefully all!) should get fixed.
Please give it a try. I will spend more time with this fix tomorrow.

Apart from the last hunk(MSR_IA32_SYSENTER_CS changes), I believe
the below patch is needed for 2.6.25 aswell.

Thanks.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6d54833..e2db9ac 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -333,6 +333,7 @@ void flush_thread(void)
 	/*
 	 * Forget coprocessor state..
 	 */
+	tsk->fpu_counter = 0;
 	clear_fpu(tsk);
 	clear_used_math();
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ac54ff5..c6eb5c9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -294,6 +294,7 @@ void flush_thread(void)
 	/*
 	 * Forget coprocessor state..
 	 */
+	tsk->fpu_counter = 0;
 	clear_fpu(tsk);
 	clear_used_math();
 }
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 5126d5d..4a98404 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -176,7 +176,7 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU. */
 	if (cpu->ts)
-		lguest_set_ts();
+		unlazy_fpu(current);
 
 	/* SYSENTER is an optimized way of doing system calls.  We can't allow
 	 * it because it always jumps to privilege level 0.  A normal Guest
@@ -196,6 +196,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * trap made the switcher code come back, and an error code which some
 	 * traps set.  */
 
+	/* Restore SYSENTER if it's supposed to be on. */
+	if (boot_cpu_has(X86_FEATURE_SEP))
+		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+
 	/* If the Guest page faulted, then the cr2 register will tell us the
 	 * bad virtual address.  We have to grab this now, because once we
 	 * re-enable interrupts an interrupt could fault and thus overwrite
@@ -203,13 +207,12 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	if (cpu->regs->trapnum == 14)
 		cpu->arch.last_pagefault = read_cr2();
 	/* Similarly, if we took a trap because the Guest used the FPU,
-	 * we have to restore the FPU it expects to see. */
+	 * we have to restore the FPU it expects to see.
+	 * math_state_restore() may sleep and we may even move off to
+	 * a different CPU. So all the critical stuff should be done
+	 * before this.  */
 	else if (cpu->regs->trapnum == 7)
 		math_state_restore();
-
-	/* Restore SYSENTER if it's supposed to be on. */
-	if (boot_cpu_has(X86_FEATURE_SEP))
-		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 }
 
 /*H:130 Now we've examined the hypercall code; our Guest can make requests.
