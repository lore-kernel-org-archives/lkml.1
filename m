Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420Ab0AUNx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0AUNx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276Ab0AUNxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:53:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:46322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0AUNxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:53:52 -0500
Date: Thu, 21 Jan 2010 13:53:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add a lock break for PREEMPT=y
Message-ID: <tip-baa8c1102f0cd86e69c1497d61d2ee177e663663@git.kernel.org>
Git-Commit-ID: baa8c1102f0cd86e69c1497d61d2ee177e663663
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:53:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  baa8c1102f0cd86e69c1497d61d2ee177e663663
Gitweb:     http://git.kernel.org/tip/baa8c1102f0cd86e69c1497d61d2ee177e663663
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 18:10:09 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:13 +0100

sched: Add a lock break for PREEMPT=y

Since load-balancing can hold rq->locks for quite a long while, allow
breaking out early when there is lock contention.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 93fccba..65d0820 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2065,6 +2065,10 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 */
 		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
 			break;
+
+		if (raw_spin_is_contended(&this_rq->lock) ||
+				raw_spin_is_contended(&busiest->lock))
+			break;
 #endif
 	} while (load_moved && max_load_move > total_load_moved);
 
