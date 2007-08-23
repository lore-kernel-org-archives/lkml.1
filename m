Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXHWWa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXHWWa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbXHWW2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50690 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbXHWW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:17 -0400
Date: Thu, 23 Aug 2007 15:26:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtk-manpages@gmx.net,
       benh@kernel.crashing.org, oleg@tv-sign.ru, tglx@linutronix.de,
       davidel@xmailserver.org, mingo@elte.hu, roland@redhat.com
Subject: [patch 06/28] signalfd: fix interaction with posix-timers
Message-ID: <20070823222619.GG18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="signalfd-fix-interaction-with-posix-timers.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@tv-sign.ru>

dequeue_signal:

	if (__SI_TIMER) {
		spin_unlock(&tsk->sighand->siglock);
		do_schedule_next_timer(info);
		spin_lock(&tsk->sighand->siglock);
	}

Unless tsk == curent, this is absolutely unsafe: nothing prevents tsk from
exiting. If signalfd was passed to another process, do_schedule_next_timer()
is just wrong.

Add yet another "tsk == current" check into dequeue_signal().

This patch fixes an oopsable bug, but breaks the scheduling of posix timers
if the shared __SI_TIMER signal was fetched via signalfd attached to another
sub-thread. Mostly fixed by the next patch.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -368,7 +368,7 @@ int dequeue_signal(struct task_struct *t
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	if (tsk == current)
+	if (likely(tsk == current))
 		signr = __dequeue_signal(&tsk->pending, mask, info);
 	if (!signr) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
@@ -415,7 +415,7 @@ int dequeue_signal(struct task_struct *t
 		if (!(tsk->signal->flags & SIGNAL_GROUP_EXIT))
 			tsk->signal->flags |= SIGNAL_STOP_DEQUEUED;
 	}
-	if ( signr &&
+	if (signr && likely(tsk == current) &&
 	     ((info->si_code & __SI_MASK) == __SI_TIMER) &&
 	     info->si_sys_private){
 		/*

-- 
