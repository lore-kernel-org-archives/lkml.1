Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXB0GQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXB0GQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932775AbXB0GQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:16:30 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:38216 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbXB0GQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:16:29 -0500
X-Greylist: delayed 1255 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 01:16:28 EST
Date: Tue, 27 Feb 2007 16:55:29 +1100
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Fix soft lockup with iSeries viocd driver
Message-ID: <20070227055529.GO4575@bakeyournoodle.com>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Breeds <tony@bakeyournoodle.com>

Fix soft lockup with iSeries viocd driver, caused by eventually calling
end_that_request_first() with nr_bytes 0.

The lockup is triggered by hald, interrogating the device.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---
Implementation based on drivers/ide/ide-io.c:ide_end_request()

 viocd.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6.20-rc5/drivers/cdrom/viocd.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/cdrom/viocd.c
+++ linux-2.6.20-rc5/drivers/cdrom/viocd.c
@@ -376,6 +376,22 @@ static int send_request(struct request *
        return 0;
 }
 
+static void viocd_end_request(struct request *req, int uptodate)
+{
+       int nsectors = req->hard_cur_sectors;
+
+       /* Make sure it's fully ended */
+       if (blk_pc_request(req))
+               nsectors = (req->data_len + 511) >> 9;
+       if (!nsectors)
+               nsectors = 1;
+
+       if (!end_that_request_first(req, uptodate, nsectors)) {
+               add_disk_randomness(req->rq_disk);
+               blkdev_dequeue_request(req);
+               end_that_request_last(req, uptodate);
+       }
+}
 
 static int rwreq;
 
@@ -385,11 +401,11 @@ static void do_viocd_request(request_que
 
        while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
                if (!blk_fs_request(req))
-                       end_request(req, 0);
+                       viocd_end_request(req, 0);
                else if (send_request(req) < 0) {
                        printk(VIOCD_KERN_WARNING
                                        "unable to send message to OS/400!");
-                       end_request(req, 0);
+                       viocd_end_request(req, 0);
                } else
                        rwreq++;
        }
@@ -601,9 +617,9 @@ return_complete:
                                        "with rc %d:0x%04X: %s\n",
                                        req, event->xRc,
                                        bevent->sub_result, err->msg);
-                       end_request(req, 0);
+                       viocd_end_request(req, 0);
                } else
-                       end_request(req, 1);
+                       viocd_end_request(req, 1);
 
                /* restart handling of incoming requests */
                spin_unlock_irqrestore(&viocd_reqlock, flags);




Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

