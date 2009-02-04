Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZBDW6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZBDW6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZBDW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:58:41 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39796 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZBDW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:58:40 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Feb 2009 14:58:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [patch/rfc] eventfd semaphore-like behavior
Message-ID: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People started using eventfd in scnarios where before where using pipes. 
Many of them use eventfds in a semaphore-like way, like they were before 
with pipes. The problem with eventfd is that a read() on the fd returns 
and wipes the whole counter, making the use of it as semaphore a little 
bit more cumbersome. You can do a read() followed by a write() of 
COUNTER-1, but IMO it's pretty easy and cheap to make this work w/out 
extra steps. This patch introduces a new eventfd flag that tells eventfd 
to only dequeue 1 from the counter, allowing simple read/write to make it 
behave like a semaphore.
Simple test here:

http://www.xmailserver.org/eventfd-sem.c


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventfd.c            |   20 +++++++++++---------
 include/linux/eventfd.h |   12 +++++++++++-
 2 files changed, 22 insertions(+), 10 deletions(-)

Index: linux-2.6.mod/fs/eventfd.c
===================================================================
--- linux-2.6.mod.orig/fs/eventfd.c	2009-02-03 18:13:33.000000000 -0800
+++ linux-2.6.mod/fs/eventfd.c	2009-02-04 12:16:39.000000000 -0800
@@ -28,6 +28,7 @@ struct eventfd_ctx {
 	 * issue a wakeup.
 	 */
 	__u64 count;
+	unsigned int flags;
 };
 
 /*
@@ -87,22 +88,20 @@ static ssize_t eventfd_read(struct file 
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	ssize_t res;
-	__u64 ucnt;
+	__u64 ucnt = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ucnt))
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
-	ucnt = ctx->count;
-	if (ucnt > 0)
+	if (ctx->count > 0)
 		res = sizeof(ucnt);
 	else if (!(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (ctx->count > 0) {
-				ucnt = ctx->count;
 				res = sizeof(ucnt);
 				break;
 			}
@@ -117,8 +116,9 @@ static ssize_t eventfd_read(struct file 
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (res > 0) {
-		ctx->count = 0;
+	if (likely(res > 0)) {
+		ucnt = (ctx->flags & EFD_SEMAPHORE) ? 1 : ctx->count;
+		ctx->count -= ucnt;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLOUT);
 	}
@@ -166,7 +166,7 @@ static ssize_t eventfd_write(struct file
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (res > 0) {
+	if (likely(res > 0)) {
 		ctx->count += ucnt;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLIN);
@@ -207,7 +207,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(EFD_CLOEXEC | EFD_NONBLOCK))
+	if (flags & ~EFD_FLAGS_SET)
 		return -EINVAL;
 
 	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
@@ -216,13 +216,14 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, 
 
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
+	ctx->flags = flags;
 
 	/*
 	 * When we call this, the initialization must be complete, since
 	 * anon_inode_getfd() will install the fd.
 	 */
 	fd = anon_inode_getfd("[eventfd]", &eventfd_fops, ctx,
-			      flags & (O_CLOEXEC | O_NONBLOCK));
+			      flags & EFD_SHARED_FCNTL_FLAGS);
 	if (fd < 0)
 		kfree(ctx);
 	return fd;
@@ -232,3 +233,4 @@ SYSCALL_DEFINE1(eventfd, unsigned int, c
 {
 	return sys_eventfd2(count, 0);
 }
+
Index: linux-2.6.mod/include/linux/eventfd.h
===================================================================
--- linux-2.6.mod.orig/include/linux/eventfd.h	2009-02-03 18:13:33.000000000 -0800
+++ linux-2.6.mod/include/linux/eventfd.h	2009-02-04 12:16:32.000000000 -0800
@@ -13,10 +13,20 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
-/* Flags for eventfd2.  */
+/*
+ * CAREFUL: Check include/asm-generic/fcntl.h when defining
+ * new flags, since they might collide with O_* ones. We want
+ * to re-use O_* flags that couldn't possibly have a meaning
+ * from eventfd, in order to leave a free define-space for
+ * shared O_* flags.
+ */
+#define EFD_SEMAPHORE (1 << 0)
 #define EFD_CLOEXEC O_CLOEXEC
 #define EFD_NONBLOCK O_NONBLOCK
 
+#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
+#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
+
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
 
