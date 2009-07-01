Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbZGABCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbZGABCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbZGAAfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:04 -0400
Received: from kroah.org ([198.145.64.141]:60443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760126AbZGAAfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:31 2009
Message-Id: <20090701002431.096318663@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [patch 058/108] epoll: fix nested calls support
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=epoll-fix-nested-calls-support.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Davide Libenzi <davidel@xmailserver.org>

commit 3fe4a975d662f11037cb710f8b4b158a3e38f9c0 upstream.

This fixes a regression in 2.6.30.

I unfortunately accepted a patch time ago, to drop the "current" usage
from possible IRQ context, w/out proper thought over it.  The patch
switched to using the CPU id by bounding the nested call callback with a
get_cpu()/put_cpu().

Unfortunately the ep_call_nested() function can be called with a callback
that grabs sleepy locks (from own f_op->poll()), that results in epic
fails.  The following patch uses the proper "context" depending on the
path where it is called, and on the kind of callback.

This has been reported by Stefan Richter, that has also verified the patch
is his previously failing environment.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/eventpoll.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
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


