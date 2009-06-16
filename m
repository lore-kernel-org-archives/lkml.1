Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZFPEcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZFPEcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZFPEcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:32:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54166 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZFPEcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:32:09 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 15 Jun 2009 21:26:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc1 regression? -- epoll: BUG: sleeping function called
 from invalid context
In-Reply-To: <tkrat.dc33b782c61692c7@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.1.10.0906152124480.21001@makko.or.mcafeemobile.com>
References: <tkrat.dc33b782c61692c7@s5r6.in-berlin.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Stefan Richter wrote:

> Looks like a regression after 2.6.29, before 2.6.30-rc1, caused by
> commit 5071f97ec6d74f006072de0ce89b67c8792fe5a1, "epoll: fix epoll's own
> poll" (since this introduced ep_scan_ready_list), but I haven't fully
> investigated yet whether this is really the cause.
> 
> Test case:  Run any libraw1394 or libdc1394 based program on
> firewire-core on a kernel with the usual selection of debugging options
> configured in.  I didn't have these options enabled for a while, hence
> noticed only now.
> 
> BUG: sleeping function called from invalid context at kernel/mutex.c:278
> in_atomic(): 1, irqs_disabled(): 0, pid: 8301, name: dvgrab
> no locks held by dvgrab/8301.
> Pid: 8301, comm: dvgrab Tainted: G	  W  2.6.30 #2
> Call Trace:
> [<ffffffff80250bb2>] ? __debug_show_held_locks+0x22/0x24
> [<ffffffff8022a91f>] __might_sleep+0x120/0x122
> [<ffffffff8045192b>] mutex_lock_nested+0x25/0x2eb
> [<ffffffff80253c25>] ? __lock_acquire+0x705/0x793
> [<ffffffff802b8f5a>] ep_scan_ready_list+0x3c/0x185
> [<ffffffff802b997f>] ? ep_read_events_proc+0x0/0x6c
> [<ffffffff802b90b5>] ep_poll_readyevents_proc+0x12/0x14
> [<ffffffff802b8b4f>] ep_call_nested+0x9f/0xfa
> [<ffffffff802b90a3>] ? ep_poll_readyevents_proc+0x0/0x14
> [<ffffffff802b8bf7>] ep_eventpoll_poll+0x4d/0x5b
> [<ffffffff8029d525>] do_sys_poll+0x1b4/0x3b5
> [<ffffffff8029e17a>] ? __pollwait+0x0/0xce
> [<ffffffff8029e248>] ? pollwake+0x0/0x52
> [<ffffffff8025162b>] ? mark_held_locks+0x4d/0x6a
> [<ffffffff8020b900>] ? restore_args+0x0/0x30
> [<ffffffff80251753>] ? trace_hardirqs_on_caller+0x10b/0x12f
> [<ffffffff8025162b>] ? mark_held_locks+0x4d/0x6a
> [<ffffffff8020b900>] ? restore_args+0x0/0x30
> [<ffffffff80253c25>] ? __lock_acquire+0x705/0x793
> [<ffffffff80251753>] ? trace_hardirqs_on_caller+0x10b/0x12f
> [<ffffffff80251784>] ? trace_hardirqs_on+0xd/0xf
> [<ffffffff80235a69>] ? timespec_add_safe+0x34/0x61
> [<ffffffff802b9070>] ? ep_scan_ready_list+0x152/0x185
> [<ffffffff802483f9>] ? ktime_get_ts+0x49/0x4e
> [<ffffffff8029d26b>] ? poll_select_set_timeout+0x5c/0x7f
> [<ffffffff8029d778>] sys_poll+0x52/0xb2
> [<ffffffff8020aeab>] system_call_fastpath+0x16/0x1b
> 
> Any idea how to approach this?

Do you have a chance to give the patch below a spin, in your context?



- Davide


---
 fs/eventpoll.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-06-15 19:27:05.000000000 -0700
+++ linux-2.6.mod/fs/eventpoll.c	2009-06-15 21:14:36.000000000 -0700
@@ -13,6 +13,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/hardirq.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -98,7 +99,7 @@ struct epoll_filefd {
 struct nested_call_node {
 	struct list_head llink;
 	void *cookie;
-	int cpu;
+	void *ctx;
 };
 
 /*
@@ -317,17 +318,17 @@ static void ep_nested_calls_init(struct 
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
@@ -340,7 +341,7 @@ static int ep_call_nested(struct nested_
 	 * very much limited.
 	 */
 	list_for_each_entry(tncur, lsthead, llink) {
-		if (tncur->cpu == this_cpu &&
+		if (tncur->ctx == ctx &&
 		    (tncur->cookie == cookie || ++call_nests > max_nests)) {
 			/*
 			 * Ops ... loop detected or maximum nest level reached.
@@ -352,7 +353,7 @@ static int ep_call_nested(struct nested_
 	}
 
 	/* Add the current task and cookie to the list */
-	tnode.cpu = this_cpu;
+	tnode.ctx = ctx;
 	tnode.cookie = cookie;
 	list_add(&tnode.llink, lsthead);
 
@@ -364,10 +365,9 @@ static int ep_call_nested(struct nested_
 	/* Remove the current task from the list */
 	spin_lock_irqsave(&ncalls->lock, flags);
 	list_del(&tnode.llink);
- out_unlock:
+out_unlock:
 	spin_unlock_irqrestore(&ncalls->lock, flags);
 
-	put_cpu();
 	return error;
 }
 
@@ -408,8 +408,12 @@ static int ep_poll_wakeup_proc(void *pri
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
@@ -663,7 +667,7 @@ static unsigned int ep_eventpoll_poll(st
 	 * could re-enter here.
 	 */
 	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, ep, ep);
+				   ep_poll_readyevents_proc, ep, ep, current);
 
 	return pollflags != -1 ? pollflags : 0;
 }
