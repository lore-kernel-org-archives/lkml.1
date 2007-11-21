Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXKUQA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXKUQA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759552AbXKUQAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:00:48 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60031 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbXKUQAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:00:47 -0500
Date: Wed, 21 Nov 2007 19:00:33 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/3] ptrace_check_attach: remove unneeded ->signal != NULL check
Message-ID: <20071121160033.GA1178@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is not possible to see the PT_PTRACED task without ->signal/sighand under
tasklist_lock, release_task() does ptrace_unlink() first. If the task was
already released before, ptrace_attach() can't succeed and set PT_PTRACED.
Remove this check.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/ptrace.c~3_signal	2007-11-21 16:53:39.000000000 +0300
+++ PT/kernel/ptrace.c	2007-11-21 17:20:24.000000000 +0300
@@ -99,9 +99,12 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent == current &&
-	     child->signal != NULL) {
+	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
 		ret = 0;
+		/*
+		 * child->sighand can't be NULL, release_task()
+		 * does ptrace_unlink() before __exit_signal().
+		 */
 		spin_lock_irq(&child->sighand->siglock);
 		if (is_task_stopped(child))
 			__set_task_state(child, TASK_TRACED);

