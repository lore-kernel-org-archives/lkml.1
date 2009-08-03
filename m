Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZHCR6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZHCR6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZHCR6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:58:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbZHCR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:58:48 -0400
Date: Mon, 3 Aug 2009 10:58:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 1/2] tty-ldisc: make refcount be atomic_t 'users' count
In-Reply-To: <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908031055400.3208@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Aug 2009 10:07:09 -0700
Subject: [PATCH 1/2] tty-ldisc: make refcount be atomic_t 'users' count

This is pure preparation of changing the ldisc reference counting to be
a true refcount that defines the lifetime of the ldisc.  But this is a
purely syntactic change for now to make the next steps easier.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

This patch should make no semantic changes at all. But I wanted to make 
the ldisc refcount be an atomic (I will be touching it without locks soon 
enough), and I wanted to rename it so that there isn't quite as much 
confusion between 'ldo->refcount' (ldisk operations refcount) and 
'ld->refcount' (ldisc refcount itself) in the same file.

So it's now an atomic 'ld->users' count. It still starts at zero, despite 
having a reference from 'tty->ldisc', but that will change once we turn it 
into a _real_ refcount.

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
1.6.4.21.g73b866

