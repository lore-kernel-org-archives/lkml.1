Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXG2RFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXG2RFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764295AbXG2RFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:05:41 -0400
Received: from [83.222.144.183] ([83.222.144.183]:43521 "EHLO
	colorfullife.mysite.adiungo.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764046AbXG2RFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:05:40 -0400
Date: Sun, 29 Jul 2007 19:05:05 +0200
Message-Id: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com>
From: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

poll() returns -EINTR if a signal is pending.
EINTR is a bad choice: it means that poll returns to user space if the
task is stopped by SIGSTOP/SIGCONT or by the freezer.
select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
user space for signals that are handled by the kernel.

The patch switches poll() to ERESTARTNOHAND.
Tested with FC6. Patch against 2.6.23-rc1-mm1.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

--- 2.6/fs/select.c	2007-07-28 20:31:51.000000000 +0200
+++ build-2.6/fs/select.c	2007-07-28 21:21:52.000000000 +0200
@@ -621,7 +621,7 @@ static int do_poll(unsigned int nfds,  s
 		if (!count) {
 			count = wait->error;
 			if (signal_pending(current))
-				count = -EINTR;
+				count = -ERESTARTNOHAND;
 		}
 		if (count || !*timeout)
 			break;
@@ -774,7 +774,7 @@ asmlinkage long sys_ppoll(struct pollfd 
 	ret = do_sys_poll(ufds, nfds, &timeout);
 
 	/* We can restart this syscall, usually */
-	if (ret == -EINTR) {
+	if (ret == -ERESTARTNOHAND) {
 		/*
 		 * Don't restore the signal mask yet. Let do_signal() deliver
 		 * the signal on the way back to userspace, before the signal
@@ -785,7 +785,6 @@ asmlinkage long sys_ppoll(struct pollfd 
 					sizeof(sigsaved));
 			set_thread_flag(TIF_RESTORE_SIGMASK);
 		}
-		ret = -ERESTARTNOHAND;
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
