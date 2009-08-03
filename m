Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbZHCW6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbZHCW6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZHCW6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:58:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769AbZHCW6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:58:43 -0400
Date: Mon, 3 Aug 2009 15:58:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/2] tty-ldisc: be more careful in 'put_ldisc' locking
In-Reply-To: <alpine.LFD.2.01.0908031521300.3208@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908031555230.3270@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com>
 <20090803221651.GA3122@localdomain.by> <alpine.LFD.2.01.0908031521300.3208@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Aug 2009 14:55:24 -0700
Subject: [PATCH 3/2] tty-ldisc: be more careful in 'put_ldisc' locking

Use 'atomic_dec_and_lock()' to make sure that we always hold the
tty_ldisc_lock when the ldisc count goes to zero. That way we can never
race against 'tty_ldisc_try()' increasing the count again.

Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/char/tty_ldisc.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

Ok, this is strictly speaking a bugfix, but the race is so unlikely that I 
doubt that you'll see it in testing.

So testing just patches 1-2 is fine, but this is a good idea on top of 
them.

I'll be sending out two further patches after this that are pure cleanups 
(numbered 4/2 and 5/2). Again, testing them would be wonderful, but not 
essential - they're not as interesting or important as 1-2 were.

On Mon, 3 Aug 2009, Linus Torvalds wrote:
> 
> Ogawa found a race in my original 2/2, and Greg has a small fix pending, 
> but that almost certainly won't realistically matter for any real-life 
> testing, so you don't really need to worry about it. 
> 
> But I'll forward that patch (and another couple cleanup patch) for you for 
> testing after I've verified it myself. But don't feel like you have to 
> worry about those extra patches - testing the initial refcount handling is 
> the thing that matters most, the thing I have pending really is just 
> details.
> 
> 		Linus
> 

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index be55dfc..1733d34 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -55,25 +55,32 @@ static inline struct tty_ldisc *get_ldisc(struct tty_ldisc *ld)
 	return ld;
 }
 
-static inline void put_ldisc(struct tty_ldisc *ld)
+static void put_ldisc(struct tty_ldisc *ld)
 {
+	unsigned long flags;
+
 	if (WARN_ON_ONCE(!ld))
 		return;
 
 	/*
 	 * If this is the last user, free the ldisc, and
 	 * release the ldisc ops.
+	 *
+	 * We really want an "atomic_dec_and_lock_irqsave()",
+	 * but we don't have it, so this does it by hand.
 	 */
-	if (atomic_dec_and_test(&ld->users)) {
-		unsigned long flags;
+	local_irq_save(flags);
+	if (atomic_dec_and_lock(&ld->users, &tty_ldisc_lock)) {
 		struct tty_ldisc_ops *ldo = ld->ops;
 
-		kfree(ld);
-		spin_lock_irqsave(&tty_ldisc_lock, flags);
 		ldo->refcount--;
 		module_put(ldo->owner);
 		spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+
+		kfree(ld);
+		return;
 	}
+	local_irq_restore(flags);
 }
 
 /**
-- 
1.6.4.21.g73b866

