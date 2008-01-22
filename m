Return-Path: <linux-kernel-owner+w=401wt.eu-S1761703AbYAVJ4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703AbYAVJ4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbYAVJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:54:37 -0500
Received: from brick.kernel.dk ([87.55.233.238]:8790 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbYAVJy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:54:29 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: knikanth@novell.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/6] kernel: add CLONE_IO to specifically request sharing of IO contexts
Date: Tue, 22 Jan 2008 10:49:21 +0100
Message-Id: <1200995361-24001-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.rc2.84.gf85fd
In-Reply-To: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syslets can set this to enforce sharing of io context.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/sched.h |    1 +
 kernel/fork.c         |   14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 638250c..b6dbcd6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -27,6 +27,7 @@
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
 #define CLONE_NEWPID		0x20000000	/* New pid namespace */
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
+#define CLONE_IO		0x80000000	/* Clone io context */
 
 /*
  * Scheduling policies
diff --git a/kernel/fork.c b/kernel/fork.c
index 4cfb0f4..e7eec39 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -792,14 +792,20 @@ out:
 	return error;
 }
 
-static int copy_io(struct task_struct *tsk)
+static int copy_io(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct io_context *ioc = current->io_context;
 
 	if (!ioc)
 		return 0;
-
-	if (ioprio_valid(ioc->ioprio)) {
+	/*
+	 * Share io context with parent, if CLONE_IO is set
+	 */
+	if (clone_flags & CLONE_IO) {
+		tsk->io_context = ioc_task_link(ioc);
+		if (unlikely(!tsk->io_context))
+			return -ENOMEM;
+	} else if (ioprio_valid(ioc->ioprio)) {
 		tsk->io_context = alloc_io_context(GFP_KERNEL, -1);
 		if (unlikely(!tsk->io_context))
 			return -ENOMEM;
@@ -1166,7 +1172,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_mm;
 	if ((retval = copy_namespaces(clone_flags, p)))
 		goto bad_fork_cleanup_keys;
-	if ((retval = copy_io(p)))
+	if ((retval = copy_io(clone_flags, p)))
 		goto bad_fork_cleanup_namespaces;
 	retval = copy_thread(0, clone_flags, stack_start, stack_size, p, regs);
 	if (retval)
-- 
1.5.4.rc2.84.gf85fd

