Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbZFBBbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbZFBBbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZFBBbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:31:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbZFBBbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:31:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UmuI9W7mtLKo8IvVoERr9Etmc+KJhmLwaVKIXgKgm35Gw0G5Za+o5SCBIdR4hvCjZ
	+Pkar+G8cu1VomqgAPzxA==
Date: Mon, 1 Jun 2009 18:31:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/3 -mmotm] oom: avoid unnecessary mm locking and scanning
 for OOM_DISABLE
In-Reply-To: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0906011830310.6936@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the check for OOM_DISABLE to the badness heuristic so it is
only necessary to hold task_lock() once.  If the mm is OOM_DISABLE, the
score is 0, which is also correctly exported via /proc/pid/oom_score.
This requires that tasks with badness scores of 0 are prohibited from
being oom killed, which makes sense since they would not allow for
future memory freeing anyway.
 
Since the oom_adj value is a characteristic of an mm and not a task, it
is no longer necessary to check the oom_adj value for threads sharing the
same memory (except when simply issuing SIGKILLs for threads in other
thread groups).

Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   42 ++++++++++--------------------------------
 1 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -67,6 +67,10 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 		return 0;
 	}
 	oom_adj = mm->oom_adj;
+	if (oom_adj == OOM_DISABLE) {
+		task_unlock(p);
+		return 0;
+	}
 
 	/*
 	 * The memory size of the process is the basis for the badness.
@@ -253,15 +257,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 			*ppoints = ULONG_MAX;
 		}
 
-		task_lock(p);
-		if (p->mm && p->mm->oom_adj == OOM_DISABLE) {
-			task_unlock(p);
-			continue;
-		}
-		task_unlock(p);
-
 		points = badness(p, uptime.tv_sec);
-		if (points > *ppoints || !chosen) {
+		if (points > *ppoints) {
 			chosen = p;
 			*ppoints = points;
 		}
@@ -354,32 +351,13 @@ static int oom_kill_task(struct task_struct *p)
 	struct mm_struct *mm;
 	struct task_struct *g, *q;
 
+	task_lock(p);
 	mm = p->mm;
-
-	/* WARNING: mm may not be dereferenced since we did not obtain its
-	 * value from get_task_mm(p).  This is OK since all we need to do is
-	 * compare mm to q->mm below.
-	 *
-	 * Furthermore, even if mm contains a non-NULL value, p->mm may
-	 * change to NULL at any time since we do not hold task_lock(p).
-	 * However, this is of no concern to us.
-	 */
-
-	if (mm == NULL)
+	if (!mm || mm->oom_adj == OOM_DISABLE) {
+		task_unlock(p);
 		return 1;
-
-	/*
-	 * Don't kill the process if any threads are set to OOM_DISABLE
-	 */
-	do_each_thread(g, q) {
-		task_lock(q);
-		if (q->mm == mm && q->mm && q->mm->oom_adj == OOM_DISABLE) {
-			task_unlock(q);
-			return 1;
-		}
-		task_unlock(q);
-	} while_each_thread(g, q);
-
+	}
+	task_unlock(p);
 	__oom_kill_task(p, 1);
 
 	/*
