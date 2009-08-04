Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbZHDVKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbZHDVKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZHDVKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:10:16 -0400
Received: from kroah.org ([198.145.64.141]:46662 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZHDVKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:10:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/3] tty-ldisc: turn ldisc user count into a proper refcount
Date: Tue,  4 Aug 2009 14:09:14 -0700
Message-Id: <1249420155-26210-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <20090804210829.GA26166@kroah.com>
References: <20090804210829.GA26166@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

By using the user count for the actual lifetime rules, we can get rid of
the silly "wait_for_idle" logic, because any busy ldisc will
automatically stay around until the last user releases it.  This avoids
a host of odd issues, and simplifies the code.

So now, when the last ldisc reference is dropped, we just release the
ldisc operations struct reference, and free the ldisc.

It looks obvious enough, and it does work for me, but the counting
_could_ be off. It probably isn't (bad counting in the new version would
generally imply that the old code did something really bad, like free an
ldisc with a non-zero count), but it does need some testing, and
preferably somebody looking at it.

With this change, both 'tty_ldisc_put()' and 'tty_ldisc_deref()' are
just aliases for the new ref-counting 'put_ldisc()'. Both of them
decrement the ldisc user count and free it if it goes down to zero.
They're identical functions, in other words.

But the reason they still exist as sepate functions is that one of them
was exported (tty_ldisc_deref) and had a stupid name (so I don't want to
use it as the main name), and the other one was used in multiple places
(and I didn't want to make the patch larger just to rename the users).

In addition to the refcounting, I did do some minimal cleanup. For
example, now "tty_ldisc_try()" actually returns the ldisc it got under
the lock, rather than returning true/false and then the caller would
look up the ldisc again (now without the protection of the lock).

That said, there's tons of dubious use of 'tty->ldisc' without obviously
proper locking or refcounting left. I expressly did _not_ want to try to
fix it all, keeping the patch minimal. There may or may not be bugs in
that kind of code, but they wouldn't be _new_ bugs.

That said, even if the bugs aren't new, the timing and lifetime will
change. For example, some silly code may depend on the 'tty->ldisc'
pointer not changing because they hold a refcount on the 'ldisc'. And
that's no longer true - if you hold a ref on the ldisc, the 'ldisc'
itself is safe, but tty->ldisc may change.

So the proper locking (remains) to hold tty->ldisc_mutex if you expect
tty->ldisc to be stable. That's not really a _new_ rule, but it's an
example of something that the old code might have unintentionally
depended on and hidden bugs.

Whatever. The patch _looks_ sensible to me. The only users of
ldisc->users are:
 - get_ldisc() - atomically increment the count

 - put_ldisc() - atomically decrements the count and releases if zero

 - tty_ldisc_try_get() - creates the ldisc, and sets the count to 1.
   The ldisc should then either be released, or be attached to a tty.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c |  143 +++++++++++++++-------------------------------
 1 files changed, 46 insertions(+), 97 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index fd175e6..be55dfc 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -48,6 +48,34 @@ static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
+static inline struct tty_ldisc *get_ldisc(struct tty_ldisc *ld)
+{
+	if (ld)
+		atomic_inc(&ld->users);
+	return ld;
+}
+
+static inline void put_ldisc(struct tty_ldisc *ld)
+{
+	if (WARN_ON_ONCE(!ld))
+		return;
+
+	/*
+	 * If this is the last user, free the ldisc, and
+	 * release the ldisc ops.
+	 */
+	if (atomic_dec_and_test(&ld->users)) {
+		unsigned long flags;
+		struct tty_ldisc_ops *ldo = ld->ops;
+
+		kfree(ld);
+		spin_lock_irqsave(&tty_ldisc_lock, flags);
+		ldo->refcount--;
+		module_put(ldo->owner);
+		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	}
+}
+
 /**
  *	tty_register_ldisc	-	install a line discipline
  *	@disc: ldisc number
@@ -142,7 +170,7 @@ static struct tty_ldisc *tty_ldisc_try_get(int disc)
 			/* lock it */
 			ldops->refcount++;
 			ld->ops = ldops;
-			atomic_set(&ld->users, 0);
+			atomic_set(&ld->users, 1);
 			err = 0;
 		}
 	}
@@ -181,35 +209,6 @@ static struct tty_ldisc *tty_ldisc_get(int disc)
 	return ld;
 }
 
-/**
- *	tty_ldisc_put		-	drop ldisc reference
- *	@ld: ldisc
- *
- *	Drop a reference to a line discipline. Manage refcounts and
- *	module usage counts. Free the ldisc once the recount hits zero.
- *
- *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
- */
-
-static void tty_ldisc_put(struct tty_ldisc *ld)
-{
-	unsigned long flags;
-	int disc = ld->ops->num;
-	struct tty_ldisc_ops *ldo;
-
-	BUG_ON(disc < N_TTY || disc >= NR_LDISCS);
-
-	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	ldo = tty_ldiscs[disc];
-	BUG_ON(ldo->refcount == 0);
-	ldo->refcount--;
-	module_put(ldo->owner);
-	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	WARN_ON(atomic_read(&ld->users));
-	kfree(ld);
-}
-
 static void *tty_ldiscs_seq_start(struct seq_file *m, loff_t *pos)
 {
 	return (*pos < NR_LDISCS) ? pos : NULL;
@@ -234,7 +233,7 @@ static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
 	if (IS_ERR(ld))
 		return 0;
 	seq_printf(m, "%-10s %2d\n", ld->ops->name ? ld->ops->name : "???", i);
-	tty_ldisc_put(ld);
+	put_ldisc(ld);
 	return 0;
 }
 
@@ -288,20 +287,17 @@ static void tty_ldisc_assign(struct tty_struct *tty, struct tty_ldisc *ld)
  *	Locking: takes tty_ldisc_lock
  */
 
-static int tty_ldisc_try(struct tty_struct *tty)
+static struct tty_ldisc *tty_ldisc_try(struct tty_struct *tty)
 {
 	unsigned long flags;
 	struct tty_ldisc *ld;
-	int ret = 0;
 
 	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	ld = tty->ldisc;
-	if (test_bit(TTY_LDISC, &tty->flags)) {
-		atomic_inc(&ld->users);
-		ret = 1;
-	}
+	ld = NULL;
+	if (test_bit(TTY_LDISC, &tty->flags))
+		ld = get_ldisc(tty->ldisc);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	return ret;
+	return ld;
 }
 
 /**
@@ -322,10 +318,11 @@ static int tty_ldisc_try(struct tty_struct *tty)
 
 struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
 {
+	struct tty_ldisc *ld;
+
 	/* wait_event is a macro */
-	wait_event(tty_ldisc_wait, tty_ldisc_try(tty));
-	WARN_ON(atomic_read(&tty->ldisc->users) == 0);
-	return tty->ldisc;
+	wait_event(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
+	return ld;
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
 
@@ -342,9 +339,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
 
 struct tty_ldisc *tty_ldisc_ref(struct tty_struct *tty)
 {
-	if (tty_ldisc_try(tty))
-		return tty->ldisc;
-	return NULL;
+	return tty_ldisc_try(tty);
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref);
 
@@ -360,19 +355,15 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref);
 
 void tty_ldisc_deref(struct tty_ldisc *ld)
 {
-	unsigned long flags;
-
-	BUG_ON(ld == NULL);
-
-	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	if (atomic_read(&ld->users) == 0)
-		printk(KERN_ERR "tty_ldisc_deref: no references.\n");
-	else if (atomic_dec_and_test(&ld->users))
-		wake_up(&tty_ldisc_wait);
-	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	put_ldisc(ld);
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_deref);
 
+static inline void tty_ldisc_put(struct tty_ldisc *ld)
+{
+	put_ldisc(ld);
+}
+
 /**
  *	tty_ldisc_enable	-	allow ldisc use
  *	@tty: terminal to activate ldisc on
@@ -521,31 +512,6 @@ static int tty_ldisc_halt(struct tty_struct *tty)
 }
 
 /**
- *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
- *	@tty: tty to wait for
- *
- *	Wait for the line discipline to become idle. The discipline must
- *	have been halted for this to guarantee it remains idle.
- *
- *	tty_ldisc_lock protects the ref counts currently.
- */
-
-static int tty_ldisc_wait_idle(struct tty_struct *tty)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	while (atomic_read(&tty->ldisc->users)) {
-		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-		if (wait_event_timeout(tty_ldisc_wait,
-				atomic_read(&tty->ldisc->users) == 0, 5 * HZ) == 0)
-			return -EBUSY;
-		spin_lock_irqsave(&tty_ldisc_lock, flags);
-	}
-	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	return 0;
-}
-
-/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -640,14 +606,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	flush_scheduled_work();
 
-	/* Let any existing reference holders finish */
-	retval = tty_ldisc_wait_idle(tty);
-	if (retval < 0) {
-		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
-		tty_ldisc_put(new_ldisc);
-		return retval;
-	}
-
 	mutex_lock(&tty->ldisc_mutex);
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
@@ -793,7 +751,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		if (tty->ldisc) {	/* Not yet closed */
 			/* Switch back to N_TTY */
 			tty_ldisc_halt(tty);
-			tty_ldisc_wait_idle(tty);
 			tty_ldisc_reinit(tty);
 			/* At this point we have a closed ldisc and we want to
 			   reopen it. We could defer this to the next open but
@@ -858,14 +815,6 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	tty_ldisc_halt(tty);
 	flush_scheduled_work();
 
-	/*
-	 * Wait for any short term users (we know they are just driver
-	 * side waiters as the file is closing so user count on the file
-	 * side is zero.
-	 */
-
-	tty_ldisc_wait_idle(tty);
-
 	mutex_lock(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
-- 
1.6.3.2

