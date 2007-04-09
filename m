Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbXDIMwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbXDIMwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 08:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbXDIMwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 08:52:30 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:47372 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXDIMw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 08:52:29 -0400
Message-ID: <461A37FE.6030603@sw.ru>
Date: Mon, 09 Apr 2007 16:56:30 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
CC: devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Chandra Seetharaman <sekharan@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rohit Seth <rohitseth@google.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 6/8] Per container OOM killer
References: <461A3010.90403@sw.ru>
In-Reply-To: <461A3010.90403@sw.ru>
Content-Type: multipart/mixed;
 boundary="------------090102020609060604010609"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090102020609060604010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

When container is completely out of memory some tasks should
die. This is unfair to kill the current task, so a task with
the largest RSS is chosen and killed. The code re-uses current
OOM killer select_bad_process() for task selection.

--------------090102020609060604010609
Content-Type: text/plain;
 name="diff-rss-container-oom-killer"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff-rss-container-oom-killer"

diff -upr linux-2.6.20.orig/include/linux/rss_container.h linux-2.6.20-2/include/linux/rss_container.h
--- linux-2.6.20.orig/include/linux/rss_container.h	2007-04-09 11:26:12.000000000 +0400
+++ linux-2.6.20-2/include/linux/rss_container.h	2007-04-09 11:26:06.000000000 +0400
@@ -19,6 +19,7 @@
 void container_rss_add(struct page_container *);
 void container_rss_del(struct page_container *);
 void container_rss_release(struct page_container *);
+void container_out_of_memory(struct rss_container *);
 
 void mm_init_container(struct mm_struct *mm, struct task_struct *tsk);
 void mm_free_container(struct mm_struct *mm);
diff -upr linux-2.6.20.orig/mm/oom_kill.c linux-2.6.20-2/mm/oom_kill.c
--- linux-2.6.20.orig/mm/oom_kill.c	2007-03-06 19:09:50.000000000 +0300
+++ linux-2.6.20-2/mm/oom_kill.c	2007-04-09 11:26:06.000000000 +0400
@@ -24,6 +24,7 @@
 #include <linux/cpuset.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/rss_container.h>
 
 int sysctl_panic_on_oom;
 /* #define DEBUG */
@@ -47,7 +48,8 @@ int sysctl_panic_on_oom;
  *    of least surprise ... (be careful when you change it)
  */
 
-unsigned long badness(struct task_struct *p, unsigned long uptime)
+unsigned long badness(struct task_struct *p, unsigned long uptime,
+		struct rss_container *rss)
 {
 	unsigned long points, cpu_time, run_time, s;
 	struct mm_struct *mm;
@@ -60,6 +62,13 @@ unsigned long badness(struct task_struct
 		return 0;
 	}
 
+#ifdef CONFIG_RSS_CONTAINER
+	if (rss != NULL && mm->rss_container != rss) {
+		task_unlock(p);
+		return 0;
+	}
+#endif
+
 	/*
 	 * The memory size of the process is the basis for the badness.
 	 */
@@ -200,7 +209,8 @@ static inline int constrained_alloc(stru
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
-static struct task_struct *select_bad_process(unsigned long *ppoints)
+static struct task_struct *select_bad_process(unsigned long *ppoints,
+		struct rss_container *rss)
 {
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
@@ -254,7 +264,7 @@ static struct task_struct *select_bad_pr
 		if (p->oomkilladj == OOM_DISABLE)
 			continue;
 
-		points = badness(p, uptime.tv_sec);
+		points = badness(p, uptime.tv_sec, rss);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
@@ -435,7 +445,7 @@ retry:
 		 * Rambo mode: Shoot down a process and hope it solves whatever
 		 * issues we may have.
 		 */
-		p = select_bad_process(&points);
+		p = select_bad_process(&points, NULL);
 
 		if (PTR_ERR(p) == -1UL)
 			goto out;
@@ -464,3 +474,27 @@ out:
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
+
+#ifdef CONFIG_RSS_CONTAINER
+void container_out_of_memory(struct rss_container *rss)
+{
+	unsigned long points = 0;
+	struct task_struct *p;
+
+	container_lock();
+	read_lock(&tasklist_lock);
+retry:
+	p = select_bad_process(&points, rss);
+	if (PTR_ERR(p) == -1UL)
+		goto out;
+
+	if (!p)
+		p = current;
+
+	if (oom_kill_process(p, points, "Container out of memory"))
+		goto retry;
+out:
+	read_unlock(&tasklist_lock);
+	container_unlock();
+}
+#endif


--------------090102020609060604010609--
