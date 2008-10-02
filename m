Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbYJBDAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbYJBDAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 23:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYJBDAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 23:00:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:46294 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYJBDAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 23:00:40 -0400
Date: Wed, 1 Oct 2008 20:00:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081001200034.65eb67d6@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 1 Oct 2008 19:58:18 -0700
Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority

With latencytop, I noticed that the (in memory) atime updates during a
kernel build had latencies of 6 seconds or longer; this is obviously not so
nice behavior. Other EXT3 journal related operations had similar or even
longer latencies.

Digging into this a bit more, it appears to be an interaction between EXT3
and CFQ in that CFQ tries to be fair to everyone, including kjournald.
However, in reality, kjournald is "special" in that it does a lot of journal
work on behalf of other processes and effectively this leads to a twisted 
kind of "mass priority inversion" type of behavior.

The good news is that CFQ already has the infrastructure to make certain
processes special... JBD just wasn't using that quite yet.

The patch below makes kjournald of the IOPRIO_CLASS_RT priority to break
this priority inversion behavior. With this patch, the latencies for atime
updates (and similar operation) go down by a factor of 3x to 4x !

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/ioprio.c            |    3 ++-
 fs/jbd/journal.c       |   12 ++++++++++++
 include/linux/ioprio.h |    2 ++
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/ioprio.c b/fs/ioprio.c
index da3cc46..3bd95dc 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -27,7 +27,7 @@
 #include <linux/security.h>
 #include <linux/pid_namespace.h>
 
-static int set_task_ioprio(struct task_struct *task, int ioprio)
+int set_task_ioprio(struct task_struct *task, int ioprio)
 {
 	int err;
 	struct io_context *ioc;
@@ -64,6 +64,7 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	task_unlock(task);
 	return err;
 }
+EXPORT_SYMBOL_GPL(set_task_ioprio);
 
 asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 {
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index aa7143a..2ed3d8f 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -36,6 +36,7 @@
 #include <linux/poison.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
+#include <linux/ioprio.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -131,6 +132,17 @@ static int kjournald(void *arg)
 			journal->j_commit_interval / HZ);
 
 	/*
+	 * kjournald is the process on which most other processes depend on
+	 * for doing the filesystem portion of their IO. As such, there exists
+	 * the equivalent of a priority inversion situation, where kjournald
+	 * would get less priority as it should.
+	 *
+	 * For this reason we set to "medium real time priority", which is higher
+	 * than regular tasks, but not infinitely powerful.
+	 */
+	set_task_ioprio(current, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 4));
+
+	/*
 	 * And now, wait forever for commit wakeup events.
 	 */
 	spin_lock(&journal->j_state_lock);
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index f98a656..76dad48 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -86,4 +86,6 @@ static inline int task_nice_ioclass(struct task_struct *task)
  */
 extern int ioprio_best(unsigned short aprio, unsigned short bprio);
 
+extern int set_task_ioprio(struct task_struct *task, int ioprio);
+
 #endif
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
