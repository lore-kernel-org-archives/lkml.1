Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbXHRRhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbXHRRhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbXHRRhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:37:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41978 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbXHRRg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:36:58 -0400
Date: Sat, 18 Aug 2007 21:39:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] exec: simplify the new ->sighand allocation
Message-ID: <20070818173950.GA212@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

de_thread() pre-allocates newsighand to make sure that exec() can't fail after
killing all sub-threads. Imho, this buys nothing, but complicates the code:

	- this is (mostly) needed to handle CLONE_SIGHAND without CLONE_THREAD
	  tasks, this is very unlikely (if ever used) case

	- unless we already have some serious problems, GFP_KERNEL allocation
	  should not fail

	- ENOMEM still can happen after de_thread(), ->sighand is not the last
	  object we have to allocate

Change the code to allocate the new ->sighand on demand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/exec.c~3_ALLOC	2007-08-18 18:26:48.000000000 +0400
+++ t/fs/exec.c	2007-08-18 19:10:58.000000000 +0400
@@ -774,7 +774,7 @@ static int exec_mmap(struct mm_struct *m
 static int de_thread(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-	struct sighand_struct *newsighand, *oldsighand = tsk->sighand;
+	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
 	struct task_struct *leader = NULL;
 	int count;
@@ -789,10 +789,6 @@ static int de_thread(struct task_struct 
 		return 0;
 	}
 
-	newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
-	if (!newsighand)
-		return -ENOMEM;
-
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
 
@@ -809,7 +805,6 @@ static int de_thread(struct task_struct 
 		 */
 		spin_unlock_irq(lock);
 		read_unlock(&tasklist_lock);
-		kmem_cache_free(sighand_cachep, newsighand);
 		return -EAGAIN;
 	}
 
@@ -928,17 +923,16 @@ no_thread_group:
 	if (leader)
 		release_task(leader);
 
-	if (atomic_read(&oldsighand->count) == 1) {
-		/*
-		 * Now that we nuked the rest of the thread group,
-		 * it turns out we are not sharing sighand any more either.
-		 * So we can just keep it.
-		 */
-		kmem_cache_free(sighand_cachep, newsighand);
-	} else {
+	if (atomic_read(&oldsighand->count) != 1) {
+		struct sighand_struct *newsighand;
 		/*
-		 * Move our state over to newsighand and switch it in.
+		 * This ->sighand is shared with the CLONE_SIGHAND
+		 * but not CLONE_THREAD task, switch to the new one.
 		 */
+		newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
+		if (!newsighand)
+			return -ENOMEM;
+
 		atomic_set(&newsighand->count, 1);
 		memcpy(newsighand->action, oldsighand->action,
 		       sizeof(newsighand->action));

