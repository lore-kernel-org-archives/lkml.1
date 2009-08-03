Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZHCXBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZHCXBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZHCXBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:01:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbZHCXBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:01:47 -0400
Date: Mon, 3 Aug 2009 16:01:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/2] tty-ldisc: get rid of tty_ldisc_try_get() helper
 function
In-Reply-To: <alpine.LFD.2.01.0908031558240.3270@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908031600180.3270@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com>
 <20090803221651.GA3122@localdomain.by> <alpine.LFD.2.01.0908031521300.3208@localhost.localdomain> <alpine.LFD.2.01.0908031555230.3270@localhost.localdomain> <alpine.LFD.2.01.0908031558240.3270@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Aug 2009 15:30:29 -0700
Subject: [PATCH 5/2] tty-ldisc: get rid of tty_ldisc_try_get() helper function

Now that the /proc/tty/ldiscs handling doesn't play games with 'struct
ldisc' any more, the only remaining user of 'tty_ldisc_try_get()' is
'tty_ldisc_get()' (note the lack of 'try').

And we're actually much better off folding the logic directly into that
file, since the 'try' part was always about trying to get the ldisc
operations, not the ldisc itself: and making that explicit inside of
'tty_ldisc_get()' clarifies the whole semantics.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Just consolidation and cleanup.

 drivers/char/tty_ldisc.c |   51 ++++++++++++++++++----------------------------
 1 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 8106514..706de25 100644
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
1.6.4.21.g73b866

