Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbZEOSTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbZEOSTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZEOSTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:19:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:36797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZEOSTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:19:38 -0400
Date: Fri, 15 May 2009 18:18:34 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jeremy.fitzhardinge@citrix.com, npiggin@suse.de, jeremy@goop.org,
       xiaohui.xin@intel.com, xin.li@intel.com, tglx@linutronix.de,
       mingo@elte.hu, xen-devel@lists.xensource.com, jun.nakajima@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, npiggin@suse.de, jeremy@goop.org,
       xiaohui.xin@intel.com, xin.li@intel.com, tglx@linutronix.de,
       jun.nakajima@intel.com, xen-devel@lists.xensource.com, mingo@elte.hu
In-Reply-To: <4A0B62F7.5030802@goop.org>
References: <4A0B62F7.5030802@goop.org>
Subject: [tip:x86/urgent] x86: Fix performance regression caused by paravirt_ops on native kernels
Message-ID: <tip-b4ecc126991b30fe5f9a59dfacda046aeac124b2@git.kernel.org>
Git-Commit-ID: b4ecc126991b30fe5f9a59dfacda046aeac124b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 18:18:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4ecc126991b30fe5f9a59dfacda046aeac124b2
Gitweb:     http://git.kernel.org/tip/b4ecc126991b30fe5f9a59dfacda046aeac124b2
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Wed, 13 May 2009 17:16:55 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 20:07:42 +0200

x86: Fix performance regression caused by paravirt_ops on native kernels

Xiaohui Xin and some other folks at Intel have been looking into what's
behind the performance hit of paravirt_ops when running native.

It appears that the hit is entirely due to the paravirtualized
spinlocks introduced by:

 | commit 8efcbab674de2bee45a2e4cdf97de16b8e609ac8
 | Date:   Mon Jul 7 12:07:51 2008 -0700
 |
 |     paravirt: introduce a "lock-byte" spinlock implementation

The extra call/return in the spinlock path is somehow
causing an increase in the cycles/instruction of somewhere around 2-7%
(seems to vary quite a lot from test to test).  The working theory is
that the CPU's pipeline is getting upset about the
call->call->locked-op->return->return, and seems to be failing to
speculate (though I haven't seen anything definitive about the precise
reasons).  This doesn't entirely make sense, because the performance
hit is also visible on unlock and other operations which don't involve
locked instructions.  But spinlock operations clearly swamp all the
other pvops operations, even though I can't imagine that they're
nearly as common (there's only a .05% increase in instructions
executed).

If I disable just the pv-spinlock calls, my tests show that pvops is
identical to non-pvops performance on native (my measurements show that
it is actually about .1% faster, but Xiaohui shows a .05% slowdown).

Summary of results, averaging 10 runs of the "mmperf" test, using a
no-pvops build as baseline:

		nopv		Pv-nospin	Pv-spin
CPU cycles	100.00%		99.89%		102.18%
instructions	100.00%		100.10%		100.15%
CPI		100.00%		99.79%		102.03%
cache ref	100.00%		100.84%		100.28%
cache miss	100.00%		90.47%		88.56%
cache miss rate	100.00%		89.72%		88.31%
branches	100.00%		99.93%		100.04%
branch miss	100.00%		103.66%		107.72%
branch miss rt	100.00%		103.73%		107.67%
wallclock	100.00%		99.90%		102.20%

The clear effect here is that the 2% increase in CPI is
directly reflected in the final wallclock time.

(The other interesting effect is that the more ops are
out of line calls via pvops, the lower the cache access
and miss rates.  Not too surprising, but it suggests that
the non-pvops kernel is over-inlined.  On the flipside,
the branch misses go up correspondingly...)

So, what's the fix?

Paravirt patching turns all the pvops calls into direct calls, so
_spin_lock etc do end up having direct calls.  For example, the compiler
generated code for paravirtualized _spin_lock is:

<_spin_lock+0>:		mov    %gs:0xb4c8,%rax
<_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
<_spin_lock+15>:	callq  *0xffffffff805a5b30
<_spin_lock+22>:	retq

The indirect call will get patched to:
<_spin_lock+0>:		mov    %gs:0xb4c8,%rax
<_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
<_spin_lock+15>:	callq <__ticket_spin_lock>
<_spin_lock+20>:	nop; nop		/* or whatever 2-byte nop */
<_spin_lock+22>:	retq

One possibility is to inline _spin_lock, etc, when building an
optimised kernel (ie, when there's no spinlock/preempt
instrumentation/debugging enabled).  That will remove the outer
call/return pair, returning the instruction stream to a single
call/return, which will presumably execute the same as the non-pvops
case.  The downsides arel 1) it will replicate the
preempt_disable/enable code at eack lock/unlock callsite; this code is
fairly small, but not nothing; and 2) the spinlock definitions are
already a very heavily tangled mass of #ifdefs and other preprocessor
magic, and making any changes will be non-trivial.

The other obvious answer is to disable pv-spinlocks.  Making them a
separate config option is fairly easy, and it would be trivial to
enable them only when Xen is enabled (as the only non-default user).
But it doesn't really address the common case of a distro build which
is going to have Xen support enabled, and leaves the open question of
whether the native performance cost of pv-spinlocks is worth the
performance improvement on a loaded Xen system (10% saving of overall
system CPU when guests block rather than spin).  Still it is a
reasonable short-term workaround.

[ Impact: fix pvops performance regression when running native ]

Analysed-by: "Xin Xiaohui" <xiaohui.xin@intel.com>
Analysed-by: "Li Xin" <xin.li@intel.com>
Analysed-by: "Nakajima Jun" <jun.nakajima@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Xen-devel <xen-devel@lists.xensource.com>
LKML-Reference: <4A0B62F7.5030802@goop.org>
[ fixed the help text ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig                |   13 +++++++++++++
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/include/asm/spinlock.h |    4 ++--
 arch/x86/kernel/Makefile        |    3 ++-
 arch/x86/kernel/paravirt.c      |    2 ++
 arch/x86/xen/Makefile           |    5 +++--
 arch/x86/xen/xen-ops.h          |   19 +++++++++++++++----
 7 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..a6efe0a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -498,6 +498,19 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
+config PARAVIRT_SPINLOCKS
+	bool "Paravirtualization layer for spinlocks"
+	depends on PARAVIRT && SMP && EXPERIMENTAL
+	---help---
+	  Paravirtualized spinlocks allow a pvops backend to replace the
+	  spinlock implementation with something virtualization-friendly
+	  (for example, block the virtual CPU rather than spinning).
+
+	  Unfortunately the downside is an up to 5% performance hit on
+	  native kernels, with various workloads.
+
+	  If you are unsure how to answer this question, answer N.
+
 config PARAVIRT_CLOCK
 	bool
 	default n
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 378e369..a53da00 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -1443,7 +1443,7 @@ u64 _paravirt_ident_64(u64);
 
 #define paravirt_nop	((void *)_paravirt_nop)
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
 static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
 {
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index e5e6caf..b7e5db8 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,7 +172,7 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }
 
-#ifndef CONFIG_PARAVIRT
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
 
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
@@ -206,7 +206,7 @@ static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
 	__raw_spin_lock(lock);
 }
 
-#endif
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 145cce7..88d1bfc 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -89,7 +89,8 @@ obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o paravirt-spinlocks.o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 8e45f44..9faf43b 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -134,7 +134,9 @@ static void *get_call_destination(u8 type)
 		.pv_irq_ops = pv_irq_ops,
 		.pv_apic_ops = pv_apic_ops,
 		.pv_mmu_ops = pv_mmu_ops,
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
 		.pv_lock_ops = pv_lock_ops,
+#endif
 	};
 	return *((void **)&tmpl + type);
 }
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3b767d0..172438f 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -9,5 +9,6 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			time.o xen-asm.o xen-asm_$(BITS).o \
 			grant-table.o suspend.o
 
-obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_SMP)		+= smp.o
+obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 2013946..ca6596b 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -62,15 +62,26 @@ void xen_setup_vcpu_info_placement(void);
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
 
-void __init xen_init_spinlocks(void);
-__cpuinit void xen_init_lock_cpu(int cpu);
-void xen_uninit_lock_cpu(int cpu);
-
 extern cpumask_var_t xen_cpu_initialized_map;
 #else
 static inline void xen_smp_init(void) {}
 #endif
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+void __init xen_init_spinlocks(void);
+__cpuinit void xen_init_lock_cpu(int cpu);
+void xen_uninit_lock_cpu(int cpu);
+#else
+static inline void xen_init_spinlocks(void)
+{
+}
+static inline void xen_init_lock_cpu(int cpu)
+{
+}
+static inline void xen_uninit_lock_cpu(int cpu)
+{
+}
+#endif
 
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
