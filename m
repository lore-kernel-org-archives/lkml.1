Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYA1PTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYA1PTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760424AbYA1PS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:18:57 -0500
Received: from sacred.ru ([62.205.161.221]:53816 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761380AbYA1PS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:18:56 -0500
Message-ID: <479DF260.9080405@openvz.org>
Date: Mon, 28 Jan 2008 18:18:56 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 4/4] Get rid of the kill_pgrp_info() function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 28 Jan 2008 18:18:35 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one caller left - the kill_pgrp one - so merge
these two functions and forget the kill_pgrp_info one.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@tv-sign.ru>

--

 include/linux/sched.h |    1 -
 kernel/signal.c       |   19 +++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 198659b..538f14a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1680,7 +1680,6 @@ extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
-extern int kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
diff --git a/kernel/signal.c b/kernel/signal.c
index ae9f6ba..a469873 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1036,17 +1036,6 @@ int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp)
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
@@ -1235,7 +1224,13 @@ force_sigsegv(int sig, struct task_struct *p)
 
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

