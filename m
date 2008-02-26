Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbYBZQMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbYBZQMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYBZQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:12:11 -0500
Received: from sacred.ru ([62.205.161.221]:41351 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYBZQML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:12:11 -0500
Message-ID: <47C43A32.3090901@openvz.org>
Date: Tue, 26 Feb 2008 19:11:30 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: [PATCH] pidns: make pid->level and pid_ns->level unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 26 Feb 2008 19:11:20 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These values represent the nesting level of a namespace and 
pids living in it, and it's always non-negative.

Turning this from int to unsigned int saves some space in 
pid.c (11 bytes on x86 and 64 on ia64) by letting the compiler 
optimize the pid_nr_ns a bit. E.g. on ia64 this removes the 
sign extension calls, which compiler adds to optimize access
to pid->nubers[ns->level].

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/include/linux/pid.h b/include/linux/pid.h
index c798081..03573e3 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -60,7 +60,7 @@ struct pid
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
-	int level;
+	unsigned int level;
 	struct upid numbers[1];
 };
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index fcd61fa..caff528 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -20,7 +20,7 @@ struct pid_namespace {
 	int last_pid;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
-	int level;
+	unsigned int level;
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 6d792b6..cb17497 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -66,7 +66,7 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(int level)
+static struct pid_namespace *create_pid_namespace(unsigned int level)
 {
 	struct pid_namespace *ns;
 	int i;
