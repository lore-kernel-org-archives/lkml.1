Return-Path: <linux-kernel-owner+w=401wt.eu-S935593AbZFOVbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935593AbZFOVbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934385AbZFOVb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:31:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZFOVb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:31:26 -0400
Date: Mon, 15 Jun 2009 23:26:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ptrace: wait_task_zombie: do not account traced
	sub-threads
Message-ID: <20090615212648.GA22751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is ancient, the fix doesn't depend on other changes in -mm.

If we trace the sub-thread of our natural child and this sub-thread exits,
we update parent->signal->cxxx fields. But we should not do this until the
whole thread-group exits, otherwise we account this thread (and all other
live threads) twice.

Add the task_detached() check. No need to check thread_group_empty(),
wait_consider_task()->delay_group_leader() already did this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~1_WAIT_REPARENTED	2009-06-15 21:04:49.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-06-15 22:26:02.000000000 +0200
@@ -1189,7 +1189,7 @@ static int wait_task_zombie(struct wait_
 
 	traced = ptrace_reparented(p);
 
-	if (likely(!traced)) {
+	if (likely(!traced) && likely(!task_detached(p))) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		struct task_cputime cputime;

