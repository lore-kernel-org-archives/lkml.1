Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbXICUPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbXICUPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbXICUOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:14:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbXICUOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:14:53 -0400
Subject: Re: [PATCH] Fix preemptible lazy mode bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Zachary Amsden <zach@vmware.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <46D9D517.6010201@goop.org>
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>
	 <46CE81DC.90103@vmware.com>  <46D9D517.6010201@goop.org>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 06:14:28 +1000
Message-Id: <1188850468.10802.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 14:09 -0700, Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
> > Do you agree it is better to be safe than sorry in this case?  The
> > kind of bugs introduced by getting this wrong are really hard to find,
> > and I would rather err on the side of an extra increment and decrement
> > of preempt_count that causing a regression.
> 
> I think this patch is the direction we should go.  I this this would
> work equally well for the other pv implementations; it would probably go
> into the common lazy mode logic when we get around to doing it.

Well, here's the (untested) hoisting patch...
===
Hoist per-cpu lazy_mode variable up into common code.

VMI, Xen and lguest all track paravirt_lazy_mode individually, meaning
we hand a "magic" value for set_lazy_mode() to say "flush if currently
active".

We can simplify the logic by hoisting this variable into common code.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 072a0b3924fb arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c	Thu Aug 30 04:47:43 2007 +1000
+++ b/arch/i386/kernel/vmi.c	Tue Sep 04 05:36:11 2007 +1000
@@ -554,22 +554,14 @@ vmi_startup_ipi_hook(int phys_apicid, un
 
 static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	static DEFINE_PER_CPU(enum paravirt_lazy_mode, lazy_mode);
-
 	if (!vmi_ops.set_lazy_mode)
 		return;
 
 	/* Modes should never nest or overlap */
-	BUG_ON(__get_cpu_var(lazy_mode) && !(mode == PARAVIRT_LAZY_NONE ||
-					     mode == PARAVIRT_LAZY_FLUSH));
-
-	if (mode == PARAVIRT_LAZY_FLUSH) {
-		vmi_ops.set_lazy_mode(0);
-		vmi_ops.set_lazy_mode(__get_cpu_var(lazy_mode));
-	} else {
-		vmi_ops.set_lazy_mode(mode);
-		__get_cpu_var(lazy_mode) = mode;
-	}
+	BUG_ON(get_lazy_mode() && !(mode == PARAVIRT_LAZY_NONE |
+				    | mode == PARAVIRT_LAZY_FLUSH));
+
+	vmi_ops.set_lazy_mode(mode);
 }
 
 static inline int __init check_vmi_rom(struct vrom_header *rom)
diff -r 072a0b3924fb arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c	Thu Aug 30 04:47:43 2007 +1000
+++ b/arch/i386/xen/enlighten.c	Tue Sep 04 05:37:14 2007 +1000
@@ -52,8 +52,6 @@
 
 EXPORT_SYMBOL_GPL(hypercall_page);
 
-DEFINE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
-
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DEFINE_PER_CPU(unsigned long, xen_cr3);
@@ -255,23 +253,16 @@ static void xen_set_lazy_mode(enum parav
 
 	switch (mode) {
 	case PARAVIRT_LAZY_NONE:
-		BUG_ON(x86_read_percpu(xen_lazy_mode) == PARAVIRT_LAZY_NONE);
+		BUG_ON(get_lazy_mode() == PARAVIRT_LAZY_NONE);
 		break;
 
 	case PARAVIRT_LAZY_MMU:
 	case PARAVIRT_LAZY_CPU:
-		BUG_ON(x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE);
+		BUG_ON(get_lazy_mode() != PARAVIRT_LAZY_NONE);
 		break;
-
-	case PARAVIRT_LAZY_FLUSH:
-		/* flush if necessary, but don't change state */
-		if (x86_read_percpu(xen_lazy_mode) != PARAVIRT_LAZY_NONE)
-			xen_mc_flush();
-		return;
 	}
 
 	xen_mc_flush();
-	x86_write_percpu(xen_lazy_mode, mode);
 }
 
 static unsigned long xen_store_tr(void)
@@ -358,7 +349,7 @@ static void xen_load_tls(struct thread_s
 	 * loaded properly.  This will go away as soon as Xen has been
 	 * modified to not save/restore %gs for normal hypercalls.
 	 */
-	if (xen_get_lazy_mode() == PARAVIRT_LAZY_CPU)
+	if (x86_read_percpu(paravirt_lazy_mode) == PARAVIRT_LAZY_CPU)
 		loadsegment(gs, 0);
 }
 
diff -r 072a0b3924fb arch/i386/xen/multicalls.h
--- a/arch/i386/xen/multicalls.h	Thu Aug 30 04:47:43 2007 +1000
+++ b/arch/i386/xen/multicalls.h	Tue Sep 04 05:37:52 2007 +1000
@@ -35,7 +35,7 @@ void xen_mc_flush(void);
 /* Issue a multicall if we're not in a lazy mode */
 static inline void xen_mc_issue(unsigned mode)
 {
-	if ((xen_get_lazy_mode() & mode) == 0)
+	if ((get_lazy_mode() & mode) == 0)
 		xen_mc_flush();
 
 	/* restore flags saved in xen_mc_batch */
diff -r 072a0b3924fb arch/i386/xen/xen-ops.h
--- a/arch/i386/xen/xen-ops.h	Thu Aug 30 04:47:43 2007 +1000
+++ b/arch/i386/xen/xen-ops.h	Tue Sep 04 05:29:20 2007 +1000
@@ -29,13 +29,6 @@ unsigned long long xen_sched_clock(void)
 
 void xen_mark_init_mm_pinned(void);
 
-DECLARE_PER_CPU(enum paravirt_lazy_mode, xen_lazy_mode);
-
-static inline unsigned xen_get_lazy_mode(void)
-{
-	return x86_read_percpu(xen_lazy_mode);
-}
-
 void __init xen_fill_possible_map(void);
 
 void __init xen_setup_vcpu_info_placement(void);
diff -r 072a0b3924fb drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Thu Aug 30 04:47:43 2007 +1000
+++ b/drivers/lguest/lguest.c	Tue Sep 04 05:32:24 2007 +1000
@@ -93,8 +93,8 @@ static cycle_t clock_base;
 /*G:035 Notice the lazy_hcall() above, rather than hcall().  This is our first
  * real optimization trick!
  *
- * When lazy_mode is set, it means we're allowed to defer all hypercalls and do
- * them as a batch when lazy_mode is eventually turned off.  Because hypercalls
+ * When lazy mode is set, it means we're allowed to defer all hypercalls and do
+ * them as a batch when lazy mode is eventually turned off.  Because hypercalls
  * are reasonably expensive, batching them up makes sense.  For example, a
  * large mmap might update dozens of page table entries: that code calls
  * lguest_lazy_mode(PARAVIRT_LAZY_MMU), does the dozen updates, then calls
@@ -102,24 +102,11 @@ static cycle_t clock_base;
  *
  * So, when we're in lazy mode, we call async_hypercall() to store the call for
  * future processing.  When lazy mode is turned off we issue a hypercall to
- * flush the stored calls.
- *
- * There's also a hack where "mode" is set to "PARAVIRT_LAZY_FLUSH" which
- * indicates we're to flush any outstanding calls immediately.  This is used
- * when an interrupt handler does a kmap_atomic(): the page table changes must
- * happen immediately even if we're in the middle of a batch.  Usually we're
- * not, though, so there's nothing to do. */
-static enum paravirt_lazy_mode lazy_mode; /* Note: not SMP-safe! */
+ * flush the stored calls. */
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	if (mode == PARAVIRT_LAZY_FLUSH) {
-		if (unlikely(lazy_mode != PARAVIRT_LAZY_NONE))
-			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	} else {
-		lazy_mode = mode;
-		if (mode == PARAVIRT_LAZY_NONE)
-			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	}
+	if (mode == PARAVIRT_LAZY_NONE)
+		hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
 }
 
 static void lazy_hcall(unsigned long call,
@@ -127,7 +114,7 @@ static void lazy_hcall(unsigned long cal
 		       unsigned long arg2,
 		       unsigned long arg3)
 {
-	if (lazy_mode == PARAVIRT_LAZY_NONE)
+	if (get_lazy_mode() == PARAVIRT_LAZY_NONE)
 		hcall(call, arg1, arg2, arg3);
 	else
 		async_hcall(call, arg1, arg2, arg3);
diff -r 072a0b3924fb include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Thu Aug 30 04:47:43 2007 +1000
+++ b/include/asm-i386/paravirt.h	Tue Sep 04 05:31:47 2007 +1000
@@ -30,7 +30,6 @@ enum paravirt_lazy_mode {
 	PARAVIRT_LAZY_NONE = 0,
 	PARAVIRT_LAZY_MMU = 1,
 	PARAVIRT_LAZY_CPU = 2,
-	PARAVIRT_LAZY_FLUSH = 3,
 };
 
 struct paravirt_ops
@@ -903,36 +902,47 @@ static inline void set_pmd(pmd_t *pmdp, 
 #endif	/* CONFIG_X86_PAE */
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+DECLARE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode);
+static inline enum paravirt_lazy_mode get_lazy_mode(void)
+{
+	return x86_read_percpu(paravirt_lazy_mode);
+}
+
 static inline void arch_enter_lazy_cpu_mode(void)
 {
 	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_CPU);
+	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_CPU);
 }
 
 static inline void arch_leave_lazy_cpu_mode(void)
 {
 	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE);
+	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 static inline void arch_flush_lazy_cpu_mode(void)
 {
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
-}
-
+	if (unlikely(__get_cpu_var(paravirt_lazy_mode) == PARAVIRT_LAZY_CPU))
+		arch_leave_lazy_cpu_mode();
+}
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_MMU);
+	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_MMU);
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE);
+	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
-	PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_FLUSH);
+	if (unlikely(__get_cpu_var(paravirt_lazy_mode) == PARAVIRT_LAZY_MMU))
+		arch_leave_lazy_mmu_mode();
 }
 
 void _paravirt_nop(void);


