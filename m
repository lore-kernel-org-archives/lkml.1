Return-Path: <linux-kernel-owner+w=401wt.eu-S934470AbXGWTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbXGWTes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934392AbXGWTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:34:06 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37016 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934481AbXGWTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:34:04 -0400
Date: Mon, 23 Jul 2007 15:33:12 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Al Viro <viro@ftp.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/3] UML - Fix aio compilation bug
Message-ID: <20070723193312.GA12388@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure do_aio thanks to commments from Ulrich and Al.

Uli started this by seeing that UML's initialization of a struct iocb
initialized fields that it shouldn't.

Al followed up by adding the following cleanups:
	eliminating a variable by just using an anonymous structure in
its place.
	hoisting a duplicated line out of the switch.
	simplifying the error checking at the end.

I added a severity to the printk.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/aio.c |   47 +++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

Index: linux-2.6.17/arch/um/os-Linux/aio.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/aio.c	2007-07-23 14:58:18.000000000 -0400
+++ linux-2.6.17/arch/um/os-Linux/aio.c	2007-07-23 14:59:13.000000000 -0400
@@ -14,6 +14,7 @@
 #include "init.h"
 #include "user.h"
 #include "mode.h"
+#include "kern_constants.h"
 
 struct aio_thread_req {
 	enum aio_type type;
@@ -65,47 +66,33 @@ static long io_getevents(aio_context_t c
 static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
 		  int len, unsigned long long offset, struct aio_context *aio)
 {
-	struct iocb iocb, *iocbp = &iocb;
+	struct iocb *iocbp = & ((struct iocb) {
+				    .aio_data       = (unsigned long) aio,
+				    .aio_fildes     = fd,
+				    .aio_buf        = (unsigned long) buf,
+				    .aio_nbytes     = len,
+				    .aio_offset     = offset
+			     });
 	char c;
-	int err;
-
-	iocb = ((struct iocb) { .aio_data 	= (unsigned long) aio,
-				.aio_reqprio	= 0,
-				.aio_fildes	= fd,
-				.aio_buf	= (unsigned long) buf,
-				.aio_nbytes	= len,
-				.aio_offset	= offset,
-				.aio_reserved1	= 0,
-				.aio_reserved2	= 0,
-				.aio_reserved3	= 0 });
 
-	switch(type){
+	switch (type) {
 	case AIO_READ:
-		iocb.aio_lio_opcode = IOCB_CMD_PREAD;
-		err = io_submit(ctx, 1, &iocbp);
+		iocbp->aio_lio_opcode = IOCB_CMD_PREAD;
 		break;
 	case AIO_WRITE:
-		iocb.aio_lio_opcode = IOCB_CMD_PWRITE;
-		err = io_submit(ctx, 1, &iocbp);
+		iocbp->aio_lio_opcode = IOCB_CMD_PWRITE;
 		break;
 	case AIO_MMAP:
-		iocb.aio_lio_opcode = IOCB_CMD_PREAD;
-		iocb.aio_buf = (unsigned long) &c;
-		iocb.aio_nbytes = sizeof(c);
-		err = io_submit(ctx, 1, &iocbp);
+		iocbp->aio_lio_opcode = IOCB_CMD_PREAD;
+		iocbp->aio_buf = (unsigned long) &c;
+		iocbp->aio_nbytes = sizeof(c);
 		break;
 	default:
-		printk("Bogus op in do_aio - %d\n", type);
-		err = -EINVAL;
-		break;
+		printk(UM_KERN_ERR "Bogus op in do_aio - %d\n", type);
+		return -EINVAL;
 	}
 
-	if(err > 0)
-		err = 0;
-	else
-		err = -errno;
-
-	return err;
+	return (io_submit(ctx, 1, &iocbp) > 0) ? 0 : -errno;
 }
 
 /* Initialized in an initcall and unchanged thereafter */
