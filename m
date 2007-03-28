Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXC1CGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXC1CGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXC1CGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:06:06 -0400
Received: from [198.99.130.12] ([198.99.130.12]:46838 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbXC1CGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:06:01 -0400
Date: Tue, 27 Mar 2007 22:02:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - fix I/O hang when multiple devices are in use
Message-ID: <20070328020247.GA12299@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This patch needs to get into 2.6.21, as it fixes a serious bug
introduced soon after 2.6.20 ]

Commit 62f96cb01e8de7a5daee472e540f726db2801499 introduced per-devices
queues and locks, which was fine as far as it went, but left in place
a global which controlled access to submitting requests to the host.
This should have been made per-device as well, since it causes I/O
hangs when multiple block devices are in use.

This patch fixes that by replacing the global with an activity flag in
the device structure in order to tell whether the queue is currently
being run.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-03-27 20:27:16.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-03-27 20:28:29.000000000 -0400
@@ -108,10 +108,6 @@ static inline void ubd_set_bit(__u64 bit
 
 static DEFINE_MUTEX(ubd_lock);
 
-/* XXX - this made sense in 2.4 days, now it's only used as a boolean, and
- * probably it doesn't make sense even for that. */
-static int do_ubd;
-
 static int ubd_open(struct inode * inode, struct file * filp);
 static int ubd_release(struct inode * inode, struct file * file);
 static int ubd_ioctl(struct inode * inode, struct file * file,
@@ -168,6 +164,7 @@ struct ubd {
 	struct platform_device pdev;
 	struct request_queue *queue;
 	spinlock_t lock;
+	int active;
 };
 
 #define DEFAULT_COW { \
@@ -189,6 +186,7 @@ struct ubd {
 	.shared =		0, \
         .cow =			DEFAULT_COW, \
 	.lock =			SPIN_LOCK_UNLOCKED,	\
+	.active =		0, \
 }
 
 /* Protected by ubd_lock */
@@ -506,7 +504,6 @@ static void ubd_handler(void)
 	struct ubd *dev;
 	int n;
 
-	do_ubd = 0;
 	n = os_read_file(thread_fd, &req, sizeof(req));
 	if(n != sizeof(req)){
 		printk(KERN_ERR "Pid %d - spurious interrupt in ubd_handler, "
@@ -516,6 +513,7 @@ static void ubd_handler(void)
 
 	rq = req.req;
 	dev = rq->rq_disk->private_data;
+	dev->active = 0;
 
 	ubd_finish(rq, req.error);
 	reactivate_fd(thread_fd, UBD_IRQ);
@@ -1081,11 +1079,12 @@ static void do_ubd_request(request_queue
 		}
 	}
 	else {
-		if(do_ubd || (req = elv_next_request(q)) == NULL)
+		struct ubd *dev = q->queuedata;
+		if(dev->active || (req = elv_next_request(q)) == NULL)
 			return;
 		err = prepare_request(req, &io_req);
 		if(!err){
-			do_ubd = 1;
+			dev->active = 1;
 			n = os_write_file(thread_fd, (char *) &io_req,
 					 sizeof(io_req));
 			if(n != sizeof(io_req))
