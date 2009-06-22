Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZFVUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZFVUTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbZFVUTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:19:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33246 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbZFVUTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:19:19 -0400
Date: Mon, 22 Jun 2009 19:04:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 1/2] shift security_task_wait() from eligible_child()
	to wait_consider_task()
Message-ID: <20090622170434.GA4903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation, no functional changes.

eligible_child() has a single caller, wait_consider_task(). We can move
security_task_wait() out from eligible_child(), this allows us to use it
for filtered wake_up().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- WAIT/kernel/exit.c~1_SPLIT_ELIGIBLE	2009-06-22 17:19:55.000000000 +0200
+++ WAIT/kernel/exit.c	2009-06-22 17:33:08.000000000 +0200
@@ -1104,8 +1104,6 @@ static struct pid *task_pid_type(struct 
 
 static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 {
-	int err;
-
 	if (wo->wo_type < PIDTYPE_MAX) {
 		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
 			return 0;
@@ -1120,10 +1118,6 @@ static int eligible_child(struct wait_op
 	    && !(wo->wo_flags & __WALL))
 		return 0;
 
-	err = security_task_wait(p);
-	if (err)
-		return err;
-
 	return 1;
 }
 
@@ -1480,6 +1474,7 @@ static int wait_consider_task(struct wai
 	if (!ret)
 		return ret;
 
+	ret = security_task_wait(p);
 	if (unlikely(ret < 0)) {
 		/*
 		 * If we have not yet seen any eligible child,

