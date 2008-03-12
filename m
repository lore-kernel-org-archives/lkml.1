Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYCLNSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYCLNSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYCLNRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:17:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:50262 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbYCLNRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:17:44 -0400
Date: Wed, 12 Mar 2008 16:17:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: send_signal: be paranoid about signalfd_notify()
Message-ID: <20080312131716.GA14324@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

send_signal() shouldn't call signalfd_notify() if it then fails with -EAGAIN.
Harmless, just a paranoid cleanup.

Also remove the comment. It is obsolete, signalfd_notify() was simplified and
does a simple wakeup.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~3_SS_NOTIFY	2008-03-12 15:16:52.000000000 +0300
+++ 25/kernel/signal.c	2008-03-12 15:55:47.000000000 +0300
@@ -769,13 +769,6 @@ static int send_signal(int sig, struct s
 	 */
 	if (legacy_queue(pending, sig))
 		return 0;
-
-	/*
-	 * Deliver the signal to listening signalfds. This must be called
-	 * with the sighand lock held.
-	 */
-	signalfd_notify(t, sig);
-
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.
@@ -825,6 +818,7 @@ static int send_signal(int sig, struct s
 	}
 
 out_set:
+	signalfd_notify(t, sig);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
 	return 0;

