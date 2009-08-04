Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbZHDVKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbZHDVKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbZHDVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:10:34 -0400
Received: from kroah.org ([198.145.64.141]:46665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830AbZHDVKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:10:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] tty-ldisc: be more careful in 'put_ldisc' locking
Date: Tue,  4 Aug 2009 14:09:15 -0700
Message-Id: <1249420155-26210-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <20090804210829.GA26166@kroah.com>
References: <20090804210829.GA26166@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Use 'atomic_dec_and_lock()' to make sure that we always hold the
tty_ldisc_lock when the ldisc count goes to zero. That way we can never
race against 'tty_ldisc_try()' increasing the count again.

Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

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
1.6.3.2

