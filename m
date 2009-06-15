Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZFOIne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZFOIne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZFOInY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:43:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021AbZFOInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:43:23 -0400
Date: Mon, 15 Jun 2009 10:36:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with
 __exit_signal()
Message-ID: <20090615103650.17b3a30b@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect thread_group_cputime() call by siglock, to avoid possible (but
to be honest - very improbable) double times accounting of exiting task.
This is revert of commit 2b5fe6de58276d0b5a7c884d5dbfc300ca47db78
"thread_group_cputime: move a couple of callsites outside of ->siglock",
but implementation of thread_group_cputime() was different then.

In thread_group_cputime() we loop on all threads within the group to sum
they cputimes. After finish loop, we add killed tasks times from tsk->signal.
If thread (one or more) exit in gap between loop and adding killed tasks
times, __exit_signal() function add already accounted times to tsk->signal.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 438d99a..aef73e1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -914,8 +914,8 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime cputime;
 	cputime_t cutime, cstime;
 
-	thread_group_cputime(current, &cputime);
 	spin_lock_irq(&current->sighand->siglock);
+	thread_group_cputime(current, &cputime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
-- 
1.5.5.6
