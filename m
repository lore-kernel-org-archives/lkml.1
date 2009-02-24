Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZBXR1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZBXR1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbZBXR1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:27:11 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3518 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbZBXR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:27:09 -0500
Message-ID: <49A42DEB.503@cybernetics.com>
Date: Tue, 24 Feb 2009 12:27:07 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] [2.6.29] epoll: don't use current in irq context
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_poll_safewake() uses "current" to detect callback recursion, but it
may be called from irq context where the use of current is generally
frowned upon.  It would be better to use get_cpu() and put_cpu() to
detect the callback recursion.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch is against 2.6.29-rc6; however, it doesn't need to go
into 2.6.29.  Use the -mm version instead if applying after the other
patches in -mm.

--- a/fs/eventpoll.c	2009-02-23 11:07:40.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 11:08:39.000000000 -0500
@@ -118,8 +118,8 @@ struct epoll_filefd {
  */
 struct wake_task_node {
 	struct list_head llink;
-	struct task_struct *task;
 	wait_queue_head_t *wq;
+	int cpu;
 };
 
 /*
@@ -335,7 +335,7 @@ static void ep_poll_safewake(struct poll
 {
 	int wake_nests = 0;
 	unsigned long flags;
-	struct task_struct *this_task = current;
+	int this_cpu = get_cpu();
 	struct list_head *lsthead = &psw->wake_task_list;
 	struct wake_task_node *tncur;
 	struct wake_task_node tnode;
@@ -346,18 +346,18 @@ static void ep_poll_safewake(struct poll
 	list_for_each_entry(tncur, lsthead, llink) {
 
 		if (tncur->wq == wq ||
-		    (tncur->task == this_task && ++wake_nests > EP_MAX_POLLWAKE_NESTS)) {
+		    (tncur->cpu == this_cpu &&
+		     ++wake_nests > EP_MAX_POLLWAKE_NESTS)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
 			 * We abort this wake by breaking the cycle itself.
 			 */
-			spin_unlock_irqrestore(&psw->lock, flags);
-			return;
+			goto out_unlock;
 		}
 	}
 
 	/* Add the current task to the list */
-	tnode.task = this_task;
+	tnode.cpu = this_cpu;
 	tnode.wq = wq;
 	list_add(&tnode.llink, lsthead);
 
@@ -369,7 +369,9 @@ static void ep_poll_safewake(struct poll
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&psw->lock, flags);
 	list_del(&tnode.llink);
+out_unlock:
 	spin_unlock_irqrestore(&psw->lock, flags);
+	put_cpu();
 }
 
 /*
@@ -652,8 +654,8 @@ static int ep_poll_callback(wait_queue_t
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
-		     current, epi->ffd.file, epi, ep));
+	DNPRINTK(3, (KERN_INFO "eventpoll: poll_callback(%p) epi=%p ep=%p\n",
+		     epi->ffd.file, epi, ep));
 
 	spin_lock_irqsave(&ep->lock, flags);
 

