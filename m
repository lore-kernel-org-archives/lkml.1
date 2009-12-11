Return-Path: <linux-kernel-owner+w=401wt.eu-S934647AbZLKXa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbZLKXa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934537AbZLKX3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:50 -0500
Received: from kroah.org ([198.145.64.141]:50543 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933948AbZLKX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/58] tty: Push the lock down further into the ldisc code
Date: Fri, 11 Dec 2009 15:28:39 -0800
Message-Id: <1260574122-10676-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c    |    2 --
 drivers/char/tty_ldisc.c |   12 +++++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 1e24130..c408c81 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1347,9 +1347,7 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	 * If we fail here just call release_tty to clean up.  No need
 	 * to decrement the use counts, as release_tty doesn't care.
 	 */
-	lock_kernel();
 	retval = tty_ldisc_setup(tty, tty->link);
-	unlock_kernel();
 	if (retval)
 		goto release_mem_out;
 	return tty;
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index d914e77..3f653f7 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -445,8 +445,14 @@ static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 {
 	WARN_ON(test_and_set_bit(TTY_LDISC_OPEN, &tty->flags));
-	if (ld->ops->open)
-		return ld->ops->open(tty);
+	if (ld->ops->open) {
+		int ret;
+                /* BKL here locks verus a hangup event */
+		lock_kernel();
+		ret = ld->ops->open(tty);
+		unlock_kernel();
+		return ret;
+	}
 	return 0;
 }
 
@@ -566,6 +572,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		return 0;
 	}
 
+	unlock_kernel();
 	/*
 	 *	Problem: What do we do if this blocks ?
 	 *	We could deadlock here
@@ -573,7 +580,6 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_wait_until_sent(tty, 0);
 
-	unlock_kernel();
 	mutex_lock(&tty->ldisc_mutex);
 
 	/*
-- 
1.6.5.5

