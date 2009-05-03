Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZECWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZECWWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZECWWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:22:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55017 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZECWWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:22:06 -0400
Date: Mon, 4 May 2009 00:17:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] allow_signal: kill the bogus ->mm check, add a note about
	CLONE_SIGHAND
Message-ID: <20090503221737.GA26523@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allow_signal() checks ->mm == NULL. Not sure why. Perhaps to make sure
current is the kernel thread. But this helper must not be used unless
we are the kernel thread, kill this check.

Also, document the fact that the CLONE_SIGHAND kthread must not use
allow_signal(), unless the caller really wants to change the parent's
->sighand->action as well.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/kernel/exit.c~AS_1	2009-04-29 16:19:40.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-03 23:24:14.000000000 +0200
@@ -374,9 +374,8 @@ static void set_special_pids(struct pid 
 }
 
 /*
- * Let kernel threads use this to say that they
- * allow a certain signal (since daemonize() will
- * have disabled all of them by default).
+ * Let kernel threads use this to say that they allow a certain signal.
+ * Must not be used if kthread was cloned with CLONE_SIGHAND.
  */
 int allow_signal(int sig)
 {
@@ -384,14 +383,14 @@ int allow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
+	/* This is only needed for daemonize()'ed kthreads */
 	sigdelset(&current->blocked, sig);
-	if (!current->mm) {
-		/* Kernel threads handle their own signals.
-		   Let the signal code know it'll be handled, so
-		   that they don't get converted to SIGKILL or
-		   just silently dropped */
-		current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	}
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;

