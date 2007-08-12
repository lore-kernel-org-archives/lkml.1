Return-Path: <linux-kernel-owner+w=401wt.eu-S937167AbXHLRj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937167AbXHLRj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760563AbXHLRjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:39:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:43953 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129AbXHLRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=NckzyX/3I5RESGIfq4Xt/Jgs62homKP9Q/v2thT/h6fQMT2FR3DNw5x66MQCsJRk8SdgN5EuOVpv23PujgvGA8/kTLe6Eyu/7BWlRRyBsQYBbhYfEc+mgsUllQD+8ICNkN/RIcQnYAZ2azfCUXvfJKM4HgfPvis0pFhlfDD5Zzo=
Date: Sun, 12 Aug 2007 21:39:07 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, suparna@in.ibm.com, daniel@osdl.org,
       mason@suse.com
Subject: [PATCH] Remove struct task_struct::io_wait
Message-ID: <20070812173907.GD5871@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hell knows what happened in commit 63b05203af57e7de4f3bb63b8b81d43bc196d32b
during 2.6.9 development. Commit introduced io_wait field which remained
write-only than and still remains write-only.

Also garbage collect macros which "use" io_wait.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/aio.c              |   16 ++--------------
 include/linux/aio.h   |   12 ------------
 include/linux/sched.h |    7 -------
 kernel/fork.c         |    1 -
 4 files changed, 2 insertions(+), 34 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -710,18 +710,9 @@ static ssize_t aio_run_iocb(struct kiocb *iocb)
 
 	/*
 	 * Now we are all set to call the retry method in async
-	 * context. By setting this thread's io_wait context
-	 * to point to the wait queue entry inside the currently
-	 * running iocb for the duration of the retry, we ensure
-	 * that async notification wakeups are queued by the
-	 * operation instead of blocking waits, and when notified,
-	 * cause the iocb to be kicked for continuation (through
-	 * the aio_wake_function callback).
+	 * context.
 	 */
-	BUG_ON(current->io_wait != NULL);
-	current->io_wait = &iocb->ki_wait;
 	ret = retry(iocb);
-	current->io_wait = NULL;
 
 	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
 		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
@@ -1508,10 +1499,7 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
  * 	Simply triggers a retry of the operation via kick_iocb.
  *
  * 	This callback is specified in the wait queue entry in
- *	a kiocb	(current->io_wait points to this wait queue
- *	entry when an aio operation executes; it is used
- * 	instead of a synchronous wait when an i/o blocking
- *	condition is encountered during aio).
+ *	a kiocb.
  *
  * Note:
  * This routine is executed with the wait queue lock held.
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -232,18 +232,6 @@ int FASTCALL(io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		__put_ioctx(kioctx);					\
 } while (0)
 
-#define in_aio() (unlikely(!is_sync_wait(current->io_wait)))
-
-/* may be used for debugging */
-#define warn_if_async()							\
-do {									\
-	if (in_aio()) {							\
-		printk(KERN_ERR "%s(%s:%d) called in async context!\n",	\
-			__FUNCTION__, __FILE__, __LINE__);		\
-		dump_stack();						\
-	}								\
-} while (0)
-
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
 #include <linux/aio_abi.h>
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1147,13 +1147,6 @@ struct task_struct {
 
 	unsigned long ptrace_message;
 	siginfo_t *last_siginfo; /* For ptrace use.  */
-/*
- * current io wait handle: wait queue entry to use for io waits
- * If this thread is processing aio, this points at the waitqueue
- * inside the currently handled kiocb. It may be NULL (i.e. default
- * to a stack based synchronous wait) if its doing sync IO.
- */
-	wait_queue_t *io_wait;
 #ifdef CONFIG_TASK_XACCT
 /* i/o counters(bytes read/written, #syscalls */
 	u64 rchar, wchar, syscr, syscw;
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1068,7 +1068,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	monotonic_to_bootbased(&p->real_start_time);
 	p->security = NULL;
 	p->io_context = NULL;
-	p->io_wait = NULL;
 	p->audit_context = NULL;
 	cpuset_fork(p);
 #ifdef CONFIG_NUMA

