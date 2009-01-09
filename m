Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZAIKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZAIKEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZAIKEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:04:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54063 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZAIKEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:04:16 -0500
Date: Fri, 9 Jan 2009 11:06:22 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       paul.clements@steeleye.com
Subject: nbd: trivial cleanups
Message-ID: <20090109100622.GA3585@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanups for nbd: only the return -EIO one really changes
code, and I've verified all the callers (plus 0 == success, 1 == error
convention is really ugly).

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7bcc1d8..670e89d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -4,7 +4,7 @@
  * Note that you can not swap over this thing, yet. Seems to work but
  * deadlocks sometimes - you can not swap over TCP in general.
  * 
- * Copyright 1997-2000 Pavel Machek <pavel@ucw.cz>
+ * Copyright 1997-2000, 2008 Pavel Machek <pavel@suse.cz>
  * Parts copyright 2001 Steven Whitehouse <steve@chygwyn.com>
  *
  * This file is released under GPLv2 or later.
@@ -276,7 +276,7 @@ static int nbd_send_req(struct nbd_devic
 	return 0;
 
 error_out:
-	return 1;
+	return -EIO;
 }
 
 static struct request *nbd_find_request(struct nbd_device *lo,
@@ -465,9 +465,7 @@ static void nbd_handle_req(struct nbd_de
 		mutex_unlock(&lo->tx_lock);
 		printk(KERN_ERR "%s: Attempted send on closed socket\n",
 		       lo->disk->disk_name);
-		req->errors++;
-		nbd_end_request(req);
-		return;
+		goto error_out;
 	}
 
 	lo->active_req = req;
@@ -529,7 +527,7 @@ static int nbd_thread(void *data)
  *   { printk( "Warning: Ignoring result!\n"); nbd_end_request( req ); }
  */
 
-static void do_nbd_request(struct request_queue * q)
+static void do_nbd_request(struct request_queue *q)
 {
 	struct request *req;
 	
@@ -563,7 +561,7 @@ static int nbd_ioctl(struct block_device
 	struct nbd_device *lo = bdev->bd_disk->private_data;
 	struct file *file;
 	int error;
-	struct request sreq ;
+	struct request sreq;
 	struct task_struct *thread;
 
 	if (!capable(CAP_SYS_ADMIN))

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
