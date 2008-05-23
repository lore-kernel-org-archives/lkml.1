Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYEWO0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYEWO0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 10:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYEWOZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 10:25:43 -0400
Received: from gw.goop.org ([64.81.55.164]:48119 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbYEWOZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 10:25:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 4] mm: add a pte_rmw transaction abstraction
X-Mercurial-Node: 2b93875edf6075d9d61041a5270b5343c317f8ac
Message-Id: <2b93875edf6075d9d610.1211552449@localhost>
In-Reply-To: <patchbomb.1211552448@localhost>
Date: Fri, 23 May 2008 15:20:49 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an API for doing read-modify-write updates to a pte
which may race against hardware updates to the pte.  After reading the
pte, the hardware may asynchonously set the accessed or dirty bits on
a pte, which would be lost when writing back the modified pte value.

The existing technique to handle this race is to use
ptep_get_and_clear() atomically fetch the old pte value and clear it
in memory.  This has the effect of marking the pte as non-present,
which will prevent the hardware from updating its state.  When the new
value is written back, the pte will be present again, and the hardware
can resume updating the access/dirty flags.

When running in a virtualized environment, pagetable updates are
relatively expensive, since they generally involve some trap into the
hypervisor.  To mitigate the cost of these updates, we tend to batch
them.

However, because of the atomic nature of ptep_get_and_clear(), it is
inherently non-batchable.  This new interface allows batching by
giving the underlying implementation enough information to open a
transaction between the read and write phases:

pte_rmw_start() returns the current pte value, and puts the pte entry
  into a state where either the hardware will not update the pte, or if
  it does, the updates will be preserved on commit.

pte_rmw_commit() writes back the updated pte, makes sure that any
  hardware updates made since pte_rmw_start() are preserved.

pte_rmw_start() and _commit() must be exactly paired, and used while
holding the appropriate pte lock.  They do not protect against other
software updates of the pte in any way.

The current implementations of pte_rmw_start and _commit are functionally
unchanged from before: pte_rmw_start() uses ptep_get_and_clear() fetch
the pte and zero the entry, preventing any hardware updates.
pte_rmw_commit() simply writes the new pte value back knowing that the
hardware has not updated the pte in the meantime.

The only current user of this interface is mprotect

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-generic/pgtable.h |   51 ++++++++++++++++++++++++++++++++++++++++-
 mm/mprotect.c                 |   10 +++-----
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -197,6 +197,55 @@
 }
 #endif /* CONFIG_MMU */
 
+static inline pte_t __pte_rmw_start(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep)
+{
+	/* Get the current pte state, but zero it out to make it
+	   non-present, preventing the hardware from asynchronously
+	   updating it. */
+	return ptep_get_and_clear(mm, addr, ptep);
+}
+
+static inline void __pte_rmw_commit(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte)
+{
+	/* The pte is non-present, so there's no hardware state to
+	   preserve. */
+	set_pte_at(mm, addr, ptep, pte);
+}
+
+#ifndef __HAVE_ARCH_PTE_RMW_TRANSACTION
+/*
+ * Start a pte read-modify-write transaction, which protects against
+ * asynchronous hardware modifications to the pte.  The intention is
+ * not to prevent the hardware from making pte updates, but to prevent
+ * any updates it may make from being lost.
+ *
+ * This does not protect against other software modifications of the
+ * pte; the appropriate pte lock must be held over the transation.
+ *
+ * Note that this interface is intended to be batchable, meaning that
+ * pte_rmw_commit may not actually update the pte, but merely queue
+ * the update to be done at some later time.  The update must be
+ * actually committed before the pte lock is released, however.
+ */
+static inline pte_t pte_rmw_start(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep)
+{
+	return __pte_rmw_start(mm, addr, ptep);
+}
+
+/*
+ * Commit an update to a pte, leaving any hardware-controlled bits in
+ * the PTE unmodified.
+ */
+static inline void pte_rmw_commit(struct mm_struct *mm, unsigned long addr,
+				  pte_t *ptep, pte_t pte)
+{
+	__pte_rmw_commit(mm, addr, ptep, pte);
+}
+#endif
+
 /*
  * A facility to provide lazy MMU batching.  This allows PTE updates and
  * page invalidations to be delayed until a call to leave lazy MMU mode
diff --git a/mm/mprotect.c b/mm/mprotect.c
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -47,19 +47,17 @@
 		if (pte_present(oldpte)) {
 			pte_t ptent;
 
-			/* Avoid an SMP race with hardware updated dirty/clean
-			 * bits by wiping the pte and then setting the new pte
-			 * into place.
-			 */
-			ptent = ptep_get_and_clear(mm, addr, pte);
+			ptent = pte_rmw_start(mm, addr, pte);
 			ptent = pte_modify(ptent, newprot);
+
 			/*
 			 * Avoid taking write faults for pages we know to be
 			 * dirty.
 			 */
 			if (dirty_accountable && pte_dirty(ptent))
 				ptent = pte_mkwrite(ptent);
-			set_pte_at(mm, addr, pte, ptent);
+
+			pte_rmw_commit(mm, addr, pte, ptent);
 #ifdef CONFIG_MIGRATION
 		} else if (!pte_file(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);


