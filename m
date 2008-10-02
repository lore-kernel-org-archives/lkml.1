Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYJBVnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYJBVnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYJBVna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:43:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39076 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbYJBVn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:43:29 -0400
Date: Thu, 2 Oct 2008 15:43:08 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove completion from struct klist_node
Message-ID: <20081002214308.GP13822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removing the completion from klist_node reduces its size from 64 bytes
to 28 on x86-64.  To maintain the semantics of klist_remove(), we add
a single list of klist nodes which are pending deletion and scan them.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

 include/linux/klist.h |    2 --
 lib/klist.c           |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index 06c338e..989a335 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -13,7 +13,6 @@
 #define _LINUX_KLIST_H
 
 #include <linux/spinlock.h>
-#include <linux/completion.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 
@@ -41,7 +40,6 @@ struct klist_node {
 	struct klist		*n_klist;
 	struct list_head	n_node;
 	struct kref		n_ref;
-	struct completion	n_removed;
 };
 
 extern void klist_add_tail(struct klist_node *n, struct klist *k);
diff --git a/lib/klist.c b/lib/klist.c
index cca37f9..2b609ee 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -36,7 +36,7 @@
 
 #include <linux/klist.h>
 #include <linux/module.h>
-
+#include <linux/sched.h>
 
 /**
  * klist_init - Initialize a klist structure.
@@ -77,7 +77,6 @@ static void add_tail(struct klist *k, struct klist_node *n)
 static void klist_node_init(struct klist *k, struct klist_node *n)
 {
 	INIT_LIST_HEAD(&n->n_node);
-	init_completion(&n->n_removed);
 	kref_init(&n->n_ref);
 	n->n_klist = k;
 	if (k->get)
@@ -140,12 +139,36 @@ void klist_add_before(struct klist_node *n, struct klist_node *pos)
 }
 EXPORT_SYMBOL_GPL(klist_add_before);
 
+struct klist_waiter {
+	struct klist_waiter *next;
+	struct klist_node *node;
+	struct task_struct *process;
+	int woken;
+};
+
+static DEFINE_SPINLOCK(klist_remove_lock);
+static struct klist_waiter *klist_remove_waiters;
+
 static void klist_release(struct kref *kref)
 {
+	struct klist_waiter **pprev, *this;
 	struct klist_node *n = container_of(kref, struct klist_node, n_ref);
 
 	list_del(&n->n_node);
-	complete(&n->n_removed);
+	spin_lock(&klist_remove_lock);
+	pprev = &klist_remove_waiters;
+	while ((this = *pprev)) {
+		if (this->node != n) {
+			pprev = &this->next;
+			continue;
+		}
+
+		this->woken = 1;
+		mb();
+		wake_up_process(this->process);
+		*pprev = this->next;
+	}
+	spin_unlock(&klist_remove_lock);
 	n->n_klist = NULL;
 }
 
@@ -178,8 +201,25 @@ EXPORT_SYMBOL_GPL(klist_del);
  */
 void klist_remove(struct klist_node *n)
 {
+	struct klist_waiter waiter;
+
+	waiter.node = n;
+	waiter.process = current;
+	waiter.woken = 0;
+	spin_lock(&klist_remove_lock);
+	waiter.next = klist_remove_waiters;
+	klist_remove_waiters = &waiter;
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
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
