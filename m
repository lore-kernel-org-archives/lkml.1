Return-Path: <linux-kernel-owner+w=401wt.eu-S1764867AbXGaU07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764867AbXGaU07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbXGaUZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:25:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761283AbXGaUZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:25:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/14] FS-Cache: Provide an add_wait_queue_tail() function
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 21:25:10 +0100
Message-ID: <20070731202510.6412.60155.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com>
References: <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an add_wait_queue_tail() function to add a waiter to the back of a
wait queue instead of the front.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/wait.h |    1 +
 kernel/wait.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0e68628..4cae7db 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -118,6 +118,7 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 #define is_sync_wait(wait)	(!(wait) || ((wait)->private))
 
 extern void FASTCALL(add_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
+extern void FASTCALL(add_wait_queue_tail(wait_queue_head_t *q, wait_queue_t * wait));
 extern void FASTCALL(add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t * wait));
 extern void FASTCALL(remove_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
 
diff --git a/kernel/wait.c b/kernel/wait.c
index 444ddbf..7acc9cc 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -29,6 +29,24 @@ void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 }
 EXPORT_SYMBOL(add_wait_queue);
 
+/**
+ * add_wait_queue_tail - Add a waiter to the back of a waitqueue
+ * @q: the wait queue to append the waiter to
+ * @wait: the waiter to be queued
+ *
+ * Add a waiter to the back of a waitqueue so that it gets woken up last.
+ */
+void fastcall add_wait_queue_tail(wait_queue_head_t *q, wait_queue_t *wait)
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
 void fastcall add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;

