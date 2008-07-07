Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYGGT2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYGGT2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYGGT1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:27:15 -0400
Received: from 166.sub-75-208-119.myvzw.com ([75.208.119.166]:55584 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754627AbYGGT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:27:13 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 15:27:10 EDT
Message-Id: <20080707190838.399905143@goop.org>
References: <20080707190749.299430659@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 12:07:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 1/4] x86/paravirt: add hooks for spinlock operations
Content-Disposition: inline; filename=paravirt-spinlocks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ticket spinlocks have absolutely ghastly worst-case performance
characteristics in a virtual environment.  If there is any contention
for physical CPUs (ie, there are more runnable vcpus than cpus), then
ticket locks can cause the system to end up spending 90+% of its time
spinning.

The problem is that (v)cpus waiting on a ticket spinlock will be
granted access to the lock in strict order they got their tickets.  If
the hypervisor scheduler doesn't give the vcpus time in that order,
they will burn timeslices waiting for the scheduler to give the right
vcpu some time.  In the worst case it could take O(n^2) vcpu scheduler
timeslices for everyone waiting on the lock to get it, not counting
new cpus trying to take the lock while the log-jam is sorted out.

These hooks allow a paravirt backend to replace the spinlock
implementation.

At the very least, this could revert the implementation back to the
old lock algorithm, which allows the next scheduled vcpu to take the
lock, and has basically fairly good performance.

It also allows the spinlocks to take advantages of the hypervisor
features to make locks more efficient (spin and block, for example).

The cost to native execution is an extra direct call when using a
spinlock function.  There's no overhead if CONFIG_PARAVIRT is turned
off.

The lock structure is fixed at a single "unsigned int", initialized to
zero, but the spinlock implementation can use it as it wishes.

Thanks to Thomas Friebel's Xen Summit talk "Preventing Guests from
Spinning Around" for pointing out this problem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Thomas Friebel <thomas.friebel@amd.com>
---
 arch/x86/kernel/paravirt.c       |   10 ++++++
 include/asm-x86/paravirt.h       |   37 +++++++++++++++++++++++++
 include/asm-x86/spinlock.h       |   55 +++++++++++++++++++++++++++-----------
 include/asm-x86/spinlock_types.h |    2 -
 4 files changed, 88 insertions(+), 16 deletions(-)

===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -123,6 +123,7 @@
 		.pv_irq_ops = pv_irq_ops,
 		.pv_apic_ops = pv_apic_ops,
 		.pv_mmu_ops = pv_mmu_ops,
+		.pv_lock_ops = pv_lock_ops,
 	};
 	return *((void **)&tmpl + type);
 }
@@ -445,6 +446,15 @@
 	.set_fixmap = native_set_fixmap,
 };
 
+struct pv_lock_ops pv_lock_ops = {
+	.spin_is_locked = __ticket_spin_is_locked,
+	.spin_is_contended = __ticket_spin_is_contended,
+
+	.spin_lock = __ticket_spin_lock,
+	.spin_trylock = __ticket_spin_trylock,
+	.spin_unlock = __ticket_spin_unlock,
+};
+
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
 EXPORT_SYMBOL    (pv_mmu_ops);
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -329,6 +329,15 @@
 			   unsigned long phys, pgprot_t flags);
 };
 
+struct raw_spinlock;
+struct pv_lock_ops {
+	int (*spin_is_locked)(struct raw_spinlock *lock);
+	int (*spin_is_contended)(struct raw_spinlock *lock);
+	void (*spin_lock)(struct raw_spinlock *lock);
+	int (*spin_trylock)(struct raw_spinlock *lock);
+	void (*spin_unlock)(struct raw_spinlock *lock);
+};
+
 /* This contains all the paravirt structures: we get a convenient
  * number for each function using the offset which we use to indicate
  * what to patch. */
@@ -339,6 +348,7 @@
 	struct pv_irq_ops pv_irq_ops;
 	struct pv_apic_ops pv_apic_ops;
 	struct pv_mmu_ops pv_mmu_ops;
+	struct pv_lock_ops pv_lock_ops;
 };
 
 extern struct pv_info pv_info;
@@ -348,6 +358,7 @@
 extern struct pv_irq_ops pv_irq_ops;
 extern struct pv_apic_ops pv_apic_ops;
 extern struct pv_mmu_ops pv_mmu_ops;
+extern struct pv_lock_ops pv_lock_ops;
 
 #define PARAVIRT_PATCH(x)					\
 	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
@@ -1377,6 +1388,31 @@
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
+static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
+{
+	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
+}
+
+static inline int __raw_spin_is_contended(struct raw_spinlock *lock)
+{
+	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
+}
+
+static __always_inline void __raw_spin_lock(struct raw_spinlock *lock)
+{
+	return PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
+}
+
+static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
+{
+	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
+}
+
+static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
+{
+	return PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
+}
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
@@ -1461,6 +1497,7 @@
 	return f;
 }
 
+
 /* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
 #undef __PVOP_CALL
===================================================================
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -6,7 +6,7 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <linux/compiler.h>
-
+#include <asm/paravirt.h>
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
@@ -54,21 +54,21 @@
  * much between them in performance though, especially as locks are out of line.
  */
 #if (NR_CPUS < 256)
-static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
 	return (((tmp >> 8) & 0xff) != (tmp & 0xff));
 }
 
-static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
 	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
 }
 
-static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 {
 	short inc = 0x0100;
 
@@ -87,9 +87,7 @@
 		: "memory", "cc");
 }
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
 {
 	int tmp;
 	short new;
@@ -110,7 +108,7 @@
 	return tmp;
 }
 
-static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
 		     : "+m" (lock->slock)
@@ -118,21 +116,21 @@
 		     : "memory", "cc");
 }
 #else
-static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
 	return (((tmp >> 16) & 0xffff) != (tmp & 0xffff));
 }
 
-static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
 	return (((tmp >> 16) & 0xffff) - (tmp & 0xffff)) > 1;
 }
 
-static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 {
 	int inc = 0x00010000;
 	int tmp;
@@ -153,9 +151,7 @@
 		     : "memory", "cc");
 }
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
 {
 	int tmp;
 	int new;
@@ -177,7 +173,7 @@
 	return tmp;
 }
 
-static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
 		     : "+m" (lock->slock)
@@ -185,6 +181,35 @@
 		     : "memory", "cc");
 }
 #endif
+
+#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+
+#ifndef CONFIG_PARAVIRT
+static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+{
+	return __ticket_spin_is_locked(lock);
+}
+
+static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+{
+	return __ticket_spin_is_contended(lock);
+}
+
+static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
+{
+	__ticket_spin_lock(lock);
+}
+
+static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+{
+	return __ticket_spin_trylock(lock);
+}
+
+static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
+{
+	__ticket_spin_unlock(lock);
+}
+#endif	/* CONFIG_PARAVIRT */
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
===================================================================
--- a/include/asm-x86/spinlock_types.h
+++ b/include/asm-x86/spinlock_types.h
@@ -5,7 +5,7 @@
 # error "please don't include this file directly"
 #endif
 
-typedef struct {
+typedef struct raw_spinlock {
 	unsigned int slock;
 } raw_spinlock_t;
 

-- 

