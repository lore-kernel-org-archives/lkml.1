Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZFFWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZFFWNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZFFWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:13:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZFFWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:13:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=TNJtbysYF+hsNw3BhgOqPLUHweX2nu9hia/+Aa1PdUa0JS7ztQKzdulZFLLPPsziG
	5mREzADralGHalOHnf8ww==
Date: Sat, 6 Jun 2009 15:12:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: [patch -mmotm] oom: only oom kill exiting tasks with attached
 memory
Message-ID: <alpine.DEB.2.00.0906061512100.16635@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task is chosen for oom kill and is found to be PF_EXITING,
__oom_kill_task() is called to elevate the task's timeslice and give it
access to memory reserves so that it may quickly exit.

This privilege is unnecessary, however, if the task has already detached
its mm.  Although its possible for the mm to become detached later since
task_lock() is not held, __oom_kill_task() will simply be a no-op in such
circumstances.

Subsequently, it is no longer necessary to warn about killing mm-less
tasks since it is a no-op.

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -325,11 +325,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 		return;
 	}
 
-	if (!p->mm) {
-		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill an mm-less task!\n");
+	if (!p->mm)
 		return;
-	}
 
 	if (verbose)
 		printk(KERN_ERR "Killed process %d (%s)\n",
@@ -397,8 +394,9 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
+	 * if its mm is still attached.
 	 */
-	if (p->flags & PF_EXITING) {
+	if (p->mm && (p->flags & PF_EXITING)) {
 		__oom_kill_task(p, 0);
 		return 0;
 	}
