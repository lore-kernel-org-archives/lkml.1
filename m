Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYCYE1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYCYE1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYCYE1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:27:36 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35384 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYCYE1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:27:35 -0400
Message-ID: <47E87F2A.2040303@bk.jp.nec.com>
Date: Tue, 25 Mar 2008 13:27:22 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1
 case
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Thanks for some patches about tasklist_lock. The avoidance of
tasklist_lock is very important for us.  And now, I found another
avoidable tasklist_lock, and made the patch. Could you please have a
look?

This patch avoid taking tasklist_lock in kill_something_info() when
the pid is -1. It can convert to rcu_read_lock() for this case because
group_send_sig_info() doesn't need tasklist_lock.

This patch is for 2.6.25-rc5-mm1.

Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
---
diff --git a/kernel/signal.c b/kernel/signal.c
index 3edbfd4..a888c58 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1089,14 +1089,16 @@ static int kill_something_info(int sig, struct siginfo 
*info, int pid)
  		return ret;
  	}

-	read_lock(&tasklist_lock);
  	if (pid != -1) {
+		read_lock(&tasklist_lock);
  		ret = __kill_pgrp_info(sig, info,
  				pid ? find_vpid(-pid) : task_pgrp(current));
+		read_unlock(&tasklist_lock);
  	} else {
  		int retval = 0, count = 0;
  		struct task_struct * p;

+		rcu_read_lock();
  		for_each_process(p) {
  			if (p->pid > 1 && !same_thread_group(p, current)) {
  				int err = group_send_sig_info(sig, info, p);
@@ -1106,8 +1108,8 @@ static int kill_something_info(int sig, struct siginfo 
*info, int pid)
  			}
  		}
  		ret = count ? retval : -ESRCH;
+		rcu_read_unlock();
  	}
-	read_unlock(&tasklist_lock);

  	return ret;
  }
