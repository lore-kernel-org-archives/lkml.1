Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbXEIIsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbXEIIsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXEIIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:48:16 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:51930 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754124AbXEIIsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:48:15 -0400
Date: Wed, 9 May 2007 10:48:05 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 update
Message-ID: <20070509104805.76fb793d@dhcp-252-105.norway.atmel.com>
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

Haavard Skinnemoen (4):
      [AVR32] Use correct config symbol when setting cpuflags
      [AVR32] Implement dma_{alloc,free}_writecombine()
      [AVR32] Fix section mismatch .taglist -> .init.text
      [AVR32] Wire up sys_utimensat

Thomas Gleixner (1):
      AVR32: Spinlock initializer cleanup

 arch/avr32/Makefile               |    2 +-
 arch/avr32/kernel/syscall_table.S |    1 +
 arch/avr32/kernel/traps.c         |    2 +-
 arch/avr32/kernel/vmlinux.lds.c   |    2 +-
 arch/avr32/mach-at32ap/clock.c    |    2 +-
 arch/avr32/mm/dma-coherent.c      |   12 ++++++++----
 include/asm-avr32/setup.h         |    2 +-
 include/asm-avr32/unistd.h        |    4 +++-
 8 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/Makefile b/arch/avr32/Makefile
index 6115fc1..dc6bc01 100644
--- a/arch/avr32/Makefile
+++ b/arch/avr32/Makefile
@@ -16,7 +16,7 @@ AFLAGS		+= -mrelax -mno-pic
 CFLAGS_MODULE	+= -mno-relax
 LDFLAGS_vmlinux	+= --relax
 
-cpuflags-$(CONFIG_CPU_AP7000)	+= -mcpu=ap7000
+cpuflags-$(CONFIG_CPU_AT32AP7000)	+= -mcpu=ap7000
 
 CFLAGS		+= $(cpuflags-y)
 AFLAGS		+= $(cpuflags-y)
diff --git a/arch/avr32/kernel/syscall_table.S b/arch/avr32/kernel/syscall_table.S
index 7c27958..07f6a6f 100644
--- a/arch/avr32/kernel/syscall_table.S
+++ b/arch/avr32/kernel/syscall_table.S
@@ -291,4 +291,5 @@ sys_call_table:
 	.long	sys_shmget		/* 275 */
 	.long	sys_shmdt
 	.long	sys_shmctl
+	.long	sys_utimensat
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 4de9edf..86d1075 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -123,7 +123,7 @@ asmlinkage void do_address_exception(unsigned long ecr, struct pt_regs *regs)
 
 /* This way of handling undefined instructions is stolen from ARM */
 static LIST_HEAD(undef_hook);
-static spinlock_t undef_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(undef_lock);
 
 void register_undef_hook(struct undef_hook *hook)
 {
diff --git a/arch/avr32/kernel/vmlinux.lds.c b/arch/avr32/kernel/vmlinux.lds.c
index 7ad20cf..e7f72c9 100644
--- a/arch/avr32/kernel/vmlinux.lds.c
+++ b/arch/avr32/kernel/vmlinux.lds.c
@@ -35,7 +35,7 @@ SECTIONS
 			_einittext = .;
 		. = ALIGN(4);
 		__tagtable_begin = .;
-			*(.taglist)
+			*(.taglist.init)
 		__tagtable_end = .;
 			*(.init.data)
 		. = ALIGN(16);
diff --git a/arch/avr32/mach-at32ap/clock.c b/arch/avr32/mach-at32ap/clock.c
index 00c4354..0f8c89c 100644
--- a/arch/avr32/mach-at32ap/clock.c
+++ b/arch/avr32/mach-at32ap/clock.c
@@ -18,7 +18,7 @@
 
 #include "clock.h"
 
-static spinlock_t clk_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(clk_lock);
 
 struct clk *clk_get(struct device *dev, const char *id)
 {
diff --git a/arch/avr32/mm/dma-coherent.c b/arch/avr32/mm/dma-coherent.c
index b68d669..099212d 100644
--- a/arch/avr32/mm/dma-coherent.c
+++ b/arch/avr32/mm/dma-coherent.c
@@ -112,16 +112,21 @@ void dma_free_coherent(struct device *dev, size_t size,
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-#if 0
 void *dma_alloc_writecombine(struct device *dev, size_t size,
 			     dma_addr_t *handle, gfp_t gfp)
 {
 	struct page *page;
+	dma_addr_t phys;
 
 	page = __dma_alloc(dev, size, handle, gfp);
+	if (!page)
+		return NULL;
+
+	phys = page_to_phys(page);
+	*handle = phys;
 
 	/* Now, map the page into P3 with write-combining turned on */
-	return __ioremap(page_to_phys(page), size, _PAGE_BUFFER);
+	return __ioremap(phys, size, _PAGE_BUFFER);
 }
 EXPORT_SYMBOL(dma_alloc_writecombine);
 
@@ -132,8 +137,7 @@ void dma_free_writecombine(struct device *dev, size_t size,
 
 	iounmap(cpu_addr);
 
-	page = bus_to_page(handle);
+	page = phys_to_page(handle);
 	__dma_free(dev, size, page, handle);
 }
 EXPORT_SYMBOL(dma_free_writecombine);
-#endif
diff --git a/include/asm-avr32/setup.h b/include/asm-avr32/setup.h
index 1ff1a21..b0828d4 100644
--- a/include/asm-avr32/setup.h
+++ b/include/asm-avr32/setup.h
@@ -110,7 +110,7 @@ struct tagtable {
 	int	(*parse)(struct tag *);
 };
 
-#define __tag __attribute_used__ __attribute__((__section__(".taglist")))
+#define __tag __attribute_used__ __attribute__((__section__(".taglist.init")))
 #define __tagtable(tag, fn)						\
 	static struct tagtable __tagtable_##fn __tag = { tag, fn }
 
diff --git a/include/asm-avr32/unistd.h b/include/asm-avr32/unistd.h
index 8f51204..2418cce 100644
--- a/include/asm-avr32/unistd.h
+++ b/include/asm-avr32/unistd.h
@@ -295,8 +295,10 @@
 #define __NR_shmdt		276
 #define __NR_shmctl		277
 
+#define __NR_utimensat		278
+
 #ifdef __KERNEL__
-#define NR_syscalls		278
+#define NR_syscalls		279
 
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
