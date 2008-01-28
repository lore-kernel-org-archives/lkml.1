Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbYA1PQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbYA1PQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761545AbYA1PQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:16:37 -0500
Received: from sacred.ru ([62.205.161.221]:53425 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761090AbYA1PQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:16:36 -0500
Message-ID: <479DF1D3.3080704@openvz.org>
Date: Mon, 28 Jan 2008 18:16:35 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 3/4] Clean up the kill_someting_info
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 28 Jan 2008 18:16:14 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first stop (of two) in removing the kill_pgrp_info.

All the users of this function are in kernel/signal.c, but all
they need is to call __kill_pgrp_info() with the tasklist_lock
read-locked.

Fortunately, one of its users is the kill_something_info(),
which already needs this lock in one of its branches, so clean
these branches up and call the __kill_pgrp_info() directly.

Based on Oleg's view of how this function should look.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

 kernel/signal.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 280bccb..ae9f6ba 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1133,14 +1133,22 @@ EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
 static int kill_something_info(int sig, struct siginfo *info, int pid)
 {
 	int ret;
-	rcu_read_lock();
-	if (!pid) {
-		ret = kill_pgrp_info(sig, info, task_pgrp(current));
-	} else if (pid == -1) {
+
+	if (pid > 0) {
+		rcu_read_lock();
+		ret = kill_pid_info(sig, info, find_vpid(pid));
+		rcu_read_lock();
+		return ret;
+	}
+
+	read_lock(&tasklist_lock);
+	if (pid != -1) {
+		ret = __kill_pgrp_info(sig, info,
+				pid ? find_vpid(-pid) : task_pgrp(current));
+	} else {
 		int retval = 0, count = 0;
 		struct task_struct * p;
 
-		read_lock(&tasklist_lock);
 		for_each_process(p) {
 			if (p->pid > 1 && !same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
@@ -1149,14 +1157,10 @@ static int kill_something_info(int sig, struct siginfo *info, int pid)
 					retval = err;
 			}
 		}
-		read_unlock(&tasklist_lock);
 		ret = count ? retval : -ESRCH;
-	} else if (pid < 0) {
-		ret = kill_pgrp_info(sig, info, find_vpid(-pid));
-	} else {
-		ret = kill_pid_info(sig, info, find_vpid(pid));
 	}
-	rcu_read_unlock();
+	read_unlock(&tasklist_lock);
+
 	return ret;
 }
 
-- 
1.5.3.4

