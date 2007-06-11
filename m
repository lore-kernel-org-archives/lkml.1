Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXFKWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXFKWT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXFKWTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:19:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:32820 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbXFKWTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:19:20 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, davidel@xmailserver.org
In-Reply-To: <alpine.LFD.0.98.0706072015520.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
	 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
	 <87sl949eyx.wl%takeuchi_satoru@jp.fujitsu.com>
	 <alpine.LFD.0.98.0706070852390.4205@woody.linux-foundation.org>
	 <1181255068.14818.77.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706072015520.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 08:16:18 +1000
Message-Id: <1181600178.14818.237.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Don't let signalfd dequeue private signals off other threads (in the
case of things like SIGILL or SIGSEGV, trying to do so would result
in undefined behaviour on who actually gets the signal, since they
are force unblocked).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Davide asked me to re-send this one. So here it is.


Index: linux-work/kernel/signal.c
===================================================================
--- linux-work.orig/kernel/signal.c	2007-06-08 15:28:00.000000000 +1000
+++ linux-work/kernel/signal.c	2007-06-08 15:28:44.000000000 +1000
@@ -363,7 +363,13 @@ static int __dequeue_signal(struct sigpe
  */
 int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
-	int signr = __dequeue_signal(&tsk->pending, mask, info);
+	int signr = 0;
+
+	/* We only dequeue private signals from ourselves, we don't let
+	 * signalfd steal them
+	 */
+	if (tsk == current)
+		signr = __dequeue_signal(&tsk->pending, mask, info);
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);


