Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYCHRUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYCHRUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYCHRUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:20:38 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:52049 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbYCHRUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:20:37 -0500
Date: Sat, 8 Mar 2008 20:24:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC, PATCH] signals: print_fatal_signal: fix the signr "calculation"
Message-ID: <20080308172453.GA28323@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure this is needed, please review. Afaics, print_fatal_signal() is needed
to detect the early segfaults, and we don not transform the coredump signals
into the group-wide SIGKILL. With this change, for example, ^C will be reported.
I don't know whether this is good or bad. Most probably we don't need this, but
please clarify what is the desirable behaviour.

The task can dequeue SIGKILL while in fact it was killed by another fatal signal.
Consult ->group_exit_code to figure out the right signr.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~7_PFS_FIX	2008-03-08 17:38:50.000000000 +0300
+++ 25/kernel/signal.c	2008-03-08 19:15:00.000000000 +0300
@@ -834,6 +834,13 @@ int print_fatal_signals;
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
+	if (signr == SIGKILL) {
+		if (current->signal->flags & SIGNAL_GROUP_EXIT)
+			signr = current->signal->group_exit_code & 0x7f;
+		if (!signr || signr == SIGKILL)
+			return;
+	}
+
 	printk("%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, task_pid_nr(current), signr);
 
@@ -855,7 +862,7 @@ static void print_fatal_signal(struct pt
 
 static int __init setup_print_fatal_signals(char *str)
 {
-	get_option (&str, &print_fatal_signals);
+	get_option(&str, &print_fatal_signals);
 
 	return 1;
 }
@@ -1768,7 +1775,7 @@ relock:
 		 * Anything else is fatal, maybe with a core dump.
 		 */
 		current->flags |= PF_SIGNALED;
-		if ((signr != SIGKILL) && print_fatal_signals)
+		if (print_fatal_signals)
 			print_fatal_signal(regs, signr);
 		if (sig_kernel_coredump(signr)) {
 			/*

