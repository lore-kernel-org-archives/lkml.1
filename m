Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZC2LyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZC2LyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZC2LyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:54:06 -0400
Received: from aun.it.uu.se ([130.238.12.36]:47075 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZC2LyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:54:05 -0400
Date: Sun, 29 Mar 2009 13:53:59 +0200 (MEST)
Message-Id: <200903291153.n2TBrxvV012426@pilspetsen.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: can get_signal_to_deliver() clobber current's _RESTORE_SIGMASK flag?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all archs that support _RESTORE_SIGMASK do_signal() queries the
thread flags and sets up oldset before calling get_signal_to_deliver(),
but oldset is then only used in the "if (signr > 0)" block.

Would it be safe to move the threads flags query past the
get_signal_to_deliver() call into the "if (signr > 0)" block?
To illustrate, here's how it would look on x86:

--- linux-2.6.29/arch/x86/kernel/signal.c.~1~	2009-03-24 18:00:34.000000000 +0100
+++ linux-2.6.29/arch/x86/kernel/signal.c	2009-03-29 10:36:02.000000000 +0200
@@ -802,7 +802,6 @@ static void do_signal(struct pt_regs *re
 	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
-	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which is why we may in certain
@@ -814,13 +813,15 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
-		oldset = &current->saved_sigmask;
-	else
-		oldset = &current->blocked;
-
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
+		sigset_t *oldset;
+
+		if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+			oldset = &current->saved_sigmask;
+		else
+			oldset = &current->blocked;
+
 		/*
 		 * Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will


The background is that I've been working on _RESTORE_SIGMASK
support for ARM in order to enable pselect6/ppoll/epoll_pwait.
It's working but as a cleanup rmk wanted the oldset setup code to
be moved into the "if (signr > 0)" block. But that's only safe if
get_signal_to_deliver() cannot clobber current's _RESTORE_SIGMASK.

/Mikael
