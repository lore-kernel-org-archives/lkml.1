Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbZFPPDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbZFPPDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbZFPPCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:02:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44035 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759385AbZFPPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:02:52 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/9] tty: fix unused warning when TCGETX is not defined
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:01:02 +0100
Message-ID: <20090616160058.10041.12590.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

If TCGETX is not defined, we end up with this warning:
drivers/char/tty_ioctl.c: In function ‘tty_mode_ioctl’:
drivers/char/tty_ioctl.c:950: warning: unused variable ‘ktermx’

Since the variable is only used in one case statement, push it down to
the local case scope.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
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

