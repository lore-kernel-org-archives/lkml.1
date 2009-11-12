Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZKLCNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZKLCNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbZKLCNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:13:18 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:28310 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbZKLCNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:13:16 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADb++kqrR7Hu/2dsb2JhbADFBJgJhDwE
X-IronPort-AV: E=Sophos;i="4.44,726,1249257600"; 
   d="scan'208";a="269845762"
Date: Wed, 11 Nov 2009 21:13:22 -0500
From: David VomLehn <dvomlehn@cisco.com>
To: linux-embedded@vger.kernel.org
Cc: akpm@linux-foundation.org, dwm2@infradead.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows annotation of panics to include platform information. It's no big
deal to collect information, but way helpful when you are collecting
failure reports from a eventual base of millions of systems deployed in
other people's homes.

One of the biggest reasons this is an RFC is that I'm uncomfortable with
putting the pseudo-file that holds the annotation information in /proc.
Different layers of the software stack may drop dynamic information, such
as DHCP-supplied IP addresses, in here as they come up. This means it's
necessary to be able to append to the end of the annotation, so this looks
much more like a real file than a sysctl file.  It also has multiple lines,
which doesn't look a sysctl file. Annotation can be viewed as a debug thing,
so maybe it belongs in debugfs, but people seem to be doing somewhat different
things with that filesystem.

So, suggestions on this issue, and any others are most welcome. If there a
better way to do this, I'll be happy to use it.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 fs/proc/Makefile       |    1 +
 fs/proc/panic-note.c   |  293 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kernel.h |    7 +
 kernel/panic.c         |    1 +
 lib/Kconfig.debug      |    8 ++
 5 files changed, 310 insertions(+), 0 deletions(-)

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index 11a7b5c..486d273 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -26,3 +26,4 @@ proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
 proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
+proc-$(CONFIG_PANIC_NOTE)	+= panic-note.o
diff --git a/fs/proc/panic-note.c b/fs/proc/panic-note.c
new file mode 100644
index 0000000..449c5ef
--- /dev/null
+++ b/fs/proc/panic-note.c
@@ -0,0 +1,293 @@
+/*
+ *				panic-note.c
+ *
+ * Allow a blob to be registered with the kernel that will be printed if
+ * the kernel panics.
+ *
+ * Copyright (C) 2009  Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/* Open issues:
+ * Where should the panic_note file be created? It's almost like a sysctl,
+ * but doesn't follow the same rules. When you write to a sysctl file, the
+ * previous data is replaced. When you write to the panic_note file, you
+ * can append to the end of the existing data.
+ */
+
+#include <linux/semaphore.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+/* Maximum size, in bytes, allowed for the blob. Having this limit prevents
+ * an inadvertant denial of service attack that might happen if someone with
+ * root privileges was automatically generating this note and the generator
+ * had an infinite loop. Perhaps this is more of a a denial of service
+ * suicide. */
+#define PANIC_NOTE_SIZE		(PAGE_SIZE * 4)
+
+/*
+ * struct panic_note_data - Information about the panic note
+ * @n:		Number of bytes in the note
+ * @p:		Pointer to the data in the note
+ * @sem:	Semaphore controlling access to data in the note
+ */
+struct panic_note_state {
+	size_t			n;
+	void			*p;
+	struct rw_semaphore	sem;
+};
+
+static struct panic_note_state panic_note_state = {
+	0, NULL, __RWSEM_INITIALIZER(panic_note_state.sem)
+};
+static const struct file_operations panic_note_fops;
+static struct inode_operations panic_note_iops;
+static struct proc_dir_entry *panic_note_entry;
+
+/*
+ * panic_note_print - display the panic note
+ * @priority:	Printk priority to use, e.g. KERN_EMERG
+ */
+void panic_note_print()
+{
+	int i;
+	int linelen;
+
+	/* We skip the semaphore stuff because we're in a panic situation and
+	 * the scheduler isn't available in case the semaphore is already owned
+	 * by someone else */
+	for (i = 0; i < panic_note_state.n; i += linelen) {
+		const char *p;
+		int remaining;
+		const char *nl;
+
+		p = panic_note_state.p + i;
+		remaining = panic_note_state.n - i;
+
+		nl = memchr(p, '\n', remaining);
+
+		if (nl == NULL) {
+			linelen = remaining;
+			pr_emerg("%.*s\n", linelen, p);
+		} else {
+			linelen = nl - p + 1;
+			pr_emerg("%.*s", linelen, p);
+		}
+	}
+}
+
+/*
+ * read_write_size - calculate the limited copy_to_user/copy_from_user count
+ * @nbytes:	The number of bytes requested
+ * @pos:	Offset, in bytes, into the file
+ * @size:	Maximum I/O offset, in bytes. For a read, this is the actual
+ *		number of bytes in the file, since you can't read past
+ *		the end. Writes can be done after the number of bytes in the
+ *		file, so this is the maximum possible file size, minus one.
+ *
+ * Returns the number of bytes to copy.
+ */
+static ssize_t read_write_size(size_t nbytes, loff_t pos, size_t size)
+{
+	ssize_t retval;
+
+	if (pos >= size)
+		retval = 0;
+
+	else {
+		retval = size - pos;
+		if (retval > nbytes)
+			retval = nbytes;
+	}
+
+	return retval;
+}
+
+/*
+ * panic_note_read - return data from the panic note
+ * @filp:	Pointer to information on the file
+ * @buf:	Pointer, in user space, to the buffer in which to return the
+ * 		data
+ * @nbytes:	Number of bytes requested
+ * @ppos:	Pointer to file position
+ *
+ * Returns the number of bytes actually transferred, or a negative errno
+ * value if none could be transferred.
+ */
+static ssize_t panic_note_read(struct file *filp, char __user *buf,
+	size_t nbytes, loff_t *ppos)
+{
+	ssize_t retval;
+	ssize_t result;
+
+	down_read(&panic_note_state.sem);
+	panic_note_entry->size = panic_note_state.n;
+	retval = read_write_size(nbytes, *ppos, panic_note_state.n);
+
+	if (retval > 0) {
+		result = copy_to_user(buf, panic_note_state.p + *ppos, retval);
+
+		if (result != 0)
+			retval = -EFAULT;
+		else
+			*ppos += retval;
+	}
+	up_read(&panic_note_state.sem);
+
+	return retval;
+}
+
+/*
+ * panic_note_write - store data in the panic note
+ * @filp:	Pointer to information on the file
+ * @buf:	Pointer, in user space, to the buffer from which to retrieve the
+ * 		data
+ * @nbytes:	Number of bytes requested
+ * @ppos:	Pointer to file position
+ *
+ * Returns the number of bytes actually transferred, or a negative errno
+ * value if none could be transferred.
+ */
+static ssize_t panic_note_write(struct file *filp, const char __user *buf,
+	size_t nbytes, loff_t *ppos)
+{
+	ssize_t retval;
+	ssize_t result;
+	loff_t pos;
+
+	down_write(&panic_note_state.sem);
+
+	/* If the O_APPEND flag is set, ignore the current position and
+	 * add to the end. */
+	pos = ((filp->f_flags & O_APPEND) == 0) ? *ppos : panic_note_state.n;
+
+	retval = read_write_size(nbytes, pos, PANIC_NOTE_SIZE);
+
+	if (retval == 0)
+		retval = -ENOSPC;
+	else {
+		/* If we have a hole, fill it with zeros */
+		if (pos > panic_note_state.n)
+			memset(panic_note_state.p + panic_note_state.n,
+				0, pos - panic_note_state.n);
+
+		/* Fetch what was written from user space */
+		result = copy_from_user(panic_note_state.p + pos, buf,
+			retval);
+
+		if (result != 0)
+			retval = -EFAULT;
+		else {
+
+			/* If we now have more bytes than we did, grow the
+			 * size */
+			if (pos + retval > panic_note_state.n) {
+				struct inode *inode;
+				inode = filp->f_path.dentry->d_inode;
+				panic_note_state.n = pos + retval;
+				panic_note_entry->size = panic_note_state.n;
+			}
+
+			*ppos = pos + retval;
+		}
+	}
+	up_write(&panic_note_state.sem);
+
+	return retval;
+}
+
+static int panic_note_open(struct inode *inode, struct file *filp)
+{
+	filp->f_op = &panic_note_fops;
+	inode->i_op = &panic_note_iops;
+	panic_note_entry->size = panic_note_state.n;
+
+	return 0;
+}
+
+static const struct file_operations panic_note_fops = {
+	.owner = THIS_MODULE,
+	.open = panic_note_open,
+	.read = panic_note_read,
+	.write = panic_note_write,
+};
+
+static void panic_note_truncate(struct inode *inode)
+{
+	down_write(&panic_note_state.sem);
+	panic_note_state.n = 0;
+	panic_note_entry->size = panic_note_state.n;
+	up_write(&panic_note_state.sem);
+}
+
+static struct inode_operations panic_note_iops = {
+	.truncate = panic_note_truncate,
+};
+
+static int __init panic_note_init(void)
+{
+	int retval;
+
+	/* This can allocate kernel memory, so we let only the root use
+	 * it. */
+	panic_note_entry = create_proc_entry("panic_note", 0600, NULL);
+
+	if (panic_note_entry == NULL) {
+		retval = -ENOMEM;
+		goto error_exit;
+	}
+
+	/* Set up the basic proc file fields */
+	panic_note_entry->proc_fops = &panic_note_fops;
+	panic_note_entry->proc_iops = &panic_note_iops;
+
+	/* Allocate a buffer. Doing so now avoids the possibility that
+	 * we won't be able to get when when the kernel runs out of
+	 * memory. */
+	panic_note_state.p = kmalloc(PANIC_NOTE_SIZE, GFP_KERNEL);
+
+	if (panic_note_state.p == NULL) {
+		retval = -ENOMEM;
+		goto kmalloc_buf_error;
+	}
+
+	return 0;
+
+kmalloc_buf_error:
+	kfree(panic_note_state.p);
+	panic_note_state.p = NULL;
+
+	remove_proc_entry("panic_note", NULL);
+
+error_exit:
+	return retval;
+}
+
+static int __exit panic_note_cleanup(void)
+{
+	if (panic_note_state.p != NULL)
+		kfree(panic_note_state.p);
+
+	remove_proc_entry("panic_note", NULL);
+
+	return 0;
+}
+
+late_initcall(panic_note_init);
+late_initcall(panic_note_cleanup);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f4e3184..86ca4d7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -312,6 +312,13 @@ extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
 extern int root_mountflags;
+#ifdef CONFIG_PANIC_NOTE
+extern void panic_note_print(void);
+#else
+static inline void panic_note_print(void)
+{
+}
+#endif
 
 /* Values used for system_state */
 extern enum system_states {
diff --git a/kernel/panic.c b/kernel/panic.c
index 96b45d0..513deae 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -70,6 +70,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	panic_note_print();
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 30df586..bade7a1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1045,6 +1045,14 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
+config PANIC_NOTE
+	bool "Create file for user space data to be reported at panic time"
+	default n
+	help
+	  This creates a pseudo-file, named /proc/panic_note, into which
+	  user space data can be written. If a panic occurs, the contents
+	  of the file will be included in the failure report.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
