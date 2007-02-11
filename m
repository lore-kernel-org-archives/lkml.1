Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbXBKGft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbXBKGft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXBKGft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:35:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43707 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbXBKGfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:35:46 -0500
Date: Sun, 11 Feb 2007 06:34:31 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
Message-ID: <20070211063431.GS10050@ftp.linux.org.uk>
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CEB720.1020406@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 01:26:40AM -0500, Tejun Heo wrote:
> Christoph Hellwig wrote:
> >I haven't looked at what causes it, but any leakage of pci details
> >into io.h is bogus.  I'd suggest that the original submitter fixes
> >up that problem instead.
> 
> pci_iomap() depends on two things - PCI and iomap.  AFAIK, there is no 
> config to test whether the current arch supports iomap or not. 
> Previously it worked because those archs which don't support either one 
> doesn't have set CONFIG_GENERIC_IOMAP while not implementing 
> arch-specific ones && not compiling any driver which uses the iomap 
> interface.  This is why pci_iomap() ended up in lib/iomap.c in the first 
> place; otherwise, it cannot be conditionalized correctly as devers 
> currently shows (the 'not implementing arch-specific ones' part cannot 
> be easily tested).
> 
> So, it seems what we need is either 1. bogus iomap implementation for 
> all archs or 2. CONFIG_IOMAP.  Hmmm... I think CONFIG_IOMAP is better as 
> it will allow leaving out related devres parts (or any generic function 
> using iomap).

My current version:

>From 97f115834b5ebef4f04e0f18aaa10f78f43733a0 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 10 Feb 2007 23:41:09 -0500
Subject: [PATCH] sort the devres mess out

Split the implementation-agnostic stuff in separate files.
Make sure that targets using non-default request_irq() pull kernel/irq/devres.o
Mark targets that have no ioport_map() and friends, protect the ioport-related
Parts of lib/devres.o with corresponding ifdef (BTW, we need it in driver
dependencies in quite a few of cases, so that symbol was needed anyway).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/arm/Kconfig           |    5 +
 arch/cris/Kconfig          |    3 +
 arch/h8300/Kconfig         |    3 +
 arch/h8300/kernel/Makefile |    4 +-
 arch/m32r/Kconfig          |    3 +
 arch/m68k/Kconfig          |    3 +
 arch/m68k/kernel/Makefile  |    4 +-
 arch/m68knommu/Kconfig     |    3 +
 arch/s390/Kconfig          |    3 +
 arch/sparc/kernel/Makefile |    4 +-
 arch/um/Kconfig            |    3 +
 arch/xtensa/Kconfig        |    3 +
 include/linux/io.h         |    6 -
 include/linux/pci.h        |    5 +
 kernel/irq/Makefile        |    2 +-
 kernel/irq/devres.c        |   88 +++++++++++++
 kernel/irq/manage.c        |   86 -------------
 lib/Kconfig                |    9 +-
 lib/Makefile               |    5 +-
 lib/devres.c               |  300 ++++++++++++++++++++++++++++++++++++++++++++
 lib/iomap.c                |  296 -------------------------------------------
 21 files changed, 442 insertions(+), 396 deletions(-)
 create mode 100644 kernel/irq/devres.c
 create mode 100644 lib/devres.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1523046..7215152 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -29,6 +29,10 @@ config MMU
 	bool
 	default y
 
+config NO_IOPORT
+	bool
+	default n
+
 config EISA
 	bool
 	---help---
@@ -294,6 +298,7 @@ config ARCH_RPC
 	select TIMER_ACORN
 	select ARCH_MAY_HAVE_PC_FDC
 	select ISA_DMA_API
+	select NO_IOPORT
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 3474309..6ad0c79 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -40,6 +40,9 @@ config IRQ_PER_CPU
 	bool
 	default y
 
+config NO_IOPORT
+	def_bool y
+
 config CRIS
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 34a84bc..8978c16 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -53,6 +53,9 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config NO_IOPORT
+	def_bool y
+
 config ISA
 	bool
 	default y
diff --git a/arch/h8300/kernel/Makefile b/arch/h8300/kernel/Makefile
index 71b6131..4edbc2e 100644
--- a/arch/h8300/kernel/Makefile
+++ b/arch/h8300/kernel/Makefile
@@ -6,6 +6,8 @@ extra-y := vmlinux.lds
 
 obj-y := process.o traps.o ptrace.o ints.o \
 	 sys_h8300.o time.o semaphore.o signal.o \
-         setup.o gpio.o init_task.o syscalls.o
+         setup.o gpio.o init_task.o syscalls.o devres.o
+
+devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_MODULES) += module.o h8300_ksyms.o 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index f383dab..ba49442 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -24,6 +24,9 @@ config GENERIC_IRQ_PROBE
 	bool
 	default y
 
+config NO_IOPORT
+	def_bool y
+
 source "init/Kconfig"
 
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 70a577c..c1e3162 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -42,6 +42,9 @@ config ARCH_MAY_HAVE_PC_FDC
 	depends on Q40 || (BROKEN && SUN3X)
 	default y
 
+config NO_IOPORT
+	def_bool y
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index 1c9ecaa..0b68ab8 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -10,7 +10,9 @@ endif
 extra-y	+= vmlinux.lds
 
 obj-y	:= entry.o process.o traps.o ints.o signal.o ptrace.o \
-	   sys_m68k.o time.o semaphore.o setup.o m68k_ksyms.o
+	   sys_m68k.o time.o semaphore.o setup.o m68k_ksyms.o devres.o
+
+devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_PCI)	+= bios32.o
 obj-$(CONFIG_MODULES)	+= module.o
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 25993c2..f23d45c 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -49,6 +49,9 @@ config TIME_LOW_RES
 	bool
 	default y
 
+config NO_IOPORT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index eaed402..c4366aa 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -37,6 +37,9 @@ config GENERIC_HWEIGHT
 config GENERIC_TIME
 	def_bool y
 
+config NO_IOPORT
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/sparc/kernel/Makefile b/arch/sparc/kernel/Makefile
index 6616ee0..e795f28 100644
--- a/arch/sparc/kernel/Makefile
+++ b/arch/sparc/kernel/Makefile
@@ -12,7 +12,9 @@ obj-y    := entry.o wof.o wuf.o etrap.o rtrap.o traps.o $(IRQ_OBJS) \
 	    sys_sparc.o sunos_asm.o systbls.o \
 	    time.o windows.o cpu.o devices.o sclow.o \
 	    tadpole.o tick14.o ptrace.o sys_solaris.o \
-	    unaligned.o muldiv.o semaphore.o prom.o of_device.o
+	    unaligned.o muldiv.o semaphore.o prom.o of_device.o devres.o
+
+devres-y = ../../../kernel/irq/devres.o
 
 obj-$(CONFIG_PCI) += pcic.o
 obj-$(CONFIG_SUN4) += sun4setup.o
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index d32a80e..b3a21ba 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -16,6 +16,9 @@ config MMU
 	bool
 	default y
 
+config NO_IOMEM
+	def_bool y
+
 mainmenu "Linux/Usermode Kernel Configuration"
 
 config ISA
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 2e74cb0..ea615f4 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -42,6 +42,9 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config NO_IOPORT
+	def_bool y
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff --git a/include/linux/io.h b/include/linux/io.h
index 9e419eb..c244a0c 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -43,12 +43,6 @@ void __iomem * devm_ioremap_nocache(struct device *dev, unsigned long offset,
 				    unsigned long size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
 
-void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
-void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
-void __iomem * const * pcim_iomap_table(struct pci_dev *pdev);
-
-int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
-
 /**
  *	check_signature		-	find BIOS signatures
  *	@io_addr: mmio address to check
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9e3042e..98c8765 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -840,6 +840,11 @@ enum pci_fixup_pass {
 
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
 
+void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
+void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
+void __iomem * const * pcim_iomap_table(struct pci_dev *pdev);
+int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
+
 extern int pci_pci_problems;
 #define PCIPCI_FAIL		1	/* No PCI PCI DMA */
 #define PCIPCI_TRITON		2
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 1dab0ac..681c52d 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,5 +1,5 @@
 
-obj-y := handle.o manage.o spurious.o resend.o chip.o
+obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
new file mode 100644
index 0000000..85a430d
--- /dev/null
+++ b/kernel/irq/devres.c
@@ -0,0 +1,88 @@
+#include <linux/module.h>
+#include <linux/interrupt.h>
+
+/*
+ * Device resource management aware IRQ request/free implementation.
+ */
+struct irq_devres {
+	unsigned int irq;
+	void *dev_id;
+};
+
+static void devm_irq_release(struct device *dev, void *res)
+{
+	struct irq_devres *this = res;
+
+	free_irq(this->irq, this->dev_id);
+}
+
+static int devm_irq_match(struct device *dev, void *res, void *data)
+{
+	struct irq_devres *this = res, *match = data;
+
+	return this->irq == match->irq && this->dev_id == match->dev_id;
+}
+
+/**
+ *	devm_request_irq - allocate an interrupt line for a managed device
+ *	@dev: device to request interrupt for
+ *	@irq: Interrupt line to allocate
+ *	@handler: Function to be called when the IRQ occurs
+ *	@irqflags: Interrupt type flags
+ *	@devname: An ascii name for the claiming device
+ *	@dev_id: A cookie passed back to the handler function
+ *
+ *	Except for the extra @dev argument, this function takes the
+ *	same arguments and performs the same function as
+ *	request_irq().  IRQs requested with this function will be
+ *	automatically freed on driver detach.
+ *
+ *	If an IRQ allocated with this function needs to be freed
+ *	separately, dev_free_irq() must be used.
+ */
+int devm_request_irq(struct device *dev, unsigned int irq,
+		     irq_handler_t handler, unsigned long irqflags,
+		     const char *devname, void *dev_id)
+{
+	struct irq_devres *dr;
+	int rc;
+
+	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
+			  GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = request_irq(irq, handler, irqflags, devname, dev_id);
+	if (rc) {
+		kfree(dr);
+		return rc;
+	}
+
+	dr->irq = irq;
+	dr->dev_id = dev_id;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_request_irq);
+
+/**
+ *	devm_free_irq - free an interrupt
+ *	@dev: device to free interrupt for
+ *	@irq: Interrupt line to free
+ *	@dev_id: Device identity to free
+ *
+ *	Except for the extra @dev argument, this function takes the
+ *	same arguments and performs the same function as free_irq().
+ *	This function instead of free_irq() should be used to manually
+ *	free IRQs allocated with dev_request_irq().
+ */
+void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
+{
+	struct irq_devres match_data = { irq, dev_id };
+
+	free_irq(irq, dev_id);
+	WARN_ON(devres_destroy(dev, devm_irq_release, devm_irq_match,
+			       &match_data));
+}
+EXPORT_SYMBOL(devm_free_irq);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c4b7ed1..8b961ad 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -482,89 +482,3 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	return retval;
 }
 EXPORT_SYMBOL(request_irq);
-
-/*
- * Device resource management aware IRQ request/free implementation.
- */
-struct irq_devres {
-	unsigned int irq;
-	void *dev_id;
-};
-
-static void devm_irq_release(struct device *dev, void *res)
-{
-	struct irq_devres *this = res;
-
-	free_irq(this->irq, this->dev_id);
-}
-
-static int devm_irq_match(struct device *dev, void *res, void *data)
-{
-	struct irq_devres *this = res, *match = data;
-
-	return this->irq == match->irq && this->dev_id == match->dev_id;
-}
-
-/**
- *	devm_request_irq - allocate an interrupt line for a managed device
- *	@dev: device to request interrupt for
- *	@irq: Interrupt line to allocate
- *	@handler: Function to be called when the IRQ occurs
- *	@irqflags: Interrupt type flags
- *	@devname: An ascii name for the claiming device
- *	@dev_id: A cookie passed back to the handler function
- *
- *	Except for the extra @dev argument, this function takes the
- *	same arguments and performs the same function as
- *	request_irq().  IRQs requested with this function will be
- *	automatically freed on driver detach.
- *
- *	If an IRQ allocated with this function needs to be freed
- *	separately, dev_free_irq() must be used.
- */
-int devm_request_irq(struct device *dev, unsigned int irq,
-		     irq_handler_t handler, unsigned long irqflags,
-		     const char *devname, void *dev_id)
-{
-	struct irq_devres *dr;
-	int rc;
-
-	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
-			  GFP_KERNEL);
-	if (!dr)
-		return -ENOMEM;
-
-	rc = request_irq(irq, handler, irqflags, devname, dev_id);
-	if (rc) {
-		kfree(dr);
-		return rc;
-	}
-
-	dr->irq = irq;
-	dr->dev_id = dev_id;
-	devres_add(dev, dr);
-
-	return 0;
-}
-EXPORT_SYMBOL(devm_request_irq);
-
-/**
- *	devm_free_irq - free an interrupt
- *	@dev: device to free interrupt for
- *	@irq: Interrupt line to free
- *	@dev_id: Device identity to free
- *
- *	Except for the extra @dev argument, this function takes the
- *	same arguments and performs the same function as free_irq().
- *	This function instead of free_irq() should be used to manually
- *	free IRQs allocated with dev_request_irq().
- */
-void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
-{
-	struct irq_devres match_data = { irq, dev_id };
-
-	free_irq(irq, dev_id);
-	WARN_ON(devres_destroy(dev, devm_irq_release, devm_irq_match,
-			       &match_data));
-}
-EXPORT_SYMBOL(devm_free_irq);
diff --git a/lib/Kconfig b/lib/Kconfig
index 9b03581..3842499 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -101,9 +101,14 @@ config TEXTSEARCH_FSM
 config PLIST
 	boolean
 
-config IOMAP_COPY
+config HAS_IOMEM
 	boolean
-	depends on !UML
+	depends on !NO_IOMEM
+	default y
+
+config HAS_IOPORT
+	boolean
+	depends on HAS_IOMEM && !NO_IOPORT
 	default y
 
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 3b605da..fc4c51e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,14 +12,15 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
-obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o iomap.o
+obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
 CFLAGS_kobject_uevent.o += -DDEBUG
 endif
 
-obj-$(CONFIG_IOMAP_COPY) += iomap_copy.o
+obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
+obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
diff --git a/lib/devres.c b/lib/devres.c
new file mode 100644
index 0000000..2a668dd
--- /dev/null
+++ b/lib/devres.c
@@ -0,0 +1,300 @@
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+static void devm_ioremap_release(struct device *dev, void *res)
+{
+	iounmap(*(void __iomem **)res);
+}
+
+static int devm_ioremap_match(struct device *dev, void *res, void *match_data)
+{
+	return *(void **)res == match_data;
+}
+
+/**
+ * devm_ioremap - Managed ioremap()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ *
+ * Managed ioremap().  Map is automatically unmapped on driver detach.
+ */
+void __iomem *devm_ioremap(struct device *dev, unsigned long offset,
+			   unsigned long size)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap(offset, size);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap);
+
+/**
+ * devm_ioremap_nocache - Managed ioremap_nocache()
+ * @dev: Generic device to remap IO address for
+ * @offset: BUS offset to map
+ * @size: Size of map
+ *
+ * Managed ioremap_nocache().  Map is automatically unmapped on driver
+ * detach.
+ */
+void __iomem *devm_ioremap_nocache(struct device *dev, unsigned long offset,
+				   unsigned long size)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioremap_nocache(offset, size);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioremap_nocache);
+
+/**
+ * devm_iounmap - Managed iounmap()
+ * @dev: Generic device to unmap for
+ * @addr: Address to unmap
+ *
+ * Managed iounmap().  @addr must have been mapped using devm_ioremap*().
+ */
+void devm_iounmap(struct device *dev, void __iomem *addr)
+{
+	iounmap(addr);
+	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
+			       (void *)addr));
+}
+EXPORT_SYMBOL(devm_iounmap);
+
+#ifdef CONFIG_HAS_IOPORT
+/*
+ * Generic iomap devres
+ */
+static void devm_ioport_map_release(struct device *dev, void *res)
+{
+	ioport_unmap(*(void __iomem **)res);
+}
+
+static int devm_ioport_map_match(struct device *dev, void *res,
+				 void *match_data)
+{
+	return *(void **)res == match_data;
+}
+
+/**
+ * devm_ioport_map - Managed ioport_map()
+ * @dev: Generic device to map ioport for
+ * @port: Port to map
+ * @nr: Number of ports to map
+ *
+ * Managed ioport_map().  Map is automatically unmapped on driver
+ * detach.
+ */
+void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
+			       unsigned int nr)
+{
+	void __iomem **ptr, *addr;
+
+	ptr = devres_alloc(devm_ioport_map_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	addr = ioport_map(port, nr);
+	if (addr) {
+		*ptr = addr;
+		devres_add(dev, ptr);
+	} else
+		devres_free(ptr);
+
+	return addr;
+}
+EXPORT_SYMBOL(devm_ioport_map);
+
+/**
+ * devm_ioport_unmap - Managed ioport_unmap()
+ * @dev: Generic device to unmap for
+ * @addr: Address to unmap
+ *
+ * Managed ioport_unmap().  @addr must have been mapped using
+ * devm_ioport_map().
+ */
+void devm_ioport_unmap(struct device *dev, void __iomem *addr)
+{
+	ioport_unmap(addr);
+	WARN_ON(devres_destroy(dev, devm_ioport_map_release,
+			       devm_ioport_map_match, (void *)addr));
+}
+EXPORT_SYMBOL(devm_ioport_unmap);
+
+#ifdef CONFIG_PCI
+/*
+ * PCI iomap devres
+ */
+#define PCIM_IOMAP_MAX	PCI_ROM_RESOURCE
+
+struct pcim_iomap_devres {
+	void __iomem *table[PCIM_IOMAP_MAX];
+};
+
+static void pcim_iomap_release(struct device *gendev, void *res)
+{
+	struct pci_dev *dev = container_of(gendev, struct pci_dev, dev);
+	struct pcim_iomap_devres *this = res;
+	int i;
+
+	for (i = 0; i < PCIM_IOMAP_MAX; i++)
+		if (this->table[i])
+			pci_iounmap(dev, this->table[i]);
+}
+
+/**
+ * pcim_iomap_table - access iomap allocation table
+ * @pdev: PCI device to access iomap table for
+ *
+ * Access iomap allocation table for @dev.  If iomap table doesn't
+ * exist and @pdev is managed, it will be allocated.  All iomaps
+ * recorded in the iomap table are automatically unmapped on driver
+ * detach.
+ *
+ * This function might sleep when the table is first allocated but can
+ * be safely called without context and guaranteed to succed once
+ * allocated.
+ */
+void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
+{
+	struct pcim_iomap_devres *dr, *new_dr;
+
+	dr = devres_find(&pdev->dev, pcim_iomap_release, NULL, NULL);
+	if (dr)
+		return dr->table;
+
+	new_dr = devres_alloc(pcim_iomap_release, sizeof(*new_dr), GFP_KERNEL);
+	if (!new_dr)
+		return NULL;
+	dr = devres_get(&pdev->dev, new_dr, NULL, NULL);
+	return dr->table;
+}
+EXPORT_SYMBOL(pcim_iomap_table);
+
+/**
+ * pcim_iomap - Managed pcim_iomap()
+ * @pdev: PCI device to iomap for
+ * @bar: BAR to iomap
+ * @maxlen: Maximum length of iomap
+ *
+ * Managed pci_iomap().  Map is automatically unmapped on driver
+ * detach.
+ */
+void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
+{
+	void __iomem **tbl;
+
+	BUG_ON(bar >= PCIM_IOMAP_MAX);
+
+	tbl = (void __iomem **)pcim_iomap_table(pdev);
+	if (!tbl || tbl[bar])	/* duplicate mappings not allowed */
+		return NULL;
+
+	tbl[bar] = pci_iomap(pdev, bar, maxlen);
+	return tbl[bar];
+}
+EXPORT_SYMBOL(pcim_iomap);
+
+/**
+ * pcim_iounmap - Managed pci_iounmap()
+ * @pdev: PCI device to iounmap for
+ * @addr: Address to unmap
+ *
+ * Managed pci_iounmap().  @addr must have been mapped using pcim_iomap().
+ */
+void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr)
+{
+	void __iomem **tbl;
+	int i;
+
+	pci_iounmap(pdev, addr);
+
+	tbl = (void __iomem **)pcim_iomap_table(pdev);
+	BUG_ON(!tbl);
+
+	for (i = 0; i < PCIM_IOMAP_MAX; i++)
+		if (tbl[i] == addr) {
+			tbl[i] = NULL;
+			return;
+		}
+	WARN_ON(1);
+}
+EXPORT_SYMBOL(pcim_iounmap);
+
+/**
+ * pcim_iomap_regions - Request and iomap PCI BARs
+ * @pdev: PCI device to map IO resources for
+ * @mask: Mask of BARs to request and iomap
+ * @name: Name used when requesting regions
+ *
+ * Request and iomap regions specified by @mask.
+ */
+int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
+{
+	void __iomem * const *iomap;
+	int i, rc;
+
+	iomap = pcim_iomap_table(pdev);
+	if (!iomap)
+		return -ENOMEM;
+
+	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+		unsigned long len;
+
+		if (!(mask & (1 << i)))
+			continue;
+
+		rc = -EINVAL;
+		len = pci_resource_len(pdev, i);
+		if (!len)
+			goto err_inval;
+
+		rc = pci_request_region(pdev, i, name);
+		if (rc)
+			goto err_region;
+
+		rc = -ENOMEM;
+		if (!pcim_iomap(pdev, i, 0))
+			goto err_iomap;
+	}
+
+	return 0;
+
+ err_iomap:
+	pcim_iounmap(pdev, iomap[i]);
+ err_region:
+	pci_release_region(pdev, i);
+ err_inval:
+	while (--i >= 0) {
+		pcim_iounmap(pdev, iomap[i]);
+		pci_release_region(pdev, i);
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL(pcim_iomap_regions);
+#endif
+#endif
diff --git a/lib/iomap.c b/lib/iomap.c
index 4990c73..4d43f37 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -6,7 +6,6 @@
 #include <linux/pci.h>
 #include <linux/io.h>
 
-#ifdef CONFIG_GENERIC_IOMAP
 #include <linux/module.h>
 
 /*
@@ -256,298 +255,3 @@ void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 }
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
-
-#endif /* CONFIG_GENERIC_IOMAP */
-
-/*
- * Generic iomap devres
- */
-static void devm_ioport_map_release(struct device *dev, void *res)
-{
-	ioport_unmap(*(void __iomem **)res);
-}
-
-static int devm_ioport_map_match(struct device *dev, void *res,
-				 void *match_data)
-{
-	return *(void **)res == match_data;
-}
-
-/**
- * devm_ioport_map - Managed ioport_map()
- * @dev: Generic device to map ioport for
- * @port: Port to map
- * @nr: Number of ports to map
- *
- * Managed ioport_map().  Map is automatically unmapped on driver
- * detach.
- */
-void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
-			       unsigned int nr)
-{
-	void __iomem **ptr, *addr;
-
-	ptr = devres_alloc(devm_ioport_map_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return NULL;
-
-	addr = ioport_map(port, nr);
-	if (addr) {
-		*ptr = addr;
-		devres_add(dev, ptr);
-	} else
-		devres_free(ptr);
-
-	return addr;
-}
-EXPORT_SYMBOL(devm_ioport_map);
-
-/**
- * devm_ioport_unmap - Managed ioport_unmap()
- * @dev: Generic device to unmap for
- * @addr: Address to unmap
- *
- * Managed ioport_unmap().  @addr must have been mapped using
- * devm_ioport_map().
- */
-void devm_ioport_unmap(struct device *dev, void __iomem *addr)
-{
-	ioport_unmap(addr);
-	WARN_ON(devres_destroy(dev, devm_ioport_map_release,
-			       devm_ioport_map_match, (void *)addr));
-}
-EXPORT_SYMBOL(devm_ioport_unmap);
-
-static void devm_ioremap_release(struct device *dev, void *res)
-{
-	iounmap(*(void __iomem **)res);
-}
-
-static int devm_ioremap_match(struct device *dev, void *res, void *match_data)
-{
-	return *(void **)res == match_data;
-}
-
-/**
- * devm_ioremap - Managed ioremap()
- * @dev: Generic device to remap IO address for
- * @offset: BUS offset to map
- * @size: Size of map
- *
- * Managed ioremap().  Map is automatically unmapped on driver detach.
- */
-void __iomem *devm_ioremap(struct device *dev, unsigned long offset,
-			   unsigned long size)
-{
-	void __iomem **ptr, *addr;
-
-	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return NULL;
-
-	addr = ioremap(offset, size);
-	if (addr) {
-		*ptr = addr;
-		devres_add(dev, ptr);
-	} else
-		devres_free(ptr);
-
-	return addr;
-}
-EXPORT_SYMBOL(devm_ioremap);
-
-/**
- * devm_ioremap_nocache - Managed ioremap_nocache()
- * @dev: Generic device to remap IO address for
- * @offset: BUS offset to map
- * @size: Size of map
- *
- * Managed ioremap_nocache().  Map is automatically unmapped on driver
- * detach.
- */
-void __iomem *devm_ioremap_nocache(struct device *dev, unsigned long offset,
-				   unsigned long size)
-{
-	void __iomem **ptr, *addr;
-
-	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
-		return NULL;
-
-	addr = ioremap_nocache(offset, size);
-	if (addr) {
-		*ptr = addr;
-		devres_add(dev, ptr);
-	} else
-		devres_free(ptr);
-
-	return addr;
-}
-EXPORT_SYMBOL(devm_ioremap_nocache);
-
-/**
- * devm_iounmap - Managed iounmap()
- * @dev: Generic device to unmap for
- * @addr: Address to unmap
- *
- * Managed iounmap().  @addr must have been mapped using devm_ioremap*().
- */
-void devm_iounmap(struct device *dev, void __iomem *addr)
-{
-	iounmap(addr);
-	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
-			       (void *)addr));
-}
-EXPORT_SYMBOL(devm_iounmap);
-
-/*
- * PCI iomap devres
- */
-#define PCIM_IOMAP_MAX	PCI_ROM_RESOURCE
-
-struct pcim_iomap_devres {
-	void __iomem *table[PCIM_IOMAP_MAX];
-};
-
-static void pcim_iomap_release(struct device *gendev, void *res)
-{
-	struct pci_dev *dev = container_of(gendev, struct pci_dev, dev);
-	struct pcim_iomap_devres *this = res;
-	int i;
-
-	for (i = 0; i < PCIM_IOMAP_MAX; i++)
-		if (this->table[i])
-			pci_iounmap(dev, this->table[i]);
-}
-
-/**
- * pcim_iomap_table - access iomap allocation table
- * @pdev: PCI device to access iomap table for
- *
- * Access iomap allocation table for @dev.  If iomap table doesn't
- * exist and @pdev is managed, it will be allocated.  All iomaps
- * recorded in the iomap table are automatically unmapped on driver
- * detach.
- *
- * This function might sleep when the table is first allocated but can
- * be safely called without context and guaranteed to succed once
- * allocated.
- */
-void __iomem * const * pcim_iomap_table(struct pci_dev *pdev)
-{
-	struct pcim_iomap_devres *dr, *new_dr;
-
-	dr = devres_find(&pdev->dev, pcim_iomap_release, NULL, NULL);
-	if (dr)
-		return dr->table;
-
-	new_dr = devres_alloc(pcim_iomap_release, sizeof(*new_dr), GFP_KERNEL);
-	if (!new_dr)
-		return NULL;
-	dr = devres_get(&pdev->dev, new_dr, NULL, NULL);
-	return dr->table;
-}
-EXPORT_SYMBOL(pcim_iomap_table);
-
-/**
- * pcim_iomap - Managed pcim_iomap()
- * @pdev: PCI device to iomap for
- * @bar: BAR to iomap
- * @maxlen: Maximum length of iomap
- *
- * Managed pci_iomap().  Map is automatically unmapped on driver
- * detach.
- */
-void __iomem * pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
-{
-	void __iomem **tbl;
-
-	BUG_ON(bar >= PCIM_IOMAP_MAX);
-
-	tbl = (void __iomem **)pcim_iomap_table(pdev);
-	if (!tbl || tbl[bar])	/* duplicate mappings not allowed */
-		return NULL;
-
-	tbl[bar] = pci_iomap(pdev, bar, maxlen);
-	return tbl[bar];
-}
-EXPORT_SYMBOL(pcim_iomap);
-
-/**
- * pcim_iounmap - Managed pci_iounmap()
- * @pdev: PCI device to iounmap for
- * @addr: Address to unmap
- *
- * Managed pci_iounmap().  @addr must have been mapped using pcim_iomap().
- */
-void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr)
-{
-	void __iomem **tbl;
-	int i;
-
-	pci_iounmap(pdev, addr);
-
-	tbl = (void __iomem **)pcim_iomap_table(pdev);
-	BUG_ON(!tbl);
-
-	for (i = 0; i < PCIM_IOMAP_MAX; i++)
-		if (tbl[i] == addr) {
-			tbl[i] = NULL;
-			return;
-		}
-	WARN_ON(1);
-}
-EXPORT_SYMBOL(pcim_iounmap);
-
-/**
- * pcim_iomap_regions - Request and iomap PCI BARs
- * @pdev: PCI device to map IO resources for
- * @mask: Mask of BARs to request and iomap
- * @name: Name used when requesting regions
- *
- * Request and iomap regions specified by @mask.
- */
-int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name)
-{
-	void __iomem * const *iomap;
-	int i, rc;
-
-	iomap = pcim_iomap_table(pdev);
-	if (!iomap)
-		return -ENOMEM;
-
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-		unsigned long len;
-
-		if (!(mask & (1 << i)))
-			continue;
-
-		rc = -EINVAL;
-		len = pci_resource_len(pdev, i);
-		if (!len)
-			goto err_inval;
-
-		rc = pci_request_region(pdev, i, name);
-		if (rc)
-			goto err_region;
-
-		rc = -ENOMEM;
-		if (!pcim_iomap(pdev, i, 0))
-			goto err_iomap;
-	}
-
-	return 0;
-
- err_iomap:
-	pcim_iounmap(pdev, iomap[i]);
- err_region:
-	pci_release_region(pdev, i);
- err_inval:
-	while (--i >= 0) {
-		pcim_iounmap(pdev, iomap[i]);
-		pci_release_region(pdev, i);
-	}
-
-	return rc;
-}
-EXPORT_SYMBOL(pcim_iomap_regions);
-- 
1.5.0-rc2.GIT

