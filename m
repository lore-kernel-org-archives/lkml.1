Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbZFPQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbZFPQ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZFPQ6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:58:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45582 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFPQ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:58:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 16 Jun 2009 09:51:05 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch] epoll - fix nested calls support
Message-ID: <alpine.DEB.1.10.0906160941030.25664@makko.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Greg, this fixes a regression in 2.6.30.
I unfortunately accepted a patch time ago, to drop the "current" usage 
from possible IRQ context, w/out proper thought over it.
The patch switched to using the CPU id by bounding the nested call 
callback with a get_cpu()/put_cpu().
Unfortunately the ep_call_nested() function can be called with a callback 
that grabs sleepy locks (from own f_op->poll()), that results in epic fails.
The following patch uses the proper "context" depending on the path where 
it is called, and on the kind of callback.
This has been reported by Stefan Richter, that has also verified the patch 
is his previously failing environment.
Greg, this should go in -stable too.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-06-15 19:27:05.000000000 -0700
+++ linux-2.6.mod/fs/eventpoll.c	2009-06-15 21:30:19.000000000 -0700
@@ -98,7 +98,7 @@ struct epoll_filefd {
 struct nested_call_node {
 	struct list_head llink;
 	void *cookie;
-	int cpu;
+	void *ctx;
 };
 
 /*
@@ -317,17 +317,17 @@ static void ep_nested_calls_init(struct 
  * @nproc: Nested call core function pointer.
  * @priv: Opaque data to be passed to the @nproc callback.
  * @cookie: Cookie to be used to identify this nested call.
+ * @ctx: This instance context.
  *
  * Returns: Returns the code returned by the @nproc callback, or -1 if
  *          the maximum recursion limit has been exceeded.
  */
 static int ep_call_nested(struct nested_calls *ncalls, int max_nests,
 			  int (*nproc)(void *, void *, int), void *priv,
-			  void *cookie)
+			  void *cookie, void *ctx)
 {
 	int error, call_nests = 0;
 	unsigned long flags;
-	int this_cpu = get_cpu();
 	struct list_head *lsthead = &ncalls->tasks_call_list;
 	struct nested_call_node *tncur;
 	struct nested_call_node tnode;
@@ -340,7 +340,7 @@ static int ep_call_nested(struct nested_
 	 * very much limited.
 	 */
 	list_for_each_entry(tncur, lsthead, llink) {
-		if (tncur->cpu == this_cpu &&
+		if (tncur->ctx == ctx &&
 		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
@@ -352,7 +352,7 @@ static int ep_call_nested(struct nested_
 	}
 
 	/* Add the current task and cookie to the list */
-	tnode.cpu = this_cpu;
+	tnode.ctx = ctx;
 	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
@@ -364,10 +364,9 @@ static int ep_call_nested(struct nested_
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
- out_unlock:
+out_unlock:
 	spin_unlock_irqrestore(&ncalls->lock, flags);
 
-	put_cpu();
 	return error;
 }
 
@@ -408,8 +407,12 @@ static int ep_poll_wakeup_proc(void *pri
  */
 static void ep_poll_safewake(wait_queue_head_t *wq)
 {
+	int this_cpu = get_cpu();
+
 	ep_call_nested(&poll_safewake_ncalls, EP_MAX_NESTS,
-		       ep_poll_wakeup_proc, NULL, wq);
+		       ep_poll_wakeup_proc, NULL, wq, (void *) (long) this_cpu);
+
+	put_cpu();
 }
 
 /*
@@ -663,7 +666,7 @@ static unsigned int ep_eventpoll_poll(st
 	 * could re-enter here.
 	 */
 	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, ep, ep);
+				   ep_poll_readyevents_proc, ep, ep, current);
 
 	return pollflags != -1 ? pollflags : 0;
 }
