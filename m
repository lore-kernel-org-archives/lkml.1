Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYFIOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYFIOq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbYFIOqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:46:14 -0400
Received: from sacred.ru ([62.205.161.221]:48174 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420AbYFIOqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:46:12 -0400
Message-ID: <484D4199.7090609@openvz.org>
Date: Mon, 09 Jun 2008 18:43:37 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] pidns: remove now unused find_pid function.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 09 Jun 2008 18:45:52 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one had the only users so far - the kill_proc, which is
removed, so drop this (invalid in namespaced world) call too.

And of course - erase all references on it from comments.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 include/linux/pid.h   |    4 +---
 include/linux/sched.h |    2 +-
 kernel/pid.c          |    8 +-------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 6f084b9..ff1b2a5 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -48,7 +48,7 @@ enum pid_type
  */
 
 struct upid {
-	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
+	/* Try to keep pid_chain in the same cacheline as nr for find_vpid */
 	int nr;
 	struct pid_namespace *ns;
 	struct hlist_node pid_chain;
@@ -105,14 +105,12 @@ extern struct pid_namespace init_pid_ns;
  * or rcu_read_lock() held.
  *
  * find_pid_ns() finds the pid in the namespace specified
- * find_pid() find the pid by its global id, i.e. in the init namespace
  * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
  *
  * see also find_task_by_pid() set in include/linux/sched.h
  */
 extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
-extern struct pid *find_pid(int nr);
 
 /*
  * Lookup a PID in the hash table, and return with it's count elevated.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4d877ea..7c0443b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1710,7 +1710,7 @@ extern struct pid_namespace init_pid_ns;
  * find_task_by_pid():
  *      finds a task by its global pid
  *
- * see also find_pid() etc in include/linux/pid.h
+ * see also find_vpid() etc in include/linux/pid.h
  */
 
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
diff --git a/kernel/pid.c b/kernel/pid.c
index 30bd5d4..9da013e 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -309,12 +309,6 @@ struct pid *find_vpid(int nr)
 }
 EXPORT_SYMBOL_GPL(find_vpid);
 
-struct pid *find_pid(int nr)
-{
-	return find_pid_ns(nr, &init_pid_ns);
-}
-EXPORT_SYMBOL_GPL(find_pid);
-
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
@@ -482,7 +476,7 @@ EXPORT_SYMBOL(task_session_nr_ns);
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
- * If there is a pid at nr this function is exactly the same as find_pid.
+ * If there is a pid at nr this function is exactly the same as find_pid_ns.
  */
 struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 {
-- 
1.5.3.4

