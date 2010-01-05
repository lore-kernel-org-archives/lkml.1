Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681Ab0AEA5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0AEA5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464Ab0AEA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:57:06 -0500
Received: from kroah.org ([198.145.64.141]:34084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab0AEAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/97] sched: Fix task_hot() test order
Date: Mon,  4 Jan 2010 16:32:18 -0800
Message-Id: <1262651630-7354-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit e6c8fba7771563b2f3dfb96a78f36ec17e15bdf0 upstream.

Make sure not to access sched_fair fields before verifying it is
indeed a sched_fair task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.577998058@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d079a9f..2797859 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2036,6 +2036,9 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 {
 	s64 delta;
 
+	if (p->sched_class != &fair_sched_class)
+		return 0;
+
 	/*
 	 * Buddy candidates are cache hot:
 	 */
@@ -2044,9 +2047,6 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
 
-	if (p->sched_class != &fair_sched_class)
-		return 0;
-
 	if (sysctl_sched_migration_cost == -1)
 		return 1;
 	if (sysctl_sched_migration_cost == 0)
-- 
1.6.6

