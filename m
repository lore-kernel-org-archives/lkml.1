Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbYJMJnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbYJMJnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760679AbYJMJgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:36:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48624 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760666AbYJMJgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:36:43 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 30/80] tty: move tioclinux from a special case
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:36:40 +0100
Message-ID: <20081013093636.21645.73358.stgit@localhost.localdomain>
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

Right now we have ifdefs and hooks in the core ioctl handler for TIOCLINUX
and then test if its a console. This is brain dead. Instead call the
tioclinux helper from the relevant driver ioctl methods.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c   |    4 ----
 drivers/char/vt.c       |    2 --
 drivers/char/vt_ioctl.c |    2 ++
 3 files changed, 2 insertions(+), 6 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e4dce87..2f05728 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3026,10 +3026,6 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return put_user(tty->ldisc.ops->num, (int __user *)p);
 	case TIOCSETD:
 		return tiocsetd(tty, p);
-#ifdef CONFIG_VT
-	case TIOCLINUX:
-		return tioclinux(tty, arg);
-#endif
 	/*
 	 * Break handling
 	 */
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 60359c3..05ca1c5 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2583,8 +2583,6 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 	int lines;
 	int ret;
 
-	if (tty->driver->type != TTY_DRIVER_TYPE_CONSOLE)
-		return -EINVAL;
 	if (current->signal->tty != tty && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (get_user(type, p))
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c904e9a..8944ce5 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -395,6 +395,8 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
  
 	kbd = kbd_table + console;
 	switch (cmd) {
+	case TIOCLINUX:
+		return tioclinux(tty, arg);
 	case KIOCSOUND:
 		if (!perm)
 			goto eperm;

