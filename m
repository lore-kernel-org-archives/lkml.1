Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYEQPQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYEQPQC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbYEQPOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:14:37 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47574 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621AbYEQPOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:14:36 -0400
Date: Sat, 17 May 2008 19:14:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] signals: introduce SIGQUEUE_CANCELLED
Message-ID: <20080517151421.GA9499@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Linus Torvalds.

Introduce SIGQUEUE_CANCELLED flag. If it is set, the pending signal should be
ignored and collect_signal() should return 0.

Note that the new flag is completely orthogonal to SIGQUEUE_PREALLOC, and it
can be set without ->siglock held.

No users of this new flag yet, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/signal.h~5_INTRODUCE_CANCELLED	2008-03-04 21:43:25.000000000 +0300
+++ 25/include/linux/signal.h	2008-03-04 21:43:25.000000000 +0300
@@ -20,6 +20,7 @@ struct sigqueue {
 
 /* flags values. */
 #define SIGQUEUE_PREALLOC	1
+#define SIGQUEUE_CANCELLED	2
 
 struct sigpending {
 	struct list_head list;
--- 25/kernel/signal.c~5_INTRODUCE_CANCELLED	2008-05-17 17:14:04.000000000 +0400
+++ 25/kernel/signal.c	2008-05-17 17:40:09.000000000 +0400
@@ -326,11 +326,13 @@ static int collect_signal(int sig, struc
 		}
 	}
 	if (first) {
-		list_del_init(&first->list);
-		copy_siginfo(info, &first->info);
-		__sigqueue_free(first);
 		if (!still_pending)
 			sigdelset(&list->signal, sig);
+		if (unlikely(first->flags & SIGQUEUE_CANCELLED))
+			sig = 0;
+		copy_siginfo(info, &first->info);
+		list_del_init(&first->list);
+		__sigqueue_free(first);
 	} else {
 
 		/* Ok, it wasn't in the queue.  This must be
@@ -344,7 +346,7 @@ static int collect_signal(int sig, struc
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}
-	return 1;
+	return sig;
 }
 
 static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
@@ -362,8 +364,7 @@ static int __dequeue_signal(struct sigpe
 			}
 		}
 
-		if (!collect_signal(sig, pending, info))
-			sig = 0;
+		sig = collect_signal(sig, pending, info);
 	}
 
 	return sig;

