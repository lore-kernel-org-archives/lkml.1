Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYBOR7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYBOR7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbYBOR6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:58:40 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:59338 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbYBOR6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:58:39 -0500
Date: Fri, 15 Feb 2008 21:02:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] do_group_exit: use signal_group_exit() more consistently
Message-ID: <20080215180202.GA4356@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(hopefully this patch is simple enough for 2.6.25)

do_group_exit() checks SIGNAL_GROUP_EXIT to avoid taking sighand->siglock.
Since ed5d2cac114202fe2978a9cbcab8f5032796d538 exec() doesn't set this flag,
we should use signal_group_exit().

This is not needed for correctness, but can speedup the multithreaded exec
and makes the code more consistent.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/exit.c~5_DO_GROUP_EXIT	2008-02-15 16:59:17.000000000 +0300
+++ 25/kernel/exit.c	2008-02-15 20:27:18.000000000 +0300
@@ -1057,12 +1057,13 @@ asmlinkage long sys_exit(int error_code)
 NORET_TYPE void
 do_group_exit(int exit_code)
 {
+	struct signal_struct *sig = current->signal;
+
 	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
 
-	if (current->signal->flags & SIGNAL_GROUP_EXIT)
-		exit_code = current->signal->group_exit_code;
+	if (signal_group_exit(sig))
+		exit_code = sig->group_exit_code;
 	else if (!thread_group_empty(current)) {
-		struct signal_struct *const sig = current->signal;
 		struct sighand_struct *const sighand = current->sighand;
 		spin_lock_irq(&sighand->siglock);
 		if (signal_group_exit(sig))

