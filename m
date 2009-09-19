Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZISViG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZISViG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZISVh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:37:59 -0400
Received: from kroah.org ([198.145.64.141]:50895 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZISVh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:37:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/79] tty-ldisc: get rid of tty_ldisc_try_get() helper function
Date: Sat, 19 Sep 2009 14:36:10 -0700
Message-Id: <1253396244-7885-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Now that the /proc/tty/ldiscs handling doesn't play games with 'struct
ldisc' any more, the only remaining user of 'tty_ldisc_try_get()' is
'tty_ldisc_get()' (note the lack of 'try').

And we're actually much better off folding the logic directly into that
file, since the 'try' part was always about trying to get the ldisc
operations, not the ldisc itself: and making that explicit inside of
'tty_ldisc_get()' clarifies the whole semantics.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c |   51 ++++++++++++++++++----------------------------
 1 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index cbfacc0..aafdbae 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -175,34 +175,6 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
 }
 
 /**
- *	tty_ldisc_try_get	-	try and reference an ldisc
- *	@disc: ldisc number
- *
- *	Attempt to open and lock a line discipline into place. Return
- *	the line discipline refcounted or an error.
- */
-
-static struct tty_ldisc *tty_ldisc_try_get(int disc)
-{
-	struct tty_ldisc *ld;
-	struct tty_ldisc_ops *ldops;
-
-	ld = kmalloc(sizeof(struct tty_ldisc), GFP_KERNEL);
-	if (ld == NULL)
-		return ERR_PTR(-ENOMEM);
-
-	ldops = get_ldops(disc);
-	if (IS_ERR(ldops)) {
-		kfree(ld);
-		return ERR_CAST(ldops);
-	}
-
-	ld->ops = ldops;
-	atomic_set(&ld->users, 1);
-	return ld;
-}
-
-/**
  *	tty_ldisc_get		-	take a reference to an ldisc
  *	@disc: ldisc number
  *
@@ -218,14 +190,31 @@ static struct tty_ldisc *tty_ldisc_try_get(int disc)
 static struct tty_ldisc *tty_ldisc_get(int disc)
 {
 	struct tty_ldisc *ld;
+	struct tty_ldisc_ops *ldops;
 
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return ERR_PTR(-EINVAL);
-	ld = tty_ldisc_try_get(disc);
-	if (IS_ERR(ld)) {
+
+	/*
+	 * Get the ldisc ops - we may need to request them to be loaded
+	 * dynamically and try again.
+	 */
+	ldops = get_ldops(disc);
+	if (IS_ERR(ldops)) {
 		request_module("tty-ldisc-%d", disc);
-		ld = tty_ldisc_try_get(disc);
+		ldops = get_ldops(disc);
+		if (IS_ERR(ldops))
+			return ERR_CAST(ldops);
+	}
+
+	ld = kmalloc(sizeof(struct tty_ldisc), GFP_KERNEL);
+	if (ld == NULL) {
+		put_ldops(ldops);
+		return ERR_PTR(-ENOMEM);
 	}
+
+	ld->ops = ldops;
+	atomic_set(&ld->users, 1);
 	return ld;
 }
 
-- 
1.6.4.2

