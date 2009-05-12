Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZELX0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZELX0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZELXZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:25:27 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36159
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595AbZELXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:25:24 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/17] xen: implement io_apic_ops
Date: Tue, 12 May 2009 16:25:10 -0700
Message-Id: <1242170724-13349-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170724-13349-1-git-send-email-jeremy@goop.org>
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writes to the IO APIC are paravirtualized via hypercalls, so implement
the appropriate operations.

[ Impact: implement Xen interface for io_apic_ops ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile    |    2 +-
 arch/x86/xen/apic.c      |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |    2 +
 arch/x86/xen/xen-ops.h   |    6 ++++
 4 files changed, 73 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/xen/apic.c

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
index 0000000..8ae563c
--- /dev/null
+++ b/arch/x86/xen/apic.c
@@ -0,0 +1,64 @@
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
+static void __init xen_io_apic_init(void)
+{
+}
+
+static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
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
+static void xen_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
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
+static struct io_apic_ops __initdata xen_ioapic_ops = {
+	.init = xen_io_apic_init,
+	.read = xen_io_apic_read,
+	.write = xen_io_apic_write,
+	.modify = xen_io_apic_write,
+};
+
+void xen_init_apic(void)
+{
+	if (!xen_initial_domain())
+		return;
+
+	set_io_apic_ops(&xen_ioapic_ops);
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
index 12e4d9c..3a4932a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1085,6 +1085,8 @@ asmlinkage void __init xen_start_kernel(void)
 		set_iopl.iopl = 1;
 		if (HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl) == -1)
 			BUG();
+
+		xen_init_apic();
 	}
 
 	/* set the limit of our address space */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 40abcef..0853949 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -76,13 +76,19 @@ struct dom0_vga_console_info;
 
 #ifdef CONFIG_XEN_DOM0
 void xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+void xen_init_apic(void);
 #else
 static inline void xen_init_vga(const struct dom0_vga_console_info *info,
 				size_t size)
 {
 }
+
+static inline void xen_init_apic(void)
+{
+}
 #endif
 
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
-- 
1.6.0.6

