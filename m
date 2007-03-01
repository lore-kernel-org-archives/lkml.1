Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXCAD4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXCAD4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 22:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXCAD4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 22:56:45 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:42664 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbXCAD4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 22:56:42 -0500
Date: Thu, 1 Mar 2007 14:56:40 +1100
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Fix soft lockup with iSeries viocd driver
Message-ID: <20070301035640.GS4575@bakeyournoodle.com>
Mail-Followup-To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
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
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

---
 viocd.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

Index: linux-2.6.20-rc5/drivers/cdrom/viocd.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/cdrom/viocd.c
+++ linux-2.6.20-rc5/drivers/cdrom/viocd.c
@@ -376,6 +376,25 @@ static int send_request(struct request *
        return 0;
 }
 
+static void viocd_end_request(struct request *req, int uptodate)
+{
+       int nsectors = req->hard_nr_sectors;
+
+       /*
+        * Make sure it's fully ended, and ensure that we process
+        * at least one sector.
+        */
+       if (blk_pc_request(req))
+               nsectors = (req->data_len + 511) >> 9;
+       if (!nsectors)
+               nsectors = 1;
+
+       if (end_that_request_first(req, uptodate, nsectors))
+               BUG();
+       add_disk_randomness(req->rq_disk);
+       blkdev_dequeue_request(req);
+       end_that_request_last(req, uptodate);
+}
 
 static int rwreq;
 
@@ -385,11 +404,11 @@ static void do_viocd_request(request_que
 
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
@@ -601,9 +620,9 @@ return_complete:
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



Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

