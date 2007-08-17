Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXHQPfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXHQPfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXHQPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:34:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50062 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXHQPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:34:57 -0400
Date: Fri, 17 Aug 2007 19:37:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] wait_task_zombie: don't fight with non-existing race with a dying ptracee
Message-ID: <20070817153740.GA1098@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(textually depends on wait_task_zombie-remove-unneeded-child-signal-check.patch)

The "p->exit_signal == -1 && p->ptrace == 0" check and the comment are bogus.
We already did exactly the same check in eligible_child(), we did not drop
tasklist_lock since then, and both variables need write_lock(tasklist) to be
changed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~1_WTZ_NORACE	2007-08-17 17:31:59.000000000 +0400
+++ t/kernel/exit.c	2007-08-17 18:56:31.000000000 +0400
@@ -1210,13 +1210,6 @@ static int wait_task_zombie(struct task_
 		BUG_ON(state != EXIT_DEAD);
 		return 0;
 	}
-	if (unlikely(p->exit_signal == -1 && p->ptrace == 0)) {
-		/*
-		 * This can only happen in a race with a ptraced thread
-		 * dying on another processor.
-		 */
-		return 0;
-	}
 
 	/* traced means p->ptrace, but not vice versa */
 	traced = (p->real_parent != p->parent);

