Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbXCNWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbXCNWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCNWZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:25:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42449 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbXCNWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:24:54 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Date: Wed, 14 Mar 2007 15:19:21 -0700
Subject: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support (example/maybe-broken) ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an example about how to add asyncfd support to the current
KAIO code.
Patch is small and comments says it all about my doubts.
I made a quick test program to verify the patch, and it runs fine here:

http://www.xmailserver.org/asyncfd-aio-test.c

The test program uses poll(2), but it'd, of course, work with epoll too.
This can allow to schedule both block I/O and other poll-able devices
requests, and wait for results using select/poll/epoll.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.20.ep2/fs/aio.c
===================================================================
--- linux-2.6.20.ep2.orig/fs/aio.c	2007-03-14 09:41:42.000000000 -0700
+++ linux-2.6.20.ep2/fs/aio.c	2007-03-14 10:31:53.000000000 -0700
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#include <linux/asyncfd.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -422,6 +423,7 @@
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
+	req->ki_asyncfd = ERR_PTR(-EINVAL);
 
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
@@ -463,6 +465,8 @@
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (!IS_ERR(req->ki_asyncfd))
+		fput(req->ki_asyncfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -947,6 +951,30 @@
 		return 1;
 	}
 
+	/*
+	 * Check if the user asked us to deliver the result through an
+	 * asyncfd. Note that asyncfd_add_results() may sleep. It seems
+	 * OK looking at the code, but I'm not sure since inside a USB driver,
+	 * aio_complete() is called with a spinlock held. !!CHECK
+	 */
+	if (unlikely(!IS_ERR(iocb->ki_asyncfd))) {
+		struct asyncfd_result asr;
+
+		asr.cookie = iocb->ki_user_data;
+		asr.obj = (unsigned long) iocb->ki_obj.user;
+		asr.res = res;
+		asr.res2 = res2;
+		if ((ret = asyncfd_add_results(iocb->ki_asyncfd, &asr, 1)) != 1) {
+			/*
+			 * Here I dunno what to do in case the userspace result
+			 * ring is full, or if -EFAULT is returned. !!CHECK
+			 */
+
+		}
+		spin_lock_irqsave(&ctx->ctx_lock, flags);
+		goto put_rq;
+	}
+
 	info = &ctx->ring_info;
 
 	/* add a completion event to the ring buffer.
@@ -1556,6 +1584,18 @@
 		fput(file);
 		return -EAGAIN;
 	}
+	if (iocb->aio_resfd != 0) {
+		/*
+		 * If the aio_resfd field of the iocb is not zero, get an
+		 * instance of the file* now. This will be the place to deliver
+		 * AIO results to.
+		 */
+		req->ki_asyncfd = asyncfd_fget((int) iocb->aio_resfd);
+		if (IS_ERR(req->ki_asyncfd)) {
+			ret = PTR_ERR(req->ki_asyncfd);
+			goto out_put_req;
+		}
+	}
 
 	req->ki_filp = file;
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
Index: linux-2.6.20.ep2/include/linux/aio.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/aio.h	2007-03-14 09:42:16.000000000 -0700
+++ linux-2.6.20.ep2/include/linux/aio.h	2007-03-14 10:17:24.000000000 -0700
@@ -119,6 +119,12 @@
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
+
+	/*
+	 * If the aio_resfd field of the userspace iocb is not zero,
+	 * this is the underlying file* to deliver event to.
+	 */
+	struct file		*ki_asyncfd;
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
Index: linux-2.6.20.ep2/include/linux/aio_abi.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/aio_abi.h	2007-03-14 09:42:51.000000000 -0700
+++ linux-2.6.20.ep2/include/linux/aio_abi.h	2007-03-14 09:46:11.000000000 -0700
@@ -84,7 +84,11 @@
 
 	/* extra parameters */
 	__u64	aio_reserved2;	/* TODO: use this for a (struct sigevent *) */
-	__u64	aio_reserved3;
+	__u32	aio_reserved3;
+	/*
+	 * If different from 0, this is an asyncfd to deliver AIO results to
+	 */
+	__u32	aio_resfd;
 }; /* 64 bytes */
 
 #undef IFBIG

