Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYFPOTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYFPOTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYFPOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:18:32 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38102 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYFPOSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:18:31 -0400
Date: Mon, 16 Jun 2008 18:20:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ptrace: give more respect to SIGKILL
Message-ID: <20080616142017.GA13342@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_stop() has some complicated checks to prevent the scheduling in the
TASK_TRACED state with the pending SIGKILL, but these checks are racy, and
they depend on arch_ptrace_stop_needed().

This patch assumes that the traced task should die asap if it was killed by
SIGKILL, in that case schedule()->signal_pending_state() has no reason to
ignore the TASK_WAKEKILL part of TASK_TRACED, and we can kill this nasty
special case.

Note: do_exit()->ptrace_notify() is special, the killed task can already
dequeue SIGKILL at this point. Another indication that fatal_signal_pending()
is not exactly right.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/include/linux/sched.h~1_KILL_TRACED_CHECK	2008-06-01 16:44:39.000000000 +0400
+++ 26-rc2/include/linux/sched.h	2008-06-01 16:44:39.000000000 +0400
@@ -2034,9 +2034,6 @@ static inline int signal_pending_state(l
 	if (!signal_pending(p))
 		return 0;
 
-	if (state & (__TASK_STOPPED | __TASK_TRACED))
-		return 0;
-
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 

