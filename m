Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXCXX7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXCXX7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 19:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXCXX7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 19:59:48 -0400
Received: from 70-91-206-233-BusName-SFBA.hfc.comcastbusiness.net ([70.91.206.233]:44227
	"EHLO winkc2d1.saville.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S964780AbXCXX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 19:59:06 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Mar 2007 19:59:03 EDT
From: Wink Saville <wink@saville.com>
To: linux-kernel@vger.kernel.org
Cc: Wink Saville <wink@saville.com>
Subject: [PATCH 2/3] Trec driver.
Date: Sat, 24 Mar 2007 16:51:38 -0700
Message-Id: <11747803002933-git-send-email-wink@saville.com>
X-Mailer: git-send-email 1.5.0.rc2
In-Reply-To: <11747802992043-git-send-email-wink@saville.com>
References: trec-take2 <11747802992043-git-send-email-wink@saville.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Trec driver, Makefile, header files.
Enable trec in Kernel hacking configuration menu.

Signed-off-by: Wink Saville <wink@saville.com>
---
 drivers/Makefile           |    1 +
 drivers/trec/Makefile      |    5 +
 drivers/trec/trec.c        |  404 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/trec.h |   17 ++
 include/asm-i386/trec.h    |   33 ++++
 include/asm-x86_64/trec.h  |   13 ++
 include/linux/trec.h       |   75 ++++++++
 lib/Kconfig.debug          |    7 +
 8 files changed, 555 insertions(+), 0 deletions(-)
 create mode 100644 drivers/trec/Makefile
 create mode 100644 drivers/trec/trec.c
 create mode 100644 include/asm-generic/trec.h
 create mode 100644 include/asm-i386/trec.h
 create mode 100644 include/asm-x86_64/trec.h
 create mode 100644 include/linux/trec.h

diff --git a/drivers/Makefile b/drivers/Makefile
index 3a718f5..01724c0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -81,3 +81,4 @@ obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
+obj-$(CONFIG_TREC)		+= trec/
diff --git a/drivers/trec/Makefile b/drivers/trec/Makefile
new file mode 100644
index 0000000..d930b4d
--- /dev/null
+++ b/drivers/trec/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for Trace records.
+#
+
+obj-$(CONFIG_TREC)	+= trec.o
diff --git a/drivers/trec/trec.c b/drivers/trec/trec.c
new file mode 100644
index 0000000..0b04b71
--- /dev/null
+++ b/drivers/trec/trec.c
@@ -0,0 +1,404 @@
+/*
+ * Copyright (C) 2007 Saville Software, Inc.
+ *
+ * This code may be used for any purpose whatsoever,
+ * but no warranty of any kind is provided.
+ */
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/smp.h>
+#include <linux/kallsyms.h>
+#include <linux/sysrq.h>
+#include <linux/trec.h>
+
+#include <asm/trec.h>
+
+#define TREC_DEBUG
+#ifdef TREC_DEBUG
+#define DPK(fmt, args...) printk(KERN_ERR "trec " fmt, ## args)
+#else
+#define DPK(fmt, args...)
+#endif
+
+struct trec_dev_struct
+{
+	struct	cdev		cdev;			/* Character device structure */
+};
+
+MODULE_AUTHOR("Wink Saville");
+MODULE_LICENSE("Dual BSD/GPL");
+
+/*
+ * Module parameters
+ */
+int major = 240;	/* 240 a "local/expermental" device number for the moment */
+int minor = 1;
+
+module_param(major, int, S_IRUGO);
+module_param(minor, int, S_IRUGO);
+
+/*
+ * Forward declarations
+ */
+static int trec_open(struct inode *inode, struct file *file);
+static int trec_release(struct inode *inode, struct file *file);
+
+/*
+ * File operations
+ */
+struct file_operations trec_f_ops = {
+	.owner		=	THIS_MODULE,
+	.open		=	trec_open,
+	.release	=	trec_release,
+};
+
+struct trec_struct {
+	uint64_t	tsc;
+	unsigned long	pc;
+	unsigned long	tsk;
+	unsigned int	pid;
+	unsigned long	v1;
+	unsigned long	v2;
+};
+
+/*
+ * Change trec_buffer_struct.data to be a pointer to a PAGE in the future
+ */
+#define TREC_DATA_SIZE 0x200
+struct trec_buffer_struct {
+	struct trec_buffer_struct *	next;
+	struct trec_struct *		cur;
+	struct trec_struct *		end;
+	struct trec_struct		data[TREC_DATA_SIZE];
+};
+
+/*
+ * Number of buffers must be a multiple of two so we can
+ * snapshot the buffers and the minimum should be 4.
+ */
+#define	TREC_COUNT 2
+struct trec_buffer_struct 	trec_buffers[2][TREC_COUNT];
+int				trec_idx = 0;
+spinlock_t 			trec_lock = SPIN_LOCK_UNLOCKED;
+
+struct trec_buffer_struct *	trec_buffer_cur = NULL;
+struct trec_buffer_struct *	trec_buffer_snapshot = NULL;
+
+struct trec_dev_struct 		trec_dev;
+
+/**
+ * Print an address symbol if available to the buffer
+ * this is from traps.c
+ */
+static int snprint_address(char *b, int bsize, unsigned long address)
+{
+#ifdef CONFIG_KALLSYMS
+	unsigned long offset = 0, symsize;
+	const char *symname;
+	char *modname;
+	char *delim = ":";
+	int n;
+	char namebuf[128];
+
+	symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
+	if (!symname) {
+		n = 0;
+	} else {
+		if (!modname)
+			modname = delim = ""; 		
+		n = snprintf(b, bsize, "0x%016lx %s%s%s%s+0x%lx/0x%lx",
+			address, delim, modname, delim, symname, offset, symsize);
+	}
+	return n;
+#else
+	return snprintf(b, bsize, "0x%016lx", address);
+#endif
+}
+
+/*
+ * Initialize the trec buffers
+ */
+void trec_init(void)
+{
+	int i;
+	int j;
+
+	DPK("trec: trec_init E\n");
+
+	for (i = 0; i < 2; i++) {
+		for (j = 0; j < TREC_COUNT; j++) {
+			struct trec_buffer_struct *trec = &trec_buffers[i][j];
+
+			trec->next = &trec_buffers[i][(j+1) % TREC_COUNT];
+			trec->cur = &trec->data[0];
+			trec->end = &trec->data[TREC_DATA_SIZE];
+			memset(trec->cur, 0, sizeof(trec->data));
+		}
+	}
+
+	trec_idx = 0;
+	trec_buffer_cur = &trec_buffers[trec_idx][0];
+	trec_buffer_snapshot = NULL;
+
+	DPK("trec: trec_init X\n");
+}
+EXPORT_SYMBOL(trec_init);
+
+/*
+ * Write a trec entry
+ */
+void trec_write(unsigned long pc, int pid, unsigned long v1, unsigned long v2)
+{
+	struct trec_struct *trec;
+	int flags;
+
+	spin_lock_irqsave(&trec_lock, flags);
+	trec = trec_buffer_cur->cur;
+	trec_buffer_cur->cur += 1;
+	if (trec_buffer_cur->cur >= trec_buffer_cur->end) {
+		trec_buffer_cur = trec_buffer_cur->next;
+		trec_buffer_cur->cur = &trec_buffer_cur->data[0];
+	}
+	spin_unlock_irqrestore(&trec_lock, flags);
+
+	trec->tsc = rd_tsc();	
+	trec->pc = pc;
+	trec->pid = pid;
+	trec->tsk = (unsigned long)current;
+	trec->v1 = v1;
+	trec->v2 = v2;
+}
+EXPORT_SYMBOL(trec_write);
+
+/*
+ * Snapshot the current trecs
+ */
+void trec_snapshot(void)
+{
+	int flags;
+
+	spin_lock_irqsave(&trec_lock, flags);
+	trec_buffer_snapshot = trec_buffer_cur;
+	trec_idx = trec_idx ^ 1;
+	trec_buffer_cur = &trec_buffers[trec_idx][0];
+	spin_unlock_irqrestore(&trec_lock, flags);
+}
+EXPORT_SYMBOL(trec_snapshot);
+
+/*
+ * trec_print
+ */
+void trec_print_snapshot(void)
+{
+	int i;
+	struct trec_buffer_struct *cur_buffer;
+
+	if (!trec_buffer_snapshot)
+		trec_snapshot();
+
+	cur_buffer = trec_buffer_snapshot->next;
+	for (i = 0; i < TREC_COUNT; i++) {
+		struct trec_struct *cur;
+
+		for (cur = &cur_buffer->data[0];
+			cur < cur_buffer->cur;
+			cur += 1) {
+			char b[256];
+			int n;
+			
+			n = snprintf(b, sizeof(b), KERN_ERR "t=%20llu pid=%5u tsk=%p v1=%p v2=%p ",
+				cur->tsc, cur->pid, (void *)cur->tsk, (void *)cur->v1, (void *)cur->v2);
+			n += snprint_address(b+n, sizeof(b)-n, cur->pc);
+			printk("%s\n", b);
+		}
+		cur_buffer = cur_buffer->next;
+	}
+}
+EXPORT_SYMBOL(trec_print_snapshot);
+
+/*
+ * Sysrq support for trec's
+ */
+#ifdef CONFIG_MAGIC_SYSRQ
+/*
+ * trec print snapshot handler for sysrq
+ */
+static void sysrq_handle_trec_print_snapshot(int key, struct tty_struct *tty) 
+{
+	trec_print_snapshot();
+}
+
+/*
+ * trec snapshot handler for sysrq
+ */
+static void sysrq_handle_trec_snapshot(int key, struct tty_struct *tty) 
+{
+	trec_snapshot();
+}
+
+static struct sysrq_key_op sysrq_trec_snapshot_op = 
+{
+	.handler =	sysrq_handle_trec_snapshot,
+	.help_msg =	"Trec snapshot(Y)",
+	.action_msg =	"Trec snapshot",
+};
+
+static struct sysrq_key_op sysrq_trec_print_snapshot_op = 
+{
+	.handler =	sysrq_handle_trec_print_snapshot,
+	.help_msg =	"Print current trec snapshot",
+	.action_msg =	"Trec print snapshot(Z)",
+};
+
+/*
+ * Initilize trec sysrq support
+ */
+static int __init setup_trec_sysrq(void)
+{
+	DPK("setup_trec_sysrq y=trec_snapshot z=trec_print_snapshot\n");
+	register_sysrq_key('y', &sysrq_trec_snapshot_op);
+	register_sysrq_key('z', &sysrq_trec_print_snapshot_op);
+	return 0;
+}
+__initcall(setup_trec_sysrq);
+#endif /* CONFIG_MAGIC_SYSRQ */
+
+/*
+ * Open
+ */
+static int trec_open(struct inode *inode, struct file *file)
+{
+	int result = 0;
+	struct trec_dev_struct *dev;
+       
+	DPK("trec_open: E\n");
+
+	dev = container_of(inode->i_cdev, struct trec_dev_struct, cdev);
+	file->private_data = (void *)dev;
+
+	DPK("trec_open: X result=%d\n", result);
+	return result;
+}
+
+/*
+ * Release/Close
+ */
+static int trec_release(struct inode *inode, struct file *file)
+{
+	int	result = 0; 
+
+	DPK("trec_release: E\n");
+	
+	DPK("trec_release: X result=%d\n", result);
+	return result;
+}
+
+/*
+ * Init routine for the trec device
+ */
+static int __init trec_device_init(void)
+{
+	int 		result;
+	dev_t 		dev_number = 0;
+	static struct 	class *trec_class;
+
+	DPK("trec_device_init: E\n");
+
+	if (major) {
+		dev_number = MKDEV(major, minor);
+		result = register_chrdev_region(dev_number, 1, "trec");
+		DPK("trec_device_init: static major result=%d\n", result);
+	} else {
+		result = alloc_chrdev_region(&dev_number, minor, 1, "trec");
+		major = MAJOR(dev_number);
+		DPK("trec_device_init: dynamic major result=%d\n", result);
+	}	
+
+	if (result < 0) {
+		printk(KERN_WARNING "trec: can't get major %d\n", major);
+		goto err;
+	}
+
+	cdev_init(&trec_dev.cdev, &trec_f_ops);
+	trec_dev.cdev.owner = THIS_MODULE;
+	trec_dev.cdev.ops = &trec_f_ops;
+	
+	result = cdev_add(&trec_dev.cdev, dev_number, 1);
+	if (result)
+	{
+		DPK("trec_device_init: cdev_add failed\n");
+		goto err;
+	}
+
+	/*
+	 * Make a trec class and create the device
+	 */
+	trec_class = class_create(THIS_MODULE, "trec");
+	class_device_create(trec_class, NULL, dev_number, NULL, "trec");
+
+	/*
+	 * If the trec buffers have not been initialized do so
+	 */
+	if (trec_buffer_cur == NULL) {
+		trec_init();
+	}
+
+	/*
+	 * Test macros
+	 */
+	TREC(1, 2);
+	TRECC(1, 3, 4);
+	TRECC0(1);
+	TRECC1(1, 5);
+	TRECC2(1, 6, 7);
+
+	TREC0();
+	TREC1(8);
+	TREC2(9, 10);
+
+#undef TREC_ENABLED
+#define TREC_ENABLED 0
+	/*
+	 * Should not be in the trec buffer
+	 */
+	TREC(1, 11);
+	TRECC(1, 12, 13);
+	TRECC0(1);
+	TRECC1(1, 14);
+	TRECC2(1, 15, 16);
+
+	TREC0();
+	TREC1(17);
+	TREC2(18, 19);
+#undef TREC_ENABLED
+#define TREC_ENABLED 1
+
+	result = 0;
+	goto out;
+
+err:
+	unregister_chrdev_region(dev_number, 1);
+out:
+	DPK("trec_device_init: X result=%d major=%d minor=%d\n", result, major, minor);
+	TREC_RETV(result);
+}
+
+/*
+ * Exit routine for trec device
+ */
+static void __exit trec_device_exit(void)
+{
+	dev_t dev_number = MKDEV(major, minor);
+
+	DPK("trec_device_exit: E\n");
+
+	unregister_chrdev_region(dev_number, 1);
+
+	DPK("trec_device_exit: X\n");
+}
+
+module_init(trec_device_init);
+module_exit(trec_device_exit);
+
diff --git a/include/asm-generic/trec.h b/include/asm-generic/trec.h
new file mode 100644
index 0000000..4d8dffb
--- /dev/null
+++ b/include/asm-generic/trec.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2007 Saville Software, Inc.
+ *
+ * This code may be used for any purpose whatsoever, but
+ * no warranty of any kind is provided.
+ */
+
+#ifndef _ASM_GENERIC_TREC_H
+#define _ASM_GENERIC_TREC_H
+
+#ifndef __ASSEMBLY__
+
+#define rd_tsc() (0)
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_GENERIC_TREC_H */
diff --git a/include/asm-i386/trec.h b/include/asm-i386/trec.h
new file mode 100644
index 0000000..1de4dc6
--- /dev/null
+++ b/include/asm-i386/trec.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) 2007 Saville Software, Inc.
+ *
+ * This code may be used for any purpose whatsoever, but
+ * no warranty of any kind is provided.
+ */
+
+#ifndef _ASM_I386_TREC_H
+#define _ASM_I386_TREC_H
+
+#ifndef __ASSEMBLY__
+
+#if CONFIG_X86_TSC 
+#include <asm/msr.h>
+
+/*
+ * read x86 time stamp counter.
+ */
+static uint64_t inline rd_tsc(void)
+{
+	volatile uint64_t value;
+
+	rdtscll(value);
+
+	return value;
+}
+#else
+	#define rd_tsc() (0)
+#endif /* CONFIG_X86_TSC */
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_I386_TREC_H */
diff --git a/include/asm-x86_64/trec.h b/include/asm-x86_64/trec.h
new file mode 100644
index 0000000..ba2a852
--- /dev/null
+++ b/include/asm-x86_64/trec.h
@@ -0,0 +1,13 @@
+/*
+ * Copyright (C) 2007 Saville Software, Inc.
+ *
+ * This code may be used for any purpose whatsoever, but
+ * no warranty of any kind is provided.
+ */
+
+#ifndef _ASM_X86_64_TREC_H
+#define _ASM_X86_64_TREC_H
+
+#include <asm-i386/trec.h>
+
+#endif /* _ASM_X86_64_TREC_H */
diff --git a/include/linux/trec.h b/include/linux/trec.h
new file mode 100644
index 0000000..d5d8e74
--- /dev/null
+++ b/include/linux/trec.h
@@ -0,0 +1,75 @@
+/*
+ * Copyright (C) 2007 Saville Software, Inc.
+ *
+ * This code may be used for any purpose whatsoever, but
+ * no warranty of any kind is provided.
+ */
+
+#ifndef _TREC_H
+#define _TREC_H
+
+#if defined(CONFIG_TREC)
+
+#include <linux/sched.h>	/* For current->pid */
+#include <asm/processor.h>	/* For current_text_addr */
+
+#define TREC_PC_ADDR		((unsigned long)(current_text_addr()))
+#define TREC_PID		(current->pid)
+
+#ifndef TREC_ENABLED
+#define TREC_ENABLED 		1
+#endif
+
+#define TREC(__v1, __v2) \
+	do { \
+		if (TREC_ENABLED) \
+			trec_write(TREC_PC_ADDR, TREC_PID, (unsigned long)(__v1), (unsigned long)(__v2)); \
+       	} while (0)
+
+
+#define TRECC(__c, __v1, __v2)	do { if ((__c)) TREC(__v1, __v2); } while (0)
+#define TRECC0(__c) 		TRECC(__c, 0, 0)
+#define TRECC1(__c, __v1)	TRECC(__c, __v1, 0)
+#define TRECC2(__c, __v1, __v2) TRECC(__c, __v1, __v2)
+#define TRECC0_RETV(__c,__retv) do { TRECC0(__c); return(__retv); } while (0)
+#define TRECC0_RET(__c) 	do { TRECC0(__c); return; } while (0)
+
+#define TREC0() 		TRECC0(1)
+#define TREC1(__v) 		TRECC1(1, (__v)) 
+#define TREC2(__v1, __v2)	TRECC2(1, (__v1), (__v2)) 
+#define TREC_RETV(__retv) 	TRECC0_RETV(1, __retv)
+#define TREC_RET() 		TRECC0_RET(1)
+
+extern void trec_init(void);
+extern void trec_write(unsigned long pc, int pid, unsigned long v1, unsigned long v2);
+extern void trec_snapshot(void);
+extern void trec_print_snapshot(void);
+
+#else
+
+/*
+ * All TREC's are disabled
+ */
+#define TREC_ENABLED 		0
+
+#define TREC(__v1, __v2)	do { } while (0)
+
+#define TRECC(__c,__v1, __v2)	do { } while (0)
+#define TRECC0(__c)		do { } while (0)
+#define TRECC1(__c, __v)	do { } while (0)
+#define TRECC2(__c, __v1, __v2)	do { } while (0)
+
+#define TREC0()			do { } while (0)
+#define TREC1(__v)		do { } while (0)
+#define TREC2(__v1, __v2)	do { } while (0)
+#define TREC_RETV(__retv) 	do { return(__retv); } while (0)
+#define TREC_RET() 		do { return; } while (0)
+
+static inline void trec_init(void) {}
+static inline void trec_write(unsigned long pc, int pid, unsigned long v1, unsigned long v2) {}
+static inline void trec_snapshot(void) {}
+static inline void trec_print_snapshot(void) {}
+
+#endif /* CONFIG_TREC && !TREC_DISABLED */
+
+#endif /* _TREC_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3f3e740..db53fdb 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -303,6 +303,13 @@ config STACKTRACE
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 
+config TREC
+ 	def_bool n
+ 	bool "Trace record support"
+ 	depends on DEBUG_KERNEL
+ 	help
+ 	  Trace records are a light weight tracing facility
+
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
-- 
1.5.0.rc2

