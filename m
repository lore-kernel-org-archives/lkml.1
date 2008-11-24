Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbYKXLYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbYKXLYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYKXLYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:24:33 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:38901 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbYKXLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:24:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEABwaKklMROB9/2dsb2JhbACBbc4Pgnw
Date: Mon, 24 Nov 2008 06:24:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Poll : add poll_wait_set_exclusive (fixing thundering
	herd problem in LTTng)
Message-ID: <20081124112429.GA15791@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 05:52:40 up 7 days, 11:33,  3 users,  load average: 0.50, 0.43,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
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

This patch applies both on 2.6.27.7 and current -tip. It is integrated
and used in the LTTng tree as of LTTng 0.59.

poll_wait_set_exclusive : set poll wait queue to exclusive
Sets up a poll wait queue to use exclusive wakeups. This is useful to
wake up only one waiter at each wakeup. Used to work-around "thundering herd"
problem.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/select.c          |   42 +++++++++++++++++++++++++++++++++++++++---
 include/linux/poll.h |    2 ++
 2 files changed, 41 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/fs/select.c
===================================================================
--- linux-2.6-lttng.orig/fs/select.c	2008-11-24 05:16:33.000000000 -0500
+++ linux-2.6-lttng/fs/select.c	2008-11-24 05:55:07.000000000 -0500
@@ -50,6 +50,9 @@ struct poll_table_page {
  */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 		       poll_table *p);
+static void __pollwait_exclusive(struct file *filp,
+				 wait_queue_head_t *wait_address,
+				 poll_table *p);
 
 void poll_initwait(struct poll_wqueues *pwq)
 {
@@ -90,6 +93,21 @@ void poll_freewait(struct poll_wqueues *
 
 EXPORT_SYMBOL(poll_freewait);
 
+/**
+ * poll_wait_set_exclusive : set poll wait queue to exclusive
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
+
+EXPORT_SYMBOL(poll_wait_set_exclusive);
+
 static struct poll_table_entry *poll_get_entry(poll_table *_p)
 {
 	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
@@ -117,8 +135,10 @@ static struct poll_table_entry *poll_get
 }
 
 /* Add a new entry */
-static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
-				poll_table *p)
+static void __pollwait_common(struct file *filp,
+			      wait_queue_head_t *wait_address,
+			      poll_table *p,
+			      int exclusive)
 {
 	struct poll_table_entry *entry = poll_get_entry(p);
 	if (!entry)
@@ -127,7 +147,23 @@ static void __pollwait(struct file *filp
 	entry->filp = filp;
 	entry->wait_address = wait_address;
 	init_waitqueue_entry(&entry->wait, current);
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
 
 #define FDS_IN(fds, n)		(fds->in + n)
Index: linux-2.6-lttng/include/linux/poll.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/poll.h	2008-11-24 05:16:28.000000000 -0500
+++ linux-2.6-lttng/include/linux/poll.h	2008-11-24 05:25:35.000000000 -0500
@@ -65,6 +65,8 @@ struct poll_wqueues {
 extern void poll_initwait(struct poll_wqueues *pwq);
 extern void poll_freewait(struct poll_wqueues *pwq);
 
+extern void poll_wait_set_exclusive(poll_table *p);
+
 /*
  * Scaleable version of the fd_set.
  */
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
