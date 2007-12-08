Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbXLHSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbXLHSh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXLHShS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:37:18 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42405 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbXLHShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:37:17 -0500
Date: Sat, 8 Dec 2007 21:38:00 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
Message-ID: <20071208183800.GA9940@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

p->exit_state != 0 doesn't mean this process is dead, it may have sub-threads.

However, the new "p->exit_state && thread_group_empty(p)" check is not correct
either, this is just the temporary hack. Perhaps we can just remove this check,
but I don't understand orphaned process groups magic. At all. However, I think
exit_notify() is obviously and completely wrong wrt this helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~4_orphaned_pgrp	2007-12-06 18:06:09.000000000 +0300
+++ PT/kernel/exit.c	2007-12-07 20:25:40.000000000 +0300
@@ -219,9 +219,9 @@ static int will_become_orphaned_pgrp(str
 	int ret = 1;
 
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
-		if (p == ignored_task
-				|| p->exit_state
-				|| is_global_init(p->real_parent))
+		if ((p == ignored_task) ||
+		    (p->exit_state && thread_group_empty(p)) ||
+		    is_global_init(p->real_parent))
 			continue;
 		if (task_pgrp(p->real_parent) != pgrp &&
 		    task_session(p->real_parent) == task_session(p)) {

