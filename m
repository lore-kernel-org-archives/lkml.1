Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYGHWz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYGHWz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYGHWzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:55:50 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44497 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753656AbYGHWzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:55:49 -0400
Message-ID: <4873F074.8010708@sgi.com>
Date: Tue, 08 Jul 2008 15:55:48 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] kthread: Reduce stack pressure in create_kthread and
 kthreadd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 1/1] kthread: Reduce stack pressure in create_kthread and kthreadd

  * Replace:
  
  	set_cpus_allowed(..., CPU_MASK_ALL)

    with:

  	set_cpus_allowed_ptr(..., CPU_MASK_ALL_PTR)

    to remove excessive stack requirements when NR_CPUS=4096.

Based on linux-2.6.tip/master

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/kthread.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.tip.orig/kernel/kthread.c
+++ linux-2.6.tip/kernel/kthread.c
@@ -107,7 +107,7 @@ static void create_kthread(struct kthrea
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed(create->result, CPU_MASK_ALL);
+		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
 	}
 	complete(&create->done);
 }
@@ -238,7 +238,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed(tsk, CPU_MASK_ALL);
+	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
 
 	current->flags |= PF_NOFREEZE;
 
