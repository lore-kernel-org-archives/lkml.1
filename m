Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbZBNBvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbZBNBvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764107AbZBNBoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:44:07 -0500
Received: from gw.goop.org ([64.81.55.164]:51049 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932697AbZBNBoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:44:01 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 0/9] x86/apic: hooks for Xen dom0 support
Date: Fri, 13 Feb 2009 17:07:37 -0800
Message-Id: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This series adds a some hooks into the APIC code to allow Xen's dom0
support to hook in.

A dom0 kernel's interactions with the hypervisor and the platform
interrupt hardware are... interesting.

The overview is:

Xen itself owns the local APICs, and the kernel is not allowed to
touch them directly.  Instead, interrupts from hardware are
delivered like all other interrupts in Xen: as events coming over
an event channel.  This means that Xen is also responsible for
vector allocation.

The dom0 kernel does, however, own the IO APICs, and is responsible
for programming them appropriately.  It uses ACPI to do the interrupt
routing to find the GSI for a given device, and then asks Xen to
allocate a vector for it, which gets mapped to an event channel.  It
then programs that vector into the IO APICs so that hardware
interrupts are deliverered on that event channel.  When an event is
raised, it feeds it into the kernel's normal interrupt handling path
to be distributed among the interested device drivers as normal.

Details:

1. We change acpi_register_lapic and acpi_register_lapic_address to
   prevent the lapics from actually being registered under Xen.  We
   still want them to be discovered by ACPI, just not used.

2. Despite controlled the IO APICs, the dom0 kernel can't map them
   directly as usual, but must program their registers via hypercalls,
   so we need to hook into the io_apic accessors accordingly.  This is
   done with an explicit test and call for Xen, rather than being
   abstracted via an _ops layer, on the grounds that this is something
   that's unlikely for anyone else to want to do (and we can always
   add an _ops layer if there's a second user).

3. Hook acpi_register_gsi(). This sets up all the pirq event channel
   state for the gsi, including allocating an event channel bound to a
   vector and setting up the routing.  It returns the irq, which is always
   equal to the gsi.


Thanks,
	J

Ian Campbell (1):
  xen: pre-initialize legacy irqs early

Jeremy Fitzhardinge (8):
  xen/dom0: handle acpi lapic parsing in Xen dom0
  xen: hook io_apic read/write operations
  xen: create dummy ioapic mapping
  xen: implement pirq type event channels
  x86/io_apic: add get_nr_irqs_gsi()
  xen/apic: identity map gsi->irqs
  xen: direct irq registration to pirq event channels
  xen: bind pirq to vector and event channel

 arch/x86/include/asm/io_apic.h |    7 +
 arch/x86/include/asm/xen/pci.h |   13 ++
 arch/x86/kernel/acpi/boot.c    |   18 +++-
 arch/x86/kernel/io_apic.c      |   37 +++++-
 arch/x86/xen/Kconfig           |   11 ++
 arch/x86/xen/Makefile          |    4 +-
 arch/x86/xen/apic.c            |   57 +++++++++
 arch/x86/xen/enlighten.c       |    2 +
 arch/x86/xen/mmu.c             |   10 ++
 arch/x86/xen/pci.c             |   81 +++++++++++++
 arch/x86/xen/xen-ops.h         |    6 +
 drivers/xen/events.c           |  260 +++++++++++++++++++++++++++++++++++++++-
 include/xen/events.h           |   22 ++++
 13 files changed, 520 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/apic.c
 create mode 100644 arch/x86/xen/pci.c

>From 3c7db30686056c9b86cc61ef50dd5572de868512 Mon Sep 17 00:00:00 2001
Message-Id: <3c7db30686056c9b86cc61ef50dd5572de868512.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:47 -0800
Subject: [PATCH 1/9] xen/dom0: handle acpi lapic parsing in Xen dom0

When running in Xen dom0, we still want to parse the ACPI tables to
find out about local and IO apics, but we don't want to actually use
the lapics.

Put a couple of tests for Xen to prevent lapics from being mapped or
accessed.  This is very Xen-specific behaviour, so there didn't seem to
be any point in adding more indirection.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/acpi/boot.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 956c1de..32bacfe 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -42,6 +42,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/hypervisor.h>
+
 static int __initdata acpi_force = 0;
 u32 acpi_rsdt_forced;
 #ifdef	CONFIG_ACPI
@@ -219,6 +221,10 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
+	/* We don't want to register lapics when in Xen dom0 */
+	if (xen_initial_domain())
+		return;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
@@ -755,6 +761,10 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
 static void __init acpi_register_lapic_address(unsigned long address)
 {
+	/* Xen dom0 doesn't have usable lapics */
+	if (xen_initial_domain())
+		return;
+
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
-- 
1.6.0.6


>From 3e46dae897fd5620f50b4cca9272969f5546aa88 Mon Sep 17 00:00:00 2001
Message-Id: <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH 2/9] xen: hook io_apic read/write operations

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


>From 79724b71f4b8ef1fb65ea246dde2e3e1344b2a43 Mon Sep 17 00:00:00 2001
Message-Id: <79724b71f4b8ef1fb65ea246dde2e3e1344b2a43.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH 3/9] xen: create dummy ioapic mapping

We don't allow direct access to the IO apic, so make sure that any
request to map it just "maps" non-present pages.  We should see any
attempts at direct access explode nicely.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e678df8..094e6b8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1844,6 +1844,16 @@ static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 		pte = pfn_pte(phys, prot);
 		break;
 
+#ifdef CONFIG_X86_IO_APIC
+	case FIX_IO_APIC_BASE_0 ... FIX_IO_APIC_BASE_END:
+		/*
+		 * We just don't map the IO APIC - all access is via
+		 * hypercalls.  Keep the address in the pte for reference.
+		 */
+		pte = pfn_pte(phys, PAGE_NONE);
+		break;
+#endif
+
 	case FIX_PARAVIRT_BOOTMAP:
 		/* This is an MFN, but it isn't an IO mapping from the
 		   IO domain */
-- 
1.6.0.6


>From cbcff9ab54a2189156077c81c706fc30ba84344c Mon Sep 17 00:00:00 2001
Message-Id: <cbcff9ab54a2189156077c81c706fc30ba84344c.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH 4/9] xen: implement pirq type event channels

A privileged PV Xen domain can get direct access to hardware.  In
order for this to be useful, it must be able to get hardware
interrupts.

Being a PV Xen domain, all interrupts are delivered as event channels.
PIRQ event channels are bound to a pirq number and an interrupt
vector.  When a IO APIC raises a hardware interrupt on that vector, it
is delivered as an event channel, which we can deliver to the
appropriate device driver(s).

This patch simply implements the infrastructure for dealing with pirq
event channels.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |  245 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/xen/events.h |   14 +++
 2 files changed, 256 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index f46e880..81726e8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -16,7 +16,7 @@
  *    (typically dom0).
  * 2. VIRQs, typically used for timers.  These are per-cpu events.
  * 3. IPIs.
- * 4. Hardware interrupts. Not supported at present.
+ * 4. PIRQs - Hardware interrupts.
  *
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
@@ -40,6 +40,9 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
+/* Leave low irqs free for identity mapping */
+#define LEGACY_IRQS	16
+
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -83,10 +86,12 @@ struct irq_info
 		enum ipi_vector ipi;
 		struct {
 			unsigned short gsi;
-			unsigned short vector;
+			unsigned char vector;
+			unsigned char flags;
 		} pirq;
 	} u;
 };
+#define PIRQ_NEEDS_EOI	(1 << 0)
 
 static struct irq_info irq_info[NR_IRQS];
 
@@ -106,6 +111,7 @@ static inline unsigned long *cpu_evtchn_mask(int cpu)
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
 static struct irq_chip xen_dynamic_chip;
+static struct irq_chip xen_pirq_chip;
 
 /* Constructor for packed IRQ information. */
 static struct irq_info mk_unbound_info(void)
@@ -212,6 +218,15 @@ static unsigned int cpu_from_evtchn(unsigned int evtchn)
 	return ret;
 }
 
+static bool pirq_needs_eoi(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	return info->u.pirq.flags & PIRQ_NEEDS_EOI;
+}
+
 static inline unsigned long active_evtchns(unsigned int cpu,
 					   struct shared_info *sh,
 					   unsigned int idx)
@@ -328,7 +343,7 @@ static int find_unbound_irq(void)
 	int irq;
 	struct irq_desc *desc;
 
-	for (irq = 0; irq < nr_irqs; irq++)
+	for (irq = LEGACY_IRQS; irq < nr_irqs; irq++)
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
@@ -344,6 +359,210 @@ static int find_unbound_irq(void)
 	return irq;
 }
 
+static bool identity_mapped_irq(unsigned irq)
+{
+	/* only identity map legacy irqs */
+	return irq < LEGACY_IRQS;
+}
+
+static void pirq_unmask_notify(int irq)
+{
+	struct physdev_eoi eoi = { .irq = irq };
+
+	if (unlikely(pirq_needs_eoi(irq))) {
+		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
+		WARN_ON(rc);
+	}
+}
+
+static void pirq_query_unmask(int irq)
+{
+	struct physdev_irq_status_query irq_status;
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	irq_status.irq = irq;
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
+		irq_status.flags = 0;
+
+	info->u.pirq.flags &= ~PIRQ_NEEDS_EOI;
+	if (irq_status.flags & XENIRQSTAT_needs_eoi)
+		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
+}
+
+static bool probing_irq(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc && desc->action == NULL;
+}
+
+static unsigned int startup_pirq(unsigned int irq)
+{
+	struct evtchn_bind_pirq bind_pirq;
+	struct irq_info *info = info_for_irq(irq);
+	int evtchn = evtchn_from_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	if (VALID_EVTCHN(evtchn))
+		goto out;
+
+	bind_pirq.pirq = irq;
+	/* NB. We are happy to share unless we are probing. */
+	bind_pirq.flags = probing_irq(irq) ? 0 : BIND_PIRQ__WILL_SHARE;
+	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq) != 0) {
+		if (!probing_irq(irq))
+			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
+			       irq);
+		return 0;
+	}
+	evtchn = bind_pirq.port;
+
+	pirq_query_unmask(irq);
+
+	evtchn_to_irq[evtchn] = irq;
+	bind_evtchn_to_cpu(evtchn, 0);
+	info->evtchn = evtchn;
+
+ out:
+	unmask_evtchn(evtchn);
+	pirq_unmask_notify(irq);
+
+	return 0;
+}
+
+static void shutdown_pirq(unsigned int irq)
+{
+	struct evtchn_close close;
+	struct irq_info *info = info_for_irq(irq);
+	int evtchn = evtchn_from_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	if (!VALID_EVTCHN(evtchn))
+		return;
+
+	mask_evtchn(evtchn);
+
+	close.port = evtchn;
+	if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
+		BUG();
+
+	bind_evtchn_to_cpu(evtchn, 0);
+	evtchn_to_irq[evtchn] = -1;
+	info->evtchn = 0;
+}
+
+static void enable_pirq(unsigned int irq)
+{
+	startup_pirq(irq);
+}
+
+static void disable_pirq(unsigned int irq)
+{
+}
+
+static void ack_pirq(unsigned int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+
+	move_native_irq(irq);
+
+	if (VALID_EVTCHN(evtchn)) {
+		mask_evtchn(evtchn);
+		clear_evtchn(evtchn);
+	}
+}
+
+static void end_pirq(unsigned int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (WARN_ON(!desc))
+		return;
+
+	if ((desc->status & (IRQ_DISABLED|IRQ_PENDING)) ==
+	    (IRQ_DISABLED|IRQ_PENDING)) {
+		shutdown_pirq(irq);
+	} else if (VALID_EVTCHN(evtchn)) {
+		unmask_evtchn(evtchn);
+		pirq_unmask_notify(irq);
+	}
+}
+
+static int find_irq_by_gsi(unsigned gsi)
+{
+	int irq;
+
+	for(irq = 0; irq < NR_IRQS; irq++) {
+		struct irq_info *info = info_for_irq(irq);
+
+		if (info == NULL || info->type != IRQT_PIRQ)
+			continue;
+
+		if (gsi_from_irq(irq) == gsi)
+			return irq;
+	}
+
+	return -1;
+}
+
+/*
+ * Allocate a physical irq, along with a vector.  We don't assign an
+ * event channel until the irq actually started up.  Return an
+ * existing irq if we've already got one for the gsi.
+ */
+int xen_allocate_pirq(unsigned gsi)
+{
+	int irq;
+	struct physdev_irq irq_op;
+
+	spin_lock(&irq_mapping_update_lock);
+
+	irq = find_irq_by_gsi(gsi);
+	if (irq != -1) {
+		printk(KERN_INFO "xen_allocate_pirq: returning irq %d for gsi %u\n",
+		       irq, gsi);
+		goto out;	/* XXX need refcount? */
+	}
+
+	if (identity_mapped_irq(gsi)) {
+		irq = gsi;
+		dynamic_irq_init(irq);
+	} else
+		irq = find_unbound_irq();
+
+	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
+				      handle_level_irq, "pirq");
+
+	irq_op.irq = irq;
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
+		dynamic_irq_cleanup(irq);
+		irq = -ENOSPC;
+		goto out;
+	}
+
+	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+
+	return irq;
+}
+
+int xen_vector_from_irq(unsigned irq)
+{
+	return vector_from_irq(irq);
+}
+
+int xen_gsi_from_irq(unsigned irq)
+{
+	return gsi_from_irq(irq);
+}
+
 int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
@@ -916,6 +1135,26 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
+static struct irq_chip xen_pirq_chip __read_mostly = {
+	.name		= "xen-pirq",
+
+	.startup	= startup_pirq,
+	.shutdown	= shutdown_pirq,
+
+	.enable		= enable_pirq,
+	.unmask		= enable_pirq,
+
+	.disable	= disable_pirq,
+	.mask		= disable_pirq,
+
+	.ack		= ack_pirq,
+	.end		= end_pirq,
+
+	.set_affinity	= set_affinity_irq,
+
+	.retrigger	= retrigger_dynirq,
+};
+
 void __init xen_init_IRQ(void)
 {
 	int i;
diff --git a/include/xen/events.h b/include/xen/events.h
index 0397ba1..e5b541d 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -55,4 +55,18 @@ bool xen_test_irq_pending(int irq);
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq);
 
+/* Determine the IRQ which is bound to an event channel */
+unsigned irq_from_evtchn(unsigned int evtchn);
+
+/* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
+   GSIs are identity mapped; others are dynamically allocated as
+   usual. */
+int xen_allocate_pirq(unsigned gsi);
+
+/* Return vector allocated to pirq */
+int xen_vector_from_irq(unsigned pirq);
+
+/* Return gsi allocated to pirq */
+int xen_gsi_from_irq(unsigned pirq);
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.6.0.6


>From 5b0148b366eaa87072ab261f71c4c545be8e607f Mon Sep 17 00:00:00 2001
Message-Id: <5b0148b366eaa87072ab261f71c4c545be8e607f.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>
Date: Thu, 12 Feb 2009 17:22:49 -0800
Subject: [PATCH 5/9] x86/io_apic: add get_nr_irqs_gsi()

Add get_nr_irqs_gsi() to return nr_irqs_gsi.  Xen will use this to
determine how many irqs it needs to reserve for hardware irqs.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/io_apic.c      |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 20b543a..10a7a43 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -168,6 +168,7 @@ extern void reinit_intr_remapped_IO_APIC(int);
 #endif
 
 extern void probe_nr_irqs_gsi(void);
+extern int get_nr_irqs_gsi(void);
 
 extern int setup_ioapic_entry(int apic, int irq,
 			      struct IO_APIC_route_entry *entry,
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index de0368a..f66c093 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3865,6 +3865,11 @@ void __init probe_nr_irqs_gsi(void)
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
+int get_nr_irqs_gsi(void)
+{
+	return nr_irqs_gsi;
+}
+
 #ifdef CONFIG_SPARSE_IRQ
 int __init arch_probe_nr_irqs(void)
 {
-- 
1.6.0.6


>From 4e896f722e4175f96f3846896c3a7b627e634e7e Mon Sep 17 00:00:00 2001
Message-Id: <4e896f722e4175f96f3846896c3a7b627e634e7e.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@f9-builder.(none)>
Date: Thu, 12 Feb 2009 19:45:08 -0800
Subject: [PATCH 6/9] xen/apic: identity map gsi->irqs

Reserve the lower irq range for use for hardware interrupts so we
can identity-map them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 81726e8..3477998 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -31,6 +31,7 @@
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/io_apic.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -40,9 +41,6 @@
 #include <xen/interface/xen.h>
 #include <xen/interface/event_channel.h>
 
-/* Leave low irqs free for identity mapping */
-#define LEGACY_IRQS	16
-
 /*
  * This lock protects updates to the following mapping and reference-count
  * arrays. The lock does not need to be acquired to read the mapping tables.
@@ -338,12 +336,24 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static int get_nr_hw_irqs(void)
+{
+	int ret = 1;
+
+#ifdef CONFIG_X86_IO_APIC
+	ret = get_nr_irqs_gsi();
+#endif
+
+	return ret;
+}
+
 static int find_unbound_irq(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	int start = get_nr_hw_irqs();
 
-	for (irq = LEGACY_IRQS; irq < nr_irqs; irq++)
+	for (irq = start; irq < nr_irqs; irq++)
 		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
@@ -361,8 +371,8 @@ static int find_unbound_irq(void)
 
 static bool identity_mapped_irq(unsigned irq)
 {
-	/* only identity map legacy irqs */
-	return irq < LEGACY_IRQS;
+	/* identity map all the hardware irqs */
+	return irq < get_nr_hw_irqs();
 }
 
 static void pirq_unmask_notify(int irq)
@@ -531,6 +541,7 @@ int xen_allocate_pirq(unsigned gsi)
 
 	if (identity_mapped_irq(gsi)) {
 		irq = gsi;
+		irq_to_desc_alloc_cpu(irq, 0);
 		dynamic_irq_init(irq);
 	} else
 		irq = find_unbound_irq();
-- 
1.6.0.6


>From 0e852da646969a2296f66cbc485f278fe1fa9929 Mon Sep 17 00:00:00 2001
Message-Id: <0e852da646969a2296f66cbc485f278fe1fa9929.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH 7/9] xen: direct irq registration to pirq event channels

This patch puts the hooks into place so that when the interrupt
subsystem registers an irq, it gets routed via Xen (if we're running
under Xen).

The first step is to get a gsi for a particular device+pin.  We use
the normal acpi interrupt routing to do the mapping.

We reserve enough irq space to fit the hardware interrupt sources in,
so we can allocate the irq == gsi, as we do in the native case;
software events will get allocated irqs above that.

Having allocated an irq, we ask Xen to allocate a vector, and then
bind that pirq/vector to an event channel.  When the hardware raises
an interrupt on a vector, Xen signals us on the corresponding event
channel, which gets routed to the irq and delivered to the appropriate
device driver.

This patch does everything except set up the IO APIC pin routing to
the vector.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/pci.h |   13 +++++++++++
 arch/x86/kernel/acpi/boot.c    |    8 ++++++-
 arch/x86/xen/Kconfig           |   11 +++++++++
 arch/x86/xen/Makefile          |    1 +
 arch/x86/xen/pci.c             |   47 ++++++++++++++++++++++++++++++++++++++++
 drivers/xen/events.c           |    6 ++++-
 include/xen/events.h           |    8 ++++++
 7 files changed, 92 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/xen/pci.c

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
new file mode 100644
index 0000000..0563fc6
--- /dev/null
+++ b/arch/x86/include/asm/xen/pci.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_X86_XEN_PCI_H
+#define _ASM_X86_XEN_PCI_H
+
+#ifdef CONFIG_XEN_DOM0_PCI
+int xen_register_gsi(u32 gsi, int triggering, int polarity);
+#else
+static inline int xen_register_gsi(u32 gsi, int triggering, int polarity)
+{
+	return -1;
+}
+#endif
+
+#endif	/* _ASM_X86_XEN_PCI_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 32bacfe..89afbbe 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -42,6 +42,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/pci.h>
+
 #include <asm/xen/hypervisor.h>
 
 static int __initdata acpi_force = 0;
@@ -483,9 +485,13 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
  */
 int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 {
-	unsigned int irq;
+	int irq;
 	unsigned int plat_gsi = gsi;
 
+	irq = xen_register_gsi(gsi, triggering, polarity);
+	if (irq >= 0)
+		return irq;
+
 #ifdef CONFIG_PCI
 	/*
 	 * Make sure all (legacy) PCI IRQs are set as level-triggered.
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 87b9ab1..ee429df 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -36,3 +36,14 @@ config XEN_DEBUG_FS
 	help
 	  Enable statistics output and various tuning options in debugfs.
 	  Enabling this option may incur a significant performance overhead.
+
+config XEN_PCI_PASSTHROUGH
+       bool #"Enable support for Xen PCI passthrough devices"
+       depends on XEN && PCI
+       help
+         Enable support for passing PCI devices through to
+	 unprivileged domains. (COMPLETELY UNTESTED)
+
+config XEN_DOM0_PCI
+       def_bool y
+       depends on XEN_DOM0 && PCI
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 853d05e..a5fb286 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -12,3 +12,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 obj-$(CONFIG_XEN_DOM0)		+= apic.o
+obj-$(CONFIG_XEN_DOM0_PCI)	+= pci.o
\ No newline at end of file
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
new file mode 100644
index 0000000..f450007
--- /dev/null
+++ b/arch/x86/xen/pci.c
@@ -0,0 +1,47 @@
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/pci.h>
+
+#include <asm/pci_x86.h>
+
+#include <asm/xen/hypervisor.h>
+
+#include <xen/interface/xen.h>
+#include <xen/events.h>
+
+#include "xen-ops.h"
+
+int xen_register_gsi(u32 gsi, int triggering, int polarity)
+{
+	int irq;
+
+	if (!xen_domain())
+		return -1;
+
+	printk(KERN_DEBUG "xen: registering gsi %u triggering %d polarity %d\n",
+	       gsi, triggering, polarity);
+
+	irq = xen_allocate_pirq(gsi);
+
+	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
+
+	return irq;
+}
+
+void __init xen_setup_pirqs(void)
+{
+#ifdef CONFIG_ACPI
+	int irq;
+
+	/*
+	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
+	 */
+	irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
+
+	printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
+	       irq, acpi_gbl_FADT.sci_interrupt);
+
+	/* Blerk. */
+	acpi_gbl_FADT.sci_interrupt = irq;
+#endif
+}
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 3477998..3cf0a1b 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -413,6 +413,7 @@ static unsigned int startup_pirq(unsigned int irq)
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
 	int evtchn = evtchn_from_irq(irq);
+	int rc;
 
 	BUG_ON(info->type != IRQT_PIRQ);
 
@@ -422,7 +423,8 @@ static unsigned int startup_pirq(unsigned int irq)
 	bind_pirq.pirq = irq;
 	/* NB. We are happy to share unless we are probing. */
 	bind_pirq.flags = probing_irq(irq) ? 0 : BIND_PIRQ__WILL_SHARE;
-	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq) != 0) {
+	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
+	if (rc != 0) {
 		if (!probing_irq(irq))
 			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
 			       irq);
@@ -1181,4 +1183,6 @@ void __init xen_init_IRQ(void)
 		mask_evtchn(i);
 
 	irq_ctx_init(smp_processor_id());
+
+	xen_setup_pirqs();
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index e5b541d..6fe4863 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -69,4 +69,12 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+#ifdef CONFIG_XEN_DOM0_PCI
+void xen_setup_pirqs(void);
+#else
+static inline void xen_setup_pirqs(void)
+{
+}
+#endif
+
 #endif	/* _XEN_EVENTS_H */
-- 
1.6.0.6


>From 69aeef6bc01fbe1fdc6ebd41910e6dc8767b103c Mon Sep 17 00:00:00 2001
Message-Id: <69aeef6bc01fbe1fdc6ebd41910e6dc8767b103c.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH 8/9] xen: bind pirq to vector and event channel

Having converting a dev+pin to a gsi, and that gsi to an irq, and
allocated a vector for the irq, we must program the IO APIC to deliver
an interrupt on a pin to the vector, so Xen can deliver it as an event
channel.

Given the pirq, we can get the gsi and vector.  We map the gsi to a
specific IO APIC's pin, and set the routing entry.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c |    4 ++--
 arch/x86/xen/pci.c  |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 17736a0..e9d9ea7 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -4,6 +4,7 @@
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
+#include <asm/hw_irq.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -13,8 +14,7 @@
 
 void __init xen_io_apic_init(void)
 {
-	printk("xen apic init\n");
-	dump_stack();
+	enable_IO_APIC();
 }
 
 unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index f450007..61f070c 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -2,6 +2,8 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 
+#include <asm/mpspec.h>
+#include <asm/io_apic.h>
 #include <asm/pci_x86.h>
 
 #include <asm/xen/hypervisor.h>
@@ -11,6 +13,31 @@
 
 #include "xen-ops.h"
 
+static void xen_set_io_apic_routing(int irq, int trigger, int polarity)
+{
+	int ioapic, ioapic_pin;
+	int vector, gsi;
+	struct IO_APIC_route_entry entry;
+
+	gsi = xen_gsi_from_irq(irq);
+	vector = xen_vector_from_irq(irq);
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic == -1) {
+		printk(KERN_WARNING "xen_set_ioapic_routing: irq %d gsi %d ioapic %d\n",
+			irq, gsi, ioapic);
+		return;
+	}
+
+	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
+
+	printk(KERN_INFO "xen_set_ioapic_routing: irq %d gsi %d vector %d ioapic %d pin %d triggering %d polarity %d\n",
+		irq, gsi, vector, ioapic, ioapic_pin, trigger, polarity);
+
+	setup_ioapic_entry(ioapic, -1, &entry, ~0, trigger, polarity, vector);
+	ioapic_write_entry(ioapic, ioapic_pin, entry);
+}
+
 int xen_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int irq;
@@ -25,6 +52,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 	printk(KERN_DEBUG "xen: --> irq=%d\n", irq);
 
+	if (irq > 0)
+		xen_set_io_apic_routing(irq, triggering, polarity);
+
 	return irq;
 }
 
-- 
1.6.0.6


>From 32e538eef4fe7581644814b3c96d6726456a5daa Mon Sep 17 00:00:00 2001
Message-Id: <32e538eef4fe7581644814b3c96d6726456a5daa.1234573319.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573319.git.jeremy.fitzhardinge@citrix.com>
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH 9/9] xen: pre-initialize legacy irqs early

Various legacy devices, such as IDE, assume their legacy interrupts are
already initialized and are immediately usable.  Pre-initialize all the
legacy interrupts.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 61f070c..d661c74 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -60,9 +60,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 void __init xen_setup_pirqs(void)
 {
-#ifdef CONFIG_ACPI
 	int irq;
 
+#ifdef CONFIG_ACPI
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
@@ -74,4 +74,8 @@ void __init xen_setup_pirqs(void)
 	/* Blerk. */
 	acpi_gbl_FADT.sci_interrupt = irq;
 #endif
+
+	/* Pre-allocate legacy irqs */
+	for (irq=0; irq < NR_IRQS_LEGACY; irq++)
+		xen_allocate_pirq(irq);
 }
-- 
1.6.0.6

