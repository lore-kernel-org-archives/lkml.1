Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbZBKVQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbZBKVQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZBKVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:15:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbZBKVPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:15:02 -0500
Date: Wed, 11 Feb 2009 22:12:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] reparent/untrace: do nothing if no childs/tracees
Message-ID: <20090211211224.GA16860@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forget_original_parent() and exit_ptrace() can avoid taking the global
tasklist_lock if there are no childs/tracees. But I failed to invent
the comment to explain why/when this is safe to do, that is why the
separate patch/changelog.

The problem is, we can race with the concurrent release_task() which
can remove the last child form our ->children/ptraced list. This means
that list_empty() can return the "false" positive, it is possible that
release_task() is still in progress, it can use the caller's task_struct
somehow, and it is even possible that list_del(sibling/ptrace_entry)
has not yet completed.

But this is fine, before our task_struct will be released we will take
tasklist_lock at least once in release_task(), this will synchronize us
with the possible release_task/ptrace_unlink in flight.

However, forget_original_parent() has another problem. We can race with
another thread which has already picked us for reparenting before we set
PF_EXITING, so this patch also checks thread_group_empty().

It is possible to be more clever, we can take tasklist for reading, or
ensure that ->thread_group.prev is not PF_EXITING, but this is nasty.
Perhaps even this optimization is too ugly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/exit.c~4_TASKLIST	2009-02-11 07:20:54.000000000 +0100
+++ 6.29-rc3/kernel/exit.c	2009-02-11 21:25:35.000000000 +0100
@@ -803,6 +803,16 @@ static void forget_original_parent(struc
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_childs);
 
+	if (thread_group_empty(father)) {
+		/*
+		 * Make sure no other thread can reparent to
+		 * us after the list_empty(->children) check.
+		 */
+		smp_rmb();
+		if (list_empty(&father->children))
+			return;
+	}
+
 	write_lock_irq(&tasklist_lock);
 	reaper = find_new_reaper(father);
 
--- 6.29-rc3/kernel/ptrace.c~4_TASKLIST	2009-02-11 04:04:17.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-02-11 08:27:41.000000000 +0100
@@ -323,6 +323,9 @@ void exit_ptrace(struct task_struct *tra
 	struct task_struct *p, *n;
 	LIST_HEAD(ptrace_dead);
 
+	if (list_empty(&tracer->ptraced))
+		return;
+
 	write_lock_irq(&tasklist_lock);
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (__ptrace_detach(tracer, p))

