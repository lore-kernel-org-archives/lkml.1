Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXJWBs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXJWBs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXJWBss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:48:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37348 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbXJWBsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:48:47 -0400
Date: Mon, 22 Oct 2007 19:48:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Sparse fix for scsi_request_fn
Message-ID: <20071023014845.GN27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new __holds() macro to tell sparse it's OK to drop and then
reacquire a lock within a function.  Use it in scsi_request_fn.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 207f1aa..5e0583a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1374,6 +1372,7 @@ static void scsi_softirq_done(struct request *rq)
  * Lock status: IO request lock assumed to be held when called.
  */
 static void scsi_request_fn(struct request_queue *q)
+		__holds(q->queue_lock)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 86f9a3a..1611ac6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -12,6 +12,7 @@
 # define __iomem	__attribute__((noderef, address_space(2)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
+# define __holds(x)	__attribute__((context(x,1,1)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
@@ -29,6 +30,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __builtin_warning(x, y...) (1)
 # define __acquires(x)
 # define __releases(x)
+# define __holds(x)
 # define __acquire(x) (void)0
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
