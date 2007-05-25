Return-Path: <linux-kernel-owner+w=401wt.eu-S1762705AbXEYMQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705AbXEYMQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbXEYMPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:15:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760756AbXEYMP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:15:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/4] swsusp: Introduce restore platform operations
Date: Fri, 25 May 2007 14:18:34 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <aystarik@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <200705251409.55644.rjw@sisk.pl>
In-Reply-To: <200705251409.55644.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705251418.34742.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

At least on some machines it is necessary to prepare the ACPI firmware for the
restoration of the system memory state from the hibernation image if the
"platform" mode of hibernation has been used.  Namely, in that cases we need to
disable the GPEs before replacing the "boot" kernel with the "frozen" kernel
(cf. http://bugzilla.kernel.org/show_bug.cgi?id=7887).  After the restore they
will be re-enabled by hibernation_ops->finish(), but if the restore fails, they
have to be re-enabled by the restore code explicitly.

For this purpose we can introduce two additional hibernation operations, called
pre_restore() and restore_cleanup() and call them from the restore code path.
Still, they should be called if the "platform" mode of hibernation has been
used, so we need to pass the information about the hibernation mode from the
"frozen" kernel to the "boot" kernel in the image header.

Apparently, we can't drop the disabling of GPEs before the restore because of
Bug #7887 .  We also can't do it unconditionally, because the GPEs wouldn't have
been enabled after a successful restore if the suspend had been done in the
'shutdown' or 'reboot' mode.

In principle we could (and probably should) unconditionally disable the GPEs
before each snapshot creation *and* before the restore, but then we'd have to
unconditionally enable them after the snapshot creation as well as after the
restore (or restore failure)   Still, for this purpose we'd need to modify
acpi_enter_sleep_state_prep() and acpi_leave_sleep_state() and we'd have to
introduce some mechanism synchronizing the disablind/enabling of the GPEs with
the device drivers' .suspend()/.resume() routines and with
disable_/enable_nonboot_cpus().  However, this would have affected the suspend
(ie. s2ram) code as well as the hibernation, which I'd like to avoid in this
patch series.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sleep/main.c |   16 +++++++++++++
 include/linux/suspend.h   |    4 +++
 kernel/power/disk.c       |   56 +++++++++++++++++++++++++++++++++++++---------
 kernel/power/power.h      |   13 ++++++++--
 kernel/power/swap.c       |   20 ++++++++++++----
 kernel/power/user.c       |    2 -
 6 files changed, 92 insertions(+), 19 deletions(-)

Index: linux-2.6.22-rc2/kernel/power/disk.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/disk.c
+++ linux-2.6.22-rc2/kernel/power/disk.c
@@ -54,7 +54,8 @@ struct hibernation_ops *hibernation_ops;
 
 void hibernation_set_ops(struct hibernation_ops *ops)
 {
-	if (ops && !(ops->prepare && ops->enter && ops->finish)) {
+	if (ops && !(ops->prepare && ops->enter && ops->finish
+	    && ops->pre_restore && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
 	}
@@ -92,6 +93,31 @@ static void platform_finish(int platform
 }
 
 /**
+ *	platform_pre_restore - prepare the platform for the restoration from a
+ *	hibernation image.  If the restore fails after this function has been
+ *	called, platform_restore_cleanup() must be called.
+ */
+
+static int platform_pre_restore(int platform_mode)
+{
+	return (platform_mode && hibernation_ops) ?
+		hibernation_ops->pre_restore() : 0;
+}
+
+/**
+ *	platform_restore_cleanup - switch the platform to the normal mode of
+ *	operation after a failing restore.  If platform_pre_restore() has been
+ *	called before the failing restore, this function must be called too,
+ *	regardless of the result of platform_pre_restore().
+ */
+
+static void platform_restore_cleanup(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->restore_cleanup();
+}
+
+/**
  *	hibernation_snapshot - quiesce devices and create the hibernation
  *	snapshot image.
  *	@platform_mode - if set, use the platform driver, if available, to
@@ -141,11 +167,13 @@ int hibernation_snapshot(int platform_mo
 /**
  *	hibernation_restore - quiesce devices and restore the hibernation
  *	snapshot image.  If successful, control returns in hibernation_snaphot()
+ *	@platform_mode - if set, use the platform driver, if available, to
+ *			 prepare the platform frimware for the transition.
  *
  *	Must be called with pm_mutex held
  */
 
-int hibernation_restore(void)
+int hibernation_restore(int platform_mode)
 {
 	int error;
 
@@ -155,11 +183,14 @@ int hibernation_restore(void)
 	if (error)
 		goto Finish;
 
-	error = disable_nonboot_cpus();
-	if (!error)
-		error = swsusp_resume();
-
-	enable_nonboot_cpus();
+	error = platform_pre_restore(platform_mode);
+	if (!error) {
+		error = disable_nonboot_cpus();
+		if (!error)
+			error = swsusp_resume();
+		enable_nonboot_cpus();
+	}
+	platform_restore_cleanup(platform_mode);
  Finish:
 	device_resume();
 	resume_console();
@@ -260,8 +291,12 @@ int hibernate(void)
 	}
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
 	if (in_suspend && !error) {
+		unsigned int flags = 0;
+
+		if (hibernation_mode == HIBERNATION_PLATFORM)
+			flags |= SF_PLATFORM_MODE;
 		pr_debug("PM: writing image.\n");
-		error = swsusp_write();
+		error = swsusp_write(flags);
 		swsusp_free();
 		if (!error)
 			power_down();
@@ -295,6 +330,7 @@ int hibernate(void)
 static int software_resume(void)
 {
 	int error;
+	unsigned int flags;
 
 	mutex_lock(&pm_mutex);
 	if (!swsusp_resume_device) {
@@ -342,9 +378,9 @@ static int software_resume(void)
 
 	pr_debug("PM: Reading swsusp image.\n");
 
-	error = swsusp_read();
+	error = swsusp_read(&flags);
 	if (!error)
-		hibernation_restore();
+		hibernation_restore(flags & SF_PLATFORM_MODE);
 
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	swsusp_free();
Index: linux-2.6.22-rc2/kernel/power/power.h
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/power.h
+++ linux-2.6.22-rc2/kernel/power/power.h
@@ -27,7 +27,7 @@ struct swsusp_info {
 
 /* kernel/power/disk.c */
 extern int hibernation_snapshot(int platform_mode);
-extern int hibernation_restore(void);
+extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
 #endif
 
@@ -155,13 +155,20 @@ extern sector_t alloc_swapdev_block(int 
 extern void free_all_swap_pages(int swap);
 extern int swsusp_swap_in_use(void);
 
+/*
+ * Flags that can be passed from the hibernatig hernel to the "boot" kernel in
+ * the image header.
+ */
+#define SF_PLATFORM_MODE	1
+
+/* kernel/power/disk.c */
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
 extern int swsusp_suspend(void);
 extern int swsusp_resume(void);
-extern int swsusp_read(void);
-extern int swsusp_write(void);
+extern int swsusp_read(unsigned int *flags_p);
+extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(void);
 extern int suspend_enter(suspend_state_t state);
 
Index: linux-2.6.22-rc2/kernel/power/swap.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/swap.c
+++ linux-2.6.22-rc2/kernel/power/swap.c
@@ -33,8 +33,9 @@ extern char resume_file[];
 #define SWSUSP_SIG	"S1SUSPEND"
 
 struct swsusp_header {
-	char reserved[PAGE_SIZE - 20 - sizeof(sector_t)];
+	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int)];
 	sector_t image;
+	unsigned int flags;	/* Flags to pass to the "boot" kernel */
 	char	orig_sig[10];
 	char	sig[10];
 } __attribute__((packed));
@@ -138,7 +139,7 @@ static int wait_on_bio_chain(struct bio 
  * Saving part
  */
 
-static int mark_swapfiles(sector_t start)
+static int mark_swapfiles(sector_t start, unsigned int flags)
 {
 	int error;
 
@@ -148,6 +149,7 @@ static int mark_swapfiles(sector_t start
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
 		swsusp_header->image = start;
+		swsusp_header->flags = flags;
 		error = bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
@@ -369,6 +371,7 @@ static int enough_swap(unsigned int nr_p
 
 /**
  *	swsusp_write - Write entire image and metadata.
+ *	@flags: flags to pass to the "boot" kernel in the image header
  *
  *	It is important _NOT_ to umount filesystems at this point. We want
  *	them synced (in case something goes wrong) but we DO not want to mark
@@ -376,7 +379,7 @@ static int enough_swap(unsigned int nr_p
  *	correctly, we'll mark system clean, anyway.)
  */
 
-int swsusp_write(void)
+int swsusp_write(unsigned int flags)
 {
 	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
@@ -415,7 +418,7 @@ int swsusp_write(void)
 		if (!error) {
 			flush_swap_writer(&handle);
 			printk("S");
-			error = mark_swapfiles(start);
+			error = mark_swapfiles(start, flags);
 			printk("|\n");
 		}
 	}
@@ -540,13 +543,20 @@ static int load_image(struct swap_map_ha
 	return error;
 }
 
-int swsusp_read(void)
+/**
+ *	swsusp_read - read the hibernation image.
+ *	@flags_p: flags passed by the "frozen" kernel in the image header should
+ *		  be written into this memeory location
+ */
+
+int swsusp_read(unsigned int *flags_p)
 {
 	int error;
 	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
 
+	*flags_p = swsusp_header->flags;
 	if (IS_ERR(resume_bdev)) {
 		pr_debug("swsusp: block device not initialised\n");
 		return PTR_ERR(resume_bdev);
Index: linux-2.6.22-rc2/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc2.orig/kernel/power/user.c
+++ linux-2.6.22-rc2/kernel/power/user.c
@@ -186,7 +186,7 @@ static int snapshot_ioctl(struct inode *
 			error = -EPERM;
 			break;
 		}
-		error = hibernation_restore();
+		error = hibernation_restore(data->platform_suspend);
 		break;
 
 	case SNAPSHOT_FREE:
Index: linux-2.6.22-rc2/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.22-rc2.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.22-rc2/drivers/acpi/sleep/main.c
@@ -217,10 +217,26 @@ static void acpi_hibernation_finish(void
 	}
 }
 
+static int acpi_hibernation_pre_restore(void)
+{
+	acpi_status status;
+
+	status = acpi_hw_disable_all_gpes();
+
+	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
+}
+
+static void acpi_hibernation_restore_cleanup(void)
+{
+	acpi_hw_enable_all_runtime_gpes();
+}
+
 static struct hibernation_ops acpi_hibernation_ops = {
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
 	.finish = acpi_hibernation_finish,
+	.pre_restore = acpi_hibernation_pre_restore,
+	.restore_cleanup = acpi_hibernation_restore_cleanup,
 };
 #endif				/* CONFIG_SOFTWARE_SUSPEND */
 
Index: linux-2.6.22-rc2/include/linux/suspend.h
===================================================================
--- linux-2.6.22-rc2.orig/include/linux/suspend.h
+++ linux-2.6.22-rc2/include/linux/suspend.h
@@ -43,11 +43,15 @@ static inline void pm_restore_console(vo
  * @prepare: prepare system for hibernation
  * @enter: shut down system after state has been saved to disk
  * @finish: finish/clean up after state has been reloaded
+ * @pre_restore: prepare system for the restoration from a hibernation image
+ * @restore_cleanup: clean up after a failing image restoration
  */
 struct hibernation_ops {
 	int (*prepare)(void);
 	int (*enter)(void);
 	void (*finish)(void);
+	int (*pre_restore)(void);
+	void (*restore_cleanup)(void);
 };
 
 #if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)

