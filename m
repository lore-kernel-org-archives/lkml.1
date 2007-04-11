Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXDKQHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXDKQHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXDKQHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:07:15 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46149 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbXDKQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:07:08 -0400
Date: Wed, 11 Apr 2007 12:01:26 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/4] UML - Send pointers instead of structures to I/O thread
Message-ID: <20070411160126.GA6324@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of writing entire structures between UML and the I/O thread,
we send pointers.  This cuts down on the amount of data being copied
and possibly allows more requests to be pending between the two.

This requires that the requests be kmalloced and freed instead of
living on the stack.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-04-10 10:59:03.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-04-10 10:59:17.000000000 -0400
@@ -503,7 +503,7 @@ static struct list_head restart = LIST_H
 /* Called without dev->lock held, and only in interrupt context. */
 static void ubd_handler(void)
 {
-	struct io_thread_req req;
+	struct io_thread_req *req;
 	struct request *rq;
 	struct ubd *ubd;
 	struct list_head *list, *next_ele;
@@ -511,7 +511,8 @@ static void ubd_handler(void)
 	int n;
 
 	while(1){
-		n = os_read_file_k(thread_fd, &req, sizeof(req));
+		n = os_read_file_k(thread_fd, &req,
+				   sizeof(struct io_thread_req *));
 		if(n != sizeof(req)){
 			if(n == -EAGAIN)
 				break;
@@ -520,10 +521,11 @@ static void ubd_handler(void)
 			return;
 		}
 
-		rq = req.req;
-		rq->nr_sectors -= req.length >> 9;
+		rq = req->req;
+		rq->nr_sectors -= req->length >> 9;
 		if(rq->nr_sectors == 0)
 			ubd_finish(rq, rq->hard_nr_sectors << 9);
+		kfree(req);
 	}
 	reactivate_fd(thread_fd, UBD_IRQ);
 
@@ -1078,7 +1080,7 @@ static void prepare_request(struct reque
 /* Called with dev->lock held */
 static void do_ubd_request(request_queue_t *q)
 {
-	struct io_thread_req io_req;
+	struct io_thread_req *io_req;
 	struct request *req;
 	int n;
 
@@ -1099,13 +1101,20 @@ static void do_ubd_request(request_queue
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
-			prepare_request(req, &io_req,
+			io_req = kmalloc(sizeof(struct io_thread_req),
+					 GFP_KERNEL | GFP_ATOMIC);
+			if(io_req == NULL){
+				if(list_empty(&dev->restart))
+					list_add(&dev->restart, &restart);
+				return;
+			}
+			prepare_request(req, io_req,
 					(unsigned long long) req->sector << 9,
 					sg->offset, sg->length, sg->page);
 
-			n = os_write_file_k(thread_fd, (char *) &io_req,
-					    sizeof(io_req));
-			if(n != sizeof(io_req)){
+			n = os_write_file_k(thread_fd, &io_req,
+					    sizeof(struct io_thread_req *));
+			if(n != sizeof(struct io_thread_req *)){
 				if(n != -EAGAIN)
 					printk("write to io thread failed, "
 					       "errno = %d\n", -n);
@@ -1437,13 +1446,14 @@ static int io_count = 0;
 
 int io_thread(void *arg)
 {
-	struct io_thread_req req;
+	struct io_thread_req *req;
 	int n;
 
 	ignore_sigwinch_sig();
 	while(1){
-		n = os_read_file_k(kernel_fd, &req, sizeof(req));
-		if(n != sizeof(req)){
+		n = os_read_file_k(kernel_fd, &req,
+				 sizeof(struct io_thread_req *));
+		if(n != sizeof(struct io_thread_req *)){
 			if(n < 0)
 				printk("io_thread - read failed, fd = %d, "
 				       "err = %d\n", kernel_fd, -n);
@@ -1454,9 +1464,10 @@ int io_thread(void *arg)
 			continue;
 		}
 		io_count++;
-		do_io(&req);
-		n = os_write_file_k(kernel_fd, &req, sizeof(req));
-		if(n != sizeof(req))
+		do_io(req);
+		n = os_write_file_k(kernel_fd, &req,
+				  sizeof(struct io_thread_req *));
+		if(n != sizeof(struct io_thread_req *))
 			printk("io_thread - write failed, fd = %d, err = %d\n",
 			       kernel_fd, -n);
 	}
