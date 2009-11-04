Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZKDTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZKDTeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbZKDTeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:34:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:60242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbZKDTeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:34:22 -0500
Date: Wed, 4 Nov 2009 19:33:34 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, efault@gmx.de, arjan@infradead.org,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1256654138.17752.7.camel@marge.simson.net>
References: <1256654138.17752.7.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Check for an idle shared cache in select_task_rq_fair()
Message-ID: <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
Git-Commit-ID: a1f84a3ab8e002159498814eaa7e48c33752b04b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1f84a3ab8e002159498814eaa7e48c33752b04b
Gitweb:     http://git.kernel.org/tip/a1f84a3ab8e002159498814eaa7e48c33752b04b
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 27 Oct 2009 15:35:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 18:46:22 +0100

sched: Check for an idle shared cache in select_task_rq_fair()

When waking affine, check for an idle shared cache, and if
found, wake to that CPU/sibling instead of the waker's CPU.

This improves pgsql+oltp ramp up by roughly 8%. Possibly more
for other loads, depending on overlap. The trade-off is a
roughly 1% peak downturn if tasks are truly synchronous.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@kernel.org>
LKML-Reference: <1256654138.17752.7.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4e777b4..da87385 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1372,11 +1372,36 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
+			int candidate = -1, i;
 
-			affine_sd = tmp;
-			want_affine = 0;
+			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
+				candidate = cpu;
+
+			/*
+			 * Check for an idle shared cache.
+			 */
+			if (tmp->flags & SD_PREFER_SIBLING) {
+				if (candidate == cpu) {
+					if (!cpu_rq(prev_cpu)->cfs.nr_running)
+						candidate = prev_cpu;
+				}
+
+				if (candidate == -1 || candidate == cpu) {
+					for_each_cpu(i, sched_domain_span(tmp)) {
+						if (!cpu_rq(i)->cfs.nr_running) {
+							candidate = i;
+							break;
+						}
+					}
+				}
+			}
+
+			if (candidate >= 0) {
+				affine_sd = tmp;
+				want_affine = 0;
+				cpu = candidate;
+			}
 		}
 
 		if (!want_sd && !want_affine)
