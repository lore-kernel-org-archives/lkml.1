Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZBHSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZBHSu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZBHSt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:49:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZBHSt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:49:57 -0500
Date: Sun, 8 Feb 2009 19:47:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
Message-ID: <20090208184730.GA27086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is ancient too. ptrace_untrace() must not resume the task
if the group stop in progress, we should set TASK_STOPPED instead.

Unfortunately, we still have problems here:

	- if the process/thread was traced, SIGNAL_STOP_STOPPED
	  does not necessary means this thread group is stopped.

	- ptrace breaks the bookkeeping of ->group_stop_count.

(the comment above ptrace_untrace() doesn't look exactly right too).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/ptrace.c~3_FIX_STOPPED	2009-02-08 06:22:26.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-02-08 08:52:14.000000000 +0100
@@ -60,7 +60,8 @@ static void ptrace_untrace(struct task_s
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
-		if (child->signal->flags & SIGNAL_STOP_STOPPED)
+		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
+		    child->signal->group_stop_count)
 			__set_task_state(child, TASK_STOPPED);
 		else
 			wake_up_process(child);

