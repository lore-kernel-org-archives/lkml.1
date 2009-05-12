Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZEMDG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZEMDG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZEMDF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:05:59 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36213
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754987AbZEMDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:05:57 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Christophe Saout <chtephan@leto.intern.saout.de>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/16] paravirtualize IO permission bitmap
Date: Tue, 12 May 2009 14:28:36 -0700
Message-Id: <1242163718-2934-15-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242163718-2934-1-git-send-email-jeremy@goop.org>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Saout <chtephan@leto.intern.saout.de>

A PV Xen guest kernel has no TSS of its own, so the IO permission
bitmap must be paravirtualized.  This patch adds set_io_bitmap
as a paravirt op, and defines a native version which updates the tss,
and a Xen version which uses a hypercall.

This is much easier now that 32 and 64-bit use the same code to
manage the IO bitmap.

[ Impact: make ioperm bitmap work under Xen ]

Signed-off-by: Christophe Saout <chtephan@leto.intern.saout.de>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h  |    9 +++++++++
 arch/x86/include/asm/processor.h |    4 ++++
 arch/x86/kernel/ioport.c         |   34 ++++++++++++++++++++++++++--------
 arch/x86/kernel/paravirt.c       |    1 +
 arch/x86/kernel/process.c        |   27 +++++++--------------------
 arch/x86/xen/enlighten.c         |   16 ++++++++++++++++
 6 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 1fe5837..8b02fd0 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -156,6 +156,8 @@ struct pv_cpu_ops {
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
+	void (*set_io_bitmap)(struct thread_struct *thread,
+	                      int changed, unsigned long bytes_updated);
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
@@ -996,11 +998,18 @@ static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 {
 	PVOP_VCALL3(pv_cpu_ops.write_idt_entry, dt, entry, g);
 }
+
 static inline void set_iopl_mask(unsigned mask)
 {
 	PVOP_VCALL1(pv_cpu_ops.set_iopl_mask, mask);
 }
 
+static inline void set_io_bitmap(struct thread_struct *thread,
+                                 int changed, unsigned long bytes_updated)
+{
+	PVOP_VCALL3(pv_cpu_ops.set_io_bitmap, thread, changed, bytes_updated);
+}
+
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void)
 {
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..1c70563 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -544,6 +544,9 @@ static inline void native_set_iopl_mask(unsigned mask)
 #endif
 }
 
+extern void native_set_io_bitmap(struct thread_struct *thread,
+				 int changed, unsigned long updated_bytes);
+
 static inline void
 native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
 {
@@ -585,6 +588,7 @@ static inline void load_sp0(struct tss_struct *tss,
 }
 
 #define set_iopl_mask native_set_iopl_mask
+#define set_io_bitmap native_set_io_bitmap
 #endif /* CONFIG_PARAVIRT */
 
 /*
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 99c4d30..b5c1918 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -30,14 +30,31 @@ static void set_bitmap(unsigned long *bitmap, unsigned int base,
 	}
 }
 
+void native_set_io_bitmap(struct thread_struct *t,
+			  int changed, unsigned long bytes_updated)
+{
+	struct tss_struct *tss;
+
+	if (!bytes_updated)
+		return;
+
+	tss = &__get_cpu_var(init_tss);
+
+	/* Update the TSS: */
+	if (t->io_bitmap_ptr)
+		memcpy(tss->io_bitmap, t->io_bitmap_ptr, bytes_updated);
+	else
+		memset(tss->io_bitmap, 0xff, bytes_updated);
+}
+
 /*
  * this changes the io permissions bitmap in the current task.
  */
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 {
 	struct thread_struct *t = &current->thread;
-	struct tss_struct *tss;
 	unsigned int i, max_long, bytes, bytes_updated;
+	int changed;
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
@@ -58,16 +75,18 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 		memset(bitmap, 0xff, IO_BITMAP_BYTES);
 		t->io_bitmap_ptr = bitmap;
 		set_thread_flag(TIF_IO_BITMAP);
-	}
+		changed = 1;
+	} else
+		changed = 0;
 
 	/*
-	 * do it in the per-thread copy and in the TSS ...
+	 * do it in the per-thread copy
 	 *
-	 * Disable preemption via get_cpu() - we must not switch away
+	 * Disable preemption - we must not switch away
 	 * because the ->io_bitmap_max value must match the bitmap
 	 * contents:
 	 */
-	tss = &per_cpu(init_tss, get_cpu());
+	preempt_disable();
 
 	set_bitmap(t->io_bitmap_ptr, from, num, !turn_on);
 
@@ -85,10 +104,9 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	t->io_bitmap_max = bytes;
 
-	/* Update the TSS: */
-	memcpy(tss->io_bitmap, t->io_bitmap_ptr, bytes_updated);
+	set_io_bitmap(t, changed, bytes_updated);
 
-	put_cpu();
+	preempt_enable();
 
 	return 0;
 }
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index aa34423..1c15178 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -398,6 +398,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.swapgs = native_swapgs,
 
 	.set_iopl_mask = native_set_iopl_mask,
+	.set_io_bitmap = native_set_io_bitmap,
 	.io_delay = native_io_delay,
 
 	.start_context_switch = paravirt_nop,
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..0c1a4fb 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -71,16 +71,12 @@ void exit_thread(void)
 	unsigned long *bp = t->io_bitmap_ptr;
 
 	if (bp) {
-		struct tss_struct *tss = &per_cpu(init_tss, get_cpu());
-
+		preempt_disable();
 		t->io_bitmap_ptr = NULL;
 		clear_thread_flag(TIF_IO_BITMAP);
-		/*
-		 * Careful, clear this in the TSS too:
-		 */
-		memset(tss->io_bitmap, 0xff, t->io_bitmap_max);
+		set_io_bitmap(t, 1, t->io_bitmap_max);
 		t->io_bitmap_max = 0;
-		put_cpu();
+		preempt_enable();
 		kfree(bp);
 	}
 
@@ -211,19 +207,10 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 			hard_enable_TSC();
 	}
 
-	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
-		/*
-		 * Copy the relevant range of the IO bitmap.
-		 * Normally this is 128 bytes or less:
-		 */
-		memcpy(tss->io_bitmap, next->io_bitmap_ptr,
-		       max(prev->io_bitmap_max, next->io_bitmap_max));
-	} else if (test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)) {
-		/*
-		 * Clear any possible leftover bits:
-		 */
-		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
-	}
+	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP) ||
+	    test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
+		set_io_bitmap(next, 1,
+			      max(prev->io_bitmap_max, next->io_bitmap_max));
 }
 
 int sys_fork(struct pt_regs *regs)
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 784971d..3317c91 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -605,6 +605,21 @@ static void xen_set_iopl_mask(unsigned mask)
 	HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl);
 }
 
+static void xen_set_io_bitmap(struct thread_struct *thread,
+			      int changed, unsigned long bytes_updated)
+{
+	struct physdev_set_iobitmap set_iobitmap;
+
+	if (!changed)
+		return;
+
+	set_xen_guest_handle(set_iobitmap.bitmap,
+			     (char *)thread->io_bitmap_ptr);
+	set_iobitmap.nr_ports = thread->io_bitmap_ptr ? IO_BITMAP_BITS : 0;
+	WARN_ON(HYPERVISOR_physdev_op(PHYSDEVOP_set_iobitmap,
+				      &set_iobitmap));
+}
+
 static void xen_io_delay(void)
 {
 }
@@ -914,6 +929,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.load_sp0 = xen_load_sp0,
 
 	.set_iopl_mask = xen_set_iopl_mask,
+	.set_io_bitmap = xen_set_io_bitmap,
 	.io_delay = xen_io_delay,
 
 	/* Xen takes care of %gs when switching to usermode for us */
-- 
1.6.0.6

