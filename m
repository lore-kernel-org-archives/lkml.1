Return-Path: <linux-kernel-owner+w=401wt.eu-S1763022AbZD3WjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763022AbZD3WjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZD3WjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:39:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5466 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbZD3WjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:39:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=khrGTDSGtOYfXGNfguckrdkyBR7CxKZedTTwkO58tPz+iW2QV3enwS2AQD4F00ljm
	xjUCUK4YhfbI6XvSC8sGw==
Date: Thu, 30 Apr 2009 15:38:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [patch] oom: prevent livelock when oom_kill_allocating_task is set
Message-ID: <alpine.DEB.2.00.0904301538270.12627@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /proc/sys/vm/oom_kill_allocating_task is set for large systems that
want to avoid the lengthy tasklist scan, it's possible to livelock if
current is ineligible for oom kill.  This normally happens when it is set
to OOM_DISABLE, but is also possible if any threads are sharing the same
->mm with a different tgid.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |   44 +++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -514,34 +514,32 @@ void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
  */
 static void __out_of_memory(gfp_t gfp_mask, int order)
 {
-	if (sysctl_oom_kill_allocating_task) {
-		oom_kill_process(current, gfp_mask, order, 0, NULL,
-				"Out of memory (oom_kill_allocating_task)");
-
-	} else {
-		unsigned long points;
-		struct task_struct *p;
-
-retry:
-		/*
-		 * Rambo mode: Shoot down a process and hope it solves whatever
-		 * issues we may have.
-		 */
-		p = select_bad_process(&points, NULL);
+	struct task_struct *p;
+	unsigned long points;
 
-		if (PTR_ERR(p) == -1UL)
+	if (sysctl_oom_kill_allocating_task)
+		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
+				"Out of memory (oom_kill_allocating_task)"))
 			return;
+retry:
+	/*
+	 * Rambo mode: Shoot down a process and hope it solves whatever
+	 * issues we may have.
+	 */
+	p = select_bad_process(&points, NULL);
 
-		/* Found nothing?!?! Either we hang forever, or we panic. */
-		if (!p) {
-			read_unlock(&tasklist_lock);
-			panic("Out of memory and no killable processes...\n");
-		}
+	if (PTR_ERR(p) == -1UL)
+		return;
 
-		if (oom_kill_process(p, gfp_mask, order, points, NULL,
-				     "Out of memory"))
-			goto retry;
+	/* Found nothing?!?! Either we hang forever, or we panic. */
+	if (!p) {
+		read_unlock(&tasklist_lock);
+		panic("Out of memory and no killable processes...\n");
 	}
+
+	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+			     "Out of memory"))
+		goto retry;
 }
 
 /*
