Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYC3OzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYC3OzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 10:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYC3OzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 10:55:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:15818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYC3OzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 10:55:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=xqMN/GVpFysYr7icnGV7WFDcekLou4rkUd2yvCrmpwMw0y1kIgUrKIBhj79bvw7uhtFHDYD8Pa8n0cP7wDaw48fvSOQ8jI0cVPvKgHrZZKHdW2oV6wZu+1WQZz4WvbER+kKSJhl9T2ySXYf+7Nvsyvse+HyRA1VkkIN8pI+NF2I=
Date: Sun, 30 Mar 2008 18:51:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm 7/3] proc: remove proc_root from drivers
Message-ID: <20080330145133.GD4317@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove proc_root export. Creation and removal works well if parent PDE is
supplied as NULL -- it worked always that way.

So, one useless export removed and consistency added, some drivers created PDEs
with &proc_root as parent but removed them as NULL and so on.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/kernel/atags.c                 |    2 +-
 arch/m68k/mac/iop.c                     |    2 +-
 arch/mips/basler/excite/excite_procfs.c |    2 +-
 arch/um/kernel/exitcode.c               |    2 +-
 arch/um/kernel/process.c                |    2 +-
 arch/x86/kernel/cpu/mtrr/if.c           |    2 +-
 drivers/char/ip2/ip2main.c              |    4 ++--
 drivers/mca/mca-proc.c                  |    2 +-
 drivers/misc/hdpuftrs/hdpu_cpustate.c   |    2 +-
 drivers/misc/hdpuftrs/hdpu_nexus.c      |   12 ++++++------
 drivers/s390/block/dasd_proc.c          |    6 +++---
 drivers/s390/char/tape_proc.c           |    4 ++--
 drivers/s390/cio/blacklist.c            |    2 +-
 drivers/s390/cio/qdio.c                 |    4 ++--
 drivers/scsi/megaraid.c                 |    6 +++---
 drivers/video/clps711xfb.c              |    2 +-
 fs/proc/internal.h                      |    1 +
 fs/proc/proc_misc.c                     |    2 +-
 fs/proc/root.c                          |    1 -
 include/linux/proc_fs.h                 |    3 ---
 kernel/configs.c                        |    5 ++---
 lib/likely_prof.c                       |    2 +-
 sound/core/info.c                       |    4 ++--
 23 files changed, 35 insertions(+), 39 deletions(-)

--- a/arch/arm/kernel/atags.c
+++ b/arch/arm/kernel/atags.c
@@ -35,7 +35,7 @@ create_proc_entries(void)
 {
 	struct proc_dir_entry* tags_entry;
 
-	tags_entry = create_proc_read_entry("atags", 0400, &proc_root, read_buffer, &tags_buffer);
+	tags_entry = create_proc_read_entry("atags", 0400, NULL, read_buffer, &tags_buffer);
 	if (!tags_entry)
 		return -ENOMEM;
 
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -302,7 +302,7 @@ void __init iop_init(void)
 
 #if 0	/* Crashing in 2.4 now, not yet sure why.   --jmt */
 #ifdef CONFIG_PROC_FS
-	create_proc_info_entry("mac_iop", 0, &proc_root, iop_get_proc_info);
+	create_proc_info_entry("mac_iop", 0, NULL, iop_get_proc_info);
 #endif
 #endif
 }
--- a/arch/mips/basler/excite/excite_procfs.c
+++ b/arch/mips/basler/excite/excite_procfs.c
@@ -65,7 +65,7 @@ excite_bootrom_read(char *page, char **start, off_t off, int count,
 void excite_procfs_init(void)
 {
 	/* Create & populate /proc/excite */
-	struct proc_dir_entry * const pdir = proc_mkdir("excite", &proc_root);
+	struct proc_dir_entry * const pdir = proc_mkdir("excite", NULL);
 	if (pdir) {
 		struct proc_dir_entry * e;
 
--- a/arch/um/kernel/exitcode.c
+++ b/arch/um/kernel/exitcode.c
@@ -59,7 +59,7 @@ static int make_proc_exitcode(void)
 {
 	struct proc_dir_entry *ent;
 
-	ent = create_proc_entry("exitcode", 0600, &proc_root);
+	ent = create_proc_entry("exitcode", 0600, NULL);
 	if (ent == NULL) {
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -364,7 +364,7 @@ int __init make_proc_sysemu(void)
 	if (!sysemu_supported)
 		return 0;
 
-	ent = create_proc_entry("sysemu", 0600, &proc_root);
+	ent = create_proc_entry("sysemu", 0600, NULL);
 
 	if (ent == NULL)
 	{
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -424,7 +424,7 @@ static int __init mtrr_if_init(void)
 		return -ENODEV;
 
 	proc_root_mtrr =
-		proc_create("mtrr", S_IWUSR | S_IRUGO, &proc_root, &mtrr_fops);
+		proc_create("mtrr", S_IWUSR | S_IRUGO, NULL, &mtrr_fops);
 
 	if (proc_root_mtrr)
 		proc_root_mtrr->owner = THIS_MODULE;
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -424,7 +424,7 @@ ip2_cleanup_module(void)
 	}
 	put_tty_driver(ip2_tty_driver);
 	unregister_chrdev(IP2_IPL_MAJOR, pcIpl);
-	remove_proc_entry("ip2mem", &proc_root);
+	remove_proc_entry("ip2mem", NULL);
 
 	// free memory
 	for (i = 0; i < IP2_MAX_BOARDS; i++) {
@@ -697,7 +697,7 @@ ip2_loadmain(int *iop, int *irqp, unsigned char *firmware, int firmsize)
 		}
 	}
 	/* Register the read_procmem thing */
-	if (!create_proc_info_entry("ip2mem",0,&proc_root,ip2_read_procmem)) {
+	if (!create_proc_info_entry("ip2mem",0,NULL,ip2_read_procmem)) {
 		printk(KERN_ERR "IP2: failed to register read_procmem\n");
 	} else {
 
--- a/drivers/mca/mca-proc.c
+++ b/drivers/mca/mca-proc.c
@@ -183,7 +183,7 @@ void __init mca_do_proc_init(void)
 	struct proc_dir_entry* node = NULL;
 	struct mca_device *mca_dev;
 
-	proc_mca = proc_mkdir("mca", &proc_root);
+	proc_mca = proc_mkdir("mca", NULL);
 	create_proc_read_entry("pos",0,proc_mca,get_mca_info,NULL);
 	create_proc_read_entry("machine",0,proc_mca,get_mca_machine_info,NULL);
 
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -209,7 +209,7 @@ static int hdpu_cpustate_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	proc_de = create_proc_entry("sky_cpustate", 0666, &proc_root);
+	proc_de = create_proc_entry("sky_cpustate", 0666, NULL);
 	if (!proc_de) {
 		printk(KERN_WARNING "sky_cpustate: "
 		       "Unable to create proc entry\n");
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -101,8 +101,8 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		printk(KERN_ERR "sky_nexus: Could not map slot id\n");
 	}
 
-	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
-	if (!hdpu_slot_id) {
+	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, NULL);
+	if (!hdpu_slot_id) 
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_slot_id\n");
 	} else {
@@ -110,8 +110,8 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		hdpu_slot_id->owner = THIS_MODULE;
 	}
 
-	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, &proc_root);
-	if (!hdpu_chassis_id) {
+	hdpu_chassis_id = create_proc_entry("sky_chassis_id", 0666, NULL);
+	if (!hdpu_chassis_id) 
 		printk(KERN_WARNING "sky_nexus: "
 		       "Unable to create proc dir entry: sky_chassis_id\n");
 	} else {
@@ -127,8 +127,8 @@ static int hdpu_nexus_remove(struct platform_device *pdev)
 	slot_id = -1;
 	chassis_id = -1;
 
-	remove_proc_entry("sky_slot_id", &proc_root);
-	remove_proc_entry("sky_chassis_id", &proc_root);
+	remove_proc_entry("sky_slot_id", NULL);
+	remove_proc_entry("sky_chassis_id", NULL);
 
 	hdpu_slot_id = 0;
 	hdpu_chassis_id = 0;
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -311,7 +311,7 @@ out_error:
 int
 dasd_proc_init(void)
 {
-	dasd_proc_root_entry = proc_mkdir("dasd", &proc_root);
+	dasd_proc_root_entry = proc_mkdir("dasd", NULL);
 	if (!dasd_proc_root_entry)
 		goto out_nodasd;
 	dasd_proc_root_entry->owner = THIS_MODULE;
@@ -335,7 +335,7 @@ dasd_proc_init(void)
  out_nostatistics:
 	remove_proc_entry("devices", dasd_proc_root_entry);
  out_nodevices:
-	remove_proc_entry("dasd", &proc_root);
+	remove_proc_entry("dasd", NULL);
  out_nodasd:
 	return -ENOENT;
 }
@@ -345,5 +345,5 @@ dasd_proc_exit(void)
 {
 	remove_proc_entry("devices", dasd_proc_root_entry);
 	remove_proc_entry("statistics", dasd_proc_root_entry);
-	remove_proc_entry("dasd", &proc_root);
+	remove_proc_entry("dasd", NULL);
 }
--- a/drivers/s390/char/tape_proc.c
+++ b/drivers/s390/char/tape_proc.c
@@ -125,7 +125,7 @@ tape_proc_init(void)
 {
 	tape_proc_devices =
 		create_proc_entry ("tapedevices", S_IFREG | S_IRUGO | S_IWUSR,
-				   &proc_root);
+				   NULL);
 	if (tape_proc_devices == NULL) {
 		PRINT_WARN("tape: Cannot register procfs entry tapedevices\n");
 		return;
@@ -141,5 +141,5 @@ void
 tape_proc_cleanup(void)
 {
 	if (tape_proc_devices != NULL)
-		remove_proc_entry ("tapedevices", &proc_root);
+		remove_proc_entry ("tapedevices", NULL);
 }
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -375,7 +375,7 @@ cio_ignore_proc_init (void)
 	struct proc_dir_entry *entry;
 
 	entry = create_proc_entry ("cio_ignore", S_IFREG | S_IRUGO | S_IWUSR,
-				   &proc_root);
+				   NULL);
 	if (!entry)
 		return -ENOENT;
 
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -3638,7 +3638,7 @@ qdio_add_procfs_entry(void)
 {
         proc_perf_file_registration=0;
 	qdio_perf_proc_file=create_proc_entry(QDIO_PERF,
-					      S_IFREG|0444,&proc_root);
+					      S_IFREG|0444,NULL);
 	if (qdio_perf_proc_file) {
 		qdio_perf_proc_file->read_proc=&qdio_perf_procfile_read;
 	} else proc_perf_file_registration=-1;
@@ -3653,7 +3653,7 @@ static void
 qdio_remove_procfs_entry(void)
 {
         if (!proc_perf_file_registration) /* means if it went ok earlier */
-		remove_proc_entry(QDIO_PERF,&proc_root);
+		remove_proc_entry(QDIO_PERF,NULL);
 }
 
 /**
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4996,7 +4996,7 @@ static int __init megaraid_init(void)
 		max_mbox_busy_wait = MBOX_BUSY_WAIT;
 
 #ifdef CONFIG_PROC_FS
-	mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
+	mega_proc_dir_entry = proc_mkdir("megaraid", NULL);
 	if (!mega_proc_dir_entry) {
 		printk(KERN_WARNING
 				"megaraid: failed to create megaraid root\n");
@@ -5005,7 +5005,7 @@ static int __init megaraid_init(void)
 	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
-		remove_proc_entry("megaraid", &proc_root);
+		remove_proc_entry("megaraid", NULL);
 #endif
 		return error;
 	}
@@ -5035,7 +5035,7 @@ static void __exit megaraid_exit(void)
 	pci_unregister_driver(&megaraid_pci_driver);
 
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("megaraid", &proc_root);
+	remove_proc_entry("megaraid", NULL);
 #endif
 }
 
--- a/drivers/video/clps711xfb.c
+++ b/drivers/video/clps711xfb.c
@@ -381,7 +381,7 @@ int __init clps711xfb_init(void)
 
 	/* Register the /proc entries. */
 	clps7111fb_backlight_proc_entry = create_proc_entry("backlight", 0444,
-		&proc_root);
+		NULL);
 	if (clps7111fb_backlight_proc_entry == NULL) {
 		printk("Couldn't create the /proc entry for the backlight.\n");
 		return -EINVAL;
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -11,6 +11,7 @@
 
 #include <linux/proc_fs.h>
 
+extern struct proc_dir_entry proc_root;
 #ifdef CONFIG_PROC_SYSCTL
 extern int proc_sys_init(void);
 #else
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -974,7 +974,7 @@ void __init proc_misc_init(void)
 
 	/* And now for trickier ones */
 #ifdef CONFIG_PRINTK
-	proc_create("kmsg", S_IRUSR, &proc_root, &proc_kmsg_operations);
+	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
 #endif
 	proc_create("locks", 0, NULL, &proc_locks_operations);
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -232,4 +232,3 @@ EXPORT_SYMBOL(proc_mkdir);
 EXPORT_SYMBOL(create_proc_entry);
 EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
-EXPORT_SYMBOL(proc_root);
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -96,7 +96,6 @@ struct vmcore {
 
 #ifdef CONFIG_PROC_FS
 
-extern struct proc_dir_entry proc_root;
 extern struct proc_dir_entry *proc_root_kcore;
 
 extern spinlock_t proc_subdir_lock;
@@ -243,8 +242,6 @@ struct tty_driver;
 static inline void proc_tty_register_driver(struct tty_driver *driver) {};
 static inline void proc_tty_unregister_driver(struct tty_driver *driver) {};
 
-extern struct proc_dir_entry proc_root;
-
 static inline int pid_ns_prepare_proc(struct pid_namespace *ns)
 {
 	return 0;
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -79,8 +79,7 @@ static int __init ikconfig_init(void)
 	struct proc_dir_entry *entry;
 
 	/* create the current config file */
-	entry = create_proc_entry("config.gz", S_IFREG | S_IRUGO,
-				  &proc_root);
+	entry = create_proc_entry("config.gz", S_IFREG | S_IRUGO, NULL);
 	if (!entry)
 		return -ENOMEM;
 
@@ -95,7 +94,7 @@ static int __init ikconfig_init(void)
 
 static void __exit ikconfig_cleanup(void)
 {
-	remove_proc_entry("config.gz", &proc_root);
+	remove_proc_entry("config.gz", NULL);
 }
 
 module_init(ikconfig_init);
--- a/lib/likely_prof.c
+++ b/lib/likely_prof.c
@@ -137,7 +137,7 @@ static struct file_operations proc_likely_operations  = {
 static int __init init_likely(void)
 {
 	struct proc_dir_entry *entry;
-	entry = create_proc_entry("likely_prof", 0, &proc_root);
+	entry = create_proc_entry("likely_prof", 0, NULL);
 	if (entry)
 		entry->proc_fops = &proc_likely_operations;
 
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -544,7 +544,7 @@ int __init snd_info_init(void)
 {
 	struct proc_dir_entry *p;
 
-	p = snd_create_proc_entry("asound", S_IFDIR | S_IRUGO | S_IXUGO, &proc_root);
+	p = snd_create_proc_entry("asound", S_IFDIR | S_IRUGO | S_IXUGO, NULL);
 	if (p == NULL)
 		return -ENOMEM;
 	snd_proc_root = p;
@@ -594,7 +594,7 @@ int __exit snd_info_done(void)
 #ifdef CONFIG_SND_OSSEMUL
 		snd_info_free_entry(snd_oss_root);
 #endif
-		snd_remove_proc_entry(&proc_root, snd_proc_root);
+		snd_remove_proc_entry(NULL, snd_proc_root);
 	}
 	return 0;
 }
-- 
1.5.4.3


