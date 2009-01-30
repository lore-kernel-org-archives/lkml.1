Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZA3Mh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZA3Mh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZA3MhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:37:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37667 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbZA3MhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:37:03 -0500
Date: Fri, 30 Jan 2009 13:33:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] kthreads: simplify the startup synchronization
Message-ID: <20090130123354.GA26213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use two completions two create the kernel thread, this is a bit ugly.
kthread() wakes up create_kthread() via ->started, then create_kthread()
wakes up the caller kthread_create() via ->done. But kthread() does not
need to wait for kthread(), it can just return. Instead kthread() itself
can wake up the caller of kthread_create().

Kill kthread_create_info->started, ->done is enough. This improves the
scalability a bit and sijmplifies the code.

The only problem if kernel_thread() fails, in that case create_kthread()
must do complete(&create->done).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/kthread.c~2_COMPLETION	2009-01-30 09:46:29.000000000 +0100
+++ 6.29-rc3/kernel/kthread.c	2009-01-30 10:45:18.000000000 +0100
@@ -29,7 +29,6 @@ struct kthread_create_info
 	/* Information passed to kthread() from kthreadd. */
 	int (*threadfn)(void *data);
 	void *data;
-	struct completion started;
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
@@ -77,7 +76,7 @@ static int kthread(void *_create)
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
 	create->result = current;
-	complete(&create->started);
+	complete(&create->done);
 	schedule();
 
 	if (!kthread_should_stop())
@@ -99,10 +98,8 @@ static void create_kthread(struct kthrea
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
-	} else {
-		wait_for_completion(&create->started);
+		complete(&create->done);
 	}
-	complete(&create->done);
 }
 
 /**
@@ -133,7 +130,6 @@ struct task_struct *kthread_create(int (
 
 	create.threadfn = threadfn;
 	create.data = data;
-	init_completion(&create.started);
 	init_completion(&create.done);
 
 	spin_lock(&kthread_create_lock);

