Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZDWPPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZDWPPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZDWPOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:14:43 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43631 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbZDWPOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:14:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 2/3] eventfd: add a notifier mechanism
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org
Date: Thu, 23 Apr 2009 11:14:36 -0400
Message-ID: <20090423151436.14094.35875.stgit@dev.haskins.net>
In-Reply-To: <20090423150910.14094.73708.stgit@dev.haskins.net>
References: <20090423150910.14094.73708.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows synchronous notifications to register with the eventfd
infrastructure.  Unlike traditional vfs based eventfd readers, notifiees
do not implictly clear the counter on reception.  However, the clearing
is primarily important to allowing threads to block waiting for events
anyway, so its an acceptable trade-off since blocking doesn't apply to
notifiers.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c            |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/eventfd.h |    8 +++++++
 2 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 3f0e197..1a54bd9 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -17,6 +17,7 @@
 #include <linux/eventfd.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 
 struct eventfd_ctx {
 	wait_queue_head_t wqh;
@@ -30,6 +31,7 @@ struct eventfd_ctx {
 	 */
 	__u64 count;
 	unsigned int flags;
+	struct raw_notifier_head notifier;
 };
 
 /*
@@ -48,6 +50,9 @@ int eventfd_signal(struct file *file, int n)
 	if (n < 0)
 		return -EINVAL;
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
+
+	raw_notifier_call_chain(&ctx->notifier, 0, 0);
+
 	if (ULLONG_MAX - ctx->count < n)
 		n = (int) (ULLONG_MAX - ctx->count);
 	ctx->count += n;
@@ -169,6 +174,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		__set_current_state(TASK_RUNNING);
 	}
 	if (likely(res > 0)) {
+		raw_notifier_call_chain(&ctx->notifier, 0, 0);
 		ctx->count += ucnt;
 		if (waitqueue_active(&ctx->wqh))
 			wake_up_locked_poll(&ctx->wqh, POLLIN);
@@ -201,6 +207,50 @@ struct file *eventfd_fget(int fd)
 }
 EXPORT_SYMBOL_GPL(eventfd_fget);
 
+struct file *eventfd_notifier_register(int fd, struct notifier_block *nb)
+{
+	struct file *file = eventfd_fget(fd);
+	struct eventfd_ctx *ctx;
+	unsigned long flags;
+	int ret;
+
+	if (IS_ERR(file))
+		return file;
+
+	ctx = file->private_data;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	ret = raw_notifier_chain_register(&ctx->notifier, nb);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+
+	if (ret < 0) {
+		fput(file);
+		return ERR_PTR(ret);
+	}
+
+	return file;
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_register);
+
+int eventfd_notifier_unregister(struct file *file, struct notifier_block *nb)
+{
+	struct eventfd_ctx *ctx;
+	unsigned long flags;
+	int ret;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+
+	ctx = file->private_data;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	ret = raw_notifier_chain_unregister(&ctx->notifier, nb);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_unregister);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	int fd;
@@ -220,6 +270,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 	init_waitqueue_head(&ctx->wqh);
 	ctx->count = count;
 	ctx->flags = flags;
+	RAW_INIT_NOTIFIER_HEAD(&ctx->notifier);
 
 	/*
 	 * When we call this, the initialization must be complete, since
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index f45a8ae..e13d1c5 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+#include <linux/notifier.h>
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -29,12 +31,18 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+struct file *eventfd_notifier_register(int fd, struct notifier_block *nb);
+int eventfd_notifier_unregister(struct file *file, struct notifier_block *nb);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+static inline int eventfd_notifier_register(int fd, struct notifier_block *nb)
+{ return -ENOENT; }
+static inline int eventfd_notifier_unregister(int fd, struct notifier_block *nb)
+{ return -ENOENT; }
 
 #endif /* CONFIG_EVENTFD */
 

