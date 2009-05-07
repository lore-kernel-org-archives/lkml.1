Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbZEHAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbZEHAV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbZEHAK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:28 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52711
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756715AbZEHAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:01 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/18] xen: hook io_apic read/write operations
Date: Thu,  7 May 2009 14:14:27 -0700
Message-Id: <1241730883-4917-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: paravirtualize io_apic_read/write

In Xen, writes to the IO APIC are paravirtualized via hypercalls, so
implement the appropriate operations.

This version of the patch just hooks the io_apic read/write functions
directly, rather than introducing another layer of indirection.  The
xen_initial_domain() tests compile to 0 if CONFIG_XEN_DOM0 isn't set,
and are cheap if it is.

(An alternative would be to add io_apic_ops, and point them to the Xen
implementation as needed.  HPA deemed this extra level of indirection to
be excessive.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/io_apic.h |    6 ++++
 arch/x86/kernel/apic/io_apic.c |   32 ++++++++++++++++++++--
 arch/x86/xen/Makefile          |    2 +-
 arch/x86/xen/apic.c            |   57 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/xen-ops.h         |    6 ++++
 6 files changed, 101 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/xen/apic.c

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9d826e4..894ffb8 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -187,4 +187,10 @@ static inline void ioapic_init_mappings(void)	{ }
 static inline void probe_nr_irqs_gsi(void)	{ }
 #endif
 
+void xen_io_apic_init(void);
+unsigned int xen_io_apic_read(unsigned apic, unsigned reg);
+void xen_io_apic_write(unsigned int apic,
+		       unsigned int reg, unsigned int value);
+
+
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..c8240f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -62,8 +62,10 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 
+#include <asm/xen/hypervisor.h>
 #include <asm/apic.h>
 
+
 #define __apicdebuginit(type) static type __init
 
 /*
@@ -407,14 +409,26 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic;
+
+	if (xen_initial_domain())
+		return xen_io_apic_read(apic, reg);
+
+	io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
 static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic;
+
+	if (xen_initial_domain()) {
+		xen_io_apic_write(apic, reg, value);
+		return;
+	}
+
+	io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
 }
@@ -427,7 +441,14 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
  */
 static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
-	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	struct io_apic __iomem *io_apic;
+
+	if (xen_initial_domain()) {
+		xen_io_apic_write(apic, reg, value);
+		return;
+	}
+
+	io_apic = io_apic_base(apic);
 
 	if (sis_apic_bug)
 		writel(reg, &io_apic->index);
@@ -4140,6 +4161,11 @@ void __init ioapic_init_mappings(void)
 	struct resource *ioapic_res;
 	int i;
 
+	if (xen_initial_domain()) {
+		xen_io_apic_init();
+		return;
+	}
+
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index c4cda96..73ecb74 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -11,4 +11,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
-obj-$(CONFIG_XEN_DOM0)		+= vga.o
+obj-$(CONFIG_XEN_DOM0)		+= vga.o apic.o
diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
new file mode 100644
index 0000000..17736a0
--- /dev/null
+++ b/arch/x86/xen/apic.c
@@ -0,0 +1,57 @@
+#include <linux/kernel.h>
+#include <linux/threads.h>
+#include <linux/bitmap.h>
+
+#include <asm/io_apic.h>
+#include <asm/acpi.h>
+
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/physdev.h>
+
+void __init xen_io_apic_init(void)
+{
+	printk("xen apic init\n");
+	dump_stack();
+}
+
+unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
+{
+	struct physdev_apic apic_op;
+	int ret;
+
+	apic_op.apic_physbase = mp_ioapics[apic].apicaddr;
+	apic_op.reg = reg;
+	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
+	if (ret)
+		BUG();
+	return apic_op.value;
+}
+
+
+void xen_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	struct physdev_apic apic_op;
+
+	apic_op.apic_physbase = mp_ioapics[apic].apicaddr;
+	apic_op.reg = reg;
+	apic_op.value = value;
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_apic_write, &apic_op))
+		BUG();
+}
+
+void xen_init_apic(void)
+{
+	if (!xen_initial_domain())
+		return;
+
+#ifdef CONFIG_ACPI
+	/*
+	 * Pretend ACPI found our lapic even though we've disabled it,
+ 	 * to prevent MP tables from setting up lapics.
+ 	 */
+	acpi_lapic = 1;
+#endif
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2d0341f..0ce10ef 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1034,6 +1034,8 @@ asmlinkage void __init xen_start_kernel(void)
 		set_iopl.iopl = 1;
 		if (HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl) == -1)
 			BUG();
+
+		xen_init_apic();
 	}
 
 	/* set the limit of our address space */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 40abcef..82ba25c 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -83,6 +83,12 @@ static inline void xen_init_vga(const struct dom0_vga_console_info *info,
 }
 #endif
 
+#ifdef CONFIG_XEN_DOM0
+void xen_init_apic(void);
+#else
+static inline void xen_init_apic(void) {}
+#endif
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
-- 
1.6.0.6

