Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYKMToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYKMToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYKMTeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:31 -0500
Received: from gw.goop.org ([64.81.55.164]:34442 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYKMTeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 30 of 38] xen: implement io_apic_ops
X-Mercurial-Node: d103c0da2fa147ac31af29a8e15b5ecf1c029c33
Message-Id: <d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writes to the IO APIC are paravirtualized via hypercalls, so implement
the appropriate operations.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/Makefile    |    3 +-
 arch/x86/xen/apic.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c |    2 +
 arch/x86/xen/xen-ops.h   |    2 +
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -9,4 +9,5 @@
 			time.o xen-asm_$(BITS).o grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
+obj-$(CONFIG_XEN_DOM0)		+= apic.o
diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/xen/apic.c
@@ -0,0 +1,66 @@
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
+	printk("xen apic init\n");
+	dump_stack();
+}
+
+static unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
+{
+	struct physdev_apic apic_op;
+	int ret;
+
+	apic_op.apic_physbase = mp_ioapics[apic].mp_apicaddr;
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
+	apic_op.apic_physbase = mp_ioapics[apic].mp_apicaddr;
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
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1750,6 +1750,8 @@
 		set_iopl.iopl = 1;
 		if (HYPERVISOR_physdev_op(PHYSDEVOP_set_iopl, &set_iopl) == -1)
 			BUG();
+
+		xen_init_apic();
 	}
 
 	/* set the limit of our address space */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -64,6 +64,8 @@
 #endif
 
 
+void xen_init_apic(void);
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\


