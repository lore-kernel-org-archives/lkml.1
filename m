Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZHJLdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZHJLdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 07:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZHJLdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 07:33:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37512 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZHJLdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 07:33:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Give waitqueue spinlocks their own lockdep classes
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Howells <dhowells@redhat.com>
Date: Mon, 10 Aug 2009 12:33:05 +0100
Message-ID: <20090810113305.17284.81508.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Give waitqueue spinlocks their own lockdep classes when they are initialised
from init_waitqueue_head().  This means that struct wait_queue::func functions
can operate other waitqueues.

This is used by CacheFiles to catch the page from a backing fs being unlocked
and to wake up another thread to take a copy of it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
---

 include/linux/wait.h |    9 ++++++++-
 kernel/wait.c        |    5 +++--
 2 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6788e1a..cf3c2f5 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -77,7 +77,14 @@ struct task_struct;
 #define __WAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
-extern void init_waitqueue_head(wait_queue_head_t *q);
+extern void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *);
+
+#define init_waitqueue_head(q)				\
+	do {						\
+		static struct lock_class_key __key;	\
+							\
+		__init_waitqueue_head((q), &__key);	\
+	} while (0)
 
 #ifdef CONFIG_LOCKDEP
 # define __WAIT_QUEUE_HEAD_INIT_ONSTACK(name) \
diff --git a/kernel/wait.c b/kernel/wait.c
index ea7c3b4..c4bd3d8 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -10,13 +10,14 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void init_waitqueue_head(wait_queue_head_t *q)
+void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
+	lockdep_set_class(&q->lock, key);
 	INIT_LIST_HEAD(&q->task_list);
 }
 
-EXPORT_SYMBOL(init_waitqueue_head);
+EXPORT_SYMBOL(__init_waitqueue_head);
 
 void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {

