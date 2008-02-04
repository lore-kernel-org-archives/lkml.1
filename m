Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYBDNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYBDNDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYBDNDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:03:17 -0500
Received: from sacred.ru ([62.205.161.221]:34011 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbYBDNDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:03:16 -0500
Message-ID: <47A70D10.5000305@openvz.org>
Date: Mon, 04 Feb 2008 16:03:12 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 2/2 (resend)] Get rid of the kill_pgrp_info() function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 04 Feb 2008 16:02:55 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one caller left - the kill_pgrp one - so merge
these two functions and forget the kill_pgrp_info one.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@tv-sign.ru>

---
 include/linux/sched.h |    1 -
 kernel/signal.c       |   21 ++++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1256e25..64def57 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1689,7 +1689,6 @@ extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
-extern int kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
diff --git a/kernel/signal.c b/kernel/signal.c
index a805c74..2c1f08d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1018,7 +1018,7 @@ int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 }
 
 /*
- * kill_pgrp_info() sends a signal to a process group: this is what the tty
+ * __kill_pgrp_info() sends a signal to a process group: this is what the tty
  * control characters do (^C, ^Z etc)
  */
 
@@ -1037,17 +1037,6 @@ int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
 	return success ? 0 : retval;
 }
 
-int kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
-{
-	int retval;
-
-	read_lock(&tasklist_lock);
-	retval = __kill_pgrp_info(sig, info, pgrp);
-	read_unlock(&tasklist_lock);
-
-	return retval;
-}
-
 int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 {
 	int error = -ESRCH;
@@ -1236,7 +1225,13 @@ force_sigsegv(int sig, struct task_struct *p)
 
 int kill_pgrp(struct pid *pid, int sig, int priv)
 {
-	return kill_pgrp_info(sig, __si_special(priv), pid);
+	int ret;
+
+	read_lock(&tasklist_lock);
+	ret = __kill_pgrp_info(sig, __si_special(priv), pid);
+	read_unlock(&tasklist_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(kill_pgrp);
 
-- 
1.5.3.4

