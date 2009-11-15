Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZKOK35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZKOK35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZKOK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:29:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:46989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbZKOK3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:29:53 -0500
Date: Sun, 15 Nov 2009 10:29:08 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
       avi@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tj@kernel.org, tglx@linutronix.de,
       avi@redhat.com, mingo@elte.hu
In-Reply-To: <4AFD2801.7020900@kernel.org>
References: <4AFD2801.7020900@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, kvm: Fix race condition involving sched_in_preempt_notifers
Message-ID: <tip-498657a478c60be092208422fefa9c7b248729c2@git.kernel.org>
Git-Commit-ID: 498657a478c60be092208422fefa9c7b248729c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  498657a478c60be092208422fefa9c7b248729c2
Gitweb:     http://git.kernel.org/tip/498657a478c60be092208422fefa9c7b248729c2
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Fri, 13 Nov 2009 18:33:53 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 09:59:54 +0100

sched, kvm: Fix race condition involving sched_in_preempt_notifers

In finish_task_switch(), fire_sched_in_preempt_notifiers() is
called after finish_lock_switch().

However, depending on architecture, preemption can be enabled after
finish_lock_switch() which breaks the semantics of preempt
notifiers.

So move it before finish_arch_switch(). This also makes the in-
notifiers symmetric to out- notifiers in terms of locking - now
both are called under rq lock.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4AFD2801.7020900@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 701eca4..cea2bea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2758,9 +2758,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(current, cpu_of(rq));
+	fire_sched_in_preempt_notifiers(current);
 	finish_lock_switch(rq, prev);
 
-	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
