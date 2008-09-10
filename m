Return-Path: <linux-kernel-owner+w=401wt.eu-S1752509AbYIJEkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbYIJEkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 00:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbYIJEkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 00:40:05 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:35403 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750767AbYIJEkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 00:40:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=GiZUWtryV6taKasLe9V8viRocJQ4apJlUPDoelLWFBt4jfdqBBv6j2xglHgSpmx4o/BqvCL49uxxno9b7CaFaOMoy9himB1oXbXamO5UxMtpYZI6NuOEk0Ecct0+mit0XFDhTGDLV7UK5flo0RHK2YebiJG+EORcH8XrcTun6i0=  ;
X-YMail-OSG: _.gPx_gVM1kHiqyZyft.WSvQzykX0JVUn2TlXQ.XwuSAxNm4au7yhOKVKfh.yRWzPEWE.FXhkQTid2WLspYebJnNSAXzF7urMXVRk5D4Q647p4fN687MBHq06lKQ8DNgPcuQAgmrpDJDPLg1oZ_Rd8.D
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
Date: Wed, 10 Sep 2008 14:07:16 +1000
User-Agent: KMail/1.9.5
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com>
In-Reply-To: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0f0xI+l75gB8MQ1"
Message-Id: <200809101407.16323.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0f0xI+l75gB8MQ1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 10 September 2008 07:03, Daniel J Blueman wrote:
> I observed this locking violation [1] while gnome-panel was loading;
> this was previously reported at
> http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .
>
> Let me know for more information/config/testing. Thanks!

Thanks for the report. I've attached a patch you could test. It compiles
(and boots a UML here) but I don't think I've actually tested the inotify
path at all, so it may explode on you.

Peter, this copy_*_user stuff is quite a nightmare... Well actually it
isn't, if the code is designed with it in mind from the start, but it is
easy for people to forget it can take mmap_sem and filesystem locks... Is
there a way to annotate it and say "might take mmap_sem for read" for
example? So that these LORs will _always_ trigger rather than just once
in a million times when the reclaim gods frown on us?

Anyway, Daniel, thanks again...


>   Daniel
>
> --- [1]
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc5-233c-debug #2
> -------------------------------------------------------
> gnome-panel/4944 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<ffffffff806aa40f>] do_page_fault+0x12f/0xae0
>
> but task is already holding lock:
>  (&dev->ev_mutex){--..}, at: [<ffffffff80320ac3>] inotify_read+0xe3/0x200
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #3 (&dev->ev_mutex){--..}:
>        [<ffffffff80271889>] __lock_acquire+0xd49/0x1190
>        [<ffffffff80271d61>] lock_acquire+0x91/0xc0
>        [<ffffffff806a5069>] __mutex_lock_common+0xb9/0x430
>        [<ffffffff806a54bf>] mutex_lock_nested+0x3f/0x50
>        [<ffffffff80321216>] inotify_dev_queue_event+0x46/0x1c0
>        [<ffffffff803200e6>] inotify_inode_queue_event+0xc6/0x110
>        [<ffffffff802f424c>] fsnotify_create+0x3c/0x70
>        [<ffffffff802f4c5d>] vfs_create+0xbd/0xd0
>        [<ffffffff802f7dfe>] do_filp_open+0x80e/0x910
>        [<ffffffff802e82b0>] do_sys_open+0x80/0x110
>        [<ffffffff802e8380>] sys_open+0x20/0x30
>        [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
>
> -> #2 (&ih->mutex){--..}:
>        [<ffffffff80271889>] __lock_acquire+0xd49/0x1190
>        [<ffffffff80271d61>] lock_acquire+0x91/0xc0
>        [<ffffffff806a5069>] __mutex_lock_common+0xb9/0x430
>        [<ffffffff806a54bf>] mutex_lock_nested+0x3f/0x50
>        [<ffffffff8031fe73>] inotify_find_update_watch+0x53/0xe0
>        [<ffffffff80320d85>] sys_inotify_add_watch+0x115/0x1d0
>        [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
>
> -> #1 (&inode->inotify_mutex){--..}:
>        [<ffffffff80271889>] __lock_acquire+0xd49/0x1190
>        [<ffffffff80271d61>] lock_acquire+0x91/0xc0
>        [<ffffffff806a5069>] __mutex_lock_common+0xb9/0x430
>        [<ffffffff806a54bf>] mutex_lock_nested+0x3f/0x50
>        [<ffffffff80320070>] inotify_inode_queue_event+0x50/0x110
>        [<ffffffff803206e1>] inotify_dentry_parent_queue_event+0x91/0xb0
>        [<ffffffff802ebb7f>] __fput+0x7f/0x1f0
>        [<ffffffff802ebd15>] fput+0x25/0x30
>        [<ffffffff802c84ff>] remove_vma+0x4f/0x90
>        [<ffffffff802ca359>] do_munmap+0x2e9/0x330
>        [<ffffffff802ca3f5>] sys_munmap+0x55/0x80
>        [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
>
> -> #0 (&mm->mmap_sem){----}:
>        [<ffffffff80271950>] __lock_acquire+0xe10/0x1190
>        [<ffffffff80271d61>] lock_acquire+0x91/0xc0
>        [<ffffffff806a56eb>] down_read+0x4b/0x80
>        [<ffffffff806aa40f>] do_page_fault+0x12f/0xae0
>        [<ffffffff806a7bdd>] error_exit+0x0/0xa9
>        [<ffffffff802eac08>] vfs_read+0xc8/0x170
>        [<ffffffff802eadb5>] sys_read+0x55/0x90
>        [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff
>
> other info that might help us debug this:
>
> 1 lock held by gnome-panel/4944:
>  #0:  (&dev->ev_mutex){--..}, at: [<ffffffff80320ac3>]
> inotify_read+0xe3/0x200
>
> stack backtrace:
> Pid: 4944, comm: gnome-panel Not tainted 2.6.27-rc5-233c-debug #2
>
> Call Trace:
>  [<ffffffff8026f807>] print_circular_bug_tail+0xa7/0xf0
>  [<ffffffff80271950>] __lock_acquire+0xe10/0x1190
>  [<ffffffff80271d61>] lock_acquire+0x91/0xc0
>  [<ffffffff806aa40f>] ? do_page_fault+0x12f/0xae0
>  [<ffffffff806a56eb>] down_read+0x4b/0x80
>  [<ffffffff806aa40f>] ? do_page_fault+0x12f/0xae0
>  [<ffffffff8025c51a>] ? search_exception_tables+0x2a/0x50
>  [<ffffffff806aa40f>] do_page_fault+0x12f/0xae0
>  [<ffffffff8026d951>] ? trace_hardirqs_off_caller+0x21/0xc0
>  [<ffffffff80213fc0>] ? native_sched_clock+0x90/0xb0
>  [<ffffffff80270e39>] ? __lock_acquire+0x2f9/0x1190
>  [<ffffffff80270606>] ? mark_held_locks+0x56/0xa0
>  [<ffffffff802708bd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff80270849>] ? trace_hardirqs_on_caller+0x149/0x1b0
>  [<ffffffff806a7bdd>] error_exit+0x0/0xa9
>  [<ffffffff80459acd>] ? copy_user_generic_string+0x2d/0x40
>  [<ffffffff80320b5d>] ? inotify_read+0x17d/0x200
>  [<ffffffff8025ee00>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff802708bd>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff802eac08>] vfs_read+0xc8/0x170
>  [<ffffffff802eadb5>] sys_read+0x55/0x90
>  [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b

--Boundary-00=_0f0xI+l75gB8MQ1
Content-Type: text/x-diff;
  charset="iso-8859-1";
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
-			break;
+			goto have_events;
 		}
+		mutex_unlock(&dev->ev_mutex);
 
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
@@ -459,10 +464,9 @@ static ssize_t inotify_read(struct file 
 	}
 
 	finish_wait(&dev->wq, &wait);
-	if (ret)
-		return ret;
+	return ret;
 
-	mutex_lock(&dev->ev_mutex);
+have_events:
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
 

--Boundary-00=_0f0xI+l75gB8MQ1--
