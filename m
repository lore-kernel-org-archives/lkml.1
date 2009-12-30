Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZL3PIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZL3PIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 10:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZL3PIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 10:08:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZL3PIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 10:08:51 -0500
Subject: Re: [PATCH 1/1] perf_event: add check for group_list if the parent
 isn't counted
From: Peter Zijlstra <peterz@infradead.org>
To: Wang Liming <liming.wang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B3B657B.2070009@windriver.com>
References: <1262172487-13694-1-git-send-email-liming.wang@windriver.com>
	 <1262176125.7135.207.camel@laptop>  <4B3B657B.2070009@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 16:08:04 +0100
Message-ID: <1262185684.7135.222.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 22:36 +0800, Wang Liming wrote:
> > Best I can make of it is that there is a race where the parent gets his
> > context instantiated and we manage to get the mutex before the other
> > thread manages to add the first event.
> > 
> > Then we observe parent_event_ctx but have an empty list.
> > 
> > Is that it?
> I didn't find this case.
> In my case, if I perf record a existing process with "--pid" and finish record,
> and if later the recorded process forks a process, the condition will occur.

Ah, right, that will lead to the same state, since closing the last
counter will not remove the context.

Does the below also fix your issue?

---
Subject: perf: Fix NULL deref in inheritance code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Dec 30 16:00:35 CET 2009

Liming found a NULL deref when a task has a perf context but no counters 
when it forks.

This can occur in two cases, a race during construction where the fork hits
after installing the context but before the first counter gets inserted, or
more reproducably, a fork after the last counter is closed (which leaves the
context around).

CC: stable@kernel.org
Reported-by: Wang Liming <liming.wang@windriver.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5149,7 +5149,7 @@ int perf_event_init_task(struct task_str
 					    GFP_KERNEL);
 			if (!child_ctx) {
 				ret = -ENOMEM;
-				goto exit;
+				break;
 			}
 
 			__perf_event_init_context(child_ctx, child);
@@ -5165,7 +5165,7 @@ int perf_event_init_task(struct task_str
 		}
 	}
 
-	if (inherited_all) {
+	if (child_ctx && inherited_all) {
 		/*
 		 * Mark the child context as a clone of the parent
 		 * context, or of whatever the parent is a clone of.
@@ -5185,7 +5185,6 @@ int perf_event_init_task(struct task_str
 		get_ctx(child_ctx->parent_ctx);
 	}
 
-exit:
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);


