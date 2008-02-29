Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYB2Crd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYB2Crd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYB2CrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:47:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:43991 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYB2CrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ShH/cF3vHuy2JGnkYFElz6krQzoMxJCypUWIj8f4pGS2CcY2xly+7phspMVKxWOWmf6bZrsb2IDyBpUVsh+tIovEoNaTeVqZccAlJTKNa9PJ8IL17Y3hXxM/yVl4TceZz/1PYO1JilT62B24vObjmByQovZWdO743btYBHm3cOo=
Subject: [PATCH] semaphore: remove likely/unlikely annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1204252679.20280.115.camel@brick>
References: <20080227003605.GC5715@parisc-linux.org>
	 <1204180441-8540-1-git-send-email-matthew@wil.cx>
	 <1204180441-8540-2-git-send-email-matthew@wil.cx>
	 <1204180441-8540-3-git-send-email-matthew@wil.cx>
	 <1204180441-8540-4-git-send-email-matthew@wil.cx>
	 <1204180441-8540-5-git-send-email-matthew@wil.cx>
	 <1204180441-8540-6-git-send-email-matthew@wil.cx>
	 <1204180441-8540-7-git-send-email-matthew@wil.cx>
	 <1204180441-8540-8-git-send-email-matthew@wil.cx>
	 <1204180441-8540-9-git-send-email-matthew@wil.cx>
	 <1204180441-8540-10-git-send-email-matthew@wil.cx>
	 <1204180441-8540-11-git-send-email-matthew@wil.cx>
	 <1204252679.20280.115.camel@brick>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 18:47:22 -0800
Message-Id: <1204253242.20280.117.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also some small codingstyle changes, empty line after declarations,
separate an if statement.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I know it's a small thing, feel free to take it or not.

 kernel/semaphore.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 32934f2..f4aeeda 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -41,7 +41,7 @@ void down(struct semaphore *sem)
 {
 	might_sleep();
 	spin_lock_irq(&sem->lock);
-	if (unlikely(sem->count-- <= 0))
+	if (sem->count-- <= 0)
 		__down(sem);
 	spin_unlock_irq(&sem->lock);
 }
@@ -50,9 +50,10 @@ EXPORT_SYMBOL(down);
 int down_interruptible(struct semaphore *sem)
 {
 	int result = 0;
+
 	might_sleep();
 	spin_lock_irq(&sem->lock);
-	if (unlikely(sem->count-- <= 0))
+	if (sem->count-- <= 0)
 		result = __down_interruptible(sem);
 	spin_unlock_irq(&sem->lock);
 	return result;
@@ -62,9 +63,10 @@ EXPORT_SYMBOL(down_interruptible);
 int down_killable(struct semaphore *sem)
 {
 	int result = 0;
+
 	might_sleep();
 	spin_lock_irq(&sem->lock);
-	if (unlikely(sem->count-- <= 0))
+	if (sem->count-- <= 0)
 		result = __down_killable(sem);
 	spin_unlock_irq(&sem->lock);
 	return result;
@@ -91,7 +93,7 @@ int down_trylock(struct semaphore *sem)
 
 	spin_lock_irqsave(&sem->lock, flags);
 	count = sem->count - 1;
-	if (likely(count >= 0))
+	if (count >= 0)
 		sem->count = count;
 	spin_unlock_irqrestore(&sem->lock, flags);
 	return (count < 0);
@@ -103,7 +105,7 @@ void up(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count >= 0))
+	if (sem->count >= 0)
 		sem->count++;
 	else
 		__up(sem);
@@ -128,8 +130,9 @@ struct semaphore_waiter {
  */
 static void noinline __sched __up_down_common(struct semaphore *sem)
 {
-	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
-						struct semaphore_waiter, list);
+	struct semaphore_waiter *waiter;
+
+	waiter = list_first_entry(&sem->wait_list, struct semaphore_waiter, list);
 	list_del(&waiter->list);
 	waiter->up = 1;
 	wake_up_process(waiter->task);
@@ -150,10 +153,9 @@ static inline int __sched __down_common(struct semaphore *sem, long state)
 	waiter.up = 0;
 
 	for (;;) {
-		if (unlikely((state == TASK_INTERRUPTIBLE &&
-					signal_pending(task)) ||
-			     (state == TASK_KILLABLE &&
-					fatal_signal_pending(task))))
+		if (state == TASK_INTERRUPTIBLE && signal_pending(task))
+			goto interrupted;
+		if (state == TASK_KILLABLE && fatal_signal_pending(task))
 			goto interrupted;
 		__set_task_state(task, state);
 		spin_unlock_irq(&sem->lock);
@@ -175,7 +177,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state)
 	 * but it doesn't hurt, that's not a commonly exercised path and
 	 * it's not a performance path either.
 	 */
-	if (unlikely((++sem->count >= 0) && !list_empty(&sem->wait_list)))
+	if (++sem->count >= 0 && !list_empty(&sem->wait_list))
 		__up_down_common(sem);
 	return result;
 }
@@ -197,7 +199,7 @@ static int noinline __sched __down_killable(struct semaphore *sem)
 
 static void noinline __sched __up(struct semaphore *sem)
 {
-	if (unlikely(list_empty(&sem->wait_list)))
+	if (list_empty(&sem->wait_list))
 		sem->count++;
 	else
 		__up_down_common(sem);
-- 
1.5.4.3.342.g99e8



