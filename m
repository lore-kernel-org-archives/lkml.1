Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZFSSwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZFSSwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbZFSSvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 14:51:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48457 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZFSSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 14:51:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/3] eventfd: add generalized notifier interface
To: davidel@xmailserver.org
Cc: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Date: Fri, 19 Jun 2009 14:51:33 -0400
Message-ID: <20090619185132.31118.62483.stgit@dev.haskins.net>
In-Reply-To: <20090619183534.31118.30934.stgit@dev.haskins.net>
References: <20090619183534.31118.30934.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users that want to register for signal notifications with eventfd have
several choices today:  They can do a standard sleep+wakeup against a
->read(), or they can provide their own wakeup handling using the wait-queue
callback mechanism coupled with the the eventfd->poll() interface.

In fact, Davide recently published a patch that allows eventfd to transmit
a "release" event when the underlying eventfd is closed via a POLLHUP
wakeup. This type of event is extremely useful for in-kernel notification
clients. However the wait-queue based notification interface alone is not
sufficient to use this new information race-free since it requires
operating lockless and referenceless.  We need to track some additional
data that is independent of the file* pointer, since we need
f_ops->release() to still function.

Therefore, this patch lays the groundwork to try and fix these issues. It
accomplishes this by abstracting eventfd's wait-queue based notification
interface behind eventfd specific register()/unregister() verbs.  It also
provides an eventfd specific object (eventfd_notifier) that is intended to
be embedded in the client, but used by eventfd to track proper state.

We will use this interface later in the series to fix the current races.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Davide Libenzi <davidel@xmailserver.org>
CC: Michael S. Tsirkin <mst@redhat.com>
---

 fs/eventfd.c            |   64 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/eventfd.h |   33 ++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index c71f51d..3d7fb16 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -242,3 +242,67 @@ SYSCALL_DEFINE1(eventfd, unsigned int, count)
 	return sys_eventfd2(count, 0);
 }
 
+static int eventfd_notifier_wakeup(wait_queue_t *wait, unsigned mode,
+				   int sync, void *key)
+{
+	struct eventfd_notifier *en;
+	unsigned long flags = (unsigned long)key;
+
+	en = container_of(wait, struct eventfd_notifier, wait);
+
+	if (flags & POLLIN)
+		/*
+		 * The POLLIN wake_up is called with interrupts disabled.
+		 */
+		en->ops->signal(en);
+
+	if (flags & POLLHUP) {
+		/*
+		 * The POLLHUP is called unlocked, so it theoretically should
+		 * be safe to remove ourselves from the wqh using the locked
+		 * variant of remove_wait_queue()
+		 */
+		remove_wait_queue(en->wqh, &en->wait);
+		en->ops->release(en);
+	}
+
+	return 0;
+}
+
+static void eventfd_notifier_ptable_enqueue(struct file *file,
+					    wait_queue_head_t *wqh,
+					    poll_table *pt)
+{
+	struct eventfd_notifier *en;
+
+	en = container_of(pt, struct eventfd_notifier, pt);
+
+	en->wqh = wqh;
+	add_wait_queue(wqh, &en->wait);
+}
+
+int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en)
+{
+	unsigned int events;
+
+	if (file->f_op != &eventfd_fops)
+		return -EINVAL;
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd
+	 */
+	init_waitqueue_func_entry(&en->wait, eventfd_notifier_wakeup);
+	init_poll_funcptr(&en->pt, eventfd_notifier_ptable_enqueue);
+
+	events = file->f_op->poll(file, &en->pt);
+
+	return (events & POLLIN) ? 1 : 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_register);
+
+void eventfd_notifier_unregister(struct eventfd_notifier *en)
+{
+	remove_wait_queue(en->wqh, &en->wait);
+}
+EXPORT_SYMBOL_GPL(eventfd_notifier_unregister);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index f45a8ae..cb23969 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -8,6 +8,32 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/file.h>
+#include <linux/list.h>
+
+struct eventfd_notifier;
+
+struct eventfd_notifier_ops {
+	void (*signal)(struct eventfd_notifier *en);
+	void (*release)(struct eventfd_notifier *en);
+};
+
+struct eventfd_notifier {
+	poll_table                         pt;
+	wait_queue_head_t                 *wqh;
+	wait_queue_t                       wait;
+	const struct eventfd_notifier_ops *ops;
+};
+
+static inline void eventfd_notifier_init(struct eventfd_notifier *en,
+					 const struct eventfd_notifier_ops *ops)
+{
+	memset(en, 0, sizeof(*en));
+	en->ops = ops;
+}
+
 #ifdef CONFIG_EVENTFD
 
 /* For O_CLOEXEC and O_NONBLOCK */
@@ -29,12 +55,19 @@
 
 struct file *eventfd_fget(int fd);
 int eventfd_signal(struct file *file, int n);
+int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en);
+void eventfd_notifier_unregister(struct eventfd_notifier *en);
 
 #else /* CONFIG_EVENTFD */
 
 #define eventfd_fget(fd) ERR_PTR(-ENOSYS)
 static inline int eventfd_signal(struct file *file, int n)
 { return 0; }
+static inline int eventfd_notifier_register(struct file *file,
+					    struct eventfd_notifier *en)
+{ return -ENOSYS; }
+static inline int eventfd_notifier_unregister(struct eventfd_notifier *en)
+{ return -ENOSYS; }
 
 #endif /* CONFIG_EVENTFD */
 

