Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYEQPNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYEQPNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYEQPN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:13:29 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47499 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbYEQPN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:13:28 -0400
Date: Sat, 17 May 2008 19:14:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] signals: collect_signal: simplify the "still_pending" logic
Message-ID: <20080517151424.GA9508@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out sigdelset() calls and remove the "still_pending" variable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/kernel/signal.c~8_CLEANUP_STILL_PENDING	2008-05-17 18:41:28.000000000 +0400
+++ 25/kernel/signal.c	2008-05-17 18:53:58.000000000 +0400
@@ -307,7 +307,6 @@ unblock_all_signals(void)
 static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
-	int still_pending = 0;
 
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
@@ -315,16 +314,16 @@ static int collect_signal(int sig, struc
 	*/
 	list_for_each_entry(q, &list->list, list) {
 		if (q->info.si_signo == sig) {
-			if (first) {
-				still_pending = 1;
-				break;
-			}
+			if (first)
+				goto still_pending;
 			first = q;
 		}
 	}
+
+	sigdelset(&list->signal, sig);
+
 	if (first) {
-		if (!still_pending)
-			sigdelset(&list->signal, sig);
+still_pending:
 		if (unlikely(first->flags & SIGQUEUE_CANCELLED))
 			sig = 0;
 		copy_siginfo(info, &first->info);
@@ -336,7 +335,6 @@ static int collect_signal(int sig, struc
 		   a fast-pathed signal or we must have been
 		   out of queue space.  So zero out the info.
 		 */
-		sigdelset(&list->signal, sig);
 		info->si_signo = sig;
 		info->si_errno = 0;
 		info->si_code = 0;

