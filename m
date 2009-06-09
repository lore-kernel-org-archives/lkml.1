Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbZFISOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbZFISOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZFISOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:14:05 -0400
Received: from [65.98.92.6] ([65.98.92.6]:3973 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZFISOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:14:04 -0400
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: <dedekind@infradead.org>, <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 9 Jun 2009 10:59:19 -0700
Subject: [PATCHv2] MTD: Add UBI reboot notifier
Message-Id: <f5be75d5abc1acd236bedf36c55a860e@localhost>
References: <1244550775.5847.385.camel@localhost.localdomain>
In-Reply-To: <1244550775.5847.385.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Terminate the UBI background thread prior to restarting the system.

Changes from v1:

Add ubi_sync() at the end, to make sure the underlying MTD device has
synchronized its buffers.

Clean up comments and formatting.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/ubi/build.c |   30 ++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi.h   |    3 +++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 4048db8..18b42c9 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -41,6 +41,7 @@
 #include <linux/miscdevice.h>
 #include <linux/log2.h>
 #include <linux/kthread.h>
+#include <linux/reboot.h>
 #include "ubi.h"
 
 /* Maximum length of the 'mtd=' parameter */
@@ -726,6 +727,29 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 }
 
 /**
+ * ubi_reboot_notifier - halt UBI transactions immediately prior to a reboot.
+ * @n: reboot notifier object
+ * @state: SYS_RESTART, SYS_HALT, or SYS_POWER_OFF
+ * @cmd: pointer to command string for RESTART2
+ *
+ * This function stops the UBI background thread so that the flash device
+ * remains quiescent when Linux restarts the system.  Any queued work will
+ * be discarded, but this function will block until do_work() finishes if
+ * an operation is already in progress.
+ */
+static int ubi_reboot_notifier(struct notifier_block *n, unsigned long state,
+			       void *cmd)
+{
+	struct ubi_device *ubi;
+
+	ubi = container_of(n, struct ubi_device, reboot_notifier);
+	if (ubi->bgt_thread)
+		kthread_stop(ubi->bgt_thread);
+	ubi_sync(ubi->ubi_num);
+	return NOTIFY_DONE;
+}
+
+/**
  * ubi_attach_mtd_dev - attach an MTD device.
  * @mtd: MTD device description object
  * @ubi_num: number to assign to the new UBI device
@@ -876,6 +900,11 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 		ubi->thread_enabled = 1;
 	wake_up_process(ubi->bgt_thread);
 
+	/* Flash device priority is 0 - UBI needs to shut down first */
+	ubi->reboot_notifier.priority = 1;
+	ubi->reboot_notifier.notifier_call = ubi_reboot_notifier;
+	register_reboot_notifier(&ubi->reboot_notifier);
+
 	ubi_devices[ubi_num] = ubi;
 	return ubi_num;
 
@@ -945,6 +974,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	 * Before freeing anything, we have to stop the background thread to
 	 * prevent it from doing anything on this device while we are freeing.
 	 */
+	unregister_reboot_notifier(&ubi->reboot_notifier);
 	if (ubi->bgt_thread)
 		kthread_stop(ubi->bgt_thread);
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c055511..c8fab4a 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -36,6 +36,7 @@
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/notifier.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/ubi.h>
 
@@ -339,6 +340,7 @@ struct ubi_wl_entry;
  * @bgt_thread: background thread description object
  * @thread_enabled: if the background thread is enabled
  * @bgt_name: background thread name
+ * @reboot_notifier: notifier to terminate background thread before rebooting
  *
  * @flash_size: underlying MTD device size (in bytes)
  * @peb_count: count of physical eraseblocks on the MTD device
@@ -420,6 +422,7 @@ struct ubi_device {
 	struct task_struct *bgt_thread;
 	int thread_enabled;
 	char bgt_name[sizeof(UBI_BGT_NAME_PATTERN)+2];
+	struct notifier_block reboot_notifier;
 
 	/* I/O sub-system's stuff */
 	long long flash_size;
-- 
1.6.3.1

