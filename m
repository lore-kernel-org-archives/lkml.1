Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbZD3VGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbZD3VGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZD3VF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:05:59 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36538 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbZD3VF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:05:58 -0400
Message-Id: <1241125556.12894.1313160577@webmail.messagingengine.com>
X-Sasl-Enc: S4nYU2SVqPfQb6K/lo0QsMvv9tv/ITcqh8Z3dTD2dWC6 1241125556
From: "Jack Stone" <jwjstone@fastmail.fm>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: [RFC] Regression testing framework for the kernel
Date: Thu, 30 Apr 2009 23:05:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I would like to suggest a new framework to test the kernel. This
framework would have the following goals:
    * Only runs at build time and has no effect on running kernel
    * Does not need the kernel to be booted
    * Allows the testing of any unit of code from one function to the
    full kernel
    * Requires minimal changes to the core source code
    * Allows kernel functions to be replaced with a test function to
    check the kernel's behavior

The best way of acheiving this that I have thought of it to compile the
kernel source in question and
to link it with special framework files. These files would serve two
purposes: to provide the main function
of the program and to provide the missing symbols for the kernel code.
This would allow the replacement of
certain functions in the code. For example replacing the spin_lock and
spin_unlock functions would allow the
locking behavior to be checked.

Advantages:
    * Allows the kernel to be tested without having the required
    hardware
    * As the testing is run in userland the environment can be very
    tightly controlled and this can be used to
         help find timing races and verify patches to fix them

Disadvantages:
    * Extra (potentially complex) code to maintain
    * Probably others that I haven't thought of

Usage examples:
    * Test the behavior of a device driver
         As various kernel functions can be overridden a test case could
         be written to simulate a given device and
         check that there are no regressions in the driver
    * Check locking behavior
         The lock functions can be overridden to check that no deadlocks
         can occur (ala Lockdep). The advantage over
         run time variants like lockdep is that the environment can be
         controlled and so a test case could be written
         to provoke a timing race and ensure that the kernel handles it
         correctly.
    * Regression testing
         Any time a regression is found and fixed in the kernel a test
         case could be written to check that the
         regression does not reoccur later on.

Attached is a proof of concept implementation. As you can see the code
is awful and not at all polished but hopefully you
can look past that. I wanted to submit this here to see what opinion was
before I spent too much time perfecting the method.
This patch is only meant to demonstrate one possible way of achieving
what I think would be useful. However, I think that this
implementation is not brilliant so I'm very open to alternatives.

I don't think that the above text describes what I mean very clearly but
I equally think that I won't get it any better. Feel
free to ask questions about what I mean.

Thank you for staying with me for all that,

Jack

--

Proof of concept implementation of regression testing framework

This patch attempts to demonstrate what a regression testing framework
might
look like. This test allows a slub kmalloc to be run in userspace.
Currently
the allocation fails as all the functions external to slub.c are
placeholders
but it shows what can be achieved.

The file test/common/common.c contains the definitions of the functions
that
slub.c calls into. The intention is that this file or directory of files
can
be common to all tests with each test case defining
REG_TEST_OVERRIDE_FOO as
it needs. This should reduce the leg work of writing test cases as a
large
library of replacements can be built up.

As can be seen in the patch, I had to make one change to the core kernel
source.
This was because the functions in question cannot be run in userspace
and they
are defined in a header included by slub.c. This is one of the problems
with this
approach to achieving the goals of the framework.

The main problem with this implementation is the maintenance effort
required to
keep the test cases running. If a .c file uses a new function or global
variable
external to that .c file then a new replacement needs to be defined in
test/common. Alternativly, the kernel file that that external function
or global
variable is defined in needs to be compiled into that test case. Either
way
this adds one more piece of code that needs to be kept in sync.

To test this patch. Apply it to Linus' tree and cd into the test
directory.
In there the file build.sh needs to be run. This compiles the kernel
code
into a exec called test. This exec simply runs kmalloc and prints out
the pointer
it gets back. This test case is designed to show how the kernel code can
be run
up.

This code is currently dependent on a valid .config and autoconf.h. This
is not
practical for a long term test set as different .configs give different
behavior.
The solution to this is for each test case to define the CONFIG_* it
needs to
get the behavior it is expecting. This again may add to maintenance
effort.

NOTE: This code needs a valid .config in the root of the tree and
autoconf.h to
be uptodate. This can be achieved by building the .config, ie make all.

NOTE 2: The .config must be for a UP x86 because of the replacement
functions
defined in common.c

---
 arch/x86/include/asm/irqflags.h |    4 +
 test/build.sh                   |    3 +
 test/common/common.c            |  358
 +++++++++++++++++++++++++++++++++++++++
 test/mm/slub/test.c             |   12 ++
 4 files changed, 377 insertions(+), 0 deletions(-)
 create mode 100755 test/build.sh
 create mode 100644 test/common/common.c
 create mode 100644 test/mm/slub/test.c

diff --git a/arch/x86/include/asm/irqflags.h
b/arch/x86/include/asm/irqflags.h
index 2bdab21..0c455e7 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -31,12 +31,16 @@ static inline void native_restore_fl(unsigned long
flags)

 static inline void native_irq_disable(void)
 {
+#if 0
        asm volatile("cli": : :"memory");
+#endif
 }

 static inline void native_irq_enable(void)
 {
+#if 0
        asm volatile("sti": : :"memory");
+#endif
 }

 static inline void native_safe_halt(void)
diff --git a/test/build.sh b/test/build.sh
new file mode 100755
index 0000000..30dfc3c
--- /dev/null
+++ b/test/build.sh
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+cc -o test -I ../include -I ../arch/x86/include -D__KERNEL__ -include
../include/linux/autoconf.h common/common.c mm/slub/test.c ../mm/slub.c
diff --git a/test/common/common.c b/test/common/common.c
new file mode 100644
index 0000000..5063415
--- /dev/null
+++ b/test/common/common.c
@@ -0,0 +1,358 @@
+#define REG_TEST_OVERRIDE_JIFFIES
+
+#ifdef REG_TEST_OVERRIDE_JIFFIES
+#include <linux/jiffies.h>
+unsigned long volatile __jiffy_data jiffies;
+#endif
+
+#include <linux/mmzone.h>
+struct pglist_data contig_page_data;
+
+#include <linux/percpu.h>
+#include <linux/module.h>
+DEFINE_PER_CPU(int, cpu_number);
+EXPORT_PER_CPU_SYMBOL(cpu_number);
+
+#include <linux/percpu.h>
+#include <linux/module.h>
+DEFINE_PER_CPU(struct task_struct *, current_task);
+EXPORT_PER_CPU_SYMBOL(current_task);
+
+#include <asm/processor.h>
+struct cpuinfo_x86     boot_cpu_data;
+
+#ifdef REG_TEST_OVERRIDE_NR_CPU_IDS
+#include <linux/cpumask.h>
+int nr_cpu_ids;
+#endif
+
+#include <linux/cpumask.h>
+const struct cpumask *const cpu_possible_mask;
+
+#include <linux/cpumask.h>
+const struct cpumask *const cpu_online_mask;
+
+#include <linux/kernel.h>
+int printk(const char *s, ...)
+{
+       return 0;
+}
+
+#include <linux/kernel.h>
+int get_option(char **str, int *pint)
+{
+       return 0;
+}
+
+#include <linux/kernel.h>
+void panic(const char *fmt, ...)
+{
+       for(;;)
+       {
+       }
+}
+
+#include <linux/kernel.h>
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+       return (char *)0;
+}
+
+#include <linux/ctype.h>
+unsigned char _ctype[];
+
+#ifdef REG_TEST_OVERRIDE__SPIN_LOCK
+#include <linux/spinlock.h>
+void _spin_lock(spinlock_t *lock)
+{
+}
+#endif
+
+#ifdef REG_TEST_OVERRIDE__SPIN_LOCK_IRQSAVE
+#include <linux/spinlock.h>
+unsigned long _spin_lock_irqsave(spinlock_t *lock)
+{
+       return 0;
+}
+#endif
+
+#ifdef REG_TEST_UNLOCK_IRQRESTORE
+#include <linux/spinlock.h>
+void _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+{
+}
+#endif
+
+#include <linux/kallsyms.h>
+int sprint_symbol(char *buffer, unsigned long address)
+{
+       return 0;
+}
+
+#if REG_TEST_OVERRIDE_ON_EACH_CPU
+#include <linux/smp.h>
+int on_each_cpu(void (*func)(void *info), void *info, int wait)
+{
+       return 0;
+}
+#endif
+
+#include <linux/mmzone.h>
+struct page *mem_map;
+
+#include <linux/tracepoint.h>
+struct tracepoint __tracepoint_kmalloc;
+
+#include <linux/tracepoint.h>
+struct tracepoint __tracepoint_kmem_cache_free;
+
+#include <linux/tracepoint.h>
+struct tracepoint __tracepoint_kmem_cache_alloc;
+
+#include <linux/tracepoint.h>
+struct tracepoint __tracepoint_kfree;
+
+#include <linux/tracepoint.h>
+struct tracepoint __tracepoint_kmalloc_node;
+
+#include <linux/mm.h>
+void *page_address(struct page *page)
+{
+       return (void *)0;
+}
+
+#include <linux/mm.h>
+void put_page(struct page *page)
+{
+}
+
+#include <linux/kernel.h>
+void dump_stack(void)
+{
+}
+
+#if REG_TEST_MODE_ZONE_PAGE_STATE
+#include <linux/vmstat.h>
+void mod_zone_page_state(struct zone *a, enum zone_stat_item b, int c)
+{
+}
+#endif
+
+#include <linux/vmstat.h>
+atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
+
+#include <linux/gfp.h>
+void free_pages(unsigned long addr, unsigned int order)
+{
+}
+
+#include <linux/gfp.h>
+void __free_pages(struct page *page, unsigned int order)
+{
+}
+
+#include <linux/gfp.h>
+unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
+{
+}
+
+#include <linux/gfp.h>
+struct page * __alloc_pages_internal(gfp_t gfp_mask, unsigned int
order, struct zonelist *zonelist, nodemask_t *nodemask)
+{
+       return (struct page *)0;
+}
+
+#include <linux/rcupdate.h>
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head
*head))
+{
+}
+
+#include <linux/bitmap.h>
+int __bitmap_empty(const unsigned long *bitmap, int bits)
+{
+       return 0;
+}
+
+#include <linux/bitmap.h>
+int __bitmap_weight(const unsigned long *bitmap, int bits)
+{
+       return 0;
+}
+
+#include <linux/bitmap.h>
+int bitmap_scnlistprintf(char *buf, unsigned int len, const unsigned
long *src, int nbits)
+{
+       return 0;
+}
+
+#include <linux/bitops.h>
+unsigned long find_next_bit(const unsigned long *addr, unsigned long
size, unsigned long offset)
+{
+       return 0;
+}
+
+#include <linux/kernel.h>
+int strict_strtoul(const char *a, unsigned int b, unsigned long *c)
+{
+       return 0;
+}
+
+#include <linux/seq_file.h>
+int seq_open(struct file *a, const struct seq_operations *b)
+{
+       return 0;
+}
+
+#include <linux/seq_file.h>
+struct list_head *seq_list_start(struct list_head *head, loff_t pos)
+{
+       return (struct list_head *)0;
+}
+
+#include <linux/seq_file.h>
+struct list_head *seq_list_next(void *v, struct list_head *head, loff_t
*ppos)
+{
+       return (struct list_head *)0;
+}
+
+#include <linux/seq_file.h>
+int seq_printf(struct seq_file *a, const char *b, ...)
+{
+       return 0;
+}
+
+#include <linux/seq_file.h>
+loff_t seq_lseek(struct file *a, loff_t b, int c)
+{
+       return 0;
+}
+
+#include <linux/seq_file.h>
+ssize_t seq_read(struct file *a, char *b, size_t c, loff_t *d)
+{
+       return 0;
+}
+
+int seq_release(struct inode *a, struct file *b)
+{
+       return 0;
+}
+
+#include <linux/rwsem.h>
+void up_read(struct rw_semaphore *sem)
+{
+}
+
+#include <linux/rwsem.h>
+void up_write(struct rw_semaphore *sem)
+{
+}
+
+#include <linux/rwsem.h>
+void down_read(struct rw_semaphore *sem)
+{
+}
+
+#include <linux/rwsem.h>
+void down_write(struct rw_semaphore *sem)
+{
+}
+
+#include <linux/rwsem.h>
+int down_write_trylock(struct rw_semaphore *sem)
+{
+}
+
+#include <linux/seq_file.h>
+int seq_putc(struct seq_file *m, char c)
+{
+       return 0;
+}
+
+#include <linux/seq_file.h>
+int seq_puts(struct seq_file *m, const char *s)
+{
+       return 0;
+}
+
+#include <asm/percpu.h>
+unsigned long __per_cpu_offset[NR_CPUS];
+
+#include <asm/bug.h>
+void warn_slowpath(const char *file, const int line, const char *fmt,
...)
+{
+}
+
+#include <linux/sched.h>
+int _cond_resched(void)
+{
+       return 0;
+}
+
+#include <linux/workqueue.h>
+int schedule_work(struct work_struct *work)
+{
+       return 0;
+}
+
+#include <linux/sysfs.h>
+int sysfs_create_link(struct kobject *kobj, struct kobject *target,
const char *name)
+{
+       return 0;
+}
+
+#include <linux/sysfs.h>
+void sysfs_remove_link(struct kobject *kobj, const char *name)
+{
+}
+
+#include <linux/sysfs.h>
+int sysfs_create_group(struct kobject *kobj, const struct
attribute_group *grp)
+{
+       return 0;
+}
+
+#include <linux/kobject.h>
+struct kobject *kernel_kobj;
+
+#include <linux/kobject.h>
+struct kset *kset_create_and_add(const char *name, struct
kset_uevent_ops *u, struct kobject *parent_kobj)
+{
+       return (struct kset *)0;
+}
+
+#include <linux/kobject.h>
+int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
struct kobject *parent, const char *fmt, ...)
+{
+       return 0;
+}
+
+#include <linux/kobject.h>
+void kobject_put(struct kobject *kobj)
+{
+}
+
+#include <linux/kobject.h>
+int kobject_uevent(struct kobject *kobj, enum kobject_action action)
+{
+       return 0;
+}
+
+#include <linux/kobject.h>
+void kobject_del(struct kobject *kobj)
+{
+}
+
+#include <linux/proc_fs.h>
+struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
struct proc_dir_entry *parent, const struct file_operations *proc_fops,
void *data)
+{
+       return (struct proc_dir_entry *)0;
+}
+
+#if REG_TEST_OVERRIDE_REGISTER_CPU_NOTIFIER
+#include <linux/cpu.h>
+int register_cpu_notifier(struct notifier_block *nb)
+{
+       return 0;
+}
+#endif
diff --git a/test/mm/slub/test.c b/test/mm/slub/test.c
new file mode 100644
index 0000000..f328750
--- /dev/null
+++ b/test/mm/slub/test.c
@@ -0,0 +1,12 @@
+#include <linux/slab.h>
+
+#undef __always_inline
+
+#include <stdio.h>
+
+int main(int argc, char *argv)
+{
+       char * p = kmalloc(10, GFP_KERNEL);
+
+       printf("%p\n", p);
+}
--
1.6.0
