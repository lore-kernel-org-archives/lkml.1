Return-Path: <linux-kernel-owner+w=401wt.eu-S934153AbYD3X7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbYD3X7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765521AbYD3X6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:16 -0400
Received: from mail.suse.de ([195.135.220.2]:47436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761616AbYD3X6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/11] klist: implement klist_add_{after|before}()
Date: Wed, 30 Apr 2008 16:57:42 -0700
Message-Id: <1209599870-22919-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Add klist_add_after() and klist_add_before() which puts a new node
after and before an existing node, respectively.  This is useful for
callers which need to keep klist ordered.  Note that synchronizing
between simultaneous additions for ordering is the caller's
responsibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/klist.h |    2 ++
 lib/klist.c           |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index a119c0d..b49385f 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -46,6 +46,8 @@ struct klist_node {
 
 extern void klist_add_tail(struct klist_node * n, struct klist * k);
 extern void klist_add_head(struct klist_node * n, struct klist * k);
+extern void klist_add_after(struct klist_node *n, struct klist_node *pos);
+extern void klist_add_before(struct klist_node *n, struct klist_node *pos);
 
 extern void klist_del(struct klist_node * n);
 extern void klist_remove(struct klist_node * n);
diff --git a/lib/klist.c b/lib/klist.c
index 120bd17..ebba948 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -120,6 +120,39 @@ void klist_add_tail(struct klist_node * n, struct klist * k)
 EXPORT_SYMBOL_GPL(klist_add_tail);
 
 
+/**
+ * klist_add_after - Init a klist_node and add it after an existing node
+ * @n: node we're adding.
+ * @pos: node to put @n after
+ */
+void klist_add_after(struct klist_node *n, struct klist_node *pos)
+{
+	struct klist *k = pos->n_klist;
+
+	klist_node_init(k, n);
+	spin_lock(&k->k_lock);
+	list_add(&n->n_node, &pos->n_node);
+	spin_unlock(&k->k_lock);
+}
+EXPORT_SYMBOL_GPL(klist_add_after);
+
+/**
+ * klist_add_before - Init a klist_node and add it before an existing node
+ * @n: node we're adding.
+ * @pos: node to put @n after
+ */
+void klist_add_before(struct klist_node *n, struct klist_node *pos)
+{
+	struct klist *k = pos->n_klist;
+
+	klist_node_init(k, n);
+	spin_lock(&k->k_lock);
+	list_add_tail(&n->n_node, &pos->n_node);
+	spin_unlock(&k->k_lock);
+}
+EXPORT_SYMBOL_GPL(klist_add_before);
+
+
 static void klist_release(struct kref * kref)
 {
 	struct klist_node * n = container_of(kref, struct klist_node, n_ref);
-- 
1.5.5.1

