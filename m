Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZFRRpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZFRRpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZFRRoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:44:44 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59672 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbZFRRon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:44:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH 4/4] eventfd: add module reference counting support for
	registered notifiers
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, mingo@elte.hu,
       mst@redhat.com, avi@redhat.com, paulmck@linux.vnet.ibm.com,
       rusty@rustcorp.com.au
Date: Thu, 18 Jun 2009 13:44:32 -0400
Message-ID: <20090618174431.24119.86543.stgit@dev.haskins.net>
In-Reply-To: <20090618173534.24119.95115.stgit@dev.haskins.net>
References: <20090618173534.24119.95115.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tsirkin found a race condition in the irqfd code where we may
allow the underlying eventfd object to race with the rmmod of kvm.ko.

Since we now use eventfd_notifier for irqfd, lets add a struct module *owner
field to properly maintain references to our registered signal handlers.

Found-by: Michael S. Tsirkin <mst@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 fs/eventfd.c            |    8 ++++++++
 include/linux/eventfd.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index f9d7e1d..4a073ee 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -260,6 +260,8 @@ static int eventfd_notifier_wakeup(wait_queue_t *wait, unsigned mode,
 		en->ops->signal(en);
 
 	if (flags & POLLHUP) {
+		struct module *owner = en->owner;
+
 		/*
 		 * The POLLHUP is called unlocked, so it theoretically should
 		 * be safe to remove ourselves from the wqh using the locked
@@ -267,6 +269,8 @@ static int eventfd_notifier_wakeup(wait_queue_t *wait, unsigned mode,
 		 */
 		remove_wait_queue(en->wqh, &en->wait);
 		en->ops->release(en);
+
+		module_put(owner);
 	}
 
 	return 0;
@@ -291,6 +295,9 @@ int eventfd_notifier_register(struct file *file, struct eventfd_notifier *en)
 	if (file->f_op != &eventfd_fops)
 		return -EINVAL;
 
+	if (!try_module_get(en->owner))
+		return -EINVAL;
+
 	/*
 	 * Install our own custom wake-up handling so we are notified via
 	 * a callback whenever someone signals the underlying eventfd
@@ -310,6 +317,7 @@ int eventfd_notifier_unregister(struct file *file, struct eventfd_notifier *en)
 		return -EINVAL;
 
 	remove_wait_queue(en->wqh, &en->wait);
+	module_put(en->owner);
 
 	return 0;
 }
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 802b59d..7e015f0 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -12,6 +12,7 @@
 #include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/list.h>
+#include <linux/module.h>
 
 struct eventfd_notifier;
 
@@ -21,6 +22,7 @@ struct eventfd_notifier_ops {
 };
 
 struct eventfd_notifier {
+	struct module                     *owner;
 	poll_table                         pt;
 	wait_queue_head_t                 *wqh;
 	wait_queue_t                       wait;
@@ -31,6 +33,7 @@ static inline void eventfd_notifier_init(struct eventfd_notifier *en,
 					 const struct eventfd_notifier_ops *ops)
 {
 	memset(en, 0, sizeof(*en));
+	en->owner = THIS_MODULE;
 	en->ops = ops;
 }
 

