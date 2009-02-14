Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbZBNBup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbZBNBup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932711AbZBNBoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:44:03 -0500
Received: from gw.goop.org ([64.81.55.164]:51053 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932706AbZBNBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:43:58 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/9] xen: hook io_apic read/write operations
Date: Fri, 13 Feb 2009 17:12:00 -0800
Message-Id: <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/io_apic.h |    6 ++++
 arch/x86/kernel/io_apic.c      |   32 ++++++++++++++++++++--
 arch/x86/xen/Makefile          |    3 +-
 arch/x86/xen/apic.c            |   57 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/xen-ops.h         |    6 ++++
 6 files changed, 102 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/xen/apic.c

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 59cb4a1..20b543a 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -183,4 +183,10 @@ static inline void ioapic_init_mappings(void)	{ }
 static inline void probe_nr_irqs_gsi(void)	{ }
 #endif
 
+void xen_io_apic_init(void);
+unsigned int xen_io_apic_read(unsigned apic, unsigned reg);
+void xen_io_apic_write(unsigned int apic,
+		       unsigned int reg, unsigned int value);
+
+
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 7248ca1..de0368a 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -62,6 +62,8 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 
+#include <asm/xen/hypervisor.h>
+
 #include <asm/genapic.h>
 
 #define __apicdebuginit(type) static type __init
@@ -399,14 +401,26 @@ static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 
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
@@ -419,7 +433,14 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
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
@@ -4113,6 +4134,11 @@ void __init ioapic_init_mappings(void)
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
index 3b767d0..853d05e 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -10,4 +10,5 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
+obj-$(CONFIG_XEN_DOM0)		+= apic.o
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
index c4dff5f..d775178 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -985,6 +985,8 @@ asmlinkage void __init xen_start_kernel(void)
 		set_iopl.iopl = 1;
 		if (HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl) == -1)
 			BUG();
+
+		xen_init_apic();
 	}
 
 	/* set the limit of our address space */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 33f7538..fc6dd18 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -75,6 +75,12 @@ static inline void xen_smp_init(void) {}
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

