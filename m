Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXCUGrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXCUGrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXCUGrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:47:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:15145 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXCUGrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:47:36 -0400
Message-ID: <d4cf37a60703202347o67740694jc1c9030c647ff7c6@mail.gmail.com>
Date: Tue, 20 Mar 2007 23:47:35 -0700
From: "Wink Saville" <wink@saville.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Initial implementation of the trec driver and include files
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wink Saville <wink@saville.com>
---
 drivers/trec/Kconfig       |   14 ++
 drivers/trec/Makefile      |    5 +
 drivers/trec/trec.c        |  328 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/trec.h |   17 +++
 include/asm-i386/trec.h    |   33 +++++
 include/asm-x86_64/trec.h  |   13 ++
 include/linux/trec.h       |   34 +++++
 7 files changed, 444 insertions(+), 0 deletions(-)
 create mode 100644 drivers/trec/Kconfig
 create mode 100644 drivers/trec/Makefile
 create mode 100644 drivers/trec/trec.c
 create mode 100644 include/asm-generic/trec.h
 create mode 100644 include/asm-i386/trec.h
 create mode 100644 include/asm-x86_64/trec.h
 create mode 100644 include/linux/trec.h

diff --git a/drivers/trec/Kconfig b/drivers/trec/Kconfig
new file mode 100644
index 0000000..ef43f1f
--- /dev/null
+++ b/drivers/trec/Kconfig
@@ -0,0 +1,14 @@
+#
+# Trace record configuration
+#
+
+menu "Trace record support"
+
+config TREC
+	def_bool n
+	bool "Trace record support"
+	---help---
+	  Trace records are a light weight tracing facility
+
+endmenu
+
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
index 0000000..8d954ca
--- /dev/null
+++ b/drivers/trec/trec.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright (C) 2007 Saville Software, Inc.
+ *
+ * This code may be used for any purpose whatsoever, but
+ * no warranty of any kind is provided.
+ */
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/smp.h>
+#include <linux/kallsyms.h>
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
+static int trec_open(struct inode *inode, struct file *pFile);
+static int trec_release(struct inode *inode, struct file *pFile);
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
+	struct trec_buffer_struct *	pNext;
+	struct trec_struct *		pCur;
+	struct trec_struct *		pEnd;
+	struct trec_struct		data[TREC_DATA_SIZE];
+};
+
+/*
+ * Number of buffers must be a multiple of two so we can
+ * snapshot the buffers and the minimum should be 4.
+ */
+#define	TREC_COUNT 2
+struct trec_buffer_struct 	gTrec_buffers[2][TREC_COUNT];
+int				gTrec_idx = 0;
+spinlock_t 			gTrec_lock = SPIN_LOCK_UNLOCKED;
+
+struct trec_buffer_struct *	pTrec_cur = NULL;
+struct trec_buffer_struct *	pTrec_snapshot = NULL;
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
+	return 0;
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
+	//DPK("trec: trec_init E\n");
+
+	for (i = 0; i < 2; i++) {
+		for (j = 0; j < TREC_COUNT; j++) {
+			struct trec_buffer_struct *pTrec = &gTrec_buffers[i][j];
+
+			pTrec->pNext = &gTrec_buffers[i][(j+1) % TREC_COUNT];
+			pTrec->pCur = &pTrec->data[0];
+			pTrec->pEnd = &pTrec->data[TREC_DATA_SIZE];
+			memset(pTrec->pCur, 0, sizeof(pTrec->data));
+		}
+	}
+
+	gTrec_idx = 0;
+	pTrec_cur = &gTrec_buffers[gTrec_idx][0];
+	pTrec_snapshot = NULL;
+
+	//DPK("trec: trec_init X\n");
+}
+EXPORT_SYMBOL(trec_init);
+
+/*
+ * Write a trec entry
+ */
+void trec_write(unsigned long pc, int pid, unsigned long v1, unsigned long v2)
+{
+	struct trec_struct *pTrec;
+	int flags;
+
+	spin_lock_irqsave(&gTrec_lock, flags);
+	pTrec = pTrec_cur->pCur;
+	pTrec_cur->pCur += 1;
+	if (pTrec_cur->pCur >= pTrec_cur->pEnd) {
+		pTrec_cur = pTrec_cur->pNext;
+		pTrec_cur->pCur = &pTrec_cur->data[0];
+	}
+	spin_unlock_irqrestore(&gTrec_lock, flags);
+
+	pTrec->tsc = rd_tsc();	
+	pTrec->pc = pc;
+	pTrec->pid = pid;
+	pTrec->tsk = (unsigned long)current;
+	pTrec->v1 = v1;
+	pTrec->v2 = v2;
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
+	spin_lock_irqsave(&gTrec_lock, flags);
+	pTrec_snapshot = pTrec_cur;
+	gTrec_idx = gTrec_idx ^ 1;
+	pTrec_cur = &gTrec_buffers[gTrec_idx][0];
+	spin_unlock_irqrestore(&gTrec_lock, flags);
+}
+EXPORT_SYMBOL(trec_snapshot);
+
+/*
+ * trec_print
+ */
+void trec_print_snapshot(void)
+{
+	int i;
+	struct trec_buffer_struct *pCur_buffer;
+
+	printk(KERN_ERR "\ntrec_print_snapshot:\n");
+
+	pCur_buffer = pTrec_snapshot->pNext;
+	for (i = 0; i < TREC_COUNT; i++) {
+		struct trec_struct *pCur;
+
+		for (pCur = &pCur_buffer->data[0];
+			pCur < pCur_buffer->pCur;
+			pCur += 1) {
+			char b[256];
+			int n;
+			
+			n = snprintf(b, sizeof(b), KERN_ERR "t=%20llu pid=%5u tsk=%p v1=%p v2=%p",
+					pCur->tsc, pCur->pid, (void *)pCur->tsk, (void *)pCur->v1, (void
*)pCur->v2);
+			n += snprint_address(b+n, sizeof(b)-n, pCur->pc);
+			printk("%s\n", b);
+		}
+		pCur_buffer = pCur_buffer->pNext;
+	}
+
+	printk(KERN_ERR "trec_print_snapshot done\n");
+}
+EXPORT_SYMBOL(trec_print_snapshot);
+
+/*
+ * Open
+ */
+static int trec_open(struct inode *inode, struct file *pFile)
+{
+	int result = 0;
+	struct trec_dev_struct *pDev;
+
+	DPK("trec_open: E\n");
+
+	pDev = container_of(inode->i_cdev, struct trec_dev_struct, cdev);
+	pFile->private_data = (void *)pDev;
+
+	DPK("trec_open: X result=%d\n", result);
+	return result;
+}
+
+/*
+ * Release/Close
+ */
+static int trec_release(struct inode *inode, struct file *pFile)
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
+static int trec_device_init(void)
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
+		goto done;
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
+		goto done;
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
+	if (pTrec_cur == NULL) {
+		trec_init();
+	}
+
+	TREC0();
+	TREC1(1);
+	TREC2(2,3);
+
+	result = 0;
+done:	
+	DPK("trec_device_init: X result=%d major=%d minor=%d\n", result,
major, minor);
+	return result;
+}
+
+/*
+ * Exit routine for trec device
+ */
+static void trec_device_exit(void)
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
index 0000000..8b5d235
--- /dev/null
+++ b/include/linux/trec.h
@@ -0,0 +1,34 @@
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
+#include <linux/sched.h>	/* For current->pid */
+#include <asm/processor.h>	/* For current_text_addr */
+
+#define TREC_PC_ADDR		((unsigned long)(current_text_addr()))
+#define TREC_PID		(current->pid)
+
+#define TREC0()			trec_write(TREC_PC_ADDR, TREC_PID, 0, 0)
+#define TREC1(__v)		trec_write(TREC_PC_ADDR, TREC_PID, (unsigned long)(__v), 0)
+#define TREC2(__v1, __v2)	trec_write(TREC_PC_ADDR, TREC_PID,
(unsigned long)(__v1), (unsigned long)(__v2))
+#define TREC_RETV(__retv) 	do { TREC0(); return(__retv); } while (0)
+#define TREC_RET() 		do { TREC0(); return; } while (0)
+
+#define ZREC0()			do { } while (0)
+#define ZREC1(__v)		do { } while (0)
+#define ZREC2(__v1, __v2)	do { } while (0)
+#define ZREC_RETV(__retv) 	do { } while (0)
+#define ZREC_RET() 		do { } while (0)
+
+extern void trec_init(void);
+extern void trec_write(unsigned long pc, int pid, unsigned long v1,
unsigned long v2);
+extern void trec_snapshot(void);
+extern void trec_print_snapshot(void);
+
+#endif /* _TREC_H */
-- 
1.5.0.rc2
