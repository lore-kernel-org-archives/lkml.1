Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbZFLK2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbZFLK2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760066AbZFLK15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:27:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45603 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZFLK14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:27:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: fix unused warning when TCGETX is not defined
Date: Fri, 12 Jun 2009 06:27:48 -0400
Message-Id: <1244802468-13667-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If TCGETX is not defined, we end up with this warning:
drivers/char/tty_ioctl.c: In function ‘tty_mode_ioctl’:
drivers/char/tty_ioctl.c:950: warning: unused variable ‘ktermx’

Since the variable is only used in one case statement, push it down to
the local case scope.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/char/tty_ioctl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 8116bb1..b24f6c6 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -947,7 +947,6 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 	void __user *p = (void __user *)arg;
 	int ret = 0;
 	struct ktermios kterm;
-	struct termiox ktermx;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -1049,7 +1048,8 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		return ret;
 #endif
 #ifdef TCGETX
-	case TCGETX:
+	case TCGETX: {
+		struct termiox ktermx;
 		if (real_tty->termiox == NULL)
 			return -EINVAL;
 		mutex_lock(&real_tty->termios_mutex);
@@ -1058,6 +1058,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		if (copy_to_user(p, &ktermx, sizeof(struct termiox)))
 			ret = -EFAULT;
 		return ret;
+	}
 	case TCSETX:
 		return set_termiox(real_tty, p, 0);
 	case TCSETXW:
-- 
1.6.3.1

