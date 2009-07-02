Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZGBR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZGBR2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGBR22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:28:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39106 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZGBR21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:28:27 -0400
Date: Thu, 2 Jul 2009 19:25:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ratan Nalumasu <rnalumasu@gmail.com>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] shift security_task_wait() from eligible_child() to
	wait_consider_task()
Message-ID: <20090702172508.GA24086@redhat.com>
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

--- WAIT/kernel/exit.c~1_SPLIT_ELIGIBLE	2009-07-02 18:23:58.000000000 +0200
+++ WAIT/kernel/exit.c	2009-07-02 18:29:24.000000000 +0200
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

