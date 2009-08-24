Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZHXKwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZHXKwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 06:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZHXKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 06:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZHXKwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 06:52:20 -0400
Date: Mon, 24 Aug 2009 12:45:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Robert Peterson <rpeterso@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -stable] kthreads: fix kthread_create() vs kthread_stop()
	race
Message-ID: <20090824104529.GA6899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug should be "accidently" fixed by recent changes in 2.6.31,
all kernels <= 2.6.30 need the fix. The problem was never noticed before,
it was found because it causes mysterious failures with GFS mount/umount.

Credits to Robert Peterson. He blaimed kthread.c from the very beginning.
But, despite my promise, I forgot to inspect the old implementation until
he did a lot of testing and reminded me. This led to huge delay in fixing
this bug.

kthread_stop() does put_task_struct(k) before it clears kthread_stop_info.k.
This means another kthread_create() can re-use this task_struct, but the
new kthread can still see kthread_should_stop() == T and exit even without
calling threadfn().

Reported-by: Robert Peterson <rpeterso@redhat.com>
Tested-by: Robert Peterson <rpeterso@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -216,12 +216,12 @@ int kthread_stop(struct task_struct *k)
 	/* Now set kthread_should_stop() to true, and wake it up. */
 	kthread_stop_info.k = k;
 	wake_up_process(k);
-	put_task_struct(k);
 
 	/* Once it dies, reset stop ptr, gather result and we're done. */
 	wait_for_completion(&kthread_stop_info.done);
 	kthread_stop_info.k = NULL;
 	ret = kthread_stop_info.err;
+	put_task_struct(k);
 	mutex_unlock(&kthread_stop_lock);
 
 	trace_sched_kthread_stop_ret(ret);

