Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXDKSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXDKSvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbXDKSvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:51:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39561 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbXDKSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:51:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] Change reparent_to_init to reparent_to_kthreadd
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
	<20070411000316.52f2551e.akpm@linux-foundation.org>
	<m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com>
Date: Wed, 11 Apr 2007 12:49:33 -0600
In-Reply-To: <m1hcrmsr4g.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Wed, 11 Apr 2007 12:27:59 -0600")
Message-ID: <m18xcysq4i.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a kernel thread calls daemonize, instead of reparenting the thread to
init reparent the thread to kthreadd next to the threads created by
kthread_create.

This is really just a stop gap until daemonize goes away, but it does
ensure no kernel threads are under init and they are all in one place
that is easy to find.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/exit.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b55ed4c..1a7c878 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -42,6 +42,7 @@
 #include <linux/audit.h> /* for audit_free() */
 #include <linux/resource.h>
 #include <linux/blkdev.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -255,26 +256,25 @@ static int has_stopped_jobs(struct pid *pgrp)
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
+ * reparent_to_kthreadd - Reparent the calling kernel thread to kthreadd
  *
  * If a kernel thread is launched as a result of a system call, or if
- * it ever exits, it should generally reparent itself to init so that
- * it is correctly cleaned up on exit.
+ * it ever exits, it should generally reparent itself to kthreadd so it
+ * isn't in the way of other processes and is correctly cleaned up on exit.
  *
  * The various task state such as scheduling policy and priority may have
  * been inherited from a user process, so we reset them to sane values here.
  *
- * NOTE that reparent_to_init() gives the caller full capabilities.
+ * NOTE that reparent_to_kthreadd() gives the caller full capabilities.
  */
-static void reparent_to_init(void)
+static void reparent_to_kthreadd(void)
 {
 	write_lock_irq(&tasklist_lock);
 
 	ptrace_unlink(current);
 	/* Reparent to init */
 	remove_parent(current);
-	current->parent = child_reaper(current);
-	current->real_parent = child_reaper(current);
+	current->real_parent = current->parent = kthreadd_task;
 	add_parent(current);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
@@ -401,7 +401,7 @@ void daemonize(const char *name, ...)
 	current->files = init_task.files;
 	atomic_inc(&current->files->count);
 
-	reparent_to_init();
+	reparent_to_kthreadd();
 }
 
 EXPORT_SYMBOL(daemonize);
-- 
1.5.0.g53756

