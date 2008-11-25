Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYKYKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYKYKuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbYKYKug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:50:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45622 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYKYKuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:50:35 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Poll : introduce poll_wait_exclusive() new function
Cc: kosaki.motohiro@jp.fujitsu.com, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <20081124121659.GA18987@Krystal>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal>
Message-Id: <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 25 Nov 2008 19:50:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patch againt: tip/tracing/marker

==========
Currently, wake_up() function behavior depend on the way of
wait queue adding function.


                              wake_up()          wake_up_all()
---------------------------------------------------------------
add_wait_queue()              wake up all        wake up all
add_wait_queue_exclusive()    wake up one task   wake up all


Unforunately, poll_wait() always use add_wait_queue().
it means there is no way that wake up only one process in polled processes.
wake_up() also wake up all sleeping processes, not 1 process.


Mathieu Desnoyers explained it cause following problem to LTTng.

   In LTTng, all lttd readers are polling all the available debugfs files
   for data. This is principally because the number of reader threads is
   user-defined and there are typical workloads where a single CPU is
   producing most of the tracing data and all other CPUs are idle,
   available to consume data. It therefore makes sense not to tie those
   threads to specific buffers. However, when the number of threads grows,
   we face a "thundering herd" problem where many threads can be woken up
   and put back to sleep, leaving only a single thread doing useful work.


this patch introduce poll_wait_exclusive() new API for allow wake up
only one process.

<usage example>
unsigned int foo_device_poll(struct file *file,
		         struct poll_table_struct *wait)
{
	poll_wait_exclusive(file, &foo_wait_queue, wait);
	if (data_exist)
		return POLLIN | POLLRDNORM;
	return 0;
}
</usage example>


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/eventpoll.c       |    7 +++++--
 fs/select.c          |    9 ++++++---
 include/linux/poll.h |   13 +++++++++++--
 3 files changed, 22 insertions(+), 7 deletions(-)



Index: b/fs/eventpoll.c
===================================================================
--- a/fs/eventpoll.c	2008-11-25 19:05:28.000000000 +0900
+++ b/fs/eventpoll.c	2008-11-25 19:15:50.000000000 +0900
@@ -655,7 +655,7 @@ out_unlock:
  * target file wakeup lists.
  */
 static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
-				 poll_table *pt)
+				 poll_table *pt, int exclusive)
 {
 	struct epitem *epi = ep_item_from_epqueue(pt);
 	struct eppoll_entry *pwq;
@@ -664,7 +664,10 @@ static void ep_ptable_queue_proc(struct 
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		pwq->whead = whead;
 		pwq->base = epi;
-		add_wait_queue(whead, &pwq->wait);
+		if (exclusive)
+			add_wait_queue_exclusive(whead, &pwq->wait);
+		else
+			add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
 		epi->nwait++;
 	} else {
Index: b/fs/select.c
===================================================================
--- a/fs/select.c	2008-11-25 19:04:26.000000000 +0900
+++ b/fs/select.c	2008-11-25 19:15:50.000000000 +0900
@@ -104,7 +104,7 @@ struct poll_table_page {
  * poll table.
  */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-		       poll_table *p);
+		       poll_table *p, int exclusive);
 
 void poll_initwait(struct poll_wqueues *pwq)
 {
@@ -173,7 +173,7 @@ static struct poll_table_entry *poll_get
 
 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-				poll_table *p)
+		       poll_table *p, int exclusive)
 {
 	struct poll_table_entry *entry = poll_get_entry(p);
 	if (!entry)
@@ -182,7 +182,10 @@ static void __pollwait(struct file *filp
 	entry->filp = filp;
 	entry->wait_address = wait_address;
 	init_waitqueue_entry(&entry->wait, current);
-	add_wait_queue(wait_address, &entry->wait);
+	if (exclusive)
+		add_wait_queue_exclusive(wait_address, &entry->wait);
+	else
+		add_wait_queue(wait_address, &entry->wait);
 }
 
 /**
Index: b/include/linux/poll.h
===================================================================
--- a/include/linux/poll.h	2008-11-25 19:04:26.000000000 +0900
+++ b/include/linux/poll.h	2008-11-25 19:19:54.000000000 +0900
@@ -28,7 +28,8 @@ struct poll_table_struct;
 /* 
  * structures and helpers for f_op->poll implementations
  */
-typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *, struct poll_table_struct *);
+typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *,
+				struct poll_table_struct *, int);
 
 typedef struct poll_table_struct {
 	poll_queue_proc qproc;
@@ -37,7 +38,15 @@ typedef struct poll_table_struct {
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
 	if (p && wait_address)
-		p->qproc(filp, wait_address, p);
+		p->qproc(filp, wait_address, p, 0);
+}
+
+static inline void poll_wait_exclusive(struct file *filp,
+				       wait_queue_head_t *wait_address,
+				       poll_table *p)
+{
+	if (p && wait_address)
+		p->qproc(filp, wait_address, p, 1);
 }
 
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)


