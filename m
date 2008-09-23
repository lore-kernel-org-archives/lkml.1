Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYIWPyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYIWPyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIWPy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:54:26 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:49926 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751456AbYIWPyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:54:24 -0400
Date: Tue, 23 Sep 2008 11:53:31 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [BUG, TEST PATCH] stallout race between SIGCONT and SIGSTOP
Message-ID: <20080923155331.GA20380@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.25-git16, the Open POSIX Test Suite test sigaction/10-1 on
occasion stalls out.  A ^C breaks the test out of the stall.

To see the problem, one must run the test in a loop.  The stallout happens
anywhere from 3 to approximately 60 iterations.  To make the test runtime
more bearable, I've been using a custom version that is 8x faster than
the original, s/sleep/usleep/g + new sleep constants.

The test in essence does 10 SIGSTOPs and SIGCONTs, interleaved, with a
short delay between each SIGSTOP and SIGCONT, but none (other than the
small delay of a printf) between each SIGCONT and SIGSTOP:

    for(i=0; i<10; i++) {
	printf("--> Sending SIGSTOP #%d\n", i);
	kill (pid, SIGSTOP);
	usleep(125000);
	printf("--> Sending SIGCONT #%d\n", i);
	kill (pid, SIGCONT);
	// usleep(125000); /* this is missing from the real 10-1 */
    }

When the above commented-out usleep is enabled, the stallout disappears.
If instead of adding a usleep, the printf's are removed, the test stalls
out immediately.  Therefore the problem has something to do with a SIGSTOP
being issued 'too soon' after the issuance of a SIGCONT.

Bisection shows that the problem was introduced by

    commit e442055193e4584218006e616c9bdce0c5e9ae5c
    Author: Oleg Nesterov <oleg@tv-sign.ru>
    Date:   Wed Apr 30 00:52:44 2008 -0700

This commit adds code that solves serious race problems by deferring the
actual processing of SIGSTOP and SIGCONT to a later time.  I suspect it
is this deferring that is making SIGCONT sensitive to a SIGSTOP coming
in too close on its heels.

The following patch, not to be considered seriously, lends credence to
that theory.  It reverts a bit of the above commit, forcing SIGCONT (but
not SIGSTOP) to be processed immediately.  With this patch, I achieved
some 1,400 runs before manually stopping the test.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc6-git4/kernel/signal.c
===================================================================
--- 2.6.27-rc6-git4.orig/kernel/signal.c	2008-09-17 17:42:35.000000000 -0400
+++ 2.6.27-rc6-git4/kernel/signal.c	2008-09-22 16:07:48.000000000 -0400
@@ -598,6 +598,8 @@
 	return security_task_kill(t, info, sig, 0);
 }
 
+static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
+
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -682,6 +684,10 @@
 			signal->flags = why | SIGNAL_STOP_CONTINUED;
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
+			signal->flags &= ~SIGNAL_CLD_MASK;
+			spin_unlock(&p->sighand->siglock);
+			do_notify_parent_cldstop(p, CLD_CONTINUED);
+			spin_lock(&p->sighand->siglock);
 		} else {
 			/*
 			 * We are not stopped, but there could be a stop
