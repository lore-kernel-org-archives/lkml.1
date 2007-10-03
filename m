Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbXJCOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbXJCOXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 10:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXJCOXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 10:23:32 -0400
Received: from sacred.ru ([62.205.161.221]:41828 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbXJCOXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 10:23:31 -0400
Message-ID: <4703A53B.9090804@openvz.org>
Date: Wed, 03 Oct 2007 18:20:43 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 2/3] Prepare pid_nr() etc functions to work with not-NULL
 pids
References: <4703A44F.9020402@openvz.org>
In-Reply-To: <4703A44F.9020402@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 03 Oct 2007 18:23:05 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just make the __pid_nr() etc functions that expect the argument
to always be not NULL.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/include/linux/pid.h b/include/linux/pid.h
index e29a900..50b6899 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -135,21 +135,32 @@ extern void zap_pid_ns_processes(struct 
  * see also task_xid_nr() etc in include/linux/sched.h
  */
 
+static inline pid_t __pid_nr(struct pid *pid)
+{
+	return pid->numbers[0].nr;
+}
+
 static inline pid_t pid_nr(struct pid *pid)
 {
 	pid_t nr = 0;
 	if (pid)
-		nr = pid->numbers[0].nr;
+		nr = __pid_nr(pid);
 	return nr;
 }
 
+pid_t __pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
 pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
 
+static inline pid_t __pid_vnr(struct pid *pid)
+{
+	return pid->numbers[pid->level].nr;
+}
+
 static inline pid_t pid_vnr(struct pid *pid)
 {
 	pid_t nr = 0;
 	if (pid)
-		nr = pid->numbers[pid->level].nr;
+		nr = __pid_vnr(pid);
 	return nr;
 }
 
diff --git a/kernel/pid.c b/kernel/pid.c
index d7388d7..b7a11cf 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -430,12 +441,12 @@ struct pid *find_get_pid(pid_t nr)
 	return pid;
 }
 
-pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
+pid_t __pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
 {
 	struct upid *upid;
 	pid_t nr = 0;
 
-	if (pid && ns->level <= pid->level) {
+	if (ns->level <= pid->level) {
 		upid = &pid->numbers[ns->level];
 		if (upid->ns == ns)
 			nr = upid->nr;
@@ -443,6 +454,14 @@ pid_t pid_nr_ns(struct pid *pid, struct 
 	return nr;
 }
 
+pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns)
+{
+	pid_t nr = 0;
+	if (pid)
+		nr = __pid_nr_ns(pid, ns);
+	return nr;
+}
+
 pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
 	return pid_nr_ns(task_pid(tsk), ns);

