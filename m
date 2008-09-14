Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYINIHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYINIHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 04:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYINIGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 04:06:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37248 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYINIGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 04:06:51 -0400
Date: Sun, 14 Sep 2008 10:06:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] mm: fix locking, inotify_read's ev_mutex vs
	do_page_fault's mmap_sem...
Message-ID: <20080914080631.GA10720@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914004442.4f8e851f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > [ 6460.634452] 
> > [ 6460.634465] =======================================================
> > [ 6460.634494] [ INFO: possible circular locking dependency detected ]
> > [ 6460.634517] 2.6.27-rc6-tip-00290-g8e229c3-dirty #1
> > [ 6460.634535] -------------------------------------------------------
> > [ 6460.634555] gdm-simple-gree/4778 is trying to acquire lock:
> > [ 6460.634574]  (&mm->mmap_sem){----}, at: [<c018fe33>] might_fault+0x36/0x73
> > [ 6460.634639] 
> > [ 6460.634645] but task is already holding lock:
> > [ 6460.634662]  (&dev->ev_mutex){--..}, at: [<c01c7a76>] inotify_read+0xd8/0x16e
> > [ 6460.634715] 
> > [ 6460.634721] which lock already depends on the new lock.
> 
> Yes, there's a thread in my intray called "inotify_read's ev_mutex vs 
> do_page_fault's mmap_sem...".  It's a bit flakey-looking, but there's 
> a patch in there.

ah, thx. I picked up the patch into tip/out-of-tree. (see below for a 
tided up changelog) Please queue it up as v2.6.27 material. (i'll report 
it if anything breaks due to the patch)

	Ingo

--------------->
>From 1eb0a42e4eb3283521ee1de99adbf567874b622f Mon Sep 17 00:00:00 2001
From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 11 Sep 2008 06:12:51 +1000
Subject: [PATCH] mm: fix locking, inotify_read's ev_mutex vs do_page_fault's mmap_sem...

Daniel J Blueman wrote:
> I observed this locking violation [1] while gnome-panel was loading;
> this was previously reported at
> http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .

Fix inotify lock order reversal with mmap_sem due to holding locks over
copy_to_user.

Reported-by: "Daniel J Blueman" <daniel.blueman@gmail.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/inotify_user.c            |   27 ++++++++++++++++++++-------
 include/asm-x86/uaccess_64.h |    1 +
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6024942..d85c7d9 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -323,7 +323,7 @@ out:
 }
 
 /*
- * remove_kevent - cleans up and ultimately frees the given kevent
+ * remove_kevent - cleans up the given kevent
  *
  * Caller must hold dev->ev_mutex.
  */
@@ -334,7 +334,13 @@ static void remove_kevent(struct inotify_device *dev,
 
 	dev->event_count--;
 	dev->queue_size -= sizeof(struct inotify_event) + kevent->event.len;
+}
 
+/*
+ * free_kevent - frees the given kevent.
+ */
+static void free_kevent(struct inotify_kernel_event *kevent)
+{
 	kfree(kevent->name);
 	kmem_cache_free(event_cachep, kevent);
 }
@@ -350,6 +356,7 @@ static void inotify_dev_event_dequeue(struct inotify_device *dev)
 		struct inotify_kernel_event *kevent;
 		kevent = inotify_dev_get_event(dev);
 		remove_kevent(dev, kevent);
+		free_kevent(kevent);
 	}
 }
 
@@ -433,17 +440,15 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 	dev = file->private_data;
 
 	while (1) {
-		int events;
 
 		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
 
 		mutex_lock(&dev->ev_mutex);
-		events = !list_empty(&dev->events);
-		mutex_unlock(&dev->ev_mutex);
-		if (events) {
+		if (!list_empty(&dev->events)) {
 			ret = 0;
 			break;
 		}
+		mutex_unlock(&dev->ev_mutex);
 
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
@@ -462,7 +467,6 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 
-	mutex_lock(&dev->ev_mutex);
 	while (1) {
 		struct inotify_kernel_event *kevent;
 
@@ -481,6 +485,13 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 			}
 			break;
 		}
+		remove_kevent(dev, kevent);
+
+		/*
+		 * Must perform the copy_to_user outside the mutex in order
+		 * to avoid a lock order reversal with mmap_sem.
+		 */
+		mutex_unlock(&dev->ev_mutex);
 
 		if (copy_to_user(buf, &kevent->event, event_size)) {
 			ret = -EFAULT;
@@ -498,7 +509,9 @@ static ssize_t inotify_read(struct file *file, char __user *buf,
 			count -= kevent->event.len;
 		}
 
-		remove_kevent(dev, kevent);
+		free_kevent(kevent);
+
+		mutex_lock(&dev->ev_mutex);
 	}
 	mutex_unlock(&dev->ev_mutex);
 
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 515d4dc..45806d6 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -7,6 +7,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/prefetch.h>
+#include <linux/lockdep.h>
 #include <asm/page.h>
 
 /*
