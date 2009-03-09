Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZCICcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZCICcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 22:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZCICcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 22:32:08 -0400
Received: from cmpxchg.org ([85.214.51.133]:43934 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbZCICcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 22:32:07 -0400
Date: Mon, 9 Mar 2009 03:31:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oliver@neukum.name>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [patch] hiddev: fix incorrect hiddev freeing
Message-ID: <20090309023151.GA11464@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hiddev_open() fails for whatever reason, free the just allocated
hiddev_list structure shared hiddev potentially still in use.

The hiddev is freed in device disconnect/last close of the device file
and must not be freed while there are possibly existing references to
it.

This is probably responsible for these

  http://kerneloops.org/oops.php?number=221185
  http://kerneloops.org/oops.php?number=220365

where a reader sleeps on the waitqueue, the device gets disconnected
(exist -> 0) another user tries to open it, fails on the exist check
and frees the hiddev from the table.  The finish_wait() in the reader
will then dereference the hiddev to get to the waitqueue and oopses.

This was introduced by commit 079034073faf974973baa0256b029451f6e768ad
"HID: hiddev cleanup -- handle all error conditions properly".

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oliver Neukum <oliver@neukum.name>
---

diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 4940e4d..00ea1ed 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -306,7 +306,7 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	return 0;
 bail:
 	file->private_data = NULL;
-	kfree(list->hiddev);
+	kfree(list);
 	return res;
 }
 
