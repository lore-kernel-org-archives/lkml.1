Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbZA3Mhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbZA3Mhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZA3MhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:37:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbZA3MhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:37:03 -0500
Date: Fri, 30 Jan 2009 13:33:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vitaliy Gusev <vgusev@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] kthreads: move sched-realeted initialization from
	kthreadd context
Message-ID: <20090130123350.GA26206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of kthread-dont-looking-for-a-task-in-create_kthread-2.patch)

kthreadd is the single thread which implements ths "create" request,
move sched_setscheduler/etc from create_kthread() to kthread_create()
to improve the scalability.

We should be careful with sched_setscheduler(), use _nochek helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/kthread.c~1_SCHED	2009-01-30 09:40:12.000000000 +0100
+++ 6.29-rc3/kernel/kthread.c	2009-01-30 09:46:29.000000000 +0100
@@ -100,15 +100,7 @@ static void create_kthread(struct kthrea
 	if (pid < 0) {
 		create->result = ERR_PTR(pid);
 	} else {
-		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
-		/*
-		 * root may have changed our (kthreadd's) priority or CPU mask.
-		 * The kernel thread should not inherit these properties.
-		 */
-		sched_setscheduler(create->result, SCHED_NORMAL, &param);
-		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
 	}
 	complete(&create->done);
 }
@@ -152,11 +144,20 @@ struct task_struct *kthread_create(int (
 	wait_for_completion(&create.done);
 
 	if (!IS_ERR(create.result)) {
+		struct sched_param param = { .sched_priority = 0 };
 		va_list args;
+
 		va_start(args, namefmt);
 		vsnprintf(create.result->comm, sizeof(create.result->comm),
 			  namefmt, args);
 		va_end(args);
+		/*
+		 * root may have changed our (kthreadd's) priority or CPU mask.
+		 * The kernel thread should not inherit these properties.
+		 */
+		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
+		set_user_nice(create.result, KTHREAD_NICE_LEVEL);
+		set_cpus_allowed_ptr(create.result, CPU_MASK_ALL_PTR);
 	}
 	return create.result;
 }

