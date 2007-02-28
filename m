Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbXB1TIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbXB1TIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932354AbXB1TIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:08:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346AbXB1TIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:08:38 -0500
Date: Wed, 28 Feb 2007 11:06:31 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: dtor@insightbb.com
Cc: linux-kernel@vger.kernel.org, zaitcev@redhat.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Fix locking in mousedev
Message-Id: <20070228110631.86a150e4.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a process is closing /dev/input/mice and an mouse disconnects simulta-
neously, the system is likely to oops. This usually happens when someone
hits <Alt><Ctrl>F1 or logs out from X, and flips a KVM while the system
is reacting.

I reproduced the issue by running this:
  while true; do cat </dev/null >/dev/input/mice; done
This way, it oopses on 2nd or 3rd disconnect reliably. With the patch,
I can disconnect the mouse 20 times.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

---

Discussion

One of the race scenarios is related to the list of handles. The cat
calls mousedev_close -> mixdev_release, does list_for_each to walk for
all handles for a given handler. Iterations are longish while it does
input_close_device -> hidinput_close -> usbhid_close -> usb_kill_urb,
which sleeps briefly. Into this gap goes khubd and does hid_disconnect ->
hidinput_disconnect -> input_unregister_device. This corrupts the list
of handles which cat process is walking.

I was unable to devise a scheme to protect the stock h_list adequately,
so I implemented a private list of mousedev instances, which can be
protected correctly.

Dmitry, please consider getting rid of the list of handles entirely.
The other major user is drivers/char/keyboard.c.

Other than that, the patch is straightforward. It adds a static mutex
to guard common data structures. It has to be static because instances
of mousedev share common structures, such as the mousedev_table[].

This should be uncontroversial, but please let me know if I missed
something obvious.

-- Pete

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 664bcc8..2425c2a 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/major.h>
 #include <linux/device.h>
@@ -64,6 +65,7 @@ struct mousedev {
 	char name[16];
 	wait_queue_head_t wait;
 	struct list_head list;
+	struct list_head h_node;
 	struct input_handle handle;
 
 	struct mousedev_hw_data packet;
@@ -108,10 +110,13 @@ static unsigned char mousedev_imps_seq[] = { 0xf3, 200, 0xf3, 100, 0xf3, 80 };
 static unsigned char mousedev_imex_seq[] = { 0xf3, 200, 0xf3, 200, 0xf3, 80 };
 
 static struct input_handler mousedev_handler;
+static LIST_HEAD(mousedev_h_list);
 
 static struct mousedev *mousedev_table[MOUSEDEV_MINORS];
 static struct mousedev mousedev_mix;
 
+static DEFINE_MUTEX(mousedev_lock);
+
 #define fx(i)  (mousedev->old_x[(mousedev->pkt_count - (i)) & 03])
 #define fy(i)  (mousedev->old_y[(mousedev->pkt_count - (i)) & 03])
 
@@ -366,11 +371,9 @@ static void mousedev_free(struct mousedev *mousedev)
 
 static void mixdev_release(void)
 {
-	struct input_handle *handle;
-
-	list_for_each_entry(handle, &mousedev_handler.h_list, h_node) {
-		struct mousedev *mousedev = handle->private;
+	struct mousedev *mousedev;
 
+	list_for_each_entry(mousedev, &mousedev_h_list, h_node) {
 		if (!mousedev->open) {
 			if (mousedev->exist)
 				input_close_device(&mousedev->handle);
@@ -386,6 +389,7 @@ static int mousedev_release(struct inode * inode, struct file * file)
 
 	mousedev_fasync(-1, file, 0);
 
+	mutex_lock(&mousedev_lock);
 	list_del(&list->node);
 
 	if (!--list->mousedev->open) {
@@ -398,6 +402,7 @@ static int mousedev_release(struct inode * inode, struct file * file)
 				mousedev_free(list->mousedev);
 		}
 	}
+	mutex_unlock(&mousedev_lock);
 
 	kfree(list);
 	return 0;
@@ -406,7 +411,6 @@ static int mousedev_release(struct inode * inode, struct file * file)
 static int mousedev_open(struct inode * inode, struct file * file)
 {
 	struct mousedev_list *list;
-	struct input_handle *handle;
 	struct mousedev *mousedev;
 	int i;
 
@@ -417,11 +421,16 @@ static int mousedev_open(struct inode * inode, struct file * file)
 #endif
 		i = iminor(inode) - MOUSEDEV_MINOR_BASE;
 
-	if (i >= MOUSEDEV_MINORS || !mousedev_table[i])
+	mutex_lock(&mousedev_lock);
+	if (i >= MOUSEDEV_MINORS || !mousedev_table[i]) {
+		mutex_unlock(&mousedev_lock);
 		return -ENODEV;
+	}
 
-	if (!(list = kzalloc(sizeof(struct mousedev_list), GFP_KERNEL)))
+	if (!(list = kzalloc(sizeof(struct mousedev_list), GFP_KERNEL))) {
+		mutex_unlock(&mousedev_lock);
 		return -ENOMEM;
+	}
 
 	spin_lock_init(&list->packet_lock);
 	list->pos_x = xres / 2;
@@ -432,16 +441,16 @@ static int mousedev_open(struct inode * inode, struct file * file)
 
 	if (!list->mousedev->open++) {
 		if (list->mousedev->minor == MOUSEDEV_MIX) {
-			list_for_each_entry(handle, &mousedev_handler.h_list, h_node) {
-				mousedev = handle->private;
+			list_for_each_entry(mousedev, &mousedev_h_list, h_node) {
 				if (!mousedev->open && mousedev->exist)
-					input_open_device(handle);
+					input_open_device(&mousedev->handle);
 			}
 		} else
 			if (!mousedev_mix.open && list->mousedev->exist)
 				input_open_device(&list->mousedev->handle);
 	}
 
+	mutex_unlock(&mousedev_lock);
 	return 0;
 }
 
@@ -604,7 +613,6 @@ static ssize_t mousedev_read(struct file * file, char __user * buffer, size_t co
 	return count;
 }
 
-/* No kernel lock - fine */
 static unsigned int mousedev_poll(struct file *file, poll_table *wait)
 {
 	struct mousedev_list *list = file->private_data;
@@ -631,14 +639,19 @@ static struct input_handle *mousedev_connect(struct input_handler *handler, stru
 	struct class_device *cdev;
 	int minor = 0;
 
+	mutex_lock(&mousedev_lock);
+
 	for (minor = 0; minor < MOUSEDEV_MINORS && mousedev_table[minor]; minor++);
 	if (minor == MOUSEDEV_MINORS) {
+		mutex_unlock(&mousedev_lock);
 		printk(KERN_ERR "mousedev: no more free mousedev devices\n");
 		return NULL;
 	}
 
-	if (!(mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL)))
+	if (!(mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL))) {
+		mutex_unlock(&mousedev_lock);
 		return NULL;
+	}
 
 	INIT_LIST_HEAD(&mousedev->list);
 	init_waitqueue_head(&mousedev->wait);
@@ -664,6 +677,9 @@ static struct input_handle *mousedev_connect(struct input_handler *handler, stru
 	sysfs_create_link(&input_class.subsys.kset.kobj, &cdev->kobj,
 			  mousedev->name);
 
+	list_add_tail(&mousedev->h_node, &mousedev_h_list);
+
+	mutex_unlock(&mousedev_lock);
 	return &mousedev->handle;
 }
 
@@ -672,6 +688,9 @@ static void mousedev_disconnect(struct input_handle *handle)
 	struct mousedev *mousedev = handle->private;
 	struct mousedev_list *list;
 
+	mutex_lock(&mousedev_lock);
+	list_del(&mousedev->h_node);
+
 	sysfs_remove_link(&input_class.subsys.kset.kobj, mousedev->name);
 	class_device_destroy(&input_class,
 			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + mousedev->minor));
@@ -687,6 +706,7 @@ static void mousedev_disconnect(struct input_handle *handle)
 			input_close_device(handle);
 		mousedev_free(mousedev);
 	}
+	mutex_unlock(&mousedev_lock);
 }
 
 static const struct input_device_id mousedev_ids[] = {
