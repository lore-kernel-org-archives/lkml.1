Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXGIO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXGIO5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbXGIO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:57:26 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55606 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756445AbXGIO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:57:24 -0400
Date: Mon, 9 Jul 2007 16:57:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled ACPI_PROCFS removal
Message-ID: <20070709145755.GD3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the ACPI procfs interface.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 Documentation/feature-removal-schedule.txt |    8 -
 drivers/acpi/Kconfig                       |   13 -
 drivers/acpi/debug.c                       |  143 ---------------------
 drivers/acpi/system.c                      |  129 ------------------
 4 files changed, 293 deletions(-)

--- linux-2.6.22-rc6-mm1/Documentation/feature-removal-schedule.txt.old	2007-07-09 02:04:01.000000000 +0200
+++ linux-2.6.22-rc6-mm1/Documentation/feature-removal-schedule.txt	2007-07-09 02:04:32.000000000 +0200
@@ -190,14 +190,6 @@
 
 ---------------------------
 
-What:	ACPI procfs interface
-When:	July 2007
-Why:	After ACPI sysfs conversion, ACPI attributes will be duplicated
-	in sysfs and the ACPI procfs interface should be removed.
-Who:	Zhang Rui <rui.zhang@intel.com>
-
----------------------------
-
 What:	/proc/acpi/button
 When:	August 2007
 Why:	/proc/acpi/button has been replaced by events to the input layer
--- linux-2.6.22-rc6-mm1/drivers/acpi/Kconfig.old	2007-07-09 02:04:39.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/acpi/Kconfig	2007-07-09 02:04:57.000000000 +0200
@@ -75,19 +75,6 @@
 	  Create /proc/acpi/sleep
 	  Deprecated by /sys/power/state
 
-config ACPI_PROCFS
-	bool "Procfs interface (deprecated)"
-	default y
-	---help---
-	  The Procfs interface for ACPI is made optional for backward compatibility.
-	  As the same functions are duplicated in the sysfs interface
-	  and this proc interface will be removed some time later,
-	  it's marked as deprecated.
-	  ( /proc/acpi/debug_layer && debug_level are deprecated by
-	    /sys/module/acpi/parameters/debug_layer && debug_level.
-	    /proc/acpi/info is deprecated by
-	    /sys/module/acpi/parameters/acpica_version )
-
 config ACPI_AC
 	tristate "AC Adapter"
 	depends on X86
--- linux-2.6.22-rc6-mm1/drivers/acpi/debug.c.old	2007-07-09 02:05:04.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/acpi/debug.c	2007-07-09 02:05:41.000000000 +0200
@@ -130,146 +130,3 @@
 module_param_call(debug_layer, param_set_uint, param_get_debug_layer, &acpi_dbg_layer, 0644);
 module_param_call(debug_level, param_set_uint, param_get_debug_level, &acpi_dbg_level, 0644);
 
-/* --------------------------------------------------------------------------
-                              FS Interface (/proc)
-   -------------------------------------------------------------------------- */
-#ifdef CONFIG_ACPI_PROCFS
-#define ACPI_SYSTEM_FILE_DEBUG_LAYER	"debug_layer"
-#define ACPI_SYSTEM_FILE_DEBUG_LEVEL		"debug_level"
-
-static int
-acpi_system_read_debug(char *page,
-		       char **start, off_t off, int count, int *eof, void *data)
-{
-	char *p = page;
-	int size = 0;
-	unsigned int i;
-
-	if (off != 0)
-		goto end;
-
-	p += sprintf(p, "%-25s\tHex        SET\n", "Description");
-
-	switch ((unsigned long)data) {
-	case 0:
-		for (i = 0; i < ARRAY_SIZE(acpi_debug_layers); i++) {
-			p += sprintf(p, "%-25s\t0x%08lX [%c]\n",
-				     acpi_debug_layers[i].name,
-				     acpi_debug_layers[i].value,
-				     (acpi_dbg_layer & acpi_debug_layers[i].
-				      value) ? '*' : ' ');
-		}
-		p += sprintf(p, "%-25s\t0x%08X [%c]\n", "ACPI_ALL_DRIVERS",
-			     ACPI_ALL_DRIVERS,
-			     (acpi_dbg_layer & ACPI_ALL_DRIVERS) ==
-			     ACPI_ALL_DRIVERS ? '*' : (acpi_dbg_layer &
-						       ACPI_ALL_DRIVERS) ==
-			     0 ? ' ' : '-');
-		p += sprintf(p,
-			     "--\ndebug_layer = 0x%08X (* = enabled, - = partial)\n",
-			     acpi_dbg_layer);
-		break;
-	case 1:
-		for (i = 0; i < ARRAY_SIZE(acpi_debug_levels); i++) {
-			p += sprintf(p, "%-25s\t0x%08lX [%c]\n",
-				     acpi_debug_levels[i].name,
-				     acpi_debug_levels[i].value,
-				     (acpi_dbg_level & acpi_debug_levels[i].
-				      value) ? '*' : ' ');
-		}
-		p += sprintf(p, "--\ndebug_level = 0x%08X (* = enabled)\n",
-			     acpi_dbg_level);
-		break;
-	default:
-		p += sprintf(p, "Invalid debug option\n");
-		break;
-	}
-
-      end:
-	size = (p - page);
-	if (size <= off + count)
-		*eof = 1;
-	*start = page + off;
-	size -= off;
-	if (size > count)
-		size = count;
-	if (size < 0)
-		size = 0;
-
-	return size;
-}
-
-static int
-acpi_system_write_debug(struct file *file,
-			const char __user * buffer,
-			unsigned long count, void *data)
-{
-	char debug_string[12] = { '\0' };
-
-
-	if (count > sizeof(debug_string) - 1)
-		return -EINVAL;
-
-	if (copy_from_user(debug_string, buffer, count))
-		return -EFAULT;
-
-	debug_string[count] = '\0';
-
-	switch ((unsigned long)data) {
-	case 0:
-		acpi_dbg_layer = simple_strtoul(debug_string, NULL, 0);
-		break;
-	case 1:
-		acpi_dbg_level = simple_strtoul(debug_string, NULL, 0);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return count;
-}
-
-static int __init acpi_debug_init(void)
-{
-	struct proc_dir_entry *entry;
-	int error = 0;
-	char *name;
-
-
-	if (acpi_disabled)
-		return 0;
-
-	/* 'debug_layer' [R/W] */
-	name = ACPI_SYSTEM_FILE_DEBUG_LAYER;
-	entry =
-	    create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-				   acpi_root_dir, acpi_system_read_debug,
-				   (void *)0);
-	if (entry)
-		entry->write_proc = acpi_system_write_debug;
-	else
-		goto Error;
-
-	/* 'debug_level' [R/W] */
-	name = ACPI_SYSTEM_FILE_DEBUG_LEVEL;
-	entry =
-	    create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
-				   acpi_root_dir, acpi_system_read_debug,
-				   (void *)1);
-	if (entry)
-		entry->write_proc = acpi_system_write_debug;
-	else
-		goto Error;
-
-      Done:
-	return error;
-
-      Error:
-	remove_proc_entry(ACPI_SYSTEM_FILE_DEBUG_LEVEL, acpi_root_dir);
-	remove_proc_entry(ACPI_SYSTEM_FILE_DEBUG_LAYER, acpi_root_dir);
-	error = -ENODEV;
-	goto Done;
-}
-
-subsys_initcall(acpi_debug_init);
-#endif
--- linux-2.6.22-rc6-mm1/drivers/acpi/system.c.old	2007-07-09 02:05:48.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/acpi/system.c	2007-07-09 02:06:30.000000000 +0200
@@ -167,131 +167,6 @@
 	return 0;
 }
 
-/* --------------------------------------------------------------------------
-                              FS Interface (/proc)
-   -------------------------------------------------------------------------- */
-#ifdef CONFIG_ACPI_PROCFS
-#define ACPI_SYSTEM_FILE_INFO		"info"
-#define ACPI_SYSTEM_FILE_EVENT		"event"
-#define ACPI_SYSTEM_FILE_DSDT		"dsdt"
-#define ACPI_SYSTEM_FILE_FADT		"fadt"
-
-static int acpi_system_read_info(struct seq_file *seq, void *offset)
-{
-
-	seq_printf(seq, "version:                 %x\n", ACPI_CA_VERSION);
-	return 0;
-}
-
-static int acpi_system_info_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_system_read_info, PDE(inode)->data);
-}
-
-static const struct file_operations acpi_system_info_ops = {
-	.open = acpi_system_info_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static ssize_t acpi_system_read_dsdt(struct file *, char __user *, size_t,
-				     loff_t *);
-
-static const struct file_operations acpi_system_dsdt_ops = {
-	.read = acpi_system_read_dsdt,
-};
-
-static ssize_t
-acpi_system_read_dsdt(struct file *file,
-		      char __user * buffer, size_t count, loff_t * ppos)
-{
-	acpi_status status = AE_OK;
-	struct acpi_table_header *dsdt = NULL;
-	ssize_t res;
-
-	status = acpi_get_table(ACPI_SIG_DSDT, 1, &dsdt);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	res = simple_read_from_buffer(buffer, count, ppos, dsdt, dsdt->length);
-
-	return res;
-}
-
-static ssize_t acpi_system_read_fadt(struct file *, char __user *, size_t,
-				     loff_t *);
-
-static const struct file_operations acpi_system_fadt_ops = {
-	.read = acpi_system_read_fadt,
-};
-
-static ssize_t
-acpi_system_read_fadt(struct file *file,
-		      char __user * buffer, size_t count, loff_t * ppos)
-{
-	acpi_status status = AE_OK;
-	struct acpi_table_header *fadt = NULL;
-	ssize_t res;
-
-	status = acpi_get_table(ACPI_SIG_FADT, 1, &fadt);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	res = simple_read_from_buffer(buffer, count, ppos, fadt, fadt->length);
-
-	return res;
-}
-
-static int acpi_system_procfs_init(void)
-{
-	struct proc_dir_entry *entry;
-	int error = 0;
-	char *name;
-
-	/* 'info' [R] */
-	name = ACPI_SYSTEM_FILE_INFO;
-	entry = create_proc_entry(name, S_IRUGO, acpi_root_dir);
-	if (!entry)
-		goto Error;
-	else {
-		entry->proc_fops = &acpi_system_info_ops;
-	}
-
-	/* 'dsdt' [R] */
-	name = ACPI_SYSTEM_FILE_DSDT;
-	entry = create_proc_entry(name, S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_dsdt_ops;
-	else
-		goto Error;
-
-	/* 'fadt' [R] */
-	name = ACPI_SYSTEM_FILE_FADT;
-	entry = create_proc_entry(name, S_IRUSR, acpi_root_dir);
-	if (entry)
-		entry->proc_fops = &acpi_system_fadt_ops;
-	else
-		goto Error;
-
-      Done:
-	return error;
-
-      Error:
-	remove_proc_entry(ACPI_SYSTEM_FILE_FADT, acpi_root_dir);
-	remove_proc_entry(ACPI_SYSTEM_FILE_DSDT, acpi_root_dir);
-	remove_proc_entry(ACPI_SYSTEM_FILE_INFO, acpi_root_dir);
-
-	error = -EFAULT;
-	goto Done;
-}
-#else
-static int acpi_system_procfs_init(void)
-{
-	return 0;
-}
-#endif
-
 static int __init acpi_system_init(void)
 {
 	int result = 0;
@@ -299,10 +174,6 @@
 	if (acpi_disabled)
 		return 0;
 
-	result = acpi_system_procfs_init();
-	if (result)
-		return result;
-
 	result = acpi_system_sysfs_init();
 
 	return result;

