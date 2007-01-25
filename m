Return-Path: <linux-kernel-owner+w=401wt.eu-S1030478AbXAYRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030478AbXAYRhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030477AbXAYRhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:37:31 -0500
Received: from alpha2.look.ca ([207.136.100.2]:50214 "EHLO jandor.look.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030478AbXAYRh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:37:29 -0500
X-Greylist: delayed 1847 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 12:37:29 EST
Date: Thu, 25 Jan 2007 12:06:50 -0500
To: linux-kernel@vger.kernel.org
Cc: Pekka Paalanen <pq@iki.fi>
Message-ID: <20070125170650.GA15290@infidigm.net>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: Jeff Muizelaar <jeff@infidigm.net>
X-SA-Exim-Mail-From: jeff@infidigm.net
Subject: kmmio/mmio-trace problems
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Version: 3.1 (built Tue Feb 24 05:09:27 GMT 2004)
X-SA-Exim-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have built a tool with the goal of logging mmio writes and reads by
device drivers. I am sure anyone who has reverse engineered device
drivers can immediately see the use of such a tool. In particular I have
been trying to help with the nouveau project. The code for the tool is
based on the work Intel did quite some time ago for device driver fault
injection which some of you may remember (It was presented at OLS in
2003).

The basic mechanism involves using page faults to capture all of the
accesses to an ioremapped area. It works by clearing the _PAGE_PRESENT
bit on all of the pages in the mapping. On an access to the area, the
faulting instruction is decoded. The _PAGE_PRESENT flag is set and the
single stepping is turned on in eflags. In the debugging handler the
_PAGE_PRESET flag is recleared and written or read values are logged.

The implementation seems to mostly work, however, there are some large
stability problems. Occasionally, it seems that the processor is not
convinced that page is actually present and will continue to fault on
the same instruction.

Basically, I have a situation where if the following code is executed in
the page fault handler I get a recursive fault. i.e *(int *)addr page
faults.

if (page_present(addr)) {
	flush_tlb_all();
	int read_val = *(int *)addr;
	printk("read: %x\n", read_val);
	explosion;
}

static inline unsigned long page_present(unsigned long address)
{
        pgd_t *pgd = pgd_offset_k(address);
        pud_t *pud = pud_offset(pgd, address);
        pmd_t *pmd = pmd_offset(pud, address);
        if (pmd_large(*pmd)) {
                printk("4MB pages are not currently supported: %lx\n", address);
                BUG();
        }
        return pte_val(*pte_offset_kernel(pmd, address)) & _PAGE_PRESENT;
}

I have no idea why this would happen. Can anyone think of any reason it
would?

Note: the addresses that cause the problem are not anything special.
e.g. base+0x600140 (they don't span page boundaries)

The code for the intercepting calls to ioremap and setting up the
trace region (mmio-trace) is at:
git://people.freedesktop.org/~jrmuizel/mmio-trace
http://gitweb.freedesktop.org/?p=users/jrmuizel/mmio-trace.git;a=summary
There is also more information about mmio-trace at
http://nouveau.freedesktop.org/wiki/MmioTrace

There are a whole set of logs from the debugging sessions available at
https://no.spoon.fi/~pq/home_nv28/ in the mmio directories. The most
recent and probably the more interesting logs are in the mmio17
directory.

Although, the problem was found using the binary drivers. I can
reproduce the problem with a simple driver that maps the io memory on an
nvidia card and then pokes it.
http://infidigm.net/~jeff/nv-test-0.5.tar.bz2

I've included the relevant code here. It is pretty straight forward.

static void poke(void *base)
{
	int new;
	printk("doing a poke()\n");
	new = *(int *)(base + 0x101000);
	printk("read %x from 0x101000\n", new);
	*(int *)(base + 0x600140) = 0;
	printk("wrote 0 to 0x600140\n");
}

static int __devinit nv_test_init_one(struct pci_dev *pdev,
					const struct pci_device_id *ent)
{
	int err;
	void *base;

	err = pci_enable_device(pdev);
	if (err) {
		printk(KERN_ERR "%s cannot enable PCI device\n",
				pci_name(pdev));
		goto err_out;
	}

	err = pci_request_regions(pdev, "nv-test");
	if (err) {
		printk(KERN_ERR "%s cannot obtain PCI resources\n",
				pci_name(pdev));
		goto err_out_disable_pdev;
	}

	pci_set_master(pdev);

	base = ioremap_nocache(pci_resource_start(pdev, 0), 0x1000000);

	poke(base);

	pci_set_drvdata(pdev, base);
err_out_disable_pdev:
	pci_disable_device(pdev);
	pci_set_drvdata(pdev, NULL);
err_out:
	return err;
}


Finally, here is the kmmio patch against a git kernel from about 2 weeks
ago. A debugging version of the patch that the above case is from is
also available at:
http://infidigm.net/~jeff/kmmio-super-debug.patch

diff --git a/arch/i386/Kconfig.debug b/arch/i386/Kconfig.debug
index f68cc6f..64372f3 100644
--- a/arch/i386/Kconfig.debug
+++ b/arch/i386/Kconfig.debug
@@ -26,6 +26,15 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
+config KMMIO
+	bool "KMMIO (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	depends on KPROBES 
+	help
+	  KMMIO is a Kprobes add-ons for placing a probe on MMIO access, using
+	  register_kmmio(), and providing a callback function. This is useful
+	  for monitoring driver access specific MMIO address.
+
 config DEBUG_STACK_USAGE
 	bool "Stack utilization instrumentation"
 	depends on DEBUG_KERNEL
diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 1e8988e..2b5fec2 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
+obj-$(CONFIG_KMMIO)		+= kmmio.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-y				+= sysenter.o vsyscall.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
diff --git a/arch/i386/kernel/kmmio.c b/arch/i386/kernel/kmmio.c
new file mode 100644
index 0000000..4f32bbf
--- /dev/null
+++ b/arch/i386/kernel/kmmio.c
@@ -0,0 +1,162 @@
+/* 
+ * KMMIO
+ * Benfit many code from kprobes
+ * (C) 2002 Louis Zhuang <louis.zhuang@intel.com>.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+
+#include <linux/kmmio.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <asm/io.h>
+#include <asm/highmem.h>
+
+static int cpu=-1;
+static struct kmmio_fault_page *cur_page = NULL;
+static struct kmmio_probe *cur_probe = NULL;
+static unsigned long kmmio_saved_eflags;
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate 
+ * and they remain disabled thorough out this function.
+ */
+int kmmio_handler(struct pt_regs *regs, unsigned long addr)
+{
+	/* We're in an interrupt, but this is clear and BUG()-safe. */
+	preempt_disable();
+
+	lock_kmmio();
+
+	cur_page = get_kmmio_fault_page(addr);
+	if (!cur_page) {
+		/* this page fault is not caused by kmmio */
+		/* XXX some pending fault on other cpu may cause problem! */ 
+		unlock_kmmio();
+		goto no_kmmio;
+	}
+	cpu = smp_processor_id();
+	
+	cur_probe = get_kmmio_probe(addr); 
+	kmmio_saved_eflags = (regs->eflags & (TF_MASK|IF_MASK));
+	
+	if (cur_probe && cur_probe->pre_handler) {
+		cur_probe->pre_handler(cur_probe, regs, addr);
+	}
+	
+	regs->eflags |= TF_MASK;
+	regs->eflags &= ~IF_MASK;
+
+	/* We hold lock, now we set present bit in PTE and single step. */
+	disarm_kmmio_fault_page(cur_page->page);
+	
+
+	return 1;
+
+no_kmmio:
+	preempt_enable_no_resched();
+	return 0;
+}
+
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate 
+ * and they remain disabled thorough out this function.  
+ * And we hold kmmio lock.
+ */
+int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
+{
+	if (!is_kmmio_active())
+		return 0;
+	if (smp_processor_id() != cpu)
+		return 0;
+
+	if (cur_probe && cur_probe->post_handler) {
+		cur_probe->post_handler(cur_probe, condition, regs);
+	}
+
+	arm_kmmio_fault_page(cur_page->page);
+	__flush_tlb_one(cur_page->page);
+	
+	regs->eflags &= ~TF_MASK;
+	regs->eflags |= kmmio_saved_eflags;
+
+	cpu = -1;
+	
+	unlock_kmmio();
+	preempt_enable_no_resched();
+	
+        /*
+	 * if somebody else is singlestepping across a probe point, eflags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (regs->eflags & TF_MASK)
+		return 0;
+
+	return 1;
+}
+
+static inline pte_t *get_pte(unsigned long address) 
+{
+        pgd_t *pgd = pgd_offset_k(address);
+	pud_t *pud = pud_offset(pgd, address);
+	pmd_t *pmd = pmd_offset(pud, address);
+	if (pmd_large(*pmd)) {
+		printk("4MB pages are not currently supported: %lx\n", address);
+		BUG();
+		return (pte_t *)pmd;
+	}
+	return pte_offset_kernel(pmd, address);
+};
+
+/**
+ * Set/Clear pte bits
+ */
+static inline void clr_pte_bits(unsigned long addr, 
+				unsigned long bitmask) 
+{
+	pte_t *pte;
+	pte = get_pte(addr);
+	set_pte( pte, __pte( pte_val(*pte) & ~bitmask) );	
+};
+
+static inline void set_pte_bits(unsigned long addr, 
+				unsigned long bitmask) 
+{
+	pte_t *pte;
+	pte = get_pte(addr);
+	set_pte( pte, __pte( pte_val(*pte) | bitmask) );	
+};	
+
+void arm_kmmio_fault_page(kmmio_addr_t page)
+{	
+	page &= PAGE_MASK;
+	clr_pte_bits(page, _PAGE_PRESENT);
+}
+
+void disarm_kmmio_fault_page(kmmio_addr_t page)
+{
+	page &= PAGE_MASK;
+	set_pte_bits(page, _PAGE_PRESENT);
+}
+
+/* the function is only used to make virt map to bus */
+void *kmmio_invert_map(void *virt_addr, unsigned long bus_addr)
+{
+	int offset;
+	pte_t *pte;
+
+	if((unsigned long)virt_addr & ~PAGE_MASK)
+		BUG();
+	
+	offset = bus_addr & ~PAGE_MASK;
+	bus_addr &= PAGE_MASK;
+	pte = get_pte((unsigned long)virt_addr);
+	
+	set_pte( pte, __pte( (pte_val(*pte) & ~PAGE_MASK) | bus_addr) );
+	return virt_addr+offset;								
+}
+
+EXPORT_SYMBOL_GPL(kmmio_invert_map);
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 0efad8a..81a506a 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -27,6 +27,7 @@
 #include <linux/utsname.h>
 #include <linux/kprobes.h>
 #include <linux/kexec.h>
+#include <linux/kmmio.h>
 #include <linux/unwind.h>
 #include <linux/uaccess.h>
 #include <linux/nmi.h>
@@ -808,9 +809,13 @@ fastcall void __kprobes do_debug(struct pt_regs * regs, long error_code)
 
 	get_debugreg(condition, 6);
 
+	if (post_kmmio_handler(condition, regs))
+		return;
+
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
 					SIGTRAP) == NOTIFY_STOP)
 		return;
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	if (regs->eflags & X86_EFLAGS_IF)
 		local_irq_enable();
diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index aaaa4d2..cbc706b 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -22,6 +22,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/kprobes.h>
+#include <linux/kmmio.h>
 #include <linux/uaccess.h>
 
 #include <asm/system.h>
@@ -333,6 +334,9 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	/* get the address */
         address = read_cr2();
 
+	if (is_kmmio_active() && kmmio_handler(regs, address))
+		return;
+	
 	tsk = current;
 
 	si_code = SEGV_MAPERR;
diff --git a/include/asm-i386/kmmio.h b/include/asm-i386/kmmio.h
new file mode 100644
index 0000000..6f8f034
--- /dev/null
+++ b/include/asm-i386/kmmio.h
@@ -0,0 +1,33 @@
+/*
+ * Benfit many code from kprobes
+ * (C) 2002 Louis Zhuang <louis.zhuang@intel.com>.
+ */
+
+#ifndef _ASM_KMMIO_H
+#define _ASM_KMMIO_H
+#include <linux/types.h>
+#include <linux/ptrace.h>
+
+struct pt_regs;
+
+typedef unsigned long kmmio_addr_t;
+
+#ifdef CONFIG_KMMIO
+extern void arm_kmmio_fault_page(kmmio_addr_t page);
+extern void disarm_kmmio_fault_page(kmmio_addr_t page);
+extern int post_kmmio_handler(unsigned long condition, 
+			      struct pt_regs *regs);
+extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
+extern void *kmmio_invert_map(void *virt_addr, unsigned long bus_addr);
+#else /* !CONFIG_KMMIO */
+static inline int post_kmmio_handler(unsigned long condition, 
+				     struct pt_regs *regs) 
+{ 
+	return 0; 
+}
+static inline int kmmio_handler(struct pt_regs *regs, unsigned long addr) 
+{ 
+	return 0; 
+}
+#endif
+#endif /* _ASM_KMMIO_H */
diff --git a/include/linux/kmmio.h b/include/linux/kmmio.h
new file mode 100644
index 0000000..be81a7e
--- /dev/null
+++ b/include/linux/kmmio.h
@@ -0,0 +1,69 @@
+#ifndef _LINUX_KMMIO_H
+#define _LINUX_KMMIO_H
+#include <linux/list.h>
+#include <linux/notifier.h>
+#include <linux/smp.h>
+#include <asm/kmmio.h>
+
+struct kmmio_probe;
+struct kmmio_fault_page;
+struct pt_regs;
+
+typedef void (*kmmio_pre_handler_t)(struct kmmio_probe *, 
+				    struct pt_regs *, 
+				    unsigned long addr);
+typedef void (*kmmio_post_handler_t)(struct kmmio_probe *, 
+				     unsigned long condition, 
+				     struct pt_regs *);
+struct kmmio_probe {
+	struct list_head list;
+
+	/* start location of the probe point */
+	kmmio_addr_t addr;
+
+	/* length of the probe region */
+	unsigned long len;
+
+	 /* Called before addr is executed. */
+	kmmio_pre_handler_t pre_handler;
+
+	/* Called after addr is executed, unless... */
+	kmmio_post_handler_t post_handler;
+};
+
+struct kmmio_fault_page {
+	struct list_head list;
+
+	/* location of the fault page */
+	kmmio_addr_t page;
+
+	int count;
+};
+
+#ifdef CONFIG_KMMIO
+/* Locks kmmio: irq must be disabled */
+void lock_kmmio(void);
+void unlock_kmmio(void);
+
+/* kmmio is active by some kmmio_probes? */
+static inline int is_kmmio_active(void)
+{
+	extern unsigned int kmmio_count;
+	return kmmio_count;
+}
+
+/* Get the kmmio at this addr (if any).  Must have called lock_kmmio */
+struct kmmio_probe *get_kmmio_probe(kmmio_addr_t addr);
+struct kmmio_fault_page *get_kmmio_fault_page(kmmio_addr_t page);
+int add_kmmio_fault_page(kmmio_addr_t page);
+void release_kmmio_fault_page(kmmio_addr_t page);
+
+int register_kmmio_probe(struct kmmio_probe *p);
+void unregister_kmmio_probe(struct kmmio_probe *p);
+#else
+static inline int is_kmmio_active(void) 
+{ 
+	return 0; 
+}
+#endif
+#endif /* _LINUX_KMMIO_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 14f4d45..ab7d291 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_KMMIO) += kmmio.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
diff --git a/kernel/kmmio.c b/kernel/kmmio.c
new file mode 100644
index 0000000..4a66d5d
--- /dev/null
+++ b/kernel/kmmio.c
@@ -0,0 +1,157 @@
+/* Support for MMIO probes.
+ * Benfit many code from kprobes
+ * (C) 2002 Louis Zhuang <louis.zhuang@intel.com>.
+*/
+
+#include <linux/kmmio.h>
+#include <linux/spinlock.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/cacheflush.h>
+#include <asm/errno.h>
+#include <asm/highmem.h>
+
+#define KMMIO_HASH_BITS 6
+#define KMMIO_TABLE_SIZE (1 << KMMIO_HASH_BITS)
+
+static LIST_HEAD(kmmio_probes);
+
+#define KMMIO_PAGE_HASH_BITS 4
+#define KMMIO_PAGE_TABLE_SIZE (1 << KMMIO_PAGE_HASH_BITS)
+static struct list_head kmmio_page_table[KMMIO_PAGE_TABLE_SIZE];
+
+unsigned int kmmio_count = 0;
+static spinlock_t kmmio_lock = SPIN_LOCK_UNLOCKED;
+
+/* Locks kmmio: irqs must be disabled */
+void lock_kmmio(void)
+{
+	spin_lock(&kmmio_lock);
+}
+
+void unlock_kmmio(void)
+{
+	spin_unlock(&kmmio_lock);
+}
+
+/* You have to be holding the kmmio_lock */
+/* this is basically a dynamic stabbing problem:
+ * Could use the existing prio tree code or
+ * Possible better implementations:
+ *	The Interval Skip List: A Data Structure for Finding All Intervals That Overlap a Point (might be simple)
+ *	Space Efficient Dynamic Stabbing with Fast Queries - Mikkel Thorup */
+struct kmmio_probe *get_kmmio_probe(unsigned long addr)
+{
+	struct kmmio_probe *p;
+	list_for_each_entry(p, &kmmio_probes, list) {
+		if (addr >= p->addr && addr <= (p->addr + p->len))
+			return p;
+	}
+	return NULL;
+}
+
+int register_kmmio_probe(struct kmmio_probe *p)
+{
+	int ret = 0;
+	unsigned int size = 0;
+	
+	spin_lock_irq(&kmmio_lock);
+	kmmio_count++;
+	if (get_kmmio_probe(p->addr)) {
+		ret = -EEXIST;
+		goto out;
+	}
+	list_add(&p->list, &kmmio_probes);
+	while (size < p->len) {
+		printk("adding fault page\n");
+		if (add_kmmio_fault_page(p->addr + size)) {
+			printk(KERN_ERR "Unable to set page fault\n");
+		}
+		size += PAGE_SIZE;
+	}
+
+out:
+	spin_unlock_irq(&kmmio_lock);
+	flush_tlb_all();
+	return ret;
+}
+
+void unregister_kmmio_probe(struct kmmio_probe *p)
+{
+	unsigned int size = 0;
+	spin_lock_irq(&kmmio_lock);
+	while (size < p->len) {
+		release_kmmio_fault_page(p->addr + size);
+		size += PAGE_SIZE;
+	}
+	list_del(&p->list);
+	kmmio_count--;
+	spin_unlock_irq(&kmmio_lock);
+}
+
+struct kmmio_fault_page *get_kmmio_fault_page(kmmio_addr_t page)
+{
+	struct list_head *head, *tmp;
+
+	page &= PAGE_MASK;
+	head = &kmmio_page_table[hash_long(page, KMMIO_PAGE_HASH_BITS)];
+	list_for_each(tmp, head) {
+		struct kmmio_fault_page *p 
+			= list_entry(tmp, struct kmmio_fault_page, list);
+		if (p->page == page)
+			return p;
+	}
+	return NULL;
+}
+
+int add_kmmio_fault_page(kmmio_addr_t page)
+{
+	struct kmmio_fault_page *f;
+	
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (f) {
+		f->count++;
+		return 0;
+	}
+	f = (struct kmmio_fault_page *)kmalloc(sizeof(*f), GFP_ATOMIC);
+	if (!f) return -1;
+	f->count = 1;
+	f->page = page;
+	list_add(&f->list, 
+		 &kmmio_page_table[hash_long(f->page, KMMIO_PAGE_HASH_BITS)]);
+
+	arm_kmmio_fault_page(f->page);
+	return 0;
+}
+
+void release_kmmio_fault_page(kmmio_addr_t page)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (!f)	return;
+	f->count--;
+	if(!f->count) {
+		disarm_kmmio_fault_page(f->page);
+		list_del(&f->list);
+	}
+}
+
+static int __init init_kmmio(void)
+{
+	int i;
+
+	/* FIXME allocate the probe table, currently defined statically */
+	/* initialize all list heads */
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++) 
+		INIT_LIST_HEAD(&kmmio_page_table[i]);
+	return 0;
+}
+__initcall(init_kmmio);
+
+EXPORT_SYMBOL_GPL(register_kmmio_probe);
+EXPORT_SYMBOL_GPL(unregister_kmmio_probe);
