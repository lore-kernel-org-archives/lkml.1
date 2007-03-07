Return-Path: <linux-kernel-owner+w=401wt.eu-S1422710AbXCGKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422710AbXCGKKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422714AbXCGKKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:10:25 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50208 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422710AbXCGKKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:10:22 -0500
Date: Wed, 7 Mar 2007 11:10:09 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 fixes
Message-ID: <20070307111009.67b45efd@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'for-linus' branch of

git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates.

Gary Zambrano (1):
      avr32: dma-mapping.h

Haavard Skinnemoen (5):
      [AVR32] at32_spi_setup_slaves should be __init
      [AVR32] show_trace: Only walk valid stack addresses
      [AVR32] Fix typo in include/asm-avr32/Kbuild
      [AVR32] Fix bogus ti->flags manipulation in debug handler
      [AVR32] Don't use kmap() in flush_icache_page()

 arch/avr32/kernel/ptrace.c          |    4 +-
 arch/avr32/kernel/traps.c           |   52 +++++++++++++++++++---------------
 arch/avr32/mach-at32ap/at32ap7000.c |    2 +-
 arch/avr32/mm/cache.c               |    3 +-
 include/asm-avr32/Kbuild            |    2 +-
 include/asm-avr32/dma-mapping.h     |   18 ++++++++++++
 6 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index f2e81cd..6f4388f 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -313,7 +313,7 @@ asmlinkage void do_debug_priv(struct pt_regs *regs)
 		__mtdr(DBGREG_DC, dc);
 
 		ti = current_thread_info();
-		ti->flags |= _TIF_BREAKPOINT;
+		set_ti_thread_flag(ti, TIF_BREAKPOINT);
 
 		/* The TLB miss handlers don't check thread flags */
 		if ((regs->pc >= (unsigned long)&itlb_miss)
@@ -328,7 +328,7 @@ asmlinkage void do_debug_priv(struct pt_regs *regs)
 		 * single step.
 		 */
 		if ((regs->sr & MODE_MASK) != MODE_SUPERVISOR)
-			ti->flags |= TIF_SINGLE_STEP;
+			set_ti_thread_flag(ti, TIF_SINGLE_STEP);
 	} else {
 		panic("Unable to handle debug trap at pc = %08lx\n",
 		      regs->pc);
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 7e803f4..adc01a1 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -49,39 +49,45 @@ out:
 	return;
 }
 
+static inline int valid_stack_ptr(struct thread_info *tinfo, unsigned long p)
+{
+	return (p > (unsigned long)tinfo)
+		&& (p < (unsigned long)tinfo + THREAD_SIZE - 3);
+}
+
 #ifdef CONFIG_FRAME_POINTER
 static inline void __show_trace(struct task_struct *tsk, unsigned long *sp,
 				struct pt_regs *regs)
 {
-	unsigned long __user *fp;
-	unsigned long __user *last_fp = NULL;
-
-	if (regs) {
-		fp = (unsigned long __user *)regs->r7;
-	} else if (tsk == current) {
-		register unsigned long __user *real_fp __asm__("r7");
-		fp = real_fp;
-	} else {
-		fp = (unsigned long __user *)tsk->thread.cpu_context.r7;
-	}
+	unsigned long lr, fp;
+	struct thread_info *tinfo;
+
+	tinfo = (struct thread_info *)
+		((unsigned long)sp & ~(THREAD_SIZE - 1));
+
+	if (regs)
+		fp = regs->r7;
+	else if (tsk == current)
+		asm("mov %0, r7" : "=r"(fp));
+	else
+		fp = tsk->thread.cpu_context.r7;
 
 	/*
-	 * Walk the stack until (a) we get an exception, (b) the frame
-	 * pointer becomes zero, or (c) the frame pointer gets stuck
-	 * at the same value.
+	 * Walk the stack as long as the frame pointer (a) is within
+	 * the kernel stack of the task, and (b) it doesn't move
+	 * downwards.
 	 */
-	while (fp && fp != last_fp) {
-		unsigned long lr, new_fp = 0;
-
-		last_fp = fp;
-		if (__get_user(lr, fp))
-			break;
-		if (fp && __get_user(new_fp, fp + 1))
-			break;
-		fp = (unsigned long __user *)new_fp;
+	while (valid_stack_ptr(tinfo, fp)) {
+		unsigned long new_fp;
 
+		lr = *(unsigned long *)fp;
 		printk(" [<%08lx>] ", lr);
 		print_symbol("%s\n", lr);
+
+		new_fp = *(unsigned long *)(fp + 4);
+		if (new_fp <= fp)
+			break;
+		fp = new_fp;
 	}
 	printk("\n");
 }
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index bc23550..472703f 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -752,7 +752,7 @@ static struct resource atmel_spi1_resource[] = {
 DEFINE_DEV(atmel_spi, 1);
 DEV_CLK(spi_clk, atmel_spi1, pba, 1);
 
-static void
+static void __init
 at32_spi_setup_slaves(unsigned int bus_num, struct spi_board_info *b,
 		      unsigned int n, const u8 *pins)
 {
diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index fb13f72..8f7b1c3 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -121,9 +121,8 @@ void flush_icache_range(unsigned long start, unsigned long end)
 void flush_icache_page(struct vm_area_struct *vma, struct page *page)
 {
 	if (vma->vm_flags & VM_EXEC) {
-		void *v = kmap(page);
+		void *v = page_address(page);
 		__flush_icache_range((unsigned long)v, (unsigned long)v + PAGE_SIZE);
-		kunmap(v);
 	}
 }
 
diff --git a/include/asm-avr32/Kbuild b/include/asm-avr32/Kbuild
index 8770e73..3136628 100644
--- a/include/asm-avr32/Kbuild
+++ b/include/asm-avr32/Kbuild
@@ -1,3 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
-headers-y	+= cachectl.h
+header-y	+= cachectl.h
diff --git a/include/asm-avr32/dma-mapping.h b/include/asm-avr32/dma-mapping.h
index 115813e..21bb60b 100644
--- a/include/asm-avr32/dma-mapping.h
+++ b/include/asm-avr32/dma-mapping.h
@@ -274,6 +274,24 @@ dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
 	dma_cache_sync(dev, bus_to_virt(dma_handle), size, direction);
 }
 
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	/* just sync everything, that's all the pci API can do */
+	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
+}
+
 /**
  * dma_sync_sg_for_cpu
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
