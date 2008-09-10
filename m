Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbYIJKNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbYIJKNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYIJKNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:13:14 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:41550 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751654AbYIJKNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:13:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=v+Gio5kUD+CP+DDCaNgwbp8ZsV0pz637qIW63lf7xckN8YfSqbq2Lc8NkBUwm5wWvGV+d/MMmFz06pQbM2Cm+5H4qKmEFsNuY+q8uZRj0Et5KxEPOs8Q2J/dS9kvN7gPKQ7w2An0yQImRNjxP06pOxW+mP1Vk/JO7qMcNfQTNRQ=  ;
X-YMail-OSG: BT9czMQVM1lQ6EtbbwiXJshiiYstSaNaCq7haIJ4xmx8JPrhxjzkMVB.Da9QU2qHrA1iyjXAGlKa5bObbMGjwUFNjakp_lMJnb28mfm4HO25BBGPTZ2ZvjRp80SGdMRtbo8yNkKkJpAJ_zEo1HGIcwmU
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
Date: Thu, 11 Sep 2008 06:12:51 +1000
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com> <200809101407.16323.nickpiggin@yahoo.com.au>
In-Reply-To: <200809101407.16323.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DpCyIBRgMcIBHDj"
Message-Id: <200809110612.51736.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_DpCyIBRgMcIBHDj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 10 September 2008 14:07, Nick Piggin wrote:
> On Wednesday 10 September 2008 07:03, Daniel J Blueman wrote:
> > I observed this locking violation [1] while gnome-panel was loading;
> > this was previously reported at
> > http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .
> >
> > Let me know for more information/config/testing. Thanks!
>
> Thanks for the report. I've attached a patch you could test. It compiles
> (and boots a UML here) but I don't think I've actually tested the inotify
> path at all, so it may explode on you.

Indeed it was wrong, I messed up the waitqueue handling. This one
survives longer for me...

--Boundary-00=_DpCyIBRgMcIBHDj
Content-Type: text/x-diff;
  charset="utf-8";
  name="inotify-lor-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="inotify-lor-fix.patch"

Fix inotify lock order reversal with mmap_sem due to holding locks over
copy_to_user.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/fs/inotify_user.c
===================================================================
--- linux-2.6.orig/fs/inotify_user.c
+++ linux-2.6/fs/inotify_user.c
@@ -323,7 +323,7 @@ out:
 }
 
 /*
- * remove_kevent - cleans up and ultimately frees the given kevent
+ * remove_kevent - cleans up the given kevent
  *
  * Caller must hold dev->ev_mutex.
  */
@@ -334,7 +334,13 @@ static void remove_kevent(struct inotify
 
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
@@ -350,6 +356,7 @@ static void inotify_dev_event_dequeue(st
 		struct inotify_kernel_event *kevent;
 		kevent = inotify_dev_get_event(dev);
 		remove_kevent(dev, kevent);
+		free_kevent(kevent);
 	}
 }
 
@@ -433,17 +440,15 @@ static ssize_t inotify_read(struct file 
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
@@ -462,7 +467,6 @@ static ssize_t inotify_read(struct file 
 	if (ret)
 		return ret;
 
-	mutex_lock(&dev->ev_mutex);
 	while (1) {
 		struct inotify_kernel_event *kevent;
 
@@ -481,6 +485,13 @@ static ssize_t inotify_read(struct file 
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
@@ -498,7 +509,9 @@ static ssize_t inotify_read(struct file 
 			count -= kevent->event.len;
 		}
 
-		remove_kevent(dev, kevent);
+		free_kevent(kevent);
+
+		mutex_lock(&dev->ev_mutex);
 	}
 	mutex_unlock(&dev->ev_mutex);
 
Index: linux-2.6/include/asm-x86/uaccess_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/uaccess_64.h
+++ linux-2.6/include/asm-x86/uaccess_64.h
@@ -7,6 +7,7 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/prefetch.h>
+#include <linux/lockdep.h>
 #include <asm/page.h>
 
 /*

--Boundary-00=_DpCyIBRgMcIBHDj--
