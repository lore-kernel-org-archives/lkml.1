Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXEUT02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXEUT02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765363AbXEUTVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:30 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46336 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbXEUTVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:22 -0400
Message-Id: <20070521191754.683888000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 63/69] USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()
Content-Disposition: inline; filename=usb-hid-hiddev-fix-race-between-hiddev_send_event-and-hiddev_release.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jiri Kosina <jkosina@suse.cz>

USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()
    
There is a small race window in which hiddev_release() could corrupt the
list that is being processed for new event in hiddev_send_event().
Synchronize the operations over this list.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
(in Linus' tree as cdcb44e87bedcf5070eece61f89f9373a3810031)

---
 drivers/usb/input/hiddev.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- linux-2.6.21.1.orig/drivers/usb/input/hiddev.c
+++ linux-2.6.21.1/drivers/usb/input/hiddev.c
@@ -51,6 +51,7 @@ struct hiddev {
 	wait_queue_head_t wait;
 	struct hid_device *hid;
 	struct list_head list;
+	spinlock_t list_lock;
 };
 
 struct hiddev_list {
@@ -161,7 +162,9 @@ static void hiddev_send_event(struct hid
 {
 	struct hiddev *hiddev = hid->hiddev;
 	struct hiddev_list *list;
+	unsigned long flags;
 
+	spin_lock_irqsave(&hiddev->list_lock, flags);
 	list_for_each_entry(list, &hiddev->list, node) {
 		if (uref->field_index != HID_FIELD_INDEX_NONE ||
 		    (list->flags & HIDDEV_FLAG_REPORT) != 0) {
@@ -171,6 +174,7 @@ static void hiddev_send_event(struct hid
 			kill_fasync(&list->fasync, SIGIO, POLL_IN);
 		}
 	}
+	spin_unlock_irqrestore(&hiddev->list_lock, flags);
 
 	wake_up_interruptible(&hiddev->wait);
 }
@@ -235,9 +239,13 @@ static int hiddev_fasync(int fd, struct 
 static int hiddev_release(struct inode * inode, struct file * file)
 {
 	struct hiddev_list *list = file->private_data;
+	unsigned long flags;
 
 	hiddev_fasync(-1, file, 0);
+
+	spin_lock_irqsave(&list->hiddev->list_lock, flags);
 	list_del(&list->node);
+	spin_unlock_irqrestore(&list->hiddev->list_lock, flags);
 
 	if (!--list->hiddev->open) {
 		if (list->hiddev->exist)
@@ -257,6 +265,7 @@ static int hiddev_release(struct inode *
 static int hiddev_open(struct inode *inode, struct file *file)
 {
 	struct hiddev_list *list;
+	unsigned long flags;
 
 	int i = iminor(inode) - HIDDEV_MINOR_BASE;
 
@@ -267,7 +276,11 @@ static int hiddev_open(struct inode *ino
 		return -ENOMEM;
 
 	list->hiddev = hiddev_table[i];
+
+	spin_lock_irqsave(&list->hiddev->list_lock, flags);
 	list_add_tail(&list->node, &hiddev_table[i]->list);
+	spin_unlock_irqrestore(&list->hiddev->list_lock, flags);
+
 	file->private_data = list;
 
 	if (!list->hiddev->open++)
@@ -773,6 +786,7 @@ int hiddev_connect(struct hid_device *hi
 
 	init_waitqueue_head(&hiddev->wait);
 	INIT_LIST_HEAD(&hiddev->list);
+	spin_lock_init(&hiddev->list_lock);
 	hiddev->hid = hid;
 	hiddev->exist = 1;
 

-- 
