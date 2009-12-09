Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZLIJ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZLIJ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZLIJ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:59:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:45765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbZLIJ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:57:41 -0500
Date: Wed, 9 Dec 2009 09:55:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove unnecessary RCU exclusion
Message-ID: <tip-fb58bac5c75bfff8bbf7d02071a10a62f32fe28b@git.kernel.org>
Git-Commit-ID: fb58bac5c75bfff8bbf7d02071a10a62f32fe28b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb58bac5c75bfff8bbf7d02071a10a62f32fe28b
Gitweb:     http://git.kernel.org/tip/fb58bac5c75bfff8bbf7d02071a10a62f32fe28b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Dec 2009 12:21:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:08 +0100

sched: Remove unnecessary RCU exclusion

As Nick pointed out, and realized by myself when doing:
   sched: Fix balance vs hotplug race
the patch:
   sched: for_each_domain() vs RCU

is wrong, sched_domains are freed after synchronize_sched(), which
means disabling preemption is enough.

Reported-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e9f5dae..c163a28 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1403,7 +1403,6 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		new_cpu = prev_cpu;
 	}
 
-	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		/*
 		 * If power savings logic is enabled for a domain, see if we
@@ -1484,10 +1483,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			update_shares(tmp);
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync)) {
-		new_cpu = cpu;
-		goto out;
-	}
+	if (affine_sd && wake_affine(affine_sd, p, sync))
+		return cpu;
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
@@ -1528,8 +1525,6 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		/* while loop will break here if sd == NULL */
 	}
 
-out:
-	rcu_read_unlock();
 	return new_cpu;
 }
 #endif /* CONFIG_SMP */
