Return-Path: <linux-kernel-owner+w=401wt.eu-S1031346AbXD2UJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031346AbXD2UJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031382AbXD2UJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:09:42 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15500 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031346AbXD2UJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:09:41 -0400
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070429194129.GA747@bitwizard.nl>
References: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	 <20070417195823.943f9472.akpm@linux-foundation.org>
	 <1176865565.6796.16.camel@heimdal.trondhjem.org>
	 <20070418033055.GA24044@iucha.net>
	 <1176868485.6796.42.camel@heimdal.trondhjem.org>
	 <20070418040730.GC24044@iucha.net>
	 <20070417211350.ebba1493.akpm@linux-foundation.org>
	 <20070418043040.GD24044@iucha.net>
	 <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
	 <20070417223738.8f49a39f.akpm@linux-foundation.org>
	 <20070429194129.GA747@bitwizard.nl>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 22:09:38 +0200
Message-Id: <1177877378.28223.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 21:41 +0200, Rogier Wolff wrote:
> On Tue, Apr 17, 2007 at 10:37:38PM -0700, Andrew Morton wrote:
> > Florin, can we please see /proc/meminfo as well?
> > 
> > Also the result of `echo m > /proc/sysrq-trigger'
> 
> Hi,
> 
> It's been a while since this thread died out, but maybe I'm 
> having the same problem. Networking, large part of memory is 
> buffering writes..... 
> 
> In my case I'm using NBD. 
> 
> Oh, 
> 
> /sys/block/nbd0/stat gives:
>      636       88     5353     1700      991    19554   162272    63156       43  1452000 61802352
> I put some debugging stuff in nbd, and it DOES NOT KNOW about the
> 43 requests that the io scheduler claims are in flight at the
> driver.... 

AFAIK nbd is a tad broken; the following patch used to fix it, although
not in the proper way. Hence it never got merged.

There is a race where the plug state of the device queue gets confused,
which causes requests to just sit on the queue, without further action.

---

Subject: nbd: request_fn fixup

Dropping the queue_lock opens up a nasty race, fix this race by
plugging the device when we're done.

Also includes a small cleanup.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Daniel Phillips <phillips@google.com>
CC: Pavel Machek <pavel@ucw.cz>
---
 drivers/block/nbd.c |   67 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/block/nbd.c
===================================================================
--- linux-2.6.orig/drivers/block/nbd.c	2006-09-07 17:20:52.000000000 +0200
+++ linux-2.6/drivers/block/nbd.c	2006-09-07 17:35:05.000000000 +0200
@@ -97,20 +97,24 @@ static const char *nbdcmd_to_ascii(int c
 }
 #endif /* NDEBUG */
 
-static void nbd_end_request(struct request *req)
+static void __nbd_end_request(struct request *req)
 {
 	int uptodate = (req->errors == 0) ? 1 : 0;
-	request_queue_t *q = req->q;
-	unsigned long flags;
 
 	dprintk(DBG_BLKDEV, "%s: request %p: %s\n", req->rq_disk->disk_name,
 			req, uptodate? "done": "failed");
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
+	if (!end_that_request_first(req, uptodate, req->nr_sectors))
 		end_that_request_last(req, uptodate);
-	}
-	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
+static void nbd_end_request(struct request *req)
+{
+	request_queue_t *q = req->q;
+
+	spin_lock_irq(q->queue_lock);
+	__nbd_end_request(req);
+	spin_unlock_irq(q->queue_lock);
 }
 
 /*
@@ -435,10 +439,8 @@ static void do_nbd_request(request_queue
 			mutex_unlock(&lo->tx_lock);
 			printk(KERN_ERR "%s: Attempted send on closed socket\n",
 			       lo->disk->disk_name);
-			req->errors++;
-			nbd_end_request(req);
 			spin_lock_irq(q->queue_lock);
-			continue;
+			goto error_out;
 		}
 
 		lo->active_req = req;
@@ -463,10 +465,13 @@ static void do_nbd_request(request_queue
 
 error_out:
 		req->errors++;
-		spin_unlock(q->queue_lock);
-		nbd_end_request(req);
-		spin_lock(q->queue_lock);
+		__nbd_end_request(req);
 	}
+	/*
+	 * q->queue_lock has been dropped, this opens up a race
+	 * plug the device to close it.
+	 */
+	blk_plug_device(q);
 	return;
 }
 


