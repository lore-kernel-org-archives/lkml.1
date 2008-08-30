Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYH3RDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYH3RDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYH3RDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:03:44 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49043 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYH3RDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:03:43 -0400
Date: Sat, 30 Aug 2008 21:08:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softlockup: minor cleanup, don't check task->state twice
Message-ID: <20080830170840.GA7884@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit 16d9679f33caf7e683471647d1472bfe133d858 changed
check_hung_task() to filter out the TASK_KILLABLE tasks. We can
move this check to the caller which has to test t->state anyway.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.27-rc4/kernel/softlockup.c~SOFTLOCKUP	2008-08-30 18:24:40.000000000 +0400
+++ 2.6.27-rc4/kernel/softlockup.c	2008-08-30 21:06:51.000000000 +0400
@@ -180,10 +180,6 @@ static void check_hung_task(struct task_
 	if (t->flags & PF_FROZEN)
 		return;
 
-	/* Don't check for tasks waiting on network file systems like NFS */
-	if (t->state & TASK_KILLABLE)
-		return;
-
 	if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
 		t->last_switch_count = switch_count;
 		t->last_switch_timestamp = now;
@@ -237,7 +233,8 @@ static void check_hung_uninterruptible_t
 	do_each_thread(g, t) {
 		if (!--max_count)
 			goto unlock;
-		if (t->state & TASK_UNINTERRUPTIBLE)
+		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
+		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now);
 	} while_each_thread(g, t);
  unlock:

