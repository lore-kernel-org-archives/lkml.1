Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYESHsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYESHsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbYESHs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:48:28 -0400
Received: from sacred.ru ([62.205.161.221]:37003 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbYESHs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:48:27 -0400
Message-ID: <48313025.2060103@openvz.org>
Date: Mon, 19 May 2008 11:45:41 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH (resend)] Bsdacct: stir up comments around acct_process
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 19 May 2008 11:48:02 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the one describing what this function is and add one
more - about locking absence around pid namespaces loop.

Changes from v1: fixed misprints pointed out by Randy.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>

---

diff --git a/kernel/acct.c b/kernel/acct.c
index 0feba97..d7b670c 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -657,7 +657,8 @@ static void acct_process_in_ns(struct pid_namespace *ns)
 }
 
 /**
- * acct_process - now just a wrapper around do_acct_process
+ * acct_process - now just a wrapper around acct_process_in_ns,
+ * which in turn is a wrapper around do_acct_process.
  *
  * handles process accounting for an exiting task
  */
@@ -665,6 +666,11 @@ void acct_process(void)
 {
 	struct pid_namespace *ns;
 
+	/*
+	 * This loop is safe lockless, since current is still
+	 * alive and holds its namespace, which in turn holds
+	 * its parent.
+	 */
 	for (ns = task_active_pid_ns(current); ns != NULL; ns = ns->parent)
 		acct_process_in_ns(ns);
 }
