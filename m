Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbZHDK1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbZHDK1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZHDK1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:27:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40914 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbZHDK1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:27:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] oom: oom_kill doesn't kill vfork parent(or child)
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
Message-Id: <20090804192638.6A46.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  4 Aug 2009 19:27:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] oom: oom_kill doesn't kill vfork parent(or child).

Current oom_kill doesn't only kill victim process, but also kill
mm shread task. it mean vfork parent will be killed.

but, That's bogus. another process have another oom_adj. we shouldn't
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


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>,
---
 mm/oom_kill.c |   12 ------------
 1 file changed, 12 deletions(-)

Index: b/mm/oom_kill.c
===================================================================
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -399,23 +399,11 @@ static void __oom_kill_task(struct task_
 
 static int oom_kill_task(struct task_struct *p)
 {
-	struct task_struct *g, *q;
-
 	if (get_oom_adj(p) == OOM_DISABLE)
 		return 1;
 
 	__oom_kill_task(p, 1);
 
-	/*
-	 * kill all processes that share the ->mm (i.e. all threads),
-	 * but are in a different thread group. Don't let them have access
-	 * to memory reserves though, otherwise we might deplete all memory.
-	 */
-	do_each_thread(g, q) {
-		if (q->mm == p->mm && !same_thread_group(q, p))
-			force_sig(SIGKILL, q);
-	} while_each_thread(g, q);
-
 	return 0;
 }
 


