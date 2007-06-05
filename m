Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbXFEU7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbXFEU7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764584AbXFEU7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:59:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53452 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760775AbXFEU7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:59:33 -0400
Date: Tue, 5 Jun 2007 16:50:54 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/2] UML - Fix request->sector update
Message-ID: <20070605205054.GA9765@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is post-2.6.22 material - it fixes a bug, but not one that I
think has been seen in the wild, plus an earlier version of this fix
caused file corruption ]

It is theoretically possible for a request to finish and be freed
between writing it to the I/O thread and updating the sector count.
In this case, the update will dereference a freed pointer.

To avoid this, I delay the update until processing the next sg
segment, when the request pointer is known to be good.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/ubd_kern.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-06-02 12:13:50.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-06-02 22:23:41.000000000 -0400
@@ -1082,7 +1082,7 @@ static void do_ubd_request(request_queue
 {
 	struct io_thread_req *io_req;
 	struct request *req;
-	int n;
+	int n, last_sectors;
 
 	while(1){
 		struct ubd *dev = q->queuedata;
@@ -1098,9 +1098,11 @@ static void do_ubd_request(request_queue
 		}
 
 		req = dev->request;
+		last_sectors = 0;
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
+			req->sector += last_sectors;
 			io_req = kmalloc(sizeof(struct io_thread_req),
 					 GFP_ATOMIC);
 			if(io_req == NULL){
@@ -1112,6 +1114,7 @@ static void do_ubd_request(request_queue
 					(unsigned long long) req->sector << 9,
 					sg->offset, sg->length, sg->page);
 
+			last_sectors = sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
 					  sizeof(struct io_thread_req *));
 			if(n != sizeof(struct io_thread_req *)){
@@ -1123,7 +1126,6 @@ static void do_ubd_request(request_queue
 				return;
 			}
 
-			req->sector += sg->length >> 9;
 			dev->start_sg++;
 		}
 		dev->end_sg = 0;
