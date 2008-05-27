Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYE0Q5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYE0Q5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbYE0Q52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:57:28 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37093 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbYE0Q51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:57:27 -0400
Date: Tue, 27 May 2008 20:58:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] signals: collect_signal: simplify the "still_pending" logic
Message-ID: <20080527165857.GA1407@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out sigdelset() calls and remove the "still_pending" variable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>

--- 26-rc2/kernel/signal.c~3_CLEANUP_STILL_PENDING	2008-05-27 18:37:10.000000000 +0400
+++ 26-rc2/kernel/signal.c	2008-05-27 19:06:55.000000000 +0400
@@ -341,7 +341,6 @@ unblock_all_signals(void)
 static int collect_signal(int sig, struct sigpending *list, siginfo_t *info)
 {
 	struct sigqueue *q, *first = NULL;
-	int still_pending = 0;
 
 	/*
 	 * Collect the siginfo appropriate to this signal.  Check if
@@ -349,26 +348,24 @@ static int collect_signal(int sig, struc
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
+still_pending:
 		list_del_init(&first->list);
 		copy_siginfo(info, &first->info);
 		__sigqueue_free(first);
-		if (!still_pending)
-			sigdelset(&list->signal, sig);
 	} else {
-
 		/* Ok, it wasn't in the queue.  This must be
 		   a fast-pathed signal or we must have been
 		   out of queue space.  So zero out the info.
 		 */
-		sigdelset(&list->signal, sig);
 		info->si_signo = sig;
 		info->si_errno = 0;
 		info->si_code = 0;

