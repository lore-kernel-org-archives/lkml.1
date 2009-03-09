Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbZCIWtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbZCIWtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZCIWqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:46:09 -0400
Received: from cmpxchg.org ([85.214.51.133]:60377 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbZCIWqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:46:08 -0400
Message-Id: <20090309224228.631986739@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 09 Mar 2009 23:37:28 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>
Subject: [patch 2/2] hiddev: fix waitqueue usage
References: <20090309223726.565021009@cmpxchg.org>
Content-Disposition: inline; filename=hiddev-fix-waitqueue-usage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DECLARE_WAITQUEUE doesn't initialize the wait descriptor's task_list
to 'empty' but to zero.

prepare_to_wait() will not enqueue the descriptor to the waitqueue and
finish_wait() will do list_del_init() on a list head that contains
NULL pointers, which oopses.

This was introduced by 079034073 "HID: hiddev cleanup -- handle all
error conditions properly".

The prior code used an unconditional add_to_waitqueue() which didn't
care about the wait descriptor's list head and enqueued the thing
unconditionally.

The new code uses prepare_to_wait() which DOES check the prior list
state, so use DEFINE_WAIT instead.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oliver Neukum <oliver@neukum.name>
---
 drivers/hid/usbhid/hiddev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -323,7 +323,7 @@ static ssize_t hiddev_write(struct file 
  */
 static ssize_t hiddev_read(struct file * file, char __user * buffer, size_t count, loff_t *ppos)
 {
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT(wait);
 	struct hiddev_list *list = file->private_data;
 	int event_size;
 	int retval;


