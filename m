Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbXCAFgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbXCAFgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 00:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbXCAFgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 00:36:35 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:8503 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbXCAFge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 00:36:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAKz05UVKhRO4UGdsb2JhbACHTYdPAQEqlgkBAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Date: Thu, 1 Mar 2007 00:36:26 -0500
User-Agent: KMail/1.9.3
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kristian =?iso-8859-15?q?Gr=F8nfeldt_S=F8rensen?= 
	<kriller@vkr.dk>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <1172601905.5428.28.camel@localhost.localdomain> <1172622441.4587.14.camel@localhost.localdomain> <200702281345.15098.rjw@sisk.pl>
In-Reply-To: <200702281345.15098.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703010036.28166.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 February 2007 07:45, Rafael J. Wysocki wrote:
> 
> > This gives:
> > 
> > (gdb) l *evdev_disconnect+0xb1
> > 0xa81 is in evdev_disconnect (include/asm/processor.h:716).
> > 711        However we don't do prefetches for pre XP Athlons currently
> > 712        That should be fixed. */
> > 713     #define ARCH_HAS_PREFETCH
> > 714     static inline void prefetch(const void *x)
> > 715     {
> > 716             alternative_input(ASM_NOP4,
> > 717                               "prefetchnta (%1)",
> > 718                               X86_FEATURE_XMM,
> > 719                               "r" (x));
> > 720     }
> 
> Hm, interesting.  Looks like a pointer points to nowhere in
> input_unregister_device(), but I don't know which one.  This may be
> an evdev problem ...
> 

Please try the patch below.

-- 
Dmitry

Input: use krefs for refcounting in input handlers

This should fix problems whith accessing memory already freed by
another thread.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/evdev.c    |   62 ++++++++++-------
 drivers/input/joydev.c   |   51 +++++++++-----
 drivers/input/mousedev.c |  166 +++++++++++++++++++++++++++++++++--------------
 drivers/input/tsdev.c    |   65 +++++++++++-------
 4 files changed, 227 insertions(+), 117 deletions(-)

Index: work/drivers/input/evdev.c
===================================================================
--- work.orig/drivers/input/evdev.c
+++ work/drivers/input/evdev.c
@@ -29,8 +29,10 @@ struct evdev {
 	char name[16];
 	struct input_handle handle;
 	wait_queue_head_t wait;
-	struct evdev_list *grab;
+	struct kref kref;
 	struct list_head list;
+
+	struct evdev_list *grab;
 };
 
 struct evdev_list {
@@ -94,53 +96,62 @@ static int evdev_flush(struct file *file
 	return input_flush_device(&list->evdev->handle, file);
 }
 
-static void evdev_free(struct evdev *evdev)
+static void evdev_free(struct kref *kref)
 {
+	struct evdev *evdev = container_of(kref, struct evdev, kref);
+
 	evdev_table[evdev->minor] = NULL;
 	kfree(evdev);
 }
 
-static int evdev_release(struct inode * inode, struct file * file)
+static int evdev_release(struct inode *inode, struct file *file)
 {
 	struct evdev_list *list = file->private_data;
+	struct evdev *evdev = list->evdev;
 
-	if (list->evdev->grab == list) {
-		input_release_device(&list->evdev->handle);
-		list->evdev->grab = NULL;
+	if (evdev->grab == list) {
+		input_release_device(&evdev->handle);
+		evdev->grab = NULL;
 	}
 
 	evdev_fasync(-1, file, 0);
+
 	list_del(&list->node);
+	kfree(list);
 
-	if (!--list->evdev->open) {
-		if (list->evdev->exist)
-			input_close_device(&list->evdev->handle);
-		else
-			evdev_free(list->evdev);
-	}
+	if (!--evdev->open && evdev->exist)
+		input_close_device(&evdev->handle);
+
+	kref_put(&evdev->kref, evdev_free);
 
-	kfree(list);
 	return 0;
 }
 
-static int evdev_open(struct inode * inode, struct file * file)
+static int evdev_open(struct inode *inode, struct file *file)
 {
 	struct evdev_list *list;
+	struct evdev *evdev;
 	int i = iminor(inode) - EVDEV_MINOR_BASE;
 
-	if (i >= EVDEV_MINORS || !evdev_table[i] || !evdev_table[i]->exist)
+	if (i >= EVDEV_MINORS)
+		return -ENODEV;
+
+	evdev = evdev_table[i];
+	if (!evdev || !evdev->exist)
 		return -ENODEV;
 
-	if (!(list = kzalloc(sizeof(struct evdev_list), GFP_KERNEL)))
+	list = kzalloc(sizeof(struct evdev_list), GFP_KERNEL);
+	if (!list)
 		return -ENOMEM;
 
-	list->evdev = evdev_table[i];
-	list_add_tail(&list->node, &evdev_table[i]->list);
+	kref_get(&evdev->kref);
+
+	list->evdev = evdev;
+	list_add_tail(&list->node, &evdev->list);
 	file->private_data = list;
 
-	if (!list->evdev->open++)
-		if (list->evdev->exist)
-			input_open_device(&list->evdev->handle);
+	if (!evdev->open++ && evdev->exist)
+		input_open_device(&evdev->handle);
 
 	return 0;
 }
@@ -629,9 +640,11 @@ static struct input_handle *evdev_connec
 		return NULL;
 	}
 
-	if (!(evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL)))
+	evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
+	if (!evdev)
 		return NULL;
 
+	kref_init(&evdev->kref);
 	INIT_LIST_HEAD(&evdev->list);
 	init_waitqueue_head(&evdev->wait);
 
@@ -672,8 +685,9 @@ static void evdev_disconnect(struct inpu
 		wake_up_interruptible(&evdev->wait);
 		list_for_each_entry(list, &evdev->list, node)
 			kill_fasync(&list->fasync, SIGIO, POLL_HUP);
-	} else
-		evdev_free(evdev);
+	}
+
+	kref_put(&evdev->kref, evdev_free);
 }
 
 static const struct input_device_id evdev_ids[] = {
Index: work/drivers/input/joydev.c
===================================================================
--- work.orig/drivers/input/joydev.c
+++ work/drivers/input/joydev.c
@@ -43,7 +43,9 @@ struct joydev {
 	char name[16];
 	struct input_handle handle;
 	wait_queue_head_t wait;
+	struct kref kref;
 	struct list_head list;
+
 	struct js_corr corr[ABS_MAX + 1];
 	struct JS_DATA_SAVE_TYPE glue;
 	int nabs;
@@ -139,8 +141,10 @@ static int joydev_fasync(int fd, struct 
 	return retval < 0 ? retval : 0;
 }
 
-static void joydev_free(struct joydev *joydev)
+static void joydev_free(struct kref *kref)
 {
+	struct joydev *joydev = container_of(kref, struct joydev, kref);
+
 	joydev_table[joydev->minor] = NULL;
 	kfree(joydev);
 }
@@ -148,40 +152,46 @@ static void joydev_free(struct joydev *j
 static int joydev_release(struct inode * inode, struct file * file)
 {
 	struct joydev_list *list = file->private_data;
+	struct joydev *joydev = list->joydev;
 
 	joydev_fasync(-1, file, 0);
 
 	list_del(&list->node);
+	kfree(list);
 
-	if (!--list->joydev->open) {
-		if (list->joydev->exist)
-			input_close_device(&list->joydev->handle);
-		else
-			joydev_free(list->joydev);
-	}
+	if (!--joydev->open && joydev->exist)
+		input_close_device(&list->joydev->handle);
+
+	kref_put(&joydev->kref, joydev_free);
 
-	kfree(list);
 	return 0;
 }
 
 static int joydev_open(struct inode *inode, struct file *file)
 {
 	struct joydev_list *list;
+	struct joydev *joydev;
 	int i = iminor(inode) - JOYDEV_MINOR_BASE;
 
-	if (i >= JOYDEV_MINORS || !joydev_table[i])
+	if (i >= JOYDEV_MINORS)
 		return -ENODEV;
 
-	if (!(list = kzalloc(sizeof(struct joydev_list), GFP_KERNEL)))
+	joydev = joydev_table[i];
+	if (!joydev || !joydev->exist)
+		return -ENODEV;
+
+	list = kzalloc(sizeof(struct joydev_list), GFP_KERNEL);
+	if (!list)
 		return -ENOMEM;
 
-	list->joydev = joydev_table[i];
-	list_add_tail(&list->node, &joydev_table[i]->list);
+	kref_get(&joydev->kref);
+
+	list->joydev = joydev;
+	list_add_tail(&list->node, &joydev->list);
 	file->private_data = list;
 
-	if (!list->joydev->open++)
-		if (list->joydev->exist)
-			input_open_device(&list->joydev->handle);
+	if (!joydev->open++ && joydev->exist)
+		input_open_device(&list->joydev->handle);
 
 	return 0;
 }
@@ -198,7 +208,7 @@ static ssize_t joydev_read(struct file *
 	struct input_dev *input = joydev->handle.dev;
 	int retval = 0;
 
-	if (!list->joydev->exist)
+	if (!joydev->exist)
 		return -ENODEV;
 
 	if (count < sizeof(struct js_event))
@@ -478,9 +488,11 @@ static struct input_handle *joydev_conne
 		return NULL;
 	}
 
-	if (!(joydev = kzalloc(sizeof(struct joydev), GFP_KERNEL)))
+	joydev = kzalloc(sizeof(struct joydev), GFP_KERNEL);
+	if (!joydev)
 		return NULL;
 
+	kref_init(&joydev->kref);
 	INIT_LIST_HEAD(&joydev->list);
 	init_waitqueue_head(&joydev->wait);
 
@@ -559,8 +571,9 @@ static void joydev_disconnect(struct inp
 		wake_up_interruptible(&joydev->wait);
 		list_for_each_entry(list, &joydev->list, node)
 			kill_fasync(&list->fasync, SIGIO, POLL_HUP);
-	} else
-		joydev_free(joydev);
+	}
+
+	kref_put(&joydev->kref, joydev_free);
 }
 
 static const struct input_device_id joydev_blacklist[] = {
Index: work/drivers/input/mousedev.c
===================================================================
--- work.orig/drivers/input/mousedev.c
+++ work/drivers/input/mousedev.c
@@ -62,9 +62,13 @@ struct mousedev {
 	int open;
 	int minor;
 	char name[16];
+	struct input_handle handle;
 	wait_queue_head_t wait;
+	struct kref kref;
 	struct list_head list;
-	struct input_handle handle;
+
+	struct list_head mixdev_node;
+	int mixdev_open;
 
 	struct mousedev_hw_data packet;
 	unsigned int pkt_count;
@@ -111,6 +115,8 @@ static struct input_handler mousedev_han
 
 static struct mousedev *mousedev_table[MOUSEDEV_MINORS];
 static struct mousedev mousedev_mix;
+static LIST_HEAD(mousedev_mix_list);
+static DEFINE_MUTEX(mousedev_mix_mutex);
 
 #define fx(i)  (mousedev->old_x[(mousedev->pkt_count - (i)) & 03])
 #define fy(i)  (mousedev->old_y[(mousedev->pkt_count - (i)) & 03])
@@ -358,55 +364,112 @@ static int mousedev_fasync(int fd, struc
 	return retval < 0 ? retval : 0;
 }
 
-static void mousedev_free(struct mousedev *mousedev)
+static void mousedev_free(struct kref *kref)
 {
+	struct mousedev *mousedev = container_of(kref, struct mousedev, kref);
+
 	mousedev_table[mousedev->minor] = NULL;
 	kfree(mousedev);
 }
 
-static void mixdev_release(void)
+static int mixdev_add_device(struct mousedev *mousedev)
+{
+	int retval = 0;
+
+	mutex_lock(&mousedev_mix_mutex);
+
+	if (mousedev_mix.open) {
+		if (!mousedev->open && mousedev->exist) {
+			retval = input_open_device(&mousedev->handle);
+			if (retval)
+				goto out;
+
+			mousedev->open++;
+		}
+		mousedev->mixdev_open++;
+	}
+
+	list_add_tail(&mousedev->mixdev_node, &mousedev_mix_list);
+
+ out:
+	mutex_unlock(&mousedev_mix_mutex);
+	return retval;
+}
+
+static void mixdev_remove_device(struct mousedev *mousedev)
 {
-	struct input_handle *handle;
+	mutex_lock(&mousedev_mix_mutex);
 
-	list_for_each_entry(handle, &mousedev_handler.h_list, h_node) {
-		struct mousedev *mousedev = handle->private;
+	if (!--mousedev->mixdev_open)
+		if (!--mousedev->open && mousedev->exist)
+			input_close_device(&mousedev->handle);
 
-		if (!mousedev->open) {
-			if (mousedev->exist)
+	list_del_init(&mousedev->mixdev_node);
+
+	mutex_unlock(&mousedev_mix_mutex);
+}
+
+static void mixdev_open_devices(void)
+{
+	struct mousedev *mousedev;
+
+	mutex_lock(&mousedev_mix_mutex);
+
+	list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
+		if (!mousedev->mixdev_open)
+			if (!mousedev->open && mousedev->exist) {
+				if (input_open_device(&mousedev->handle))
+					continue;
+				mousedev->open++;
+			}
+		mousedev->mixdev_open++;
+	}
+
+	mutex_unlock(&mousedev_mix_mutex);
+}
+
+static void mixdev_close_devices(void)
+{
+	struct mousedev *mousedev, *next;
+
+	mutex_lock(&mousedev_mix_mutex);
+
+	list_for_each_entry_safe(mousedev, next, &mousedev_mix_list, mixdev_node) {
+		if (mousedev->mixdev_open) {
+			if (!--mousedev->open && mousedev->exist)
 				input_close_device(&mousedev->handle);
-			else
-				mousedev_free(mousedev);
+			mousedev->mixdev_open--;
 		}
 	}
+
+	mutex_unlock(&mousedev_mix_mutex);
 }
 
-static int mousedev_release(struct inode * inode, struct file * file)
+static int mousedev_release(struct inode *inode, struct file *file)
 {
 	struct mousedev_list *list = file->private_data;
+	struct mousedev *mousedev = list->mousedev;
 
 	mousedev_fasync(-1, file, 0);
 
 	list_del(&list->node);
+	kfree(list);
 
-	if (!--list->mousedev->open) {
-		if (list->mousedev->minor == MOUSEDEV_MIX)
-			mixdev_release();
-		else if (!mousedev_mix.open) {
-			if (list->mousedev->exist)
-				input_close_device(&list->mousedev->handle);
-			else
-				mousedev_free(list->mousedev);
-		}
+	if (!--mousedev->open) {
+		if (mousedev->minor == MOUSEDEV_MIX)
+			mixdev_close_devices();
+		else if (mousedev->exist)
+			input_close_device(&mousedev->handle);
 	}
 
-	kfree(list);
+	kref_put(&mousedev->kref, mousedev_free);
+
 	return 0;
 }
 
-static int mousedev_open(struct inode * inode, struct file * file)
+static int mousedev_open(struct inode *inode, struct file *file)
 {
 	struct mousedev_list *list;
-	struct input_handle *handle;
 	struct mousedev *mousedev;
 	int i;
 
@@ -417,29 +480,31 @@ static int mousedev_open(struct inode * 
 #endif
 		i = iminor(inode) - MOUSEDEV_MINOR_BASE;
 
-	if (i >= MOUSEDEV_MINORS || !mousedev_table[i])
+	if (i >= MOUSEDEV_MINORS)
+		return -ENODEV;
+
+	mousedev =  mousedev_table[i];
+	if (!mousedev || !mousedev->exist)
 		return -ENODEV;
 
-	if (!(list = kzalloc(sizeof(struct mousedev_list), GFP_KERNEL)))
+	list = kzalloc(sizeof(struct mousedev_list), GFP_KERNEL);
+	if (!list)
 		return -ENOMEM;
 
+	kref_get(&mousedev->kref);
+
 	spin_lock_init(&list->packet_lock);
 	list->pos_x = xres / 2;
 	list->pos_y = yres / 2;
-	list->mousedev = mousedev_table[i];
-	list_add_tail(&list->node, &mousedev_table[i]->list);
+	list->mousedev = mousedev;
+	list_add_tail(&list->node, &mousedev->list);
 	file->private_data = list;
 
-	if (!list->mousedev->open++) {
-		if (list->mousedev->minor == MOUSEDEV_MIX) {
-			list_for_each_entry(handle, &mousedev_handler.h_list, h_node) {
-				mousedev = handle->private;
-				if (!mousedev->open && mousedev->exist)
-					input_open_device(handle);
-			}
-		} else
-			if (!mousedev_mix.open && list->mousedev->exist)
-				input_open_device(&list->mousedev->handle);
+	if (!mousedev->open++) {
+		if (mousedev->minor == MOUSEDEV_MIX)
+			mixdev_open_devices();
+		else if (mousedev->exist)
+			input_open_device(&mousedev->handle);
 	}
 
 	return 0;
@@ -629,7 +694,7 @@ static struct input_handle *mousedev_con
 {
 	struct mousedev *mousedev;
 	struct class_device *cdev;
-	int minor = 0;
+	int minor;
 
 	for (minor = 0; minor < MOUSEDEV_MINORS && mousedev_table[minor]; minor++);
 	if (minor == MOUSEDEV_MINORS) {
@@ -637,10 +702,13 @@ static struct input_handle *mousedev_con
 		return NULL;
 	}
 
-	if (!(mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL)))
+	mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL);
+	if (!mousedev)
 		return NULL;
 
+	kref_init(&mousedev->kref);
 	INIT_LIST_HEAD(&mousedev->list);
+	INIT_LIST_HEAD(&mousedev->mixdev_node);
 	init_waitqueue_head(&mousedev->wait);
 
 	mousedev->minor = minor;
@@ -651,8 +719,7 @@ static struct input_handle *mousedev_con
 	mousedev->handle.private = mousedev;
 	sprintf(mousedev->name, "mouse%d", minor);
 
-	if (mousedev_mix.open)
-		input_open_device(&mousedev->handle);
+	mixdev_add_device(mousedev);
 
 	mousedev_table[minor] = mousedev;
 
@@ -675,18 +742,18 @@ static void mousedev_disconnect(struct i
 	sysfs_remove_link(&input_class.subsys.kset.kobj, mousedev->name);
 	class_device_destroy(&input_class,
 			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + mousedev->minor));
-	mousedev->exist = 0;
 
+	mixdev_remove_device(mousedev);
+
+	mousedev->exist = 0;
 	if (mousedev->open) {
 		input_close_device(handle);
 		wake_up_interruptible(&mousedev->wait);
 		list_for_each_entry(list, &mousedev->list, node)
 			kill_fasync(&list->fasync, SIGIO, POLL_HUP);
-	} else {
-		if (mousedev_mix.open)
-			input_close_device(handle);
-		mousedev_free(mousedev);
 	}
+
+	kref_put(&mousedev->kref, mousedev_free);
 }
 
 static const struct input_device_id mousedev_ids[] = {
@@ -714,7 +781,7 @@ static const struct input_device_id mous
 		.absbit = { BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_PRESSURE) | BIT(ABS_TOOL_WIDTH) },
 	},	/* A touchpad */
 
-	{ }, 	/* Terminating entry */
+	{ },	/* Terminating entry */
 };
 
 MODULE_DEVICE_TABLE(input, mousedev_ids);
@@ -745,13 +812,14 @@ static int __init mousedev_init(void)
 	if (error)
 		return error;
 
-	memset(&mousedev_mix, 0, sizeof(struct mousedev));
+	kref_init(&mousedev_mix.kref);
 	INIT_LIST_HEAD(&mousedev_mix.list);
 	init_waitqueue_head(&mousedev_mix.wait);
-	mousedev_table[MOUSEDEV_MIX] = &mousedev_mix;
 	mousedev_mix.exist = 1;
 	mousedev_mix.minor = MOUSEDEV_MIX;
 
+	mousedev_table[MOUSEDEV_MIX] = &mousedev_mix;
+
 	cdev = class_device_create(&input_class, NULL,
 			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + MOUSEDEV_MIX), NULL, "mice");
 	if (IS_ERR(cdev)) {
Index: work/drivers/input/tsdev.c
===================================================================
--- work.orig/drivers/input/tsdev.c
+++ work/drivers/input/tsdev.c
@@ -110,9 +110,11 @@ struct tsdev {
 	int open;
 	int minor;
 	char name[8];
+	struct input_handle handle;
 	wait_queue_head_t wait;
+	struct kref kref;
 	struct list_head list;
-	struct input_handle handle;
+
 	int x, y, pressure;
 	struct ts_calibration cal;
 };
@@ -150,6 +152,7 @@ static int tsdev_open(struct inode *inod
 {
 	int i = iminor(inode) - TSDEV_MINOR_BASE;
 	struct tsdev_list *list;
+	struct tsdev *tsdev;
 
 	printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is scheduled "
 		"for removal.\nSee Documentation/feature-removal-schedule.txt "
@@ -158,24 +161,31 @@ static int tsdev_open(struct inode *inod
 	if (i >= TSDEV_MINORS || !tsdev_table[i & TSDEV_MINOR_MASK])
 		return -ENODEV;
 
-	if (!(list = kzalloc(sizeof(struct tsdev_list), GFP_KERNEL)))
+	tsdev = tsdev_table[i & TSDEV_MINOR_MASK];
+	if (!tsdev || !tsdev->exist)
+		return -ENODEV;
+
+	list = kzalloc(sizeof(struct tsdev_list), GFP_KERNEL);
+	if (!list)
 		return -ENOMEM;
 
-	list->raw = (i >= TSDEV_MINORS/2) ? 1 : 0;
+	kref_get(&tsdev->kref);
 
-	i &= TSDEV_MINOR_MASK;
-	list->tsdev = tsdev_table[i];
-	list_add_tail(&list->node, &tsdev_table[i]->list);
+	list->tsdev = tsdev;
+	list->raw = (i >= TSDEV_MINORS / 2);
+	list_add_tail(&list->node, &tsdev->list);
 	file->private_data = list;
 
-	if (!list->tsdev->open++)
-		if (list->tsdev->exist)
-			input_open_device(&list->tsdev->handle);
+	if (!tsdev->open++ && tsdev->exist)
+		input_open_device(&list->tsdev->handle);
+
 	return 0;
 }
 
-static void tsdev_free(struct tsdev *tsdev)
+static void tsdev_free(struct kref *kref)
 {
+	struct tsdev *tsdev = container_of(kref, struct tsdev, kref);
+
 	tsdev_table[tsdev->minor] = NULL;
 	kfree(tsdev);
 }
@@ -183,17 +193,18 @@ static void tsdev_free(struct tsdev *tsd
 static int tsdev_release(struct inode *inode, struct file *file)
 {
 	struct tsdev_list *list = file->private_data;
+	struct tsdev *tsdev = list->tsdev;
 
 	tsdev_fasync(-1, file, 0);
-	list_del(&list->node);
 
-	if (!--list->tsdev->open) {
-		if (list->tsdev->exist)
-			input_close_device(&list->tsdev->handle);
-		else
-			tsdev_free(list->tsdev);
-	}
+	list_del(&list->node);
 	kfree(list);
+
+	if (!--tsdev->open && tsdev->exist)
+		input_close_device(&tsdev->handle);
+
+	kref_put(&tsdev->kref, tsdev_free);
+
 	return 0;
 }
 
@@ -201,22 +212,23 @@ static ssize_t tsdev_read(struct file *f
 			  loff_t * ppos)
 {
 	struct tsdev_list *list = file->private_data;
+	struct tsdev *tsdev = list->tsdev;
 	int retval = 0;
 
-	if (list->head == list->tail && list->tsdev->exist && (file->f_flags & O_NONBLOCK))
+	if (list->head == list->tail && tsdev->exist && (file->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
-	retval = wait_event_interruptible(list->tsdev->wait,
-			list->head != list->tail || !list->tsdev->exist);
+	retval = wait_event_interruptible(tsdev->wait,
+			list->head != list->tail || !tsdev->exist);
 
 	if (retval)
 		return retval;
 
-	if (!list->tsdev->exist)
+	if (!tsdev->exist)
 		return -ENODEV;
 
 	while (list->head != list->tail &&
-	       retval + sizeof (struct ts_event) <= count) {
+	       retval + sizeof(struct ts_event) <= count) {
 		if (copy_to_user (buffer + retval, list->event + list->tail,
 				  sizeof (struct ts_event)))
 			return -EFAULT;
@@ -385,9 +397,11 @@ static struct input_handle *tsdev_connec
 		return NULL;
 	}
 
-	if (!(tsdev = kzalloc(sizeof(struct tsdev), GFP_KERNEL)))
+	tsdev = kzalloc(sizeof(struct tsdev), GFP_KERNEL);
+	if (!tsdev)
 		return NULL;
 
+	kref_init(&tsdev->kref);
 	INIT_LIST_HEAD(&tsdev->list);
 	init_waitqueue_head(&tsdev->wait);
 
@@ -441,8 +455,9 @@ static void tsdev_disconnect(struct inpu
 		wake_up_interruptible(&tsdev->wait);
 		list_for_each_entry(list, &tsdev->list, node)
 			kill_fasync(&list->fasync, SIGIO, POLL_HUP);
-	} else
-		tsdev_free(tsdev);
+	}
+
+	kref_put(&tsdev->kref, tsdev_free);
 }
 
 static const struct input_device_id tsdev_ids[] = {
