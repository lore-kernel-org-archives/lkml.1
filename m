Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbZISPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbZISPRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZISPRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:17:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757407AbZISPRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:17:15 -0400
Date: Sat, 19 Sep 2009 15:16:45 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Re-add lost cpu_allowed check to sched_fair.c::select_task_rq_fair()
Message-ID: <tip-3f04e8cd5b24727a2500f8ab8f3de730ba47b02c@git.kernel.org>
Git-Commit-ID: 3f04e8cd5b24727a2500f8ab8f3de730ba47b02c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 15:16:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f04e8cd5b24727a2500f8ab8f3de730ba47b02c
Gitweb:     http://git.kernel.org/tip/3f04e8cd5b24727a2500f8ab8f3de730ba47b02c
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Sat, 19 Sep 2009 16:52:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 17:11:31 +0200

sched: Re-add lost cpu_allowed check to sched_fair.c::select_task_rq_fair()

While doing some testing, I pinned mplayer, only to find it
following X around like a puppy. Looking at commit c88d591, I found
a cpu_allowed check that went AWOL.  I plugged it back in where it
looks like it needs to go, and now when I say "sit, stay!", mplayer
obeys again.

'c88d591 sched: Merge select_task_rq_fair() and
sched_balance_self()' accidentally dropped the check, causing
wake_affine() to pull pinned tasks - put it back.

[ v2: use a cheaper version from Peter ]

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 29b35a7..566e3bb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1339,7 +1339,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS))
+		if (sched_feat(AFFINE_WAKEUPS) &&
+		    cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
