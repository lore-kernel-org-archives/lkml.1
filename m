Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZEDQgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZEDQgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbZEDQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:35:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbZEDQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:35:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wlCO2XyTFgOe8ONm1j/HV+QNuGjW8Wz5itQNWnbi/qy0S4mdylbzUf9jGEY6SIDL8
	wzqVKSQrz8etxXh71n5zg==
Date: Mon, 4 May 2009 09:35:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 5/5] oom: prevent possible OOM_DISABLE livelock
In-Reply-To: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905031307200.18426@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently possible to livelock the oom killer if a task is chosen
for oom kill and another thread sharing the same memory has an oom_adj
value of OOM_DISABLE.  This occurs because oom_kill_task() repeatedly
returns 1 and refuses to kill the chosen task while select_bad_process()
will repeatedly chooses the same task during the next retry.

This moves the check for OOM_DISABLE to the badness heuristic while
holding task_lock().  Badness scores of 0 are now explicitly prohibited
from being oom killed and since the oom_adj value is a characteristic of
an mm and not a task, it is no longer necessary to check the oom_adj
value for threads sharing the same memory (except when simply issuing
SIGKILLs for threads in other thread groups).

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   40 ++++++++++------------------------------
 1 files changed, 10 insertions(+), 30 deletions(-)

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
@@ -253,13 +257,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 			*ppoints = ULONG_MAX;
 		}
 
-		task_lock(p);
-		if (p->mm && p->mm->oom_adj == OOM_DISABLE)
-			continue;
-		task_unlock(p);
-
 		points = badness(p, uptime.tv_sec);
-		if (points > *ppoints || !chosen) {
+		if (points > *ppoints) {
 			chosen = p;
 			*ppoints = points;
 		}
@@ -352,32 +351,13 @@ static int oom_kill_task(struct task_struct *p)
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
