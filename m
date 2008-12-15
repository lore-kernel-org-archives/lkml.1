Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYLORLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYLORLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 12:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYLORLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 12:11:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60478 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYLORLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 12:11:36 -0500
Date: Mon, 15 Dec 2008 18:09:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: broken do_each_pid_{thread,task}
Message-ID: <20081215170937.GA24080@redhat.com>
References: <494581D7.6000203@gmail.com> <m1wse29roy.fsf@frodo.ebiederm.org> <20081215104716.GB11106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215104716.GB11106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15, Oleg Nesterov wrote:
>
> On 12/14, Eric W. Biederman wrote:
> >
> > Although seeing the unexpected corner case it gets us into I think it would
> > be good to reconsider this test.

So. I can't decide whether this patch is cleanup or the further
uglification, but if anyone likes it I will be happy to send it.

Then we can kill do_each_pid_task/while_each_pid_task completely.

Oleg.

--- linux-2.6.27/include/linux/pid.h~PID_FOR_EACH	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/include/linux/pid.h	2008-12-15 17:51:50.000000000 +0100
@@ -144,21 +144,25 @@ static inline pid_t pid_nr(struct pid *p
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
-		if (pid != NULL)					\
-			hlist_for_each_entry_rcu((task), pos___,	\
-				&pid->tasks[type], pids[type].node) {
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

