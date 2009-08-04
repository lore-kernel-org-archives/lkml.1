Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbZHDVKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbZHDVKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZHDVKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:10:14 -0400
Received: from kroah.org ([198.145.64.141]:46658 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZHDVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:10:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] tty-ldisc: make refcount be atomic_t 'users' count
Date: Tue,  4 Aug 2009 14:09:13 -0700
Message-Id: <1249420155-26210-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <20090804210829.GA26166@kroah.com>
References: <20090804210829.GA26166@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

This is pure preparation of changing the ldisc reference counting to be
a true refcount that defines the lifetime of the ldisc.  But this is a
purely syntactic change for now to make the next steps easier.

This patch should make no semantic changes at all. But I wanted to make
the ldisc refcount be an atomic (I will be touching it without locks
soon enough), and I wanted to rename it so that there isn't quite as
much confusion between 'ldo->refcount' (ldisk operations refcount) and
'ld->refcount' (ldisc refcount itself) in the same file.

So it's now an atomic 'ld->users' count. It still starts at zero,
despite having a reference from 'tty->ldisc', but that will change once
we turn it into a _real_ refcount.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c  |   18 ++++++++----------
 include/linux/tty_ldisc.h |    2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index acd76b7..fd175e6 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -142,7 +142,7 @@ static struct tty_ldisc *tty_ldisc_try_get(int disc)
 			/* lock it */
 			ldops->refcount++;
 			ld->ops = ldops;
-			ld->refcount = 0;
+			atomic_set(&ld->users, 0);
 			err = 0;
 		}
 	}
@@ -206,7 +206,7 @@ static void tty_ldisc_put(struct tty_ldisc *ld)
 	ldo->refcount--;
 	module_put(ldo->owner);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	WARN_ON(ld->refcount);
+	WARN_ON(atomic_read(&ld->users));
 	kfree(ld);
 }
 
@@ -297,7 +297,7 @@ static int tty_ldisc_try(struct tty_struct *tty)
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
 	ld = tty->ldisc;
 	if (test_bit(TTY_LDISC, &tty->flags)) {
-		ld->refcount++;
+		atomic_inc(&ld->users);
 		ret = 1;
 	}
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
@@ -324,7 +324,7 @@ struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
 {
 	/* wait_event is a macro */
 	wait_event(tty_ldisc_wait, tty_ldisc_try(tty));
-	WARN_ON(tty->ldisc->refcount == 0);
+	WARN_ON(atomic_read(&tty->ldisc->users) == 0);
 	return tty->ldisc;
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
@@ -365,11 +365,9 @@ void tty_ldisc_deref(struct tty_ldisc *ld)
 	BUG_ON(ld == NULL);
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	if (ld->refcount == 0)
+	if (atomic_read(&ld->users) == 0)
 		printk(KERN_ERR "tty_ldisc_deref: no references.\n");
-	else
-		ld->refcount--;
-	if (ld->refcount == 0)
+	else if (atomic_dec_and_test(&ld->users))
 		wake_up(&tty_ldisc_wait);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 }
@@ -536,10 +534,10 @@ static int tty_ldisc_wait_idle(struct tty_struct *tty)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	while (tty->ldisc->refcount) {
+	while (atomic_read(&tty->ldisc->users)) {
 		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
 		if (wait_event_timeout(tty_ldisc_wait,
-				tty->ldisc->refcount == 0, 5 * HZ) == 0)
+				atomic_read(&tty->ldisc->users) == 0, 5 * HZ) == 0)
 			return -EBUSY;
 		spin_lock_irqsave(&tty_ldisc_lock, flags);
 	}
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 40f38d8..0c4ee9b 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -144,7 +144,7 @@ struct tty_ldisc_ops {
 
 struct tty_ldisc {
 	struct tty_ldisc_ops *ops;
-	int refcount;
+	atomic_t users;
 };
 
 #define TTY_LDISC_MAGIC	0x5403
-- 
1.6.3.2

