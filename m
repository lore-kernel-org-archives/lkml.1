Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZHZJga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZHZJga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbZHZJg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:36:29 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36807 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbZHZJg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:36:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [mmotm][PATCH 3/4] oom: oom_kill doesn't kill vfork parent(or child)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090826182634.3968.A69D9226@jp.fujitsu.com>
References: <20090826182634.3968.A69D9226@jp.fujitsu.com>
Message-Id: <20090826183529.3971.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 26 Aug 2009 18:36:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current oom_kill doesn't only kill the victim process, but also kill
all thas shread the same mm. it mean vfork parent will be killed.

This is definitely incorrect. another process have another oom_adj. we shouldn't
ignore their oom_adj (it might have OOM_DISABLE).

following caller hit the minefield.

---------------------------------------
        switch (constraint) {
        case CONSTRAINT_MEMORY_POLICY:
                oom_kill_process(current, gfp_mask, order, 0, NULL,
                                "No available memory (MPOL_BIND)");
                break;

Note: force_sig(SIGKILL) send SIGKILL to all thread in the process.
We don't need to care multi thread in here.

Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 26725bc..f8fa81e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -373,11 +373,6 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 
 static int oom_kill_task(struct task_struct *p)
 {
-	struct mm_struct *mm;
-	struct task_struct *g, *q;
-
-	mm = p->mm;
-
 	/* WARNING: mm may not be dereferenced since we did not obtain its
 	 * value from get_task_mm(p).  This is OK since all we need to do is
 	 * compare mm to q->mm below.
@@ -386,21 +381,11 @@ static int oom_kill_task(struct task_struct *p)
 	 * change to NULL at any time since we do not hold task_lock(p).
 	 * However, this is of no concern to us.
 	 */
-	if (!mm || p->signal->oom_adj == OOM_DISABLE)
+	if (!p->mm || p->signal->oom_adj == OOM_DISABLE)
 		return 1;
 
 	__oom_kill_task(p, 1);
 
-	/*
-	 * kill all processes that share the ->mm (i.e. all threads),
-	 * but are in a different thread group. Don't let them have access
-	 * to memory reserves though, otherwise we might deplete all memory.
-	 */
-	do_each_thread(g, q) {
-		if (q->mm == mm && !same_thread_group(q, p))
-			force_sig(SIGKILL, q);
-	} while_each_thread(g, q);
-
 	return 0;
 }
 
-- 
1.6.2.5



