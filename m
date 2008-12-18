Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753156AbYLRST2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYLRST2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYLRSTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:19:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57158 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYLRSTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:19:17 -0500
Date: Thu, 18 Dec 2008 19:21:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul.Clements@steeleye.com, kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: nbd: clean up error handling
Message-ID: <20081218182108.GA13546@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses existing error_out: label instead of hardcoding error action.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit d4bf0663fe12e5536360b2b9a3df3f49cdb7ef76
tree b5b88ccf8008e135a972415f186b8a93cecb184c
parent 70b683565a6bfdb95a367b47509c2bc5db54c33f
author Pavel <pavel@amd.ucw.cz> Thu, 18 Dec 2008 19:20:21 +0100
committer Pavel <pavel@amd.ucw.cz> Thu, 18 Dec 2008 19:20:21 +0100

 drivers/block/nbd.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index d3a91ca..f0b8ee2 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
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
@@ -475,8 +473,7 @@ static void nbd_handle_req(struct nbd_de
 	if (nbd_send_req(lo, req) != 0) {
 		printk(KERN_ERR "%s: Request send failed\n",
 				lo->disk->disk_name);
-		req->errors++;
-		nbd_end_request(req);
+		goto error_out;
 	} else {
 		spin_lock(&lo->queue_lock);
 		list_add(&req->queuelist, &lo->queue_head);
@@ -563,7 +560,7 @@ static int nbd_ioctl(struct block_device
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
