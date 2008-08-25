Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYHYUSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYHYUSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYHYURr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:17:47 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36234
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753531AbYHYURq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:17:46 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/5] sched: pull only one task during NEWIDLE balancing to
	limit critical section
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Mon, 25 Aug 2008 16:15:29 -0400
Message-ID: <20080825201529.23217.8708.stgit@dev.haskins.net>
In-Reply-To: <20080825200852.23217.13842.stgit@dev.haskins.net>
References: <20080825200852.23217.13842.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git-id c4acb2c0669c5c5c9b28e9d02a34b5c67edf7092 attempted to limit
newidle critical section length by stopping after at least one task
was moved.  Further investigation has shown that there are other
paths nested further inside the algorithm which still remain that allow
long latencies to occur with newidle balancing.  This patch applies
the same technique inside balance_tasks() to limit the duration of
this optional balancing operation.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Nick Piggin <npiggin@suse.de>
---

 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6a43c89..6e0bde6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2963,9 +2963,11 @@ next:
 	rem_load_move -= p->se.load.weight;
 
 	/*
-	 * We only want to steal up to the prescribed amount of weighted load.
+	 * We only want to steal up to the prescribed amount of weighted load
+	 * and we don't want to take more than one task if we are NEWLY idle
+	 * since this can cause unbounded latencies
 	 */
-	if (rem_load_move > 0) {
+	if (idle != CPU_NEWLY_IDLE && rem_load_move > 0) {
 		if (p->prio < *this_best_prio)
 			*this_best_prio = p->prio;
 		p = iterator->next(iterator->arg);

