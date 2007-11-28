Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbXK1OgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbXK1OgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760258AbXK1Of0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:35:26 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62240 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757042AbXK1OfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:35:23 -0500
Message-Id: <20071128143438.302492000@pademelon.sonytel.be>
References: <20071128143142.580732000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 15:31:45 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 3/7] ps3: Use the HVs storage device notification mechanism properly
Content-Disposition: inline; filename=ps3-wip/ps3-storage-correct-notification-mechanism.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3: Use the HV's storage device notification mechanism properly

The hypervisor has a storage device notification mechanism to wait until a
storage device is ready. Unfortunately the storage device probing code used
this mechanism in an incorrect way, needing a polling loop and handling of
devices that are not yet ready.

This change corrects this by:
  - First waiting for the reception of an asynchronous notification that a new
    storage device became ready,
  - Then looking up the storage device in the device repository.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/device-init.c |  395 +++++++++++++++----------------
 arch/powerpc/platforms/ps3/platform.h    |    2 
 arch/powerpc/platforms/ps3/repository.c  |   29 --
 3 files changed, 194 insertions(+), 232 deletions(-)

--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -238,166 +238,6 @@ static int __init ps3_setup_vuart_device
 	return result;
 }
 
-static int ps3stor_wait_for_completion(u64 dev_id, u64 tag,
-				       unsigned int timeout)
-{
-	int result = -1;
-	unsigned int retries = 0;
-	u64 status;
-
-	for (retries = 0; retries < timeout; retries++) {
-		result = lv1_storage_check_async_status(dev_id, tag, &status);
-		if (!result)
-			break;
-
-		msleep(1);
-	}
-
-	if (result)
-		pr_debug("%s:%u: check_async_status: %s, status %lx\n",
-			 __func__, __LINE__, ps3_result(result), status);
-
-	return result;
-}
-
-/**
- * ps3_storage_wait_for_device - Wait for a storage device to become ready.
- * @repo: The repository device to wait for.
- *
- * Uses the hypervisor's storage device notification mechanism to wait until
- * a storage device is ready.  The device notification mechanism uses a
- * psuedo device (id = -1) to asynchronously notify the guest when storage
- * devices become ready.  The notification device has a block size of 512
- * bytes.
- */
-
-static int ps3_storage_wait_for_device(const struct ps3_repository_device *repo)
-{
-	int error = -ENODEV;
-	int result;
-	const u64 notification_dev_id = (u64)-1LL;
-	const unsigned int timeout = HZ;
-	u64 lpar;
-	u64 tag;
-	void *buf;
-	enum ps3_notify_type {
-		notify_device_ready = 0,
-		notify_region_probe = 1,
-		notify_region_update = 2,
-	};
-	struct {
-		u64 operation_code;	/* must be zero */
-		u64 event_mask;		/* OR of 1UL << enum ps3_notify_type */
-	} *notify_cmd;
-	struct {
-		u64 event_type;		/* enum ps3_notify_type */
-		u64 bus_id;
-		u64 dev_id;
-		u64 dev_type;
-		u64 dev_port;
-	} *notify_event;
-
-	pr_debug(" -> %s:%u: (%lu:%lu:%u)\n", __func__, __LINE__, repo->bus_id,
-		 repo->dev_id, repo->dev_type);
-
-	buf = kzalloc(512, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	lpar = ps3_mm_phys_to_lpar(__pa(buf));
-	notify_cmd = buf;
-	notify_event = buf;
-
-	result = lv1_open_device(repo->bus_id, notification_dev_id, 0);
-	if (result) {
-		printk(KERN_ERR "%s:%u: lv1_open_device %s\n", __func__,
-		       __LINE__, ps3_result(result));
-		goto fail_free;
-	}
-
-	/* Setup and write the request for device notification. */
-
-	notify_cmd->operation_code = 0; /* must be zero */
-	notify_cmd->event_mask = 1UL << notify_region_probe;
-
-	result = lv1_storage_write(notification_dev_id, 0, 0, 1, 0, lpar,
-				   &tag);
-	if (result) {
-		printk(KERN_ERR "%s:%u: write failed %s\n", __func__, __LINE__,
-		       ps3_result(result));
-		goto fail_close;
-	}
-
-	/* Wait for the write completion */
-
-	result = ps3stor_wait_for_completion(notification_dev_id, tag,
-					     timeout);
-	if (result) {
-		printk(KERN_ERR "%s:%u: write not completed %s\n", __func__,
-		       __LINE__, ps3_result(result));
-		goto fail_close;
-	}
-
-	/* Loop here processing the requested notification events. */
-
-	while (1) {
-		memset(notify_event, 0, sizeof(*notify_event));
-
-		result = lv1_storage_read(notification_dev_id, 0, 0, 1, 0,
-					  lpar, &tag);
-		if (result) {
-			printk(KERN_ERR "%s:%u: write failed %s\n", __func__,
-			       __LINE__, ps3_result(result));
-			break;
-		}
-
-		result = ps3stor_wait_for_completion(notification_dev_id, tag,
-						     timeout);
-		if (result) {
-			printk(KERN_ERR "%s:%u: read not completed %s\n",
-			       __func__, __LINE__, ps3_result(result));
-			break;
-		}
-
-		pr_debug("%s:%d: notify event (%u:%u:%u): event_type 0x%lx, "
-			 "port %lu\n", __func__, __LINE__, repo->bus_index,
-			 repo->dev_index, repo->dev_type,
-			 notify_event->event_type, notify_event->dev_port);
-
-		if (notify_event->event_type != notify_region_probe ||
-		    notify_event->bus_id != repo->bus_id) {
-			pr_debug("%s:%u: bad notify_event: event %lu, "
-				 "dev_id %lu, dev_type %lu\n",
-				 __func__, __LINE__, notify_event->event_type,
-				 notify_event->dev_id, notify_event->dev_type);
-			break;
-		}
-
-		if (notify_event->dev_id == repo->dev_id &&
-		    notify_event->dev_type == repo->dev_type) {
-			pr_debug("%s:%u: device ready (%u:%u:%u)\n", __func__,
-				 __LINE__, repo->bus_index, repo->dev_index,
-				 repo->dev_type);
-			error = 0;
-			break;
-		}
-
-		if (notify_event->dev_id == repo->dev_id &&
-		    notify_event->dev_type == PS3_DEV_TYPE_NOACCESS) {
-			pr_debug("%s:%u: no access: dev_id %lu\n", __func__,
-				 __LINE__, repo->dev_id);
-			break;
-		}
-	}
-
-fail_close:
-	lv1_close_device(repo->bus_id, notification_dev_id);
-fail_free:
-	kfree(buf);
-	pr_debug(" <- %s:%u\n", __func__, __LINE__);
-	return error;
-}
-
 static int ps3_setup_storage_dev(const struct ps3_repository_device *repo,
 				 enum ps3_match_id match_id)
 {
@@ -449,16 +289,6 @@ static int ps3_setup_storage_dev(const s
 		goto fail_find_interrupt;
 	}
 
-	/* FIXME: Arrange to only do this on a 'cold' boot */
-
-	result = ps3_storage_wait_for_device(repo);
-	if (result) {
-		printk(KERN_ERR "%s:%u: storage_notification failed %d\n",
-		       __func__, __LINE__, result);
-		result = -ENODEV;
-		goto fail_probe_notification;
-	}
-
 	for (i = 0; i < num_regions; i++) {
 		unsigned int id;
 		u64 start, size;
@@ -494,7 +324,6 @@ static int ps3_setup_storage_dev(const s
 
 fail_device_register:
 fail_read_region:
-fail_probe_notification:
 fail_find_interrupt:
 	kfree(p);
 fail_malloc:
@@ -659,56 +488,219 @@ static int ps3_register_repository_devic
 	return result;
 }
 
+
+#define PS3_NOTIFICATION_DEV_ID		ULONG_MAX
+#define PS3_NOTIFICATION_INTERRUPT_ID	0
+
+struct ps3_notification_device {
+	struct ps3_system_bus_device sbd;
+	spinlock_t lock;
+	u64 tag;
+	u64 lv1_status;
+	struct completion done;
+};
+
+enum ps3_notify_type {
+	notify_device_ready = 0,
+	notify_region_probe = 1,
+	notify_region_update = 2,
+};
+
+struct ps3_notify_cmd {
+	u64 operation_code;		/* must be zero */
+	u64 event_mask;			/* OR of 1UL << enum ps3_notify_type */
+};
+
+struct ps3_notify_event {
+	u64 event_type;			/* enum ps3_notify_type */
+	u64 bus_id;
+	u64 dev_id;
+	u64 dev_type;
+	u64 dev_port;
+};
+
+static irqreturn_t ps3_notification_interrupt(int irq, void *data)
+{
+	struct ps3_notification_device *dev = data;
+	int res;
+	u64 tag, status;
+
+	spin_lock(&dev->lock);
+	res = lv1_storage_get_async_status(PS3_NOTIFICATION_DEV_ID, &tag,
+					   &status);
+	if (tag != dev->tag)
+		pr_err("%s:%u: tag mismatch, got %lx, expected %lx\n",
+		       __func__, __LINE__, tag, dev->tag);
+
+	if (res) {
+		pr_err("%s:%u: res %d status 0x%lx\n", __func__, __LINE__, res,
+		       status);
+	} else {
+		pr_debug("%s:%u: completed, status 0x%lx\n", __func__,
+			 __LINE__, status);
+		dev->lv1_status = status;
+		complete(&dev->done);
+	}
+	spin_unlock(&dev->lock);
+	return IRQ_HANDLED;
+}
+
+static int ps3_notification_read_write(struct ps3_notification_device *dev,
+				       u64 lpar, int write)
+{
+	const char *op = write ? "write" : "read";
+	unsigned long flags;
+	int res;
+
+	init_completion(&dev->done);
+	spin_lock_irqsave(&dev->lock, flags);
+	res = write ? lv1_storage_write(dev->sbd.dev_id, 0, 0, 1, 0, lpar,
+					&dev->tag)
+		    : lv1_storage_read(dev->sbd.dev_id, 0, 0, 1, 0, lpar,
+				       &dev->tag);
+	spin_unlock_irqrestore(&dev->lock, flags);
+	if (res) {
+		pr_err("%s:%u: %s failed %d\n", __func__, __LINE__, op, res);
+		return -EPERM;
+	}
+	pr_debug("%s:%u: notification %s issued\n", __func__, __LINE__, op);
+
+	res = wait_for_completion_interruptible(&dev->done);
+	if (res) {
+		pr_debug("%s:%u: interrupted %s\n", __func__, __LINE__, op);
+		return res;
+	}
+
+	if (dev->lv1_status) {
+		pr_err("%s:%u: %s not completed, status 0x%lx\n", __func__,
+		       __LINE__, op, dev->lv1_status);
+		return -EIO;
+	}
+	pr_debug("%s:%u: notification %s completed\n", __func__, __LINE__, op);
+
+	return 0;
+}
+
+
 /**
  * ps3_probe_thread - Background repository probing at system startup.
  *
  * This implementation only supports background probing on a single bus.
+ * It uses the hypervisor's storage device notification mechanism to wait until
+ * a storage device is ready.  The device notification mechanism uses a
+ * pseudo device to asynchronously notify the guest when storage devices become
+ * ready.  The notification device has a block size of 512 bytes.
  */
 
 static int ps3_probe_thread(void *data)
 {
-	struct ps3_repository_device *repo = data;
-	int result;
-	unsigned int ms = 250;
+	struct ps3_notification_device dev;
+	struct ps3_repository_device repo;
+	int res;
+	unsigned int irq;
+	u64 lpar;
+	void *buf;
+	struct ps3_notify_cmd *notify_cmd;
+	struct ps3_notify_event *notify_event;
 
 	pr_debug(" -> %s:%u: kthread started\n", __func__, __LINE__);
 
-	do {
-		try_to_freeze();
+	buf = kzalloc(512, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	lpar = ps3_mm_phys_to_lpar(__pa(buf));
+	notify_cmd = buf;
+	notify_event = buf;
+
+	/* dummy system bus device */
+	dev.sbd.bus_id = (u64)data;
+	dev.sbd.dev_id = PS3_NOTIFICATION_DEV_ID;
+	dev.sbd.interrupt_id = PS3_NOTIFICATION_INTERRUPT_ID;
+
+	res = lv1_open_device(dev.sbd.bus_id, dev.sbd.dev_id, 0);
+	if (res) {
+		pr_err("%s:%u: lv1_open_device %s\n", __func__, __LINE__,
+		       ps3_result(res));
+		goto fail_free;
+	}
+
+	res = ps3_sb_event_receive_port_setup(&dev.sbd, PS3_BINDING_CPU_ANY,
+					      &irq);
+	if (res) {
+		pr_err("%s:%u: ps3_sb_event_receive_port_setup failed %d\n",
+		       __func__, __LINE__, res);
+	       goto fail_close_device;
+	}
+
+	spin_lock_init(&dev.lock);
+
+	res = request_irq(irq, ps3_notification_interrupt, IRQF_DISABLED,
+			  "ps3_notification", &dev);
+	if (res) {
+		pr_err("%s:%u: request_irq failed %d\n", __func__, __LINE__,
+		       res);
+		goto fail_sb_event_receive_port_destroy;
+	}
 
-		pr_debug("%s:%u: probing...\n", __func__, __LINE__);
+	/* Setup and write the request for device notification. */
+	notify_cmd->operation_code = 0; /* must be zero */
+	notify_cmd->event_mask = 1UL << notify_region_probe;
 
-		do {
-			result = ps3_repository_find_device(repo);
+	res = ps3_notification_read_write(&dev, lpar, 1);
+	if (res)
+		goto fail_free_irq;
 
-			if (result == -ENODEV)
-				pr_debug("%s:%u: nothing new\n", __func__,
-					__LINE__);
-			else if (result)
-				pr_debug("%s:%u: find device error.\n",
-					__func__, __LINE__);
-			else {
-				pr_debug("%s:%u: found device (%u:%u:%u)\n",
-					 __func__, __LINE__, repo->bus_index,
-					 repo->dev_index, repo->dev_type);
-				ps3_register_repository_device(repo);
-				ps3_repository_bump_device(repo);
-				ms = 250;
-			}
-		} while (!result);
+	/* Loop here processing the requested notification events. */
+	do {
+		try_to_freeze();
 
-		pr_debug("%s:%u: ms %u\n", __func__, __LINE__, ms);
+		memset(notify_event, 0, sizeof(*notify_event));
 
-		if ( ms > 60000)
+		res = ps3_notification_read_write(&dev, lpar, 0);
+		if (res)
 			break;
 
-		msleep_interruptible(ms);
+		pr_debug("%s:%u: notify event type 0x%lx bus id %lu dev id %lu"
+			 " type %lu port %lu\n", __func__, __LINE__,
+			 notify_event->event_type, notify_event->bus_id,
+			 notify_event->dev_id, notify_event->dev_type,
+			 notify_event->dev_port);
 
-		/* An exponential backoff. */
-		ms <<= 1;
+		if (notify_event->event_type != notify_region_probe ||
+		    notify_event->bus_id != dev.sbd.bus_id) {
+			pr_warning("%s:%u: bad notify_event: event %lu, "
+				   "dev_id %lu, dev_type %lu\n",
+				   __func__, __LINE__, notify_event->event_type,
+				   notify_event->dev_id,
+				   notify_event->dev_type);
+			continue;
+		}
+
+		res = ps3_repository_find_device_by_id(&repo, dev.sbd.bus_id,
+						       notify_event->dev_id);
+		if (res) {
+			pr_warning("%s:%u: device %lu:%lu not found\n",
+				   __func__, __LINE__, dev.sbd.bus_id,
+				   notify_event->dev_id);
+			continue;
+		}
+
+		pr_debug("%s:%u: device %lu:%lu found\n", __func__, __LINE__,
+			 dev.sbd.bus_id, notify_event->dev_id);
+		ps3_register_repository_device(&repo);
 
 	} while (!kthread_should_stop());
 
+fail_free_irq:
+	free_irq(irq, &dev);
+fail_sb_event_receive_port_destroy:
+	ps3_sb_event_receive_port_destroy(&dev.sbd, irq);
+fail_close_device:
+	lv1_close_device(dev.sbd.bus_id, dev.sbd.dev_id);
+fail_free:
+	kfree(buf);
+
 	pr_debug(" <- %s:%u: kthread finished\n", __func__, __LINE__);
 
 	return 0;
@@ -723,7 +715,7 @@ static int __init ps3_start_probe_thread
 {
 	int result;
 	struct task_struct *task;
-	static struct ps3_repository_device repo; /* must be static */
+	struct ps3_repository_device repo;
 
 	pr_debug(" -> %s:%d\n", __func__, __LINE__);
 
@@ -746,7 +738,8 @@ static int __init ps3_start_probe_thread
 		return -ENODEV;
 	}
 
-	task = kthread_run(ps3_probe_thread, &repo, "ps3-probe-%u", bus_type);
+	task = kthread_run(ps3_probe_thread, (void *)repo.bus_id,
+			   "ps3-probe-%u", bus_type);
 
 	if (IS_ERR(task)) {
 		result = PTR_ERR(task);
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -89,8 +89,6 @@ enum ps3_dev_type {
 	PS3_DEV_TYPE_STOR_ROM = TYPE_ROM,	/* 5 */
 	PS3_DEV_TYPE_SB_GPIO = 6,
 	PS3_DEV_TYPE_STOR_FLASH = TYPE_RBC,	/* 14 */
-	PS3_DEV_TYPE_STOR_DUMMY = 32,
-	PS3_DEV_TYPE_NOACCESS = 255,
 };
 
 int ps3_repository_read_bus_str(unsigned int bus_index, const char *bus_str,
--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -344,35 +344,6 @@ int ps3_repository_find_device(struct ps
 		return result;
 	}
 
-	if (tmp.bus_type == PS3_BUS_TYPE_STORAGE) {
-		/*
-		 * A storage device may show up in the repository before the
-		 * hypervisor has finished probing its type and regions
-		 */
-		unsigned int num_regions;
-
-		if (tmp.dev_type == PS3_DEV_TYPE_STOR_DUMMY) {
-			pr_debug("%s:%u storage device not ready\n", __func__,
-				 __LINE__);
-			return -ENODEV;
-		}
-
-		result = ps3_repository_read_stor_dev_num_regions(tmp.bus_index,
-								  tmp.dev_index,
-								  &num_regions);
-		if (result) {
-			pr_debug("%s:%d read_stor_dev_num_regions failed\n",
-				 __func__, __LINE__);
-			return result;
-		}
-
-		if (!num_regions) {
-			pr_debug("%s:%u storage device has no regions yet\n",
-				 __func__, __LINE__);
-			return -ENODEV;
-		}
-	}
-
 	result = ps3_repository_read_dev_id(tmp.bus_index, tmp.dev_index,
 		&tmp.dev_id);
 

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

