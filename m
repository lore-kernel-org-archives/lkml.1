Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYJEQQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYJEQQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290AbYJEQJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:09:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48476 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756533AbYJEQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:09:33 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 32/76] tty: ipw need reworking
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:09:33 +0100
Message-ID: <20081005160921.1997.97571.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This came in via another tree and unfortunately is rather broken on
the tty side. Comment the apparent locking problems for someone who knows
the driver to look at.

Fix the termios and other ioctl handling. The driver was calling the wrong
methods for what it wanted to do but the right ones existed so its a simple
fix up.
---

 drivers/char/pcmcia/ipwireless/tty.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
index 3a23e76..569f2f7 100644
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -276,6 +276,7 @@ static int ipw_write_room(struct tty_struct *linux_tty)
 	struct ipw_tty *tty = linux_tty->driver_data;
 	int room;
 
+	/* FIXME: Exactly how is the tty object locked here .. */
 	if (!tty)
 		return -ENODEV;
 
@@ -397,6 +398,7 @@ static int set_control_lines(struct ipw_tty *tty, unsigned int set,
 static int ipw_tiocmget(struct tty_struct *linux_tty, struct file *file)
 {
 	struct ipw_tty *tty = linux_tty->driver_data;
+	/* FIXME: Exactly how is the tty object locked here .. */
 
 	if (!tty)
 		return -ENODEV;
@@ -412,6 +414,7 @@ ipw_tiocmset(struct tty_struct *linux_tty, struct file *file,
 	     unsigned int set, unsigned int clear)
 {
 	struct ipw_tty *tty = linux_tty->driver_data;
+	/* FIXME: Exactly how is the tty object locked here .. */
 
 	if (!tty)
 		return -ENODEV;
@@ -433,6 +436,8 @@ static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
 	if (!tty->open_count)
 		return -EINVAL;
 
+	/* FIXME: Exactly how is the tty object locked here .. */
+
 	switch (cmd) {
 	case TIOCGSERIAL:
 		return ipwireless_get_serial_info(tty, (void __user *) arg);
@@ -467,13 +472,6 @@ static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
 			}
 			return 0;
 
-		case TCGETS:
-		case TCGETA:
-			return n_tty_ioctl(linux_tty, file, cmd, arg);
-
-		case TCFLSH:
-			return n_tty_ioctl(linux_tty, file, cmd, arg);
-
 		case FIONREAD:
 			{
 				int val = 0;
@@ -482,10 +480,11 @@ static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
 					return -EFAULT;
 			}
 			return 0;
+		case TCFLSH:
+			return tty_perform_flush(linux_tty, arg);
 		}
 	}
-
-	return -ENOIOCTLCMD;
+	return tty_mode_ioctl(linux_tty, file, cmd , arg);
 }
 
 static int add_tty(dev_node_t *nodesp, int j,
@@ -588,6 +587,8 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 				tty_hangup(ttyj->linux_tty);
 				/* Wait till the tty_hangup has completed */
 				flush_scheduled_work();
+				/* FIXME: Exactly how is the tty object locked here
+				   against a parallel ioctl etc */
 				mutex_lock(&ttyj->ipw_tty_mutex);
 			}
 			while (ttyj->open_count)

