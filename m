Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbXGLEwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbXGLEwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXGLEwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:52:43 -0400
Received: from ozlabs.org ([203.10.76.45]:40653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXGLEwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:52:43 -0400
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, hch@lst.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20070711212435.abd33524.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070711122324.GA21714@lst.de>
	 <1184203311.6005.664.camel@localhost.localdomain>
	 <20070711.192829.08323972.davem@davemloft.net>
	 <1184208521.6005.695.camel@localhost.localdomain>
	 <20070711212435.abd33524.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 14:52:23 +1000
Message-Id: <1184215943.6005.745.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 21:24 -0700, Andrew Morton wrote:
> We seem to be taking the reference against the wrong thing here.  It should
> be against the mm, not against a task_struct?

This is solely for the wakeup: you don't wake an mm 8)

The mm reference is held as well under the big lguest_mutex (mm gets
destroyed before files get closed, so we definitely do need to hold a
reference).

I just completed benchmarking: the cached wakeup with the current naive
drivers makes no difference (at one stage I was playing with batched
hypercalls, where it seemed to help).

Thanks Christoph, DaveM!
===
Remove export of __put_task_struct, and usage in lguest

lguest takes a reference count of tasks for two reasons.  The first is
bogus: the /dev/lguest close callback will be called before the task
is destroyed anyway, so no need to take a reference on open.

The second is code to defer waking up tasks for inter-guest I/O, but
the current lguest drivers are too simplistic to benefit (only batched
hypercalls will see an effect, and it's likely that lguests' entire
I/O model will be replaced with virtio and ringbuffers anyway).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/hypercalls.c  |    1 -
 drivers/lguest/io.c          |   18 +-----------------
 drivers/lguest/lg.h          |    1 -
 drivers/lguest/lguest_user.c |    2 --
 kernel/fork.c                |    1 -
 5 files changed, 1 insertion(+), 22 deletions(-)

===================================================================
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -189,5 +189,4 @@ void do_hypercalls(struct lguest *lg)
 		do_hcall(lg, lg->regs);
 		clear_hcall(lg);
 	}
-	set_wakeup_process(lg, NULL);
 }
===================================================================
--- a/drivers/lguest/io.c
+++ b/drivers/lguest/io.c
@@ -296,7 +296,7 @@ static int dma_transfer(struct lguest *s
 
 	/* Do this last so dst doesn't simply sleep on lock. */
 	set_bit(dst->interrupt, dstlg->irqs_pending);
-	set_wakeup_process(srclg, dstlg->tsk);
+	wake_up_process(dstlg->tsk);
 	return i == dst->num_dmas;
 
 fail:
@@ -333,7 +333,6 @@ again:
 			/* Give any recipients one chance to restock. */
 			up_read(&current->mm->mmap_sem);
 			mutex_unlock(&lguest_lock);
-			set_wakeup_process(lg, NULL);
 			empty++;
 			goto again;
 		}
@@ -360,21 +359,6 @@ void release_all_dma(struct lguest *lg)
 			unlink_dma(&lg->dma[i]);
 	}
 	up_read(&lg->mm->mmap_sem);
-}
-
-/* We cache one process to wakeup: helps for batching & wakes outside locks. */
-void set_wakeup_process(struct lguest *lg, struct task_struct *p)
-{
-	if (p == lg->wake)
-		return;
-
-	if (lg->wake) {
-		wake_up_process(lg->wake);
-		put_task_struct(lg->wake);
-	}
-	lg->wake = p;
-	if (lg->wake)
-		get_task_struct(lg->wake);
 }
 
 /* Userspace wants a dma buffer from this guest. */
===================================================================
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -240,7 +240,6 @@ void release_all_dma(struct lguest *lg);
 void release_all_dma(struct lguest *lg);
 unsigned long get_dma_buffer(struct lguest *lg, unsigned long key,
 			     unsigned long *interrupt);
-void set_wakeup_process(struct lguest *lg, struct task_struct *p);
 
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
===================================================================
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -141,7 +141,6 @@ static int initialize(struct file *file,
 	setup_guest_gdt(lg);
 	init_clockdev(lg);
 	lg->tsk = current;
-	get_task_struct(lg->tsk);
 	lg->mm = get_task_mm(lg->tsk);
 	init_waitqueue_head(&lg->break_wq);
 	lg->last_pages = NULL;
@@ -205,7 +204,6 @@ static int close(struct inode *inode, st
 	hrtimer_cancel(&lg->hrt);
 	release_all_dma(lg);
 	free_guest_pagetable(lg);
-	put_task_struct(lg->tsk);
 	mmput(lg->mm);
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);
===================================================================
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -128,7 +128,6 @@ void __put_task_struct(struct task_struc
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
-EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init fork_init(unsigned long mempages)
 {


