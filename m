Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZHJMrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZHJMrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZHJMrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:47:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:58194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbZHJMq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:46:59 -0400
Date: Mon, 10 Aug 2009 12:46:12 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tiwai@suse.de,
       dhowells@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, tiwai@suse.de, mingo@elte.hu
In-Reply-To: <20090810113305.17284.81508.stgit@warthog.procyon.org.uk>
References: <20090810113305.17284.81508.stgit@warthog.procyon.org.uk>
Subject: [tip:core/urgent] locking, sched: Give waitqueue spinlocks their own lockdep classes
Message-ID: <tip-2fc391112fb6f3424435a3aa2fda887497b5f807@git.kernel.org>
Git-Commit-ID: 2fc391112fb6f3424435a3aa2fda887497b5f807
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 12:46:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fc391112fb6f3424435a3aa2fda887497b5f807
Gitweb:     http://git.kernel.org/tip/2fc391112fb6f3424435a3aa2fda887497b5f807
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 10 Aug 2009 12:33:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 14:43:09 +0200

locking, sched: Give waitqueue spinlocks their own lockdep classes

Give waitqueue spinlocks their own lockdep classes when they
are initialised from init_waitqueue_head().  This means that
struct wait_queue::func functions can operate other waitqueues.

This is used by CacheFiles to catch the page from a backing fs
being unlocked and to wake up another thread to take a copy of
it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Cc: linux-cachefs@redhat.com
Cc: torvalds@osdl.org
Cc: akpm@linux-foundation.org
LKML-Reference: <20090810113305.17284.81508.stgit@warthog.procyon.org.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
