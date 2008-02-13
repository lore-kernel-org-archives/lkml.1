Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYBMN4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYBMN4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYBMN4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:56:30 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:47465 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYBMN43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:56:29 -0500
Date: Wed, 13 Feb 2008 17:00:04 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, roland@redhat.com
Subject: [PATCH] consolidate-checking-for-ignored-legacy-signals-simplify
Message-ID: <20080213140004.GA846@tv-sign.ru>
References: <200802122142.m1CLgrkp023736@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802122142.m1CLgrkp023736@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every user of send_signal() must check ret twice. Change the meaning of the
returned value, so that ret <= 0 means we can just return, and ret == 1 means
the signal was queued. Saves a couple of if's and imho makes the code more
logical.

Also, remove now unneeded "ret = 0" initializions.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Emelyanov <xemul@openvz.org>

--- t/kernel/signal.c	2008-02-12 15:10:07.814848687 +0300
+++ t/kernel/signal.c	2008-02-12 15:09:14.000000000 +0300
@@ -673,7 +673,7 @@ static int send_signal(int sig, struct s
 	 * detailed information about the cause of the signal.
 	 */
 	if (sig_ignored(t, sig) || legacy_queue(signals, sig))
-		return 1;
+		return 0;
 
 	/*
 	 * Deliver the signal to listening signalfds. This must be called
@@ -731,7 +731,7 @@ static int send_signal(int sig, struct s
 
 out_set:
 	sigaddset(&signals->signal, sig);
-	return 0;
+	return 1;
 }
 
 int print_fatal_signals;
@@ -769,16 +769,16 @@ __setup("print-fatal-signals=", setup_pr
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
 {
-	int ret = 0;
+	int ret;
 
 	BUG_ON(!irqs_disabled());
 	assert_spin_locked(&t->sighand->siglock);
 
 	ret = send_signal(sig, info, t, &t->pending);
-	if (ret < 0)
+	if (ret <= 0)
 		return ret;
 
-	if (!ret && !sigismember(&t->blocked, sig))
+	if (!sigismember(&t->blocked, sig))
 		signal_wake_up(t, sig == SIGKILL);
 	return 0;
 }
@@ -946,7 +946,7 @@ __group_complete_signal(int sig, struct 
 int
 __group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret = 0;
+	int ret;
 
 	assert_spin_locked(&p->sighand->siglock);
 	handle_stop_signal(sig, p);
@@ -957,11 +957,10 @@ __group_send_sig_info(int sig, struct si
 	 * to avoid several races.
 	 */
 	ret = send_signal(sig, info, p, &p->signal->shared_pending);
-	if (unlikely(ret < 0))
+	if (ret <= 0)
 		return ret;
 
-	if (!ret)
-		__group_complete_signal(sig, p);
+	__group_complete_signal(sig, p);
 	return 0;
 }
 

