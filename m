Return-Path: <linux-kernel-owner+w=401wt.eu-S1764556AbZEHV1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764556AbZEHV1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZEHVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:44763 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951AbZEHVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:36 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 01/13] RFC ONLY - kdb: core for kgdb back end
Date: Fri,  8 May 2009 16:23:08 -0500
Message-Id: <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:24.0372 (UTC) FILETIME=[384C3140:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patch.  This work is by no means in its final form, nor
is it in a form that would be suitible for upstream merging.  This is
an early prototype of a kdb frontend talking to a kgdb backend.  It is
meant to foster some discussion around the usefulness of merging kdb
and kgdb together, as well as experiment with changes to kgdb's core
to improve robustness and functionality.

This patch contains the kdb core and some instrumentation into the
core kernel which kdb requires in order to gather information for some
of its reporting functions.

This work is directly derived from kdb v4.4 found at:

ftp://oss.sgi.com/projects/kdb/download/v4.4/

This particular patch is not even close to sanitized with sparse, or
checkpatch.pl.  This is more or less a very raw port of the original
kdb which attempts to break down kdb into a architecture independent
front end to attach to kgdb.

The original starting point for the 2.6.29 kernel was:
   "129 files changed, 57952 insertions(+), 10 deletions(-)"

You can imagine some stuff got severly chopped in order to get it down
to ~8000 lines worth changes.  Things like the x86 disasembler,
kdump/kexec analysis, x86 specific backtracer, usb support, and even
the scrolling pager got tossed overboard.

There is a lot of clean up that can happen with in the kdb internals
as a result of the integration as well as to improve modularity.  It
seems that it would be nice to have a modular front end for kgdb which
you can add additional commands for other post mortem activities.
Part of the motivation behind adding another front end to kgdb is to
make the built in kernel debugger better and join the user base of kdb
and kgdb vs further fragmentation.

With all the disclaimers out of the way, it can be noted that this is
a working prototype for 4 architechtures, and it is reasonably easy to
add more.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Makefile                              |    1 +
 arch/arm/include/asm/kmap_types.h     |    1 +
 arch/mips/include/asm/kmap_types.h    |    3 +-
 arch/powerpc/include/asm/kmap_types.h |    1 +
 arch/x86/include/asm/kmap_types.h     |    3 +-
 fs/proc/meminfo.c                     |  145 ++
 fs/proc/mmu.c                         |   16 +-
 include/linux/kdb.h                   |  171 ++
 include/linux/kdbprivate.h            |  610 ++++++
 init/main.c                           |   26 +
 kdb/.gitignore                        |    1 +
 kdb/Makefile                          |   48 +
 kdb/kdb_bp.c                          |  863 ++++++++
 kdb/kdb_bt.c                          |  209 ++
 kdb/kdb_cmds                          |   32 +
 kdb/kdb_io.c                          |  890 ++++++++
 kdb/kdbmain.c                         | 3666 +++++++++++++++++++++++++++++++++
 kdb/kdbsupport.c                      | 1120 ++++++++++
 kernel/kallsyms.c                     |   22 +
 kernel/module.c                       |   19 +-
 kernel/panic.c                        |    6 +
 kernel/printk.c                       |   14 +
 kernel/sched.c                        |   93 +-
 kernel/signal.c                       |   49 +
 mm/hugetlb.c                          |   22 +
 mm/swapfile.c                         |   22 +
 26 files changed, 8045 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/kdb.h
 create mode 100644 include/linux/kdbprivate.h
 create mode 100644 kdb/.gitignore
 create mode 100644 kdb/Makefile
 create mode 100644 kdb/kdb_bp.c
 create mode 100644 kdb/kdb_bt.c
 create mode 100644 kdb/kdb_cmds
 create mode 100644 kdb/kdb_io.c
 create mode 100644 kdb/kdbmain.c
 create mode 100644 kdb/kdbsupport.c

diff --git a/Makefile b/Makefile
index b18afad..b2c349a 100644
--- a/Makefile
+++ b/Makefile
@@ -647,6 +647,7 @@ export mod_strip_cmd
 
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-$(CONFIG_KGDB_KDB) += kdb/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/arch/arm/include/asm/kmap_types.h b/arch/arm/include/asm/kmap_types.h
index d16ec97..93cc780 100644
--- a/arch/arm/include/asm/kmap_types.h
+++ b/arch/arm/include/asm/kmap_types.h
@@ -19,6 +19,7 @@ enum km_type {
 	KM_SOFTIRQ0,
 	KM_SOFTIRQ1,
 	KM_L2_CACHE,
+	KM_KDB,
 	KM_TYPE_NR
 };
 
diff --git a/arch/mips/include/asm/kmap_types.h b/arch/mips/include/asm/kmap_types.h
index 806aae3..ec3f7a7 100644
--- a/arch/mips/include/asm/kmap_types.h
+++ b/arch/mips/include/asm/kmap_types.h
@@ -22,7 +22,8 @@ D(9)	KM_IRQ0,
 D(10)	KM_IRQ1,
 D(11)	KM_SOFTIRQ0,
 D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
+D(13)	KM_KDB,
+D(14)	KM_TYPE_NR
 };
 
 #undef D
diff --git a/arch/powerpc/include/asm/kmap_types.h b/arch/powerpc/include/asm/kmap_types.h
index b6bac6f..96ae0f2 100644
--- a/arch/powerpc/include/asm/kmap_types.h
+++ b/arch/powerpc/include/asm/kmap_types.h
@@ -26,6 +26,7 @@ enum km_type {
 	KM_SOFTIRQ1,
 	KM_PPC_SYNC_PAGE,
 	KM_PPC_SYNC_ICACHE,
+	KM_KDB,
 	KM_TYPE_NR
 };
 
diff --git a/arch/x86/include/asm/kmap_types.h b/arch/x86/include/asm/kmap_types.h
index 5759c16..9e7a73f 100644
--- a/arch/x86/include/asm/kmap_types.h
+++ b/arch/x86/include/asm/kmap_types.h
@@ -21,7 +21,8 @@ D(9)	KM_IRQ0,
 D(10)	KM_IRQ1,
 D(11)	KM_SOFTIRQ0,
 D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
+D(13)	KM_KDB,
+D(14)	KM_TYPE_NR
 };
 
 #undef D
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index c6b0302..4124657 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -154,6 +154,151 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #undef K
 }
 
+#ifdef	CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+/* Like meminfo_proc_show() but without the locks and using kdb_printf() */
+void
+kdb_meminfo_proc_show(void)
+{
+	struct sysinfo i;
+	unsigned long committed;
+	unsigned long allowed;
+	struct vmalloc_info vmi;
+	long cached;
+	unsigned long pages[NR_LRU_LISTS];
+	int lru;
+
+/*
+ * display in kilobytes.
+ */
+#define K(x) ((x) << (PAGE_SHIFT - 10))
+	si_meminfo(&i);
+	kdb_si_swapinfo(&i);
+	committed = percpu_counter_read_positive(&vm_committed_as);
+	allowed = ((totalram_pages - hugetlb_total_pages())
+		* sysctl_overcommit_ratio / 100) + total_swap_pages;
+
+	cached = global_page_state(NR_FILE_PAGES) -
+			total_swapcache_pages - i.bufferram;
+	if (cached < 0)
+		cached = 0;
+
+	get_vmalloc_info(&vmi);
+
+	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
+		pages[lru] = global_page_state(NR_LRU_BASE + lru);
+
+	kdb_printf(
+		"MemTotal:       %8lu kB\n"
+		"MemFree:        %8lu kB\n"
+		"Buffers:        %8lu kB\n",
+		K(i.totalram),
+		K(i.freeram),
+		K(i.bufferram)
+		);
+	kdb_printf(
+		"Cached:         %8lu kB\n"
+		"SwapCached:     %8lu kB\n"
+		"Active:         %8lu kB\n"
+		"Inactive:       %8lu kB\n",
+		K(cached),
+		K(total_swapcache_pages),
+		K(pages[LRU_ACTIVE_ANON]   + pages[LRU_ACTIVE_FILE]),
+		K(pages[LRU_INACTIVE_ANON] + pages[LRU_INACTIVE_FILE])
+		);
+	kdb_printf(
+		"Active(anon):   %8lu kB\n"
+		"Inactive(anon): %8lu kB\n"
+		"Active(file):   %8lu kB\n"
+		"Inactive(file): %8lu kB\n",
+		K(pages[LRU_ACTIVE_ANON]),
+		K(pages[LRU_INACTIVE_ANON]),
+		K(pages[LRU_ACTIVE_FILE]),
+		K(pages[LRU_INACTIVE_FILE])
+		);
+#ifdef CONFIG_UNEVICTABLE_LRU
+	kdb_printf(
+		"Unevictable:    %8lu kB\n"
+		"Mlocked:        %8lu kB\n",
+		K(pages[LRU_UNEVICTABLE]),
+		K(global_page_state(NR_MLOCK))
+		);
+#endif
+#ifdef CONFIG_HIGHMEM
+	kdb_printf(
+		"HighTotal:      %8lu kB\n"
+		"HighFree:       %8lu kB\n"
+		"LowTotal:       %8lu kB\n"
+		"LowFree:        %8lu kB\n",
+		K(i.totalhigh),
+		K(i.freehigh),
+		K(i.totalram-i.totalhigh),
+		K(i.freeram-i.freehigh)
+		);
+#endif
+	kdb_printf(
+		"SwapTotal:      %8lu kB\n"
+		"SwapFree:       %8lu kB\n"
+		"Dirty:          %8lu kB\n",
+		K(i.totalswap),
+		K(i.freeswap),
+		K(global_page_state(NR_FILE_DIRTY))
+		);
+	kdb_printf(
+		"Writeback:      %8lu kB\n"
+		"AnonPages:      %8lu kB\n"
+		"Mapped:         %8lu kB\n",
+		K(global_page_state(NR_WRITEBACK)),
+		K(global_page_state(NR_ANON_PAGES)),
+		K(global_page_state(NR_FILE_MAPPED))
+		);
+	kdb_printf(
+		"Slab:           %8lu kB\n"
+		"SReclaimable:   %8lu kB\n"
+		"SUnreclaim:     %8lu kB\n",
+		K(global_page_state(NR_SLAB_RECLAIMABLE) +
+				global_page_state(NR_SLAB_UNRECLAIMABLE)),
+		K(global_page_state(NR_SLAB_RECLAIMABLE)),
+		K(global_page_state(NR_SLAB_UNRECLAIMABLE))
+		);
+	kdb_printf(
+		"PageTables:     %8lu kB\n"
+#ifdef CONFIG_QUICKLIST
+		"Quicklists:     %8lu kB\n"
+#endif
+		"NFS_Unstable:   %8lu kB\n"
+		"Bounce:         %8lu kB\n",
+		K(global_page_state(NR_PAGETABLE)),
+#ifdef CONFIG_QUICKLIST
+		K(quicklist_total_size()),
+#endif
+		K(global_page_state(NR_UNSTABLE_NFS)),
+		K(global_page_state(NR_BOUNCE))
+		);
+	kdb_printf(
+		"WritebackTmp:   %8lu kB\n"
+		"CommitLimit:    %8lu kB\n"
+		"Committed_AS:   %8lu kB\n",
+		K(global_page_state(NR_WRITEBACK_TEMP)),
+		K(allowed),
+		K(committed)
+		);
+	kdb_printf(
+		"VmallocTotal:   %8lu kB\n"
+		"VmallocUsed:    %8lu kB\n"
+		"VmallocChunk:   %8lu kB\n",
+		(unsigned long)VMALLOC_TOTAL >> 10,
+		vmi.used >> 10,
+		vmi.largest_chunk >> 10
+		);
+
+#ifdef	CONFIG_HUGETLBFS
+	kdb_hugetlb_report_meminfo();
+#endif
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 static int meminfo_proc_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, meminfo_proc_show, NULL);
diff --git a/fs/proc/mmu.c b/fs/proc/mmu.c
index 8ae221d..7fdb075 100644
--- a/fs/proc/mmu.c
+++ b/fs/proc/mmu.c
@@ -14,11 +14,21 @@
 #include <asm/pgtable.h>
 #include "internal.h"
 
+#ifdef	CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+#endif
+
 void get_vmalloc_info(struct vmalloc_info *vmi)
 {
 	struct vm_struct *vma;
 	unsigned long free_area_size;
 	unsigned long prev_end;
+#ifdef CONFIG_KGDB_KDB
+	int get_lock = !KDB_IS_RUNNING();
+#else
+#define	get_lock 1
+#endif
+
 
 	vmi->used = 0;
 
@@ -30,7 +40,8 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 
 		prev_end = VMALLOC_START;
 
-		read_lock(&vmlist_lock);
+		if (get_lock)
+			read_lock(&vmlist_lock);
 
 		for (vma = vmlist; vma; vma = vma->next) {
 			unsigned long addr = (unsigned long) vma->addr;
@@ -55,6 +66,7 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 		if (VMALLOC_END - prev_end > vmi->largest_chunk)
 			vmi->largest_chunk = VMALLOC_END - prev_end;
 
-		read_unlock(&vmlist_lock);
+		if (get_lock)
+			read_unlock(&vmlist_lock);
 	}
 }
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
new file mode 100644
index 0000000..200af81
--- /dev/null
+++ b/include/linux/kdb.h
@@ -0,0 +1,171 @@
+#ifndef _KDB_H
+#define _KDB_H
+
+/*
+ * Kernel Debugger Architecture Independent Global Headers
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2000-2007 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (C) 2000 Stephane Eranian <eranian@hpl.hp.com>
+ */
+
+#ifdef	CONFIG_KGDB_KDB
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+
+#define KDB_MAJOR_VERSION	4
+#define KDB_MINOR_VERSION	4
+#define KDB_TEST_VERSION	""
+#define KDB_POLL_FUNC_MAX	5
+
+/*
+ * kdb_initial_cpu is initialized to -1, and is set to the cpu
+ * number whenever the kernel debugger is entered.
+ */
+extern int kdb_initial_cpu;
+extern atomic_t kdb_event;
+extern atomic_t kdb_8250;
+
+#define KDB_IS_RUNNING() (kdb_initial_cpu != -1)
+#define KDB_8250() (atomic_read(&kdb_8250) != 0)
+
+/*
+ * kdb_on
+ *
+ * 	Defines whether kdb is on or not.  Default value
+ *	is set by CONFIG_KDB_OFF.  Boot with kdb=on/off/on-nokey
+ *	or echo "[012]" > /proc/sys/kernel/kdb to change it.
+ */
+extern int kdb_on;
+
+#if defined(CONFIG_SERIAL_8250_CONSOLE) || defined(CONFIG_SERIAL_SGI_L1_CONSOLE)
+/*
+ * kdb_serial.iobase is initialized to zero, and is set to the I/O
+ * address of the serial port when the console is setup in
+ * serial_console_setup.
+ */
+extern struct kdb_serial {
+	int io_type;
+	unsigned long iobase;
+	unsigned long ioreg_shift;
+} kdb_serial;
+#endif
+
+/*
+ * kdb_diemsg
+ *
+ *	Contains a pointer to the last string supplied to the
+ *	kernel 'die' panic function.
+ */
+extern const char *kdb_diemsg;
+
+#define KDB_FLAG_EARLYKDB	(1 << 0) /* set from boot parameter kdb=early */
+#define KDB_FLAG_CATASTROPHIC	(1 << 1) /* A catastrophic event has occurred */
+#define KDB_FLAG_CMD_INTERRUPT	(1 << 2) /* Previous command was interrupted */
+#define KDB_FLAG_NOIPI		(1 << 3) /* Do not send IPIs */
+#define KDB_FLAG_ONLY_DO_DUMP	(1 << 4) /* Only do a dump, used when
+					  * kdb is off */
+#define KDB_FLAG_NO_CONSOLE	(1 << 5) /* No console is available,
+					  * kdb is disabled */
+#define KDB_FLAG_NO_VT_CONSOLE	(1 << 6) /* No VT console is available, do
+					  * not use keyboard */
+#define KDB_FLAG_NO_I8042	(1 << 7) /* No i8042 chip is available, do
+					  * not use keyboard */
+#define KDB_FLAG_RECOVERY	(1 << 8) /* kdb is being entered for an
+					  * error which has been recovered */
+
+extern int kdb_flags;	/* Global flags, see kdb_state for per cpu state */
+
+extern void kdb_save_flags(void);
+extern void kdb_restore_flags(void);
+
+#define KDB_FLAG(flag)		(kdb_flags & KDB_FLAG_##flag)
+#define KDB_FLAG_SET(flag)	((void)(kdb_flags |= KDB_FLAG_##flag))
+#define KDB_FLAG_CLEAR(flag)	((void)(kdb_flags &= ~KDB_FLAG_##flag))
+
+/*
+ * External entry point for the kernel debugger.  The pt_regs
+ * at the time of entry are supplied along with the reason for
+ * entry to the kernel debugger.
+ */
+
+typedef enum {
+	KDB_REASON_ENTER = 1,	/* KDB_ENTER() trap/fault - regs valid */
+	KDB_REASON_ENTER_SLAVE,	/* KDB_ENTER_SLAVE() trap/fault - regs valid */
+	KDB_REASON_BREAK,	/* Breakpoint inst. - regs valid */
+	KDB_REASON_DEBUG,	/* Debug Fault - regs valid */
+	KDB_REASON_OOPS,	/* Kernel Oops - regs valid */
+	KDB_REASON_SWITCH,	/* CPU switch - regs valid*/
+	KDB_REASON_KEYBOARD,	/* Keyboard entry - regs valid */
+	KDB_REASON_NMI,		/* Non-maskable interrupt; regs valid */
+	KDB_REASON_RECURSE,	/* Recursive entry to kdb;
+				 * regs probably valid */
+	KDB_REASON_CPU_UP,	/* Add one cpu to kdb; regs invalid */
+	KDB_REASON_SILENT,	/* Silent entry/exit to kdb;
+				 * regs invalid - internal only */
+	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
+} kdb_reason_t;
+
+/* Mainly used by kdb code, but this function is sometimes used
+ * by hacked debug code so make it generally available, not private.
+ */
+extern void kdb_printf(const char *, ...)
+	    __attribute__ ((format (printf, 1, 2)));
+typedef void (*kdb_printf_t)(const char *, ...)
+	     __attribute__ ((format (printf, 1, 2)));
+extern void kdb_init(void);
+
+#if defined(CONFIG_SMP)
+/*
+ * Kernel debugger non-maskable IPI handler.
+ */
+extern int kdb_ipi(struct pt_regs *, void (*ack_interrupt)(void));
+extern void smp_kdb_stop(void);
+#else	/* CONFIG_SMP */
+#define	smp_kdb_stop()
+#endif	/* CONFIG_SMP */
+
+#ifdef CONFIG_KDB_USB
+
+#include <linux/usb.h>
+
+extern int kdb_no_usb;
+extern int kdb_usb_keyboard_attach(struct urb *urb,
+				   unsigned char *buffer, void *poll_func);
+extern int kdb_usb_keyboard_detach(struct urb *urb);
+
+#endif /* CONFIG_KDB_USB */
+
+static inline
+int kdb_process_cpu(const struct task_struct *p)
+{
+	unsigned int cpu = task_thread_info(p)->cpu;
+	if (cpu > NR_CPUS)
+		cpu = 0;
+	return cpu;
+}
+
+extern const char kdb_serial_str[];
+
+#ifdef CONFIG_KDB_KDUMP
+/* Define values for kdb_kdump_state */
+extern int kdb_kdump_state;	/* KDB kdump state */
+#define KDB_KDUMP_RESET		0
+#define KDB_KDUMP_KDUMP		1
+
+void kdba_kdump_prepare(struct pt_regs *);
+void machine_crash_shutdown(struct pt_regs *);
+void machine_crash_shutdown_begin(void);
+void machine_crash_shutdown_end(struct pt_regs *);
+
+#endif /* CONFIG_KDB_KDUMP */
+#else /* ! CONFIG_KGDB_KDB */
+#define KDB_IS_RUNNING() (0)
+#define KDB_8250() (0)
+#endif	/* CONFIG_KGDB_KDB */
+
+#endif	/* !_KDB_H */
diff --git a/include/linux/kdbprivate.h b/include/linux/kdbprivate.h
new file mode 100644
index 0000000..8579e97
--- /dev/null
+++ b/include/linux/kdbprivate.h
@@ -0,0 +1,610 @@
+#ifndef _KDBPRIVATE_H
+#define _KDBPRIVATE_H
+
+/*
+ * Kernel Debugger Architecture Independent Private Headers
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+
+	/*
+	 * Kernel Debugger Error codes.  Must not overlap with command codes.
+	 */
+
+#define KDB_NOTFOUND	(-1)
+#define KDB_ARGCOUNT	(-2)
+#define KDB_BADWIDTH	(-3)
+#define KDB_BADRADIX	(-4)
+#define KDB_NOTENV	(-5)
+#define KDB_NOENVVALUE	(-6)
+#define KDB_NOTIMP	(-7)
+#define KDB_ENVFULL	(-8)
+#define KDB_ENVBUFFULL	(-9)
+#define KDB_TOOMANYBPT	(-10)
+#define KDB_TOOMANYDBREGS (-11)
+#define KDB_DUPBPT	(-12)
+#define KDB_BPTNOTFOUND	(-13)
+#define KDB_BADMODE	(-14)
+#define KDB_BADINT	(-15)
+#define KDB_INVADDRFMT  (-16)
+#define KDB_BADREG      (-17)
+#define KDB_BADCPUNUM   (-18)
+#define KDB_BADLENGTH	(-19)
+#define KDB_NOBP	(-20)
+#define KDB_BADADDR	(-21)
+
+	/*
+	 * Kernel Debugger Command codes.  Must not overlap with error codes.
+	 */
+#define KDB_CMD_GO	(-1001)
+#define KDB_CMD_CPU	(-1002)
+#define KDB_CMD_SS	(-1003)
+#define KDB_CMD_SSB	(-1004)
+#define KDB_CMD_KGDB (-1005)
+#define KDB_CMD_KGDB2 (-1006)
+
+	/*
+	 * Internal debug flags
+	 */
+/*	KDB_DEBUG_FLAG_BT	0x0001	Was Stack traceback debug */
+#define KDB_DEBUG_FLAG_BP	0x0002	/* Breakpoint subsystem debug */
+#define KDB_DEBUG_FLAG_BB_SUMM	0x0004	/* Basic block analysis, summary only */
+#define KDB_DEBUG_FLAG_AR	0x0008	/* Activation record, generic */
+#define KDB_DEBUG_FLAG_ARA	0x0010	/* Activation record, arch specific */
+#define KDB_DEBUG_FLAG_BB	0x0020	/* All basic block analysis */
+#define KDB_DEBUG_FLAG_STATE	0x0040	/* State flags */
+#define KDB_DEBUG_FLAG_MASK	0xffff	/* All debug flags */
+#define KDB_DEBUG_FLAG_SHIFT	16	/* Shift factor for dbflags */
+
+#define KDB_DEBUG(flag)	(kdb_flags & \
+	(KDB_DEBUG_FLAG_##flag << KDB_DEBUG_FLAG_SHIFT))
+#define KDB_DEBUG_STATE(text, value) if (KDB_DEBUG(STATE)) \
+		kdb_print_state(text, value)
+
+/* merged code from arch independent section */
+
+#if BITS_PER_LONG == 32
+
+#define KDB_PLATFORM_ENV	"BYTESPERWORD=4"
+
+#define kdb_machreg_fmt		"0x%lx"
+#define kdb_machreg_fmt0	"0x%08lx"
+#define kdb_bfd_vma_fmt		"0x%lx"
+#define kdb_bfd_vma_fmt0	"0x%08lx"
+#define kdb_elfw_addr_fmt	"0x%x"
+#define kdb_elfw_addr_fmt0	"0x%08x"
+#define kdb_f_count_fmt		"%d"
+
+#elif BITS_PER_LONG == 64
+
+#define KDB_PLATFORM_ENV	"BYTESPERWORD=8"
+
+#define kdb_machreg_fmt		"0x%lx"
+#define kdb_machreg_fmt0	"0x%016lx"
+#define kdb_bfd_vma_fmt		"0x%lx"
+#define kdb_bfd_vma_fmt0	"0x%016lx"
+#define kdb_elfw_addr_fmt	"0x%x"
+#define kdb_elfw_addr_fmt0	"0x%016x"
+#define kdb_f_count_fmt		"%ld"
+
+#endif
+
+typedef unsigned long kdb_machreg_t;
+typedef unsigned char kdb_machinst_t;
+
+/*
+ * KDB_MAXBPT describes the total number of breakpoints
+ * supported by this architecure.
+ */
+#define KDB_MAXBPT	16
+
+/*
+ * KDB_MAXHARDBPT describes the total number of hardware
+ * breakpoint registers that exist.
+ */
+#define KDB_MAXHARDBPT	4
+
+/* Maximum number of arguments to a function  */
+#define KDBA_MAXARGS    16
+
+typedef struct _kdbhard_bp {
+	kdb_machreg_t	bph_reg;	/* Register this breakpoint uses */
+
+	unsigned int	bph_free:1;	/* Register available for use */
+	unsigned int	bph_data:1;	/* Data Access breakpoint */
+
+	unsigned int	bph_write:1;	/* Write Data breakpoint */
+	unsigned int	bph_mode:2;	/* 0=inst, 1=write, 2=io, 3=read */
+	unsigned int	bph_length:2;	/* 0=1, 1=2, 2=BAD, 3=4 (bytes) */
+	unsigned int	bph_installed;	/* flag: hw bp is installed */
+} kdbhard_bp_t;
+
+
+/* end merge */
+
+typedef enum {
+	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
+	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
+	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
+} kdb_repeat_t;
+
+typedef int (*kdb_func_t)(int, const char **);
+
+	/*
+	 * Symbol table format returned by kallsyms.
+	 */
+
+typedef struct __ksymtab {
+		unsigned long value;	/* Address of symbol */
+		const char *mod_name;	/* Module containing symbol or
+					 * "kernel" */
+		unsigned long mod_start;
+		unsigned long mod_end;
+		const char *sec_name;	/* Section containing symbol */
+		unsigned long sec_start;
+		unsigned long sec_end;
+		const char *sym_name;	/* Full symbol name, including
+					 * any version */
+		unsigned long sym_start;
+		unsigned long sym_end;
+		} kdb_symtab_t;
+extern int kallsyms_symbol_next(char *prefix_name, int flag);
+extern int kallsyms_symbol_complete(char *prefix_name, int max_len);
+
+	/*
+	 * Exported Symbols for kernel loadable modules to use.
+	 */
+extern int kdb_register(char *, kdb_func_t, char *, char *, short);
+extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
+			       short, kdb_repeat_t);
+extern int kdb_unregister(char *);
+
+extern int kdb_getarea_size(void *, unsigned long, size_t);
+extern int kdb_putarea_size(unsigned long, void *, size_t);
+
+/* Like get_user and put_user, kdb_getarea and kdb_putarea take variable
+ * names, not pointers.  The underlying *_size functions take pointers.
+ */
+#define kdb_getarea(x, addr) kdb_getarea_size(&(x), addr, sizeof((x)))
+#define kdb_putarea(addr, x) kdb_putarea_size(addr, &(x), sizeof((x)))
+
+extern int kdb_getphysword(unsigned long *word,
+			unsigned long addr, size_t size);
+extern int kdb_getword(unsigned long *, unsigned long, size_t);
+extern int kdb_putword(unsigned long, unsigned long, size_t);
+
+extern int kdbgetularg(const char *, unsigned long *);
+extern char *kdbgetenv(const char *);
+extern int kdbgetintenv(const char *, int *);
+extern int kdbgetaddrarg(int, const char**, int*, unsigned long *,
+			 long *, char **);
+extern int kdbgetsymval(const char *, kdb_symtab_t *);
+extern int kdbnearsym(unsigned long, kdb_symtab_t *);
+extern void kdbnearsym_cleanup(void);
+extern char *kdb_read(char *buffer, size_t bufsize);
+extern char *kdb_strdup(const char *str, gfp_t type);
+extern void kdb_symbol_print(kdb_machreg_t, const kdb_symtab_t *, unsigned int);
+
+	 /*
+	  * Do we have a set of registers?
+	  */
+
+#define KDB_NULL_REGS(regs) \
+	(regs == (struct pt_regs *)NULL ? \
+	 kdb_printf("%s: null regs - should never happen\n", __func__), \
+	 1 : 0)
+
+	 /*
+	  * Routine for debugging the debugger state.
+	  */
+
+extern void kdb_print_state(const char *, int);
+
+	/*
+	 * Per cpu kdb state.  A cpu can be under kdb control but outside kdb,
+	 * for example when doing single step.
+	 */
+extern int kdb_state[];				/* [NR_CPUS] */
+#define KDB_STATE_KDB		0x00000001	/* Cpu is inside kdb */
+#define KDB_STATE_LEAVING	0x00000002	/* Cpu is leaving kdb */
+#define KDB_STATE_CMD		0x00000004	/* Running a kdb command */
+#define KDB_STATE_KDB_CONTROL	0x00000008	/* This cpu is under
+						 * kdb control */
+#define KDB_STATE_HOLD_CPU	0x00000010	/* Hold this cpu inside kdb */
+#define KDB_STATE_DOING_SS	0x00000020	/* Doing ss command */
+#define KDB_STATE_DOING_SSB	0x00000040	/* Doing ssb command,
+						 * DOING_SS is also set */
+#define KDB_STATE_SSBPT		0x00000080	/* Install breakpoint
+						 * after one ss, independent of
+						 * DOING_SS */
+#define KDB_STATE_REENTRY	0x00000100	/* Valid re-entry into kdb */
+#define KDB_STATE_SUPPRESS	0x00000200	/* Suppress error messages */
+#define KDB_STATE_PAGER		0x00000400	/* pager is available */
+#define KDB_STATE_GO_SWITCH	0x00000800	/* go is switching
+						 * back to initial cpu */
+#define KDB_STATE_PRINTF_LOCK	0x00001000	/* Holds kdb_printf lock */
+#define KDB_STATE_WAIT_IPI	0x00002000	/* Waiting for kdb_ipi() NMI */
+#define KDB_STATE_RECURSE	0x00004000	/* Recursive entry to kdb */
+#define KDB_STATE_IP_ADJUSTED	0x00008000	/* Restart IP has been
+						 * adjusted */
+#define KDB_STATE_GO1		0x00010000	/* go only releases one cpu */
+#define KDB_STATE_KEYBOARD	0x00020000	/* kdb entered via
+						 * keyboard on this cpu */
+#define KDB_STATE_KEXEC		0x00040000	/* kexec issued */
+#define KDB_STATE_DOING_KGDB	0x00080000	/* kgdb enter now issued */
+#define KDB_STATE_DOING_KGDB2	0x00100000	/* kgdb enter now issued */
+#define KDB_STATE_KGDB_TRANS	0x00200000	/* Transition to kgdb */
+#define KDB_STATE_ARCH		0xff000000	/* Reserved for arch
+						 * specific use */
+
+#define KDB_STATE_CPU(flag, cpu) (kdb_state[cpu] & KDB_STATE_##flag)
+#define KDB_STATE_SET_CPU(flag, cpu) \
+	((void)(kdb_state[cpu] |= KDB_STATE_##flag))
+#define KDB_STATE_CLEAR_CPU(flag, cpu) \
+	((void)(kdb_state[cpu] &= ~KDB_STATE_##flag))
+
+#define KDB_STATE(flag)		KDB_STATE_CPU(flag, smp_processor_id())
+#define KDB_STATE_SET(flag)	KDB_STATE_SET_CPU(flag, smp_processor_id())
+#define KDB_STATE_CLEAR(flag)	KDB_STATE_CLEAR_CPU(flag, smp_processor_id())
+
+	/*
+	 * kdb_nextline
+	 *
+	 * 	Contains the current line number on the screen.  Used
+	 *	to handle the built-in pager (LINES env variable)
+	 */
+extern int kdb_nextline;
+
+	/*
+	 * Breakpoint state
+	 *
+	 * 	Each active and inactive breakpoint is represented by
+	 * 	an instance of the following data structure.
+	 */
+
+typedef struct _kdb_bp {
+	unsigned long  	bp_addr;	/* Address breakpoint is present at */
+	kdb_machinst_t	bp_inst;	/* Replaced instruction */
+
+	unsigned int	bp_free:1;	/* This entry is available */
+
+	unsigned int	bp_enabled:1;	/* Breakpoint is active in register */
+	unsigned int	bp_global:1;	/* Global to all processors */
+
+	unsigned int	bp_hardtype:1;	/* Uses hardware register */
+	unsigned int	bp_forcehw:1;	/* Force hardware register */
+	unsigned int	bp_installed:1;	/* Breakpoint is installed */
+	unsigned int	bp_delay:1;	/* Do delayed bp handling */
+	unsigned int	bp_delayed:1;	/* Delayed breakpoint */
+
+	int		bp_cpu;		/* Cpu #  (if bp_global == 0) */
+	kdbhard_bp_t	bp_template;	/* Hardware breakpoint template */
+	kdbhard_bp_t   *bp_hard[NR_CPUS]; /* Hardware breakpoint structure */
+	int		bp_adjust;	/* Adjustment to PC for real
+					 * instruction */
+} kdb_bp_t;
+
+#ifdef CONFIG_KGDB_KDB
+	/*
+	 * Breakpoint handling subsystem global variables
+	 */
+extern kdb_bp_t kdb_breakpoints[/* KDB_MAXBPT */];
+
+	/*
+	 * Breakpoint architecture dependent functions.  Must be provided
+	 * in some form for all architectures.
+	 */
+extern void kdba_initbp(void);
+extern void kdba_printbp(kdb_bp_t *);
+extern void kdba_alloc_hwbp(kdb_bp_t *bp, int *diagp);
+extern void kdba_free_hwbp(kdb_bp_t *bp);
+extern int kdba_parsebp(int, const char**, int *, kdb_bp_t*);
+extern char *kdba_bptype(kdbhard_bp_t *);
+extern void kdba_setsinglestep(struct pt_regs *);
+extern void kdba_clearsinglestep(struct pt_regs *);
+
+	/*
+	 * Adjust instruction pointer architecture dependent function.  Must be
+	 * provided in some form for all architectures.
+	 */
+extern void kdba_adjust_ip(kdb_reason_t, int, struct pt_regs *);
+
+	/*
+	 * KDB-only global function prototypes.
+	 */
+extern void kdb_id1(unsigned long);
+extern void kdb_id_init(void);
+
+	/*
+	 * Initialization functions.
+	 */
+extern void kdba_init(void);
+extern void kdb_io_init(void);
+
+	/*
+	 * Architecture specific function to read a string.
+	 */
+typedef int (*get_char_func)(void);
+extern get_char_func kdb_poll_funcs[];
+extern int kdb_poll_idx;
+extern int kdb_get_kbd_char(void);
+
+#ifndef	CONFIG_IA64
+	/*
+	 * Data for a single activation record on stack.
+	 */
+
+struct kdb_stack_info {
+	kdb_machreg_t physical_start;
+	kdb_machreg_t physical_end;
+	kdb_machreg_t logical_start;
+	kdb_machreg_t logical_end;
+	kdb_machreg_t next;
+	const char *id;
+};
+
+typedef struct { DECLARE_BITMAP(bits, KDBA_MAXARGS); } valid_t;
+
+struct kdb_activation_record {
+	struct kdb_stack_info	stack;		/* information about
+						 * current stack */
+	int		args;			/* number of arguments
+						 * detected */
+	kdb_machreg_t	arg[KDBA_MAXARGS];	/* -> arguments */
+	valid_t		valid;			/* is argument n valid? */
+};
+#endif
+
+	/*
+	 * Architecture specific Stack Traceback functions.
+	 */
+
+struct task_struct;
+
+extern int kdba_bt_address(kdb_machreg_t, int);
+extern int kdba_bt_process(const struct task_struct *, int);
+
+	/*
+	 * KDB Command Table
+	 */
+
+typedef struct _kdbtab {
+	char    *cmd_name;		/* Command name */
+	kdb_func_t cmd_func;		/* Function to execute command */
+	char    *cmd_usage;		/* Usage String for this command */
+	char    *cmd_help;		/* Help message for this command */
+	short    cmd_flags;		/* Parsing flags */
+	short    cmd_minlen;		/* Minimum legal # command
+					 * chars required */
+	kdb_repeat_t cmd_repeat;	/* Does command auto repeat on enter? */
+} kdbtab_t;
+
+	/*
+	 * External command function declarations
+	 */
+
+extern int kdb_id(int, const char **);
+extern int kdb_bt(int, const char **);
+
+	/*
+	 * External utility function declarations
+	 */
+extern char *kdb_getstr(char *, size_t, char *);
+
+	/*
+	 * Register contents manipulation
+	 */
+extern int kdba_getregcontents(const char *, struct pt_regs *, kdb_machreg_t *);
+extern int kdba_setregcontents(const char *, struct pt_regs *, kdb_machreg_t);
+extern int kdba_dumpregs(struct pt_regs *, const char *, const char *);
+extern int kdba_setpc(struct pt_regs *, kdb_machreg_t);
+extern kdb_machreg_t kdba_getpc(struct pt_regs *);
+
+	/*
+	 * Debug register handling.
+	 */
+extern void kdba_installdbreg(kdb_bp_t *);
+extern void kdba_removedbreg(kdb_bp_t *);
+
+	/*
+	 * Breakpoint handling - External interfaces
+	 */
+extern void kdb_initbptab(void);
+extern void kdb_bp_install_global(struct pt_regs *);
+extern void kdb_bp_install_local(struct pt_regs *);
+extern void kdb_bp_remove_global(void);
+extern void kdb_bp_remove_local(void);
+
+	/*
+	 * Breakpoint handling - Internal to kdb_bp.c/kdba_bp.c
+	 */
+extern int kdba_installbp(struct pt_regs *regs, kdb_bp_t *);
+extern int kdba_removebp(kdb_bp_t *);
+
+
+typedef enum {
+	KDB_DB_BPT,	/* Breakpoint */
+	KDB_DB_SS,	/* Single-step trap */
+	KDB_DB_SSB,	/* Single step to branch */
+	KDB_DB_SSBPT,	/* Single step over breakpoint */
+	KDB_DB_NOBPT	/* Spurious breakpoint */
+} kdb_dbtrap_t;
+
+/* DEBUG trap/fault handler */
+extern kdb_dbtrap_t kdba_db_trap(struct pt_regs *, int);
+/* Breakpoint trap/fault hdlr */
+extern kdb_dbtrap_t kdba_bp_trap(struct pt_regs *, int);
+
+	/*
+	 * Interrupt Handling
+	 */
+typedef unsigned long kdb_intstate_t;
+
+extern void kdba_disableint(kdb_intstate_t *);
+extern void kdba_restoreint(kdb_intstate_t *);
+
+	/*
+	 * SMP and process stack manipulation routines.
+	 */
+extern int kdba_ipi(struct pt_regs *, void (*)(void));
+extern int kdba_main_loop(kdb_reason_t, kdb_reason_t,
+			  int, kdb_dbtrap_t, struct pt_regs *);
+extern int kdb_main_loop(kdb_reason_t, kdb_reason_t,
+			 int, kdb_dbtrap_t, struct pt_regs *);
+
+	/*
+	 * General Disassembler interfaces
+	 */
+#if 0
+extern int kdb_dis_fprintf(PTR, const char *, ...) \
+	__attribute__ ((format (printf, 2, 3)));
+extern int kdb_dis_fprintf_dummy(PTR, const char *, ...) \
+	__attribute__ ((format (printf, 2, 3)));
+extern disassemble_info	kdb_di;
+#endif
+
+	/*
+	 * Architecture Dependent Disassembler interfaces
+	 */
+#if 0
+extern int  kdba_id_printinsn(kdb_machreg_t, disassemble_info *);
+extern int  kdba_id_parsemode(const char *, disassemble_info*);
+extern void kdba_id_init(disassemble_info *);
+extern void kdba_check_pc(kdb_machreg_t *);
+#endif
+
+	/*
+	 * Miscellaneous functions and data areas
+	 */
+extern char *kdb_cmds[];
+extern void kdb_syslog_data(char *syslog_data[]);
+extern unsigned long kdb_task_state_string(const char *);
+extern char kdb_task_state_char (const struct task_struct *);
+extern unsigned long kdb_task_state(const struct task_struct *p,
+				    unsigned long mask);
+extern void kdb_ps_suppressed(void);
+extern void kdb_ps1(const struct task_struct *p);
+extern int kdb_parse(const char *cmdstr);
+extern void kdb_print_nameval(const char *name, unsigned long val);
+extern void kdb_send_sig_info(struct task_struct *p,
+			      struct siginfo *info, int seqno);
+#ifdef CONFIG_SWAP
+extern void kdb_si_swapinfo(struct sysinfo *);
+#else
+#include <linux/swap.h>
+#define kdb_si_swapinfo(x) si_swapinfo(x)
+#endif
+extern void kdb_meminfo_proc_show(void);
+#ifdef	CONFIG_HUGETLB_PAGE
+extern void kdb_hugetlb_report_meminfo(void);
+#endif	/* CONFIG_HUGETLB_PAGE */
+extern const char *kdb_walk_kallsyms(loff_t *pos);
+
+	/*
+	 * Architecture Dependant Local Processor setup & cleanup interfaces
+	 */
+extern void kdba_local_arch_setup(void);
+extern void kdba_local_arch_cleanup(void);
+
+	/*
+	 * Defines for kdb_symbol_print.
+	 */
+#define KDB_SP_SPACEB	0x0001		/* Space before string */
+#define KDB_SP_SPACEA	0x0002		/* Space after string */
+#define KDB_SP_PAREN	0x0004		/* Parenthesis around string */
+#define KDB_SP_VALUE	0x0008		/* Print the value of the address */
+#define KDB_SP_SYMSIZE	0x0010		/* Print the size of the symbol */
+#define KDB_SP_NEWLINE	0x0020		/* Newline after string */
+#define KDB_SP_DEFAULT (KDB_SP_VALUE|KDB_SP_PAREN)
+
+/* Save data about running processes */
+
+#if 0
+struct kdba_running_process {
+	long sp;	/* KDB may be on a different stack */
+	long ip;	/* eip when esp was set */
+};
+#endif
+
+struct kdb_running_process {
+	struct task_struct *p;
+	struct pt_regs *regs;
+	int seqno;				/* kdb sequence number */
+	int irq_depth;				/* irq count */
+	/*struct kdba_running_process arch; */	/* arch dependent save data */
+};
+
+extern struct kdb_running_process kdb_running_process[/* NR_CPUS */];
+
+extern void kdb_save_running_cpu(struct pt_regs *, struct task_struct *, int);
+extern int kdb_save_running(struct pt_regs *, kdb_reason_t,
+			    kdb_reason_t, int, kdb_dbtrap_t);
+extern void kdb_unsave_running(struct pt_regs *);
+extern struct task_struct *kdb_curr_task(int);
+
+/* 	Incremented each time the main kdb loop is entered on the initial cpu,
+ * 	it gives some indication of how old the saved data is.
+ */
+extern int kdb_seqno;
+
+#define kdb_task_has_cpu(p) (task_curr(p))
+extern void kdb_runqueue(unsigned long cpu, kdb_printf_t xxx_printf);
+
+/* Simplify coexistence with NPTL */
+#define	kdb_do_each_thread(g, p) do_each_thread(g, p)
+#define	kdb_while_each_thread(g, p) while_each_thread(g, p)
+
+#define GFP_KDB (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
+
+extern void *debug_kmalloc(size_t size, gfp_t flags);
+extern void debug_kfree(void *);
+extern void debug_kusage(void);
+
+extern void kdba_set_current_task(const struct task_struct *);
+extern const struct task_struct *kdb_current_task;
+extern struct pt_regs *kdb_current_regs;
+
+/* Functions to safely read and write kernel areas.  The {to,from}_xxx
+ * addresses are not necessarily valid, these functions must check for
+ * validity.  If the arch already supports get and put routines with suitable
+ * validation and/or recovery on invalid addresses then use those routines,
+ * otherwise check it yourself.
+ */
+
+extern int kdba_putarea_size(unsigned long to_xxx, void *from, size_t size);
+extern int kdba_getarea_size(void *to, unsigned long from_xxx, size_t size);
+extern int kdba_verify_rw(unsigned long addr, size_t size);
+
+#ifndef KDB_RUNNING_PROCESS_ORIGINAL
+#define KDB_RUNNING_PROCESS_ORIGINAL kdb_running_process
+#endif
+
+extern int kdb_wait_for_cpus_secs;
+extern void kdba_cpu_up(void);
+extern char kdb_prompt_str[];
+
+#define	KDB_WORD_SIZE	((int)sizeof(kdb_machreg_t))
+
+#ifdef CONFIG_KDB_USB
+#include <linux/usb.h>
+
+struct kdb_usb_kbd_info {
+	struct urb *urb;		/* pointer to the URB */
+	unsigned char *buffer;		/* pointer to the kbd char buffer */
+	int (*poll_func)(struct urb *urb); /* poll function to retrieve chars */
+	int	poll_ret;	/* return val from poll_func */
+	int	caps_lock;	/* state of the caps lock for this keyboard */
+};
+#endif /* CONFIG_KDB_USB */
+
+#ifdef CONFIG_KDB_KDUMP
+#define KDUMP_REASON_RESET	0
+extern void kdba_kdump_shutdown_slave(struct pt_regs *);
+#endif /* CONFIG_KDB_KDUMP */
+#endif /* CONFIG_KGDB_KDB */
+#endif	/* !_KDBPRIVATE_H */
diff --git a/init/main.c b/init/main.c
index 3bbf93b..5b16c8b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -62,6 +62,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kdb.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <trace/boot.h>
@@ -190,6 +191,26 @@ static const char *panic_later, *panic_param;
 
 extern struct obs_kernel_param __setup_start[], __setup_end[];
 
+#ifdef	CONFIG_KGDB_KDB
+static int __init kdb_setup(char *str)
+{
+	if (strcmp(str, "on") == 0) {
+		kdb_on = 1;
+	} else if (strcmp(str, "on-nokey") == 0) {
+		kdb_on = 2;
+	} else if (strcmp(str, "off") == 0) {
+		kdb_on = 0;
+	} else if (strcmp(str, "early") == 0) {
+		kdb_on = 1;
+		kdb_flags |= KDB_FLAG_EARLYKDB;
+	} else
+		printk(KERN_ERR "kdb flag %s not recognised\n", str);
+	return 0;
+}
+
+__setup("kdb=", kdb_setup);
+#endif	/* CONFIG_KGDB_KDB */
+
 static int __init obsolete_checksetup(char *line)
 {
 	struct obs_kernel_param *p;
@@ -666,6 +687,11 @@ asmlinkage void __init start_kernel(void)
 	pgtable_cache_init();
 	prio_tree_init();
 	anon_vma_init();
+
+#ifdef	CONFIG_KGDB_KDB
+	kdb_init();
+#endif	/* CONFIG_KGDB_KDB */
+
 #ifdef CONFIG_X86
 	if (efi_enabled)
 		efi_enter_virtual_mode();
diff --git a/kdb/.gitignore b/kdb/.gitignore
new file mode 100644
index 0000000..396d12e
--- /dev/null
+++ b/kdb/.gitignore
@@ -0,0 +1 @@
+gen-kdb_cmds.c
diff --git a/kdb/Makefile b/kdb/Makefile
new file mode 100644
index 0000000..6f67941
--- /dev/null
+++ b/kdb/Makefile
@@ -0,0 +1,48 @@
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (c) 1999-2004 Silicon Graphics, Inc.  All Rights Reserved.
+#
+
+EXTRA_CFLAGS += -O0
+
+CCVERSION	:= $(shell $(CC) -v 2>&1 | sed -ne '$$p')
+obj-y := kdb_io.o kdbmain.o kdbsupport.o kdb_bt.o gen-kdb_cmds.o kdb_bp.o
+#obj-$(CONFIG_KDB_LXCRASH) += kdbdereference.o
+#
+#obj-y		:= kdb_bt.o kdb_bp.o kdb_id.o kdbsupport.o gen-kdb_cmds.o kdbmain.o kdb_io.o kdbdereference.o
+#CFLAGS_kdbmain.o += -DCCVERSION="$(CCVERSION)"
+#
+#subdir-$(CONFIG_KDB_MODULES) := modules
+#obj-y += $(addsuffix /built-in.o, $(subdir-y))
+#
+clean-files := gen-kdb_cmds.c
+#
+#override CFLAGS := $(CFLAGS:%-pg=% )
+#
+## define architecture dependent kdb_cmds
+#ifeq ($(CONFIG_IA64),y)
+#	KDB_CMDS = ia64/kdb/kdb_cmds
+#else
+#	ifeq ($(CONFIG_X86_64),y)
+#		KDB_CMDS = x86/kdb/kdb_cmds_64
+#	else
+#		ifeq ($(CONFIG_X86_32),y)
+#			KDB_CMDS = x86/kdb/kdb_cmds_32
+#		endif
+#	endif
+#endif
+#
+quiet_cmd_gen-kdb = GENKDB  $@
+      cmd_gen-kdb = $(AWK) 'BEGIN {print "\#include <linux/stddef.h>"; print "\#include <linux/init.h>"} \
+		/^\#/{next} \
+	/^[ \t]*$$/{next} \
+		{gsub(/"/, "\\\"", $$0); \
+		  print "static __initdata char kdb_cmd" cmds++ "[] = \"" $$0 "\\n\";"} \
+		END {print "extern char *kdb_cmds[]; char __initdata *kdb_cmds[] = {"; for (i = 0; i < cmds; ++i) {print "  kdb_cmd" i ","}; print("  NULL\n};");}' \
+		$(filter-out %/Makefile,$^) > $@#
+
+$(obj)/gen-kdb_cmds.c:	$(src)/kdb_cmds $(if $(KDB_CMDS),(wildcard $(TOPDIR)/arch/$(KDB_CMDS))) $(src)/Makefile
+	$(call cmd,gen-kdb)
diff --git a/kdb/kdb_bp.c b/kdb/kdb_bp.c
new file mode 100644
index 0000000..7f2264e
--- /dev/null
+++ b/kdb/kdb_bp.c
@@ -0,0 +1,863 @@
+/*
+ * Kernel Debugger Architecture Independent Breakpoint Handler
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 1999-2004 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+#include <linux/kgdb.h>
+#include <linux/smp.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <asm/system.h>
+
+/*
+ * Table of kdb_breakpoints
+ */
+kdb_bp_t kdb_breakpoints[KDB_MAXBPT];
+
+/* HACK HACK HACK */
+
+void kdba_setsinglestep(struct pt_regs *regs)
+{
+	KDB_STATE_SET(DOING_SS);
+}
+
+void
+kdba_alloc_hwbp(kdb_bp_t *bp, int *diagp)
+{
+}
+
+void kdba_free_hwbp(kdb_bp_t *bp)
+{
+}
+
+static char *kdba_rwtypes[] = { "Instruction(Register)", "Data Write",
+			"I/O", "Data Access"};
+
+char *kdba_bptype(kdbhard_bp_t *bph)
+{
+	char *mode;
+
+	mode = kdba_rwtypes[bph->bph_mode];
+
+	return mode;
+}
+
+void
+kdba_printbp(kdb_bp_t *bp)
+{
+	kdb_printf("\n    is enabled");
+}
+
+int
+kdba_parsebp(int argc, const char **argv, int *nextargp, kdb_bp_t *bp)
+{
+	int nextarg = *nextargp;
+	int diag;
+	kdbhard_bp_t *bph = &bp->bp_template;
+
+	bph->bph_mode = 0;		/* Default to instruction breakpoint */
+	bph->bph_length = 0;		/* Length must be zero for insn bp */
+	if ((argc + 1) != nextarg) {
+		if (strnicmp(argv[nextarg], "datar", sizeof("datar")) == 0)
+			bph->bph_mode = 3;
+		else if (strnicmp(argv[nextarg], "dataw", sizeof("dataw")) == 0)
+			bph->bph_mode = 1;
+		else if (strnicmp(argv[nextarg], "io", sizeof("io")) == 0)
+			bph->bph_mode = 2;
+		else if (strnicmp(argv[nextarg], "inst", sizeof("inst")) == 0)
+			bph->bph_mode = 0;
+		else
+			return KDB_ARGCOUNT;
+
+		bph->bph_length = 3;	/* Default to 4 byte */
+
+		nextarg++;
+
+		if ((argc + 1) != nextarg) {
+			unsigned long len;
+
+			diag = kdbgetularg((char *)argv[nextarg],
+					   &len);
+			if (diag)
+				return diag;
+
+
+			if ((len > 4) || (len == 3))
+				return KDB_BADLENGTH;
+
+			bph->bph_length = len;
+			bph->bph_length--; /* Normalize for debug register */
+			nextarg++;
+		}
+
+		if ((argc + 1) != nextarg)
+			return KDB_ARGCOUNT;
+
+		/*
+		 * Indicate to architecture independent level that
+		 * a hardware register assignment is required to enable
+		 * this breakpoint.
+		 */
+
+		bph->bph_free = 0;
+	} else {
+		if (KDB_DEBUG(BP))
+			kdb_printf("kdba_bp: no args, forcehw is %d\n",
+				   bp->bp_forcehw);
+		if (bp->bp_forcehw) {
+			/*
+			 * We are forced to use a hardware register for this
+			 * breakpoint because either the bph or bpha
+			 * commands were used to establish this breakpoint.
+			 */
+			bph->bph_free = 0;
+		} else {
+			/*
+			 * Indicate to architecture dependent level that
+			 * the instruction replacement breakpoint technique
+			 * should be used for this breakpoint.
+			 */
+			bph->bph_free = 1;
+			bp->bp_adjust = 1; /* software, int 3 is one byte */
+		}
+	}
+
+	if (bph->bph_mode != 2 &&
+	    kdba_verify_rw(bp->bp_addr, bph->bph_length+1)) {
+		kdb_printf("Invalid address for breakpoint, "
+			   "ignoring bp command\n");
+		return KDB_BADADDR;
+	}
+
+	*nextargp = nextarg;
+	return 0;
+}
+
+int
+kdba_removebp(kdb_bp_t *bp)
+{
+	int ret = 1;
+	if (!bp->bp_hardtype) {
+		if (bp->bp_installed) {
+			ret = kgdb_remove_sw_break(bp->bp_addr);
+			if (ret == 0)
+				bp->bp_installed = 0;
+		}
+	}
+	return ret;
+}
+
+static void
+kdba_handle_bp(struct pt_regs *regs, kdb_bp_t *bp)
+{
+	if (KDB_NULL_REGS(regs))
+		return;
+
+	if (KDB_DEBUG(BP))
+		kdb_printf("regs->ip = 0x%lx\n", instruction_pointer(regs));
+
+	/*
+	 * Setup single step
+	 */
+	kdba_setsinglestep(regs);
+
+	/*
+	 * Reset delay attribute
+	 */
+	bp->bp_delay = 0;
+	bp->bp_delayed = 1;
+}
+
+int
+kdba_installbp(struct pt_regs *regs, kdb_bp_t *bp)
+{
+	/*
+	 * Install the breakpoint, if it is not already installed.
+	 */
+
+	if (KDB_DEBUG(BP))
+		kdb_printf("kdba_installbp bp_installed %d\n",
+			   bp->bp_installed);
+	if (!KDB_STATE(SSBPT))
+		bp->bp_delay = 0;
+
+	if (!bp->bp_hardtype && !bp->bp_installed) {
+		if (bp->bp_delay || (bp->bp_delayed && KDB_STATE(DOING_SS))) {
+			if (KDB_DEBUG(BP))
+				kdb_printf("kdba_installbp delayed bp\n");
+			kdba_handle_bp(regs, bp);
+		} else {
+			if (kgdb_set_sw_break(bp->bp_addr) == 0) {
+				bp->bp_installed = 1;
+			} else {
+				kdb_printf("kdba_installbp failed to set "
+					   "software breakpoint at 0x%lx\n",
+					   bp->bp_addr);
+				return 1;
+			}
+		}
+		return 0;
+	}
+	return 1;
+}
+int
+kdba_verify_rw(unsigned long addr, size_t size)
+{
+	unsigned char data[size];
+	return kdb_getarea_size(data, addr, size) ||
+	       kdb_putarea_size(addr, data, size);
+}
+
+/* END HACK HACK HACK */
+
+/*
+ *	Predicate to test whether a breakpoint should be installed
+ *	on this CPU.
+ *
+ *	Note that for purposes of installation, hardware breakpoints
+ *	are treated as local (even if the global flag is set), on
+ *	the assumption that the require per-cpu registers to be set.
+ */
+
+static inline int kdb_is_installable_global_bp(const kdb_bp_t *bp)
+{
+	return bp->bp_enabled &&
+		bp->bp_global &&
+		!bp->bp_forcehw;
+}
+
+static int kdb_is_installable_local_bp(const kdb_bp_t *bp)
+{
+	if (!bp->bp_enabled)
+		return 0;
+
+	if (bp->bp_forcehw) {
+		if (bp->bp_cpu == smp_processor_id() || bp->bp_global)
+			return 1;
+	} else {
+		if (bp->bp_cpu == smp_processor_id() && !bp->bp_global)
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * kdb_bp_install_global
+ *
+ *	Install global kdb_breakpoints prior to returning from the
+ *	kernel debugger.  This allows the kdb_breakpoints to be set
+ *	upon functions that are used internally by kdb, such as
+ *	printk().
+ *
+ * Parameters:
+ *	regs	Execution frame.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ *
+ *	This function is only called once per kdb session.
+ */
+
+void
+kdb_bp_install_global(struct pt_regs *regs)
+{
+	int i;
+
+	for (i = 0; i < KDB_MAXBPT; i++) {
+		kdb_bp_t *bp = &kdb_breakpoints[i];
+
+		if (KDB_DEBUG(BP)) {
+			kdb_printf("kdb_bp_install_global bp %d "
+				   "bp_enabled %d bp_global %d\n",
+				i, bp->bp_enabled, bp->bp_global);
+		}
+		/* HW BP local or global are installed in kdb_bp_install_local*/
+		if (kdb_is_installable_global_bp(bp))
+			kdba_installbp(regs, bp);
+	}
+}
+
+/*
+ * kdb_bp_install_local
+ *
+ *	Install local kdb_breakpoints prior to returning from the
+ *	kernel debugger.  This allows the kdb_breakpoints to be set
+ *	upon functions that are used internally by kdb, such as
+ *	printk().
+ *
+ * Parameters:
+ *	regs	Execution frame.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ *
+ *	This function is called once per processor.
+ */
+
+void
+kdb_bp_install_local(struct pt_regs *regs)
+{
+	int i;
+
+	for (i = 0; i < KDB_MAXBPT; i++) {
+		kdb_bp_t *bp = &kdb_breakpoints[i];
+
+		if (KDB_DEBUG(BP)) {
+			kdb_printf("kdb_bp_install_local bp %d bp_enabled "
+				   "%d bp_global %d cpu %d bp_cpu %d\n",
+				i, bp->bp_enabled, bp->bp_global,
+				smp_processor_id(), bp->bp_cpu);
+		}
+		if (kdb_is_installable_local_bp(bp))
+			kdba_installbp(regs, bp);
+	}
+}
+
+/*
+ * kdb_bp_remove_global
+ *
+ * 	Remove global kdb_breakpoints upon entry to the kernel debugger.
+ *
+ * Parameters:
+ *	None.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ */
+
+void
+kdb_bp_remove_global(void)
+{
+	int i;
+
+	for (i = KDB_MAXBPT - 1; i >= 0; i--) {
+		kdb_bp_t *bp = &kdb_breakpoints[i];
+
+		if (KDB_DEBUG(BP)) {
+			kdb_printf("kdb_bp_remove_global bp %d bp_enabled "
+				   "%d bp_global %d\n",
+				   i, bp->bp_enabled, bp->bp_global);
+		}
+		if (kdb_is_installable_global_bp(bp))
+			kdba_removebp(bp);
+	}
+}
+
+
+/*
+ * kdb_bp_remove_local
+ *
+ * 	Remove local kdb_breakpoints upon entry to the kernel debugger.
+ *
+ * Parameters:
+ *	None.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ */
+
+void
+kdb_bp_remove_local(void)
+{
+	int i;
+
+	for (i = KDB_MAXBPT - 1; i >= 0; i--) {
+		kdb_bp_t *bp = &kdb_breakpoints[i];
+
+		if (KDB_DEBUG(BP)) {
+			kdb_printf("kdb_bp_remove_local bp %d bp_enabled "
+				   "%d bp_global %d cpu %d bp_cpu %d\n",
+				i, bp->bp_enabled, bp->bp_global,
+				smp_processor_id(), bp->bp_cpu);
+		}
+		if (kdb_is_installable_local_bp(bp))
+			kdba_removebp(bp);
+	}
+}
+
+/*
+ * kdb_printbp
+ *
+ * 	Internal function to format and print a breakpoint entry.
+ *
+ * Parameters:
+ *	None.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ */
+
+static void
+kdb_printbp(kdb_bp_t *bp, int i)
+{
+	if (bp->bp_forcehw)
+		kdb_printf("Forced ");
+
+	if (!bp->bp_template.bph_free)
+		kdb_printf("%s ", kdba_bptype(&bp->bp_template));
+	else
+		kdb_printf("Instruction(i) ");
+
+	kdb_printf("BP #%d at ", i);
+	kdb_symbol_print(bp->bp_addr, NULL, KDB_SP_DEFAULT);
+
+	if (bp->bp_enabled) {
+		kdba_printbp(bp);
+		if (bp->bp_global)
+			kdb_printf(" globally");
+		else
+			kdb_printf(" on cpu %d", bp->bp_cpu);
+		if (bp->bp_adjust)
+			kdb_printf(" adjust %d", bp->bp_adjust);
+	} else {
+		kdb_printf("\n    is disabled");
+	}
+
+	kdb_printf("\taddr at %016lx, hardtype=%d, forcehw=%d, "
+		   "installed=%d, hard=%p\n",
+		bp->bp_addr, bp->bp_hardtype, bp->bp_forcehw,
+		bp->bp_installed, bp->bp_hard);
+
+	kdb_printf("\n");
+}
+
+/*
+ * kdb_bp
+ *
+ * 	Handle the bp, and bpa commands.
+ *
+ *	[bp|bpa|bph] <addr-expression> [DATAR|DATAW|IO [length]]
+ *
+ * Parameters:
+ *	argc	Count of arguments in argv
+ *	argv	Space delimited command line arguments
+ * Outputs:
+ *	None.
+ * Returns:
+ *	Zero for success, a kdb diagnostic if failure.
+ * Locking:
+ *	None.
+ * Remarks:
+ *
+ * 	bp	Set breakpoint.  Only use hardware assist if necessary.
+ *	bpa	Set breakpoint on all cpus, only use hardware regs if necessary
+ *	bph	Set breakpoint - force hardware register
+ *	bpha	Set breakpoint on all cpus, force hardware register
+ */
+
+static int
+kdb_bp(int argc, const char **argv)
+{
+	int i, bpno;
+	kdb_bp_t *bp, *bp_check;
+	int diag;
+	int free;
+	char *symname = NULL;
+	long offset = 0ul;
+	int nextarg;
+	kdb_bp_t template = {0};
+
+	if (argc == 0) {
+		/*
+		 * Display breakpoint table
+		 */
+		for (bpno = 0, bp = kdb_breakpoints; bpno < KDB_MAXBPT;
+		     bpno++, bp++) {
+			if (bp->bp_free)
+				continue;
+			kdb_printbp(bp, bpno);
+		}
+
+		return 0;
+	}
+
+	template.bp_global = ((strcmp(argv[0], "bpa") == 0)
+			   || (strcmp(argv[0], "bpha") == 0));
+	template.bp_forcehw = ((strcmp(argv[0], "bph") == 0)
+			   || (strcmp(argv[0], "bpha") == 0));
+
+	/* Fix me: "bp" is treated as "bpa" to avoid system freeze. -jlan */
+	if (strcmp(argv[0], "bp") == 0)
+		template.bp_global = 1;
+
+	nextarg = 1;
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &template.bp_addr,
+			     &offset, &symname);
+	if (diag)
+		return diag;
+	if (!template.bp_addr)
+		return KDB_BADINT;
+
+	/*
+	 * Find an empty bp structure, to allocate
+	 */
+	free = KDB_MAXBPT;
+	for (bpno = 0, bp = kdb_breakpoints; bpno < KDB_MAXBPT; bpno++, bp++) {
+		if (bp->bp_free)
+			break;
+	}
+
+	if (bpno == KDB_MAXBPT)
+		return KDB_TOOMANYBPT;
+
+	/*
+	 * Handle architecture dependent parsing
+	 */
+	diag = kdba_parsebp(argc, argv, &nextarg, &template);
+	if (diag)
+		return diag;
+
+	/*
+	 * Check for clashing breakpoints.
+	 *
+	 * Note, in this design we can't have hardware breakpoints
+	 * enabled for both read and write on the same address, even
+	 * though ia64 allows this.
+	 */
+	for (i = 0, bp_check = kdb_breakpoints; i < KDB_MAXBPT;
+	     i++, bp_check++) {
+		if (!bp_check->bp_free &&
+		    bp_check->bp_addr == template.bp_addr &&
+		    (bp_check->bp_global ||
+		     bp_check->bp_cpu == template.bp_cpu)) {
+			kdb_printf("You already have a breakpoint at "
+				   kdb_bfd_vma_fmt0 "\n", template.bp_addr);
+			return KDB_DUPBPT;
+		}
+	}
+
+	template.bp_enabled = 1;
+
+	/*
+	 * Actually allocate the breakpoint found earlier
+	 */
+	*bp = template;
+	bp->bp_free = 0;
+
+	if (!bp->bp_global)
+		bp->bp_cpu = smp_processor_id();
+
+	/*
+	 * Allocate a hardware breakpoint.  If one is not available,
+	 * disable the breakpoint, but leave it in the breakpoint
+	 * table.  When the breakpoint is re-enabled (via 'be'), we'll
+	 * attempt to allocate a hardware register for it.
+	 */
+	if (!bp->bp_template.bph_free) {
+		kdba_alloc_hwbp(bp, &diag);
+		if (diag) {
+			bp->bp_enabled = 0;
+			bp->bp_hardtype = 0;
+			kdba_free_hwbp(bp);
+			return diag;
+		}
+	}
+
+	kdb_printbp(bp, bpno);
+
+	return 0;
+}
+
+/*
+ * kdb_bc
+ *
+ * 	Handles the 'bc', 'be', and 'bd' commands
+ *
+ *	[bd|bc|be] <breakpoint-number>
+ *	[bd|bc|be] *
+ *
+ * Parameters:
+ *	argc	Count of arguments in argv
+ *	argv	Space delimited command line arguments
+ * Outputs:
+ *	None.
+ * Returns:
+ *	Zero for success, a kdb diagnostic for failure
+ * Locking:
+ *	None.
+ * Remarks:
+ */
+
+#define KDBCMD_BC	0
+#define KDBCMD_BE	1
+#define KDBCMD_BD	2
+
+static int
+kdb_bc(int argc, const char **argv)
+{
+	kdb_machreg_t addr;
+	kdb_bp_t *bp = NULL;
+	int lowbp = KDB_MAXBPT;
+	int highbp = 0;
+	int done = 0;
+	int i;
+	int diag = 0;
+	int cmd;			/* KDBCMD_B? */
+
+	if (strcmp(argv[0], "be") == 0)
+		cmd = KDBCMD_BE;
+	else if (strcmp(argv[0], "bd") == 0)
+		cmd = KDBCMD_BD;
+	else
+		cmd = KDBCMD_BC;
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+
+	if (strcmp(argv[1], "*") == 0) {
+		lowbp = 0;
+		highbp = KDB_MAXBPT;
+	} else {
+		diag = kdbgetularg(argv[1], &addr);
+		if (diag)
+			return diag;
+
+		/*
+		 * For addresses less than the maximum breakpoint number,
+		 * assume that the breakpoint number is desired.
+		 */
+		if (addr < KDB_MAXBPT) {
+			bp = &kdb_breakpoints[addr];
+			lowbp = highbp = addr;
+			highbp++;
+		} else {
+			for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT;
+			    i++, bp++) {
+				if (bp->bp_addr == addr) {
+					lowbp = highbp = i;
+					highbp++;
+					break;
+				}
+			}
+		}
+	}
+
+	/*
+	 * Now operate on the set of breakpoints matching the input
+	 * criteria (either '*' for all, or an individual breakpoint).
+	 */
+	for (bp = &kdb_breakpoints[lowbp], i = lowbp;
+	    i < highbp;
+	    i++, bp++) {
+		if (bp->bp_free)
+			continue;
+
+		done++;
+
+		switch (cmd) {
+		case KDBCMD_BC:
+			if (bp->bp_hardtype)
+				kdba_free_hwbp(bp);
+
+			bp->bp_enabled = 0;
+			bp->bp_global = 0;
+
+			kdb_printf("Breakpoint %d at "
+				   kdb_bfd_vma_fmt " cleared\n",
+				   i, bp->bp_addr);
+
+			bp->bp_addr = 0;
+			bp->bp_free = 1;
+
+			break;
+		case KDBCMD_BE:
+			/*
+			 * Allocate a hardware breakpoint.  If one is not
+			 * available, don't enable the breakpoint.
+			 */
+			if (!bp->bp_template.bph_free
+			 && !bp->bp_hardtype) {
+				kdba_alloc_hwbp(bp, &diag);
+				if (diag) {
+					bp->bp_enabled = 0;
+					bp->bp_hardtype = 0;
+					kdba_free_hwbp(bp);
+					return diag;
+				}
+			}
+
+			bp->bp_enabled = 1;
+
+			kdb_printf("Breakpoint %d at "
+				   kdb_bfd_vma_fmt " enabled",
+				   i, bp->bp_addr);
+
+			kdb_printf("\n");
+			break;
+		case KDBCMD_BD:
+			if (!bp->bp_enabled)
+				break;
+
+			/*
+			 * Since this breakpoint is now disabled, we can
+			 * give up the hardware register which is allocated
+			 * to it.
+			 */
+			if (bp->bp_hardtype)
+				kdba_free_hwbp(bp);
+
+			bp->bp_enabled = 0;
+
+			kdb_printf("Breakpoint %d at "
+				   kdb_bfd_vma_fmt " disabled\n",
+				   i, bp->bp_addr);
+
+			break;
+		}
+		if (bp->bp_delay && (cmd == KDBCMD_BC || cmd == KDBCMD_BD)) {
+			bp->bp_delay = 0;
+			KDB_STATE_CLEAR(SSBPT);
+		}
+	}
+
+	return (!done) ? KDB_BPTNOTFOUND : 0;
+}
+
+/*
+ * kdb_ss
+ *
+ *	Process the 'ss' (Single Step) and 'ssb' (Single Step to Branch)
+ *	commands.
+ *
+ *	ss
+ *	ssb
+ *
+ * Parameters:
+ *	argc	Argument count
+ *	argv	Argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	KDB_CMD_SS[B] for success, a kdb error if failure.
+ * Locking:
+ *	None.
+ * Remarks:
+ *
+ *	Set the arch specific option to trigger a debug trap after the next
+ *	instruction.
+ *
+ *	For 'ssb', set the trace flag in the debug trap handler
+ *	after printing the current insn and return directly without
+ *	invoking the kdb command processor, until a branch instruction
+ *	is encountered.
+ */
+
+static int
+kdb_ss(int argc, const char **argv)
+{
+	int ssb = 0;
+	// HACK HACK HACK no need to exec the get_irq_regs() with kgdb
+	//	struct pt_regs *regs = get_irq_regs();
+
+	ssb = (strcmp(argv[0], "ssb") == 0);
+	if (argc != 0)
+		return KDB_ARGCOUNT;
+
+	//	if (!regs) {
+	//		kdb_printf("%s: pt_regs not available\n", __FUNCTION__);
+	//		return KDB_BADREG;
+	//	}
+
+	/*
+	 * Set trace flag and go.
+	 */
+	KDB_STATE_SET(DOING_SS);
+	if (ssb)
+		KDB_STATE_SET(DOING_SSB);
+
+	//	kdba_setsinglestep(regs);		/* Enable single step */
+
+	if (ssb)
+		return KDB_CMD_SSB;
+	return KDB_CMD_SS;
+}
+
+/*
+ * kdb_initbptab
+ *
+ *	Initialize the breakpoint table.  Register breakpoint commands.
+ *
+ * Parameters:
+ *	None.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ */
+
+void __init
+kdb_initbptab(void)
+{
+	int i;
+	kdb_bp_t *bp;
+
+	/*
+	 * First time initialization.
+	 */
+	memset(&kdb_breakpoints, '\0', sizeof(kdb_breakpoints));
+
+	for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++) {
+		bp->bp_free = 1;
+		/*
+		 * The bph_free flag is architecturally required.  It
+		 * is set by architecture-dependent code to false (zero)
+		 * in the event a hardware breakpoint register is required
+		 * for this breakpoint.
+		 *
+		 * The rest of the template is reserved to the architecture
+		 * dependent code and _must_ not be touched by the architecture
+		 * independent code.
+		 */
+		bp->bp_template.bph_free = 1;
+	}
+
+	kdb_register_repeat("bp", kdb_bp, "[<vaddr>]", "Set/Display breakpoints", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("bl", kdb_bp, "[<vaddr>]", "Display breakpoints", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("bpa", kdb_bp, "[<vaddr>]", "Set/Display global breakpoints", 0, KDB_REPEAT_NO_ARGS);
+#if 0 /* temporarily not supported */
+	kdb_register_repeat("bph", kdb_bp, "[<vaddr>]", "Set hardware breakpoint", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("bpha", kdb_bp, "[<vaddr>]", "Set global hardware breakpoint", 0, KDB_REPEAT_NO_ARGS);
+#endif
+	kdb_register_repeat("bc", kdb_bc, "<bpnum>",   "Clear Breakpoint", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("be", kdb_bc, "<bpnum>",   "Enable Breakpoint", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("bd", kdb_bc, "<bpnum>",   "Disable Breakpoint", 0, KDB_REPEAT_NONE);
+
+	kdb_register_repeat("ss", kdb_ss, "", "Single Step", 1, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("ssb", kdb_ss, "", "Single step to branch/call", 0, KDB_REPEAT_NO_ARGS);
+	/*
+	 * Architecture dependent initialization.
+	 */
+}
diff --git a/kdb/kdb_bt.c b/kdb/kdb_bt.c
new file mode 100644
index 0000000..80d9665
--- /dev/null
+++ b/kdb/kdb_bt.c
@@ -0,0 +1,209 @@
+/*
+ * Kernel Debugger Architecture Independent Stack Traceback
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 1999-2004 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+#include <linux/ctype.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+#include <linux/nmi.h>
+#include <asm/system.h>
+
+
+/*
+ * kdb_bt
+ *
+ *	This function implements the 'bt' command.  Print a stack
+ *	traceback.
+ *
+ *	bt [<address-expression>]	(addr-exp is for alternate stacks)
+ *	btp <pid>			Kernel stack for <pid>
+ *	btt <address-expression>	Kernel stack for task structure at
+ *					<address-expression>
+ *	bta [DRSTCZEUIMA]		All useful processes, optionally
+ *					filtered by state
+ *	btc [<cpu>]			The current process on one cpu,
+ *					default is all cpus
+ *
+ *	bt <address-expression> refers to a address on the stack, that location
+ *	is assumed to contain a return address.
+ *
+ *	btt <address-expression> refers to the address of a struct task.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	Backtrack works best when the code uses frame pointers.  But even
+ *	without frame pointers we should get a reasonable trace.
+ *
+ *	mds comes in handy when examining the stack to do a manual traceback or
+ *	to get a starting point for bt <address-expression>.
+ */
+
+static int
+kdb_bt1(const struct task_struct *p, unsigned long mask,
+	int argcount, int btaprompt)
+{
+	//	int diag;
+	char buffer[2];
+	if (kdb_getarea(buffer[0], (unsigned long)p) ||
+	    kdb_getarea(buffer[0], (unsigned long)(p+1)-1))
+		return KDB_BADADDR;
+	if (!kdb_task_state(p, mask))
+		return 0;
+	kdb_printf("Stack traceback for pid %d\n", p->pid);
+	kdb_ps1(p);
+	//diag = kdba_bt_process(p, argcount);
+	{
+		int old_lvl = console_loglevel;
+		console_loglevel = 15;
+		kdba_set_current_task(p);
+		if (kdb_current_regs) {
+			// HACK HACK HACK below, this needs to be fixed to be
+			// architecture independent
+			// But this is a poof of concept for now...
+#ifdef CONFIG_X86
+			show_stack((struct task_struct *)p,
+				   &kdb_current_regs->sp);
+#else
+			show_stack((struct task_struct *)p, 0);
+#endif
+		} else {
+			show_stack((struct task_struct *)p, 0);
+		}
+		console_loglevel = old_lvl;
+	}
+	// HACK HACK HACK
+	if (btaprompt) {
+		kdb_getstr(buffer, sizeof(buffer),
+			   "Enter <q> to end, <cr> to continue:");
+		if (buffer[0] == 'q') {
+			kdb_printf("\n");
+			return 1;
+		}
+	}
+	touch_nmi_watchdog();
+	return 0;
+}
+
+int
+kdb_bt(int argc, const char **argv)
+{
+	int diag;
+	int argcount = 5;
+	int btaprompt = 1;
+	int nextarg;
+	unsigned long addr;
+	long offset;
+
+	kdbgetintenv("BTARGS", &argcount);	/* Arguments to print */
+	kdbgetintenv("BTAPROMPT", &btaprompt);	/* Prompt after each
+						 * proc in bta */
+
+	if (strcmp(argv[0], "bta") == 0) {
+		struct task_struct *g, *p;
+		unsigned long cpu;
+		unsigned long mask = kdb_task_state_string(argc ? argv[1] :
+							   NULL);
+		if (argc == 0)
+			kdb_ps_suppressed();
+		/* Run the active tasks first */
+		for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+			if (!cpu_online(cpu))
+				continue;
+			p = kdb_curr_task(cpu);
+			if (kdb_bt1(p, mask, argcount, btaprompt))
+				return 0;
+		}
+		/* Now the inactive tasks */
+		kdb_do_each_thread(g, p) {
+			if (task_curr(p))
+				continue;
+			if (kdb_bt1(p, mask, argcount, btaprompt))
+				return 0;
+		} kdb_while_each_thread(g, p);
+	} else if (strcmp(argv[0], "btp") == 0) {
+		struct task_struct *p;
+		unsigned long pid;
+		if (argc != 1)
+			return KDB_ARGCOUNT;
+		if ((diag = kdbgetularg((char *)argv[1], &pid)))
+			return diag;
+		if ((p = find_task_by_pid_type_ns(PIDTYPE_PID, pid, &init_pid_ns))) {
+			kdba_set_current_task(p);
+			return kdb_bt1(p, ~0UL, argcount, 0);
+		}
+		kdb_printf("No process with pid == %ld found\n", pid);
+		return 0;
+	} else if (strcmp(argv[0], "btt") == 0) {
+		if (argc != 1)
+			return KDB_ARGCOUNT;
+		if ((diag = kdbgetularg((char *)argv[1], &addr)))
+			return diag;
+		kdba_set_current_task((struct task_struct *)addr);
+		return kdb_bt1((struct task_struct *)addr, ~0UL, argcount, 0);
+	} else if (strcmp(argv[0], "btc") == 0) {
+		unsigned long cpu = ~0;
+		struct kdb_running_process *krp;
+		const struct task_struct *save_current_task = kdb_current_task;
+		char buf[80];
+		if (argc > 1)
+			return KDB_ARGCOUNT;
+		if (argc == 1 && (diag = kdbgetularg((char *)argv[1], &cpu)))
+			return diag;
+		/* Recursive use of kdb_parse, do not use argv after this point */
+		argv = NULL;
+		if (cpu != ~0) {
+			krp = kdb_running_process + cpu;
+			if (cpu >= NR_CPUS || !krp->seqno || !cpu_online(cpu)) {
+				kdb_printf("no process for cpu %ld\n", cpu);
+				return 0;
+			}
+			sprintf(buf, "btt 0x%p\n", krp->p);
+			kdb_parse(buf);
+			return 0;
+		}
+		kdb_printf("btc: cpu status: ");
+		kdb_parse("cpu\n");
+		for (cpu = 0, krp = kdb_running_process; cpu < NR_CPUS; ++cpu, ++krp) {
+			if (!cpu_online(cpu) || !krp->seqno)
+				continue;
+			sprintf(buf, "btt 0x%p\n", krp->p);
+			kdb_parse(buf);
+			touch_nmi_watchdog();
+		}
+		kdba_set_current_task(save_current_task);
+		return 0;
+	} else {
+		if (argc) {
+			nextarg = 1;
+			diag = kdbgetaddrarg(argc, argv, &nextarg, &addr,
+					     &offset, NULL);
+			if (diag)
+				return diag;
+			// return kdba_bt_address(addr, argcount);
+			// HACK HACK HACK
+			return 0;
+		} else {
+			return kdb_bt1(kdb_current_task, ~0UL, argcount, 0);
+		}
+	}
+
+	/* NOTREACHED */
+	return 0;
+}
diff --git a/kdb/kdb_cmds b/kdb/kdb_cmds
new file mode 100644
index 0000000..343955c
--- /dev/null
+++ b/kdb/kdb_cmds
@@ -0,0 +1,32 @@
+# Initial commands for kdb, alter to suit your needs.
+# These commands are executed in kdb_init() context, no SMP, no
+# processes.  Commands that require process data (including stack or
+# registers) are not reliable this early.  set and bp commands should
+# be safe.  Global breakpoint commands affect each cpu as it is booted.
+
+# Standard debugging information for first level support, just type archkdb
+# or archkdbcpu or archkdbshort at the kdb prompt.
+
+defcmd archkdb "" "First line arch debugging"
+  set BTSYMARG 1
+  set BTARGS 9
+  pid R
+  -archkdbcommon
+  -bta
+endefcmd
+
+defcmd archkdbcpu "" "archkdb with only tasks on cpus"
+  set BTSYMARG 1
+  set BTARGS 9
+  pid R
+  -archkdbcommon
+  -btc
+endefcmd
+
+defcmd archkdbshort "" "archkdb with less detailed backtrace"
+  set BTSYMARG 0
+  set BTARGS 0
+  pid R
+  -archkdbcommon
+  -bta
+endefcmd
diff --git a/kdb/kdb_io.c b/kdb/kdb_io.c
new file mode 100644
index 0000000..e7c3b40
--- /dev/null
+++ b/kdb/kdb_io.c
@@ -0,0 +1,890 @@
+/*
+ * Kernel Debugger Architecture Independent Console I/O handler
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 1999-2006 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/kdev_t.h>
+#include <linux/console.h>
+#include <linux/string.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/nmi.h>
+#include <linux/delay.h>
+
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+#include <linux/kallsyms.h>
+
+static struct console *kdbcons;
+
+#ifdef CONFIG_PPC64
+#include <asm/udbg.h>
+#endif
+
+#define CMD_BUFLEN 256
+char kdb_prompt_str[CMD_BUFLEN];
+
+extern int kdb_grepping_flag;
+extern char kdb_grep_string[];
+extern int kdb_grep_leading;
+extern int kdb_grep_trailing;
+extern int kdb_get_kbd_char(void);
+
+/*
+ * kdb_read
+ *
+ *	This function reads a string of characters, terminated by
+ *	a newline, or by reaching the end of the supplied buffer,
+ *	from the current kernel debugger console device.
+ * Parameters:
+ *	buffer	- Address of character buffer to receive input characters.
+ *	bufsize - size, in bytes, of the character buffer
+ * Returns:
+ *	Returns a pointer to the buffer containing the received
+ *	character string.  This string will be terminated by a
+ *	newline character.
+ * Locking:
+ *	No locks are required to be held upon entry to this
+ *	function.  It is not reentrant - it relies on the fact
+ *	that while kdb is running on any one processor all other
+ *	processors will be spinning at the kdb barrier.
+ * Remarks:
+ *
+ * Davidm asks, why doesn't kdb use the console abstraction;
+ * here are some reasons:
+ *      - you cannot debug the console abstraction with kdb if
+ *	  kdb uses it.
+ *      - you rely on the correct functioning of the abstraction
+ *	  in the presence of general system failures.
+ *      - You must acquire the console spinlock thus restricting
+ *	  the usability - what if the kernel fails with the spinlock
+ *	  held - one still wishes to debug such situations.
+ *      - How about debugging before the console(s) are registered?
+ *      - None of the current consoles (sercons, vt_console_driver)
+ *	  have read functions defined.
+ *	- The standard pc keyboard and terminal drivers are interrupt
+ *	  driven.   We cannot enable interrupts while kdb is active,
+ *	  so the standard input functions cannot be used by kdb.
+ *
+ * An implementation could be improved by removing the need for
+ * lock acquisition - just keep a 'struct console *kdbconsole;' global
+ * variable which refers to the preferred kdb console.
+ *
+ * The bulk of this function is architecture dependent.
+ *
+ * The buffer size must be >= 2.  A buffer size of 2 means that the caller only
+ * wants a single key.
+ *
+ * An escape key could be the start of a vt100 control sequence such as \e[D
+ * (left arrow) or it could be a character in its own right.  The standard
+ * method for detecting the difference is to wait for 2 seconds to see if there
+ * are any other characters.  kdb is complicated by the lack of a timer service
+ * (interrupts are off), by multiple input sources and by the need to sometimes
+ * return after just one key.  Escape sequence processing has to be done as
+ * states in the polling loop.
+ */
+
+char *
+kdb_read(char *buffer, size_t bufsize)
+{
+	char *cp = buffer;
+	char *bufend = buffer+bufsize-2;	/* Reserve space for newline
+						 * and null byte */
+	char *lastchar;
+	char *p_tmp;
+	char tmp;
+	static char tmpbuffer[CMD_BUFLEN];
+	int len = strlen(buffer);
+	int len_tmp;
+	int tab = 0;
+	int count;
+	int i;
+	int diag, dtab_count;
+
+#define ESCAPE_UDELAY 1000
+#define ESCAPE_DELAY 2*1000000/ESCAPE_UDELAY	/* 2 seconds worth of udelays */
+	char escape_data[5];	/* longest vt100 escape sequence is 4 bytes */
+	char *ped = escape_data;
+	int escape_delay = 0;
+	get_char_func *f, *f_escape = NULL;
+
+	diag = kdbgetintenv("DTABCOUNT", &dtab_count);
+	if (diag)
+		dtab_count = 30;
+
+	if (len > 0) {
+		cp += len;
+		if (*(buffer+len-1) == '\n')
+			cp--;
+	}
+
+	lastchar = cp;
+	*cp = '\0';
+	kdb_printf("%s", buffer);
+
+	for (;;) {
+		int key;
+		for (f = &kdb_poll_funcs[0]; ; ++f) {
+			if (*f == NULL) {
+				/* Reset NMI watchdog once per poll loop */
+				touch_nmi_watchdog();
+				f = &kdb_poll_funcs[0];
+			}
+			if (escape_delay == 2) {
+				*ped = '\0';
+				ped = escape_data;
+				--escape_delay;
+			}
+			if (escape_delay == 1) {
+				key = *ped++;
+				if (!*ped)
+					--escape_delay;
+				break;
+			}
+			key = (*f)();
+			if (key == -1) {
+				if (escape_delay) {
+					udelay(ESCAPE_UDELAY);
+					--escape_delay;
+				}
+				continue;
+			}
+			if (bufsize <= 2) {
+				if (key == '\r')
+					key = '\n';
+				kdb_printf("%c", key);
+				*buffer++ = key;
+				*buffer = '\0';
+				return buffer;
+			}
+			if (escape_delay == 0 && key == '\e') {
+				escape_delay = ESCAPE_DELAY;
+				ped = escape_data;
+				f_escape = f;
+			}
+			if (escape_delay) {
+				*ped++ = key;
+				if (f_escape != f) {
+					escape_delay = 2;
+					continue;
+				}
+				if (ped - escape_data == 1) {
+					/* \e */
+					continue;
+				} else if (ped - escape_data == 2) {
+					/* \e<something> */
+					if (key != '[')
+						escape_delay = 2;
+					continue;
+				} else if (ped - escape_data == 3) {
+					/* \e[<something> */
+					int mapkey = 0;
+					switch (key) {
+					/* \e[A, up arrow */
+					case 'A': mapkey = 16; break;
+					/* \e[B, down arrow */
+					case 'B': mapkey = 14; break;
+					/* \e[C, right arrow */
+					case 'C': mapkey = 6; break;
+					/* \e[D, left arrow */
+					case 'D': mapkey = 2; break;
+					case '1': /* dropthrough */
+					case '3': /* dropthrough */
+					/* \e[<1,3,4>], may be home, del, end */
+					case '4': mapkey = -1; break;
+					}
+					if (mapkey != -1) {
+						if (mapkey > 0) {
+							escape_data[0] = mapkey;
+							escape_data[1] = '\0';
+						}
+						escape_delay = 2;
+					}
+					continue;
+				} else if (ped - escape_data == 4) {
+					/* \e[<1,3,4><something> */
+					int mapkey = 0;
+					if (key == '~') {
+						switch (escape_data[2]) {
+						/* \e[1~, home */
+						case '1': mapkey = 1; break;
+						/* \e[3~, del */
+						case '3': mapkey = 4; break;
+						/* \e[4~, end */
+						case '4': mapkey = 5; break;
+						}
+					}
+					if (mapkey > 0) {
+						escape_data[0] = mapkey;
+						escape_data[1] = '\0';
+					}
+					escape_delay = 2;
+					continue;
+				}
+			}
+			break;	/* A key to process */
+		}
+
+		if (key != 9)
+			tab = 0;
+		switch (key) {
+		case 8: /* backspace */
+			if (cp > buffer) {
+				if (cp < lastchar) {
+					memcpy(tmpbuffer, cp, lastchar - cp);
+					memcpy(cp-1, tmpbuffer, lastchar - cp);
+				}
+				*(--lastchar) = '\0';
+				--cp;
+				kdb_printf("\b%s \r", cp);
+				tmp = *cp;
+				*cp = '\0';
+				kdb_printf(kdb_prompt_str);
+				kdb_printf("%s", buffer);
+				*cp = tmp;
+			}
+			break;
+		case 13: /* enter */
+			*lastchar++ = '\n';
+			*lastchar++ = '\0';
+			kdb_printf("\n");
+			return buffer;
+		case 4: /* Del */
+			if (cp < lastchar) {
+				memcpy(tmpbuffer, cp+1, lastchar - cp - 1);
+				memcpy(cp, tmpbuffer, lastchar - cp - 1);
+				*(--lastchar) = '\0';
+				kdb_printf("%s \r", cp);
+				tmp = *cp;
+				*cp = '\0';
+				kdb_printf(kdb_prompt_str);
+				kdb_printf("%s", buffer);
+				*cp = tmp;
+			}
+			break;
+		case 1: /* Home */
+			if (cp > buffer) {
+				kdb_printf("\r");
+				kdb_printf(kdb_prompt_str);
+				cp = buffer;
+			}
+			break;
+		case 5: /* End */
+			if (cp < lastchar) {
+				kdb_printf("%s", cp);
+				cp = lastchar;
+			}
+			break;
+		case 2: /* Left */
+			if (cp > buffer) {
+				kdb_printf("\b");
+				--cp;
+			}
+			break;
+		case 14: /* Down */
+			memset(tmpbuffer, ' ',
+			       strlen(kdb_prompt_str) + (lastchar-buffer));
+			*(tmpbuffer+strlen(kdb_prompt_str) +
+			  (lastchar-buffer)) = '\0';
+			kdb_printf("\r%s\r", tmpbuffer);
+			*lastchar = (char)key;
+			*(lastchar+1) = '\0';
+			return lastchar;
+		case 6: /* Right */
+			if (cp < lastchar) {
+				kdb_printf("%c", *cp);
+				++cp;
+			}
+			break;
+		case 16: /* Up */
+			memset(tmpbuffer, ' ',
+			       strlen(kdb_prompt_str) + (lastchar-buffer));
+			*(tmpbuffer+strlen(kdb_prompt_str) +
+			  (lastchar-buffer)) = '\0';
+			kdb_printf("\r%s\r", tmpbuffer);
+			*lastchar = (char)key;
+			*(lastchar+1) = '\0';
+			return lastchar;
+		case 9: /* Tab */
+			if (tab < 2)
+				++tab;
+			p_tmp = buffer;
+			while (*p_tmp == ' ')
+				p_tmp++;
+			if (p_tmp <= cp) {
+				memcpy(tmpbuffer, p_tmp, cp-p_tmp);
+				*(tmpbuffer + (cp-p_tmp)) = '\0';
+				p_tmp = strrchr(tmpbuffer, ' ');
+				if (p_tmp)
+					++p_tmp;
+				else
+					p_tmp = tmpbuffer;
+				len = strlen(p_tmp);
+				count = kallsyms_symbol_complete(p_tmp,
+					 sizeof(tmpbuffer) -
+						 (p_tmp - tmpbuffer));
+				if (tab == 2) {
+					if (count > 0) {
+						kdb_printf("\n%d symbols are found.", count);
+						if(count>dtab_count) {
+							count=dtab_count;
+							kdb_printf(" But only first %d symbols will be printed.\nYou can change the environment variable DTABCOUNT.", count);
+						}
+						kdb_printf("\n");
+						for(i=0;i<count;i++) {
+							if(kallsyms_symbol_next(p_tmp, i)<0)
+								break;
+							kdb_printf("%s ",p_tmp);
+							*(p_tmp+len)='\0';
+						}
+						if(i>=dtab_count)kdb_printf("...");
+						kdb_printf("\n");
+						kdb_printf(kdb_prompt_str);
+						kdb_printf("%s", buffer);
+					}
+				}
+				else {
+					if (count > 0) {
+						len_tmp = strlen(p_tmp);
+						strncpy(p_tmp+len_tmp,cp, lastchar-cp+1);
+						len_tmp = strlen(p_tmp);
+						strncpy(cp, p_tmp+len, len_tmp-len+1);
+						len = len_tmp - len;
+						kdb_printf("%s", cp);
+						cp+=len;
+						lastchar+=len;
+					}
+				}
+				kdb_nextline = 1;		/* reset output line number */
+			}
+			break;
+		default:
+			if (key >= 32 &&lastchar < bufend) {
+				if (cp < lastchar) {
+					memcpy(tmpbuffer, cp, lastchar - cp);
+					memcpy(cp+1, tmpbuffer, lastchar - cp);
+					*++lastchar = '\0';
+					*cp = key;
+					kdb_printf("%s\r", cp);
+					++cp;
+					tmp = *cp;
+					*cp = '\0';
+					kdb_printf(kdb_prompt_str);
+					kdb_printf("%s", buffer);
+					*cp = tmp;
+				} else {
+					*++lastchar = '\0';
+					*cp++ = key;
+					/* Hide printed characters if we think that kgdb is connecting */
+					if (!KDB_STATE(KGDB_TRANS)) {
+						int len = strlen(buffer);
+						if (strncmp(buffer,"$?#3f",len) != 0 &&
+						    strncmp(buffer,"$qSupported#37",len) != 0 &&
+						    strncmp(buffer,"+$qSupported#37",len) != 0) {
+							KDB_STATE_SET(KGDB_TRANS);
+							kdb_printf("%s",buffer);
+						}
+					} else {
+						kdb_printf("%c", key);
+					}
+				}
+				/* Special escape to kgdb */
+				if (lastchar - buffer >= 5 && strcmp(lastchar - 5, "$?#3f") == 0) {
+					strcpy(buffer,"kgdb");
+					KDB_STATE_SET(DOING_KGDB);
+					return buffer;
+				}
+				if (lastchar - buffer >= 14 && strcmp(lastchar - 14, "$qSupported#37") == 0) {
+					strcpy(buffer,"kgdb");
+					KDB_STATE_SET(DOING_KGDB2);
+					return buffer;
+				}
+			}
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(kdb_read);
+
+/*
+ * kdb_getstr
+ *
+ *	Print the prompt string and read a command from the
+ *	input device.
+ *
+ * Parameters:
+ *	buffer	Address of buffer to receive command
+ *	bufsize Size of buffer in bytes
+ *	prompt	Pointer to string to use as prompt string
+ * Returns:
+ *	Pointer to command buffer.
+ * Locking:
+ *	None.
+ * Remarks:
+ *	For SMP kernels, the processor number will be
+ *	substituted for %d, %x or %o in the prompt.
+ */
+
+char *
+kdb_getstr(char *buffer, size_t bufsize, char *prompt)
+{
+	if(prompt && kdb_prompt_str!=prompt)
+		strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
+	kdb_printf(kdb_prompt_str);
+	kdb_nextline = 1;	/* Prompt and input resets line number */
+	return kdb_read(buffer, bufsize);
+}
+
+/*
+ * kdb_input_flush
+ *
+ *	Get rid of any buffered console input.
+ *
+ * Parameters:
+ *	none
+ * Returns:
+ *	nothing
+ * Locking:
+ *	none
+ * Remarks:
+ *	Call this function whenever you want to flush input.  If there is any
+ *	outstanding input, it ignores all characters until there has been no
+ *	data for approximately half a second.
+ */
+
+#define FLUSH_UDELAY 100
+#define FLUSH_DELAY 500000/FLUSH_UDELAY	/* 0.5 seconds worth of udelays */
+
+static void
+kdb_input_flush(void)
+{
+	get_char_func *f;
+	int flush_delay = 1;
+	while (flush_delay--) {
+		touch_nmi_watchdog();
+		for (f = &kdb_poll_funcs[0]; *f; ++f) {
+			if ((*f)() != -1) {
+				flush_delay = FLUSH_DELAY;
+				break;
+			}
+		}
+		if (flush_delay)
+			udelay(FLUSH_UDELAY);
+	}
+}
+
+/*
+ * kdb_printf
+ *
+ *	Print a string to the output device(s).
+ *
+ * Parameters:
+ *	printf-like format and optional args.
+ * Returns:
+ *	0
+ * Locking:
+ *	None.
+ * Remarks:
+ *	use 'kdbcons->write()' to avoid polluting 'log_buf' with
+ *	kdb output.
+ *
+ *  If the user is doing a cmd args | grep srch
+ *  then kdb_grepping_flag is set.
+ *  In that case we need to accumulate full lines (ending in \n) before
+ *  searching for the pattern.
+ */
+
+static char kdb_buffer[256];	/* A bit too big to go on stack */
+static char *next_avail = kdb_buffer;
+static int  size_avail;
+static int  suspend_grep = 0;
+
+/*
+ * search arg1 to see if it contains arg2
+ * (kdmain.c provides flags for ^pat and pat$)
+ *
+ * return 1 for found, 0 for not found
+ */
+int
+kdb_search_string(char *searched, char *searchfor)
+{
+	char firstchar, *cp;
+	int len1, len2;
+
+	/* not counting the newline at the end of "searched" */
+	len1 = strlen(searched)-1;
+	len2 = strlen(searchfor);
+	if (len1 < len2)
+		return 0;
+	if (kdb_grep_leading && kdb_grep_trailing && len1 != len2)
+		return 0;
+	if (kdb_grep_leading) {
+		if (!strncmp(searched, searchfor, len2))
+			return 1;
+	} else if (kdb_grep_trailing) {
+		if (!strncmp(searched+len1-len2, searchfor, len2))
+			return 1;
+	} else {
+		firstchar = *searchfor;
+		cp = searched;
+		while ((cp = strchr(cp, firstchar))) {
+			if (!strncmp(cp, searchfor, len2))
+				return 1;
+			cp++;
+		}
+	}
+	return 0;
+}
+
+void
+kdb_printf(const char *fmt, ...)
+{
+	va_list ap;
+	int diag;
+	int linecount;
+	int logging, saved_loglevel = 0;
+	int do_longjmp = 0;
+	int got_printf_lock = 0;
+	int fnd, len;
+	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
+	char *moreprompt = "more> ";
+	struct console *c = console_drivers;
+	static DEFINE_SPINLOCK(kdb_printf_lock);
+	unsigned long uninitialized_var(flags);
+
+	preempt_disable();
+	/* Serialize kdb_printf if multiple cpus try to write at once.
+	 * But if any cpu goes recursive in kdb, just print the output,
+	 * even if it is interleaved with any other text.
+	 */
+	if (!KDB_STATE(PRINTF_LOCK)) {
+		KDB_STATE_SET(PRINTF_LOCK);
+		spin_lock_irqsave(&kdb_printf_lock, flags);
+		got_printf_lock = 1;
+		atomic_inc(&kdb_event);
+	} else {
+		__acquire(kdb_printf_lock);
+	}
+
+	diag = kdbgetintenv("LINES", &linecount);
+	if (diag || linecount <= 1)
+		linecount = 22;
+
+	diag = kdbgetintenv("LOGGING", &logging);
+	if (diag)
+		logging = 0;
+
+	if (!kdb_grepping_flag || suspend_grep) {
+		/* normally, every vsnprintf starts a new buffer */
+		next_avail = kdb_buffer;
+		size_avail = sizeof(kdb_buffer);
+	}
+	va_start(ap, fmt);
+	vsnprintf(next_avail, size_avail, fmt, ap);
+	va_end(ap);
+
+	/*
+	 * If kdb_parse() found that the command was cmd xxx | grep yyy
+	 * then kdb_grepping_flag is set, and kdb_grep_string contains yyy
+	 *
+	 * Accumulate the print data up to a newline before searching it.
+	 * (vsnprintf does null-terminate the string that it generates)
+	 */
+
+	/* skip the search if prints are temporarily unconditional */
+	if (!suspend_grep) {
+
+		if (kdb_grepping_flag) {
+			cp = strchr(kdb_buffer, '\n');
+			if (!cp) {
+				/*
+				 * Special cases that don't end with newlines
+				 * but should be written without one:
+				 *   The "[nn]kdb> " prompt should
+				 *   appear at the front of the buffer.
+				 *
+				 *   The "[nn]more " prompt should also be
+				 *     (MOREPROMPT -> moreprompt)
+				 *   written *   but we print that ourselves,
+				 *   we set the suspend_grep flag to make
+				 *   it unconditional.
+				 *
+				 */
+				if (next_avail == kdb_buffer) {
+					/*
+					 * these should occur after a newline,
+					 * so they will be at the front of
+					 * the buffer
+					 */
+					cp2 = kdb_buffer;
+					len = strlen(kdb_prompt_str);
+					if (!strncmp(cp2, kdb_prompt_str, len)) {
+						/*
+						 * We're about to start a new
+						 * command, so we can go back
+						 * to normal mode.
+						 */
+						kdb_grepping_flag = 0;
+						goto kdb_printit;
+					}
+				}
+				/* no newline; don't search/write the buffer
+				   until one is there */
+				len = strlen(kdb_buffer);
+				next_avail = kdb_buffer + len;
+				size_avail = sizeof(kdb_buffer) - len;
+				goto kdb_print_out;
+			}
+
+			/*
+			 * The newline is present; print through it or discard
+			 * it, depending on the results of the search.
+			 */
+			cp++;	 	     /* to byte after the newline */
+			replaced_byte = *cp; /* remember what/where it was */
+			cphold = cp;
+			*cp = '\0';	     /* end the string for our search */
+
+			/*
+			 * We now have a newline at the end of the string
+			 * Only continue with this output if it contains the
+			 * search string.
+			 */
+			fnd = kdb_search_string(kdb_buffer, kdb_grep_string);
+			if (!fnd) {
+				/*
+				 * At this point the complete line at the start
+				 * of kdb_buffer can be discarded, as it does
+				 * not contain what the user is looking for.
+				 * Shift the buffer left.
+				 */
+				*cphold = replaced_byte;
+				strcpy(kdb_buffer, cphold);
+				len = strlen(kdb_buffer);
+				next_avail = kdb_buffer + len;
+				size_avail = sizeof(kdb_buffer) - len;
+				goto kdb_print_out;
+			}
+			/*
+			 * at this point the string is a full line and
+			 * should be printed, up to the null.
+			 */
+		}
+	}
+kdb_printit:
+
+	/*
+	 * Write to all consoles.
+	 */
+#ifdef CONFIG_SPARC64
+	if (c == NULL)
+		prom_printf("%s", kdb_buffer);
+	else
+#endif
+
+#ifdef CONFIG_PPC64
+	if (udbg_write)
+		udbg_write(kdb_buffer, strlen(kdb_buffer));
+	else
+#endif
+
+	while (c) {
+		c->write(c, kdb_buffer, strlen(kdb_buffer));
+		touch_nmi_watchdog();
+		c = c->next;
+	}
+	if (logging) {
+		saved_loglevel = console_loglevel;
+		console_loglevel = 0;
+		printk(KERN_INFO "%s", kdb_buffer);
+	}
+
+	if (KDB_STATE(PAGER) && strchr(kdb_buffer, '\n'))
+		kdb_nextline++;
+
+	/* check for having reached the LINES number of printed lines */
+	if (kdb_nextline == linecount) {
+		char buf1[16] = "";
+#if defined(CONFIG_SMP)
+		char buf2[32];
+#endif
+
+		/* Watch out for recursion here.  Any routine that calls
+		 * kdb_printf will come back through here.  And kdb_read
+		 * uses kdb_printf to echo on serial consoles ...
+		 */
+		kdb_nextline = 1;	/* In case of recursion */
+
+		/*
+		 * Pause until cr.
+		 */
+		moreprompt = kdbgetenv("MOREPROMPT");
+		if (moreprompt == NULL)
+			moreprompt = "more> ";
+
+#if defined(CONFIG_SMP)
+		if (strchr(moreprompt, '%')) {
+			sprintf(buf2, moreprompt, get_cpu());
+			put_cpu();
+			moreprompt = buf2;
+		}
+#endif
+
+		kdb_input_flush();
+		c = console_drivers;
+#ifdef CONFIG_SPARC64
+		if (c == NULL)
+			prom_printf("%s", moreprompt);
+		else
+#endif
+
+#ifdef CONFIG_PPC64
+		if (udbg_write)
+			udbg_write(moreprompt, strlen(moreprompt));
+		else
+#endif
+
+		while (c) {
+			c->write(c, moreprompt, strlen(moreprompt));
+			touch_nmi_watchdog();
+			c = c->next;
+		}
+
+		if (logging)
+			printk("%s", moreprompt);
+
+		kdb_read(buf1, 2); /* '2' indicates to return
+				    * immediately after getting one key. */
+		kdb_nextline = 1;	/* Really set output line 1 */
+
+		/* empty and reset the buffer: */
+		kdb_buffer[0] = '\0';
+		next_avail = kdb_buffer;
+		size_avail = sizeof(kdb_buffer);
+		if ((buf1[0] == 'q') || (buf1[0] == 'Q')) {
+			/* user hit q or Q */
+			do_longjmp = 1;
+			KDB_FLAG_SET(CMD_INTERRUPT);	/* command was interrupted */
+			KDB_STATE_CLEAR(PAGER);
+			/* end of command output; back to normal mode */
+			kdb_grepping_flag = 0;
+			kdb_printf("\n");
+		} else if (buf1[0] && buf1[0] != '\n') {
+			/* user hit something other than enter */
+			suspend_grep = 1; /* for this recursion */
+			kdb_printf("\nOnly 'q' or 'Q' are processed at more prompt, input ignored\n");
+		} else if (kdb_grepping_flag) {
+			/* user hit enter */
+			suspend_grep = 1; /* for this recursion */
+			kdb_printf("\n");
+		}
+		kdb_input_flush();
+	}
+
+	/*
+	 * For grep searches, shift the printed string left.
+	 *  replaced_byte contains the character that was overwritten with
+	 *  the terminating null, and cphold points to the null.
+	 * Then adjust the notion of available space in the buffer.
+	 */
+	if (kdb_grepping_flag && !suspend_grep) {
+		*cphold = replaced_byte;
+		strcpy(kdb_buffer, cphold);
+		len = strlen(kdb_buffer);
+		next_avail = kdb_buffer + len;
+		size_avail = sizeof(kdb_buffer) - len;
+	}
+
+kdb_print_out:
+	suspend_grep = 0; /* end of what may have been a recursive call */
+	if (logging)
+		console_loglevel = saved_loglevel;
+	if (KDB_STATE(PRINTF_LOCK) && got_printf_lock) {
+		got_printf_lock = 0;
+		spin_unlock_irqrestore(&kdb_printf_lock, flags);
+		KDB_STATE_CLEAR(PRINTF_LOCK);
+		atomic_dec(&kdb_event);
+	} else {
+		__release(kdb_printf_lock);
+	}
+	preempt_enable();
+	if (do_longjmp)
+#ifdef kdba_setjmp
+		kdba_longjmp(&kdbjmpbuf[smp_processor_id()], 1)
+#endif	/* kdba_setjmp */
+		;
+}
+
+/*
+ * kdb_io_init
+ *
+ *	Initialize kernel debugger output environment.
+ *
+ * Parameters:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ *	Select a console device.  Only use a VT console if the user specified
+ *	or defaulted console= /^tty[0-9]*$/
+ */
+
+void __init
+kdb_io_init(void)
+{
+	/*
+	 * Select a console.
+	 */
+	struct console *c = console_drivers;
+	int vt_console = 0;
+
+	while (c) {
+		if ((c->flags & CON_CONSDEV) && !kdbcons)
+			kdbcons = c;
+		if ((c->flags & CON_ENABLED) &&
+		    strncmp(c->name, "tty", 3) == 0) {
+			char *p = c->name + 3;
+			while (isdigit(*p))
+				++p;
+			if (*p == '\0')
+				vt_console = 1;
+		}
+		c = c->next;
+	}
+
+	if (kdbcons == NULL) {
+		printk(KERN_ERR "kdb: Initialization failed - no console.  kdb is disabled.\n");
+		KDB_FLAG_SET(NO_CONSOLE);
+		kdb_on = 0;
+	}
+	if (!vt_console)
+		KDB_FLAG_SET(NO_VT_CONSOLE);
+	kdb_input_flush();
+	return;
+}
+
+#ifdef CONFIG_KDB_USB
+
+int kdb_no_usb;
+
+static int __init opt_kdbnousb(char *str)
+{
+	kdb_no_usb = 1;
+	return 0;
+}
+
+early_param("kdbnousb", opt_kdbnousb);
+
+#endif
diff --git a/kdb/kdbmain.c b/kdb/kdbmain.c
new file mode 100644
index 0000000..b445a17
--- /dev/null
+++ b/kdb/kdbmain.c
@@ -0,0 +1,3666 @@
+/*
+ * Kernel Debugger Architecture Independent Main Code
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1999-2004 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (C) 2000 Stephane Eranian <eranian@hpl.hp.com>
+ * Xscale (R) modifications copyright (C) 2003 Intel Corporation.
+ */
+
+/*
+ * Updated for Xscale (R) architecture support
+ * Eddie Dong <eddie.dong@intel.com> 8 Jan 03
+ */
+
+#include <linux/ctype.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/reboot.h>
+#include <linux/sched.h>
+#include <linux/sysrq.h>
+#include <linux/smp.h>
+#include <linux/utsname.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/kallsyms.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+#include <linux/notifier.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/nmi.h>
+#include <linux/ptrace.h>
+#include <linux/sysctl.h>
+#if defined(CONFIG_LKCD_DUMP) || defined(CONFIG_LKCD_DUMP_MODULE)
+#include <linux/dump.h>
+#endif
+#include <linux/cpu.h>
+#include <linux/kdebug.h>
+#ifdef CONFIG_KDB_KDUMP
+#include <linux/kexec.h>
+#endif
+
+#ifdef CONFIG_ACPI
+#include <acpi/acpi_bus.h>
+#endif
+
+#include <asm/system.h>
+#include <linux/kdebug.h>
+#include <linux/proc_fs.h>
+#include <linux/uaccess.h>
+
+char kdb_debug_info_filename[256] = {""};
+EXPORT_SYMBOL(kdb_debug_info_filename);
+#define GREP_LEN 256
+char kdb_grep_string[GREP_LEN];
+int kdb_grepping_flag;
+EXPORT_SYMBOL(kdb_grepping_flag);
+int kdb_grep_leading;
+int kdb_grep_trailing;
+
+/*
+ * Kernel debugger state flags
+ */
+int kdb_flags;
+atomic_t kdb_event;
+atomic_t kdb_8250;
+
+/*
+ * kdb_lock protects updates to kdb_initial_cpu.  Used to
+ * single thread processors through the kernel debugger.
+ */
+int kdb_initial_cpu = -1;	/* cpu number that owns kdb */
+int kdb_seqno = 2;		/* how many times kdb has been entered */
+
+int kdb_nextline = 1;
+static volatile int kdb_new_cpu;		/* Which cpu to switch to */
+
+int kdb_state[NR_CPUS];		/* Per cpu state */
+
+const struct task_struct *kdb_current_task;
+EXPORT_SYMBOL(kdb_current_task);
+struct pt_regs *kdb_current_regs;
+
+#ifdef	CONFIG_KDB_OFF
+int kdb_on;				/* Default is off */
+#else
+int kdb_on = 1;				/* Default is on */
+#endif	/* CONFIG_KDB_OFF */
+
+const char *kdb_diemsg;
+static int kdb_go_count;
+#ifdef CONFIG_KDB_CONTINUE_CATASTROPHIC
+static unsigned int kdb_continue_catastrophic =
+	CONFIG_KDB_CONTINUE_CATASTROPHIC;
+#else
+static unsigned int kdb_continue_catastrophic;
+#endif
+
+#ifdef kdba_setjmp
+	/*
+	 * Must have a setjmp buffer per CPU.  Switching cpus will
+	 * cause the jump buffer to be setup for the new cpu, and
+	 * subsequent switches (and pager aborts) will use the
+	 * appropriate per-processor values.
+	 */
+kdb_jmp_buf *kdbjmpbuf;
+#endif	/* kdba_setjmp */
+
+	/*
+	 * kdb_commands describes the available commands.
+	 */
+static kdbtab_t *kdb_commands;
+static int kdb_max_commands;
+
+typedef struct _kdbmsg {
+	int	km_diag;	/* kdb diagnostic */
+	char	*km_msg;	/* Corresponding message text */
+} kdbmsg_t;
+
+#define KDBMSG(msgnum, text) \
+	{ KDB_##msgnum, text }
+
+static kdbmsg_t kdbmsgs[] = {
+	KDBMSG(NOTFOUND, "Command Not Found"),
+	KDBMSG(ARGCOUNT, "Improper argument count, see usage."),
+	KDBMSG(BADWIDTH, "Illegal value for BYTESPERWORD use 1, 2, 4 or 8, 8 is only allowed on 64 bit systems"),
+	KDBMSG(BADRADIX, "Illegal value for RADIX use 8, 10 or 16"),
+	KDBMSG(NOTENV, "Cannot find environment variable"),
+	KDBMSG(NOENVVALUE, "Environment variable should have value"),
+	KDBMSG(NOTIMP, "Command not implemented"),
+	KDBMSG(ENVFULL, "Environment full"),
+	KDBMSG(ENVBUFFULL, "Environment buffer full"),
+	KDBMSG(TOOMANYBPT, "Too many breakpoints defined"),
+#ifdef CONFIG_CPU_XSCALE
+	KDBMSG(TOOMANYDBREGS, "More breakpoints than ibcr registers defined"),
+#else
+	KDBMSG(TOOMANYDBREGS, "More breakpoints than db registers defined"),
+#endif
+	KDBMSG(DUPBPT, "Duplicate breakpoint address"),
+	KDBMSG(BPTNOTFOUND, "Breakpoint not found"),
+	KDBMSG(BADMODE, "Invalid IDMODE"),
+	KDBMSG(BADINT, "Illegal numeric value"),
+	KDBMSG(INVADDRFMT, "Invalid symbolic address format"),
+	KDBMSG(BADREG, "Invalid register name"),
+	KDBMSG(BADCPUNUM, "Invalid cpu number"),
+	KDBMSG(BADLENGTH, "Invalid length field"),
+	KDBMSG(NOBP, "No Breakpoint exists"),
+	KDBMSG(BADADDR, "Invalid address"),
+};
+#undef KDBMSG
+
+static const int __nkdb_err = sizeof(kdbmsgs) / sizeof(kdbmsg_t);
+
+
+/*
+ * Initial environment.   This is all kept static and local to
+ * this file.   We don't want to rely on the memory allocation
+ * mechanisms in the kernel, so we use a very limited allocate-only
+ * heap for new and altered environment variables.  The entire
+ * environment is limited to a fixed number of entries (add more
+ * to __env[] if required) and a fixed amount of heap (add more to
+ * KDB_ENVBUFSIZE if required).
+ */
+
+static char *__env[] = {
+#if defined(CONFIG_SMP)
+ "PROMPT=[%d]kdb> ",
+ "MOREPROMPT=[%d]more> ",
+#else
+ "PROMPT=kdb> ",
+ "MOREPROMPT=more> ",
+#endif
+ "RADIX=16",
+ "LINES=24",
+ "COLUMNS=80",
+ "MDCOUNT=8",			/* lines of md output */
+ "BTARGS=9",			/* 9 possible args in bt */
+ KDB_PLATFORM_ENV,
+ "DTABCOUNT=30",
+ "NOSECT=1",
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+ (char *)0,
+};
+
+static const int __nenv = (sizeof(__env) / sizeof(char *));
+
+/* external commands: */
+int kdb_debuginfo_print(int argc, const char **argv);
+int kdb_pxhelp(int argc, const char **argv);
+int kdb_walkhelp(int argc, const char **argv);
+int kdb_walk(int argc, const char **argv);
+
+/*
+ * kdb_serial_str is the sequence that the user must enter on a serial
+ * console to invoke kdb.  It can be a single character such as "\001"
+ * (control-A) or multiple characters such as "\eKDB".  NOTE: All except the
+ * last character are passed through to the application reading from the serial
+ * console.
+ *
+ * I tried to make the sequence a CONFIG_ option but most of CML1 cannot cope
+ * with '\' in strings.  CML2 would have been able to do it but we lost CML2.
+ * KAO.
+ */
+const char kdb_serial_str[] = "\eKDB";
+EXPORT_SYMBOL(kdb_serial_str);
+
+struct task_struct *
+kdb_curr_task(int cpu)
+{
+	struct task_struct *p = curr_task(cpu);
+#ifdef	_TIF_MCA_INIT
+	struct kdb_running_process *krp = kdb_running_process + cpu;
+	if ((task_thread_info(p)->flags & _TIF_MCA_INIT) && krp->p)
+		p = krp->p;
+#endif
+	return p;
+}
+
+/*
+ * kdbgetenv
+ *
+ *	This function will return the character string value of
+ *	an environment variable.
+ *
+ * Parameters:
+ *	match	A character string representing an environment variable.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	NULL	No environment variable matches 'match'
+ *	char*	Pointer to string value of environment variable.
+ * Locking:
+ *	No locking considerations required.
+ * Remarks:
+ */
+char *
+kdbgetenv(const char *match)
+{
+	char **ep = __env;
+	int matchlen = strlen(match);
+	int i;
+
+	for(i = 0; i < __nenv; i++) {
+		char *e = *ep++;
+
+		if (!e)
+			continue;
+
+		if ((strncmp(match, e, matchlen) == 0)
+		 && ((e[matchlen] == '\0')
+		   || (e[matchlen] == '='))) {
+			char *cp = strchr(e, '=');
+			return (cp ? ++cp : "");
+		}
+	}
+	return NULL;
+}
+
+/*
+ * kdballocenv
+ *
+ *	This function is used to allocate bytes for environment entries.
+ *
+ * Parameters:
+ *	match	A character string representing a numeric value
+ * Outputs:
+ *	*value  the unsigned long represntation of the env variable 'match'
+ * Returns:
+ *	Zero on success, a kdb diagnostic on failure.
+ * Locking:
+ *	No locking considerations required.  Must be called with all
+ *	processors halted.
+ * Remarks:
+ *	We use a static environment buffer (envbuffer) to hold the values
+ *	of dynamically generated environment variables (see kdb_set).  Buffer
+ *	space once allocated is never free'd, so over time, the amount of space
+ *	(currently 512 bytes) will be exhausted if env variables are changed
+ *	frequently.
+ */
+static char *
+kdballocenv(size_t bytes)
+{
+#define	KDB_ENVBUFSIZE	512
+	static char envbuffer[KDB_ENVBUFSIZE];
+	static int envbufsize;
+	char *ep = NULL;
+
+	if ((KDB_ENVBUFSIZE - envbufsize) >= bytes) {
+		ep = &envbuffer[envbufsize];
+		envbufsize += bytes;
+	}
+	return ep;
+}
+
+/*
+ * kdbgetulenv
+ *
+ *	This function will return the value of an unsigned long-valued
+ *	environment variable.
+ *
+ * Parameters:
+ *	match	A character string representing a numeric value
+ * Outputs:
+ *	*value  the unsigned long represntation of the env variable 'match'
+ * Returns:
+ *	Zero on success, a kdb diagnostic on failure.
+ * Locking:
+ *	No locking considerations required.
+ * Remarks:
+ */
+
+static int
+kdbgetulenv(const char *match, unsigned long *value)
+{
+	char *ep;
+
+	ep = kdbgetenv(match);
+	if (!ep)
+		return KDB_NOTENV;
+	if (strlen(ep) == 0)
+		return KDB_NOENVVALUE;
+
+	*value = simple_strtoul(ep, NULL, 0);
+
+	return 0;
+}
+
+/*
+ * kdbgetintenv
+ *
+ *	This function will return the value of an integer-valued
+ *	environment variable.
+ *
+ * Parameters:
+ *	match	A character string representing an integer-valued env variable
+ * Outputs:
+ *	*value  the integer representation of the environment variable 'match'
+ * Returns:
+ *	Zero on success, a kdb diagnostic on failure.
+ * Locking:
+ *	No locking considerations required.
+ * Remarks:
+ */
+
+int
+kdbgetintenv(const char *match, int *value) {
+	unsigned long val;
+	int diag;
+
+	diag = kdbgetulenv(match, &val);
+	if (!diag)
+		*value = (int) val;
+	return diag;
+}
+
+/*
+ * kdbgetularg
+ *
+ *	This function will convert a numeric string
+ *	into an unsigned long value.
+ *
+ * Parameters:
+ *	arg	A character string representing a numeric value
+ * Outputs:
+ *	*value  the unsigned long represntation of arg.
+ * Returns:
+ *	Zero on success, a kdb diagnostic on failure.
+ * Locking:
+ *	No locking considerations required.
+ * Remarks:
+ */
+
+int
+kdbgetularg(const char *arg, unsigned long *value)
+{
+	char *endp;
+	unsigned long val;
+
+	val = simple_strtoul(arg, &endp, 0);
+
+	if (endp == arg) {
+		/*
+		 * Try base 16, for us folks too lazy to type the
+		 * leading 0x...
+		 */
+		val = simple_strtoul(arg, &endp, 16);
+		if (endp == arg)
+			return KDB_BADINT;
+	}
+
+	*value = val;
+
+	return 0;
+}
+
+/*
+ * kdb_set
+ *
+ *	This function implements the 'set' command.  Alter an existing
+ *	environment variable or create a new one.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_set(int argc, const char **argv)
+{
+	int i;
+	char *ep;
+	size_t varlen, vallen;
+
+	/*
+	 * we can be invoked two ways:
+	 *   set var=value    argv[1]="var", argv[2]="value"
+	 *   set var = value  argv[1]="var", argv[2]="=", argv[3]="value"
+	 * - if the latter, shift 'em down.
+	 */
+	if (argc == 3) {
+		argv[2] = argv[3];
+		argc--;
+	}
+
+	if (argc != 2)
+		return KDB_ARGCOUNT;
+
+	/*
+	 * Check for internal variables
+	 */
+	if (strcmp(argv[1], "KDBDEBUG") == 0) {
+		unsigned int debugflags;
+		char *cp;
+
+		debugflags = simple_strtoul(argv[2], &cp, 0);
+		if (cp == argv[2] || debugflags & ~KDB_DEBUG_FLAG_MASK) {
+			kdb_printf("kdb: illegal debug flags '%s'\n",
+				    argv[2]);
+			return 0;
+		}
+		kdb_flags = (kdb_flags &
+			     ~(KDB_DEBUG_FLAG_MASK << KDB_DEBUG_FLAG_SHIFT))
+			| (debugflags << KDB_DEBUG_FLAG_SHIFT);
+
+		return 0;
+	}
+
+	/*
+	 * Tokenizer squashed the '=' sign.  argv[1] is variable
+	 * name, argv[2] = value.
+	 */
+	varlen = strlen(argv[1]);
+	vallen = strlen(argv[2]);
+	ep = kdballocenv(varlen + vallen + 2);
+	if (ep == (char *)0)
+		return KDB_ENVBUFFULL;
+
+	sprintf(ep, "%s=%s", argv[1], argv[2]);
+
+	ep[varlen+vallen+1] = '\0';
+
+	for(i = 0; i < __nenv; i++) {
+		if (__env[i]
+		 && ((strncmp(__env[i], argv[1], varlen) == 0)
+		   && ((__env[i][varlen] == '\0')
+		    || (__env[i][varlen] == '=')))) {
+			__env[i] = ep;
+			return 0;
+		}
+	}
+
+	/*
+	 * Wasn't existing variable.  Fit into slot.
+	 */
+	for(i = 0; i < __nenv-1; i++) {
+		if (__env[i] == (char *)0) {
+			__env[i] = ep;
+			return 0;
+		}
+	}
+
+	return KDB_ENVFULL;
+}
+
+static int
+kdb_check_regs(void)
+{
+	if (!kdb_current_regs) {
+		kdb_printf("No current kdb registers."
+			   "  You may need to select another task\n");
+		return KDB_BADREG;
+	}
+	return 0;
+}
+
+/*
+ * kdbgetaddrarg
+ *
+ *	This function is responsible for parsing an
+ *	address-expression and returning the value of
+ *	the expression, symbol name, and offset to the caller.
+ *
+ *	The argument may consist of a numeric value (decimal or
+ *	hexidecimal), a symbol name, a register name (preceeded
+ *	by the percent sign), an environment variable with a numeric
+ *	value (preceeded by a dollar sign) or a simple arithmetic
+ *	expression consisting of a symbol name, +/-, and a numeric
+ *	constant value (offset).
+ *
+ * Parameters:
+ *	argc	- count of arguments in argv
+ *	argv	- argument vector
+ *	*nextarg - index to next unparsed argument in argv[]
+ *	regs	- Register state at time of KDB entry
+ * Outputs:
+ *	*value	- receives the value of the address-expression
+ *	*offset - receives the offset specified, if any
+ *	*name   - receives the symbol name, if any
+ *	*nextarg - index to next unparsed argument in argv[]
+ *
+ * Returns:
+ *	zero is returned on success, a kdb diagnostic code is
+ *      returned on error.
+ *
+ * Locking:
+ *	No locking requirements.
+ *
+ * Remarks:
+ *
+ */
+
+int
+kdbgetaddrarg(int argc, const char **argv, int *nextarg,
+	      kdb_machreg_t *value,  long *offset,
+	      char **name)
+{
+	kdb_machreg_t addr;
+	unsigned long off = 0;
+	int positive;
+	int diag;
+	int found = 0;
+	char *symname;
+	char symbol = '\0';
+	char *cp;
+	kdb_symtab_t symtab;
+
+	/*
+	 * Process arguments which follow the following syntax:
+	 *
+	 *  symbol | numeric-address [+/- numeric-offset]
+	 *  %register
+	 *  $environment-variable
+	 */
+
+	if (*nextarg > argc)
+		return KDB_ARGCOUNT;
+
+	symname = (char *)argv[*nextarg];
+
+	/*
+	 * If there is no whitespace between the symbol
+	 * or address and the '+' or '-' symbols, we
+	 * remember the character and replace it with a
+	 * null so the symbol/value can be properly parsed
+	 */
+	if ((cp = strpbrk(symname, "+-")) != NULL) {
+		symbol = *cp;
+		*cp++ = '\0';
+	}
+
+	if (symname[0] == '$') {
+		diag = kdbgetulenv(&symname[1], &addr);
+		if (diag)
+			return diag;
+	} else if (symname[0] == '%') {
+		if ((diag = kdb_check_regs()))
+			return diag;
+		//		diag = kdba_getregcontents(&symname[1], kdb_current_regs, &addr);
+		// HACK HACK HACK
+		diag = 0;
+		if (diag)
+			return diag;
+	} else {
+		found = kdbgetsymval(symname, &symtab);
+		if (found) {
+			addr = symtab.sym_start;
+		} else {
+			diag = kdbgetularg(argv[*nextarg], &addr);
+			if (diag)
+				return diag;
+		}
+	}
+
+	if (!found)
+		found = kdbnearsym(addr, &symtab);
+
+	(*nextarg)++;
+
+	if (name)
+		*name = symname;
+	if (value)
+		*value = addr;
+	if (offset && name && *name)
+		*offset = addr - symtab.sym_start;
+
+	if ((*nextarg > argc)
+	 && (symbol == '\0'))
+		return 0;
+
+	/*
+	 * check for +/- and offset
+	 */
+
+	if (symbol == '\0') {
+		if ((argv[*nextarg][0] != '+')
+		 && (argv[*nextarg][0] != '-')) {
+			/*
+			 * Not our argument.  Return.
+			 */
+			return 0;
+		} else {
+			positive = (argv[*nextarg][0] == '+');
+			(*nextarg)++;
+		}
+	} else
+		positive = (symbol == '+');
+
+	/*
+	 * Now there must be an offset!
+	 */
+	if ((*nextarg > argc)
+	 && (symbol == '\0')) {
+		return KDB_INVADDRFMT;
+	}
+
+	if (!symbol) {
+		cp = (char *)argv[*nextarg];
+		(*nextarg)++;
+	}
+
+	diag = kdbgetularg(cp, &off);
+	if (diag)
+		return diag;
+
+	if (!positive)
+		off = -off;
+
+	if (offset)
+		*offset += off;
+
+	if (value)
+		*value += off;
+
+	return 0;
+}
+
+static void
+kdb_cmderror(int diag)
+{
+	int i;
+
+	if (diag >= 0) {
+		kdb_printf("no error detected (diagnostic is %d)\n", diag);
+		return;
+	}
+
+	for(i = 0; i < __nkdb_err; i++) {
+		if (kdbmsgs[i].km_diag == diag) {
+			kdb_printf("diag: %d: %s\n", diag, kdbmsgs[i].km_msg);
+			return;
+		}
+	}
+
+	kdb_printf("Unknown diag %d\n", -diag);
+}
+
+/*
+ * kdb_defcmd, kdb_defcmd2
+ *
+ *	This function implements the 'defcmd' command which defines one
+ *	command as a set of other commands, terminated by endefcmd.
+ *	kdb_defcmd processes the initial 'defcmd' command, kdb_defcmd2
+ *	is invoked from kdb_parse for the following commands until
+ *	'endefcmd'.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+struct defcmd_set {
+	int count;
+	int usable;
+	char *name;
+	char *usage;
+	char *help;
+	char **command;
+};
+static struct defcmd_set *defcmd_set;
+static int defcmd_set_count;
+static int defcmd_in_progress;
+
+/* Forward references */
+static int kdb_exec_defcmd(int argc, const char **argv);
+
+static int
+kdb_defcmd2(const char *cmdstr, const char *argv0)
+{
+	struct defcmd_set *s = defcmd_set + defcmd_set_count - 1;
+	char **save_command = s->command;
+	if (strcmp(argv0, "endefcmd") == 0) {
+		defcmd_in_progress = 0;
+		if (!s->count)
+			s->usable = 0;
+		if (s->usable)
+			kdb_register(s->name, kdb_exec_defcmd,
+				     s->usage, s->help, 0);
+		return 0;
+	}
+	if (!s->usable)
+		return KDB_NOTIMP;
+	s->command = kmalloc((s->count + 1) * sizeof(*(s->command)), GFP_KDB);
+	if (!s->command) {
+		kdb_printf("Could not allocate new kdb_defcmd table for %s\n", cmdstr);
+		s->usable = 0;
+		return KDB_NOTIMP;
+	}
+	memcpy(s->command, save_command, s->count * sizeof(*(s->command)));
+	s->command[s->count++] = kdb_strdup(cmdstr, GFP_KDB);
+	kfree(save_command);
+	return 0;
+}
+
+static int
+kdb_defcmd(int argc, const char **argv)
+{
+	struct defcmd_set *save_defcmd_set = defcmd_set, *s;
+	if (defcmd_in_progress) {
+		kdb_printf("kdb: nested defcmd detected, assuming missing endefcmd\n");
+		kdb_defcmd2("endefcmd", "endefcmd");
+	}
+	if (argc == 0) {
+		int i;
+		for (s = defcmd_set; s < defcmd_set + defcmd_set_count; ++s) {
+			kdb_printf("defcmd %s \"%s\" \"%s\"\n", s->name, s->usage, s->help);
+			for (i = 0; i < s->count; ++i)
+				kdb_printf("%s", s->command[i]);
+			kdb_printf("endefcmd\n");
+		}
+		return 0;
+	}
+	if (argc != 3)
+		return KDB_ARGCOUNT;
+	defcmd_set = kmalloc((defcmd_set_count + 1) * sizeof(*defcmd_set), GFP_KDB);
+	if (!defcmd_set) {
+		kdb_printf("Could not allocate new defcmd_set entry for %s\n", argv[1]);
+		defcmd_set = save_defcmd_set;
+		return KDB_NOTIMP;
+	}
+	memcpy(defcmd_set, save_defcmd_set, defcmd_set_count * sizeof(*defcmd_set));
+	kfree(save_defcmd_set);
+	s = defcmd_set + defcmd_set_count;
+	memset(s, 0, sizeof(*s));
+	s->usable = 1;
+	s->name = kdb_strdup(argv[1], GFP_KDB);
+	s->usage = kdb_strdup(argv[2], GFP_KDB);
+	s->help = kdb_strdup(argv[3], GFP_KDB);
+	if (s->usage[0] == '"') {
+		strcpy(s->usage, s->usage+1);
+		s->usage[strlen(s->usage)-1] = '\0';
+	}
+	if (s->help[0] == '"') {
+		strcpy(s->help, s->help+1);
+		s->help[strlen(s->help)-1] = '\0';
+	}
+	++defcmd_set_count;
+	defcmd_in_progress = 1;
+	return 0;
+}
+
+/*
+ * kdb_exec_defcmd
+ *
+ *	Execute the set of commands associated with this defcmd name.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_exec_defcmd(int argc, const char **argv)
+{
+	int i, ret;
+	struct defcmd_set *s;
+	if (argc != 0)
+		return KDB_ARGCOUNT;
+	for (s = defcmd_set, i = 0; i < defcmd_set_count; ++i, ++s) {
+		if (strcmp(s->name, argv[0]) == 0)
+			break;
+	}
+	if (i == defcmd_set_count) {
+		kdb_printf("kdb_exec_defcmd: could not find commands for %s\n", argv[0]);
+		return KDB_NOTIMP;
+	}
+	for (i = 0; i < s->count; ++i) {
+		/* Recursive use of kdb_parse, do not use argv after
+		 * this point */
+		argv = NULL;
+		kdb_printf("[%s]kdb> %s\n", s->name, s->command[i]);
+		if ((ret = kdb_parse(s->command[i])))
+			return ret;
+	}
+	return 0;
+}
+
+/* Command history */
+#define KDB_CMD_HISTORY_COUNT	32
+#define CMD_BUFLEN		200	/* kdb_printf: max printline
+					 * size == 256 */
+static unsigned int cmd_head, cmd_tail;
+static unsigned int cmdptr;
+static char cmd_hist[KDB_CMD_HISTORY_COUNT][CMD_BUFLEN];
+static char cmd_cur[CMD_BUFLEN];
+
+/*
+ * The "str" argument may point to something like  | grep xyz
+ *
+ */
+static void
+parse_grep(const char *str)
+{
+	int	len;
+	char	*cp = (char *)str, *cp2;
+
+	/* sanity check: we should have been called with the \ first */
+	if (*cp != '|')
+		return;
+	cp++;
+	while (isspace(*cp))
+		cp++;
+	if (strncmp(cp, "grep ",5)) {
+		kdb_printf("invalid 'pipe', see grephelp\n");
+		return;
+	}
+	cp += 5;
+	while (isspace(*cp))
+		cp++;
+	cp2 = strchr(cp, '\n');
+	if (cp2)
+		*cp2 = '\0'; /* remove the trailing newline */
+	len = strlen(cp);
+	if (len == 0) {
+		kdb_printf("invalid 'pipe', see grephelp\n");
+		return;
+	}
+	/* now cp points to a nonzero length search string */
+	if (*cp == '"') {
+		/* allow it be "x y z" by removing the "'s - there must
+		   be two of them */
+		cp++;
+		cp2 = strchr(cp, '"');
+		if (!cp2) {
+			kdb_printf("invalid quoted string, see grephelp\n");
+			return;
+		}
+		*cp2 = '\0'; /* end the string where the 2nd " was */
+	}
+	kdb_grep_leading = 0;
+	if (*cp == '^') {
+		kdb_grep_leading = 1;
+		cp++;
+	}
+	len = strlen(cp);
+	kdb_grep_trailing = 0;
+	if (*(cp+len-1) == '$') {
+		kdb_grep_trailing = 1;
+		*(cp+len-1) = '\0';
+	}
+	len = strlen(cp);
+	if (!len) return;
+	if (len >= GREP_LEN) {
+		kdb_printf("search string too long\n");
+		return;
+	}
+	strcpy(kdb_grep_string, cp);
+	kdb_grepping_flag++;
+	return;
+}
+
+/*
+ * kdb_parse
+ *
+ *	Parse the command line, search the command table for a
+ *	matching command and invoke the command function.
+ *	This function may be called recursively, if it is, the second call
+ *	will overwrite argv and cbuf.  It is the caller's responsibility to
+ *	save their argv if they recursively call kdb_parse().
+ *
+ * Parameters:
+ *      cmdstr	The input command line to be parsed.
+ *	regs	The registers at the time kdb was entered.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	Zero for success, a kdb diagnostic if failure.
+ * Locking:
+ * 	None.
+ * Remarks:
+ *	Limited to 20 tokens.
+ *
+ *	Real rudimentary tokenization. Basically only whitespace
+ *	is considered a token delimeter (but special consideration
+ *	is taken of the '=' sign as used by the 'set' command).
+ *
+ *	The algorithm used to tokenize the input string relies on
+ *	there being at least one whitespace (or otherwise useless)
+ *	character between tokens as the character immediately following
+ *	the token is altered in-place to a null-byte to terminate the
+ *	token string.
+ */
+
+#define MAXARGC	20
+
+int
+kdb_parse(const char *cmdstr)
+{
+	static char *argv[MAXARGC];
+	static int argc = 0;
+	static char cbuf[CMD_BUFLEN+2];
+	char *cp;
+	char *cpp, quoted;
+	kdbtab_t *tp;
+	int i, escaped, ignore_errors = 0, check_grep;
+
+	/*
+	 * First tokenize the command string.
+	 */
+	cp = (char *)cmdstr;
+	kdb_grepping_flag = check_grep = 0;
+
+	if (KDB_FLAG(CMD_INTERRUPT)) {
+		/* Previous command was interrupted, newline must not repeat the command */
+		KDB_FLAG_CLEAR(CMD_INTERRUPT);
+		KDB_STATE_SET(PAGER);
+		argc = 0;	/* no repeat */
+	}
+
+	if (*cp != '\n' && *cp != '\0') {
+		argc = 0;
+		cpp = cbuf;
+		while (*cp) {
+			/* skip whitespace */
+			while (isspace(*cp)) cp++;
+			if ((*cp == '\0') || (*cp == '\n') || (*cp == '#' && !defcmd_in_progress))
+				break;
+			/* special case: check for | grep pattern */
+			if (*cp == '|') {
+				check_grep++;
+				break;
+			}
+			if (cpp >= cbuf + CMD_BUFLEN) {
+				kdb_printf("kdb_parse: command buffer overflow, command ignored\n%s\n", cmdstr);
+				return KDB_NOTFOUND;
+			}
+			if (argc >= MAXARGC - 1) {
+				kdb_printf("kdb_parse: too many arguments, command ignored\n%s\n", cmdstr);
+				return KDB_NOTFOUND;
+			}
+			argv[argc++] = cpp;
+			escaped = 0;
+			quoted = '\0';
+			/* Copy to next unquoted and unescaped whitespace or '=' */
+			while (*cp && *cp != '\n' && (escaped || quoted || !isspace(*cp))) {
+				if (cpp >= cbuf + CMD_BUFLEN)
+					break;
+				if (escaped) {
+					escaped = 0;
+					*cpp++ = *cp++;
+					continue;
+				}
+				if (*cp == '\\') {
+					escaped = 1;
+					++cp;
+					continue;
+				}
+				if (*cp == quoted) {
+					quoted = '\0';
+				} else if (*cp == '\'' || *cp == '"') {
+					quoted = *cp;
+				}
+				if ((*cpp = *cp++) == '=' && !quoted)
+					break;
+				++cpp;
+			}
+			*cpp++ = '\0';	/* Squash a ws or '=' character */
+		}
+	}
+	if (!argc)
+		return 0;
+	if (check_grep)
+		parse_grep(cp);
+	if (defcmd_in_progress) {
+		int result = kdb_defcmd2(cmdstr, argv[0]);
+		if (!defcmd_in_progress) {
+			argc = 0;	/* avoid repeat on endefcmd */
+			*(argv[0]) = '\0';
+		}
+		return result;
+	}
+	if (argv[0][0] == '-' && argv[0][1] && (argv[0][1] < '0' || argv[0][1] > '9')) {
+		ignore_errors = 1;
+		++argv[0];
+	}
+
+	for(tp=kdb_commands, i=0; i < kdb_max_commands; i++,tp++) {
+		if (tp->cmd_name) {
+			/*
+			 * If this command is allowed to be abbreviated,
+			 * check to see if this is it.
+			 */
+
+			if (tp->cmd_minlen
+			 && (strlen(argv[0]) <= tp->cmd_minlen)) {
+				if (strncmp(argv[0],
+					    tp->cmd_name,
+					    tp->cmd_minlen) == 0) {
+					break;
+				}
+			}
+
+			if (strcmp(argv[0], tp->cmd_name)==0) {
+				break;
+			}
+		}
+	}
+
+	/*
+	 * If we don't find a command by this name, see if the first
+	 * few characters of this match any of the known commands.
+	 * e.g., md1c20 should match md.
+	 */
+	if (i == kdb_max_commands) {
+		for(tp=kdb_commands, i=0; i < kdb_max_commands; i++,tp++) {
+			if (tp->cmd_name) {
+				if (strncmp(argv[0],
+					    tp->cmd_name,
+					    strlen(tp->cmd_name))==0) {
+					break;
+				}
+			}
+		}
+	}
+
+	if (i < kdb_max_commands) {
+		int result;
+		KDB_STATE_SET(CMD);
+		result = (*tp->cmd_func)(argc-1,
+				       (const char**)argv);
+		if (result && ignore_errors && result > KDB_CMD_GO)
+			result = 0;
+		KDB_STATE_CLEAR(CMD);
+		switch (tp->cmd_repeat) {
+		case KDB_REPEAT_NONE:
+			argc = 0;
+			if (argv[0])
+				*(argv[0]) = '\0';
+			break;
+		case KDB_REPEAT_NO_ARGS:
+			argc = 1;
+			if (argv[1])
+				*(argv[1]) = '\0';
+			break;
+		case KDB_REPEAT_WITH_ARGS:
+			break;
+		}
+		return result;
+	}
+
+	/*
+	 * If the input with which we were presented does not
+	 * map to an existing command, attempt to parse it as an
+	 * address argument and display the result.   Useful for
+	 * obtaining the address of a variable, or the nearest symbol
+	 * to an address contained in a register.
+	 */
+	{
+		kdb_machreg_t value;
+		char *name = NULL;
+		long offset;
+		int nextarg = 0;
+
+		if (kdbgetaddrarg(0, (const char **)argv, &nextarg,
+				  &value, &offset, &name)) {
+			return KDB_NOTFOUND;
+		}
+
+		kdb_printf("%s = ", argv[0]);
+		kdb_symbol_print(value, NULL, KDB_SP_DEFAULT);
+		kdb_printf("\n");
+		return 0;
+	}
+}
+
+
+static int
+handle_ctrl_cmd(char *cmd)
+{
+#define CTRL_P	16
+#define CTRL_N	14
+
+	/* initial situation */
+	if (cmd_head == cmd_tail) return 0;
+
+	switch(*cmd) {
+		case CTRL_P:
+			if (cmdptr != cmd_tail)
+				cmdptr = (cmdptr-1) % KDB_CMD_HISTORY_COUNT;
+			strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
+			return 1;
+		case CTRL_N:
+			if (cmdptr != cmd_head)
+				cmdptr = (cmdptr+1) % KDB_CMD_HISTORY_COUNT;
+			strncpy(cmd_cur, cmd_hist[cmdptr], CMD_BUFLEN);
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * kdb_do_dump
+ *
+ *	Call the dump() function if the kernel is configured for LKCD.
+ * Inputs:
+ *	None.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.  dump() may or may not return.
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static void
+kdb_do_dump(void)
+{
+#if defined(CONFIG_LKCD_DUMP) || defined(CONFIG_LKCD_DUMP_MODULE)
+	kdb_printf("Forcing dump (if configured)\n");
+	console_loglevel = 8;	/* to see the dump messages */
+	dump("kdb_do_dump");
+#endif
+}
+
+/*
+ * kdb_reboot
+ *
+ *	This function implements the 'reboot' command.  Reboot the system
+ *	immediately.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	Shouldn't return from this function.
+ */
+
+static int
+kdb_reboot(int argc, const char **argv)
+{
+	emergency_restart();
+	kdb_printf("Hmm, kdb_reboot did not reboot, spinning here\n");
+	while (1) {};
+	/* NOTREACHED */
+	return 0;
+}
+
+#ifdef CONFIG_KDB_KDUMP
+
+int kdb_kdump_state = KDB_KDUMP_RESET;	/* KDB kdump state */
+
+static int kdb_cpu(int argc, const char **argv);
+
+/*
+ * kdb_kdump_check
+ *
+ *	This is where the kdump on monarch cpu is handled.
+ *
+ */
+void kdb_kdump_check(struct pt_regs *regs)
+{
+	if (kdb_kdump_state != KDB_KDUMP_RESET) {
+		crash_kexec(regs);
+
+		/* If the call above returned then something
+		   didn't work */
+		kdb_printf("kdb_kdump_check: crash_kexec failed!\n");
+		kdb_printf("  Please check if the kdump kernel has been properly loaded\n");
+		kdb_kdump_state = KDB_KDUMP_RESET;
+	}
+}
+
+
+/*
+ * kdb_kdump
+ *
+ *     This function implements the 'kdump' command.
+ *
+ * Inputs:
+ *     argc    argument count
+ *     argv    argument vector
+ *     envp    environment vector
+ *     regs    registers at time kdb was entered.
+ * Outputs:
+ *     None.
+ * Returns:
+ *     zero for success, a kdb diagnostic if error
+ * Locking:
+ *     none.
+ * Remarks:
+ *     Shouldn't return from this function.
+ */
+
+static int
+kdb_kdump(int argc, const char **argv)
+{
+	char cpu_id[6];		/* up to 99,999 cpus */
+	const char *cpu_argv[] = {NULL, cpu_id, NULL};
+	int ret;
+
+	kdb_kdump_state = KDB_KDUMP_KDUMP;
+	/* Switch back to the initial cpu before process kdump command */
+	if (smp_processor_id() != kdb_initial_cpu) {
+		sprintf(cpu_id, "%d", kdb_initial_cpu);
+		ret = kdb_cpu(1, cpu_argv);
+		if (ret != KDB_CMD_CPU) {
+			kdb_printf("kdump: Failed to switch to initial cpu %d;"
+				" aborted\n", kdb_initial_cpu);
+			kdb_kdump_state = KDB_KDUMP_RESET;
+		}
+	} else
+		ret = KDB_CMD_CPU;
+
+	return ret;
+}
+
+#endif /* CONFIG_KDB_KDUMP */
+
+static int
+kdb_quiet(int reason)
+{
+	return (reason == KDB_REASON_CPU_UP || reason == KDB_REASON_SILENT);
+}
+
+kdb_machreg_t kdba_getpc(struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
+}
+
+int
+kdba_dumpregs(struct pt_regs *regs,
+            const char *type,
+            const char *extra)
+{
+	return 0;
+}
+
+
+void
+kdba_set_current_task(const struct task_struct *p)
+{
+	kdb_current_task = p;
+
+	if (kdb_task_has_cpu(p)) {
+		struct kdb_running_process *krp = kdb_running_process + kdb_process_cpu(p);
+		kdb_current_regs = krp->regs;
+		return;
+	}
+	kdb_current_regs = NULL;
+}
+
+/*
+ * kdb_local
+ *
+ *	The main code for kdb.  This routine is invoked on a specific
+ *	processor, it is not global.  The main kdb() routine ensures
+ *	that only one processor at a time is in this routine.  This
+ *	code is called with the real reason code on the first entry
+ *	to a kdb session, thereafter it is called with reason SWITCH,
+ *	even if the user goes back to the original cpu.
+ *
+ * Inputs:
+ *	reason		The reason KDB was invoked
+ *	error		The hardware-defined error code
+ *	regs		The exception frame at time of fault/breakpoint.  NULL
+ *			for reason SILENT or CPU_UP, otherwise valid.
+ *	db_result	Result code from the break or debug point.
+ * Returns:
+ *	0	KDB was invoked for an event which it wasn't responsible
+ *	1	KDB handled the event for which it was invoked.
+ *	KDB_CMD_GO	User typed 'go'.
+ *	KDB_CMD_CPU	User switched to another cpu.
+ *	KDB_CMD_SS	Single step.
+ *	KDB_CMD_SSB	Single step until branch.
+ * Locking:
+ *	none
+ * Remarks:
+ *	none
+ */
+
+static int
+kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs, kdb_dbtrap_t db_result)
+{
+	char *cmdbuf;
+	int diag;
+	struct task_struct *kdb_current = kdb_curr_task(smp_processor_id());
+
+#ifdef CONFIG_KDB_KDUMP
+	kdb_kdump_check(regs);
+#endif
+
+	/* If kdb has been entered for an event which has been/will be
+	 * recovered then silently return.  We have to get this far into kdb in
+	 * order to synchronize all the cpus, typically only one cpu (monarch)
+	 * knows that the event is recoverable but the other cpus (slaves) may
+	 * also be driven into kdb before that decision is made by the monarch.
+	 *
+	 * To pause in kdb even for recoverable events, 'set RECOVERY_PAUSE 1'
+	 */
+	KDB_DEBUG_STATE("kdb_local 1", reason);
+	if (reason == KDB_REASON_ENTER
+	    && KDB_FLAG(RECOVERY)
+	    && !KDB_FLAG(CATASTROPHIC)) {
+		int recovery_pause = 0;
+		kdbgetintenv("RECOVERY_PAUSE", &recovery_pause);
+		if (recovery_pause == 0)
+			reason = KDB_REASON_SILENT;
+		else
+			kdb_printf("%s: Recoverable error detected but"
+				   " RECOVERY_PAUSE is set, staying in KDB\n",
+				   __FUNCTION__);
+	}
+
+	KDB_DEBUG_STATE("kdb_local 2", reason);
+	kdb_go_count = 0;
+	if (kdb_quiet(reason)) {
+		/* no message */
+	} else if (reason == KDB_REASON_DEBUG) {
+		/* special case below */
+	} else {
+		kdb_printf("\nEntering kdb (current=0x%p, pid %d) ", kdb_current, kdb_current->pid);
+#if defined(CONFIG_SMP)
+		kdb_printf("on processor %d ", smp_processor_id());
+#endif
+	}
+
+	switch (reason) {
+	case KDB_REASON_DEBUG:
+	{
+		/*
+		 * If re-entering kdb after a single step
+		 * command, don't print the message.
+		 */
+		switch(db_result) {
+		case KDB_DB_BPT:
+			kdb_printf("\nEntering kdb (0x%p, pid %d) ", kdb_current, kdb_current->pid);
+#if defined(CONFIG_SMP)
+			kdb_printf("on processor %d ", smp_processor_id());
+#endif
+			kdb_printf("due to Debug @ " kdb_machreg_fmt "\n", kdba_getpc(regs));
+			break;
+		case KDB_DB_SSB:
+			/*
+			 * In the midst of ssb command. Just return.
+			 */
+			KDB_DEBUG_STATE("kdb_local 3", reason);
+			return KDB_CMD_SSB;	/* Continue with SSB command */
+
+			break;
+		case KDB_DB_SS:
+			break;
+		case KDB_DB_SSBPT:
+			KDB_DEBUG_STATE("kdb_local 4", reason);
+			return 1;	/* kdba_db_trap did the work */
+		default:
+			kdb_printf("kdb: Bad result from kdba_db_trap: %d\n",
+				   db_result);
+			break;
+		}
+
+	}
+		break;
+	case KDB_REASON_ENTER:
+		if (KDB_STATE(KEYBOARD))
+			kdb_printf("due to Keyboard Entry\n");
+		else {
+			kdb_printf("due to KDB_ENTER()\n");
+		}
+		break;
+	case KDB_REASON_KEYBOARD:
+		KDB_STATE_SET(KEYBOARD);
+		kdb_printf("due to Keyboard Entry\n");
+		break;
+	case KDB_REASON_ENTER_SLAVE:	/* drop through, slaves only get released via cpu switch */
+	case KDB_REASON_SWITCH:
+		kdb_printf("due to cpu switch\n");
+		if (KDB_STATE(GO_SWITCH)) {
+			KDB_STATE_CLEAR(GO_SWITCH);
+			KDB_DEBUG_STATE("kdb_local 5", reason);
+			return KDB_CMD_GO;
+		}
+		break;
+	case KDB_REASON_OOPS:
+		kdb_printf("Oops: %s\n", kdb_diemsg);
+		kdb_printf("due to oops @ " kdb_machreg_fmt "\n", kdba_getpc(regs));
+		kdba_dumpregs(regs, NULL, NULL);
+		break;
+	case KDB_REASON_NMI:
+		kdb_printf("due to NonMaskable Interrupt @ " kdb_machreg_fmt "\n",
+			  kdba_getpc(regs));
+		kdba_dumpregs(regs, NULL, NULL);
+		break;
+	case KDB_REASON_SSTEP:
+	case KDB_REASON_BREAK:
+		kdb_printf("due to %s @ " kdb_machreg_fmt "\n",
+				   reason == KDB_REASON_BREAK ? "Breakpoint" : "SS trap", kdba_getpc(regs));
+		/*
+		 * Determine if this breakpoint is one that we
+		 * are interested in.
+		 */
+		if (db_result != KDB_DB_BPT) {
+			kdb_printf("kdb: error return from kdba_bp_trap: %d\n", db_result);
+			KDB_DEBUG_STATE("kdb_local 6", reason);
+			return 0;	/* Not for us, dismiss it */
+		}
+		break;
+	case KDB_REASON_RECURSE:
+		kdb_printf("due to Recursion @ " kdb_machreg_fmt "\n", kdba_getpc(regs));
+		break;
+	case KDB_REASON_CPU_UP:
+	case KDB_REASON_SILENT:
+		KDB_DEBUG_STATE("kdb_local 7", reason);
+		//		if (reason == KDB_REASON_CPU_UP)
+		//			kdba_cpu_up();
+		// HACK HACK HACK
+		return KDB_CMD_GO;	/* Silent entry, silent exit */
+		break;
+	default:
+		kdb_printf("kdb: unexpected reason code: %d\n", reason);
+		KDB_DEBUG_STATE("kdb_local 8", reason);
+		return 0;	/* Not for us, dismiss it */
+	}
+
+	//	kdba_local_arch_setup();
+	// HACK HACK HACK
+
+	// kdba_set_current_task(kdb_current);
+	// HACK HACK HACK
+
+	while (1) {
+		/*
+		 * Initialize pager context.
+		 */
+		kdb_nextline = 1;
+		KDB_STATE_CLEAR(SUPPRESS);
+#ifdef kdba_setjmp
+		/*
+		 * Use kdba_setjmp/kdba_longjmp to break out of
+		 * the pager early and to attempt to recover from kdb errors.
+		 */
+		KDB_STATE_CLEAR(LONGJMP);
+		if (kdbjmpbuf) {
+			if (kdba_setjmp(&kdbjmpbuf[smp_processor_id()])) {
+				/* Command aborted (usually in pager) */
+				continue;
+			}
+			else
+				KDB_STATE_SET(LONGJMP);
+		}
+#endif	/* kdba_setjmp */
+
+		cmdbuf = cmd_cur;
+		*cmdbuf = '\0';
+		*(cmd_hist[cmd_head])='\0';
+
+		if (KDB_FLAG(ONLY_DO_DUMP)) {
+			/* kdb is off but a catastrophic error requires a dump.
+			 * Take the dump and reboot.
+			 * Turn on logging so the kdb output appears in the log
+			 * buffer in the dump.
+			 */
+			const char *setargs[] = { "set", "LOGGING", "1" };
+			kdb_set(2, setargs);
+			kdb_do_dump();
+			kdb_reboot(0, NULL);
+			/*NOTREACHED*/
+		}
+
+do_full_getstr:
+#if defined(CONFIG_SMP)
+		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"), smp_processor_id());
+#else
+		//		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"));
+		snprintf(kdb_prompt_str, CMD_BUFLEN, "KDB>");
+#endif
+		if (defcmd_in_progress)
+			strncat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
+
+		/*
+		 * Fetch command from keyboard
+		 */
+		cmdbuf = kdb_getstr(cmdbuf, CMD_BUFLEN, kdb_prompt_str);
+		if (*cmdbuf != '\n') {
+			if (*cmdbuf < 32) {
+				if(cmdptr == cmd_head) {
+					strncpy(cmd_hist[cmd_head], cmd_cur, CMD_BUFLEN);
+					*(cmd_hist[cmd_head]+strlen(cmd_hist[cmd_head])-1) = '\0';
+				}
+				if(!handle_ctrl_cmd(cmdbuf))
+					*(cmd_cur+strlen(cmd_cur)-1) = '\0';
+				cmdbuf = cmd_cur;
+				goto do_full_getstr;
+			}
+			else
+				strncpy(cmd_hist[cmd_head], cmd_cur, CMD_BUFLEN);
+
+			cmd_head = (cmd_head+1) % KDB_CMD_HISTORY_COUNT;
+			if (cmd_head == cmd_tail) cmd_tail = (cmd_tail+1) % KDB_CMD_HISTORY_COUNT;
+
+		}
+
+		cmdptr = cmd_head;
+		diag = kdb_parse(cmdbuf);
+		if (diag == KDB_NOTFOUND) {
+			kdb_printf("Unknown kdb command: '%s'\n", cmdbuf);
+			diag = 0;
+		}
+		if (diag == KDB_CMD_GO
+		 || diag == KDB_CMD_CPU
+		 || diag == KDB_CMD_SS
+		 || diag == KDB_CMD_SSB
+		 || diag == KDB_CMD_KGDB)
+			break;
+
+		if (diag)
+			kdb_cmderror(diag);
+	}
+
+	// kdba_local_arch_cleanup();
+	// HACK HACK HACK
+
+	KDB_DEBUG_STATE("kdb_local 9", diag);
+	return diag;
+}
+
+
+/*
+ * kdb_print_state
+ *
+ *	Print the state data for the current processor for debugging.
+ *
+ * Inputs:
+ *	text		Identifies the debug point
+ *	value		Any integer value to be printed, e.g. reason code.
+ * Returns:
+ *	None.
+ * Locking:
+ *	none
+ * Remarks:
+ *	none
+ */
+
+void kdb_print_state(const char *text, int value)
+{
+	kdb_printf("state: %s cpu %d value %d initial %d state %x\n",
+		text, smp_processor_id(), value, kdb_initial_cpu, kdb_state[smp_processor_id()]);
+}
+
+/*
+ * kdb_wait_for_cpus
+ *
+ * Invoked once at the start of a kdb event, from the controlling cpu.  Wait a
+ * short period for the other cpus to enter kdb state.
+ *
+ * Inputs:
+ *	none
+ * Returns:
+ *	none
+ * Locking:
+ *	none
+ * Remarks:
+ *	none
+ */
+
+int kdb_wait_for_cpus_secs;
+
+/*
+ * kdb_main_loop
+ *
+ * The main kdb loop.  After initial setup and assignment of the controlling
+ * cpu, all cpus are in this loop.  One cpu is in control and will issue the kdb
+ * prompt, the others will spin until 'go' or cpu switch.
+ *
+ * To get a consistent view of the kernel stacks for all processes, this routine
+ * is invoked from the main kdb code via an architecture specific routine.
+ * kdba_main_loop is responsible for making the kernel stacks consistent for all
+ * processes, there should be no difference between a blocked process and a
+ * running process as far as kdb is concerned.
+ *
+ * Inputs:
+ *	reason		The reason KDB was invoked
+ *	error		The hardware-defined error code
+ *	reason2		kdb's current reason code.  Initially error but can change
+ *			acording to kdb state.
+ *	db_result	Result code from break or debug point.
+ *	regs		The exception frame at time of fault/breakpoint.  If reason
+ *			is SILENT or CPU_UP then regs is NULL, otherwise it
+ *			should always be valid.
+ * Returns:
+ *	0	KDB was invoked for an event which it wasn't responsible
+ *	1	KDB handled the event for which it was invoked.
+ * Locking:
+ *	none
+ * Remarks:
+ *	none
+ */
+
+int
+kdb_main_loop(kdb_reason_t reason, kdb_reason_t reason2, int error,
+	      kdb_dbtrap_t db_result, struct pt_regs *regs)
+{
+	int result = 1;
+	/* Stay in kdb() until 'go', 'ss[b]' or an error */
+	while (1) {
+		/*
+		 * All processors except the one that is in control
+		 * will spin here.
+		 */
+		KDB_DEBUG_STATE("kdb_main_loop 1", reason);
+		while (KDB_STATE(HOLD_CPU)) {
+			/* state KDB is turned off by kdb_cpu to see if the
+			 * other cpus are still live, each cpu in this loop
+			 * turns it back on.
+			 */
+			if (!KDB_STATE(KDB)) {
+				KDB_STATE_SET(KDB);
+			}
+
+#if defined(CONFIG_KDB_KDUMP)
+			if (KDB_STATE(KEXEC)) {
+				struct pt_regs r;
+				if (regs == NULL)
+					regs = &r;
+
+				kdba_kdump_shutdown_slave(regs);
+				return 0;
+			}
+#endif
+		}
+
+		KDB_STATE_CLEAR(SUPPRESS);
+		KDB_DEBUG_STATE("kdb_main_loop 2", reason);
+		if (KDB_STATE(LEAVING))
+			break;	/* Another cpu said 'go' */
+
+		//		if (!kdb_quiet(reason))
+		//			kdb_wait_for_cpus();
+		/* Still using kdb, this processor is in control */
+		result = kdb_local(reason2, error, regs, db_result);
+		KDB_DEBUG_STATE("kdb_main_loop 3", result);
+
+		if (result == KDB_CMD_CPU) {
+			/* Cpu switch, hold the current cpu, release the target one. */
+			reason2 = KDB_REASON_SWITCH;
+			KDB_STATE_SET(HOLD_CPU);
+			KDB_STATE_CLEAR_CPU(HOLD_CPU, kdb_new_cpu);
+			continue;
+		}
+
+		if (result == KDB_CMD_SS) {
+			KDB_STATE_SET(DOING_SS);
+			break;
+		}
+
+		if (result == KDB_CMD_SSB) {
+			KDB_STATE_SET(DOING_SS);
+			KDB_STATE_SET(DOING_SSB);
+			break;
+
+		}
+
+		if (result == KDB_CMD_KGDB) {
+			if (!(KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)))
+				kdb_printf("Entering please attach debugger or use $D#44+ or $3#33\n");
+			break;
+		}
+		if (result && result != 1 && result != KDB_CMD_GO)
+			kdb_printf("\nUnexpected kdb_local return code %d\n", result);
+
+		KDB_DEBUG_STATE("kdb_main_loop 4", reason);
+		break;
+	}
+	if (KDB_STATE(DOING_SS))
+		KDB_STATE_CLEAR(SSBPT);
+
+	return result;
+}
+
+/*
+ * kdb_mdr
+ *
+ *	This function implements the guts of the 'mdr' command.
+ *
+ *	mdr  <addr arg>,<byte count>
+ *
+ * Inputs:
+ *	addr	Start address
+ *	count	Number of bytes
+ * Outputs:
+ *	None.
+ * Returns:
+ *	Always 0.  Any errors are detected and printed by kdb_getarea.
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_mdr(kdb_machreg_t addr, unsigned int count)
+{
+	unsigned char c;
+	while (count--) {
+		if (kdb_getarea(c, addr))
+			return 0;
+		kdb_printf("%02x", c);
+		addr++;
+	}
+	kdb_printf("\n");
+	return 0;
+}
+
+/*
+ * kdb_md
+ *
+ *	This function implements the 'md', 'md1', 'md2', 'md4', 'md8'
+ *	'mdr' and 'mds' commands.
+ *
+ *	md|mds  [<addr arg> [<line count> [<radix>]]]
+ *	mdWcN	[<addr arg> [<line count> [<radix>]]]
+ *		where W = is the width (1, 2, 4 or 8) and N is the count.
+ *		for eg., md1c20 reads 20 bytes, 1 at a time.
+ *	mdr  <addr arg>,<byte count>
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static void
+kdb_md_line(const char *fmtstr, kdb_machreg_t addr,
+	    int symbolic, int nosect, int bytesperword,
+	    int num, int repeat, int phys)
+{
+	/* print just one line of data */
+	kdb_symtab_t symtab;
+	char cbuf[32];
+	char *c = cbuf;
+	int i;
+	unsigned long word;
+
+	memset(cbuf, '\0', sizeof(cbuf));
+	if (phys)
+		kdb_printf("phys " kdb_machreg_fmt0 " ", addr);
+	else
+		kdb_printf(kdb_machreg_fmt0 " ", addr);
+
+	for (i = 0; i < num && repeat--; i++) {
+		if (phys) {
+			if (kdb_getphysword(&word, addr, bytesperword))
+				break;
+		} else if (kdb_getword(&word, addr, bytesperword))
+			break;
+		kdb_printf(fmtstr, word);
+		if (symbolic)
+			kdbnearsym(word, &symtab);
+		else
+			memset(&symtab, 0, sizeof(symtab));
+		if (symtab.sym_name) {
+			kdb_symbol_print(word, &symtab, 0);
+			if (!nosect) {
+				kdb_printf("\n");
+				kdb_printf("                       %s %s "
+					   kdb_machreg_fmt " " kdb_machreg_fmt " " kdb_machreg_fmt,
+					symtab.mod_name,
+					symtab.sec_name,
+					symtab.sec_start,
+					symtab.sym_start,
+					symtab.sym_end);
+			}
+			addr += bytesperword;
+		} else {
+			union {
+				u64 word;
+				unsigned char c[8];
+			} wc;
+			unsigned char *cp;
+#ifdef	__BIG_ENDIAN
+			cp = wc.c + 8 - bytesperword;
+#else
+			cp = wc.c;
+#endif
+			wc.word = word;
+#define printable_char(c) ({unsigned char __c = c; isascii(__c) && isprint(__c) ? __c : '.';})
+			switch (bytesperword) {
+			case 8:
+				*c++ = printable_char(*cp++);
+				*c++ = printable_char(*cp++);
+				*c++ = printable_char(*cp++);
+				*c++ = printable_char(*cp++);
+				addr += 4;
+			case 4:
+				*c++ = printable_char(*cp++);
+				*c++ = printable_char(*cp++);
+				addr += 2;
+			case 2:
+				*c++ = printable_char(*cp++);
+				addr++;
+			case 1:
+				*c++ = printable_char(*cp++);
+				addr++;
+				break;
+			}
+#undef printable_char
+		}
+	}
+	kdb_printf("%*s %s\n", (int)((num-i)*(2*bytesperword + 1)+1), " ", cbuf);
+}
+
+static int
+kdb_md(int argc, const char **argv)
+{
+	static kdb_machreg_t last_addr;
+	static int last_radix, last_bytesperword, last_repeat;
+	int radix = 16, mdcount = 8, bytesperword = KDB_WORD_SIZE, repeat;
+	int nosect = 0;
+	char fmtchar, fmtstr[64];
+	kdb_machreg_t addr;
+	unsigned long word;
+	long offset = 0;
+	int symbolic = 0;
+	int valid = 0;
+	int phys = 0;
+
+	kdbgetintenv("MDCOUNT", &mdcount);
+	kdbgetintenv("RADIX", &radix);
+	kdbgetintenv("BYTESPERWORD", &bytesperword);
+
+	/* Assume 'md <addr>' and start with environment values */
+	repeat = mdcount * 16 / bytesperword;
+
+	if (strcmp(argv[0], "mdr") == 0) {
+		if (argc != 2)
+			return KDB_ARGCOUNT;
+		valid = 1;
+	} else if (isdigit(argv[0][2])) {
+		bytesperword = (int)(argv[0][2] - '0');
+		if (bytesperword == 0) {
+			bytesperword = last_bytesperword;
+			if (bytesperword == 0) {
+				bytesperword = 4;
+			}
+		}
+		last_bytesperword = bytesperword;
+		repeat = mdcount * 16 / bytesperword;
+		if (!argv[0][3])
+			valid = 1;
+		else if (argv[0][3] == 'c' && argv[0][4]) {
+			char *p;
+			repeat = simple_strtoul(argv[0]+4, &p, 10);
+			mdcount = ((repeat * bytesperword) + 15) / 16;
+			valid = !*p;
+		}
+		last_repeat = repeat;
+	} else if (strcmp(argv[0], "md") == 0)
+		valid = 1;
+	else if (strcmp(argv[0], "mds") == 0)
+		valid = 1;
+	else if (strcmp(argv[0], "mdp") == 0) {
+		phys = valid = 1;
+	}
+	if (!valid)
+		return KDB_NOTFOUND;
+
+	if (argc == 0) {
+		if (last_addr == 0)
+			return KDB_ARGCOUNT;
+		addr = last_addr;
+		radix = last_radix;
+		bytesperword = last_bytesperword;
+		repeat = last_repeat;
+		mdcount = ((repeat * bytesperword) + 15) / 16;
+	}
+
+	if (argc) {
+		kdb_machreg_t val;
+		int diag, nextarg = 1;
+		diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+		if (diag)
+			return diag;
+		if (argc > nextarg+2)
+			return KDB_ARGCOUNT;
+
+		if (argc >= nextarg) {
+			diag = kdbgetularg(argv[nextarg], &val);
+			if (!diag) {
+				mdcount = (int) val;
+				repeat = mdcount * 16 / bytesperword;
+			}
+		}
+		if (argc >= nextarg+1) {
+			diag = kdbgetularg(argv[nextarg+1], &val);
+			if (!diag)
+				radix = (int) val;
+		}
+	}
+
+	if (strcmp(argv[0], "mdr") == 0) {
+		return kdb_mdr(addr, mdcount);
+	}
+
+	switch (radix) {
+	case 10:
+		fmtchar = 'd';
+		break;
+	case 16:
+		fmtchar = 'x';
+		break;
+	case 8:
+		fmtchar = 'o';
+		break;
+	default:
+		return KDB_BADRADIX;
+	}
+
+	last_radix = radix;
+
+	if (bytesperword > KDB_WORD_SIZE)
+		return KDB_BADWIDTH;
+
+	switch (bytesperword) {
+	case 8:
+		sprintf(fmtstr, "%%16.16l%c ", fmtchar);
+		break;
+	case 4:
+		sprintf(fmtstr, "%%8.8l%c ", fmtchar);
+		break;
+	case 2:
+		sprintf(fmtstr, "%%4.4l%c ", fmtchar);
+		break;
+	case 1:
+		sprintf(fmtstr, "%%2.2l%c ", fmtchar);
+		break;
+	default:
+		return KDB_BADWIDTH;
+	}
+
+	last_repeat = repeat;
+	last_bytesperword = bytesperword;
+
+	if (strcmp(argv[0], "mds") == 0) {
+		symbolic = 1;
+		/* Do not save these changes as last_*, they are temporary mds
+		 * overrides.
+		 */
+		bytesperword = KDB_WORD_SIZE;
+		repeat = mdcount;
+		kdbgetintenv("NOSECT", &nosect);
+	}
+
+	/* Round address down modulo BYTESPERWORD */
+
+	addr &= ~(bytesperword-1);
+
+	while (repeat > 0) {
+		unsigned long a;
+		int n, z, num = (symbolic ? 1 : (16 / bytesperword));
+
+		for (a = addr, z = 0; z < repeat; a += bytesperword, ++z) {
+			if (phys) {
+				if (kdb_getphysword(&word, a, bytesperword)
+						|| word)
+					break;
+			} else if (kdb_getword(&word, a, bytesperword) || word)
+				break;
+		}
+		n = min(num, repeat);
+		kdb_md_line(fmtstr, addr, symbolic, nosect, bytesperword, num, repeat, phys);
+		addr += bytesperword * n;
+		repeat -= n;
+		z = (z + num - 1) / num;
+		if (z > 2) {
+			int s = num * (z-2);
+			kdb_printf(kdb_machreg_fmt0 "-" kdb_machreg_fmt0 " zero suppressed\n",
+				addr, addr + bytesperword * s - 1);
+			addr += bytesperword * s;
+			repeat -= s;
+		}
+	}
+	last_addr = addr;
+
+	return 0;
+}
+
+/*
+ * kdb_mm
+ *
+ *	This function implements the 'mm' command.
+ *
+ *	mm address-expression new-value
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	mm works on machine words, mmW works on bytes.
+ */
+
+static int
+kdb_mm(int argc, const char **argv)
+{
+	int diag;
+	kdb_machreg_t addr;
+	long offset = 0;
+	unsigned long contents;
+	int nextarg;
+	int width;
+
+	if (argv[0][2] && !isdigit(argv[0][2]))
+		return KDB_NOTFOUND;
+
+	if (argc < 2) {
+		return KDB_ARGCOUNT;
+	}
+
+	nextarg = 1;
+	if ((diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL)))
+		return diag;
+
+	if (nextarg > argc)
+		return KDB_ARGCOUNT;
+
+	if ((diag = kdbgetaddrarg(argc, argv, &nextarg, &contents, NULL, NULL)))
+		return diag;
+
+	if (nextarg != argc + 1)
+		return KDB_ARGCOUNT;
+
+	width = argv[0][2] ? (argv[0][2] - '0') : (KDB_WORD_SIZE);
+	if ((diag = kdb_putword(addr, contents, width)))
+		return diag;
+
+	kdb_printf(kdb_machreg_fmt " = " kdb_machreg_fmt "\n", addr, contents);
+
+	return 0;
+}
+
+/*
+ * kdb_go
+ *
+ *	This function implements the 'go' command.
+ *
+ *	go [address-expression]
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	KDB_CMD_GO for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_go(int argc, const char **argv)
+{
+	kdb_machreg_t addr;
+	int diag;
+	int nextarg;
+	long offset;
+	// HACK HACK HACK
+	//	struct pt_regs *regs = get_irq_regs();
+
+	if (argc == 1) {
+		if (smp_processor_id() != kdb_initial_cpu) {
+			kdb_printf("go <address> must be issued from the initial cpu, do cpu %d first\n", kdb_initial_cpu);
+			return KDB_ARGCOUNT;
+		}
+		nextarg = 1;
+		diag = kdbgetaddrarg(argc, argv, &nextarg,
+				     &addr, &offset, NULL);
+		if (diag)
+			return diag;
+
+		//kdba_setpc(regs, addr);
+		// HACK HACK HACK
+
+	} else if (argc)
+		return KDB_ARGCOUNT;
+
+	diag = KDB_CMD_GO;
+	if (KDB_FLAG(CATASTROPHIC)) {
+		kdb_printf("Catastrophic error detected\n");
+		kdb_printf("kdb_continue_catastrophic=%d, ",
+			kdb_continue_catastrophic);
+		if (kdb_continue_catastrophic == 0 && kdb_go_count++ == 0) {
+			kdb_printf("type go a second time if you really want to continue\n");
+			return 0;
+		}
+		if (kdb_continue_catastrophic == 2) {
+			kdb_do_dump();
+			kdb_printf("forcing reboot\n");
+			kdb_reboot(0, NULL);
+		}
+		kdb_printf("attempting to continue\n");
+	}
+	if (smp_processor_id() != kdb_initial_cpu) {
+		char buf[80];
+		kdb_printf("go was not issued from initial cpu, switching back to cpu %d\n", kdb_initial_cpu);
+		sprintf(buf, "cpu %d\n", kdb_initial_cpu);
+		/* Recursive use of kdb_parse, do not use argv after this point */
+		argv = NULL;
+		diag = kdb_parse(buf);
+		if (diag == KDB_CMD_CPU)
+			KDB_STATE_SET_CPU(GO_SWITCH, kdb_initial_cpu);
+	}
+	return diag;
+}
+
+/*
+ * kdb_rd
+ *
+ *	This function implements the 'rd' command.
+ *
+ *	rd		display all general registers.
+ *	rd  c		display all control registers.
+ *	rd  d		display all debug registers.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_rd(int argc, const char **argv)
+{
+	int diag;
+	if (argc == 0) {
+		if ((diag = kdb_check_regs()))
+			return diag;
+		return kdba_dumpregs(kdb_current_regs, NULL, NULL);
+	}
+
+	if (argc > 2) {
+		return KDB_ARGCOUNT;
+	}
+
+	if ((diag = kdb_check_regs()))
+		return diag;
+	return kdba_dumpregs(kdb_current_regs, argv[1], argc==2 ? argv[2]: NULL);
+}
+
+/*
+ * kdb_rm
+ *
+ *	This function implements the 'rm' (register modify)  command.
+ *
+ *	rm register-name new-contents
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	Currently doesn't allow modification of control or
+ *	debug registers.
+ */
+
+static int
+kdb_rm(int argc, const char **argv)
+{
+	int diag;
+	int ind = 0;
+	kdb_machreg_t contents;
+
+	if (argc != 2) {
+		return KDB_ARGCOUNT;
+	}
+
+	/*
+	 * Allow presence or absence of leading '%' symbol.
+	 */
+
+	if (argv[1][0] == '%')
+		ind = 1;
+
+	diag = kdbgetularg(argv[2], &contents);
+	if (diag)
+		return diag;
+
+	if ((diag = kdb_check_regs()))
+		return diag;
+	//	diag = kdba_setregcontents(&argv[1][ind], kdb_current_regs, contents);
+	// HACK HACK HACK
+	diag = 0;
+
+	if (diag)
+		return diag;
+
+	return 0;
+}
+
+#if defined(CONFIG_MAGIC_SYSRQ)
+/*
+ * kdb_sr
+ *
+ *	This function implements the 'sr' (SYSRQ key) command which
+ *	interfaces to the soi-disant MAGIC SYSRQ functionality.
+ *
+ *	sr <magic-sysrq-code>
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	None.
+ */
+static int
+kdb_sr(int argc, const char **argv)
+{
+	extern int __sysrq_enabled;
+	if (argc != 1) {
+		return KDB_ARGCOUNT;
+	}
+	if (!__sysrq_enabled) {
+		kdb_printf("Auto activating sysrq\n");
+		__sysrq_enabled = 1;
+	}
+
+	handle_sysrq(*argv[1], NULL);
+
+	return 0;
+}
+#endif	/* CONFIG_MAGIC_SYSRQ */
+
+/*
+ * kdb_ef
+ *
+ *	This function implements the 'regs' (display exception frame)
+ *	command.  This command takes an address and expects to find
+ *	an exception frame at that address, formats and prints it.
+ *
+ *	regs address-expression
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	Not done yet.
+ */
+
+static int
+kdb_ef(int argc, const char **argv)
+{
+	int diag;
+	kdb_machreg_t addr;
+	long offset;
+	int nextarg;
+
+	if (argc == 1) {
+		nextarg = 1;
+		diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+		if (diag)
+			return diag;
+
+		//return kdba_dumpregs((struct pt_regs *)addr, NULL, NULL);
+		// HACK HACK HACK
+		return 0;
+	}
+
+	return KDB_ARGCOUNT;
+}
+
+#if defined(CONFIG_MODULES)
+extern struct list_head *kdb_modules;
+extern void free_module(struct module *);
+
+/* modules using other modules */
+struct module_use
+{
+	struct list_head list;
+	struct module *module_which_uses;
+};
+
+/*
+ * kdb_lsmod
+ *
+ *	This function implements the 'lsmod' command.  Lists currently
+ *	loaded kernel modules.
+ *
+ *	Mostly taken from userland lsmod.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *
+ */
+
+static int
+kdb_lsmod(int argc, const char **argv)
+{
+	struct module *mod;
+
+	if (argc != 0)
+		return KDB_ARGCOUNT;
+
+	kdb_printf("Module                  Size  modstruct     Used by\n");
+	list_for_each_entry(mod, kdb_modules, list) {
+
+		kdb_printf("%-20s%8u  0x%p ", mod->name,
+			   mod->core_size, (void *)mod);
+#ifdef CONFIG_MODULE_UNLOAD
+		kdb_printf("%4d ", module_refcount(mod));
+#endif
+		if (mod->state == MODULE_STATE_GOING)
+			kdb_printf(" (Unloading)");
+		else if (mod->state == MODULE_STATE_COMING)
+			kdb_printf(" (Loading)");
+		else
+			kdb_printf(" (Live)");
+
+#ifdef CONFIG_MODULE_UNLOAD
+		{
+			struct module_use *use;
+			kdb_printf(" [ ");
+			list_for_each_entry(use, &mod->modules_which_use_me, list)
+				kdb_printf("%s ", use->module_which_uses->name);
+			kdb_printf("]\n");
+		}
+#endif
+	}
+
+	return 0;
+}
+
+#endif	/* CONFIG_MODULES */
+
+/*
+ * kdb_env
+ *
+ *	This function implements the 'env' command.  Display the current
+ *	environment variables.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_env(int argc, const char **argv)
+{
+	int i;
+
+	for(i=0; i<__nenv; i++) {
+		if (__env[i]) {
+			kdb_printf("%s\n", __env[i]);
+		}
+	}
+
+	if (KDB_DEBUG(MASK))
+		kdb_printf("KDBFLAGS=0x%x\n", kdb_flags);
+
+	return 0;
+}
+
+/*
+ * kdb_dmesg
+ *
+ *	This function implements the 'dmesg' command to display the contents
+ *	of the syslog buffer.
+ *
+ *	dmesg [lines] [adjust]
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	None.
+ */
+
+static int
+kdb_dmesg(int argc, const char **argv)
+{
+	char *syslog_data[4], *start, *end, c = '\0', *p;
+	int diag, logging, logsize, lines = 0, adjust = 0, n;
+
+	if (argc > 2)
+		return KDB_ARGCOUNT;
+	if (argc) {
+		char *cp;
+		lines = simple_strtol(argv[1], &cp, 0);
+		if (*cp)
+			lines = 0;
+		if (argc > 1) {
+			adjust = simple_strtoul(argv[2], &cp, 0);
+			if (*cp || adjust < 0)
+				adjust = 0;
+		}
+	}
+
+	/* disable LOGGING if set */
+	diag = kdbgetintenv("LOGGING", &logging);
+	if (!diag && logging) {
+		const char *setargs[] = { "set", "LOGGING", "0" };
+		kdb_set(2, setargs);
+	}
+
+	/* syslog_data[0,1] physical start, end+1.  syslog_data[2,3] logical start, end+1. */
+	kdb_syslog_data(syslog_data);
+	if (syslog_data[2] == syslog_data[3])
+		return 0;
+	logsize = syslog_data[1] - syslog_data[0];
+	start = syslog_data[2];
+	end = syslog_data[3];
+#define KDB_WRAP(p) (((p - syslog_data[0]) % logsize) + syslog_data[0])
+	for (n = 0, p = start; p < end; ++p) {
+		if ((c = *KDB_WRAP(p)) == '\n')
+			++n;
+	}
+	if (c != '\n')
+		++n;
+	if (lines < 0) {
+		if (adjust >= n)
+			kdb_printf("buffer only contains %d lines, nothing printed\n", n);
+		else if (adjust - lines >= n)
+			kdb_printf("buffer only contains %d lines, last %d lines printed\n",
+				n, n - adjust);
+		if (adjust) {
+			for (; start < end && adjust; ++start) {
+				if (*KDB_WRAP(start) == '\n')
+					--adjust;
+			}
+			if (start < end)
+				++start;
+		}
+		for (p = start; p < end && lines; ++p) {
+			if (*KDB_WRAP(p) == '\n')
+				++lines;
+		}
+		end = p;
+	} else if (lines > 0) {
+		int skip = n - (adjust + lines);
+		if (adjust >= n) {
+			kdb_printf("buffer only contains %d lines, nothing printed\n", n);
+			skip = n;
+		} else if (skip < 0) {
+			lines += skip;
+			skip = 0;
+			kdb_printf("buffer only contains %d lines, first %d lines printed\n",
+				n, lines);
+		}
+		for (; start < end && skip; ++start) {
+			if (*KDB_WRAP(start) == '\n')
+				--skip;
+		}
+		for (p = start; p < end && lines; ++p) {
+			if (*KDB_WRAP(p) == '\n')
+				--lines;
+		}
+		end = p;
+	}
+	/* Do a line at a time (max 200 chars) to reduce protocol overhead */
+	c = '\n';
+	while (start != end) {
+		char buf[201];
+	       	p = buf;
+		while (start < end && (c = *KDB_WRAP(start)) && (p - buf) < sizeof(buf)-1) {
+			++start;
+			*p++ = c;
+			if (c == '\n')
+				break;
+		}
+		*p = '\0';
+		kdb_printf("%s", buf);
+	}
+	if (c != '\n')
+		kdb_printf("\n");
+
+	return 0;
+}
+
+/*
+ * kdb_cpu
+ *
+ *	This function implements the 'cpu' command.
+ *
+ *	cpu	[<cpunum>]
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	KDB_CMD_CPU for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ *	All cpu's should be spinning in kdb().  However just in case
+ *	a cpu did not take the smp_kdb_stop NMI, check that a cpu
+ *	entered kdb() before passing control to it.
+ */
+
+static void
+kdb_cpu_status(void)
+{
+	int i, start_cpu, first_print = 1;
+	char state, prev_state = '?';
+
+	kdb_printf("Currently on cpu %d\n", smp_processor_id());
+	kdb_printf("Available cpus: ");
+	for (start_cpu = -1, i = 0; i < NR_CPUS; i++) {
+		if (!cpu_online(i))
+			state = 'F';	/* cpu is offline */
+		else {
+			struct kdb_running_process *krp = kdb_running_process+i;
+			if (KDB_STATE_CPU(KDB, i)) {
+				state = ' ';	/* cpu is responding to kdb */
+				if (kdb_task_state_char(krp->p) == 'I')
+					state = 'I';	/* running the idle task */
+			} else if (krp->seqno && krp->p && krp->seqno >= kdb_seqno - 1)
+				state = '+';	/* some kdb data, but not responding */
+			else
+				state = '*';	/* no kdb data */
+		}
+		if (state != prev_state) {
+			if (prev_state != '?') {
+				if (!first_print)
+					kdb_printf(", ");
+				first_print = 0;
+				kdb_printf("%d", start_cpu);
+				if (start_cpu < i-1)
+					kdb_printf("-%d", i-1);
+				if (prev_state != ' ')
+					kdb_printf("(%c)", prev_state);
+			}
+			prev_state = state;
+			start_cpu = i;
+		}
+	}
+	/* print the trailing cpus, ignoring them if they are all offline */
+	if (prev_state != 'F') {
+		if (!first_print)
+			kdb_printf(", ");
+		kdb_printf("%d", start_cpu);
+		if (start_cpu < i-1)
+			kdb_printf("-%d", i-1);
+		if (prev_state != ' ')
+			kdb_printf("(%c)", prev_state);
+	}
+	kdb_printf("\n");
+}
+
+static int
+kdb_cpu(int argc, const char **argv)
+{
+	unsigned long cpunum;
+	int diag, i;
+
+	/* ask the other cpus if they are still active */
+	for (i=0; i<NR_CPUS; i++) {
+		if (cpu_online(i))
+			KDB_STATE_CLEAR_CPU(KDB, i);
+	}
+	KDB_STATE_SET(KDB);
+	barrier();
+	/* wait for the other cpus to notice and set state KDB again,
+	 * see kdb_main_loop
+	 */
+	udelay(1000);
+
+	if (argc == 0) {
+		kdb_cpu_status();
+		return 0;
+	}
+
+	if (argc != 1)
+		return KDB_ARGCOUNT;
+
+	diag = kdbgetularg(argv[1], &cpunum);
+	if (diag)
+		return diag;
+
+	/*
+	 * Validate cpunum
+	 */
+	if ((cpunum > NR_CPUS)
+	 || !cpu_online(cpunum)
+	 || !KDB_STATE_CPU(KDB, cpunum))
+		return KDB_BADCPUNUM;
+
+	kdb_new_cpu = cpunum;
+
+	/*
+	 * Switch to other cpu
+	 */
+	return KDB_CMD_CPU;
+}
+
+/* The user may not realize that ps/bta with no parameters does not print idle
+ * or sleeping system daemon processes, so tell them how many were suppressed.
+ */
+void
+kdb_ps_suppressed(void)
+{
+	int idle = 0, daemon = 0;
+	unsigned long mask_I = kdb_task_state_string("I"),
+		      mask_M = kdb_task_state_string("M");
+	unsigned long cpu;
+	const struct task_struct *p, *g;
+	for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+		if (!cpu_online(cpu))
+			continue;
+		p = kdb_curr_task(cpu);
+		if (kdb_task_state(p, mask_I))
+			++idle;
+	}
+	kdb_do_each_thread(g, p) {
+		if (kdb_task_state(p, mask_M))
+			++daemon;
+	} kdb_while_each_thread(g, p);
+	if (idle || daemon) {
+		if (idle)
+			kdb_printf("%d idle process%s (state I)%s\n",
+				   idle, idle == 1 ? "" : "es",
+				   daemon ? " and " : "");
+		if (daemon)
+			kdb_printf("%d sleeping system daemon (state M) process%s",
+				   daemon, daemon == 1 ? "" : "es");
+		kdb_printf(" suppressed,\nuse 'ps A' to see all.\n");
+	}
+}
+
+/*
+ * kdb_ps
+ *
+ *	This function implements the 'ps' command which shows
+ *	a list of the active processes.
+ *
+ *	ps [DRSTCZEUIMA]		All processes, optionally filtered by state
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+void
+kdb_ps1(const struct task_struct *p)
+{
+	struct kdb_running_process *krp = kdb_running_process + kdb_process_cpu(p);
+	kdb_printf("0x%p %8d %8d  %d %4d   %c  0x%p %c%s\n",
+		   (void *)p, p->pid, p->parent->pid,
+		   kdb_task_has_cpu(p), kdb_process_cpu(p),
+		   kdb_task_state_char(p),
+		   (void *)(&p->thread),
+		   p == kdb_curr_task(smp_processor_id()) ? '*': ' ',
+		   p->comm);
+	if (kdb_task_has_cpu(p)) {
+		if (!krp->seqno || !krp->p)
+			kdb_printf("  Error: no saved data for this cpu\n");
+		else {
+			if (krp->seqno < kdb_seqno - 1)
+				kdb_printf("  Warning: process state is stale\n");
+			if (krp->p != p)
+				kdb_printf("  Error: does not match running process table (0x%p)\n", krp->p);
+		}
+	}
+}
+
+static int
+kdb_ps(int argc, const char **argv)
+{
+	struct task_struct *g, *p;
+	unsigned long mask, cpu;
+
+	if (argc == 0)
+		kdb_ps_suppressed();
+	kdb_printf("%-*s      Pid   Parent [*] cpu State %-*s Command\n",
+		(int)(2*sizeof(void *))+2, "Task Addr",
+		(int)(2*sizeof(void *))+2, "Thread");
+	mask = kdb_task_state_string(argc ? argv[1] : NULL);
+	/* Run the active tasks first */
+	for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+		if (!cpu_online(cpu))
+			continue;
+		p = kdb_curr_task(cpu);
+		if (kdb_task_state(p, mask))
+			kdb_ps1(p);
+	}
+	kdb_printf("\n");
+	/* Now the real tasks */
+	kdb_do_each_thread(g, p) {
+		if (kdb_task_state(p, mask))
+			kdb_ps1(p);
+	} kdb_while_each_thread(g, p);
+
+	return 0;
+}
+
+/*
+ * kdb_pid
+ *
+ *	This function implements the 'pid' command which switches
+ *	the currently active process.
+ *
+ *	pid [<pid> | R]
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+
+static int
+kdb_pid(int argc, const char **argv)
+{
+	struct task_struct *p;
+	unsigned long val;
+	int diag;
+
+	if (argc > 1)
+		return KDB_ARGCOUNT;
+
+	if (argc) {
+		if (strcmp(argv[1], "R") == 0) {
+			p = KDB_RUNNING_PROCESS_ORIGINAL[kdb_initial_cpu].p;
+		} else {
+			diag = kdbgetularg(argv[1], &val);
+			if (diag)
+				return KDB_BADINT;
+
+			p = find_task_by_pid_type_ns(PIDTYPE_PID, (pid_t)val,
+				&init_pid_ns);
+			if (!p) {
+				kdb_printf("No task with pid=%d\n", (pid_t)val);
+				return 0;
+			}
+		}
+
+		//		kdba_set_current_task(p);
+		// HACK HACK HACK
+		printk(KERN_CRIT "DOH NEED TO IMPLEMENT THIS!");
+	}
+
+	kdb_printf("KDB current process is %s(pid=%d)\n", kdb_current_task->comm,
+		   kdb_current_task->pid);
+
+	return 0;
+}
+
+/*
+ * kdb_ll
+ *
+ *	This function implements the 'll' command which follows a linked
+ *	list and executes an arbitrary command for each element.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_ll(int argc, const char **argv)
+{
+	int diag;
+	kdb_machreg_t addr;
+	long offset = 0;
+	kdb_machreg_t va;
+	unsigned long linkoffset;
+	int nextarg;
+	const char *command;
+
+	if (argc != 3) {
+		return KDB_ARGCOUNT;
+	}
+
+	nextarg = 1;
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+	if (diag)
+		return diag;
+
+	diag = kdbgetularg(argv[2], &linkoffset);
+	if (diag)
+		return diag;
+
+	/*
+	 * Using the starting address as
+	 * the first element in the list, and assuming that
+	 * the list ends with a null pointer.
+	 */
+
+	va = addr;
+	if (!(command = kdb_strdup(argv[3], GFP_KDB))) {
+		kdb_printf("%s: cannot duplicate command\n", __FUNCTION__);
+		return 0;
+	}
+	/* Recursive use of kdb_parse, do not use argv after this point */
+	argv = NULL;
+
+	while (va) {
+		char buf[80];
+
+		sprintf(buf, "%s " kdb_machreg_fmt "\n", command, va);
+		diag = kdb_parse(buf);
+		if (diag)
+			return diag;
+
+		addr = va + linkoffset;
+		if (kdb_getword(&va, addr, sizeof(va)))
+			return 0;
+	}
+	kfree(command);
+
+	return 0;
+}
+
+static int
+kdb_kgdb(int argc, const char **argv)
+{
+	return KDB_CMD_KGDB;
+}
+
+/*
+ * kdb_help
+ *
+ *	This function implements the 'help' and '?' commands.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_help(int argc, const char **argv)
+{
+	kdbtab_t *kt;
+	int i;
+
+	kdb_printf("%-15.15s %-20.20s %s\n", "Command", "Usage", "Description");
+	kdb_printf("----------------------------------------------------------\n");
+	for(i=0, kt=kdb_commands; i<kdb_max_commands; i++, kt++) {
+		if (kt->cmd_name)
+			kdb_printf("%-15.15s %-20.20s %s\n", kt->cmd_name,
+				   kt->cmd_usage, kt->cmd_help);
+	}
+	return 0;
+}
+
+extern int kdb_wake_up_process(struct task_struct * p);
+
+/*
+ * kdb_kill
+ *
+ *	This function implements the 'kill' commands.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_kill(int argc, const char **argv)
+{
+	long sig, pid;
+	char *endp;
+	struct task_struct *p;
+	struct siginfo info;
+
+	if (argc!=2)
+		return KDB_ARGCOUNT;
+
+	sig = simple_strtol(argv[1], &endp, 0);
+	if (*endp)
+		return KDB_BADINT;
+	if (sig >= 0 ) {
+		kdb_printf("Invalid signal parameter.<-signal>\n");
+		return 0;
+	}
+	sig=-sig;
+
+	pid = simple_strtol(argv[2], &endp, 0);
+	if (*endp)
+		return KDB_BADINT;
+	if (pid <=0 ) {
+		kdb_printf("Process ID must be large than 0.\n");
+		return 0;
+	}
+
+	/* Find the process. */
+	if (!(p = find_task_by_pid_type_ns(PIDTYPE_PID, pid, &init_pid_ns))) {
+		kdb_printf("The specified process isn't found.\n");
+		return 0;
+	}
+	p = p->group_leader;
+	info.si_signo = sig;
+	info.si_errno = 0;
+	info.si_code = SI_USER;
+	info.si_pid = pid;	/* use same capabilities as process being signalled */
+	info.si_uid = 0;	/* kdb has root authority */
+	kdb_send_sig_info(p, &info, kdb_seqno);
+	return 0;
+}
+
+struct kdb_tm {
+	int tm_sec;	/* seconds */
+	int tm_min;	/* minutes */
+	int tm_hour;	/* hours */
+	int tm_mday;	/* day of the month */
+	int tm_mon;	/* month */
+	int tm_year;	/* year */
+};
+
+static void
+kdb_gmtime(struct timespec *tv, struct kdb_tm *tm)
+{
+	/* This will work from 1970-2099, 2100 is not a leap year */
+	static int mon_day[] = { 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
+	memset(tm, 0, sizeof(*tm));
+	tm->tm_sec  = tv->tv_sec % (24 * 60 * 60);
+	tm->tm_mday = tv->tv_sec / (24 * 60 * 60) + (2 * 365 + 1); /* shift base from 1970 to 1968 */
+	tm->tm_min =  tm->tm_sec / 60 % 60;
+	tm->tm_hour = tm->tm_sec / 60 / 60;
+	tm->tm_sec =  tm->tm_sec % 60;
+	tm->tm_year = 68 + 4*(tm->tm_mday / (4*365+1));
+	tm->tm_mday %= (4*365+1);
+	mon_day[1] = 29;
+	while (tm->tm_mday >= mon_day[tm->tm_mon]) {
+		tm->tm_mday -= mon_day[tm->tm_mon];
+		if (++tm->tm_mon == 12) {
+			tm->tm_mon = 0;
+			++tm->tm_year;
+			mon_day[1] = 28;
+		}
+	}
+	++tm->tm_mday;
+}
+
+/*
+ * Most of this code has been lifted from kernel/timer.c::sys_sysinfo().
+ * I cannot call that code directly from kdb, it has an unconditional
+ * cli()/sti() and calls routines that take locks which can stop the debugger.
+ */
+
+static void
+kdb_sysinfo(struct sysinfo *val)
+{
+	struct timespec uptime;
+	do_posix_clock_monotonic_gettime(&uptime);
+	memset(val, 0, sizeof(*val));
+	val->uptime = uptime.tv_sec;
+	val->loads[0] = avenrun[0];
+	val->loads[1] = avenrun[1];
+	val->loads[2] = avenrun[2];
+	val->procs = nr_threads-1;
+	si_meminfo(val);
+	kdb_si_swapinfo(val);
+
+	return;
+}
+
+/*
+ * kdb_summary
+ *
+ *	This function implements the 'summary' command.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_summary(int argc, const char **argv)
+{
+	extern struct timespec xtime;
+	extern struct timezone sys_tz;
+	struct kdb_tm tm;
+	struct sysinfo val;
+
+	if (argc)
+		return KDB_ARGCOUNT;
+
+	kdb_printf("sysname    %s\n", init_uts_ns.name.sysname);
+	kdb_printf("release    %s\n", init_uts_ns.name.release);
+	kdb_printf("version    %s\n", init_uts_ns.name.version);
+	kdb_printf("machine    %s\n", init_uts_ns.name.machine);
+	kdb_printf("nodename   %s\n", init_uts_ns.name.nodename);
+	kdb_printf("domainname %s\n", init_uts_ns.name.domainname);
+	kdb_printf("ccversion  %s\n", __stringify(CCVERSION));
+
+	kdb_gmtime(&xtime, &tm);
+	kdb_printf("date       %04d-%02d-%02d %02d:%02d:%02d tz_minuteswest %d\n",
+		1900+tm.tm_year, tm.tm_mon+1, tm.tm_mday,
+		tm.tm_hour, tm.tm_min, tm.tm_sec,
+		sys_tz.tz_minuteswest);
+
+	kdb_sysinfo(&val);
+	kdb_printf("uptime     ");
+	if (val.uptime > (24*60*60)) {
+		int days = val.uptime / (24*60*60);
+		val.uptime %= (24*60*60);
+		kdb_printf("%d day%s ", days, days == 1 ? "" : "s");
+	}
+	kdb_printf("%02ld:%02ld\n", val.uptime/(60*60), (val.uptime/60)%60);
+
+	/* lifted from fs/proc/proc_misc.c::loadavg_read_proc() */
+
+#define LOAD_INT(x) ((x) >> FSHIFT)
+#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
+	kdb_printf("load avg   %ld.%02ld %ld.%02ld %ld.%02ld\n",
+		LOAD_INT(val.loads[0]), LOAD_FRAC(val.loads[0]),
+		LOAD_INT(val.loads[1]), LOAD_FRAC(val.loads[1]),
+		LOAD_INT(val.loads[2]), LOAD_FRAC(val.loads[2]));
+	kdb_printf("\n");
+#undef LOAD_INT
+#undef LOAD_FRAC
+
+	kdb_meminfo_proc_show();	/* in fs/proc/meminfo.c */
+
+	return 0;
+}
+
+/*
+ * kdb_per_cpu
+ *
+ *	This function implements the 'per_cpu' command.
+ *
+ * Inputs:
+ *	argc	argument count
+ *	argv	argument vector
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, a kdb diagnostic if error
+ * Locking:
+ *	none.
+ * Remarks:
+ */
+
+static int
+kdb_per_cpu(int argc, const char **argv)
+{
+	char buf[256], fmtstr[64];
+	kdb_symtab_t symtab;
+	cpumask_t suppress = CPU_MASK_NONE;
+	int cpu, diag;
+	unsigned long addr, val, bytesperword = 0, whichcpu = ~0UL;
+
+	if (argc < 1 || argc > 3)
+		return KDB_ARGCOUNT;
+
+	snprintf(buf, sizeof(buf), "per_cpu__%s", argv[1]);
+	if (!kdbgetsymval(buf, &symtab)) {
+		kdb_printf("%s is not a per_cpu variable\n", argv[1]);
+		return KDB_BADADDR;
+	}
+	if (argc >=2 && (diag = kdbgetularg(argv[2], &bytesperword)))
+		return diag;
+	if (!bytesperword)
+		bytesperword = KDB_WORD_SIZE;
+	else if (bytesperword > KDB_WORD_SIZE)
+		return KDB_BADWIDTH;
+	sprintf(fmtstr, "%%0%dlx ", (int)(2*bytesperword));
+	if (argc >= 3) {
+		if ((diag = kdbgetularg(argv[3], &whichcpu)))
+			return diag;
+		if (!cpu_online(whichcpu)) {
+			kdb_printf("cpu %ld is not online\n", whichcpu);
+			return KDB_BADCPUNUM;
+		}
+	}
+
+	/* Most architectures use __per_cpu_offset[cpu], some use
+	 * __per_cpu_offset(cpu), smp has no __per_cpu_offset.
+	 */
+#ifdef	__per_cpu_offset
+#define KDB_PCU(cpu) __per_cpu_offset(cpu)
+#else
+#ifdef	CONFIG_SMP
+#define KDB_PCU(cpu) __per_cpu_offset[cpu]
+#else
+#define KDB_PCU(cpu) 0
+#endif
+#endif
+
+	for_each_online_cpu(cpu) {
+		if (whichcpu != ~0UL && whichcpu != cpu)
+			continue;
+		addr = symtab.sym_start + KDB_PCU(cpu);
+		if ((diag = kdb_getword(&val, addr, bytesperword))) {
+			kdb_printf("%5d " kdb_bfd_vma_fmt0 " - unable to read, diag=%d\n",
+				cpu, addr, diag);
+			continue;
+		}
+#ifdef	CONFIG_SMP
+		if (!val) {
+			cpu_set(cpu, suppress);
+			continue;
+		}
+#endif	/* CONFIG_SMP */
+		kdb_printf("%5d ", cpu);
+		kdb_md_line(fmtstr, addr,
+			bytesperword == KDB_WORD_SIZE,
+			1, bytesperword, 1, 1, 0);
+	}
+	if (cpus_weight(suppress) == 0)
+		return 0;
+	kdb_printf("Zero suppressed cpu(s):");
+	for (cpu = first_cpu(suppress); cpu < NR_CPUS; cpu = next_cpu(cpu, suppress)) {
+		kdb_printf(" %d", cpu);
+		if (cpu == NR_CPUS-1 || next_cpu(cpu, suppress) != cpu + 1)
+			continue;
+		while (cpu < NR_CPUS && next_cpu(cpu, suppress) == cpu + 1)
+			++cpu;
+		kdb_printf("-%d", cpu);
+	}
+	kdb_printf("\n");
+
+#undef KDB_PCU
+
+	return 0;
+}
+
+/*
+ * display help for the use of cmd | grep pattern
+ */
+static int
+kdb_grep_help(int argc, const char **argv)
+{
+	kdb_printf("Usage of  cmd args | grep pattern:\n");
+	kdb_printf("  Any command's output may be filtered through an ");
+	kdb_printf("emulated 'pipe'.\n");
+	kdb_printf("  'grep' is just a key word.\n");
+	kdb_printf("  The pattern may include a very limited set of metacharacters:\n");
+	kdb_printf("   pattern or ^pattern or pattern$ or ^pattern$\n");
+	kdb_printf("  And if there are spaces in the pattern, you may quote it:\n");
+	kdb_printf("   \"pat tern\" or \"^pat tern\" or \"pat tern$\" or \"^pat tern$\"\n");
+	return 0;
+}
+
+/*
+ * kdb_register_repeat
+ *
+ *	This function is used to register a kernel debugger command.
+ *
+ * Inputs:
+ *	cmd	Command name
+ *	func	Function to execute the command
+ *	usage	A simple usage string showing arguments
+ *	help	A simple help string describing command
+ *	repeat	Does the command auto repeat on enter?
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, one if a duplicate command.
+ * Locking:
+ *	none.
+ * Remarks:
+ *
+ */
+
+#define kdb_command_extend 50	/* arbitrary */
+int
+kdb_register_repeat(char *cmd,
+		    kdb_func_t func,
+		    char *usage,
+		    char *help,
+		    short minlen,
+		    kdb_repeat_t repeat)
+{
+	int i;
+	kdbtab_t *kp;
+
+	/*
+	 *  Brute force method to determine duplicates
+	 */
+	for (i=0, kp=kdb_commands; i<kdb_max_commands; i++, kp++) {
+		if (kp->cmd_name && (strcmp(kp->cmd_name, cmd)==0)) {
+			kdb_printf("Duplicate kdb command registered: "
+				"%s, func %p help %s\n", cmd, func, help);
+			return 1;
+		}
+	}
+
+	/*
+	 * Insert command into first available location in table
+	 */
+	for (i=0, kp=kdb_commands; i<kdb_max_commands; i++, kp++) {
+		if (kp->cmd_name == NULL) {
+			break;
+		}
+	}
+
+	if (i >= kdb_max_commands) {
+		kdbtab_t *new = kmalloc((kdb_max_commands + kdb_command_extend) * sizeof(*new), GFP_KDB);
+		if (!new) {
+			kdb_printf("Could not allocate new kdb_command table\n");
+			return 1;
+		}
+		if (kdb_commands) {
+			memcpy(new, kdb_commands, kdb_max_commands * sizeof(*new));
+			kfree(kdb_commands);
+		}
+		memset(new + kdb_max_commands, 0, kdb_command_extend * sizeof(*new));
+		kdb_commands = new;
+		kp = kdb_commands + kdb_max_commands;
+		kdb_max_commands += kdb_command_extend;
+	}
+
+	kp->cmd_name   = cmd;
+	kp->cmd_func   = func;
+	kp->cmd_usage  = usage;
+	kp->cmd_help   = help;
+	kp->cmd_flags  = 0;
+	kp->cmd_minlen = minlen;
+	kp->cmd_repeat = repeat;
+
+	return 0;
+}
+
+/*
+ * kdb_register
+ *
+ *	Compatibility register function for commands that do not need to
+ *	specify a repeat state.  Equivalent to kdb_register_repeat with
+ *	KDB_REPEAT_NONE.
+ *
+ * Inputs:
+ *	cmd	Command name
+ *	func	Function to execute the command
+ *	usage	A simple usage string showing arguments
+ *	help	A simple help string describing command
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, one if a duplicate command.
+ * Locking:
+ *	none.
+ * Remarks:
+ *
+ */
+
+int
+kdb_register(char *cmd,
+	     kdb_func_t func,
+	     char *usage,
+	     char *help,
+	     short minlen)
+{
+	return kdb_register_repeat(cmd, func, usage, help, minlen, KDB_REPEAT_NONE);
+}
+
+/*
+ * kdb_unregister
+ *
+ *	This function is used to unregister a kernel debugger command.
+ *	It is generally called when a module which implements kdb
+ *	commands is unloaded.
+ *
+ * Inputs:
+ *	cmd	Command name
+ * Outputs:
+ *	None.
+ * Returns:
+ *	zero for success, one command not registered.
+ * Locking:
+ *	none.
+ * Remarks:
+ *
+ */
+
+int
+kdb_unregister(char *cmd)
+{
+	int i;
+	kdbtab_t *kp;
+
+	/*
+	 *  find the command.
+	 */
+	for (i=0, kp=kdb_commands; i<kdb_max_commands; i++, kp++) {
+		if (kp->cmd_name && (strcmp(kp->cmd_name, cmd)==0)) {
+			kp->cmd_name = NULL;
+			return 0;
+		}
+	}
+
+	/*
+	 * Couldn't find it.
+	 */
+	return 1;
+}
+
+/*
+ * kdb_inittab
+ *
+ *	This function is called by the kdb_init function to initialize
+ *	the kdb command table.   It must be called prior to any other
+ *	call to kdb_register_repeat.
+ *
+ * Inputs:
+ *	None.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ *
+ */
+
+static void __init
+kdb_inittab(void)
+{
+	int i;
+	kdbtab_t *kp;
+
+	for(i=0, kp=kdb_commands; i < kdb_max_commands; i++,kp++) {
+		kp->cmd_name = NULL;
+	}
+
+	kdb_register_repeat("md", kdb_md, "<vaddr>",   "Display Memory Contents, also mdWcN, e.g. md8c1", 1, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("mdr", kdb_md, "<vaddr> <bytes>", 	"Display Raw Memory", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("mdp", kdb_md, "<paddr> <bytes>", 	"Display Physical Memory", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("mds", kdb_md, "<vaddr>", 	"Display Memory Symbolically", 0, KDB_REPEAT_NO_ARGS);
+	kdb_register_repeat("mm", kdb_mm, "<vaddr> <contents>",   "Modify Memory Contents", 0, KDB_REPEAT_NO_ARGS);
+	//	kdb_register_repeat("id", kdb_id, "<vaddr>",   "Display Instructions", 1, KDB_REPEAT_NO_ARGS);
+	// HACK HACK HACK
+	kdb_register_repeat("go", kdb_go, "[<vaddr>]", "Continue Execution", 1, KDB_REPEAT_NONE);
+	kdb_register_repeat("rd", kdb_rd, "",		"Display Registers", 1, KDB_REPEAT_NONE);
+	kdb_register_repeat("rm", kdb_rm, "<reg> <contents>", "Modify Registers", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("ef", kdb_ef, "<vaddr>",   "Display exception frame", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("bt", kdb_bt, "[<vaddr>]", "Stack traceback", 1, KDB_REPEAT_NONE);
+	kdb_register_repeat("btp", kdb_bt, "<pid>", 	"Display stack for process <pid>", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("bta", kdb_bt, "[DRSTCZEUIMA]", 	"Display stack all processes", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("btc", kdb_bt, "", 	"Backtrace current process on each cpu", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("btt", kdb_bt, "<vaddr>", 	"Backtrace process given its struct task address", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("ll", kdb_ll, "<first-element> <linkoffset> <cmd>", "Execute cmd for each element in linked list", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("env", kdb_env, "", 	"Show environment variables", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("set", kdb_set, "", 	"Set environment variables", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("help", kdb_help, "", 	"Display Help Message", 1, KDB_REPEAT_NONE);
+	kdb_register_repeat("?", kdb_help, "",         "Display Help Message", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("kgdb", kdb_kgdb, "", "Enter kgdb mode", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("cpu", kdb_cpu, "<cpunum>","Switch to new cpu", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("ps", kdb_ps, "[<flags>|A]", "Display active task list", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("pid", kdb_pid, "<pidnum>",	"Switch to another task", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("reboot", kdb_reboot, "",  "Reboot the machine immediately", 0, KDB_REPEAT_NONE);
+#if defined(CONFIG_KDB_KDUMP)
+	kdb_register_repeat("kdump", kdb_kdump, "",    "Calls kdump mode", 0, KDB_REPEAT_NONE);
+#endif
+#if defined(CONFIG_MODULES)
+	kdb_register_repeat("lsmod", kdb_lsmod, "",	"List loaded kernel modules", 0, KDB_REPEAT_NONE);
+#endif
+#if defined(CONFIG_MAGIC_SYSRQ)
+	kdb_register_repeat("sr", kdb_sr, "<key>",	"Magic SysRq key", 0, KDB_REPEAT_NONE);
+#endif
+	kdb_register_repeat("dmesg", kdb_dmesg, "[lines]",	"Display syslog buffer", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("defcmd", kdb_defcmd, "name \"usage\" \"help\"", "Define a set of commands, down to endefcmd", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("kill", kdb_kill, "<-signal> <pid>", "Send a signal to a process", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("summary", kdb_summary, "", "Summarize the system", 4, KDB_REPEAT_NONE);
+	kdb_register_repeat("per_cpu", kdb_per_cpu, "", "Display per_cpu variables", 3, KDB_REPEAT_NONE);
+	kdb_register_repeat("grephelp", kdb_grep_help, "",
+		"Display help on | grep", 0, KDB_REPEAT_NONE);
+#ifdef CONFIG_KDB_LKCRASH
+	kdb_register_repeat("print", kdb_debuginfo_print, "<expression>",
+		"Type casting, as in lcrash",  0, KDB_REPEAT_NONE);
+	kdb_register_repeat("px", kdb_debuginfo_print, "<expression>",
+	   "Print in hex (type casting) (see 'pxhelp')",  0, KDB_REPEAT_NONE);
+	kdb_register_repeat("pxhelp", kdb_pxhelp, "",
+		"Display help for the px command", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("pd", kdb_debuginfo_print, "<expression>",
+		"Print in decimal (type casting)", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("whatis", kdb_debuginfo_print,"<type or symbol>",
+	"Display the type, or the address for a symbol", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("sizeof", kdb_debuginfo_print, "<type>",
+	"Display the size of a structure, typedef, etc.", 0, KDB_REPEAT_NONE);
+        kdb_register_repeat("walk", kdb_walk, "",
+		"Walk a linked list (see 'walkhelp')", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("walkhelp", kdb_walkhelp, "",
+		"Display help for the walk command", 0, KDB_REPEAT_NONE);
+#endif
+}
+
+/*
+ * kdb_cmd_init
+ *
+ *	This function is called by the kdb_init function to execute any
+ *	commands defined in kdb_cmds.
+ *
+ * Inputs:
+ *	Commands in *kdb_cmds[];
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ *
+ */
+
+static void __init
+kdb_cmd_init(void)
+{
+	int i, diag;
+	for (i = 0; kdb_cmds[i]; ++i) {
+		diag = kdb_parse(kdb_cmds[i]);
+		if (diag)
+			kdb_printf("kdb command %s failed, kdb diag %d\n",
+				kdb_cmds[i], diag);
+	}
+	if (defcmd_in_progress) {
+		kdb_printf("Incomplete 'defcmd' set, forcing endefcmd\n");
+		kdb_parse("endefcmd");
+	}
+}
+
+/*
+ * kdb_init
+ *
+ * 	Initialize the kernel debugger environment.
+ *
+ * Parameters:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	None.
+ * Remarks:
+ *	None.
+ */
+
+void __init
+kdb_init(void)
+{
+	kdb_initial_cpu = smp_processor_id();
+	/*
+	 * This must be called before any calls to kdb_printf.
+	 */
+	// Start hacking away... kgdb does a lot of the same things already
+	//	kdb_io_init();
+	// HACK HACK HACK
+
+	kdb_inittab();		/* Initialize Command Table */
+	kdb_initbptab();	/* Initialize Breakpoint Table */
+	//	kdb_id_init();		/* Initialize Disassembler */
+	//	kdba_init();		/* Architecture Dependent Initialization */
+	// HACK HACK HACK
+
+	/*
+	 * Use printk() to get message in log_buf[];
+	 */
+
+	kdb_cmd_init();		/* Preset commands from kdb_cmds */
+	kdb_initial_cpu = -1;	/* Avoid recursion problems */
+	return;
+	// HACK HACK HACK
+	//	kdb(KDB_REASON_CPU_UP, 0, NULL);	/* do kdb setup on boot cpu */
+	kdb_initial_cpu = smp_processor_id();
+	//	atomic_notifier_chain_register(&panic_notifier_list, &kdb_block);
+	//	register_cpu_notifier(&kdb_cpu_nfb);
+
+#ifdef kdba_setjmp
+	kdbjmpbuf = vmalloc(NR_CPUS * sizeof(*kdbjmpbuf));
+	if (!kdbjmpbuf)
+		printk(KERN_ERR "Cannot allocate kdbjmpbuf, no kdb recovery will be possible\n");
+#endif	/* kdba_setjmp */
+
+	kdb_initial_cpu = -1;
+	//	kdb_wait_for_cpus_secs = max(10, 2*num_online_cpus());
+}
+// HACK have to sort through these later, some probably are not needed
+EXPORT_SYMBOL_GPL(kdb_register);
+EXPORT_SYMBOL_GPL(kdb_register_repeat);
+EXPORT_SYMBOL_GPL(kdb_unregister);
+EXPORT_SYMBOL_GPL(kdb_getarea_size);
+EXPORT_SYMBOL_GPL(kdb_putarea_size);
+//EXPORT_SYMBOL(kdb_getuserarea_size);
+//EXPORT_SYMBOL(kdb_putuserarea_size);
+EXPORT_SYMBOL_GPL(kdbgetularg);
+EXPORT_SYMBOL_GPL(kdbgetenv);
+EXPORT_SYMBOL_GPL(kdbgetintenv);
+EXPORT_SYMBOL_GPL(kdbgetaddrarg);
+//EXPORT_SYMBOL(kdb);
+EXPORT_SYMBOL_GPL(kdb_on);
+EXPORT_SYMBOL_GPL(kdb_seqno);
+EXPORT_SYMBOL_GPL(kdb_initial_cpu);
+EXPORT_SYMBOL_GPL(kdbnearsym);
+EXPORT_SYMBOL_GPL(kdb_printf);
+EXPORT_SYMBOL_GPL(kdb_symbol_print);
+EXPORT_SYMBOL_GPL(kdb_running_process);
diff --git a/kdb/kdbsupport.c b/kdb/kdbsupport.c
new file mode 100644
index 0000000..6234380
--- /dev/null
+++ b/kdb/kdbsupport.c
@@ -0,0 +1,1120 @@
+/*
+ * Kernel Debugger Architecture Independent Support Functions
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 1999-2004 Silicon Graphics, Inc.  All Rights Reserved.
+ * 03/02/13    added new 2.5 kallsyms <xavier.bru@bull.net>
+ */
+
+#include <stdarg.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/kallsyms.h>
+#include <linux/stddef.h>
+#include <linux/vmalloc.h>
+#include <linux/ptrace.h>
+#include <linux/module.h>
+#include <linux/highmem.h>
+#include <linux/hardirq.h>
+#include <linux/delay.h>
+
+#include <asm/uaccess.h>
+
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+
+/*
+ * Symbol table functions.
+ */
+
+/*
+ * kdbgetsymval
+ *
+ *	Return the address of the given symbol.
+ *
+ * Parameters:
+ *	symname	Character string containing symbol name
+ *      symtab  Structure to receive results
+ * Outputs:
+ * Returns:
+ *	0	Symbol not found, symtab zero filled
+ *	1	Symbol mapped to module/symbol/section, data in symtab
+ * Locking:
+ *	None.
+ * Remarks:
+ */
+
+int
+kdbgetsymval(const char *symname, kdb_symtab_t *symtab)
+{
+	if (KDB_DEBUG(AR))
+		kdb_printf("kdbgetsymval: symname=%s, symtab=%p\n", symname, symtab);
+	memset(symtab, 0, sizeof(*symtab));
+
+	if ((symtab->sym_start = kallsyms_lookup_name(symname))) {
+		if (KDB_DEBUG(AR))
+			kdb_printf("kdbgetsymval: returns 1, symtab->sym_start=0x%lx\n", symtab->sym_start);
+		return 1;
+	}
+	if (KDB_DEBUG(AR))
+		kdb_printf("kdbgetsymval: returns 0\n");
+	return 0;
+}
+EXPORT_SYMBOL(kdbgetsymval);
+
+/*
+ * kdbnearsym
+ *
+ *	Return the name of the symbol with the nearest address
+ *	less than 'addr'.
+ *
+ * Parameters:
+ *	addr	Address to check for symbol near
+ *	symtab  Structure to receive results
+ * Outputs:
+ * Returns:
+ *	0	No sections contain this address, symtab zero filled
+ *	1	Address mapped to module/symbol/section, data in symtab
+ * Locking:
+ *	None.
+ * Remarks:
+ *	2.6 kallsyms has a "feature" where it unpacks the name into a string.
+ *	If that string is reused before the caller expects it then the caller
+ *	sees its string change without warning.  To avoid cluttering up the
+ *	main kdb code with lots of kdb_strdup, tests and kfree calls, kdbnearsym
+ *	maintains an LRU list of the last few unique strings.  The list is sized
+ *	large enough to hold active strings, no kdb caller of kdbnearsym makes
+ *	more than ~20 later calls before using a saved value.
+ */
+
+static char *kdb_name_table[100];	/* arbitrary size */
+
+int
+kdbnearsym(unsigned long addr, kdb_symtab_t *symtab)
+{
+	int ret = 0;
+	unsigned long symbolsize;
+	unsigned long offset;
+#define knt1_size 128		/* must be >= kallsyms table size */
+	char *knt1 = NULL;
+
+	if (KDB_DEBUG(AR))
+		kdb_printf("kdbnearsym: addr=0x%lx, symtab=%p\n", addr, symtab);
+	memset(symtab, 0, sizeof(*symtab));
+
+	if (addr < 4096)
+		goto out;
+	knt1 = debug_kmalloc(knt1_size, GFP_ATOMIC);
+	if (!knt1) {
+		kdb_printf("kdbnearsym: addr=0x%lx cannot kmalloc knt1\n", addr);
+		goto out;
+	}
+	symtab->sym_name = kallsyms_lookup(addr, &symbolsize , &offset, (char **)(&symtab->mod_name), knt1);
+	if (offset > 8*1024*1024) {
+		symtab->sym_name = NULL;
+		addr = offset = symbolsize = 0;
+	}
+	symtab->sym_start = addr - offset;
+	symtab->sym_end = symtab->sym_start + symbolsize;
+	ret = symtab->sym_name != NULL && *(symtab->sym_name) != '\0';
+
+	if (ret) {
+		int i;
+		/* Another 2.6 kallsyms "feature".  Sometimes the sym_name is
+		 * set but the buffer passed into kallsyms_lookup is not used,
+		 * so it contains garbage.  The caller has to work out which
+		 * buffer needs to be saved.
+		 *
+		 * What was Rusty smoking when he wrote that code?
+		 */
+		if (symtab->sym_name != knt1) {
+			strncpy(knt1, symtab->sym_name, knt1_size);
+			knt1[knt1_size-1] = '\0';
+		}
+		for (i = 0; i < ARRAY_SIZE(kdb_name_table); ++i) {
+			if (kdb_name_table[i] && strcmp(kdb_name_table[i], knt1) == 0)
+				break;
+		}
+		if (i >= ARRAY_SIZE(kdb_name_table)) {
+			debug_kfree(kdb_name_table[0]);
+			memcpy(kdb_name_table, kdb_name_table+1,
+			       sizeof(kdb_name_table[0])*(ARRAY_SIZE(kdb_name_table)-1));
+		} else {
+			debug_kfree(knt1);
+			knt1 = kdb_name_table[i];
+			memcpy(kdb_name_table+i, kdb_name_table+i+1,
+			       sizeof(kdb_name_table[0])*(ARRAY_SIZE(kdb_name_table)-i-1));
+		}
+		i = ARRAY_SIZE(kdb_name_table) - 1;
+		kdb_name_table[i] = knt1;
+		symtab->sym_name = kdb_name_table[i];
+		knt1 = NULL;
+	}
+
+	if (symtab->mod_name == NULL)
+		symtab->mod_name = "kernel";
+	if (KDB_DEBUG(AR))
+		kdb_printf("kdbnearsym: returns %d symtab->sym_start=0x%lx, symtab->mod_name=%p, symtab->sym_name=%p (%s)\n", ret, symtab->sym_start, symtab->mod_name, symtab->sym_name, symtab->sym_name);
+
+out:
+	debug_kfree(knt1);
+	return ret;
+}
+
+void
+kdbnearsym_cleanup(void)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(kdb_name_table); ++i) {
+		if (kdb_name_table[i]) {
+			debug_kfree(kdb_name_table[i]);
+			kdb_name_table[i] = NULL;
+		}
+	}
+}
+
+/*
+ * kallsyms_symbol_complete
+ *
+ * Parameters:
+ *	prefix_name	prefix of a symbol name to lookup
+ *	max_len		maximum length that can be returned
+ * Returns:
+ *	Number of symbols which match the given prefix.
+ * Notes:
+ *	prefix_name is changed to contain the longest unique prefix that
+ *	starts with this prefix (tab completion).
+ */
+
+static char ks_namebuf[KSYM_NAME_LEN+1], ks_namebuf_prev[KSYM_NAME_LEN+1];
+
+int kallsyms_symbol_complete(char *prefix_name, int max_len)
+{
+	loff_t pos = 0;
+	int prefix_len = strlen(prefix_name), prev_len = 0;
+	int i, number = 0;
+	const char *name;
+
+	while ((name = kdb_walk_kallsyms(&pos))) {
+		if (strncmp(name, prefix_name, prefix_len) == 0) {
+			strcpy(ks_namebuf, name);
+			/* Work out the longest name that matches the prefix */
+			if (++number == 1) {
+				prev_len = min_t(int, max_len-1, strlen(ks_namebuf));
+				memcpy(ks_namebuf_prev, ks_namebuf, prev_len);
+				ks_namebuf_prev[prev_len] = '\0';
+			} else for (i = 0; i < prev_len; ++i) {
+				if (ks_namebuf[i] != ks_namebuf_prev[i]) {
+					prev_len = i;
+					ks_namebuf_prev[i] = '\0';
+					break;
+				}
+			}
+		}
+	}
+ 	if (prev_len > prefix_len)
+		memcpy(prefix_name, ks_namebuf_prev, prev_len+1);
+	return number;
+}
+
+/*
+ * kallsyms_symbol_next
+ *
+ * Parameters:
+ *	prefix_name	prefix of a symbol name to lookup
+ *	flag	0 means search from the head, 1 means continue search.
+ * Returns:
+ *	1 if a symbol matches the given prefix.
+ *	0 if no string found
+ */
+
+int kallsyms_symbol_next(char *prefix_name, int flag)
+{
+	int prefix_len = strlen(prefix_name);
+	static loff_t pos;
+	const char *name;
+
+	if (!flag)
+		pos = 0;
+
+	while ((name = kdb_walk_kallsyms(&pos))) {
+		if (strncmp(name, prefix_name, prefix_len) == 0) {
+			strncpy(prefix_name, name, strlen(name)+1);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+/*
+ * kdb_symbol_print
+ *
+ *	Standard method for printing a symbol name and offset.
+ * Inputs:
+ *	addr	Address to be printed.
+ *	symtab	Address of symbol data, if NULL this routine does its
+ *		own lookup.
+ *	punc	Punctuation for string, bit field.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	Always 0.
+ * Locking:
+ *	none.
+ * Remarks:
+ *	The string and its punctuation is only printed if the address
+ *	is inside the kernel, except that the value is always printed
+ *	when requested.
+ */
+
+void
+kdb_symbol_print(kdb_machreg_t addr, const kdb_symtab_t *symtab_p, unsigned int punc)
+{
+	kdb_symtab_t symtab, *symtab_p2;
+	if (symtab_p) {
+		symtab_p2 = (kdb_symtab_t *)symtab_p;
+	}
+	else {
+		symtab_p2 = &symtab;
+		kdbnearsym(addr, symtab_p2);
+	}
+	if (symtab_p2->sym_name || (punc & KDB_SP_VALUE)) {
+		;	/* drop through */
+	}
+	else {
+		return;
+	}
+	if (punc & KDB_SP_SPACEB) {
+		kdb_printf(" ");
+	}
+	if (punc & KDB_SP_VALUE) {
+		kdb_printf(kdb_machreg_fmt0, addr);
+	}
+	if (symtab_p2->sym_name) {
+		if (punc & KDB_SP_VALUE) {
+			kdb_printf(" ");
+		}
+		if (punc & KDB_SP_PAREN) {
+			kdb_printf("(");
+		}
+		if (strcmp(symtab_p2->mod_name, "kernel")) {
+			kdb_printf("[%s]", symtab_p2->mod_name);
+		}
+		kdb_printf("%s", symtab_p2->sym_name);
+		if (addr != symtab_p2->sym_start) {
+			kdb_printf("+0x%lx", addr - symtab_p2->sym_start);
+		}
+		if (punc & KDB_SP_SYMSIZE) {
+			kdb_printf("/0x%lx", symtab_p2->sym_end - symtab_p2->sym_start);
+		}
+		if (punc & KDB_SP_PAREN) {
+			kdb_printf(")");
+		}
+	}
+	if (punc & KDB_SP_SPACEA) {
+		kdb_printf(" ");
+	}
+	if (punc & KDB_SP_NEWLINE) {
+		kdb_printf("\n");
+	}
+}
+
+/*
+ * kdb_strdup
+ *
+ *	kdb equivalent of strdup, for disasm code.
+ * Inputs:
+ *	str	The string to duplicate.
+ *	type	Flags to kmalloc for the new string.
+ * Outputs:
+ *	None.
+ * Returns:
+ *	Address of the new string, NULL if storage could not be allocated.
+ * Locking:
+ *	none.
+ * Remarks:
+ *	This is not in lib/string.c because it uses kmalloc which is not
+ *	available when string.o is used in boot loaders.
+ */
+
+char *kdb_strdup(const char *str, gfp_t type)
+{
+	int n = strlen(str)+1;
+	char *s = kmalloc(n, type);
+	if (!s) return NULL;
+	return strcpy(s, str);
+}
+
+/*
+ * kdb_getarea_size
+ *
+ *	Read an area of data.  The kdb equivalent of copy_from_user, with
+ *	kdb messages for invalid addresses.
+ * Inputs:
+ *	res	Pointer to the area to receive the result.
+ *	addr	Address of the area to copy.
+ *	size	Size of the area.
+ * Outputs:
+ *	none.
+ * Returns:
+ *	0 for success, < 0 for error.
+ * Locking:
+ *	none.
+ */
+
+int kdb_getarea_size(void *res, unsigned long addr, size_t size)
+{
+	//	int ret = kdba_getarea_size(res, addr, size);
+	// HACK HACK HACK
+	int ret = probe_kernel_read((char *)res, (char *)addr, size);
+	if (ret) {
+		if (!KDB_STATE(SUPPRESS)) {
+			kdb_printf("kdb_getarea: Bad address 0x%lx\n", addr);
+			KDB_STATE_SET(SUPPRESS);
+		}
+		ret = KDB_BADADDR;
+	}
+	else {
+		KDB_STATE_CLEAR(SUPPRESS);
+	}
+	return(ret);
+}
+
+/*
+ * kdb_putarea_size
+ *
+ *	Write an area of data.  The kdb equivalent of copy_to_user, with
+ *	kdb messages for invalid addresses.
+ * Inputs:
+ *	addr	Address of the area to write to.
+ *	res	Pointer to the area holding the data.
+ *	size	Size of the area.
+ * Outputs:
+ *	none.
+ * Returns:
+ *	0 for success, < 0 for error.
+ * Locking:
+ *	none.
+ */
+
+int kdb_putarea_size(unsigned long addr, void *res, size_t size)
+{
+	//	int ret = kdba_putarea_size(addr, res, size);
+	// HACK HACK HACK
+	int ret = probe_kernel_read((char *)addr, (char *)res, size);
+	if (ret) {
+		if (!KDB_STATE(SUPPRESS)) {
+			kdb_printf("kdb_putarea: Bad address 0x%lx\n", addr);
+			KDB_STATE_SET(SUPPRESS);
+		}
+		ret = KDB_BADADDR;
+	}
+	else {
+		KDB_STATE_CLEAR(SUPPRESS);
+	}
+	return(ret);
+}
+
+/*
+ * kdb_getphys
+ *
+ * Read data from a physical address. Validate the address is in range,
+ * use kmap_atomic() to get data
+ *
+ * Similar to kdb_getarea() - but for phys addresses
+ *
+ * Inputs:
+ * 	res	Pointer to the word to receive the result
+ * 	addr	Physical address of the area to copy
+ * 	size	Size of the area
+ * Outputs:
+ * 	none.
+ * Returns:
+ *	0 for success, < 0 for error.
+ * Locking:
+ * 	none.
+ */
+static int kdb_getphys(void *res, unsigned long addr, size_t size)
+{
+	unsigned long pfn;
+	void *vaddr;
+	struct page *page;
+
+	pfn = (addr >> PAGE_SHIFT);
+	if (!pfn_valid(pfn))
+		return 1;
+	page = pfn_to_page(pfn);
+	vaddr = kmap_atomic(page, KM_KDB);
+	memcpy(res, vaddr + (addr & (PAGE_SIZE -1)), size);
+	kunmap_atomic(vaddr, KM_KDB);
+
+	return 0;
+}
+
+/*
+ * kdb_getphysword
+ *
+ * Inputs:
+ *	word	Pointer to the word to receive the result.
+ *	addr	Address of the area to copy.
+ *	size	Size of the area.
+ * Outputs:
+ *	none.
+ * Returns:
+ *	0 for success, < 0 for error.
+ * Locking:
+ *	none.
+ */
+int kdb_getphysword(unsigned long *word, unsigned long addr, size_t size)
+{
+	int diag;
+	__u8  w1;
+	__u16 w2;
+	__u32 w4;
+	__u64 w8;
+	*word = 0;	/* Default value if addr or size is invalid */
+
+	switch (size) {
+	case 1:
+		if (!(diag = kdb_getphys(&w1, addr, sizeof(w1))))
+			*word = w1;
+		break;
+	case 2:
+		if (!(diag = kdb_getphys(&w2, addr, sizeof(w2))))
+			*word = w2;
+		break;
+	case 4:
+		if (!(diag = kdb_getphys(&w4, addr, sizeof(w4))))
+			*word = w4;
+		break;
+	case 8:
+		if (size <= sizeof(*word)) {
+			if (!(diag = kdb_getphys(&w8, addr, sizeof(w8))))
+				*word = w8;
+			break;
+		}
+		/* drop through */
+	default:
+		diag = KDB_BADWIDTH;
+		kdb_printf("kdb_getphysword: bad width %ld\n", (long) size);
+	}
+	return(diag);
+}
+
+/*
+ * kdb_getword
+ *
+ *	Read a binary value.  Unlike kdb_getarea, this treats data as numbers.
+ * Inputs:
+ *	word	Pointer to the word to receive the result.
+ *	addr	Address of the area to copy.
+ *	size	Size of the area.
+ * Outputs:
+ *	none.
+ * Returns:
+ *	0 for success, < 0 for error.
+ * Locking:
+ *	none.
+ */
+
+int kdb_getword(unsigned long *word, unsigned long addr, size_t size)
+{
+	int diag;
+	__u8  w1;
+	__u16 w2;
+	__u32 w4;
+	__u64 w8;
+	*word = 0;	/* Default value if addr or size is invalid */
+	switch (size) {
+	case 1:
+		if (!(diag = kdb_getarea(w1, addr)))
+			*word = w1;
+		break;
+	case 2:
+		if (!(diag = kdb_getarea(w2, addr)))
+			*word = w2;
+		break;
+	case 4:
+		if (!(diag = kdb_getarea(w4, addr)))
+			*word = w4;
+		break;
+	case 8:
+		if (size <= sizeof(*word)) {
+			if (!(diag = kdb_getarea(w8, addr)))
+				*word = w8;
+			break;
+		}
+		/* drop through */
+	default:
+		diag = KDB_BADWIDTH;
+		kdb_printf("kdb_getword: bad width %ld\n", (long) size);
+	}
+	return(diag);
+}
+
+/*
+ * kdb_putword
+ *
+ *	Write a binary value.  Unlike kdb_putarea, this treats data as numbers.
+ * Inputs:
+ *	addr	Address of the area to write to..
+ *	word	The value to set.
+ *	size	Size of the area.
+ * Outputs:
+ *	none.
+ * Returns:
+ *	0 for success, < 0 for error.
+ * Locking:
+ *	none.
+ */
+
+int kdb_putword(unsigned long addr, unsigned long word, size_t size)
+{
+	int diag;
+	__u8  w1;
+	__u16 w2;
+	__u32 w4;
+	__u64 w8;
+	switch (size) {
+	case 1:
+		w1 = word;
+		diag = kdb_putarea(addr, w1);
+		break;
+	case 2:
+		w2 = word;
+		diag = kdb_putarea(addr, w2);
+		break;
+	case 4:
+		w4 = word;
+		diag = kdb_putarea(addr, w4);
+		break;
+	case 8:
+		if (size <= sizeof(word)) {
+			w8 = word;
+			diag = kdb_putarea(addr, w8);
+			break;
+		}
+		/* drop through */
+	default:
+		diag = KDB_BADWIDTH;
+		kdb_printf("kdb_putword: bad width %ld\n", (long) size);
+	}
+	return(diag);
+}
+
+/*
+ * kdb_task_state_string
+ *
+ *	Convert a string containing any of the letters DRSTCZEUIMA to a mask
+ *	for the process state field and return the value.  If no argument is
+ *	supplied, return the mask that corresponds to environment variable PS,
+ *	DRSTCZEU by default.
+ * Inputs:
+ *	s	String to convert
+ * Outputs:
+ *	none.
+ * Returns:
+ *	Mask for process state.
+ * Locking:
+ *	none.
+ * Notes:
+ *	The mask folds data from several sources into a single long value, so
+ *	be carefull not to overlap the bits.  TASK_* bits are in the LSB,
+ *	special cases like UNRUNNABLE are in the MSB.  As of 2.6.10-rc1 there
+ *	is no overlap between TASK_* and EXIT_* but that may not always be
+ *	true, so EXIT_* bits are shifted left 16 bits before being stored in
+ *	the mask.
+ */
+
+#define UNRUNNABLE	(1UL << (8*sizeof(unsigned long) - 1))	/* unrunnable is < 0 */
+#define RUNNING		(1UL << (8*sizeof(unsigned long) - 2))
+#define IDLE		(1UL << (8*sizeof(unsigned long) - 3))
+#define DAEMON		(1UL << (8*sizeof(unsigned long) - 4))
+
+unsigned long
+kdb_task_state_string(const char *s)
+{
+	long res = 0;
+	if (!s && !(s = kdbgetenv("PS"))) {
+		s = "DRSTCZEU";	/* default value for ps */
+	}
+	while (*s) {
+		switch (*s) {
+		case 'D': res |= TASK_UNINTERRUPTIBLE; break;
+		case 'R': res |= RUNNING; break;
+		case 'S': res |= TASK_INTERRUPTIBLE; break;
+		case 'T': res |= TASK_STOPPED; break;
+		case 'C': res |= TASK_TRACED; break;
+		case 'Z': res |= EXIT_ZOMBIE << 16; break;
+		case 'E': res |= EXIT_DEAD << 16; break;
+		case 'U': res |= UNRUNNABLE; break;
+		case 'I': res |= IDLE; break;
+		case 'M': res |= DAEMON; break;
+		case 'A': res = ~0UL; break;
+		default:
+			  kdb_printf("%s: unknown flag '%c' ignored\n", __FUNCTION__, *s);
+			  break;
+		}
+		++s;
+	}
+	return res;
+}
+
+/*
+ * kdb_task_state_char
+ *
+ *	Return the character that represents the task state.
+ * Inputs:
+ *	p	struct task for the process
+ * Outputs:
+ *	none.
+ * Returns:
+ *	One character to represent the task state.
+ * Locking:
+ *	none.
+ */
+
+char
+kdb_task_state_char (const struct task_struct *p)
+{
+	int cpu = kdb_process_cpu(p);
+	struct kdb_running_process *krp = kdb_running_process + cpu;
+	char state = (p->state == 0) ? 'R' :
+		     (p->state < 0) ? 'U' :
+		     (p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
+		     (p->state & TASK_STOPPED) ? 'T' :
+		     (p->state & TASK_TRACED) ? 'C' :
+		     (p->exit_state & EXIT_ZOMBIE) ? 'Z' :
+		     (p->exit_state & EXIT_DEAD) ? 'E' :
+		     (p->state & TASK_INTERRUPTIBLE) ? 'S' : '?';
+	if (p->pid == 0) {
+		/* Idle task.  Is it really idle, apart from the kdb interrupt? */
+		if (!kdb_task_has_cpu(p) || krp->irq_depth == 1) {
+			/* There is a corner case when the idle task takes an
+			 * interrupt and dies in the interrupt code.  It has an
+			 * interrupt count of 1 but that did not come from kdb.
+			 * This corner case can only occur on the initial cpu,
+			 * all the others were entered via the kdb IPI.
+			 */
+			if (cpu != kdb_initial_cpu || KDB_STATE_CPU(KEYBOARD, cpu))
+				state = 'I';	/* idle task */
+		}
+	}
+	else if (!p->mm && state == 'S') {
+		state = 'M';	/* sleeping system daemon */
+	}
+	return state;
+}
+
+/*
+ * kdb_task_state
+ *
+ *	Return true if a process has the desired state given by the mask.
+ * Inputs:
+ *	p	struct task for the process
+ *	mask	mask from kdb_task_state_string to select processes
+ * Outputs:
+ *	none.
+ * Returns:
+ *	True if the process matches at least one criteria defined by the mask.
+ * Locking:
+ *	none.
+ */
+
+unsigned long
+kdb_task_state(const struct task_struct *p, unsigned long mask)
+{
+	char state[] = { kdb_task_state_char(p), '\0' };
+	return (mask & kdb_task_state_string(state)) != 0;
+}
+
+struct kdb_running_process kdb_running_process[NR_CPUS];
+
+void
+kdb_save_running_cpu(struct pt_regs *regs, struct task_struct *task, int cpu)
+{
+	struct kdb_running_process *krp = kdb_running_process + cpu;
+	krp->p = task;
+	krp->regs = regs;
+	krp->seqno = kdb_seqno;
+	// HACK HACK HACK - kgdb does not store this value per cpu
+	krp->irq_depth = hardirq_count() >> HARDIRQ_SHIFT;
+}
+
+/* Save the state of a running process and invoke kdb_main_loop.  This is
+ * invoked on the current process on each cpu (assuming the cpu is responding).
+ */
+#if 0
+int
+kdb_save_running(struct pt_regs *regs, kdb_reason_t reason,
+		 kdb_reason_t reason2, int error, kdb_dbtrap_t db_result)
+{
+	struct kdb_running_process *krp = kdb_running_process + smp_processor_id();
+	krp->p = current;
+	krp->regs = regs;
+	krp->seqno = kdb_seqno;
+	krp->irq_depth = hardirq_count() >> HARDIRQ_SHIFT;
+	kdba_save_running(&(krp->arch), regs);
+	return kdb_main_loop(reason, reason2, error, db_result, regs);
+}
+
+/*
+ * kdb_unsave_running
+ *
+ *	Reverse the effect of kdb_save_running.
+ * Inputs:
+ *	regs	struct pt_regs for the process
+ * Outputs:
+ *	Updates kdb_running_process[] for this cpu.
+ * Returns:
+ *	none.
+ * Locking:
+ *	none.
+ */
+
+void
+kdb_unsave_running(struct pt_regs *regs)
+{
+	struct kdb_running_process *krp = kdb_running_process + smp_processor_id();
+	kdba_unsave_running(&(krp->arch), regs);
+	krp->seqno = 0;
+}
+#endif
+
+
+/*
+ * kdb_print_nameval
+ *
+ *	Print a name and its value, converting the value to a symbol lookup
+ *	if possible.
+ * Inputs:
+ *	name	field name to print
+ *	val	value of field
+ * Outputs:
+ *	none.
+ * Returns:
+ *	none.
+ * Locking:
+ *	none.
+ */
+
+void
+kdb_print_nameval(const char *name, unsigned long val)
+{
+	kdb_symtab_t symtab;
+	kdb_printf("  %-11.11s ", name);
+	if (kdbnearsym(val, &symtab))
+		kdb_symbol_print(val, &symtab, KDB_SP_VALUE|KDB_SP_SYMSIZE|KDB_SP_NEWLINE);
+	else
+		kdb_printf("0x%lx\n", val);
+}
+
+static struct page * kdb_get_one_user_page(const struct task_struct *tsk, unsigned long start,
+		int len, int write)
+{
+	struct mm_struct *mm = tsk->mm;
+	unsigned int flags;
+	struct vm_area_struct *	vma;
+
+	/* shouldn't cross a page boundary. */
+	if ((start & PAGE_MASK) != ((start+len) & PAGE_MASK))
+		return NULL;
+
+	/* we need to align start address to the current page boundy, PAGE_ALIGN
+	 * aligns to next page boundry.
+	 * FIXME: What about hugetlb?
+	 */
+	start = start & PAGE_MASK;
+	flags = write ? (VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
+
+	vma = find_extend_vma(mm, start);
+
+	/* may be we can allow access to VM_IO pages inside KDB? */
+	if (!vma || (vma->vm_flags & VM_IO) || !(flags & vma->vm_flags))
+		return NULL;
+
+	return follow_page(vma, start, write ? FOLL_WRITE : 0);
+}
+
+int kdb_getuserarea_size(void *to, unsigned long from, size_t size)
+{
+	struct page *page;
+	void *vaddr;
+
+	page = kdb_get_one_user_page(kdb_current_task, from, size, 0);
+	if (!page)
+		return size;
+
+	vaddr = kmap_atomic(page, KM_KDB);
+	memcpy(to, vaddr+ (from & (PAGE_SIZE - 1)), size);
+	kunmap_atomic(vaddr, KM_KDB);
+
+	return 0;
+}
+
+int kdb_putuserarea_size(unsigned long to, void *from, size_t size)
+{
+	struct page *page;
+	void *vaddr;
+
+	page = kdb_get_one_user_page(kdb_current_task, to, size, 1);
+	if (!page)
+		return size;
+
+	vaddr = kmap_atomic(page, KM_KDB);
+	memcpy(vaddr+ (to & (PAGE_SIZE - 1)), from, size);
+	kunmap_atomic(vaddr, KM_KDB);
+
+	return 0;
+}
+
+/* Last ditch allocator for debugging, so we can still debug even when the
+ * GFP_ATOMIC pool has been exhausted.  The algorithms are tuned for space
+ * usage, not for speed.  One smallish memory pool, the free chain is always in
+ * ascending address order to allow coalescing, allocations are done in brute
+ * force best fit.
+ */
+
+struct debug_alloc_header {
+	u32 next;	/* offset of next header from start of pool */
+	u32 size;
+	void *caller;
+};
+
+/* The memory returned by this allocator must be aligned, which means so must
+ * the header size.  Do not assume that sizeof(struct debug_alloc_header) is a
+ * multiple of the alignment, explicitly calculate the overhead of this header,
+ * including the alignment.  The rest of this code must not use sizeof() on any
+ * header or pointer to a header.
+ */
+#define dah_align 8
+#define dah_overhead ALIGN(sizeof(struct debug_alloc_header), dah_align)
+
+static u64 debug_alloc_pool_aligned[256*1024/dah_align];	/* 256K pool */
+static char *debug_alloc_pool = (char *)debug_alloc_pool_aligned;
+static u32 dah_first, dah_first_call = 1, dah_used = 0, dah_used_max = 0;
+
+/* Locking is awkward.  The debug code is called from all contexts, including
+ * non maskable interrupts.  A normal spinlock is not safe in NMI context.  Try
+ * to get the debug allocator lock, if it cannot be obtained after a second
+ * then give up.  If the lock could not be previously obtained on this cpu then
+ * only try once.
+ *
+ * sparse has no annotation for "this function _sometimes_ acquires a lock", so
+ * fudge the acquire/release notation.
+ */
+static DEFINE_SPINLOCK(dap_lock);
+static int
+get_dap_lock(void)
+	__acquires(dap_lock)
+{
+	static int dap_locked = -1;
+	int count;
+	if (dap_locked == smp_processor_id())
+		count = 1;
+	else
+		count = 1000;
+	while (1) {
+		if (spin_trylock(&dap_lock)) {
+			dap_locked = -1;
+			return 1;
+		}
+		if (!count--)
+			break;
+		udelay(1000);
+	}
+	dap_locked = smp_processor_id();
+	__acquire(dap_lock);
+	return 0;
+}
+
+void
+*debug_kmalloc(size_t size, gfp_t flags)
+{
+	unsigned int rem, h_offset;
+	struct debug_alloc_header *best, *bestprev, *prev, *h;
+	void *p = NULL;
+	if (!get_dap_lock()) {
+		__release(dap_lock);	/* we never actually got it */
+		return NULL;
+	}
+	h = (struct debug_alloc_header *)(debug_alloc_pool + dah_first);
+	if (dah_first_call) {
+		h->size = sizeof(debug_alloc_pool_aligned) - dah_overhead;
+		dah_first_call = 0;
+	}
+	size = ALIGN(size, dah_align);
+	prev = best = bestprev = NULL;
+	while (1) {
+		if (h->size >= size && (!best || h->size < best->size)) {
+			best = h;
+			bestprev = prev;
+			if (h->size == size)
+				break;
+		}
+		if (!h->next)
+			break;
+		prev = h;
+		h = (struct debug_alloc_header *)(debug_alloc_pool + h->next);
+	}
+	if (!best)
+		goto out;
+	rem = best->size - size;
+	/* The pool must always contain at least one header */
+	if (best->next == 0 && bestprev == NULL && rem < dah_overhead)
+		goto out;
+	if (rem >= dah_overhead) {
+		best->size = size;
+		h_offset = ((char *)best - debug_alloc_pool) +
+			   dah_overhead + best->size;
+		h = (struct debug_alloc_header *)(debug_alloc_pool + h_offset);
+		h->size = rem - dah_overhead;
+		h->next = best->next;
+	} else
+		h_offset = best->next;
+	best->caller = __builtin_return_address(0);
+	dah_used += best->size;
+	dah_used_max = max(dah_used, dah_used_max);
+	if (bestprev)
+		bestprev->next = h_offset;
+	else
+		dah_first = h_offset;
+	p = (char *)best + dah_overhead;
+	memset(p, POISON_INUSE, best->size - 1);
+	*((char *)p + best->size - 1) = POISON_END;
+out:
+	spin_unlock(&dap_lock);
+	return p;
+}
+
+void
+debug_kfree(void *p)
+{
+	struct debug_alloc_header *h;
+	unsigned int h_offset;
+	if (!p)
+		return;
+	if ((char *)p < debug_alloc_pool ||
+	    (char *)p >= debug_alloc_pool + sizeof(debug_alloc_pool_aligned)) {
+		kfree(p);
+		return;
+	}
+	if (!get_dap_lock()) {
+		__release(dap_lock);	/* we never actually got it */
+		return;		/* memory leak, cannot be helped */
+	}
+	h = (struct debug_alloc_header *)((char *)p - dah_overhead);
+	memset(p, POISON_FREE, h->size - 1);
+	*((char *)p + h->size - 1) = POISON_END;
+	h->caller = NULL;
+	dah_used -= h->size;
+	h_offset = (char *)h - debug_alloc_pool;
+	if (h_offset < dah_first) {
+		h->next = dah_first;
+		dah_first = h_offset;
+	} else {
+		struct debug_alloc_header *prev;
+		unsigned int prev_offset;
+		prev = (struct debug_alloc_header *)(debug_alloc_pool + dah_first);
+		while (1) {
+			if (!prev->next || prev->next > h_offset)
+				break;
+			prev = (struct debug_alloc_header *)
+				(debug_alloc_pool + prev->next);
+		}
+		prev_offset = (char *)prev - debug_alloc_pool;
+		if (prev_offset + dah_overhead + prev->size == h_offset) {
+			prev->size += dah_overhead + h->size;
+			memset(h, POISON_FREE, dah_overhead - 1);
+			*((char *)h + dah_overhead - 1) = POISON_END;
+			h = prev;
+			h_offset = prev_offset;
+		} else {
+			h->next = prev->next;
+			prev->next = h_offset;
+		}
+	}
+	if (h_offset + dah_overhead + h->size == h->next) {
+		struct debug_alloc_header *next;
+		next = (struct debug_alloc_header *)
+			(debug_alloc_pool + h->next);
+		h->size += dah_overhead + next->size;
+		h->next = next->next;
+		memset(next, POISON_FREE, dah_overhead - 1);
+		*((char *)next + dah_overhead - 1) = POISON_END;
+	}
+	spin_unlock(&dap_lock);
+}
+
+void
+debug_kusage(void)
+{
+	struct debug_alloc_header *h_free, *h_used;
+#ifdef	CONFIG_IA64
+	/* FIXME: using dah for ia64 unwind always results in a memory leak.
+	 * Fix that memory leak first, then set debug_kusage_one_time = 1 for
+	 * all architectures.
+	 */
+	static int debug_kusage_one_time = 0;
+#else
+	static int debug_kusage_one_time = 1;
+#endif
+	if (!get_dap_lock()) {
+		__release(dap_lock);	/* we never actually got it */
+		return;
+	}
+	h_free = (struct debug_alloc_header *)(debug_alloc_pool + dah_first);
+	if (dah_first == 0 &&
+	    (h_free->size == sizeof(debug_alloc_pool_aligned) - dah_overhead ||
+	     dah_first_call))
+		goto out;
+	if (!debug_kusage_one_time)
+		goto out;
+	debug_kusage_one_time = 0;
+	kdb_printf("%s: debug_kmalloc memory leak dah_first %d\n",
+		   __FUNCTION__, dah_first);
+	if (dah_first) {
+		h_used = (struct debug_alloc_header *)debug_alloc_pool;
+		kdb_printf("%s: h_used %p size %d\n", __FUNCTION__, h_used, h_used->size);
+	}
+	do {
+		h_used = (struct debug_alloc_header *)
+			  ((char *)h_free + dah_overhead + h_free->size);
+		kdb_printf("%s: h_used %p size %d caller %p\n",
+			   __FUNCTION__, h_used, h_used->size, h_used->caller);
+		h_free = (struct debug_alloc_header *)
+			  (debug_alloc_pool + h_free->next);
+	} while (h_free->next);
+	h_used = (struct debug_alloc_header *)
+		  ((char *)h_free + dah_overhead + h_free->size);
+	if ((char *)h_used - debug_alloc_pool !=
+	    sizeof(debug_alloc_pool_aligned))
+		kdb_printf("%s: h_used %p size %d caller %p\n",
+			   __FUNCTION__, h_used, h_used->size, h_used->caller);
+out:
+	spin_unlock(&dap_lock);
+}
+
+/* Maintain a small stack of kdb_flags to allow recursion without disturbing
+ * the global kdb state.
+ */
+
+static int kdb_flags_stack[4], kdb_flags_index;
+
+void
+kdb_save_flags(void)
+{
+	BUG_ON(kdb_flags_index >= ARRAY_SIZE(kdb_flags_stack));
+	kdb_flags_stack[kdb_flags_index++] = kdb_flags;
+}
+
+void
+kdb_restore_flags(void)
+{
+	BUG_ON(kdb_flags_index <= 0);
+	kdb_flags = kdb_flags_stack[--kdb_flags_index];
+}
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 374faf9..be88346 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -504,3 +504,25 @@ __initcall(kallsyms_init);
 
 EXPORT_SYMBOL(__print_symbol);
 EXPORT_SYMBOL_GPL(sprint_symbol);
+
+#ifdef	CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+
+const char *kdb_walk_kallsyms(loff_t *pos)
+{
+	static struct kallsym_iter kdb_walk_kallsyms_iter;
+	if (*pos == 0) {
+		memset(&kdb_walk_kallsyms_iter, 0, sizeof(kdb_walk_kallsyms_iter));
+		reset_iter(&kdb_walk_kallsyms_iter, 0);
+	}
+	while (1) {
+		if (!update_iter(&kdb_walk_kallsyms_iter, *pos))
+			return NULL;
+		++*pos;
+		/* Some debugging symbols have no name.  Ignore them. */
+		if (kdb_walk_kallsyms_iter.name[0])
+			return kdb_walk_kallsyms_iter.name;
+	}
+}
+#endif	/* CONFIG_KGDB_KDB */
diff --git a/kernel/module.c b/kernel/module.c
index e797812..0523b4c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
+#include <linux/kdb.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/syscalls.h>
@@ -71,6 +72,10 @@
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
+#ifdef CONFIG_KGDB_KDB
+struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
+#endif /* CONFIG_KGDB_KDB */
+
 
 /* Waiting for a module to finish initializing? */
 static DECLARE_WAIT_QUEUE_HEAD(module_wq);
@@ -2547,8 +2552,14 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			char *name, char *module_name, int *exported)
 {
 	struct module *mod;
+#ifdef CONFIG_KGDB_KDB
+	int get_lock = !KDB_IS_RUNNING();
+#else
+#define	get_lock 1
+#endif
 
-	preempt_disable();
+	if (get_lock)
+		preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
@@ -2557,12 +2568,14 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, *value, mod);
-			preempt_enable();
+			if (get_lock)
+				preempt_enable();
 			return 0;
 		}
 		symnum -= mod->num_symtab;
 	}
-	preempt_enable();
+	if (get_lock)
+		preempt_enable();
 	return -ERANGE;
 }
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 874ecf1..fdb7e5b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/kdb.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -81,6 +82,11 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
+#ifdef CONFIG_KDB_KDUMP
+	if (kdb_kdump_state == KDB_KDUMP_RESET) {
+		(void)kdb(KDB_REASON_OOPS, 999, get_irq_regs());
+	}
+#endif
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
 	 * unfortunately means it may not be hardened to work in a panic
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..2c3e8ea 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -405,6 +405,20 @@ SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
 	return do_syslog(type, buf, len);
 }
 
+#ifdef	CONFIG_KGDB_KDB
+/* kdb dmesg command needs access to the syslog buffer.  do_syslog() uses locks
+ * so it cannot be used during debugging.  Just tell kdb where the start and
+ * end of the physical and logical logs are.  This is equivalent to do_syslog(3).
+ */
+void kdb_syslog_data(char *syslog_data[4])
+{
+	syslog_data[0] = log_buf;
+	syslog_data[1] = log_buf + log_buf_len;
+	syslog_data[2] = log_buf + log_end - (logged_chars < log_buf_len ? logged_chars : log_buf_len);
+	syslog_data[3] = log_buf + log_end;
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 /*
  * Call the console drivers on a range of log_buf
  */
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..fe5784e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9153,7 +9153,7 @@ void normalize_rt_tasks(void)
 
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_IA64
+#if	defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
 /*
  * These functions are only useful for the IA64 MCA handling.
  *
@@ -10239,3 +10239,94 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+#ifdef	CONFIG_KGDB_KDB
+
+#include <linux/kdb.h>
+
+static void
+kdb_prio(char *name, struct rt_prio_array *array, kdb_printf_t xxx_printf,
+	unsigned int cpu)
+{
+	int pri, printed_header = 0;
+	struct task_struct *p;
+
+	xxx_printf("  %s rt bitmap: 0x%lx 0x%lx 0x%lx\n",
+		name,
+		array->bitmap[0], array->bitmap[1], array->bitmap[2]);
+
+	pri = sched_find_first_bit(array->bitmap);
+	if (pri < MAX_RT_PRIO) {
+		xxx_printf("   rt bitmap priorities:");
+		while (pri < MAX_RT_PRIO) {
+			xxx_printf(" %d", pri);
+			pri++;
+			pri = find_next_bit(array->bitmap, MAX_RT_PRIO, pri);
+		}
+		xxx_printf("\n");
+	}
+
+	for (pri = 0; pri < MAX_RT_PRIO; pri++) {
+		int printed_hdr = 0;
+		struct list_head *head, *curr;
+
+		head = array->queue + pri;
+		curr = head->next;
+		while(curr != head) {
+			struct task_struct *task;
+			if (!printed_hdr) {
+				xxx_printf("   queue at priority=%d\n", pri);
+				printed_hdr = 1;
+			}
+			task = list_entry(curr, struct task_struct, rt.run_list);
+			if (task)
+				xxx_printf("    0x%p %d %s  time_slice:%d\n",
+				   task, task->pid, task->comm,
+				   task->rt.time_slice);
+			curr = curr->next;
+		}
+	}
+	for_each_process(p) {
+		if (p->se.on_rq && (task_cpu(p) == cpu) &&
+		   (p->policy == SCHED_NORMAL)) {
+			if (!printed_header) {
+				xxx_printf("  sched_normal queue:\n");
+				printed_header = 1;
+			}
+			xxx_printf("    0x%p %d %s pri:%d spri:%d npri:%d\n",
+				p, p->pid, p->comm, p->prio,
+				p->static_prio, p->normal_prio);
+		}
+	}
+}
+
+/* This code must be in sched.c because struct rq is only defined in this
+ * source.  To allow most of kdb to be modular, this code cannot call any kdb
+ * functions directly, any external functions that it needs must be passed in
+ * as parameters.
+ */
+
+void
+kdb_runqueue(unsigned long cpu, kdb_printf_t xxx_printf)
+{
+	struct rq *rq;
+
+	rq = cpu_rq(cpu);
+
+	xxx_printf("CPU%ld lock:%s curr:0x%p(%d)(%s)",
+		   cpu, (spin_is_locked(&rq->lock))?"LOCKED":"free",
+		   rq->curr, rq->curr->pid, rq->curr->comm);
+	if (rq->curr == rq->idle)
+		xxx_printf(" is idle");
+	xxx_printf("\n ");
+#ifdef CONFIG_SMP
+	xxx_printf(" cpu_load:%lu %lu %lu",
+			rq->cpu_load[0], rq->cpu_load[1], rq->cpu_load[2]);
+#endif
+	xxx_printf(" nr_running:%lu nr_switches:%llu\n",
+		   rq->nr_running, (long long)rq->nr_switches);
+	kdb_prio("active", &rq->rt.active, xxx_printf, (unsigned int)cpu);
+}
+EXPORT_SYMBOL(kdb_runqueue);
+
+#endif	/* CONFIG_KGDB_KDB */
diff --git a/kernel/signal.c b/kernel/signal.c
index d803473..8526c90 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2656,3 +2656,52 @@ void __init signals_init(void)
 {
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
+
+#ifdef CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+/*
+ * kdb_send_sig_info
+ *
+ *	Allows kdb to send signals without exposing signal internals.
+ *
+ * Inputs:
+ *	t	task
+ *	siginfo	signal information
+ *	seqno	current kdb sequence number (avoid including kdbprivate.h)
+ * Outputs:
+ *	None.
+ * Returns:
+ *	None.
+ * Locking:
+ *	Checks if the required locks are available before calling the main
+ *	signal code, to avoid kdb deadlocks.
+ * Remarks:
+ */
+void
+kdb_send_sig_info(struct task_struct *t, struct siginfo *info, int seqno)
+{
+	static struct task_struct *kdb_prev_t;
+	static int kdb_prev_seqno;
+	int sig, new_t;
+	if (!spin_trylock(&t->sighand->siglock)) {
+		kdb_printf("Can't do kill command now.\n"
+			"The sigmask lock is held somewhere else in kernel, try again later\n");
+		return;
+	}
+	spin_unlock(&t->sighand->siglock);
+	new_t = kdb_prev_t != t || kdb_prev_seqno != seqno;
+	kdb_prev_t = t;
+	kdb_prev_seqno = seqno;
+	if (t->state != TASK_RUNNING && new_t) {
+		kdb_printf("Process is not RUNNING, sending a signal from kdb risks deadlock\n"
+			   "on the run queue locks.  The signal has _not_ been sent.\n"
+			   "Reissue the kill command if you want to risk the deadlock.\n");
+		return;
+	}
+	sig = info->si_signo;
+	if (send_sig_info(sig, info, t))
+		kdb_printf("Fail to deliver Signal %d to process %d.\n", sig, t->pid);
+	else
+		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
+}
+#endif	/* CONFIG_KGDB_KDB */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 28c655b..5e65f6a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1533,6 +1533,28 @@ int hugetlb_overcommit_handler(struct ctl_table *table, int write,
 
 #endif /* CONFIG_SYSCTL */
 
+#ifdef	CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+/* Like hugetlb_report_meminfo() but using kdb_printf() */
+void
+kdb_hugetlb_report_meminfo(void)
+{
+	struct hstate *h = &default_hstate;
+	kdb_printf(
+		"HugePages_Total: %5lu\n"
+		"HugePages_Free:  %5lu\n"
+		"HugePages_Rsvd:  %5lu\n"
+		"HugePages_Surp:  %5lu\n"
+		"Hugepagesize:    %5lu kB\n",
+		h->nr_huge_pages,
+		h->free_huge_pages,
+		h->resv_huge_pages,
+		h->surplus_huge_pages,
+		1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h = &default_hstate;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 312fafe..7e3a336 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -13,6 +13,10 @@
 #include <linux/swap.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
+#ifdef	CONFIG_KGDB_KDB
+#include <linux/kdb.h>
+#include <linux/kdbprivate.h>
+#endif	/* CONFIG_KGDB_KDB */
 #include <linux/namei.h>
 #include <linux/shm.h>
 #include <linux/blkdev.h>
@@ -1937,6 +1941,24 @@ void si_swapinfo(struct sysinfo *val)
 	spin_unlock(&swap_lock);
 }
 
+#ifdef	CONFIG_KGDB_KDB
+/* Like si_swapinfo() but without the locks */
+void kdb_si_swapinfo(struct sysinfo *val)
+{
+	unsigned int i;
+	unsigned long nr_to_be_unused = 0;
+
+	for (i = 0; i < nr_swapfiles; i++) {
+		if (!(swap_info[i].flags & SWP_USED) ||
+		     (swap_info[i].flags & SWP_WRITEOK))
+			continue;
+		nr_to_be_unused += swap_info[i].inuse_pages;
+	}
+	val->freeswap = nr_swap_pages + nr_to_be_unused;
+	val->totalswap = total_swap_pages + nr_to_be_unused;
+}
+#endif	/* CONFIG_KGDB_KDB */
+
 /*
  * Verify that a swap entry is valid and increment its swap map count.
  *
-- 
1.6.3.rc0.1.gf800

