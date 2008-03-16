Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbYCPPv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbYCPPv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 11:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYCPPue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 11:50:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35766 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYCPPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 11:50:33 -0400
Date: Sun, 16 Mar 2008 18:54:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080316155453.GA20845@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the buggy init exits, the kernel panics. I see no point for this. It is very
possible that the system is still usable enough, at least to read the logs and
prepare the bug report.

Change exit_child_reaper() to do BUG() instead of panic().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~4_EXIT_DONT_PANIC	2008-03-16 16:49:30.000000000 +0300
+++ 25/kernel/exit.c	2008-03-16 16:49:35.000000000 +0300
@@ -861,8 +861,10 @@ static inline void exit_child_reaper(str
 	if (likely(tsk->group_leader != task_child_reaper(tsk)))
 		return;
 
-	if (tsk->nsproxy->pid_ns == &init_pid_ns)
-		panic("Attempted to kill init!");
+	if (unlikely(tsk->nsproxy->pid_ns == &init_pid_ns)) {
+		printk(KERN_EMERG "Kernel panic - init is killed!\n");
+		BUG();
+	}
 
 	/*
 	 * @tsk is the last thread in the 'cgroup-init' and is exiting.

