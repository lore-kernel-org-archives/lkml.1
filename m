Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbXLETpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbXLETpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbXLETjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:39:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbXLETjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:39:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/28] FS-Cache: Provide an add_wait_queue_tail() function
	[try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:39:14 +0000
Message-ID: <20071205193914.24617.17716.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
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

 include/linux/wait.h |    2 ++
 kernel/wait.c        |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0e68628..f1038d0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -118,6 +118,8 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 #define is_sync_wait(wait)	(!(wait) || ((wait)->private))
 
 extern void FASTCALL(add_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
+extern void FASTCALL(add_wait_queue_tail(wait_queue_head_t *q,
+					 wait_queue_t *wait));
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

