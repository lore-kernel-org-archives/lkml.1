Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZKROm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZKROm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757529AbZKROm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:42:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36887 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757526AbZKROm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:42:26 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/5] tty: Push the lock down further into the ldisc code
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:26:03 +0000
Message-ID: <20091118142548.3806.34931.stgit@localhost.localdomain>
In-Reply-To: <20091118142313.3806.47368.stgit@localhost.localdomain>
References: <20091118142313.3806.47368.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_io.c    |    2 --
 drivers/char/tty_ldisc.c |   12 +++++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 05e94a2..a1b1ff6 100644
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
+                /* BKL here locks versus a hangup event */
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

