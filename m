Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0BDJG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:06:27 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:46503 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756056Ab0BDJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:06:22 -0500
Date: Thu, 4 Feb 2010 10:06:13 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com (Eric W. Biederman), ankita@in.ibm.com,
       dedekind1@gmail.com,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       mohan@in.ibm.com
Subject: [PATCH v2] lkdtm: Add debugfs access and loosen KPROBE ties
Message-ID: <20100204100613.0159a892@marrow.netinsight.se>
In-Reply-To: <20100203145503.b7f7c5d7.akpm@linux-foundation.org>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
	<1264689482.1973.132.camel@localhost>
	<20100129071324.2521705c@marrow.netinsight.se>
	<20100129023327.021cb23d.akpm@linux-foundation.org>
	<m1eil4i85t.fsf@fess.ebiederm.org>
	<20100203095224.55522f4c@marrow.netinsight.se>
	<20100203145503.b7f7c5d7.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a debugfs interface and additional failure modes to
LKDTM to provide similar functionality to the provoke-crash driver
submitted here:

  http://lwn.net/Articles/371208/

Crashes can now be induced either through module parameters (as before)
or through the debugfs interface as in provoke-crash.

The patch also provides a new "direct" interface, where KPROBES are not
used, i.e., the crash is invoked directly upon write to the debugfs
file. When built without KPROBES configured, only this mode is available.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
--
ChangeLog: (Fixes from Andrew Mortons review)
	* Fix checkpatch errors and warnings (except volatile)
	* Move break; inside braces in switch statements
	* GFP_TEMPORARY -> GFP_KERNEL
	* Use strim()
	* Constify struct crash_entry
	* #if defined -> #ifdef
	* Use i++/i-- throughout
	* lkdtm : -> lkdtm:

 Documentation/fault-injection/provoke-crashes.txt |   38 ++
 drivers/misc/lkdtm.c                              |  472 +++++++++++++++++----
 lib/Kconfig.debug                                 |    5 +-
 3 files changed, 430 insertions(+), 85 deletions(-)
 create mode 100644 Documentation/fault-injection/provoke-crashes.txt

diff --git a/Documentation/fault-injection/provoke-crashes.txt b/Documentation/fault-injection/provoke-crashes.txt
new file mode 100644
index 0000000..7a9d3d8
--- /dev/null
+++ b/Documentation/fault-injection/provoke-crashes.txt
@@ -0,0 +1,38 @@
+The lkdtm module provides an interface to crash or injure the kernel at
+predefined crashpoints to evaluate the reliability of crash dumps obtained
+using different dumping solutions. The module uses KPROBEs to instrument
+crashing points, but can also crash the kernel directly without KRPOBE
+support.
+
+
+You can provide the way either through module arguments when inserting
+the module, or through a debugfs interface.
+
+Usage: insmod lkdtm.ko [recur_count={>0}] cpoint_name=<> cpoint_type=<>
+				[cpoint_count={>0}]
+
+  recur_count : Recursion level for the stack overflow test. Default is 10.
+
+  cpoint_name : Crash point where the kernel is to be crashed. It can be
+	 one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
+	 FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_DISPATCH_CMD,
+	 IDE_CORE_CP, DIRECT
+
+  cpoint_type : Indicates the action to be taken on hitting the crash point.
+     It can be one of PANIC, BUG, EXCEPTION, LOOP, OVERFLOW,
+     CORRUPT_STACK, UNALIGNED_LOAD_STORE_WRITE, OVERWRITE_ALLOCATION,
+     WRITE_AFTER_FREE,
+
+  cpoint_count : Indicates the number of times the crash point is to be hit
+    to trigger an action. The default is 10.
+
+You can also induce failures by mounting debugfs and writing the type to
+<mountpoint>/provoke-crash/<crashpoint>. E.g.,
+
+  mount -t debugfs debugfs /mnt
+  echo EXCEPTION > /mnt/provoke-crash/INT_HARDWARE_ENTRY
+
+
+A special file is `DIRECT' which will induce the crash directly without
+KPROBE instrumentation. This mode is the only one available when the module
+is built on a kernel without KPROBEs support.
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 3648b23..4a06483 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -26,21 +26,9 @@
  * It is adapted from the Linux Kernel Dump Test Tool by
  * Fernando Luis Vazquez Cao <http://lkdtt.sourceforge.net>
  *
- * Usage :  insmod lkdtm.ko [recur_count={>0}] cpoint_name=<> cpoint_type=<>
- *							[cpoint_count={>0}]
+ * Debugfs support added by Simon Kagstrom <simon.kagstrom@netinsight.net>
  *
- * recur_count : Recursion level for the stack overflow test. Default is 10.
- *
- * cpoint_name : Crash point where the kernel is to be crashed. It can be
- *		 one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
- *		 FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_DISPATCH_CMD,
- *		 IDE_CORE_CP
- *
- * cpoint_type : Indicates the action to be taken on hitting the crash point.
- *		 It can be one of PANIC, BUG, EXCEPTION, LOOP, OVERFLOW
- *
- * cpoint_count : Indicates the number of times the crash point is to be hit
- *		  to trigger an action. The default is 10.
+ * See Documentation/fault-injection/provoke-crashes.txt for instructions
  */
 
 #include <linux/kernel.h>
@@ -53,13 +41,12 @@
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <scsi/scsi_cmnd.h>
+#include <linux/debugfs.h>
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
 #endif
 
-#define NUM_CPOINTS 8
-#define NUM_CPOINT_TYPES 5
 #define DEFAULT_COUNT 10
 #define REC_NUM_DEFAULT 10
 
@@ -72,7 +59,8 @@ enum cname {
 	MEM_SWAPOUT,
 	TIMERADD,
 	SCSI_DISPATCH_CMD,
-	IDE_CORE_CP
+	IDE_CORE_CP,
+	DIRECT,
 };
 
 enum ctype {
@@ -81,7 +69,11 @@ enum ctype {
 	BUG,
 	EXCEPTION,
 	LOOP,
-	OVERFLOW
+	OVERFLOW,
+	CORRUPT_STACK,
+	UNALIGNED_LOAD_STORE_WRITE,
+	OVERWRITE_ALLOCATION,
+	WRITE_AFTER_FREE,
 };
 
 static char* cp_name[] = {
@@ -92,7 +84,8 @@ static char* cp_name[] = {
 	"MEM_SWAPOUT",
 	"TIMERADD",
 	"SCSI_DISPATCH_CMD",
-	"IDE_CORE_CP"
+	"IDE_CORE_CP",
+	"DIRECT",
 };
 
 static char* cp_type[] = {
@@ -100,7 +93,11 @@ static char* cp_type[] = {
 	"BUG",
 	"EXCEPTION",
 	"LOOP",
-	"OVERFLOW"
+	"OVERFLOW",
+	"CORRUPT_STACK",
+	"UNALIGNED_LOAD_STORE_WRITE",
+	"OVERWRITE_ALLOCATION",
+	"WRITE_AFTER_FREE",
 };
 
 static struct jprobe lkdtm;
@@ -193,34 +190,66 @@ int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
 }
 #endif
 
+/* Return the crashpoint number or NONE if the name is invalid */
+static enum ctype parse_cp_type(const char *what, size_t count)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cp_type); i++) {
+		if (!strcmp(what, cp_type[i]))
+			return i + 1;
+	}
+
+	return NONE;
+}
+
+static const char *cp_type_to_str(enum ctype type)
+{
+	if (type == NONE || type < 0 || type > ARRAY_SIZE(cp_type))
+		return "None";
+
+	return cp_type[type - 1];
+}
+
+static const char *cp_name_to_str(enum cname name)
+{
+	if (name == INVALID || name < 0 || name > ARRAY_SIZE(cp_name))
+		return "INVALID";
+
+	return cp_name[name - 1];
+}
+
+
 static int lkdtm_parse_commandline(void)
 {
 	int i;
 
-	if (cpoint_name == NULL || cpoint_type == NULL ||
-					cpoint_count < 1 || recur_count < 1)
+	if (cpoint_count < 1 || recur_count < 1)
 		return -EINVAL;
 
-	for (i = 0; i < NUM_CPOINTS; ++i) {
+	count = cpoint_count;
+
+	/* No special parameters */
+	if (!cpoint_type && !cpoint_name)
+		return 0;
+
+	/* Neither or both of these need to be set */
+	if (!cpoint_type || !cpoint_name)
+		return -EINVAL;
+
+	cptype = parse_cp_type(cpoint_type, strlen(cpoint_type));
+	if (cptype == NONE)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(cp_name); i++) {
 		if (!strcmp(cpoint_name, cp_name[i])) {
 			cpoint = i + 1;
-			break;
-		}
-	}
-
-	for (i = 0; i < NUM_CPOINT_TYPES; ++i) {
-		if (!strcmp(cpoint_type, cp_type[i])) {
-			cptype = i + 1;
-			break;
+			return 0;
 		}
 	}
 
-	if (cpoint == INVALID || cptype == NONE)
-                return -EINVAL;
-
-	count = cpoint_count;
-
-	return 0;
+	/* Could not find a valid crash point */
+	return -EINVAL;
 }
 
 static int recursive_loop(int a)
@@ -235,53 +264,92 @@ static int recursive_loop(int a)
         	return recursive_loop(a);
 }
 
-void lkdtm_handler(void)
+static void lkdtm_do_action(enum ctype which)
 {
-	printk(KERN_INFO "lkdtm : Crash point %s of type %s hit\n",
-					 cpoint_name, cpoint_type);
-	--count;
+	switch (which) {
+	case PANIC:
+		panic("dumptest");
+		break;
+	case BUG:
+		BUG();
+		break;
+	case EXCEPTION:
+		*((int *) 0) = 0;
+		break;
+	case LOOP:
+		for (;;)
+			;
+		break;
+	case OVERFLOW:
+		(void) recursive_loop(0);
+		break;
+	case CORRUPT_STACK: {
+		volatile u32 data[8];
+		volatile u32 *p = data;
+
+		p[12] = 0x12345678;
+		break;
+	}
+	case UNALIGNED_LOAD_STORE_WRITE: {
+		static u8 data[5] __attribute__((aligned(4))) = {1, 2,
+				3, 4, 5};
+		u32 *p;
+		u32 val = 0x12345678;
+
+		p = (u32 *)(data + 1);
+		if (*p == 0)
+			val = 0x87654321;
+		*p = val;
+		 break;
+	}
+	case OVERWRITE_ALLOCATION: {
+		size_t len = 1020;
+		u32 *data = kmalloc(len, GFP_KERNEL);
+
+		data[1024 / sizeof(u32)] = 0x12345678;
+		kfree(data);
+		break;
+	}
+	case WRITE_AFTER_FREE: {
+		size_t len = 1024;
+		u32 *data = kmalloc(len, GFP_KERNEL);
+
+		kfree(data);
+		schedule();
+		memset(data, 0x78, len);
+		break;
+	}
+	case NONE:
+	default:
+		break;
+	}
+
+}
+
+static void lkdtm_handler(void)
+{
+	count--;
+	printk(KERN_INFO "lkdtm: Crash point %s of type %s hit, trigger in %d rounds\n",
+			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
 
 	if (count == 0) {
-		switch (cptype) {
-		case NONE:
-			break;
-		case PANIC:
-			printk(KERN_INFO "lkdtm : PANIC\n");
-			panic("dumptest");
-			break;
-		case BUG:
-			printk(KERN_INFO "lkdtm : BUG\n");
-			BUG();
-			break;
-		case EXCEPTION:
-			printk(KERN_INFO "lkdtm : EXCEPTION\n");
-			*((int *) 0) = 0;
-			break;
-		case LOOP:
-			printk(KERN_INFO "lkdtm : LOOP\n");
-			for (;;);
-			break;
-		case OVERFLOW:
-			printk(KERN_INFO "lkdtm : OVERFLOW\n");
-			(void) recursive_loop(0);
-			break;
-		default:
-			break;
-		}
+		lkdtm_do_action(cptype);
 		count = cpoint_count;
 	}
 }
 
-static int __init lkdtm_module_init(void)
+static int lkdtm_register_cpoint(enum cname which)
 {
 	int ret;
 
-	if (lkdtm_parse_commandline() == -EINVAL) {
-		printk(KERN_INFO "lkdtm : Invalid command\n");
-		return -EINVAL;
-	}
+	cpoint = INVALID;
+	if (lkdtm.entry != NULL)
+		unregister_jprobe(&lkdtm);
 
-	switch (cpoint) {
+	switch (which) {
+	case DIRECT:
+		lkdtm_do_action(cptype);
+		return 0;
 	case INT_HARDWARE_ENTRY:
 		lkdtm.kp.symbol_name = "do_IRQ";
 		lkdtm.entry = (kprobe_opcode_t*) jp_do_irq;
@@ -315,28 +383,268 @@ static int __init lkdtm_module_init(void)
 		lkdtm.kp.symbol_name = "generic_ide_ioctl";
 		lkdtm.entry = (kprobe_opcode_t*) jp_generic_ide_ioctl;
 #else
-		printk(KERN_INFO "lkdtm : Crash point not available\n");
+		printk(KERN_INFO "lkdtm: Crash point not available\n");
+		return -EINVAL;
 #endif
 		break;
 	default:
-		printk(KERN_INFO "lkdtm : Invalid Crash Point\n");
-		break;
+		printk(KERN_INFO "lkdtm: Invalid Crash Point\n");
+		return -EINVAL;
 	}
 
+	cpoint = which;
 	if ((ret = register_jprobe(&lkdtm)) < 0) {
-                printk(KERN_INFO "lkdtm : Couldn't register jprobe\n");
-                return ret;
+		printk(KERN_INFO "lkdtm: Couldn't register jprobe\n");
+		cpoint = INVALID;
+	}
+
+	return ret;
+}
+
+static ssize_t do_register_entry(enum cname which, struct file *f,
+		const char __user *user_buf, size_t count, loff_t *off)
+{
+	char *buf;
+	int err;
+
+	if (count >= PAGE_SIZE)
+		return -EINVAL;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	if (copy_from_user(buf, user_buf, count)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
+	}
+	/* NULL-terminate and remove enter */
+	buf[count] = '\0';
+	strim(buf);
+
+	cptype = parse_cp_type(buf, count);
+	free_page((unsigned long) buf);
+
+	if (cptype == NONE)
+		return -EINVAL;
+
+	err = lkdtm_register_cpoint(which);
+	if (err < 0)
+		return err;
+
+	*off += count;
+
+	return count;
+}
+
+/* Generic read callback that just prints out the available crash types */
+static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
+		size_t count, loff_t *off)
+{
+	char *buf;
+	int i, n, out;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+
+	n = snprintf(buf, PAGE_SIZE, "Available crash types:\n");
+	for (i = 0; i < ARRAY_SIZE(cp_type); i++)
+		n += snprintf(buf + n, PAGE_SIZE - n, "%s\n", cp_type[i]);
+	buf[n] = '\0';
+
+	out = simple_read_from_buffer(user_buf, count, off,
+				      buf, n);
+	free_page((unsigned long) buf);
+
+	return out;
+}
+
+static int lkdtm_debugfs_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+
+static ssize_t int_hardware_entry(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(INT_HARDWARE_ENTRY, f, buf, count, off);
+}
+
+static ssize_t int_hw_irq_en(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(INT_HW_IRQ_EN, f, buf, count, off);
+}
+
+static ssize_t int_tasklet_entry(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(INT_TASKLET_ENTRY, f, buf, count, off);
+}
+
+static ssize_t fs_devrw_entry(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(FS_DEVRW, f, buf, count, off);
+}
+
+static ssize_t mem_swapout_entry(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(MEM_SWAPOUT, f, buf, count, off);
+}
+
+static ssize_t timeradd_entry(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(TIMERADD, f, buf, count, off);
+}
+
+static ssize_t scsi_dispatch_cmd_entry(struct file *f,
+		const char __user *buf, size_t count, loff_t *off)
+{
+	return do_register_entry(SCSI_DISPATCH_CMD, f, buf, count, off);
+}
+
+static ssize_t ide_core_cp_entry(struct file *f, const char __user *buf,
+		size_t count, loff_t *off)
+{
+	return do_register_entry(IDE_CORE_CP, f, buf, count, off);
+}
+
+/* Special entry to just crash directly. Available without KPROBEs */
+static ssize_t direct_entry(struct file *f, const char __user *user_buf,
+		size_t count, loff_t *off)
+{
+	enum ctype type;
+	char *buf;
+
+	if (count >= PAGE_SIZE)
+		return -EINVAL;
+	if (count < 1)
+		return -EINVAL;
+
+	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	if (copy_from_user(buf, user_buf, count)) {
+		free_page((unsigned long) buf);
+		return -EFAULT;
+	}
+	/* NULL-terminate and remove enter */
+	buf[count] = '\0';
+	strim(buf);
+
+	type = parse_cp_type(buf, count);
+	free_page((unsigned long) buf);
+	if (type == NONE)
+		return -EINVAL;
+
+	printk(KERN_INFO "lkdtm: Performing direct entry %s\n",
+			cp_type_to_str(type));
+	lkdtm_do_action(type);
+	*off += count;
+
+	return count;
+}
+
+struct crash_entry {
+	const char *name;
+	const struct file_operations fops;
+};
+
+static const struct crash_entry crash_entries[] = {
+	{"DIRECT", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = direct_entry} },
+	{"INT_HARDWARE_ENTRY", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = int_hardware_entry} },
+	{"INT_HW_IRQ_EN", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = int_hw_irq_en} },
+	{"INT_TASKLET_ENTRY", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = int_tasklet_entry} },
+	{"FS_DEVRW", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = fs_devrw_entry} },
+	{"MEM_SWAPOUT", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = mem_swapout_entry} },
+	{"TIMERADD", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = timeradd_entry} },
+	{"SCSI_DISPATCH_CMD", {.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = scsi_dispatch_cmd_entry} },
+	{"IDE_CORE_CP",	{.read = lkdtm_debugfs_read,
+			.open = lkdtm_debugfs_open,
+			.write = ide_core_cp_entry} },
+};
+
+static struct dentry *lkdtm_debugfs_root;
+
+static int __init lkdtm_module_init(void)
+{
+	int ret = -EINVAL;
+	int n_debugfs_entries = 1; /* Assume only the direct entry */
+	int i;
+
+	/* Register debugfs interface */
+	lkdtm_debugfs_root = debugfs_create_dir("provoke-crash", NULL);
+	if (!lkdtm_debugfs_root) {
+		printk(KERN_ERR "lkdtm: creating root dir failed\n");
+		return -ENODEV;
+	}
+
+#ifdef CONFIG_KPROBES
+	n_debugfs_entries = ARRAY_SIZE(crash_entries);
+#endif
+
+	for (i = 0; i < n_debugfs_entries; i++) {
+		const struct crash_entry *cur = &crash_entries[i];
+		struct dentry *de;
+
+		de = debugfs_create_file(cur->name, 0644, lkdtm_debugfs_root,
+				NULL, &cur->fops);
+		if (de == NULL) {
+			printk(KERN_ERR "lkdtm: could not create %s\n",
+					cur->name);
+			goto out_err;
+		}
+	}
+
+	if (lkdtm_parse_commandline() == -EINVAL) {
+		printk(KERN_INFO "lkdtm: Invalid command\n");
+		goto out_err;
+	}
+
+	if (cpoint != INVALID && cptype != NONE) {
+		ret = lkdtm_register_cpoint(cpoint);
+		if (ret < 0) {
+			printk(KERN_INFO "lkdtm: Invalid crash point %d\n",
+					cpoint);
+			goto out_err;
+		}
+		printk(KERN_INFO "lkdtm: Crash point %s of type %s registered\n",
+				cpoint_name, cpoint_type);
+	} else {
+		printk(KERN_INFO "lkdtm: No crash points registered, enable through debugfs\n");
 	}
 
-	printk(KERN_INFO "lkdtm : Crash point %s of type %s registered\n",
-						cpoint_name, cpoint_type);
 	return 0;
+
+out_err:
+	debugfs_remove_recursive(lkdtm_debugfs_root);
+	return ret;
 }
 
 static void __exit lkdtm_module_exit(void)
 {
-        unregister_jprobe(&lkdtm);
-        printk(KERN_INFO "lkdtm : Crash point unregistered\n");
+	debugfs_remove_recursive(lkdtm_debugfs_root);
+
+	unregister_jprobe(&lkdtm);
+	printk(KERN_INFO "lkdtm: Crash point unregistered\n");
 }
 
 module_init(lkdtm_module_init);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8c82a1d..67b1799 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -840,8 +840,7 @@ config DEBUG_FORCE_WEAK_PER_CPU
 
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
-	depends on DEBUG_KERNEL
-	depends on KPROBES
+	depends on DEBUG_FS
 	depends on BLOCK
 	default n
 	help
@@ -852,7 +851,7 @@ config LKDTM
 	called lkdtm.
 
 	Documentation on how to use the module can be found in
-	drivers/misc/lkdtm.c
+	Documentation/fault-injection/provoke-crashes.txt
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
-- 
1.6.0.4

