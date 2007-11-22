Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXKVQPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXKVQPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXKVQPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:15:20 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57690 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbXKVQPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:15:19 -0500
Date: Thu, 22 Nov 2007 19:14:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] ptrace_stop: fix the race with ptrace detach+attach
Message-ID: <20071122161459.GA5973@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the tracer went away (may_ptrace_stop() failed), ptrace_stop() drops tasklist
and then changes the ->state from TASK_TRACED to TASK_RUNNING.

This can fool another tracer which attaches to us in between. Change the ->state
under tasklist_lock to ensure that ptrace_check_attach() can't wrongly succeed.
Also, remove the unnecessary mb().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/signal.c~1_ptrace_stop	2007-11-21 21:41:02.000000000 +0300
+++ PT/kernel/signal.c	2007-11-22 16:59:35.000000000 +0300
@@ -1628,11 +1628,11 @@ static void ptrace_stop(int exit_code, i
 	} else {
 		/*
 		 * By the time we got the lock, our tracer went away.
-		 * Don't stop here.
+		 * Don't drop the lock yet, another tracer may come.
 		 */
-		read_unlock(&tasklist_lock);
-		set_current_state(TASK_RUNNING);
+		__set_current_state(TASK_RUNNING);
 		current->exit_code = nostop_code;
+		read_unlock(&tasklist_lock);
 	}
 
 	/*

