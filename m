Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbYEOLOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbYEOLOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYEOLOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:14:37 -0400
Received: from sacred.ru ([62.205.161.221]:41605 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221AbYEOLOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:14:36 -0400
Message-ID: <482C1A7B.8050601@openvz.org>
Date: Thu, 15 May 2008 15:11:55 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] Bsdacct: account dying tasks in all relevant namespaces
References: <482C15FE.7070300@openvz.org>
In-Reply-To: <482C15FE.7070300@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 15 May 2008 15:14:15 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just makes the acct_proces walk the pid namespaces from 
current up to the top and account a task in each with the 
accounting turned on.

ns->parent access if safe lockless, since current it still
alive and holds its namespace, which in turn holds its parent.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 kernel/acct.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 7fc9f9d..0feba97 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -631,15 +631,9 @@ void acct_collect(long exitcode, int group_dead)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
-/**
- * acct_process - now just a wrapper around do_acct_process
- *
- * handles process accounting for an exiting task
- */
-void acct_process(void)
+static void acct_process_in_ns(struct pid_namespace *ns)
 {
 	struct file *file = NULL;
-	struct pid_namespace *ns = task_active_pid_ns(current);
 	struct bsd_acct_struct *acct;
 
 	acct = ns->bacct;
@@ -661,3 +655,16 @@ void acct_process(void)
 	do_acct_process(acct, ns, file);
 	fput(file);
 }
+
+/**
+ * acct_process - now just a wrapper around do_acct_process
+ *
+ * handles process accounting for an exiting task
+ */
+void acct_process(void)
+{
+	struct pid_namespace *ns;
+
+	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
+		acct_process_in_ns(ns);
+}
-- 
1.5.3.4
