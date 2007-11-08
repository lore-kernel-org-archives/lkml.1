Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXKHVc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXKHVc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761283AbXKHVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:32:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761253AbXKHVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:32:37 -0500
Message-Id: <200711082131.lA8LVhnk015137@imap1.linux-foundation.org>
Subject: [patch 2/2] clone: prepare to recycle CLONE_DETACHED and CLONE_STOPPED
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, drepper@redhat.com, mingo@elte.hu,
       roland@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 08 Nov 2007 13:31:43 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Ulrich says that we never used these clone flags and that nothing should be
using them.

As we're down to only a single bit left in clone's flags argument, let's add a
warning to check that no userspace is actually using these.  Hopefully we will
be able to recycle them.

Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN kernel/fork.c~clone-prepare-to-recycle-clone_detached-and-clone_stopped kernel/fork.c
--- a/kernel/fork.c~clone-prepare-to-recycle-clone_detached-and-clone_stopped
+++ a/kernel/fork.c
@@ -1420,10 +1420,18 @@ long do_fork(unsigned long clone_flags,
 	int trace = 0;
 	long nr;
 
-	if (unlikely(current->ptrace)) {
-		trace = fork_traceflag (clone_flags);
-		if (trace)
-			clone_flags |= CLONE_PTRACE;
+	/*
+	 * We hope to recycle these flags after 2.6.26
+	 */
+	if (unlikely(clone_flags & (CLONE_DETACHED|CLONE_STOPPED))) {
+		if (printk_ratelimit()) {
+			char comm[TASK_COMM_LEN];
+
+			printk(KERN_INFO "fork(): process `%s' used deprecated "
+					"clone flags 0x%lx\n",
+				get_task_comm(comm, current),
+				clone_flags & (CLONE_DETACHED|CLONE_STOPPED));
+		}
 	}
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
_
