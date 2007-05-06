Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXEFWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXEFWek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXEFWek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:34:40 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37646 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXEFWej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:34:39 -0400
Date: Mon, 7 May 2007 00:34:32 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] kernel panic
In-Reply-To: <20070506164944.GA15682@vanheusden.com>
Message-ID: <Pine.LNX.4.64.0705070029580.16923@twin.jikos.cz>
References: <20070506115651.GA13183@vanheusden.com>
 <Pine.LNX.4.64.0705061632500.16923@twin.jikos.cz> <20070506164944.GA15682@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007, Folkert van Heusden wrote:

> > > A few moments ago a system of mine running 2.6.21 on a P4 with 
> > > hyperthreading, 2GB ram, IDE disk, crashed: [10371.128320] BUG: 
> > > unable to handle kernel paging request at virtual address 00100100 
> > > [10371.128419] printing eip:
> > [...]
> > > [10371.131825] EIP is at hiddev_send_event+0xa1/0xd3
> > 
> > I will look into it. Are you able to reproduce the problem, or did it 
> > happen just randomly? Is there any userspace driver using the hiddev 
> > interface at the moment it crashes?
> > There have been no changes in the hiddev code for a pretty long time.
[...]
> This is the first time it was followed by an oops. Connected via hid are 
> 2 temperature sensors and an UPS. Has been running fine for ages.

OK, I think the patch below should solve this. I am pretty surprised 
though that this bug wasn't triggered/reported by anyone anytime sooner, 
it has been there for ages too (but ok, the race window should be pretty 
small and hiddev is usually not high-throughput interface).

Could you please test it and let me know?



From: Jiri Kosina <jkosina@suse.cz>

USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()
    
There is a small race window in which hiddev_release() could corrupt the 
list that is being processed for new event in hiddev_send_event(). 
Synchronize the operations over this list.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/usb/input/hiddev.c b/drivers/usb/input/hiddev.c
index a8b3d66..488d61b 100644
--- a/drivers/usb/input/hiddev.c
+++ b/drivers/usb/input/hiddev.c
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
 
