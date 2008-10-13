Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbYJMKI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbYJMKI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbYJMJqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:46:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32929 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932082AbYJMJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:46:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 79/80] fs3270: Correct error returns
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:46:09 +0100
Message-ID: <20081013094557.21645.65340.stgit@localhost.localdomain>
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

Drop the kernel lock further and also correct cases where we set rc to an
error code, and then return 0

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/s390/char/fs3270.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 1227f45..40759c3 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -418,23 +418,22 @@ fs3270_open(struct inode *inode, struct file *filp)
 {
 	struct fs3270 *fp;
 	struct idal_buffer *ib;
-	int minor, rc;
+	int minor, rc = 0;
 
 	if (imajor(filp->f_path.dentry->d_inode) != IBM_FS3270_MAJOR)
 		return -ENODEV;
-	lock_kernel();
 	minor = iminor(filp->f_path.dentry->d_inode);
 	/* Check for minor 0 multiplexer. */
 	if (minor == 0) {
 		struct tty_struct *tty = get_current_tty();
 		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
 			tty_kref_put(tty);
-			rc = -ENODEV;
-			goto out;
+			return -ENODEV;
 		}
 		minor = tty->index + RAW3270_FIRSTMINOR;
 		tty_kref_put(tty);
 	}
+	lock_kernel();
 	/* Check if some other program is already using fullscreen mode. */
 	fp = (struct fs3270 *) raw3270_find_view(&fs3270_fn, minor);
 	if (!IS_ERR(fp)) {
@@ -476,7 +475,7 @@ fs3270_open(struct inode *inode, struct file *filp)
 	filp->private_data = fp;
 out:
 	unlock_kernel();
-	return 0;
+	return rc;
 }
 
 /*

