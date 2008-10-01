Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYJAOSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYJAOSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYJAOSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:18:24 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:60924
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752375AbYJAOSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:18:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: add a stacktrace on enqueue_pushable error
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com
Date: Wed, 01 Oct 2008 10:22:47 -0400
Message-ID: <20081001142117.27846.83759.stgit@dev.haskins.net>
In-Reply-To: <20080930044320.GA4685@linux.vnet.ibm.com>
References: <20080930044320.GA4685@linux.vnet.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chirag,
  Please apply this patch to your 26.5-rt9 tree for ppc64, enable
  CONFIG_PROVE_LOCKING (which enables CONFIG_STACKTRACE) and give it a whirl.
  If you get an oops, please post the console output.

Thanks!

-Greg

------------------
sched: add a stacktrace on enqueue_pushable error

NOT FOR INCLUSION!

This is to help debug an issue discovered by Chirag Jog in the thread

http://lkml.org/lkml/2008/9/25/189

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    6 ++++++
 kernel/sched_rt.c     |   20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 67da014..53e8a6a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -87,6 +87,7 @@ struct sched_param {
 #include <linux/task_io_accounting.h>
 #include <linux/kobject.h>
 #include <linux/latencytop.h>
+#include <linux/stacktrace.h>
 
 #include <asm/processor.h>
 
@@ -1170,6 +1171,11 @@ struct task_struct {
 
 	struct list_head tasks;
 	struct plist_node pushable_tasks;
+	struct {
+		unsigned long data[15];
+		struct stack_trace trace;
+		pid_t pid;
+	} pushable_stack;
 
 	/*
 	 * ptrace_list/ptrace_children forms the list of my children
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 57a0c0d..0e6a88c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -55,7 +55,25 @@ static void update_rt_migration(struct rq *rq)
 
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
-	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	if (plist_node_empty(&p->pushable_tasks)) {
+		struct stack_trace *trace = &p->pushable_stack.trace;
+
+		trace->nr_entries = 0;
+		trace->max_entries = sizeof(p->pushable_stack.data)/sizeof(p->pushable_stack.data[0]);
+		trace->entries = &p->pushable_stack.data[0];
+		trace->skip = 0;
+
+		save_stack_trace(trace);
+
+		p->pushable_stack.pid = current->pid;
+	} else {
+		printk(KERN_CRIT "redundant enqueue by %d detected\n",
+		       p->pushable_stack.pid);
+		print_stack_trace(&p->pushable_stack.trace, 5);
+
+		BUG_ON(!plist_node_empty(&p->pushable_tasks));
+	}
+
 	plist_node_init(&p->pushable_tasks, p->prio);
 	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
 }

