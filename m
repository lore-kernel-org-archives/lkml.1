Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbYGQPRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbYGQPRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbYGQPRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:17:36 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:37755 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbYGQPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:17:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8yAOj6fkjVchRXPGdsb2JhbACBWYZziWkBAQEBLQGdWw
Message-ID: <487F5DA1.6000107@hozac.com>
Date: Thu, 17 Jul 2008 10:56:33 -0400
From: Daniel Hokka Zakrisson <daniel@hozac.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: containers@lists.linux-foundation.org, oleg@tv-sign.ru,
       ebiederm@xmission.com, xemul@openvz.org, akpm@linux-foundation.org
Subject: [PATCH 2/2] signals: replace p->pid == 1 check with a check for task_child_reaper
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p->pid == 1 is insufficient when there are multiple pid namespaces.
Instead, check whether the task is in the current task's
child reaper's thread group.

Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>

diff --git a/kernel/signal.c b/kernel/signal.c
index 93713a5..be932b9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1142,10 +1142,20 @@ static int kill_something_info(int sig, struct 
siginfo *info, int pid)
  				pid ? find_vpid(-pid) : task_pgrp(current));
  	} else {
  		int retval = 0, count = 0;
-		struct task_struct * p;
+		struct task_struct *p, *reaper = task_child_reaper(current);
+
+		/*
+		 * The reaper has died, so there's probably a
+		 * SIGKILL pending. Return.
+		 */
+		if (unlikely(!reaper)) {
+			ret = -ESRCH;
+			goto out;
+		}

  		for_each_process(p) {
-			if (p->pid > 1 && !same_thread_group(p, current) &&
+			if (!same_thread_group(p, reaper) &&
+			    !same_thread_group(p, current) &&
  			    task_in_pid_ns(p, current->nsproxy->pid_ns)) {
  				int err = group_send_sig_info(sig, info, p);
  				++count;
@@ -1155,6 +1165,7 @@ static int kill_something_info(int sig, struct 
siginfo *info, int pid)
  		}
  		ret = count ? retval : -ESRCH;
  	}
+out:
  	read_unlock(&tasklist_lock);

  	return ret;
-- 
1.5.5.1
