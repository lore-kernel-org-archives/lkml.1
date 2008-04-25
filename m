Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYDYBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYDYBSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYDYBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:18:06 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:58602 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbYDYBSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BV7B/PiAvc1i4FQZZzFZqL+AM6jgU/3oxD/tug3RmeGksgpOv1K+ix4U7N5ym0xVq7MNAsRIDtOHLPC8vUSjNKTZ7WXiySwqQrpLLQOwQz45nE3Oayd2xSQB66KAXm/i61CeLqFDVIpdWliVfgzbLyUTYDimfXjmKafhC2+xVJc=
Subject: [PATCH] sched: add statics, don't return void expressions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 18:17:55 -0700
Message-Id: <1209086275.20088.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
kernel/sched.c:760:20: warning: symbol 'sched_feat_names' was not declared. Should it be static?
kernel/sched.c:767:5: warning: symbol 'sched_feat_open' was not declared. Should it be static?
kernel/sched_fair.c:845:3: warning: returning void-valued expression
kernel/sched.c:4386:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/sched.c      |   10 ++++++----
 kernel/sched_fair.c |    6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0014b03..81ff960 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -757,14 +757,14 @@ const_debug unsigned int sysctl_sched_features =
 #define SCHED_FEAT(name, enabled)	\
 	#name ,
 
-__read_mostly char *sched_feat_names[] = {
+static __read_mostly char *sched_feat_names[] = {
 #include "sched_features.h"
 	NULL
 };
 
 #undef SCHED_FEAT
 
-int sched_feat_open(struct inode *inode, struct file *filp)
+static int sched_feat_open(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 	return 0;
@@ -4382,8 +4382,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
-	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
-		return account_guest_time(p, cputime);
+	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
+		account_guest_time(p, cputime);
+		return;
+	}
 
 	p->stime = cputime_add(p->stime, cputime);
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 89fa32b..0bd575e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -841,8 +841,10 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 * queued ticks are scheduled to match the slice, so don't bother
 	 * validating it and just reschedule.
 	 */
-	if (queued)
-		return resched_task(rq_of(cfs_rq)->curr);
+	if (queued) {
+		resched_task(rq_of(cfs_rq)->curr);
+		return;
+	}
 	/*
 	 * don't let the period tick interfere with the hrtick preemption
 	 */
-- 
1.5.5.1.270.g89765



