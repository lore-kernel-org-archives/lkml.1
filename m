Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZAFWOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZAFWOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZAFWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:22 -0500
Received: from kroah.org ([198.145.64.141]:51172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751481AbZAFWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/60] driver core: Remove completion from struct klist_node
Date: Tue,  6 Jan 2009 14:11:23 -0800
Message-Id: <1231279939-32728-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

Removing the completion from klist_node reduces its size from 64 bytes
to 28 on x86-64.  To maintain the semantics of klist_remove(), we add
a single list of klist nodes which are pending deletion and scan them.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/klist.h |    2 --
 lib/klist.c           |   43 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index 8ea98db..d5a27af 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -13,7 +13,6 @@
 #define _LINUX_KLIST_H
 
 #include <linux/spinlock.h>
-#include <linux/completion.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 
@@ -41,7 +40,6 @@ struct klist_node {
 	void			*n_klist;	/* never access directly */
 	struct list_head	n_node;
 	struct kref		n_ref;
-	struct completion	n_removed;
 };
 
 extern void klist_add_tail(struct klist_node *n, struct klist *k);
diff --git a/lib/klist.c b/lib/klist.c
index bbdd301..573d606 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -36,6 +36,7 @@
 
 #include <linux/klist.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 /*
  * Use the lowest bit of n_klist to mark deleted nodes and exclude
@@ -108,7 +109,6 @@ static void add_tail(struct klist *k, struct klist_node *n)
 static void klist_node_init(struct klist *k, struct klist_node *n)
 {
 	INIT_LIST_HEAD(&n->n_node);
-	init_completion(&n->n_removed);
 	kref_init(&n->n_ref);
 	knode_set_klist(n, k);
 	if (k->get)
@@ -171,13 +171,34 @@ void klist_add_before(struct klist_node *n, struct klist_node *pos)
 }
 EXPORT_SYMBOL_GPL(klist_add_before);
 
+struct klist_waiter {
+	struct list_head list;
+	struct klist_node *node;
+	struct task_struct *process;
+	int woken;
+};
+
+static DEFINE_SPINLOCK(klist_remove_lock);
+static LIST_HEAD(klist_remove_waiters);
+
 static void klist_release(struct kref *kref)
 {
+	struct klist_waiter *waiter, *tmp;
 	struct klist_node *n = container_of(kref, struct klist_node, n_ref);
 
 	WARN_ON(!knode_dead(n));
 	list_del(&n->n_node);
-	complete(&n->n_removed);
+	spin_lock(&klist_remove_lock);
+	list_for_each_entry_safe(waiter, tmp, &klist_remove_waiters, list) {
+		if (waiter->node != n)
+			continue;
+
+		waiter->woken = 1;
+		mb();
+		wake_up_process(waiter->process);
+		list_del(&waiter->list);
+	}
+	spin_unlock(&klist_remove_lock);
 	knode_set_klist(n, NULL);
 }
 
@@ -217,8 +238,24 @@ EXPORT_SYMBOL_GPL(klist_del);
  */
 void klist_remove(struct klist_node *n)
 {
+	struct klist_waiter waiter;
+
+	waiter.node = n;
+	waiter.process = current;
+	waiter.woken = 0;
+	spin_lock(&klist_remove_lock);
+	list_add(&waiter.list, &klist_remove_waiters);
+	spin_unlock(&klist_remove_lock);
+
 	klist_del(n);
-	wait_for_completion(&n->n_removed);
+
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (waiter.woken)
+			break;
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
 }
 EXPORT_SYMBOL_GPL(klist_remove);
 
-- 
1.6.0.4

