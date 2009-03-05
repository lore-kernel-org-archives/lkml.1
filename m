Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZCEXdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZCEXdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbZCEXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:33:11 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:36843 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342AbZCEXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:33:10 -0500
Message-Id: <20090305225515.055491563@polymtl.ca>
References: <20090305224728.947235917@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 05 Mar 2009 17:47:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [RFC patch 15/41] Poll : add poll_wait_set_exclusive
Content-Disposition: inline; filename=poll-wait-exclusive.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu,  5 Mar 2009 23:14:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Problem description :

In LTTng, all lttd readers are polling all the available debugfs files
for data. This is principally because the number of reader threads is
user-defined and there are typical workloads where a single CPU is
producing most of the tracing data and all other CPUs are idle,
available to consume data. It therefore makes sense not to tie those
threads to specific buffers. However, when the number of threads grows,
we face a "thundering herd" problem where many threads can be woken up
and put back to sleep, leaving only a single thread doing useful work.

Solution :

I just created a patch which adds a poll_wait_set_exclusive() primitive
to poll(), so the code which implements the pollfd operation can specify
that only a single waiter must be woken up.

poll_wait_set_exclusive : set poll wait queue to exclusive
Sets up a poll wait queue to use exclusive wakeups. This is useful to
wake up only one waiter at each wakeup. Used to work-around "thundering herd"
problem.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/select.c          |   41 ++++++++++++++++++++++++++++++++++++++---
 include/linux/poll.h |    2 ++
 2 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/fs/select.c
===================================================================
--- linux-2.6-lttng.orig/fs/select.c	2009-03-05 15:41:29.000000000 -0500
+++ linux-2.6-lttng/fs/select.c	2009-03-05 15:41:42.000000000 -0500
@@ -105,6 +105,9 @@ struct poll_table_page {
  */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 		       poll_table *p);
+static void __pollwait_exclusive(struct file *filp,
+				 wait_queue_head_t *wait_address,
+				 poll_table *p);
 
 void poll_initwait(struct poll_wqueues *pwq)
 {
@@ -144,6 +147,20 @@ void poll_freewait(struct poll_wqueues *
 }
 EXPORT_SYMBOL(poll_freewait);
 
+/**
+ * poll_wait_set_exclusive - set poll wait queue to exclusive
+ *
+ * Sets up a poll wait queue to use exclusive wakeups. This is useful to
+ * wake up only one waiter at each wakeup. Used to work-around "thundering herd"
+ * problem.
+ */
+void poll_wait_set_exclusive(poll_table *p)
+{
+	if (p)
+		init_poll_funcptr(p, __pollwait_exclusive);
+}
+EXPORT_SYMBOL(poll_wait_set_exclusive);
+
 static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 {
 	struct poll_table_page *table = p->table;
@@ -195,8 +212,10 @@ static int pollwake(wait_queue_t *wait, 
 }
 
 /* Add a new entry */
-static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-				poll_table *p)
+static void __pollwait_common(struct file *filp,
+			      wait_queue_head_t *wait_address,
+			      poll_table *p,
+			      int exclusive)
 {
 	struct poll_wqueues *pwq = container_of(p, struct poll_wqueues, pt);
 	struct poll_table_entry *entry = poll_get_entry(pwq);
@@ -207,7 +226,23 @@ static void __pollwait(struct file *filp
 	entry->wait_address = wait_address;
 	init_waitqueue_func_entry(&entry->wait, pollwake);
 	entry->wait.private = pwq;
-	add_wait_queue(wait_address, &entry->wait);
+	if (!exclusive)
+		add_wait_queue(wait_address, &entry->wait);
+	else
+		add_wait_queue_exclusive(wait_address, &entry->wait);
+}
+
+static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
+				poll_table *p)
+{
+	__pollwait_common(filp, wait_address, p, 0);
+}
+
+static void __pollwait_exclusive(struct file *filp,
+				 wait_queue_head_t *wait_address,
+				 poll_table *p)
+{
+	__pollwait_common(filp, wait_address, p, 1);
 }
 
 int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
Index: linux-2.6-lttng/include/linux/poll.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/poll.h	2009-03-05 15:41:29.000000000 -0500
+++ linux-2.6-lttng/include/linux/poll.h	2009-03-05 15:41:32.000000000 -0500
@@ -74,6 +74,8 @@ static inline int poll_schedule(struct p
 	return poll_schedule_timeout(pwq, state, NULL, 0);
 }
 
+extern void poll_wait_set_exclusive(poll_table *p);
+
 /*
  * Scaleable version of the fd_set.
  */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
