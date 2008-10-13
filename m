Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYJMKIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYJMKIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762105AbYJMJqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:46:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51052 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763301AbYJMJp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:45:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 78/80] fs3270: remove extra locks
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:45:52 +0100
Message-ID: <20081013094542.21645.48171.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

get_current_tty now does internal locking and returns a referenced object,
thus our use of tty_mutex here can go away.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/s390/char/fs3270.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)


diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 84fbc90..1227f45 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -426,18 +426,14 @@ fs3270_open(struct inode *inode, struct file *filp)
 	minor = iminor(filp->f_path.dentry->d_inode);
 	/* Check for minor 0 multiplexer. */
 	if (minor == 0) {
-		struct tty_struct *tty;
-		mutex_lock(&tty_mutex);
-		tty = get_current_tty();
+		struct tty_struct *tty = get_current_tty();
 		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
 			tty_kref_put(tty);
-			mutex_unlock(&tty_mutex);
 			rc = -ENODEV;
 			goto out;
 		}
 		minor = tty->index + RAW3270_FIRSTMINOR;
 		tty_kref_put(tty);
-		mutex_unlock(&tty_mutex);
 	}
 	/* Check if some other program is already using fullscreen mode. */
 	fp = (struct fs3270 *) raw3270_find_view(&fs3270_fn, minor);

