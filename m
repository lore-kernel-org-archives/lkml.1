Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbXKXRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbXKXRYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKXRYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:24:09 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60463 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbXKXRYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:24:08 -0500
Date: Sat, 24 Nov 2007 20:24:31 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] wait_task_zombie: remove ->exit_state/exit_signal checks for WNOWAIT
Message-ID: <20071124172431.GA8385@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The first "p->exit_state != EXIT_ZOMBIE" check doesn't make too much sense. The
exit_state was EXIT_ZOMBIE when the function was called, and another thread can
change it to EXIT_DEAD right after the check.

The second condition is not possible, detached non-traced threads were already
filtered out by eligible_child(), we didn't drop tasklist since then.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~8_wtz_dead_code	2007-11-24 19:28:11.000000000 +0300
+++ PT/kernel/exit.c	2007-11-24 20:02:27.000000000 +0300
@@ -1193,10 +1193,6 @@ static int wait_task_zombie(struct task_
 		int exit_code = p->exit_code;
 		int why, status;
 
-		if (unlikely(p->exit_state != EXIT_ZOMBIE))
-			return 0;
-		if (unlikely(p->exit_signal == -1 && p->ptrace == 0))
-			return 0;
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
 		if ((exit_code & 0x7f) == 0) {

