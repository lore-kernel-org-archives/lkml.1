Return-Path: <linux-kernel-owner+w=401wt.eu-S2992461AbXCPAaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992461AbXCPAaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXCPA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:26:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47115 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbXCPA0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:26:45 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Date: Thu, 15 Mar 2007 17:22:15 -0700
Subject: [patch 13/13] signal/timer/event fds v6 - KAIO eventfd support example ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.9367.1174004542.13>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an example about how to add eventfd support to the current KAIO code,
in order to enable KAIO to post readiness events to a pollable fd
(hence compatible with POSIX select/poll). The KAIO code simply signals
the eventfd fd when events are ready, and this triggers a POLLIN in the fd.
This patch uses a reserved for future use member of the struct iocb to pass
an eventfd file descriptor, that KAIO will use to post events every time
a request completes. At that point, an aio_getevents() will return the
completed result to a struct io_event.
I made a quick test program to verify the patch, and it runs fine here:

http://www.xmailserver.org/eventfd-aio-test.c

The test program uses poll(2), but it'd, of course, work with select and
epoll too.
This can allow to schedule both block I/O and other poll-able devices requests,
and wait for results using select/poll/epoll.




Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.21-rc3.quilt/fs/aio.c
===================================================================
--- linux-2.6.21-rc3.quilt.orig/fs/aio.c	2007-03-15 15:52:45.000000000 -0700
+++ linux-2.6.21-rc3.quilt/fs/aio.c	2007-03-15 17:15:20.000000000 -0700
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#include <linux/eventfd.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -421,6 +422,7 @@
 	req->private = NULL;
 	req->ki_iovec = NULL;
 	INIT_LIST_HEAD(&req->ki_run_list);
+	req->ki_eventfd = ERR_PTR(-EINVAL);
 
 	/* Check if the completion queue has enough free space to
 	 * accept an event from this io.
@@ -462,6 +464,8 @@
 {
 	assert_spin_locked(&ctx->ctx_lock);
 
+	if (!IS_ERR(req->ki_eventfd))
+		fput(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
 	if (req->ki_iovec != &req->ki_inline_vec)
@@ -946,6 +950,14 @@
 		return 1;
 	}
 
+	/*
+	 * Check if the user asked us to deliver the result through an
+	 * eventfd. The eventfd_signal() function is safe to be called
+	 * from IRQ context.
+	 */
+	if (unlikely(!IS_ERR(iocb->ki_eventfd)))
+		eventfd_signal(iocb->ki_eventfd, 1);
+
 	info = &ctx->ring_info;
 
 	/* add a completion event to the ring buffer.
@@ -1555,6 +1567,19 @@
 		fput(file);
 		return -EAGAIN;
 	}
+	if (iocb->aio_resfd != 0) {
+		/*
+		 * If the aio_resfd field of the iocb is not zero, get an
+		 * instance of the file* now. The file descriptor must be
+		 * an eventfd() fd, and will be signaled for each completed
+		 * event using the eventfd_signal() function.
+		 */
+		req->ki_eventfd = eventfd_fget((int) iocb->aio_resfd);
+		if (IS_ERR(req->ki_eventfd)) {
+			ret = PTR_ERR(req->ki_eventfd);
+			goto out_put_req;
+		}
+	}
 
 	req->ki_filp = file;
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
Index: linux-2.6.21-rc3.quilt/include/linux/aio.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/aio.h	2007-03-15 15:52:45.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/linux/aio.h	2007-03-15 16:13:45.000000000 -0700
@@ -119,6 +119,12 @@
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
+
+	/*
+	 * If the aio_resfd field of the userspace iocb is not zero,
+	 * this is the underlying file* to deliver event to.
+	 */
+	struct file		*ki_eventfd;
 };
 
 #define is_sync_kiocb(iocb)	((iocb)->ki_key == KIOCB_SYNC_KEY)
Index: linux-2.6.21-rc3.quilt/include/linux/aio_abi.h
===================================================================
--- linux-2.6.21-rc3.quilt.orig/include/linux/aio_abi.h	2007-03-15 15:52:45.000000000 -0700
+++ linux-2.6.21-rc3.quilt/include/linux/aio_abi.h	2007-03-15 16:13:45.000000000 -0700
@@ -84,7 +84,11 @@
 
 	/* extra parameters */
 	__u64	aio_reserved2;	/* TODO: use this for a (struct sigevent *) */
-	__u64	aio_reserved3;
+	__u32	aio_reserved3;
+	/*
+	 * If different from 0, this is an eventfd to deliver AIO results to
+	 */
+	__u32	aio_resfd;
 }; /* 64 bytes */
 
 #undef IFBIG

