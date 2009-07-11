Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZGKIWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZGKIWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZGKIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:22:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZGKIWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:22:09 -0400
Date: Sat, 11 Jul 2009 08:21:35 GMT
From: tip-bot for Paul Turner <pjt@google.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       pjt@google.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pjt@google.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.DEB.1.00.0907101649570.29914@kitami.corp.google.com>
References: <alpine.DEB.1.00.0907101649570.29914@kitami.corp.google.com>
Subject: [tip:sched/urgent] sched: Fix bug in SCHED_IDLE interaction with group scheduling
Message-ID: <tip-d07387b490b1c43bfcb9f3900faf96f2dafb2630@git.kernel.org>
Git-Commit-ID: d07387b490b1c43bfcb9f3900faf96f2dafb2630
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Jul 2009 08:21:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d07387b490b1c43bfcb9f3900faf96f2dafb2630
Gitweb:     http://git.kernel.org/tip/d07387b490b1c43bfcb9f3900faf96f2dafb2630
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 10 Jul 2009 17:05:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 11 Jul 2009 10:00:09 +0200

sched: Fix bug in SCHED_IDLE interaction with group scheduling

One of the isolation modifications for SCHED_IDLE is the
unitization of sleeper credit.  However the check for this
assumes that the sched_entity we're placing always belongs to a
task.

This is potentially not true with group scheduling and leaves
us rummaging randomly when we try to pull the policy.

Signed-off-by: Paul Turner <pjt@google.com>
Cc: peterz@infradead.org
LKML-Reference: <alpine.DEB.1.00.0907101649570.29914@kitami.corp.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ba7fd6e..7c248dc 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -687,7 +687,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 			 * all of which have the same weight.
 			 */
 			if (sched_feat(NORMALIZED_SLEEPER) &&
-					task_of(se)->policy != SCHED_IDLE)
+					(!entity_is_task(se) ||
+					 task_of(se)->policy != SCHED_IDLE))
 				thresh = calc_delta_fair(thresh, se);
 
 			vruntime -= thresh;
