Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbXHQQox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbXHQQox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXHQQop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:44:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56836 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbXHQQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:44:44 -0400
Date: Fri, 17 Aug 2007 20:47:10 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] __group_complete_signal: eliminate unneeded wakeup of ->group_exit_task
Message-ID: <20070817164710.GA3535@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. __group_complete_signal() wakes up ->group_exit_task twice. The second
wakeup's state includes TASK_UNINTERRUPTIBLE, which is not very appropriate.

Change the code to pass the "correct" argument to signal_wake_up() and kill now
unneeded wake_up_process().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/signal.c~2_GCS_NOWAKEUP	2007-08-12 19:48:26.000000000 +0400
+++ t/kernel/signal.c	2007-08-17 20:23:59.000000000 +0400
@@ -911,8 +911,7 @@ __group_complete_signal(int sig, struct 
 			do {
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
-				t = next_thread(t);
-			} while (t != p);
+			} while_each_thread(p, t);
 			return;
 		}
 
@@ -930,13 +929,11 @@ __group_complete_signal(int sig, struct 
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		p->signal->group_stop_count = 0;
 		p->signal->group_exit_task = t;
-		t = p;
+		p = t;
 		do {
 			p->signal->group_stop_count++;
-			signal_wake_up(t, 0);
-			t = next_thread(t);
-		} while (t != p);
-		wake_up_process(p->signal->group_exit_task);
+			signal_wake_up(t, t == p);
+		} while_each_thread(p, t);
 		return;
 	}
 

