Return-Path: <linux-kernel-owner+w=401wt.eu-S933139AbZHDRX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbZHDRX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbZHDRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:23:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57062 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910AbZHDRXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:23:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5hvdmos4i8.wl%tiwai@suse.de>
References: <s5hvdmos4i8.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: dhowells@redhat.com, peterz@infradead.org,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
Date: Tue, 04 Aug 2009 18:23:44 +0100
Message-ID: <3776.1249406624@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Takashi Iwai <tiwai@suse.de> wrote:

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.30-test #7
> -------------------------------------------------------
> swapper/0 is trying to acquire lock:
>  (&cwq->lock){-.-...}, at: [<c01519f3>] __queue_work+0x1f/0x4e
> 
> but task is already holding lock:
>  (&q->lock){-.-.-.}, at: [<c012cc9c>] __wake_up+0x26/0x5c
> 
> which lock already depends on the new lock.
> ...

Can you try the attached patch from Peter Zijlstra?  It should cause the work
queue's waitqueue spinlock to have a separate lockdep class from the page
bit's waitqueue.

David
---
From: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] Give waitqueue spinlocks their own lockdep classes

Give waitqueue spinlocks their own lockdep classes when they are initialised
from init_waitqueue_head().  This means that struct wait_queue::func functions
can operate other waitqueues.

This is used by CacheFiles to catch the page from a backing fs being unlocked
and to wake up another thread to take a copy of it.
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
