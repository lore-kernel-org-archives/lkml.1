Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbXDXEgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbXDXEgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161577AbXDXEgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:36:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbXDXEgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:36:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=s4tzd3S+G3Z0Z4R6/1iHcyTSlRzIFXxFwqCwz59L8RPxRxud1X37VwPcruLQqn7Jn
	EcHsSZtendqlxQllrNPcw==
Date: Mon, 23 Apr 2007 21:36:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@engr.sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [patch] oom: kill all threads that share mm with killed task
Message-ID: <Pine.LNX.4.64.0704232134430.11399@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

oom_kill_task() calls __oom_kill_task() to OOM kill a selected task.
When finding other threads that share an mm with that task, we need to
kill those individual threads and not the same one.

Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -333,7 +333,7 @@ static int oom_kill_task(struct task_struct *p)
 	 */
 	do_each_thread(g, q) {
 		if (q->mm == mm && q->tgid != p->tgid)
-			force_sig(SIGKILL, p);
+			force_sig(SIGKILL, q);
 	} while_each_thread(g, q);
 
 	return 0;
