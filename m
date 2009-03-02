Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZCBXKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZCBXKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZCBXKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:10:11 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:3812 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbZCBXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:10:10 -0500
Message-ID: <49AC674F.6080909@cybernetics.com>
Date: Mon, 02 Mar 2009 18:10:07 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] epoll: don't use current in irq context
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_call_nested() (formerly ep_poll_safewake()) uses "current" (without
dereferencing it) to detect callback recursion, but it may be called
from irq context where the use of current is generally discouraged.  It
would be better to use get_cpu() and put_cpu() to detect the callback
recursion.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
---

Dropped patch 1 from the original set, so patches 2 - 6 are now 1 - 5.
These should all apply to the current -mm tree.

--- a/fs/eventpoll.c	2009-02-23 13:13:33.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-23 13:17:46.000000000 -0500
@@ -97,8 +97,8 @@ struct epoll_filefd {
  */
 struct nested_call_node {
 	struct list_head llink;
-	struct task_struct *task;
 	void *cookie;
+	int cpu;
 };
 
 /*
@@ -327,7 +327,7 @@ static int ep_call_nested(struct nested_
 {
 	int error, call_nests = 0;
 	unsigned long flags;
-	struct task_struct *this_task = current;
+	int this_cpu = get_cpu();
 	struct list_head *lsthead = &ncalls->tasks_call_list;
 	struct nested_call_node *tncur;
 	struct nested_call_node tnode;
@@ -340,20 +340,19 @@ static int ep_call_nested(struct nested_
 	 * very much limited.
 	 */
 	list_for_each_entry(tncur, lsthead, llink) {
-		if (tncur->task == this_task &&
+		if (tncur->cpu == this_cpu &&
 		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
 			 * We abort this wake by breaking the cycle itself.
 			 */
-			spin_unlock_irqrestore(&ncalls->lock, flags);
-
-			return -1;
+			error = -1;
+			goto out_unlock;
 		}
 	}
 
 	/* Add the current task and cookie to the list */
-	tnode.task = this_task;
+	tnode.cpu = this_cpu;
 	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
@@ -365,8 +364,10 @@ static int ep_call_nested(struct nested_
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
+ out_unlock:
 	spin_unlock_irqrestore(&ncalls->lock, flags);
 
+	put_cpu();
 	return error;
 }
 



