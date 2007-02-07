Return-Path: <linux-kernel-owner+w=401wt.eu-S1422922AbXBGT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422922AbXBGT4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161430AbXBGTzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:55:47 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34307 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422907AbXBGTzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:55:04 -0500
Message-Id: <200702071947.l17JlqLf006630@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 7/7] UML - AIO locking and tidying
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 07 Feb 2007 14:47:52 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Comment the lack of locking of data that's set up once at boot time.

Also fixed a couple of bogus printks.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/aio.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6.18-mm/arch/um/os-Linux/aio.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/aio.c	2007-01-09 17:08:52.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/aio.c	2007-01-09 17:10:54.000000000 -0500
@@ -24,9 +24,6 @@ struct aio_thread_req {
 	struct aio_context *aio;
 };
 
-static int aio_req_fd_r = -1;
-static int aio_req_fd_w = -1;
-
 #if defined(HAVE_AIO_ABI)
 #include <linux/aio_abi.h>
 
@@ -111,6 +108,7 @@ static int do_aio(aio_context_t ctx, enu
 	return err;
 }
 
+/* Initialized in an initcall and unchanged thereafter */
 static aio_context_t ctx = 0;
 
 static int aio_thread(void *arg)
@@ -137,7 +135,7 @@ static int aio_thread(void *arg)
 			err = os_write_file(reply_fd, &reply, sizeof(reply));
 			if(err != sizeof(reply))
 				printk("aio_thread - write failed, fd = %d, "
-				       "err = %d\n", aio_req_fd_r, -err);
+				       "err = %d\n", reply_fd, -err);
 		}
 	}
 	return 0;
@@ -182,6 +180,11 @@ out:
 	return err;
 }
 
+/* These are initialized in initcalls and not changed */
+static int aio_req_fd_r = -1;
+static int aio_req_fd_w = -1;
+static int aio_pid = -1;
+
 static int not_aio_thread(void *arg)
 {
 	struct aio_thread_req req;
@@ -208,14 +211,12 @@ static int not_aio_thread(void *arg)
 		err = os_write_file(req.aio->reply_fd, &reply, sizeof(reply));
 		if(err != sizeof(reply))
 			printk("not_aio_thread - write failed, fd = %d, "
-			       "err = %d\n", aio_req_fd_r, -err);
+			       "err = %d\n", req.aio->reply_fd, -err);
 	}
 
 	return 0;
 }
 
-static int aio_pid = -1;
-
 static int init_aio_24(void)
 {
 	unsigned long stack;
@@ -308,6 +309,7 @@ static int submit_aio_26(enum aio_type t
 }
 #endif
 
+/* Initialized in an initcall and unchanged thereafter */
 static int aio_24 = DEFAULT_24_AIO;
 
 static int __init set_aio_24(char *name, int *add)

