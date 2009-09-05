Return-Path: <linux-kernel-owner+w=401wt.eu-S964906AbZIEAZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906AbZIEAZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964899AbZIEAZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:25:49 -0400
Received: from kroah.org ([198.145.64.141]:42288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934672AbZIEAVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:56 2009
Message-Id: <20090905001456.006786520@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Peterson <rpeterso@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 56/71] kthreads: fix kthread_create() vs kthread_stop() race
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kthreads-fix-kthread_create-vs-kthread_stop-race.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oleg Nesterov <oleg@redhat.com>

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
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


