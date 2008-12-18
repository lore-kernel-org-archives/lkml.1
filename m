Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752822AbYLRSb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYLRSb3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYLRSbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:31:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50608 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYLRSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:31:18 -0500
Date: Thu, 18 Dec 2008 19:33:10 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul.Clements@steeleye.com, kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: nbd: fix locking in case of error
Message-ID: <20081218183310.GA21260@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up error handling some more, and prevents return with lock
held from nbd_handle_req when nbd_send_req() fails. It also switches
calling convention of nbd_send_req from 0 = ok, 1 = failed to 0 /
-errno.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index fcefbe4..d36787d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -280,7 +280,7 @@ static int nbd_send_req(struct nbd_devic
 	return 0;
 
 error_out:
-	return 1;
+	return -EIO;
 }
 
 static struct request *nbd_find_request(struct nbd_device *lo,
@@ -467,10 +467,9 @@ static void nbd_handle_req(struct nbd_de
 
 	mutex_lock(&lo->tx_lock);
 	if (unlikely(!lo->sock)) {
-		mutex_unlock(&lo->tx_lock);
 		printk(KERN_ERR "%s: Attempted send on closed socket\n",
 		       lo->disk->disk_name);
-		goto error_out;
+		goto error_out_unlock;
 	}
 
 	lo->active_req = req;
@@ -478,7 +477,7 @@ static void nbd_handle_req(struct nbd_de
 	if (nbd_send_req(lo, req) != 0) {
 		printk(KERN_ERR "%s: Request send failed\n",
 				lo->disk->disk_name);
-		goto error_out;
+		goto error_out_unlock;
 	} else {
 		spin_lock(&lo->queue_lock);
 		list_add(&req->queuelist, &lo->queue_head);
@@ -491,6 +490,8 @@ static void nbd_handle_req(struct nbd_de
 
 	return;
 
+error_out_unlock:
+	mutex_unlock(&lo->tx_lock);
 error_out:
 	req->errors++;
 	nbd_end_request(req);
@@ -531,7 +532,7 @@ static int nbd_thread(void *data)
  *   { printk( "Warning: Ignoring result!\n"); nbd_end_request( req ); }
  */
 
-static void do_nbd_request(struct request_queue * q)
+static void do_nbd_request(struct request_queue *q)
 {
 	struct request *req;
 	

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
