Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYKTOph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYKTOph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYKTOmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:42:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40996 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbYKTOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:42:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/45] FS-Cache: Provide an add_wait_queue_tail() function
	[ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:42:16 +0000
Message-ID: <20081120144215.10667.81594.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an add_wait_queue_tail() function to add a waiter to the back of a
wait queue instead of the front.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/wait.h |    1 +
 kernel/wait.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)


diff --git a/include/linux/wait.h b/include/linux/wait.h
index ef609f8..f35de07 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -109,6 +109,7 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 }
 
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
+extern void add_wait_queue_tail(wait_queue_head_t *q, wait_queue_t *wait);
 extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
 extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 
diff --git a/kernel/wait.c b/kernel/wait.c
index cd87131..e2475af 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -29,6 +29,24 @@ void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 }
 EXPORT_SYMBOL(add_wait_queue);
 
+/**
+ * add_wait_queue_tail - Add a waiter to the back of a waitqueue
+ * @q: the wait queue to append the waiter to
+ * @wait: the waiter to be queued
+ *
+ * Add a waiter to the back of a waitqueue so that it gets woken up last.
+ */
+void add_wait_queue_tail(wait_queue_head_t *q, wait_queue_t *wait)
+{
+	unsigned long flags;
+
+	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
+	spin_lock_irqsave(&q->lock, flags);
+	__add_wait_queue_tail(q, wait);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(add_wait_queue_tail);
+
 void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;

