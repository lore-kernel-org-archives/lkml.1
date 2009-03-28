Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZC1NMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZC1NMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZC1NMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:12:05 -0400
Received: from ozlabs.org ([203.10.76.45]:52495 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZC1NL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:11:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest and virtio patches
Date: Sat, 28 Mar 2009 23:41:54 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282341.54810.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5d80f8e5a9dc9c9a94d4aeaa567e219a808b8a4a:             
  Linus Torvalds (1):                                                                    
        Merge git://git.kernel.org/.../davem/net-2.6                                     

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest-and-virtio.git master

Matias Zabaljauregui (2):
      lguest: use KVM hypercalls
      lguest: use bool instead of int

Roel Kluin (1):
      virtio: fix BAD_RING, START_US and END_USE macros

Rusty Russell (5):
      virtio: more neatening of virtio_ring macros.
      lguest: fix spurious BUG_ON() on invalid guest stack.
      lguest: wire up pte_update/pte_update_defer
      lguest: avoid accidental recycling of pgdir pages
      lguest: barrier me harder

 Documentation/lguest/lguest.c         |    7 +++
 arch/x86/include/asm/lguest_hcall.h   |   25 ++-------
 arch/x86/lguest/boot.c                |   94 +++++++++++++++++++++++----------
 arch/x86/lguest/i386_head.S           |    4 +-
 drivers/lguest/core.c                 |    4 +-
 drivers/lguest/hypercalls.c           |    3 +
 drivers/lguest/interrupts_and_traps.c |   28 +++++-----
 drivers/lguest/lg.h                   |    9 ++--
 drivers/lguest/lguest_device.c        |    4 +-
 drivers/lguest/page_tables.c          |   38 ++++++++++----
 drivers/lguest/segments.c             |    2 +-
 drivers/lguest/x86/core.c             |   62 +++++++++++++++++++++-
 drivers/virtio/virtio_ring.c          |   22 +++++---
 13 files changed, 210 insertions(+), 92 deletions(-)

commit ca98502ca12192f7f1aec0239734458901c4fdd6
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Thu Jan 22 16:42:57 2009 +0100

    virtio: fix BAD_RING, START_US and END_USE macros
    
    Impact: cleanup
    
    fix BAD_RING, START_US and END_USE macros
    
    When these macros aren't called with a variable named vq as first
    argument, this would result in a build failure.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/virtio/virtio_ring.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

commit d8cac090dbf12b5651609776b18446cd984a4d74
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Mar 28 23:39:16 2009 -0600

    virtio: more neatening of virtio_ring macros.
    
    Impact: cleanup
    
    Roel Kluin drew attention to these macros with his patch: here I
    neaten them a little further:
    1) Add a comment on what START_USE and END_USE are checking,
    2) Brackets around _vq in BAD_RING,
    3) Neaten formatting for START_USE so it's less than 80 cols.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/virtio/virtio_ring.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

commit ffa4ae2fe9c68fe35d0dbf29a05af5aff392122b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Mar 28 23:39:16 2009 -0600

    lguest: fix spurious BUG_ON() on invalid guest stack.
    
    Impact: fix crash on misbehaving guest
    
    gpte_addr() contains a BUG_ON(), insisting that the present flag is
    set.  We need to return before we call it if that isn't the case.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: stable@kernel.org

 drivers/lguest/page_tables.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

commit bb32d14a9e3efd1578e8ad53286de71a992bb4db
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Mar 28 23:39:16 2009 -0600

    lguest: wire up pte_update/pte_update_defer
    
    Impact: intermittent guest segv/crash fix
    
    I've been seeing random guest bad address crashes and segmentation faults:
    bisect led to 4f98a2fee8 (vmscan: split LRU lists into anon & file sets),
    but that's a red herring.
    
    It turns out that lguest never hooked up the pte_update/pte_update_defer
    calls, so our ptes were not always in sync.  After the vmscan commit, the
    bug became reproducible; now a fsck in a 64MB guest causes reproducible
    pagetable corruption.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: jeremy@xensource.com
    Cc: virtualization@lists.osdl.org
    Cc: stable@kernel.org

 arch/x86/lguest/boot.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

commit 754b83efa91a021395c7df119ce53aeb32cce11d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Mar 28 23:39:17 2009 -0600

    lguest: avoid accidental recycling of pgdir pages
    
    Impact: potential bugfix
    
    In theory, the kernel could reuse the same page as pgdir for a new process
    while the hypervisor keeps it cached.  This would have undesirable results.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/x86/include/asm/lguest_hcall.h |    1 +
 arch/x86/lguest/boot.c              |    8 ++++++++
 drivers/lguest/hypercalls.c         |    3 +++
 drivers/lguest/lg.h                 |    1 +
 drivers/lguest/page_tables.c        |   16 ++++++++++++++++
 5 files changed, 29 insertions(+), 0 deletions(-)

commit b6757ad1aeeefbe439596dc09f23a4fee16c9079
Author: Matias Zabaljauregui <zabaljauregui@gmail.com>
Date:   Sat Mar 14 13:37:52 2009 -0200

    lguest: use KVM hypercalls
    
    Impact: cleanup
    
    This patch allow us to use KVM hypercalls
    
    Signed-off-by: Matias Zabaljauregui <zabaljauregui at gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/x86/include/asm/lguest_hcall.h   |   24 ++--------
 arch/x86/lguest/boot.c                |   80 ++++++++++++++++++++------------
 arch/x86/lguest/i386_head.S           |    4 +-
 drivers/lguest/interrupts_and_traps.c |    7 ++-
 drivers/lguest/lguest_device.c        |    4 +-
 drivers/lguest/x86/core.c             |   62 +++++++++++++++++++++++++-
 6 files changed, 123 insertions(+), 58 deletions(-)

commit f8f81b891f9e2bb0e149c6bfb6b153ea72f5d8ab
Author: Matias Zabaljauregui <zabaljauregui@gmail.com>
Date:   Wed Mar 18 13:38:35 2009 -0300

    lguest: use bool instead of int
    
    Impact: clean up
    
    Rusty told me, some time ago, that he had become a fan of "bool".
    So, here are some replacements.
    
    Signed-off-by: Matias Zabaljauregui <zabaljauregui at gmail.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/lguest/core.c                 |    4 ++--
 drivers/lguest/interrupts_and_traps.c |   21 +++++++++++----------
 drivers/lguest/lg.h                   |    8 ++++----
 drivers/lguest/page_tables.c          |   18 +++++++++---------
 drivers/lguest/segments.c             |    2 +-
 5 files changed, 27 insertions(+), 26 deletions(-)

commit 89a923c45472749805a9264fb409eb9c3cbad8e2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Mar 28 23:39:19 2009 -0600

    lguest: barrier me harder
    
    Impact: barrier correctness in example launcher
    
    I doubt either lguest user will complain about performance.
    
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Cc: Jens Axboe <jens.axboe@oracle.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 Documentation/lguest/lguest.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index f2dbbf3..d36fcc0 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1630,6 +1630,13 @@ static bool service_io(struct device *dev)
 		}
 	}
 
+	/* OK, so we noted that it was pretty poor to use an fdatasync as a
+	 * barrier.  But Christoph Hellwig points out that we need a sync
+	 * *afterwards* as well: "Barriers specify no reordering to the front
+	 * or the back."  And Jens Axboe confirmed it, so here we are: */
+	if (out->type & VIRTIO_BLK_T_BARRIER)
+		fdatasync(vblk->fd);
+
 	/* We can't trigger an IRQ, because we're not the Launcher.  It does
 	 * that when we tell it we're done. */
 	add_used(dev->vq, head, wlen);
diff --git a/arch/x86/include/asm/lguest_hcall.h b/arch/x86/include/asm/lguest_hcall.h
index 4389442..93f6cc4 100644
--- a/arch/x86/include/asm/lguest_hcall.h
+++ b/arch/x86/include/asm/lguest_hcall.h
@@ -17,6 +17,7 @@
 #define LHCALL_SET_PMD		15
 #define LHCALL_LOAD_TLS		16
 #define LHCALL_NOTIFY		17
+#define LHCALL_INVALIDATE_PGTABLE 18
 
 #define LGUEST_TRAP_ENTRY 0x1F
 
@@ -26,36 +27,20 @@
 
 #ifndef __ASSEMBLY__
 #include <asm/hw_irq.h>
+#include <asm/kvm_para.h>
 
 /*G:031 But first, how does our Guest contact the Host to ask for privileged
  * operations?  There are two ways: the direct way is to make a "hypercall",
  * to make requests of the Host Itself.
  *
- * Our hypercall mechanism uses the highest unused trap code (traps 32 and
- * above are used by real hardware interrupts).  Fifteen hypercalls are
+ * We use the KVM hypercall mechanism. Eighteen hypercalls are
  * available: the hypercall number is put in the %eax register, and the
- * arguments (when required) are placed in %edx, %ebx and %ecx.  If a return
+ * arguments (when required) are placed in %ebx, %ecx and %edx.  If a return
  * value makes sense, it's returned in %eax.
  *
  * Grossly invalid calls result in Sudden Death at the hands of the vengeful
  * Host, rather than returning failure.  This reflects Winston Churchill's
  * definition of a gentleman: "someone who is only rude intentionally". */
-static inline unsigned long
-hcall(unsigned long call,
-      unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-	/* "int" is the Intel instruction to trigger a trap. */
-	asm volatile("int $" __stringify(LGUEST_TRAP_ENTRY)
-		     /* The call in %eax (aka "a") might be overwritten */
-		     : "=a"(call)
-		       /* The arguments are in %eax, %edx, %ebx & %ecx */
-		     : "a"(call), "d"(arg1), "b"(arg2), "c"(arg3)
-		       /* "memory" means this might write somewhere in memory.
-			* This isn't true for all calls, but it's safe to tell
-			* gcc that it might happen so it doesn't get clever. */
-		     : "memory");
-	return call;
-}
 /*:*/
 
 /* Can't use our min() macro here: needs to be a constant */
@@ -64,7 +49,7 @@ hcall(unsigned long call,
 #define LHCALL_RING_SIZE 64
 struct hcall_args {
 	/* These map directly onto eax, ebx, ecx, edx in struct lguest_regs */
-	unsigned long arg0, arg2, arg3, arg1;
+	unsigned long arg0, arg1, arg2, arg3;
 };
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 960a8d9..557957a 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -107,7 +107,7 @@ static void async_hcall(unsigned long call, unsigned long arg1,
 	local_irq_save(flags);
 	if (lguest_data.hcall_status[next_call] != 0xFF) {
 		/* Table full, so do normal hcall which will flush table. */
-		hcall(call, arg1, arg2, arg3);
+		kvm_hypercall3(call, arg1, arg2, arg3);
 	} else {
 		lguest_data.hcalls[next_call].arg0 = call;
 		lguest_data.hcalls[next_call].arg1 = arg1;
@@ -134,13 +134,32 @@ static void async_hcall(unsigned long call, unsigned long arg1,
  *
  * So, when we're in lazy mode, we call async_hcall() to store the call for
  * future processing: */
-static void lazy_hcall(unsigned long call,
+static void lazy_hcall1(unsigned long call,
+		       unsigned long arg1)
+{
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE)
+		kvm_hypercall1(call, arg1);
+	else
+		async_hcall(call, arg1, 0, 0);
+}
+
+static void lazy_hcall2(unsigned long call,
+		       unsigned long arg1,
+		       unsigned long arg2)
+{
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE)
+		kvm_hypercall2(call, arg1, arg2);
+	else
+		async_hcall(call, arg1, arg2, 0);
+}
+
+static void lazy_hcall3(unsigned long call,
 		       unsigned long arg1,
 		       unsigned long arg2,
 		       unsigned long arg3)
 {
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE)
-		hcall(call, arg1, arg2, arg3);
+		kvm_hypercall3(call, arg1, arg2, arg3);
 	else
 		async_hcall(call, arg1, arg2, arg3);
 }
@@ -150,7 +169,7 @@ static void lazy_hcall(unsigned long call,
 static void lguest_leave_lazy_mode(void)
 {
 	paravirt_leave_lazy(paravirt_get_lazy_mode());
-	hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	kvm_hypercall0(LHCALL_FLUSH_ASYNC);
 }
 
 /*G:033
@@ -224,7 +243,7 @@ static void lguest_write_idt_entry(gate_desc *dt,
 	/* Keep the local copy up to date. */
 	native_write_idt_entry(dt, entrynum, g);
 	/* Tell Host about this new entry. */
-	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, desc[0], desc[1]);
+	kvm_hypercall3(LHCALL_LOAD_IDT_ENTRY, entrynum, desc[0], desc[1]);
 }
 
 /* Changing to a different IDT is very rare: we keep the IDT up-to-date every
@@ -236,7 +255,7 @@ static void lguest_load_idt(const struct desc_ptr *desc)
 	struct desc_struct *idt = (void *)desc->address;
 
 	for (i = 0; i < (desc->size+1)/8; i++)
-		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+		kvm_hypercall3(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
 }
 
 /*
@@ -256,8 +275,8 @@ static void lguest_load_idt(const struct desc_ptr *desc)
  */
 static void lguest_load_gdt(const struct desc_ptr *desc)
 {
-	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
-	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
+	BUG_ON((desc->size + 1) / 8 != GDT_ENTRIES);
+	kvm_hypercall2(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES);
 }
 
 /* For a single GDT entry which changes, we do the lazy thing: alter our GDT,
@@ -267,7 +286,7 @@ static void lguest_write_gdt_entry(struct desc_struct *dt, int entrynum,
 				   const void *desc, int type)
 {
 	native_write_gdt_entry(dt, entrynum, desc, type);
-	hcall(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES, 0);
+	kvm_hypercall2(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES);
 }
 
 /* OK, I lied.  There are three "thread local storage" GDT entries which change
@@ -279,7 +298,7 @@ static void lguest_load_tls(struct thread_struct *t, unsigned int cpu)
 	 * can't handle us removing entries we're currently using.  So we clear
 	 * the GS register here: if it's needed it'll be reloaded anyway. */
 	loadsegment(gs, 0);
-	lazy_hcall(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu, 0);
+	lazy_hcall2(LHCALL_LOAD_TLS, __pa(&t->tls_array), cpu);
 }
 
 /*G:038 That's enough excitement for now, back to ploughing through each of
@@ -377,7 +396,7 @@ static void lguest_cpuid(unsigned int *ax, unsigned int *bx,
 static unsigned long current_cr0;
 static void lguest_write_cr0(unsigned long val)
 {
-	lazy_hcall(LHCALL_TS, val & X86_CR0_TS, 0, 0);
+	lazy_hcall1(LHCALL_TS, val & X86_CR0_TS);
 	current_cr0 = val;
 }
 
@@ -391,7 +410,7 @@ static unsigned long lguest_read_cr0(void)
  * the vowels have been optimized out. */
 static void lguest_clts(void)
 {
-	lazy_hcall(LHCALL_TS, 0, 0, 0);
+	lazy_hcall1(LHCALL_TS, 0);
 	current_cr0 &= ~X86_CR0_TS;
 }
 
@@ -413,7 +432,7 @@ static bool cr3_changed = false;
 static void lguest_write_cr3(unsigned long cr3)
 {
 	lguest_data.pgdir = cr3;
-	lazy_hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
+	lazy_hcall1(LHCALL_NEW_PGTABLE, cr3);
 	cr3_changed = true;
 }
 
@@ -485,11 +504,17 @@ static void lguest_write_cr4(unsigned long val)
  * into a process' address space.  We set the entry then tell the Host the
  * toplevel and address this corresponds to.  The Guest uses one pagetable per
  * process, so we need to tell the Host which one we're changing (mm->pgd). */
+static void lguest_pte_update(struct mm_struct *mm, unsigned long addr,
+			       pte_t *ptep)
+{
+	lazy_hcall3(LHCALL_SET_PTE, __pa(mm->pgd), addr, ptep->pte_low);
+}
+
 static void lguest_set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
-	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, pteval.pte_low);
+	lguest_pte_update(mm, addr, ptep);
 }
 
 /* The Guest calls this to set a top-level entry.  Again, we set the entry then
@@ -498,8 +523,8 @@ static void lguest_set_pte_at(struct mm_struct *mm, unsigned long addr,
 static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	*pmdp = pmdval;
-	lazy_hcall(LHCALL_SET_PMD, __pa(pmdp)&PAGE_MASK,
-		   (__pa(pmdp)&(PAGE_SIZE-1))/4, 0);
+	lazy_hcall2(LHCALL_SET_PMD, __pa(pmdp) & PAGE_MASK,
+		   (__pa(pmdp) & (PAGE_SIZE - 1)) / 4);
 }
 
 /* There are a couple of legacy places where the kernel sets a PTE, but we
@@ -515,7 +540,7 @@ static void lguest_set_pte(pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
 	if (cr3_changed)
-		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+		lazy_hcall1(LHCALL_FLUSH_TLB, 1);
 }
 
 /* Unfortunately for Lguest, the pv_mmu_ops for page tables were based on
@@ -531,7 +556,7 @@ static void lguest_set_pte(pte_t *ptep, pte_t pteval)
 static void lguest_flush_tlb_single(unsigned long addr)
 {
 	/* Simply set it to zero: if it was not, it will fault back in. */
-	lazy_hcall(LHCALL_SET_PTE, lguest_data.pgdir, addr, 0);
+	lazy_hcall3(LHCALL_SET_PTE, lguest_data.pgdir, addr, 0);
 }
 
 /* This is what happens after the Guest has removed a large number of entries.
@@ -539,7 +564,7 @@ static void lguest_flush_tlb_single(unsigned long addr)
  * have changed, ie. virtual addresses below PAGE_OFFSET. */
 static void lguest_flush_tlb_user(void)
 {
-	lazy_hcall(LHCALL_FLUSH_TLB, 0, 0, 0);
+	lazy_hcall1(LHCALL_FLUSH_TLB, 0);
 }
 
 /* This is called when the kernel page tables have changed.  That's not very
@@ -547,7 +572,14 @@ static void lguest_flush_tlb_user(void)
  * slow), so it's worth separating this from the user flushing above. */
 static void lguest_flush_tlb_kernel(void)
 {
-	lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
+	lazy_hcall1(LHCALL_FLUSH_TLB, 1);
+}
+
+/* This routine is called when a process exits, and we're throwing away the
+ * page table. */
+static void lguest_pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+	lazy_hcall1(LHCALL_INVALIDATE_PGTABLE, __pa(pgd));
 }
 
 /*
@@ -684,7 +716,7 @@ static int lguest_clockevent_set_next_event(unsigned long delta,
 	}
 
 	/* Please wake us this far in the future. */
-	hcall(LHCALL_SET_CLOCKEVENT, delta, 0, 0);
+	kvm_hypercall1(LHCALL_SET_CLOCKEVENT, delta);
 	return 0;
 }
 
@@ -695,7 +727,7 @@ static void lguest_clockevent_set_mode(enum clock_event_mode mode,
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		/* A 0 argument shuts the clock down. */
-		hcall(LHCALL_SET_CLOCKEVENT, 0, 0, 0);
+		kvm_hypercall0(LHCALL_SET_CLOCKEVENT);
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* This is what we expect. */
@@ -770,8 +802,8 @@ static void lguest_time_init(void)
 static void lguest_load_sp0(struct tss_struct *tss,
 			    struct thread_struct *thread)
 {
-	lazy_hcall(LHCALL_SET_STACK, __KERNEL_DS|0x1, thread->sp0,
-		   THREAD_SIZE/PAGE_SIZE);
+	lazy_hcall3(LHCALL_SET_STACK, __KERNEL_DS | 0x1, thread->sp0,
+		   THREAD_SIZE / PAGE_SIZE);
 }
 
 /* Let's just say, I wouldn't do debugging under a Guest. */
@@ -843,7 +875,7 @@ static struct apic_ops lguest_basic_apic_ops = {
 /* STOP!  Until an interrupt comes in. */
 static void lguest_safe_halt(void)
 {
-	hcall(LHCALL_HALT, 0, 0, 0);
+	kvm_hypercall0(LHCALL_HALT);
 }
 
 /* The SHUTDOWN hypercall takes a string to describe what's happening, and
@@ -853,7 +885,8 @@ static void lguest_safe_halt(void)
  * rather than virtual addresses, so we use __pa() here. */
 static void lguest_power_off(void)
 {
-	hcall(LHCALL_SHUTDOWN, __pa("Power down"), LGUEST_SHUTDOWN_POWEROFF, 0);
+	kvm_hypercall2(LHCALL_SHUTDOWN, __pa("Power down"),
+					LGUEST_SHUTDOWN_POWEROFF);
 }
 
 /*
@@ -863,7 +896,7 @@ static void lguest_power_off(void)
  */
 static int lguest_panic(struct notifier_block *nb, unsigned long l, void *p)
 {
-	hcall(LHCALL_SHUTDOWN, __pa(p), LGUEST_SHUTDOWN_POWEROFF, 0);
+	kvm_hypercall2(LHCALL_SHUTDOWN, __pa(p), LGUEST_SHUTDOWN_POWEROFF);
 	/* The hcall won't return, but to keep gcc happy, we're "done". */
 	return NOTIFY_DONE;
 }
@@ -904,7 +937,7 @@ static __init int early_put_chars(u32 vtermno, const char *buf, int count)
 		len = sizeof(scratch) - 1;
 	scratch[len] = '\0';
 	memcpy(scratch, buf, len);
-	hcall(LHCALL_NOTIFY, __pa(scratch), 0, 0);
+	kvm_hypercall1(LHCALL_NOTIFY, __pa(scratch));
 
 	/* This routine returns the number of bytes actually written. */
 	return len;
@@ -914,7 +947,7 @@ static __init int early_put_chars(u32 vtermno, const char *buf, int count)
  * Launcher to reboot us. */
 static void lguest_restart(char *reason)
 {
-	hcall(LHCALL_SHUTDOWN, __pa(reason), LGUEST_SHUTDOWN_RESTART, 0);
+	kvm_hypercall2(LHCALL_SHUTDOWN, __pa(reason), LGUEST_SHUTDOWN_RESTART);
 }
 
 /*G:050
@@ -1034,6 +1067,9 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
 	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_mmu_ops.pte_update = lguest_pte_update;
+	pv_mmu_ops.pte_update_defer = lguest_pte_update;
+	pv_mmu_ops.pgd_free = lguest_pgd_free;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */
diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/i386_head.S
index 10b9bd3..f795419 100644
--- a/arch/x86/lguest/i386_head.S
+++ b/arch/x86/lguest/i386_head.S
@@ -27,8 +27,8 @@ ENTRY(lguest_entry)
 	/* We make the "initialization" hypercall now to tell the Host about
 	 * us, and also find out where it put our page tables. */
 	movl $LHCALL_LGUEST_INIT, %eax
-	movl $lguest_data - __PAGE_OFFSET, %edx
-	int $LGUEST_TRAP_ENTRY
+	movl $lguest_data - __PAGE_OFFSET, %ebx
+	.byte 0x0f,0x01,0xc1 /* KVM_HYPERCALL */
 
 	/* Set up the initial stack so we can run C code. */
 	movl $(init_thread_union+THREAD_SIZE),%esp
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 60156df..4845fb3 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -152,8 +152,8 @@ static void unmap_switcher(void)
  * code.  We have to check that the range is below the pfn_limit the Launcher
  * gave us.  We have to make sure that addr + len doesn't give us a false
  * positive by overflowing, too. */
-int lguest_address_ok(const struct lguest *lg,
-		      unsigned long addr, unsigned long len)
+bool lguest_address_ok(const struct lguest *lg,
+		       unsigned long addr, unsigned long len)
 {
 	return (addr+len) / PAGE_SIZE < lg->pfn_limit && (addr+len >= addr);
 }
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 54d66f0..a160894 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -92,6 +92,9 @@ static void do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
 	case LHCALL_NOTIFY:
 		cpu->pending_notify = args->arg1;
 		break;
+	case LHCALL_INVALIDATE_PGTABLE:
+		invalidate_pagetable(cpu, args->arg1);
+		break;
 	default:
 		/* It should be an architecture-specific hypercall. */
 		if (lguest_arch_do_hcall(cpu, args))
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 415fab0..6e99adb 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -34,7 +34,7 @@ static int idt_type(u32 lo, u32 hi)
 }
 
 /* An IDT entry can't be used unless the "present" bit is set. */
-static int idt_present(u32 lo, u32 hi)
+static bool idt_present(u32 lo, u32 hi)
 {
 	return (hi & 0x8000);
 }
@@ -60,7 +60,8 @@ static void push_guest_stack(struct lg_cpu *cpu, unsigned long *gstack, u32 val)
  * We set up the stack just like the CPU does for a real interrupt, so it's
  * identical for the Guest (and the standard "iret" instruction will undo
  * it). */
-static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi, int has_err)
+static void set_guest_interrupt(struct lg_cpu *cpu, u32 lo, u32 hi,
+				bool has_err)
 {
 	unsigned long gstack, origstack;
 	u32 eflags, ss, irq_enable;
@@ -184,7 +185,7 @@ void maybe_do_interrupt(struct lg_cpu *cpu)
 		/* set_guest_interrupt() takes the interrupt descriptor and a
 		 * flag to say whether this interrupt pushes an error code onto
 		 * the stack as well: virtual interrupts never do. */
-		set_guest_interrupt(cpu, idt->a, idt->b, 0);
+		set_guest_interrupt(cpu, idt->a, idt->b, false);
 	}
 
 	/* Every time we deliver an interrupt, we update the timestamp in the
@@ -244,26 +245,26 @@ void free_interrupts(void)
 /*H:220 Now we've got the routines to deliver interrupts, delivering traps like
  * page fault is easy.  The only trick is that Intel decided that some traps
  * should have error codes: */
-static int has_err(unsigned int trap)
+static bool has_err(unsigned int trap)
 {
 	return (trap == 8 || (trap >= 10 && trap <= 14) || trap == 17);
 }
 
 /* deliver_trap() returns true if it could deliver the trap. */
-int deliver_trap(struct lg_cpu *cpu, unsigned int num)
+bool deliver_trap(struct lg_cpu *cpu, unsigned int num)
 {
 	/* Trap numbers are always 8 bit, but we set an impossible trap number
 	 * for traps inside the Switcher, so check that here. */
 	if (num >= ARRAY_SIZE(cpu->arch.idt))
-		return 0;
+		return false;
 
 	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
 	 * bogus one in): if we fail here, the Guest will be killed. */
 	if (!idt_present(cpu->arch.idt[num].a, cpu->arch.idt[num].b))
-		return 0;
+		return false;
 	set_guest_interrupt(cpu, cpu->arch.idt[num].a,
 			    cpu->arch.idt[num].b, has_err(num));
-	return 1;
+	return true;
 }
 
 /*H:250 Here's the hard part: returning to the Host every time a trap happens
@@ -279,18 +280,19 @@ int deliver_trap(struct lg_cpu *cpu, unsigned int num)
  *
  * This routine indicates if a particular trap number could be delivered
  * directly. */
-static int direct_trap(unsigned int num)
+static bool direct_trap(unsigned int num)
 {
 	/* Hardware interrupts don't go to the Guest at all (except system
 	 * call). */
 	if (num >= FIRST_EXTERNAL_VECTOR && !could_be_syscall(num))
-		return 0;
+		return false;
 
 	/* The Host needs to see page faults (for shadow paging and to save the
 	 * fault address), general protection faults (in/out emulation) and
-	 * device not available (TS handling), and of course, the hypercall
-	 * trap. */
-	return num != 14 && num != 13 && num != 7 && num != LGUEST_TRAP_ENTRY;
+	 * device not available (TS handling), invalid opcode fault (kvm hcall),
+	 * and of course, the hypercall trap. */
+	return num != 14 && num != 13 && num != 7 &&
+			num != 6 && num != LGUEST_TRAP_ENTRY;
 }
 /*:*/
 
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index f2c641e..4d81591 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -109,8 +109,8 @@ struct lguest
 extern struct mutex lguest_lock;
 
 /* core.c: */
-int lguest_address_ok(const struct lguest *lg,
-		      unsigned long addr, unsigned long len);
+bool lguest_address_ok(const struct lguest *lg,
+		       unsigned long addr, unsigned long len);
 void __lgread(struct lg_cpu *, void *, unsigned long, unsigned);
 void __lgwrite(struct lg_cpu *, unsigned long, const void *, unsigned);
 
@@ -140,7 +140,7 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user);
 
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lg_cpu *cpu);
-int deliver_trap(struct lg_cpu *cpu, unsigned int num);
+bool deliver_trap(struct lg_cpu *cpu, unsigned int num);
 void load_guest_idt_entry(struct lg_cpu *cpu, unsigned int i,
 			  u32 low, u32 hi);
 void guest_set_stack(struct lg_cpu *cpu, u32 seg, u32 esp, unsigned int pages);
@@ -173,7 +173,8 @@ void guest_pagetable_flush_user(struct lg_cpu *cpu);
 void guest_set_pte(struct lg_cpu *cpu, unsigned long gpgdir,
 		   unsigned long vaddr, pte_t val);
 void map_switcher_in_guest(struct lg_cpu *cpu, struct lguest_pages *pages);
-int demand_page(struct lg_cpu *cpu, unsigned long cr2, int errcode);
+bool demand_page(struct lg_cpu *cpu, unsigned long cr2, int errcode);
+void invalidate_pagetable(struct lg_cpu *cpu, unsigned long pgtable);
 void pin_page(struct lg_cpu *cpu, unsigned long vaddr);
 unsigned long guest_pa(struct lg_cpu *cpu, unsigned long vaddr);
 void page_table_guest_data_init(struct lg_cpu *cpu);
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 8132533..df44d96 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -161,7 +161,7 @@ static void set_status(struct virtio_device *vdev, u8 status)
 
 	/* We set the status. */
 	to_lgdev(vdev)->desc->status = status;
-	hcall(LHCALL_NOTIFY, (max_pfn<<PAGE_SHIFT) + offset, 0, 0);
+	kvm_hypercall1(LHCALL_NOTIFY, (max_pfn << PAGE_SHIFT) + offset);
 }
 
 static void lg_set_status(struct virtio_device *vdev, u8 status)
@@ -209,7 +209,7 @@ static void lg_notify(struct virtqueue *vq)
 	 * virtqueue structure. */
 	struct lguest_vq_info *lvq = vq->priv;
 
-	hcall(LHCALL_NOTIFY, lvq->config.pfn << PAGE_SHIFT, 0, 0);
+	kvm_hypercall1(LHCALL_NOTIFY, lvq->config.pfn << PAGE_SHIFT);
 }
 
 /* An extern declaration inside a C file is bad form.  Don't do it. */
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 576a831..d137f7d 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -199,7 +199,7 @@ static void check_gpgd(struct lg_cpu *cpu, pgd_t gpgd)
  *
  * If we fixed up the fault (ie. we mapped the address), this routine returns
  * true.  Otherwise, it was a real fault and we need to tell the Guest. */
-int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
+bool demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
 {
 	pgd_t gpgd;
 	pgd_t *spgd;
@@ -211,7 +211,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
 	gpgd = lgread(cpu, gpgd_addr(cpu, vaddr), pgd_t);
 	/* Toplevel not present?  We can't map it in. */
 	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
-		return 0;
+		return false;
 
 	/* Now look at the matching shadow entry. */
 	spgd = spgd_addr(cpu, cpu->cpu_pgd, vaddr);
@@ -222,7 +222,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
 		 * simple for this corner case. */
 		if (!ptepage) {
 			kill_guest(cpu, "out of memory allocating pte page");
-			return 0;
+			return false;
 		}
 		/* We check that the Guest pgd is OK. */
 		check_gpgd(cpu, gpgd);
@@ -238,16 +238,16 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
 
 	/* If this page isn't in the Guest page tables, we can't page it in. */
 	if (!(pte_flags(gpte) & _PAGE_PRESENT))
-		return 0;
+		return false;
 
 	/* Check they're not trying to write to a page the Guest wants
 	 * read-only (bit 2 of errcode == write). */
 	if ((errcode & 2) && !(pte_flags(gpte) & _PAGE_RW))
-		return 0;
+		return false;
 
 	/* User access to a kernel-only page? (bit 3 == user access) */
 	if ((errcode & 4) && !(pte_flags(gpte) & _PAGE_USER))
-		return 0;
+		return false;
 
 	/* Check that the Guest PTE flags are OK, and the page number is below
 	 * the pfn_limit (ie. not mapping the Launcher binary). */
@@ -283,7 +283,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
 	 * manipulated, the result returned and the code complete.  A small
 	 * delay and a trace of alliteration are the only indications the Guest
 	 * has that a page fault occurred at all. */
-	return 1;
+	return true;
 }
 
 /*H:360
@@ -296,7 +296,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
  *
  * This is a quick version which answers the question: is this virtual address
  * mapped by the shadow page tables, and is it writable? */
-static int page_writable(struct lg_cpu *cpu, unsigned long vaddr)
+static bool page_writable(struct lg_cpu *cpu, unsigned long vaddr)
 {
 	pgd_t *spgd;
 	unsigned long flags;
@@ -304,7 +304,7 @@ static int page_writable(struct lg_cpu *cpu, unsigned long vaddr)
 	/* Look at the current top level entry: is it present? */
 	spgd = spgd_addr(cpu, cpu->cpu_pgd, vaddr);
 	if (!(pgd_flags(*spgd) & _PAGE_PRESENT))
-		return 0;
+		return false;
 
 	/* Check the flags on the pte entry itself: it must be present and
 	 * writable. */
@@ -373,8 +373,10 @@ unsigned long guest_pa(struct lg_cpu *cpu, unsigned long vaddr)
 	/* First step: get the top-level Guest page table entry. */
 	gpgd = lgread(cpu, gpgd_addr(cpu, vaddr), pgd_t);
 	/* Toplevel not present?  We can't map it in. */
-	if (!(pgd_flags(gpgd) & _PAGE_PRESENT))
+	if (!(pgd_flags(gpgd) & _PAGE_PRESENT)) {
 		kill_guest(cpu, "Bad address %#lx", vaddr);
+		return -1UL;
+	}
 
 	gpte = lgread(cpu, gpte_addr(gpgd, vaddr), pte_t);
 	if (!(pte_flags(gpte) & _PAGE_PRESENT))
@@ -449,6 +451,22 @@ void guest_new_pagetable(struct lg_cpu *cpu, unsigned long pgtable)
 		pin_stack_pages(cpu);
 }
 
+/* The Guest tells us when a page is no longer being used as a pagetable.
+ * Without this there can be a subtle bug where the same page gets re-used
+ * for a different process, and we think it's the same one as the one we have
+ * in our little pgdir cache. */
+void invalidate_pagetable(struct lg_cpu *cpu, unsigned long pgtable)
+{
+	unsigned int pgdir = find_pgdir(cpu->lg, pgtable);
+
+	if (pgdir != ARRAY_SIZE(cpu->lg->pgdirs)) {
+		if (pgdir == cpu->cpu_pgd)
+			kill_guest(cpu, "Attempt to invalidate in-use pgdir");
+		/* We set it to an invalid value. */
+		cpu->lg->pgdirs[pgdir].gpgdir = -1UL;
+	}
+}
+
 /*H:470 Finally, a routine which throws away everything: all PGD entries in all
  * the shadow page tables, including the Guest's kernel mappings.  This is used
  * when we destroy the Guest. */
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index ec6aa3f..4f15439 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -45,7 +45,7 @@
  * "Task State Segment" which controls all kinds of delicate things.  The
  * LGUEST_CS and LGUEST_DS entries are reserved for the Switcher, and the
  * the Guest can't be trusted to deal with double faults. */
-static int ignored_gdt(unsigned int num)
+static bool ignored_gdt(unsigned int num)
 {
 	return (num == GDT_ENTRY_TSS
 		|| num == GDT_ENTRY_LGUEST_CS
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index bf79423..a6b7176 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -290,6 +290,57 @@ static int emulate_insn(struct lg_cpu *cpu)
 	return 1;
 }
 
+/* Our hypercalls mechanism used to be based on direct software interrupts.
+ * After Anthony's "Refactor hypercall infrastructure" kvm patch, we decided to
+ * change over to using kvm hypercalls.
+ *
+ * KVM_HYPERCALL is actually a "vmcall" instruction, which generates an invalid
+ * opcode fault (fault 6) on non-VT cpus, so the easiest solution seemed to be
+ * an *emulation approach*: if the fault was really produced by an hypercall
+ * (is_hypercall() does exactly this check), we can just call the corresponding
+ * hypercall host implementation function.
+ *
+ * But these invalid opcode faults are notably slower than software interrupts.
+ * So we implemented the *patching (or rewriting) approach*: every time we hit
+ * the KVM_HYPERCALL opcode in Guest code, we patch it to the old "int 0x1f"
+ * opcode, so next time the Guest calls this hypercall it will use the
+ * faster trap mechanism.
+ *
+ * Matias even benchmarked it to convince you: this shows the average cycle
+ * cost of a hypercall.  For each alternative solution mentioned above we've
+ * made 5 runs of the benchmark:
+ *
+ * 1) direct software interrupt: 2915, 2789, 2764, 2721, 2898
+ * 2) emulation technique: 3410, 3681, 3466, 3392, 3780
+ * 3) patching (rewrite) technique: 2977, 2975, 2891, 2637, 2884
+ *
+ * One two-line function is worth a 20% hypercall speed boost!
+ */
+static void rewrite_hypercall(struct lg_cpu *cpu)
+{
+	/* This are the opcodes we use to patch the Guest.  The opcode for "int
+	 * $0x1f" is "0xcd 0x1f" but vmcall instruction is 3 bytes long, so we
+	 * complete the sequence with a NOP (0x90). */
+	u8 insn[3] = {0xcd, 0x1f, 0x90};
+
+	__lgwrite(cpu, guest_pa(cpu, cpu->regs->eip), insn, sizeof(insn));
+}
+
+static bool is_hypercall(struct lg_cpu *cpu)
+{
+	u8 insn[3];
+
+	/* This must be the Guest kernel trying to do something.
+	 * The bottom two bits of the CS segment register are the privilege
+	 * level. */
+	if ((cpu->regs->cs & 3) != GUEST_PL)
+		return false;
+
+	/* Is it a vmcall? */
+	__lgread(cpu, insn, guest_pa(cpu, cpu->regs->eip), sizeof(insn));
+	return insn[0] == 0x0f && insn[1] == 0x01 && insn[2] == 0xc1;
+}
+
 /*H:050 Once we've re-enabled interrupts, we look at why the Guest exited. */
 void lguest_arch_handle_trap(struct lg_cpu *cpu)
 {
@@ -337,7 +388,7 @@ void lguest_arch_handle_trap(struct lg_cpu *cpu)
 		break;
 	case 32 ... 255:
 		/* These values mean a real interrupt occurred, in which case
-		 * the Host handler has already been run.  We just do a
+		 * the Host handler has already been run. We just do a
 		 * friendly check if another process should now be run, then
 		 * return to run the Guest again */
 		cond_resched();
@@ -347,6 +398,15 @@ void lguest_arch_handle_trap(struct lg_cpu *cpu)
 		 * up the pointer now to indicate a hypercall is pending. */
 		cpu->hcall = (struct hcall_args *)cpu->regs;
 		return;
+	case 6:
+		/* kvm hypercalls trigger an invalid opcode fault (6).
+		 * We need to check if ring == GUEST_PL and
+		 * faulting instruction == vmcall. */
+		if (is_hypercall(cpu)) {
+			rewrite_hypercall(cpu);
+			return;
+		}
+		break;
 	}
 
 	/* We didn't handle the trap, so it needs to go to the Guest. */
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5777196..5c52369 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -23,15 +23,21 @@
 
 #ifdef DEBUG
 /* For development, we want to crash whenever the ring is screwed. */
-#define BAD_RING(vq, fmt...)			\
-	do { dev_err(&vq->vq.vdev->dev, fmt); BUG(); } while(0)
-#define START_USE(vq) \
-	do { if ((vq)->in_use) panic("in_use = %i\n", (vq)->in_use); (vq)->in_use = __LINE__; mb(); } while(0)
-#define END_USE(vq) \
-	do { BUG_ON(!(vq)->in_use); (vq)->in_use = 0; mb(); } while(0)
+#define BAD_RING(_vq, fmt...)			\
+	do { dev_err(&(_vq)->vq.vdev->dev, fmt); BUG(); } while(0)
+/* Caller is supposed to guarantee no reentry. */
+#define START_USE(_vq)						\
+	do {							\
+		if ((_vq)->in_use)				\
+			panic("in_use = %i\n", (_vq)->in_use);	\
+		(_vq)->in_use = __LINE__;			\
+		mb();						\
+	} while(0)
+#define END_USE(_vq) \
+	do { BUG_ON(!(_vq)->in_use); (_vq)->in_use = 0; mb(); } while(0)
 #else
-#define BAD_RING(vq, fmt...)			\
-	do { dev_err(&vq->vq.vdev->dev, fmt); (vq)->broken = true; } while(0)
+#define BAD_RING(_vq, fmt...)			\
+	do { dev_err(&_vq->vq.vdev->dev, fmt); (_vq)->broken = true; } while(0)
 #define START_USE(vq)
 #define END_USE(vq)
 #endif
