Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbZJIDyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbZJIDyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbZJIDyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:54:35 -0400
Received: from mail.perches.com ([173.55.12.10]:2012 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbZJIDyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:54:33 -0400
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
In-Reply-To: <200910060037.57546.rjw@sisk.pl>
References: <cover.1254701151.git.joe@perches.com>
	 <200910052143.37985.rjw@sisk.pl>
	 <1254774687.1799.566.camel@Joe-Laptop.home>
	 <200910060037.57546.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Oct 2009 20:53:56 -0700
Message-Id: <1255060436.16347.36.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 00:37 +0200, Rafael J. Wysocki wrote:
> On Monday 05 October 2009, Joe Perches wrote:
> > On Mon, 2009-10-05 at 21:43 +0200, Rafael J. Wysocki wrote:
> > > On Monday 05 October 2009, Joe Perches wrote:
> > > > Added #define pr_fmt(fmt) "PM: " fmt
> > > > Converted printk(KERN_<level> to pr_<level>(
> > > > Removed "PM: " prefix
> > > > Added pr_fmt() to __initdata strings
> > > 
> > > Well, can you please tell me what actually is wrong with the current code?
> > 
> > Not much.  There were a couple of trivial corrections,
> > but perhaps the changes add a bit more flexibility and
> > regularity.
> > 
> > Effective trivial changes:
> > 
> > o Added KERN_CONT (pr_cont) to a couple of messages
> > o Added "PM: " (pr_info) to an #ifdef'd message
> > o Added "PM: " (pr_info) to a printk "Syncing filesystems ..."
> >   in power/user.c
> 
> The patch as is conflicts with the changes I have queued up for 2.6.33
> (they'll appear in linux-next after I've fixed all build issues, hopefully
> tomorrow).  For one example, we're dropping swsusp.c altogether.

Hi Rafael.

Here's the same patch redone against -next.

Added #define pr_fmt(fmt) "PM: " fmt
Converted printk(KERN_<level> to pr_<level>(
Converted printks without KERN_ to pr_info or pr_cont
Removed hard coded "PM: " prefix from message strings
Added pr_fmt() to __initdata strings
Integrated multiple line strings
All logging messages are now output prefixed with "PM: "

Signed-off-by: Joe Perches <joe@perches.com>

 kernel/power/hibernate.c     |   54 ++++++++++++++++++++---------------------
 kernel/power/hibernate_nvs.c |    6 +++-
 kernel/power/process.c       |   28 +++++++++++-----------
 kernel/power/snapshot.c      |   33 +++++++++++++------------
 kernel/power/suspend.c       |   18 +++++++------
 kernel/power/suspend_test.c  |   17 +++++++------
 kernel/power/swap.c          |   44 ++++++++++++++++------------------
 kernel/power/user.c          |    8 ++++--
 8 files changed, 106 insertions(+), 102 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 5d0d150..ce6c8ef 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -9,6 +9,8 @@
  * This file is released under the GPLv2.
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
@@ -85,7 +87,7 @@ EXPORT_SYMBOL(system_entering_hibernation);
 #ifdef CONFIG_PM_DEBUG
 static void hibernation_debug_sleep(void)
 {
-	printk(KERN_INFO "hibernation debug: Waiting for 5 seconds.\n");
+	pr_info("hibernation debug: Waiting for 5 seconds.\n");
 	mdelay(5000);
 }
 
@@ -221,10 +223,10 @@ void swsusp_show_speed(struct timeval *start, struct timeval *stop,
 		centisecs = 1;	/* avoid div-by-zero */
 	k = nr_pages * (PAGE_SIZE / 1024);
 	kps = (k * 100) / centisecs;
-	printk(KERN_INFO "PM: %s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
-			msg, k,
-			centisecs / 100, centisecs % 100,
-			kps / 1000, (kps % 1000) / 10);
+	pr_info("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
+		msg, k,
+		centisecs / 100, centisecs % 100,
+		kps / 1000, (kps % 1000) / 10);
 }
 
 /**
@@ -249,8 +251,7 @@ static int create_image(int platform_mode)
 	 */
 	error = dpm_suspend_noirq(PMSG_FREEZE);
 	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to power down, "
-			"aborting hibernation\n");
+		pr_err("Some devices failed to power down, aborting hibernation\n");
 		return error;
 	}
 
@@ -267,8 +268,7 @@ static int create_image(int platform_mode)
 
 	error = sysdev_suspend(PMSG_FREEZE);
 	if (error) {
-		printk(KERN_ERR "PM: Some system devices failed to power down, "
-			"aborting hibernation\n");
+		pr_err("Some system devices failed to power down, aborting hibernation\n");
 		goto Enable_irqs;
 	}
 
@@ -279,8 +279,7 @@ static int create_image(int platform_mode)
 	save_processor_state();
 	error = swsusp_arch_suspend();
 	if (error)
-		printk(KERN_ERR "PM: Error %d creating hibernation image\n",
-			error);
+		pr_err("Error %d creating hibernation image\n", error);
 	/* Restore control flow magically appears here */
 	restore_processor_state();
 	if (!in_suspend)
@@ -371,8 +370,7 @@ static int resume_target_kernel(bool platform_mode)
 
 	error = dpm_suspend_noirq(PMSG_QUIESCE);
 	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to power down, "
-			"aborting resume\n");
+		pr_err("Some devices failed to power down, aborting resume\n");
 		return error;
 	}
 
@@ -549,7 +547,7 @@ static void power_down(void)
 	 * Valid image is on the disk, if we continue we risk serious data
 	 * corruption after resume.
 	 */
-	printk(KERN_CRIT "PM: Please power down manually\n");
+	pr_crit("Please power down manually\n");
 	while(1);
 }
 
@@ -593,9 +591,9 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
-	printk(KERN_INFO "PM: Syncing filesystems ... ");
+	pr_info("Syncing filesystems ... ");
 	sys_sync();
-	printk("done.\n");
+	pr_cont("done.\n");
 
 	error = prepare_processes();
 	if (error)
@@ -616,13 +614,13 @@ int hibernate(void)
 
 		if (hibernation_mode == HIBERNATION_PLATFORM)
 			flags |= SF_PLATFORM_MODE;
-		pr_debug("PM: writing image.\n");
+		pr_debug("writing image.\n");
 		error = swsusp_write(flags);
 		swsusp_free();
 		if (!error)
 			power_down();
 	} else {
-		pr_debug("PM: Image restored successfully.\n");
+		pr_debug("Image restored successfully.\n");
 	}
 
  Thaw:
@@ -683,7 +681,7 @@ static int software_resume(void)
 		goto Unlock;
 	}
 
-	pr_debug("PM: Checking image partition %s\n", resume_file);
+	pr_debug("Checking image partition %s\n", resume_file);
 
 	/* Check if the device is there */
 	swsusp_resume_device = name_to_dev_t(resume_file);
@@ -708,10 +706,10 @@ static int software_resume(void)
 	}
 
  Check_image:
-	pr_debug("PM: Resume from partition %d:%d\n",
-		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
+	pr_debug("Resume from partition %d:%d\n",
+		 MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
 
-	pr_debug("PM: Checking hibernation image.\n");
+	pr_debug("Checking hibernation image.\n");
 	error = swsusp_check();
 	if (error)
 		goto Unlock;
@@ -736,21 +734,21 @@ static int software_resume(void)
 	if (error)
 		goto close_finish;
 
-	pr_debug("PM: Preparing processes for restore.\n");
+	pr_debug("Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
 		swsusp_close(FMODE_READ);
 		goto Done;
 	}
 
-	pr_debug("PM: Reading hibernation image.\n");
+	pr_debug("Reading hibernation image.\n");
 
 	error = swsusp_read(&flags);
 	swsusp_close(FMODE_READ);
 	if (!error)
 		hibernation_restore(flags & SF_PLATFORM_MODE);
 
-	printk(KERN_ERR "PM: Restore failed, recovering.\n");
+	pr_err("Restore failed, recovering.\n");
 	swsusp_free();
 	thaw_processes();
  Done:
@@ -763,7 +761,7 @@ static int software_resume(void)
 	/* For success case, the suspend path will release the lock */
  Unlock:
 	mutex_unlock(&pm_mutex);
-	pr_debug("PM: Resume from disk failed.\n");
+	pr_debug("Resume from disk failed.\n");
 	return error;
 close_finish:
 	swsusp_close(FMODE_READ);
@@ -876,7 +874,7 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 		error = -EINVAL;
 
 	if (!error)
-		pr_debug("PM: Hibernation mode set to '%s'\n",
+		pr_debug("Hibernation mode set to '%s'\n",
 			 hibernation_modes[mode]);
 	mutex_unlock(&pm_mutex);
 	return error ? error : n;
@@ -908,7 +906,7 @@ static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
 	mutex_lock(&pm_mutex);
 	swsusp_resume_device = res;
 	mutex_unlock(&pm_mutex);
-	printk(KERN_INFO "PM: Starting manual resume from disk\n");
+	pr_info("Starting manual resume from disk\n");
 	noresume = 0;
 	software_resume();
 	ret = n;
diff --git a/kernel/power/hibernate_nvs.c b/kernel/power/hibernate_nvs.c
index 39ac698..13bf5cf 100644
--- a/kernel/power/hibernate_nvs.c
+++ b/kernel/power/hibernate_nvs.c
@@ -6,6 +6,8 @@
  * This file is released under the GPLv2.
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -108,7 +110,7 @@ void hibernate_nvs_save(void)
 {
 	struct nvs_page *entry;
 
-	printk(KERN_INFO "PM: Saving platform NVS memory\n");
+	pr_info("Saving platform NVS memory\n");
 
 	list_for_each_entry(entry, &nvs_list, node)
 		if (entry->data) {
@@ -127,7 +129,7 @@ void hibernate_nvs_restore(void)
 {
 	struct nvs_page *entry;
 
-	printk(KERN_INFO "PM: Restoring platform NVS memory\n");
+	pr_info("Restoring platform NVS memory\n");
 
 	list_for_each_entry(entry, &nvs_list, node)
 		if (entry->data)
diff --git a/kernel/power/process.c b/kernel/power/process.c
index cc2e553..7ead6c2 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -5,6 +5,7 @@
  * Originally from swsusp.
  */
 
+#define pr_fmt(fmt) "PM: " fmt
 
 #undef DEBUG
 
@@ -78,23 +79,22 @@ static int try_to_freeze_tasks(bool sig_only)
 		 * and caller must call thaw_processes() if something fails),
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
-		printk("\n");
-		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
-				"(%d tasks refusing to freeze):\n",
-				elapsed_csecs / 100, elapsed_csecs % 100, todo);
+		pr_cont("\n");
+		pr_err("Freezing of tasks failed after %d.%02d seconds (%d tasks refusing to freeze):\n",
+		       elapsed_csecs / 100, elapsed_csecs % 100, todo);
 		show_state();
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
 			if (freezing(p) && !freezer_should_skip(p))
-				printk(KERN_ERR " %s\n", p->comm);
+				pr_err(" %s\n", p->comm);
 			cancel_freezing(p);
 			task_unlock(p);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	} else {
-		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
-			elapsed_csecs % 100);
+		pr_cont("(elapsed %d.%02d seconds) ",
+			elapsed_csecs / 100, elapsed_csecs % 100);
 	}
 
 	return todo ? -EBUSY : 0;
@@ -107,22 +107,22 @@ int freeze_processes(void)
 {
 	int error;
 
-	printk("Freezing user space processes ... ");
+	pr_info("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(true);
 	if (error)
 		goto Exit;
-	printk("done.\n");
+	pr_cont("done.\n");
 
-	printk("Freezing remaining freezable tasks ... ");
+	pr_info("Freezing remaining freezable tasks ... ");
 	error = try_to_freeze_tasks(false);
 	if (error)
 		goto Exit;
-	printk("done.");
+	pr_cont("done.");
 
 	oom_killer_disable();
  Exit:
 	BUG_ON(in_atomic());
-	printk("\n");
+	pr_cont("\n");
 
 	return error;
 }
@@ -151,10 +151,10 @@ void thaw_processes(void)
 {
 	oom_killer_enable();
 
-	printk("Restarting tasks ... ");
+	pr_info("Restarting tasks ... ");
 	thaw_tasks(true);
 	thaw_tasks(false);
 	schedule();
-	printk("done.\n");
+	pr_cont("done.\n");
 }
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 36cb168..a424e3a 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -624,7 +626,7 @@ __register_nosave_region(unsigned long start_pfn, unsigned long end_pfn,
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);
  Report:
-	printk(KERN_INFO "PM: Registered nosave memory: %016lx - %016lx\n",
+	pr_info("Registered nosave memory: %016lx - %016lx\n",
 		start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
 }
 
@@ -693,7 +695,7 @@ static void mark_nosave_pages(struct memory_bitmap *bm)
 	list_for_each_entry(region, &nosave_regions, list) {
 		unsigned long pfn;
 
-		pr_debug("PM: Marking nosave pages: %016lx - %016lx\n",
+		pr_debug("Marking nosave pages: %016lx - %016lx\n",
 				region->start_pfn << PAGE_SHIFT,
 				region->end_pfn << PAGE_SHIFT);
 
@@ -745,7 +747,7 @@ int create_basic_memory_bitmaps(void)
 	free_pages_map = bm2;
 	mark_nosave_pages(forbidden_pages_map);
 
-	pr_debug("PM: Basic memory bitmaps created\n");
+	pr_debug("Basic memory bitmaps created\n");
 
 	return 0;
 
@@ -780,7 +782,7 @@ void free_basic_memory_bitmaps(void)
 	memory_bm_free(bm2, PG_UNSAFE_CLEAR);
 	kfree(bm2);
 
-	pr_debug("PM: Basic memory bitmaps freed\n");
+	pr_debug("Basic memory bitmaps freed\n");
 }
 
 /**
@@ -1261,7 +1263,7 @@ int hibernate_preallocate_memory(void)
 	struct timeval start, stop;
 	int error;
 
-	printk(KERN_INFO "PM: Preallocating image memory... ");
+	pr_info("Preallocating image memory... ");
 	do_gettimeofday(&start);
 
 	error = memory_bm_create(&orig_bm, GFP_IMAGE, PG_ANY);
@@ -1354,13 +1356,13 @@ int hibernate_preallocate_memory(void)
 
  out:
 	do_gettimeofday(&stop);
-	printk(KERN_CONT "done (allocated %lu pages)\n", pages);
+	pr_cont("done (allocated %lu pages)\n", pages);
 	swsusp_show_speed(&start, &stop, pages, "Allocated");
 
 	return 0;
 
  err_out:
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 	swsusp_free();
 	return -ENOMEM;
 }
@@ -1402,8 +1404,8 @@ static int enough_free_mem(unsigned int nr_pages, unsigned int nr_highmem)
 			free += zone_page_state(zone, NR_FREE_PAGES);
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("PM: Normal pages needed: %u + %u, available pages: %u\n",
-		nr_pages, PAGES_FOR_IO, free);
+	pr_debug("Normal pages needed: %u + %u, available pages: %u\n",
+		 nr_pages, PAGES_FOR_IO, free);
 
 	return free > nr_pages + PAGES_FOR_IO;
 }
@@ -1500,20 +1502,20 @@ asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
-	printk(KERN_INFO "PM: Creating hibernation image: \n");
+	pr_info("Creating hibernation image:\n");
 
 	drain_local_pages(NULL);
 	nr_pages = count_data_pages();
 	nr_highmem = count_highmem_pages();
-	printk(KERN_INFO "PM: Need to copy %u pages\n", nr_pages + nr_highmem);
+	pr_info("Need to copy %u pages\n", nr_pages + nr_highmem);
 
 	if (!enough_free_mem(nr_pages, nr_highmem)) {
-		printk(KERN_ERR "PM: Not enough free memory\n");
+		pr_err("Not enough free memory\n");
 		return -ENOMEM;
 	}
 
 	if (swsusp_alloc(&orig_bm, &copy_bm, nr_pages, nr_highmem)) {
-		printk(KERN_ERR "PM: Memory allocation failed\n");
+		pr_err("Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -1533,8 +1535,7 @@ asmlinkage int swsusp_save(void)
 	nr_copy_pages = nr_pages;
 	nr_meta_pages = DIV_ROUND_UP(nr_pages * sizeof(long), PAGE_SIZE);
 
-	printk(KERN_INFO "PM: Hibernation image created (%d pages copied)\n",
-		nr_pages);
+	pr_info("Hibernation image created (%d pages copied)\n", nr_pages);
 
 	return 0;
 }
@@ -1733,7 +1734,7 @@ static int check_header(struct swsusp_info *info)
 	if (!reason && info->num_physpages != num_physpages)
 		reason = "memory size";
 	if (reason) {
-		printk(KERN_ERR "PM: Image mismatch: %s\n", reason);
+		pr_err("Image mismatch: %s\n", reason);
 		return -EPERM;
 	}
 	return 0;
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6f10dfc..14e83cd 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -8,6 +8,8 @@
  * This file is released under the GPLv2.
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -61,7 +63,7 @@ static int suspend_test(int level)
 {
 #ifdef CONFIG_PM_DEBUG
 	if (pm_test_level == level) {
-		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
+		pr_info("suspend debug: Waiting for 5 seconds.\n");
 		mdelay(5000);
 		return 1;
 	}
@@ -134,7 +136,7 @@ static int suspend_enter(suspend_state_t state)
 
 	error = dpm_suspend_noirq(PMSG_SUSPEND);
 	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to power down\n");
+		pr_err("Some devices failed to power down\n");
 		goto Platfrom_finish;
 	}
 
@@ -202,7 +204,7 @@ int suspend_devices_and_enter(suspend_state_t state)
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to suspend\n");
+		pr_err("Some devices failed to suspend\n");
 		goto Recover_platform;
 	}
 	suspend_test_finish("suspend devices");
@@ -261,11 +263,11 @@ int enter_state(suspend_state_t state)
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
-	printk(KERN_INFO "PM: Syncing filesystems ... ");
+	pr_info("Syncing filesystems ... ");
 	sys_sync();
-	printk("done.\n");
+	pr_cont("done.\n");
 
-	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
+	pr_debug("Preparing system for %s sleep\n", pm_states[state]);
 	error = suspend_prepare();
 	if (error)
 		goto Unlock;
@@ -273,11 +275,11 @@ int enter_state(suspend_state_t state)
 	if (suspend_test(TEST_FREEZER))
 		goto Finish;
 
-	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pr_debug("Entering %s sleep\n", pm_states[state]);
 	error = suspend_devices_and_enter(state);
 
  Finish:
-	pr_debug("PM: Finishing wakeup.\n");
+	pr_debug("Finishing wakeup.\n");
 	suspend_finish();
  Unlock:
 	mutex_unlock(&pm_mutex);
diff --git a/kernel/power/suspend_test.c b/kernel/power/suspend_test.c
index 17d8bb1..e5cc1b9 100644
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
@@ -6,6 +6,8 @@
  * This file is released under the GPLv2.
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/init.h>
 #include <linux/rtc.h>
 
@@ -38,8 +40,7 @@ void suspend_test_finish(const char *label)
 	unsigned msec;
 
 	msec = jiffies_to_msecs(abs(nj));
-	pr_info("PM: %s took %d.%03d seconds\n", label,
-			msec / 1000, msec % 1000);
+	pr_info("%s took %d.%03d seconds\n", label, msec / 1000, msec % 1000);
 
 	/* Warning on suspend means the RTC alarm period needs to be
 	 * larger -- the system was sooo slooowwww to suspend that the
@@ -60,13 +61,13 @@ void suspend_test_finish(const char *label)
 static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
 {
 	static char err_readtime[] __initdata =
-		KERN_ERR "PM: can't read %s time, err %d\n";
+		KERN_ERR pr_fmt("can't read %s time, err %d\n");
 	static char err_wakealarm [] __initdata =
-		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
+		KERN_ERR pr_fmt("can't set %s wakealarm, err %d\n");
 	static char err_suspend[] __initdata =
-		KERN_ERR "PM: suspend test failed, error %d\n";
+		KERN_ERR pr_fmt("suspend test failed, error %d\n");
 	static char info_test[] __initdata =
-		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
+		KERN_INFO pr_fmt("test RTC wakeup from '%s' suspend\n");
 
 	unsigned long		now;
 	struct rtc_wkalrm	alm;
@@ -132,7 +133,7 @@ static int __init has_wakealarm(struct device *dev, void *name_ptr)
 static suspend_state_t test_state __initdata = PM_SUSPEND_ON;
 
 static char warn_bad_state[] __initdata =
-	KERN_WARNING "PM: can't test '%s' suspend state\n";
+	KERN_WARNING pr_fmt("can't test '%s' suspend state\n");
 
 static int __init setup_test_suspend(char *value)
 {
@@ -156,7 +157,7 @@ __setup("test_suspend", setup_test_suspend);
 static int __init test_suspend(void)
 {
 	static char		warn_no_rtc[] __initdata =
-		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
+		KERN_WARNING pr_fmt("no wakealarm-capable RTC driver is ready\n");
 
 	char			*pony = NULL;
 	struct rtc_device	*rtc = NULL;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 89e958e..75e5162 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/delay.h>
@@ -169,8 +171,7 @@ static int submit(int rw, pgoff_t page_off, struct page *page,
 	bio->bi_end_io = end_swap_bio_read;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
-			page_off);
+		pr_err("Adding page to bio failed at %ld\n", page_off);
 		bio_put(bio);
 		return -EFAULT;
 	}
@@ -250,7 +251,7 @@ static int mark_swapfiles(sector_t start, unsigned int flags)
 		error = bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
-		printk(KERN_ERR "PM: Swap header not found!\n");
+		pr_err("Swap header not found!\n");
 		error = -ENODEV;
 	}
 	return error;
@@ -422,8 +423,7 @@ static int save_image(struct swap_map_handle *handle,
 	struct timeval start;
 	struct timeval stop;
 
-	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
-		nr_to_write);
+	pr_info("Saving image data pages (%u pages) ...     ", nr_to_write);
 	m = nr_to_write / 100;
 	if (!m)
 		m = 1;
@@ -438,7 +438,7 @@ static int save_image(struct swap_map_handle *handle,
 			if (error)
 				break;
 			if (!(nr_pages % m))
-				printk("\b\b\b\b%3d%%", nr_pages / m);
+				pr_cont("\b\b\b\b%3d%%", nr_pages / m);
 			nr_pages++;
 		}
 	} while (ret > 0);
@@ -447,7 +447,7 @@ static int save_image(struct swap_map_handle *handle,
 	if (!error)
 		error = err2;
 	if (!error)
-		printk("\b\b\b\bdone\n");
+		pr_cont("\b\b\b\bdone\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 	return error;
 }
@@ -463,7 +463,7 @@ static int enough_swap(unsigned int nr_pages)
 {
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
-	pr_debug("PM: Free swap pages: %u\n", free_swap);
+	pr_debug("Free swap pages: %u\n", free_swap);
 	return free_swap > nr_pages + PAGES_FOR_IO;
 }
 
@@ -486,8 +486,7 @@ int swsusp_write(unsigned int flags)
 
 	error = swsusp_swap_check();
 	if (error) {
-		printk(KERN_ERR "PM: Cannot find swap device, try "
-				"swapon -a.\n");
+		pr_err("Cannot find swap device, try swapon -a.\n");
 		return error;
 	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
@@ -500,7 +499,7 @@ int swsusp_write(unsigned int flags)
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
 	if (!enough_swap(header->pages)) {
-		printk(KERN_ERR "PM: Not enough free swap\n");
+		pr_err("Not enough free swap\n");
 		error = -ENOSPC;
 		goto out;
 	}
@@ -515,9 +514,9 @@ int swsusp_write(unsigned int flags)
 
 		if (!error) {
 			flush_swap_writer(&handle);
-			printk(KERN_INFO "PM: S");
+			pr_info("S");
 			error = mark_swapfiles(start, flags);
-			printk("|\n");
+			pr_cont("|\n");
 		}
 	}
 	if (error)
@@ -605,8 +604,7 @@ static int load_image(struct swap_map_handle *handle,
 	int err2;
 	unsigned nr_pages;
 
-	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
-		nr_to_read);
+	pr_info("Loading image data pages (%u pages) ...     ", nr_to_read);
 	m = nr_to_read / 100;
 	if (!m)
 		m = 1;
@@ -625,7 +623,7 @@ static int load_image(struct swap_map_handle *handle,
 		if (error)
 			break;
 		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
+			pr_cont("\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
 	err2 = wait_on_bio_chain(&bio);
@@ -633,7 +631,7 @@ static int load_image(struct swap_map_handle *handle,
 	if (!error)
 		error = err2;
 	if (!error) {
-		printk("\b\b\b\bdone\n");
+		pr_cont("\b\b\b\bdone\n");
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			error = -ENODATA;
@@ -657,7 +655,7 @@ int swsusp_read(unsigned int *flags_p)
 
 	*flags_p = swsusp_header->flags;
 	if (IS_ERR(resume_bdev)) {
-		pr_debug("PM: Image device not initialised\n");
+		pr_debug("Image device not initialised\n");
 		return PTR_ERR(resume_bdev);
 	}
 
@@ -674,9 +672,9 @@ int swsusp_read(unsigned int *flags_p)
 	release_swap_reader(&handle);
 
 	if (!error)
-		pr_debug("PM: Image successfully loaded\n");
+		pr_debug("Image successfully loaded\n");
 	else
-		pr_debug("PM: Error %d resuming\n", error);
+		pr_debug("Error %d resuming\n", error);
 	return error;
 }
 
@@ -710,13 +708,13 @@ put:
 		if (error)
 			blkdev_put(resume_bdev, FMODE_READ);
 		else
-			pr_debug("PM: Signature found, resuming\n");
+			pr_debug("Signature found, resuming\n");
 	} else {
 		error = PTR_ERR(resume_bdev);
 	}
 
 	if (error)
-		pr_debug("PM: Error %d checking image file\n", error);
+		pr_debug("Error %d checking image file\n", error);
 
 	return error;
 }
@@ -728,7 +726,7 @@ put:
 void swsusp_close(fmode_t mode)
 {
 	if (IS_ERR(resume_bdev)) {
-		pr_debug("PM: Image device not initialised\n");
+		pr_debug("Image device not initialised\n");
 		return;
 	}
 
diff --git a/kernel/power/user.c b/kernel/power/user.c
index bf0014d..382d3c2 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) "PM: " fmt
+
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
@@ -221,9 +223,9 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		if (data->frozen)
 			break;
 
-		printk("Syncing filesystems ... ");
+		pr_info("Syncing filesystems ... ");
 		sys_sync();
-		printk("done.\n");
+		pr_cont("done.\n");
 
 		error = usermodehelper_disable();
 		if (error)
@@ -382,7 +384,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			break;
 
 		default:
-			printk(KERN_ERR "SNAPSHOT_PMOPS: invalid argument %ld\n", arg);
+			pr_err("SNAPSHOT_PMOPS: invalid argument %ld\n", arg);
 
 		}
 		break;


