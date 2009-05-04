Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZEDIiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZEDIiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZEDIiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:38:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52650 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZEDIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:38:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=O5x7irHXwNhEdWK+VZQ4Tx93dBXoolpV8sfBwUEv21IpOYOJ8MLi6tLU3bOYr0voa
	r5Deb4ghpqJZPON9swuSQ==
Date: Mon, 4 May 2009 01:38:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: [patch] sched: emit thread info flags with stack trace
Message-ID: <alpine.DEB.2.00.0905040136390.15831@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a thread is oom killed and fails to exit, it's helpful to know which
threads have access to memory reserves if the machine livelocks.  This is
done by testing for the TIF_MEMDIE thread info flag and should be
displayed alongside stack traces to identify tasks that have access to
such reserves but are still stuck allocating pages, for instance.

It would probably be helpful in other cases as well, so all thread info
flags are emitted when showing a task.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/sched.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6490,8 +6490,9 @@ void sched_show_task(struct task_struct *p)
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent));
+	printk(KERN_CONT "%5lu %5d %6d 0x%08x\n", free,
+		task_pid_nr(p), task_pid_nr(p->real_parent),
+		task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
 }
