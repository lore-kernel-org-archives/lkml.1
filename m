Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbXEYIi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbXEYIi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760256AbXEYIhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:37:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40504 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758658AbXEYIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:37:30 -0400
Message-Id: <20070525083632.474400000@sonycom.com>
References: <20070525083607.784351000@sonycom.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 May 2007 10:36:11 +0200
From: Geert.Uytterhoeven@sonycom.com
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 4/7] ps3: Storage Driver Probing
Content-Disposition: inline; filename=ps3stor_probe.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add storage driver probing.
New storage devices are detected and added by a kthread.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/device-init.c |  344 +++++++++++++++++++++++++++++++
 1 files changed, 344 insertions(+)

--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -28,6 +28,7 @@
 
 #include <asm/firmware.h>
 #include <asm/lv1call.h>
+#include <asm/ps3stor.h>
 
 #include "platform.h"
 
@@ -508,6 +509,348 @@ static int __devinit ps3_register_av(voi
 	return result;
 }
 
+#ifdef DEBUG
+static const char *ps3stor_dev_type(enum ps3_dev_type dev_type)
+{
+	switch (dev_type) {
+	case PS3_DEV_TYPE_STOR_DISK:
+		return "disk";
+
+	case PS3_DEV_TYPE_STOR_ROM:
+		return "rom";
+
+	case PS3_DEV_TYPE_STOR_FLASH:
+		return "flash";
+
+	case PS3_DEV_TYPE_NONE:
+		return "not present";
+
+	default:
+		return "unknown";
+	}
+}
+#else
+static inline const char *ps3stor_dev_type(enum ps3_dev_type dev_type)
+{
+    return NULL;
+}
+#endif /* DEBUG */
+
+#define NOTIFICATION_DEVID	((u64)(-1L))
+#define NOTIFICATION_TIMEOUT	HZ
+
+static u64 ps3stor_wait_for_completion(u64 devid, u64 tag,
+				       unsigned int timeout)
+{
+	unsigned int retries = 0;
+	u64 res = -1, status;
+
+	for (retries = 0; retries < timeout; retries++) {
+		res = lv1_storage_check_async_status(NOTIFICATION_DEVID, tag,
+						     &status);
+		if (!res)
+			break;
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(1);
+	}
+	if (res)
+		pr_debug("%s:%u: check_async_status returns %ld status %lx\n",
+			 __func__, __LINE__, res, status);
+
+	return res;
+}
+
+static int ps3stor_probe_notification(struct ps3_storage_device *dev,
+				      enum ps3_dev_type dev_type)
+{
+	int error = -ENODEV, res;
+	u64 *buf;
+	u64 lpar;
+
+	pr_info("%s:%u: Requesting notification\n", __func__, __LINE__);
+
+	buf = kzalloc(512, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	lpar = ps3_mm_phys_to_lpar(__pa(buf));
+
+	/* 2-1) open special event device */
+	res = lv1_open_device(dev->sbd.did.bus_id, NOTIFICATION_DEVID, 0);
+	if (res) {
+		printk(KERN_ERR "%s:%u: open notification device failed %d\n",
+		       __func__, __LINE__, res);
+		goto fail_free;
+	}
+
+	/* 2-2) write info to request notify */
+	buf[0] = 0;
+	buf[1] = (1 << 1); /* region update info only */
+	res = lv1_storage_write(NOTIFICATION_DEVID, 0, 0, 1, 0, lpar,
+				&dev->tag);
+	if (res) {
+		printk(KERN_ERR "%s:%u: notify request write failed %d\n",
+		       __func__, __LINE__, res);
+		goto fail_close;
+	}
+
+	/* wait for completion in one second */
+	res = ps3stor_wait_for_completion(NOTIFICATION_DEVID, dev->tag,
+					  NOTIFICATION_TIMEOUT);
+	if (res) {
+		/* write not completed */
+		printk(KERN_ERR "%s:%u: write not completed %d\n", __func__,
+		       __LINE__, res);
+		goto fail_close;
+	}
+
+	/* 2-3) read to wait region notification for each device */
+	while (1) {
+		memset(buf, 0, 512);
+		lv1_storage_read(NOTIFICATION_DEVID, 0, 0, 1, 0, lpar,
+				 &dev->tag);
+		res = ps3stor_wait_for_completion(NOTIFICATION_DEVID, dev->tag,
+						  NOTIFICATION_TIMEOUT);
+		if (res) {
+			/* read not completed */
+			printk(KERN_ERR "%s:%u: read not completed %d\n",
+			       __func__, __LINE__, res);
+			break;
+		}
+
+		/* 2-4) verify the notification */
+		if (buf[0] != 1 || buf[1] != dev->sbd.did.bus_id) {
+			/* other info notified */
+			pr_debug("%s:%u: notification info %ld dev=%lx type=%lx\n",
+				 __func__, __LINE__, buf[0], buf[2], buf[3]);
+			break;
+		}
+
+		if (buf[2] == dev->sbd.did.dev_id && buf[3] == dev_type) {
+			pr_debug("%s:%u: device ready\n", __func__, __LINE__);
+			error = 0;
+			break;
+		}
+	}
+
+fail_close:
+	lv1_close_device(dev->sbd.did.bus_id, NOTIFICATION_DEVID);
+
+fail_free:
+	kfree(buf);
+	return error;
+}
+
+static int ps3stor_probe_dev(struct ps3_repository_device *repo)
+{
+	int error;
+	u64 port, blk_size, num_blocks;
+	unsigned int num_regions, i;
+	struct ps3_storage_device *dev;
+	enum ps3_dev_type dev_type;
+	unsigned int match_id;
+
+	pr_info("%s:%u: Probing new storage device %u\n", __func__, __LINE__,
+		 repo->dev_index);
+
+	error = ps3_repository_read_dev_id(repo->bus_index, repo->dev_index,
+					   &repo->did.dev_id);
+	if (error) {
+		printk(KERN_ERR "%s:%u: read_dev_id failed %d\n", __func__,
+		       __LINE__, error);
+		return -ENODEV;
+	}
+
+	error = ps3_repository_read_dev_type(repo->bus_index, repo->dev_index,
+					     &dev_type);
+	if (error) {
+		printk(KERN_ERR "%s:%u: read_dev_type failed %d\n", __func__,
+		       __LINE__, error);
+		return -ENODEV;
+	}
+
+	pr_debug("%s:%u: index %u:%u: id %u:%u dev_type %u (%s)\n", __func__,
+		 __LINE__, repo->bus_index, repo->dev_index, repo->did.bus_id,
+		 repo->did.dev_id, dev_type, ps3stor_dev_type(dev_type));
+
+	switch (dev_type) {
+	case PS3_DEV_TYPE_STOR_DISK:
+		match_id = PS3_MATCH_ID_STOR_DISK;
+		break;
+
+	case PS3_DEV_TYPE_STOR_ROM:
+		match_id = PS3_MATCH_ID_STOR_ROM;
+		break;
+
+	case PS3_DEV_TYPE_STOR_FLASH:
+		match_id = PS3_MATCH_ID_STOR_FLASH;
+		break;
+
+	default:
+		return 0;
+	}
+
+	error = ps3_repository_read_stor_dev_info(repo->bus_index,
+						  repo->dev_index, &port,
+						  &blk_size, &num_blocks,
+						  &num_regions);
+	if (error) {
+		printk(KERN_ERR "%s:%u: _read_stor_dev_info failed %d\n",
+		       __func__, __LINE__, error);
+		return -ENODEV;
+	}
+	pr_debug("%s:%u: index %u:%u: port %lu blk_size %lu num_blocks %lu "
+		 "num_regions %u\n",
+		 __func__, __LINE__, repo->bus_index, repo->dev_index, port,
+		 blk_size, num_blocks, num_regions);
+
+	dev = kzalloc(sizeof(struct ps3_storage_device)+
+		      num_regions*sizeof(struct ps3_storage_region),
+		      GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->sbd.did = repo->did;
+	ps3_system_bus_device_init(&dev->sbd, match_id, &dev->dma_region,
+				   NULL);
+	dev->blk_size = blk_size;
+	dev->num_regions = num_regions;
+
+	error = ps3_repository_find_interrupt(repo,
+					      PS3_INTERRUPT_TYPE_EVENT_PORT,
+					      &dev->sbd.interrupt_id);
+	if (error) {
+		printk(KERN_ERR "%s:%u: find_interrupt failed %d\n", __func__,
+			__LINE__, error);
+		goto cleanup;
+	}
+
+	/* FIXME Do we really need this? I guess for kboot only? */
+	error = ps3stor_probe_notification(dev, dev_type);
+	if (error) {
+		printk(KERN_ERR "%s:%u: probe_notification failed %d\n",
+		       __func__, __LINE__, error);
+		goto cleanup;
+	}
+
+	for (i = 0; i < num_regions; i++) {
+		unsigned int id;
+		u64 start, size;
+
+		error = ps3_repository_read_stor_dev_region(repo->bus_index,
+							    repo->dev_index, i,
+							    &id, &start,
+							    &size);
+		if (error) {
+			printk(KERN_ERR
+			       "%s:%u: read_stor_dev_region failed %d\n",
+			       __func__, __LINE__, error);
+			goto cleanup;
+		}
+		pr_debug("%s:%u: region %u: id %u start %lu size %lu\n",
+			 __func__, __LINE__, i, id, start, size);
+
+		dev->regions[i].id = id;
+		dev->regions[i].start = start;
+		dev->regions[i].size = size;
+	}
+
+	error = ps3_system_bus_device_register(&dev->sbd, PS3_IOBUS_SB);
+	if (error) {
+		printk(KERN_ERR
+		       "%s:%u: ps3_system_bus_device_register failed %d\n",
+		       __func__, __LINE__, error);
+		goto cleanup;
+	}
+	return 0;
+
+cleanup:
+	kfree(dev);
+	return -ENODEV;
+}
+
+static int ps3stor_thread(void *data)
+{
+	struct ps3_repository_device *repo = data;
+	int error;
+	unsigned int n, ms = 250;
+
+	pr_debug("%s:%u: kthread started\n", __func__, __LINE__);
+
+	do {
+		try_to_freeze();
+
+//		pr_debug("%s:%u: Checking for new storage devices...\n",
+//			 __func__, __LINE__);
+		error = ps3_repository_read_bus_num_dev(repo->bus_index, &n);
+		if (error) {
+			printk(KERN_ERR "%s:%u: read_bus_num_dev failed %d\n",
+			       __func__, __LINE__, error);
+			break;
+		}
+
+		if (n > repo->dev_index) {
+			pr_debug("%s:%u: Found %u storage devices (%u new)\n",
+				 __func__, __LINE__, n, n - repo->dev_index);
+
+			while (repo->dev_index < n && !error) {
+				error = ps3stor_probe_dev(repo);
+				repo->dev_index++;
+			}
+
+			ms = 250;
+		}
+
+		msleep_interruptible(ms);
+		if (ms < 60000)
+			ms <<= 1;
+	} while (!kthread_should_stop());
+
+	pr_debug("%s:%u: kthread finished\n", __func__, __LINE__);
+
+	return 0;
+}
+
+static int __devinit ps3_register_storage_devices(void)
+{
+	int error;
+	static struct ps3_repository_device repo;
+	struct task_struct *task;
+
+	if (!firmware_has_feature(FW_FEATURE_PS3_LV1))
+		return -ENODEV;
+
+	error = ps3_repository_find_bus(PS3_BUS_TYPE_STORAGE, 0,
+					&repo.bus_index);
+	if (error) {
+		printk(KERN_ERR "%s: Cannot find storage bus (%d)\n", __func__,
+		       error);
+		return -ENODEV;
+	}
+	pr_debug("%s:%u: Storage bus has index %u\n", __func__, __LINE__,
+		 repo.bus_index);
+
+	error = ps3_repository_read_bus_id(repo.bus_index, &repo.did.bus_id);
+	if (error) {
+		printk(KERN_ERR "%s: read_bus_id failed %d\n", __func__,
+		       error);
+		return -ENODEV;
+	}
+
+	pr_debug("%s:%u: Storage bus has id %u\n", __func__, __LINE__,
+		 repo.did.bus_id);
+
+	task = kthread_run(ps3stor_thread, &repo, "ps3stor-probe");
+	if (IS_ERR(task)) {
+		error = PTR_ERR(task);
+		printk(KERN_ERR "%s: kthread_run failed %d\n", __func__,
+		       error);
+		return error;
+	}
+
+	return 0;
+}
+
 static int __devinit ps3_register_fb(void)
 {
 	int error;
@@ -556,6 +899,7 @@ static int __init ps3_register_known_dev
 	result = ps3_register_sys_manager();
 	result = ps3_register_sound();
 	result = ps3_register_gelic();
+	result = ps3_register_storage_devices();
 
 	pr_debug(" <- %s:%d\n", __func__, __LINE__);
 	return result;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium

