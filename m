Return-Path: <linux-kernel-owner+w=401wt.eu-S1756455AbYJaAxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbYJaAxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 20:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJaAxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 20:53:17 -0400
Received: from ozlabs.org ([203.10.76.45]:34536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbYJaAxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 20:53:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest boot fixes, example launcher fixes.
Date: Fri, 31 Oct 2008 11:53:14 +1100
User-Agent: KMail/1.9.10
Cc: lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810311153.14644.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 65fc716fa673cf98fb5887180fd3c52ca0371198:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sam/kbuild-fixes

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (3):
      lguest: fix example launcher compile after moved asm-x86 dir.
      lguest: fix early_ioremap.
      lguest: fix irq vectors.

 Documentation/lguest/Makefile |    2 +-
 Documentation/lguest/lguest.c |    2 +-
 arch/x86/lguest/boot.c        |   32 ++++++++++++++++++++------------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/Documentation/lguest/Makefile b/Documentation/lguest/Makefile
index bac037e..725eef8 100644
--- a/Documentation/lguest/Makefile
+++ b/Documentation/lguest/Makefile
@@ -1,5 +1,5 @@
 # This creates the demonstration utility "lguest" which runs a Linux guest.
-CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -I../../include
+CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -I../../include -I../../arch/x86/include
 LDLIBS:=-lz
 
 all: lguest
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index da86fd5..8045206 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -44,7 +44,7 @@
 #include "linux/virtio_console.h"
 #include "linux/virtio_rng.h"
 #include "linux/virtio_ring.h"
-#include "asm-x86/bootparam.h"
+#include "asm/bootparam.h"
 /*L:110 We can ignore the 39 include files we need for this program, but I do
  * want to draw attention to the use of kernel-style types.
  *
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 48ee4f9..a5d8e1a 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -367,10 +367,9 @@ static void lguest_cpuid(unsigned int *ax, unsigned int *bx,
  * lazily after a task switch, and Linux uses that gratefully, but wouldn't a
  * name like "FPUTRAP bit" be a little less cryptic?
  *
- * We store cr0 (and cr3) locally, because the Host never changes it.  The
- * Guest sometimes wants to read it and we'd prefer not to bother the Host
- * unnecessarily. */
-static unsigned long current_cr0, current_cr3;
+ * We store cr0 locally because the Host never changes it.  The Guest sometimes
+ * wants to read it and we'd prefer not to bother the Host unnecessarily. */
+static unsigned long current_cr0;
 static void lguest_write_cr0(unsigned long val)
 {
 	lazy_hcall(LHCALL_TS, val & X86_CR0_TS, 0, 0);
@@ -399,17 +398,23 @@ static unsigned long lguest_read_cr2(void)
 	return lguest_data.cr2;
 }
 
+/* See lguest_set_pte() below. */
+static bool cr3_changed = false;
+
 /* cr3 is the current toplevel pagetable page: the principle is the same as
- * cr0.  Keep a local copy, and tell the Host when it changes. */
+ * cr0.  Keep a local copy, and tell the Host when it changes.  The only
+ * difference is that our local copy is in lguest_data because the Host needs
+ * to set it upon our initial hypercall. */
 static void lguest_write_cr3(unsigned long cr3)
 {
+	lguest_data.pgdir = cr3;
 	lazy_hcall(LHCALL_NEW_PGTABLE, cr3, 0, 0);
-	current_cr3 = cr3;
+	cr3_changed = true;
 }
 
 static unsigned long lguest_read_cr3(void)
 {
-	return current_cr3;
+	return lguest_data.pgdir;
 }
 
 /* cr4 is used to enable and disable PGE, but we don't care. */
@@ -498,13 +503,13 @@ static void lguest_set_pmd(pmd_t *pmdp, pmd_t pmdval)
  * to forget all of them.  Fortunately, this is very rare.
  *
  * ... except in early boot when the kernel sets up the initial pagetables,
- * which makes booting astonishingly slow.  So we don't even tell the Host
- * anything changed until we've done the first page table switch. */
+ * which makes booting astonishingly slow: 1.83 seconds!  So we don't even tell
+ * the Host anything changed until we've done the first page table switch,
+ * which brings boot back to 0.25 seconds. */
 static void lguest_set_pte(pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
-	/* Don't bother with hypercall before initial setup. */
-	if (current_cr3)
+	if (cr3_changed)
 		lazy_hcall(LHCALL_FLUSH_TLB, 1, 0, 0);
 }
 
@@ -521,7 +526,7 @@ static void lguest_set_pte(pte_t *ptep, pte_t pteval)
 static void lguest_flush_tlb_single(unsigned long addr)
 {
 	/* Simply set it to zero: if it was not, it will fault back in. */
-	lazy_hcall(LHCALL_SET_PTE, current_cr3, addr, 0);
+	lazy_hcall(LHCALL_SET_PTE, lguest_data.pgdir, addr, 0);
 }
 
 /* This is what happens after the Guest has removed a large number of entries.
@@ -581,6 +586,9 @@ static void __init lguest_init_IRQ(void)
 
 	for (i = 0; i < LGUEST_IRQS; i++) {
 		int vector = FIRST_EXTERNAL_VECTOR + i;
+		/* Some systems map "vectors" to interrupts weirdly.  Lguest has
+		 * a straightforward 1 to 1 mapping, so force that here. */
+		__get_cpu_var(vector_irq)[vector] = i;
 		if (vector != SYSCALL_VECTOR) {
 			set_intr_gate(vector, interrupt[vector]);
 			set_irq_chip_and_handler_name(i, &lguest_irq_controller,
