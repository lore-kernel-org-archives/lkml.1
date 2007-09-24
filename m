Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbXIXQ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbXIXQ1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760407AbXIXQZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47203 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760397AbXIXQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:24:58 -0400
Date: Mon, 24 Sep 2007 09:20:04 -0700
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
       alan@lxorguk.ukuu.org.uk, oleg@tv-sign.ru, sukadev@us.ibm.com,
       adobriyan@sw.ru, tglx@linutronix.de, jeremy.katz@windriver.com,
       yue.tao@windriver.com, mingo@elte.hu, roland@redhat.com
Subject: [06/50] sigqueue_free: fix the race with collect_signal()
Message-ID: <20070924162004.GG13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sigqueue_free-fix-the-race-with-collect_signal.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Oleg Nesterov <oleg@tv-sign.ru>

commit 60187d2708caa870f0825d753df1612ea688eb9e in mainline.

Spotted by taoyue <yue.tao@windriver.com> and Jeremy Katz <jeremy.katz@windriver.com>.

collect_signal:				sigqueue_free:

	list_del_init(&first->list);
						if (!list_empty(&q->list)) {
							// not taken
						}
						q->flags &= ~SIGQUEUE_PREALLOC;

	__sigqueue_free(first);			__sigqueue_free(q);

Now, __sigqueue_free() is called twice on the same "struct sigqueue" with the
obviously bad implications.

In particular, this double free breaks the array_cache->avail logic, so the
same sigqueue could be "allocated" twice, and the bug can manifest itself via
the "impossible" BUG_ON(!SIGQUEUE_PREALLOC) in sigqueue_free/send_sigqueue.

Hopefully this can explain these mysterious bug-reports, see

	http://marc.info/?t=118766926500003
	http://marc.info/?t=118466273000005

Alexey Dobriyan reports this patch makes the difference for the testcase, but
nobody has an access to the application which opened the problems originally.

Also, this patch removes tasklist lock/unlock, ->siglock is enough.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: taoyue <yue.tao@windriver.com>
Cc: Jeremy Katz <jeremy.katz@windriver.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1259,20 +1259,19 @@ struct sigqueue *sigqueue_alloc(void)
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
+	spinlock_t *lock = &current->sighand->siglock;
+
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
 	 * If the signal is still pending remove it from the
-	 * pending queue.
+	 * pending queue. We must hold ->siglock while testing
+	 * q->list to serialize with collect_signal().
 	 */
-	if (unlikely(!list_empty(&q->list))) {
-		spinlock_t *lock = &current->sighand->siglock;
-		read_lock(&tasklist_lock);
-		spin_lock_irqsave(lock, flags);
-		if (!list_empty(&q->list))
-			list_del_init(&q->list);
-		spin_unlock_irqrestore(lock, flags);
-		read_unlock(&tasklist_lock);
-	}
+	spin_lock_irqsave(lock, flags);
+	if (!list_empty(&q->list))
+		list_del_init(&q->list);
+	spin_unlock_irqrestore(lock, flags);
+
 	q->flags &= ~SIGQUEUE_PREALLOC;
 	__sigqueue_free(q);
 }

-- 
