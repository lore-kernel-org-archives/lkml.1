Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbYHZTKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbYHZTKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYHZTK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:10:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33071 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757591AbYHZTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:10:27 -0400
Date: Tue, 26 Aug 2008 19:52:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tty: TIOCGSOFTCAR/SSOFTCAR on pty is wron
Message-ID: <20080826195247.55a91d76@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The termios settings ioctls on a pty should affect the bound tty side not
the pty. The SOFTCAR ioctls use the wrong device file.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_ioctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index ea9fc5d..bf34e45 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -937,12 +937,14 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			return 0;
 #endif
 	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0,
+		/* FIXME: for correctness we may need to take the termios
+		   lock here - review */
+		return put_user(C_CLOCAL(real_tty) ? 1 : 0,
 						(int __user *)arg);
 	case TIOCSSOFTCAR:
 		if (get_user(arg, (unsigned int __user *) arg))
 			return -EFAULT;
-		return tty_change_softcar(tty, arg);
+		return tty_change_softcar(real_tty, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
