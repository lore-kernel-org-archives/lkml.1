Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYDJIqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYDJIqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYDJIq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:46:28 -0400
Received: from sacred.ru ([62.205.161.221]:56177 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbYDJIq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:46:28 -0400
Message-ID: <47FDD6EF.5050101@openvz.org>
Date: Thu, 10 Apr 2008 12:59:27 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] Bsdacct: account task in each namespace is is visible
 from
References: <47FDD267.80700@openvz.org>
In-Reply-To: <47FDD267.80700@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 10 Apr 2008 12:34:39 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just makes the acct_proces walk the pid namespaces
from current up to the top and account a task in each
with the accounting turned on.

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

