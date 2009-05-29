Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZE2ITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZE2ITy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbZE2ITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:19:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60443 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZE2ITp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:19:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=RZ+8+FV5QVpn3RlvCow95q47qFK5Ea5gmTTFrg3QPMjee0lP6BlxUXepPWc78nhHY/
         HZyH0/R5UmsHQbW/A/ps7hUuNb1P/wId0uM8x3GQYBsU47Xmd8VP3Wiyew4pxu8KXmVc
         LjFBNp1WYgk5LPr+Hjix8z5CQVLArkti4Dcqo=
From: Gerard Lledo <gerard.lledo@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Gerard Lledo <gerard.lledo@gmail.com>
Subject: [PATCH] [JFFS2] Move jffs2_gcd_mtd threads to the new kthread API
Date: Fri, 29 May 2009 11:19:41 +0300
Message-Id: <1243585181-2997-1-git-send-email-gerard.lledo@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_thread() is being depracated.  This patch moves the jffs2 garbage
collecting thread to the new kthread API with the minimal impact.

Signed-off-by: Gerard Lledo <gerard.lledo@gmail.com>
---
 fs/jffs2/background.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index e958010..077fa65 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -15,6 +15,7 @@
 #include <linux/completion.h>
 #include <linux/sched.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 #include "nodelist.h"
 
 
@@ -31,7 +32,7 @@ void jffs2_garbage_collect_trigger(struct jffs2_sb_info *c)
 /* This must only ever be called when no GC thread is currently running */
 int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 {
-	pid_t pid;
+	struct task_struct *tsk;
 	int ret = 0;
 
 	BUG_ON(c->gc_task);
@@ -39,15 +40,16 @@ int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 	init_completion(&c->gc_thread_start);
 	init_completion(&c->gc_thread_exit);
 
-	pid = kernel_thread(jffs2_garbage_collect_thread, c, CLONE_FS|CLONE_FILES);
-	if (pid < 0) {
-		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %d\n", -pid);
+	tsk = kthread_create(jffs2_garbage_collect_thread, c, "jffs2_gcd_mtd%d", c->mtd->index);
+	if (IS_ERR(tsk)) {
+		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %ld\n", -PTR_ERR(tsk));
 		complete(&c->gc_thread_exit);
-		ret = pid;
+		ret = PTR_ERR(tsk);
 	} else {
-		/* Wait for it... */
-		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", pid));
+		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", tsk->pid));
+		wake_up_process(tsk);
 		wait_for_completion(&c->gc_thread_start);
+		ret = tsk->pid;
 	}
 
 	return ret;
@@ -71,7 +73,6 @@ static int jffs2_garbage_collect_thread(void *_c)
 {
 	struct jffs2_sb_info *c = _c;
 
-	daemonize("jffs2_gcd_mtd%d", c->mtd->index);
 	allow_signal(SIGKILL);
 	allow_signal(SIGSTOP);
 	allow_signal(SIGCONT);
@@ -107,6 +108,11 @@ static int jffs2_garbage_collect_thread(void *_c)
 		 * the GC thread get there first. */
 		schedule_timeout_interruptible(msecs_to_jiffies(50));
 
+		if (kthread_should_stop()) {
+			D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread():  kthread_stop() called.\n"));
+			goto die;
+		}
+
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
 		while (signal_pending(current) || freezing(current)) {
-- 
1.5.6.5

