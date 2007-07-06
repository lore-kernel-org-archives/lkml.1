Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbXGFIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbXGFIHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 04:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763228AbXGFIGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 04:06:00 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:21329 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763211AbXGFIF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 04:05:57 -0400
Message-ID: <468DF7AC.10302@openvz.org>
Date: Fri, 06 Jul 2007 12:05:00 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: [PATCH 4/16] Change data structures for pid namespaces
References: <468DF6F7.1010906@openvz.org>
In-Reply-To: <468DF6F7.1010906@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct pid_namespace will have the kmem_cache to allocate
the pids from, the parent, as they are hierarchical, and
the level of nesting value.

struct pid will have a variable length array of pid_number-s
one for each namespace this pid lives in. The level value
shows the level of the namespace this pid lives in and thus -
the number of elements in the numbers array.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

 include/linux/init_task.h     |    6 ++++++
 include/linux/pid.h           |    9 +++++++++
 include/linux/pid_namespace.h |    3 +++
 kernel/pid.c                  |    3 ++-
 4 files changed, 20 insertions(+), 1 deletion(-)

diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid.h linux-2.6.22-rc4-mm2-2/include/linux/pid.h
--- linux-2.6.22-rc4-mm2.orig/include/linux/pid.h	2007-06-14 12:14:29.000000000 +0400
+++ linux-2.6.22-rc4-mm2-2/include/linux/pid.h	2007-07-04 19:00:38.000000000 +0400
@@ -40,6 +40,13 @@ enum pid_type
  * processes.
  */
 
+struct pid_number {
+	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
+	int nr;
+	struct pid_namespace *ns;
+	struct hlist_node pid_chain;
+};
+
 struct pid
 {
 	atomic_t count;
@@ -40,6 +40,8 @@ enum pid_type
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
+	int level;
+	struct pid_number numbers[1];
 };
 
 extern struct pid init_struct_pid;
diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/pid_namespace.h linux-2.6.22-rc4-mm2-2/include/linux/pid_namespace.h
--- linux-2.6.22-rc4-mm2.orig/include/linux/pid_namespace.h	2007-06-14 12:14:29.000000000 +0400
+++ linux-2.6.22-rc4-mm2-2/include/linux/pid_namespace.h	2007-07-04 19:00:39.000000000 +0400
@@ -16,7 +15,10 @@ struct pidmap {
 	struct kref kref;
 	struct pidmap pidmap[PIDMAP_ENTRIES];
 	int last_pid;
+	int level;
 	struct task_struct *child_reaper;
+	struct kmem_cache *pid_cachep;
+	struct pid_namespace *parent;
 };
 
 extern struct pid_namespace init_pid_ns;
diff -upr linux-2.6.22-rc4-mm2.orig/include/linux/init_task.h linux-2.6.22-rc4-mm2-2/include/linux/init_task.h
--- linux-2.6.22-rc4-mm2.orig/include/linux/init_task.h	2007-06-14 12:14:29.000000000 +0400
+++ linux-2.6.22-rc4-mm2-2/include/linux/init_task.h	2007-07-04 19:00:38.000000000 +0400
@@ -91,6 +91,12 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
 	.rcu		= RCU_HEAD_INIT,				\
+	.level		= 0,						\
+	.numbers	= { {						\
+		.nr		= 0,					\
+		.ns		= &init_pid_ns,				\
+		.pid_chain	= { .next = NULL, .pprev = NULL },	\
+	}, }								\
 }
 
 #define INIT_PID_LINK(type) 					\
diff -upr linux-2.6.22-rc4-mm2.orig/kernel/pid.c linux-2.6.22-rc4-mm2-2/kernel/pid.c
--- linux-2.6.22-rc4-mm2.orig/kernel/pid.c	2007-06-14 12:14:29.000000000 +0400
+++ linux-2.6.22-rc4-mm2-2/kernel/pid.c	2007-07-04 19:00:38.000000000 +0400
@@ -61,7 +62,8 @@ static inline int mk_pid(struct pid_name
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
-	.child_reaper = &init_task
+	.level = 0,
+	.child_reaper = &init_task,
 };
 
 EXPORT_SYMBOL_GPL(init_pid_ns);

