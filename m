Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYJEQQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYJEQQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYJEQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:10:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48480 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757028AbYJEQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:10:07 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 34/76] tty: Termios locking - sort out real_tty confusions and
	lock reads
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:10:06 +0100
Message-ID: <20081005160955.1997.85473.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves us towards sanity and should mean our termios locking is now
complete and comprehensive.
---

 drivers/char/tty_io.c    |    2 +-
 drivers/char/tty_ioctl.c |   58 ++++++++++++++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index fa162c9..ac53d7f 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2605,7 +2605,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case TIOCSTI:
 		return tiocsti(tty, p);
 	case TIOCGWINSZ:
-		return tiocgwinsz(tty, p);
+		return tiocgwinsz(real_tty, p);
 	case TIOCSWINSZ:
 		return tiocswinsz(tty, real_tty, p);
 	case TIOCCONS:
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 93bfa1d..3067085 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -893,6 +893,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 {
 	struct tty_struct *real_tty;
 	void __user *p = (void __user *)arg;
+	int ret = 0;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -928,18 +929,24 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		return set_termios(real_tty, p, TERMIOS_OLD);
 #ifndef TCGETS2
 	case TCGETS:
+		mutex_lock(&real_tty->termios_mutex);
 		if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 #else
 	case TCGETS:
+		mutex_lock(&real_tty->termios_mutex);
 		if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 	case TCGETS2:
+		mutex_lock(&real_tty->termios_mutex);
 		if (kernel_termios_to_user_termios((struct termios2 __user *)arg, real_tty->termios))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 	case TCSETSF2:
 		return set_termios(real_tty, p,  TERMIOS_FLUSH | TERMIOS_WAIT);
 	case TCSETSW2:
@@ -957,36 +964,46 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		return set_termios(real_tty, p, TERMIOS_TERMIO);
 #ifndef TCGETS2
 	case TIOCGLCKTRMIOS:
+		mutex_lock(&real_tty->termios_mutex);
 		if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 	case TIOCSLCKTRMIOS:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
+		mutex_lock(&real_tty->termios_mutex);
 		if (user_termios_to_kernel_termios(real_tty->termios_locked,
 					       (struct termios __user *) arg))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 #else
 	case TIOCGLCKTRMIOS:
+		mutex_lock(&real_tty->termios_mutex);
 		if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 	case TIOCSLCKTRMIOS:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
+			ret = -EPERM;
+		mutex_lock(&real_tty->termios_mutex);
 		if (user_termios_to_kernel_termios_1(real_tty->termios_locked,
 					       (struct termios __user *) arg))
-			return -EFAULT;
-			return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 #endif
 #ifdef TCGETX
 	case TCGETX:
 		if (real_tty->termiox == NULL)
 			return -EINVAL;
+		mutex_lock(&real_tty->termios_mutex);
 		if (copy_to_user(p, real_tty->termiox, sizeof(struct termiox)))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 	case TCSETX:
 		return set_termiox(real_tty, p, 0);
 	case TCSETXW:
@@ -995,10 +1012,11 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 		return set_termiox(real_tty, p, TERMIOS_FLUSH);
 #endif		
 	case TIOCGSOFTCAR:
-		/* FIXME: for correctness we may need to take the termios
-		   lock here - review */
-		return put_user(C_CLOCAL(real_tty) ? 1 : 0,
+		mutex_lock(&real_tty->termios_mutex);
+		ret = put_user(C_CLOCAL(real_tty) ? 1 : 0,
 						(int __user *)arg);
+		mutex_unlock(&real_tty->termios_mutex);
+		return ret;
 	case TIOCSSOFTCAR:
 		if (get_user(arg, (unsigned int __user *) arg))
 			return -EFAULT;

