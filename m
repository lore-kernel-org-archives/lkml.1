Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbZHDQJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbZHDQJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbZHDQJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:09:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbZHDQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:09:14 -0400
Subject: Re: Incorrect circular locking dependency?
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, oleg <oleg@redhat.com>
In-Reply-To: <18723.1249401004@redhat.com>
References: <1249397486.7924.243.camel@twins> <s5hvdmos4i8.wl%tiwai@suse.de>
	 <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com>
	 <24075.1248705430@redhat.com>  <18723.1249401004@redhat.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 18:08:52 +0200
Message-Id: <1249402132.4762.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 16:50 +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Creating a new class for your second workqueue might help,
> 
> I only have one workqueue.  The problem is there are two waitqueues, but
> init_waitqueue_head() always sets q->lock to the same class.

Ah, right, I read it backwards then.

> > we'd have to pass a second key through __create_workqueue_key() and pass
> > that into init_cpu_workqueue() and apply it to cwq->lock using
> > lockdep_set_class() and co.
> 
> Actually, wouldn't just making init_cpu_workqueue() apply a class to
> cwq->more_work that's common to all workqueues suffice? 

That's the default behaviour.

>  Or even, have
> init_waitqueue_head() apply an alternate class to q->lock?

Right, that would work. Something akin to all the other per instance
classes would do I guess.


Utterly untested..

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


