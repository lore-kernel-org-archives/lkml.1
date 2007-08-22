Return-Path: <linux-kernel-owner+w=401wt.eu-S1764948AbXHVQwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764948AbXHVQwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763845AbXHVQwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:52:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55050 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761777AbXHVQwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:52:42 -0400
Date: Wed, 22 Aug 2007 20:55:39 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Kowalczyk <qrczak@knm.org.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] setpgid(child) fails if the child was forked by sub-thread
Message-ID: <20070822165539.GA191@tv-sign.ru>
References: <bug-8921-10286@http.bugzilla.kernel.org/> <20070822082517.321edfa5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822082517.321edfa5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by Marcin Kowalczyk <qrczak@knm.org.pl>.

sys_setpgid(child) fails if the child was forked by sub-thread.

Fix the "is it our child" check. The previous commit
ee0acf90d320c29916ba8c5c1b2e908d81f5057d was not complete.

(this patch asks for the new same_thread_group() helper, but mainline doesn't
 have it yet).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/sys.c~SETPGID	2007-08-09 19:59:27.000000000 +0400
+++ t/kernel/sys.c	2007-08-22 20:11:23.000000000 +0400
@@ -1442,7 +1442,6 @@ asmlinkage long sys_times(struct tms __u
  * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
  * LBT 04.03.94
  */
-
 asmlinkage long sys_setpgid(pid_t pid, pid_t pgid)
 {
 	struct task_struct *p;
@@ -1470,7 +1469,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 	if (!thread_group_leader(p))
 		goto out;
 
-	if (p->real_parent == group_leader) {
+	if (p->real_parent->tgid == group_leader->tgid) {
 		err = -EPERM;
 		if (task_session(p) != task_session(group_leader))
 			goto out;

