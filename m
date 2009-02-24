Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbZBXVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbZBXVwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZBXVwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:52:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZBXVwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:52:35 -0500
Date: Tue, 24 Feb 2009 22:49:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jiri Slaby <jirislaby@gmail.com>, kenchen@google.com,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC, PATCH] introduce pid_for_each_task() to replace
	do_each_pid_task()
Message-ID: <20090224214938.GA3670@redhat.com>
References: <494581D7.6000203@gmail.com> <m1wse29roy.fsf@frodo.ebiederm.org> <20081215104716.GB11106@redhat.com> <20081215170937.GA24080@redhat.com> <49A3F48E.5030008@gmail.com> <20090224154936.GA13837@redhat.com> <49A41E90.8090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A41E90.8090304@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pid_for_each_task() does the same as
do_each_pid_task() + while_each_pid_task(), so instead of

	do_each_pid_task(pid, type, task) {
		do_something(task);
	} while_each_pid_task(pid, type, task);

we can just do

	pid_for_each_task(pid, type, task)
		do_something(task);

This looks better, and we can use break/continue safely.

This patch changes do_each_pid_task() to use pid_for_each_task(), once
we convert all users of do_each_pid_task() we can kill this helper.

However. The implementation of pid_for_each_task() itself is anything
but clean/simple, so this patch asks for the explicit acks/nacks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/include/linux/pid.h~FOR_EACH_PID	2009-01-12 23:07:48.000000000 +0100
+++ 6.29-rc3/include/linux/pid.h	2009-02-24 22:07:48.000000000 +0100
@@ -162,21 +162,25 @@ static inline pid_t pid_nr(struct pid *p
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
 pid_t pid_vnr(struct pid *pid);
 
+/*
+ * Both old and new leaders may be attached to the same pid in the
+ * middle of de_thread(), that is why we do the special check for
+ * PIDTYPE_PID below.
+ */
+#define pid_for_each_task(pid, type, p)	\
+	for (p = (pid) ? (void*)(pid)->tasks[type].first : NULL;	\
+	     rcu_dereference(p) && ({					\
+		prefetch(((struct hlist_node*)p)->next);		\
+		p = hlist_entry((void*)p, typeof(*p), pids[type].node);	\
+		1; });							\
+	     p = ((type) != PIDTYPE_PID) ?				\
+		(void*)(p)->pids[type].node.next : NULL)
+
 #define do_each_pid_task(pid, type, task)				\
 	do {								\
-		struct hlist_node *pos___;				\
-		if ((pid) != NULL)					\
-			hlist_for_each_entry_rcu((task), pos___,	\
-				&(pid)->tasks[type], pids[type].node) {
+		pid_for_each_task(pid, type, task)
 
-			/*
-			 * Both old and new leaders may be attached to
-			 * the same pid in the middle of de_thread().
-			 */
 #define while_each_pid_task(pid, type, task)				\
-				if (type == PIDTYPE_PID)		\
-					break;				\
-			}						\
 	} while (0)
 
 #define do_each_pid_thread(pid, type, task)				\

