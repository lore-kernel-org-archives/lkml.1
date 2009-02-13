Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZBMK5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZBMK5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZBMK5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:57:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZBMK5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:57:22 -0500
Date: Fri, 13 Feb 2009 11:54:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] ptrace_untrace: fix the SIGNAL_STOP_STOPPED check
Message-ID: <20090213105442.GA24328@redhat.com>
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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/ptrace.c~2_FIX_STOPPED	2009-02-13 11:06:56.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-02-13 11:38:50.000000000 +0100
@@ -60,11 +60,15 @@ static void ptrace_untrace(struct task_s
 {
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
-		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
+		/*
+		 * If the group stop is completed or in progress,
+		 * this thread was already counted as stopped.
+		 */
+		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
+		    child->signal->group_stop_count)
 			__set_task_state(child, TASK_STOPPED);
-		} else {
+		else
 			signal_wake_up(child, 1);
-		}
 	}
 	spin_unlock(&child->sighand->siglock);
 }

