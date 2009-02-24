Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbZBXR3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbZBXR3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbZBXR2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:28:22 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:1462 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193AbZBXR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:28:22 -0500
Message-ID: <49A42E33.7020204@cybernetics.com>
Date: Tue, 24 Feb 2009 12:28:19 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] [-mm] epoll: don't use current in irq context
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep_call_nested() (formerly ep_poll_safewake()) uses "current" to detect
callback recursion, but it may be called from irq context where the
use of current is generally frowned upon.  It would be better to use
get_cpu() and put_cpu() to detect the callback recursion.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch is against the current -mm tree, and might not apply
to 2.6.29.  Since this patch probably won't go into 2.6.29, you may
apply this version of the patch after the other patches in -mm.

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
 

