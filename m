Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbZFPCaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbZFPCaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 22:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763334AbZFPCaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 22:30:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55616 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763100AbZFPCaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 22:30:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM-RFC PATCH 2/2] eventfd: add module reference counting support
	for registered notifiers
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mst@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com
Date: Mon, 15 Jun 2009 22:30:02 -0400
Message-ID: <20090616023001.23890.10136.stgit@dev.haskins.net>
In-Reply-To: <20090616022041.23890.90120.stgit@dev.haskins.net>
References: <20090616022041.23890.90120.stgit@dev.haskins.net>
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
index 505d5de..babedb3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -108,9 +108,12 @@ static int eventfd_release(struct inode *inode, struct file *file)
 	 * path
 	 */
 	list_for_each_entry_safe(en, tmp, &ctx->nh, list) {
+		struct module *owner = en->owner;
+
 		list_del(&en->list);
 		if (en->ops->release)
 			en->ops->release(en);
+		module_put(owner);
 	}
 
 	synchronize_srcu(&ctx->srcu);
@@ -261,6 +264,9 @@ static int _eventfd_notifier_register(struct eventfd_ctx *ctx,
 {
 	unsigned long flags;
 
+	if (!try_module_get(en->owner))
+		return -EINVAL;
+
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	list_add_tail_rcu(&en->list, &ctx->nh);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
@@ -292,6 +298,8 @@ int eventfd_notifier_unregister(struct file *file, struct eventfd_notifier *en)
 
 	synchronize_srcu(&ctx->srcu);
 
+	module_put(en->owner);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(eventfd_notifier_unregister);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 0218cf6..f534bcd 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -9,6 +9,7 @@
 #define _LINUX_EVENTFD_H
 
 #include <linux/list.h>
+#include <linux/module.h>
 
 struct eventfd_notifier;
 
@@ -18,6 +19,7 @@ struct eventfd_notifier_ops {
 };
 
 struct eventfd_notifier {
+	struct module                     *owner;
 	struct list_head                   list;
 	const struct eventfd_notifier_ops *ops;
 };
@@ -26,6 +28,7 @@ static inline void eventfd_notifier_init(struct eventfd_notifier *en,
 					 const struct eventfd_notifier_ops *ops)
 {
 	memset(en, 0, sizeof(*en));
+	en->owner = THIS_MODULE;
 	INIT_LIST_HEAD(&en->list);
 	en->ops = ops;
 }

