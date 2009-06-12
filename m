Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZFLGz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZFLGz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZFLGzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:55:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZFLGzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:55:49 -0400
Date: Fri, 12 Jun 2009 08:49:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with
 __exit_signal()
Message-ID: <20090612084910.1b63b0af@dhcp-lab-109.englab.brq.redhat.com>
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

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e7998cf..0805d08 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -913,8 +913,8 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime cputime;
 	cputime_t cutime, cstime;
 
-	thread_group_cputime(current, &cputime);
 	spin_lock_irq(&current->sighand->siglock);
+	thread_group_cputime(current, &cputime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
-- 
1.6.0.6

