Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbXIYK5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbXIYK5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbXIYK5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:57:24 -0400
Received: from sacred.ru ([62.205.161.221]:39752 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXIYK5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:57:24 -0400
Message-ID: <46F8E8C5.2050502@openvz.org>
Date: Tue, 25 Sep 2007 14:53:57 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Uninline the task_xid_nr_ns() calls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 25 Sep 2007 14:56:23 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since these are expanded into call to pid_nr_ns() anyway, it's
OK to move the whole routine out-of-line. This is a cheap way 
to save ~100 bytes from vmlinux. Together with the previous two
patches, it saves half-a-kilo from the vmlinux.

Un-inline other (currently inlined) functions must be done with
additional performance testing.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fe238fb..4108cce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1228,11 +1228,7 @@ static inline pid_t task_pid_nr(struct t
 	return tsk->pid;
 }
 
-static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pid(tsk), ns);
-}
+pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_pid_vnr(struct task_struct *tsk)
 {
@@ -1245,11 +1241,7 @@ static inline pid_t task_tgid_nr(struct 
 	return tsk->tgid;
 }
 
-static inline pid_t task_tgid_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_tgid(tsk), ns);
-}
+pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_tgid_vnr(struct task_struct *tsk)
 {
@@ -1262,11 +1254,7 @@ static inline pid_t task_pgrp_nr(struct 
 	return tsk->signal->__pgrp;
 }
 
-static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pgrp(tsk), ns);
-}
+pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
 {
@@ -1279,11 +1267,7 @@ static inline pid_t task_session_nr(stru
 	return tsk->signal->__session;
 }
 
-static inline pid_t task_session_nr_ns(struct task_struct *tsk,
-		struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_session(tsk), ns);
-}
+pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
 
 static inline pid_t task_session_vnr(struct task_struct *tsk)
 {
diff --git a/kernel/pid.c b/kernel/pid.c
index e2e060e..0032a88 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -412,6 +412,30 @@ pid_t pid_nr_ns(struct pid *pid, struct 
 	return nr;
 }
 
+pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pid(tsk), ns);
+}
+EXPORT_SYMBOL(task_pid_nr_ns);
+
+pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_tgid(tsk), ns);
+}
+EXPORT_SYMBOL(task_tgid_nr_ns);
+
+pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_pgrp(tsk), ns);
+}
+EXPORT_SYMBOL(task_pgrp_nr_ns);
+
+pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+{
+	return pid_nr_ns(task_session(tsk), ns);
+}
+EXPORT_SYMBOL(task_session_nr_ns);
+
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
