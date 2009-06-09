Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZFIFyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZFIFyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 01:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZFIFx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 01:53:58 -0400
Received: from [65.98.92.6] ([65.98.92.6]:3899 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZFIFx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 01:53:58 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 01:53:57 EDT
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: <dedekind@infradead.org>, <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 8 Jun 2009 22:14:12 -0700
Subject: [PATCH] MTD: Add UBI reboot notifier
Message-Id: <018abcd2d98090bda0f75d3c95c9ec85@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubifs_sync_fs() may queue up a new UBI erase transaction, which is
processed in the background:

bash# sync
ubifs_sync_fs: enter
schedule_erase: enter
schedule_erase: exit
ubi_sync: enter
ubi_sync: exit
ubifs_sync_fs: exit
cfi_amdstd_erase_varsize: enter
bash# cfi_amdstd_erase_varsize: exit

Normally this is not a big deal.  However, during the final sync before
rebooting, it initiates an erase operation that is potentially still
active when Linux restarts the machine:

bash# reboot -f
ubifs_sync_fs: enter
schedule_erase: enter
schedule_erase: exit
ubi_sync: enter
ubi_sync: exit
ubifs_sync_fs: exit
cfi_amdstd_erase_varsize: enter
Restarting system.
<Flash is stuck in FL_ERASE mode - system hangs>

This is easiest to observe on a NOR flash.  One factor is the long erase
time.  The other reason is because getting a NOR flash stuck in FL_ERASE
mode will prevent the bootloader from running, unless the board provides
a way for the processor to automatically reset the flash.  In my
experience, many boards do not.

My proposal is to add a reboot notifier to let the UBI background thread
terminate gracefully.  The new ordering looks like this:

bash# reboot -f
ubifs_sync_fs: enter
schedule_erase: enter
schedule_erase: exit
ubifs_sync_fs: exit
cfi_amdstd_erase_varsize: enter
ubi_reboot_notifier: enter
cfi_amdstd_erase_varsize: exit
ubi_reboot_notifier: exit
cfi_amdstd_reboot: enter
cfi_amdstd_reboot: exit

cfi_amdstd_reboot doesn't really exist, but I added a dummy notifier to
make sure that the ordering would be correct when using drivers that do
have this feature.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/ubi/build.c |   24 ++++++++++++++++++++++++
 drivers/mtd/ubi/ubi.h   |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 4048db8..ca88059 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -41,6 +41,7 @@
 #include <linux/miscdevice.h>
 #include <linux/log2.h>
 #include <linux/kthread.h>
+#include <linux/reboot.h>
 #include "ubi.h"
 
 /* Maximum length of the 'mtd=' parameter */
@@ -726,6 +727,23 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 }
 
 /**
+ * ubi_reboot_notifier - halt UBI transactions immediately prior to a reboot
+ * @n: notifier_block struct (inside our struct ubi_device)
+ * @val: unused
+ * @v: unused
+ */
+static int ubi_reboot_notifier(struct notifier_block *n, unsigned long val,
+	void *v)
+{
+	struct ubi_device *ubi = container_of(n, struct ubi_device,
+		reboot_notifier);
+
+	if (ubi->bgt_thread)
+		kthread_stop(ubi->bgt_thread);
+	return NOTIFY_DONE;
+}
+
+/**
  * ubi_attach_mtd_dev - attach an MTD device.
  * @mtd: MTD device description object
  * @ubi_num: number to assign to the new UBI device
@@ -876,6 +894,11 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 		ubi->thread_enabled = 1;
 	wake_up_process(ubi->bgt_thread);
 
+	/* Flash device priority is 0.  UBI needs to shut down first. */
+	ubi->reboot_notifier.priority = 1;
+	ubi->reboot_notifier.notifier_call = ubi_reboot_notifier;
+	register_reboot_notifier(&ubi->reboot_notifier);
+
 	ubi_devices[ubi_num] = ubi;
 	return ubi_num;
 
@@ -945,6 +968,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	 * Before freeing anything, we have to stop the background thread to
 	 * prevent it from doing anything on this device while we are freeing.
 	 */
+	unregister_reboot_notifier(&ubi->reboot_notifier);
 	if (ubi->bgt_thread)
 		kthread_stop(ubi->bgt_thread);
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index c055511..44a45b9 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -36,6 +36,7 @@
 #include <linux/device.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/notifier.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/ubi.h>
 
@@ -420,6 +421,7 @@ struct ubi_device {
 	struct task_struct *bgt_thread;
 	int thread_enabled;
 	char bgt_name[sizeof(UBI_BGT_NAME_PATTERN)+2];
+	struct notifier_block reboot_notifier;
 
 	/* I/O sub-system's stuff */
 	long long flash_size;
-- 
1.6.3.1

