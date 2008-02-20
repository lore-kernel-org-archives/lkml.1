Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbYBTUzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbYBTUzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYBTUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:55:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36577 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974AbYBTUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:55:26 -0500
Date: Wed, 20 Feb 2008 20:45:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial_core: Prepare for BKL push down
Message-ID: <20080220204558.2b1b09b4@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking for the BKL in these methods, take it ourselves. That
avoids propogating it into the serial drivers and we can then fix them
later on.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/serial/serial_core.c linux-2.6.25-rc2-mm1/drivers/serial/serial_core.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/serial/serial_core.c	2008-02-19 11:03:01.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/serial/serial_core.c	2008-02-20 16:22:49.000000000 +0000
@@ -907,14 +914,14 @@
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->port;
 
-	BUG_ON(!kernel_locked());
-
+	lock_kernel();
 	mutex_lock(&state->mutex);
 
 	if (port->type != PORT_UNKNOWN)
 		port->ops->break_ctl(port, break_state);
 
 	mutex_unlock(&state->mutex);
+	unlock_kernel();
 }
 
 static int uart_do_autoconfig(struct uart_state *state)
@@ -1052,7 +1059,7 @@
 }
 
 /*
- * Called via sys_ioctl under the BKL.  We can use spin_lock_irq() here.
+ * Called via sys_ioctl.  We can use spin_lock_irq() here.
  */
 static int
 uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
@@ -1062,8 +1069,8 @@
 	void __user *uarg = (void __user *)arg;
 	int ret = -ENOIOCTLCMD;
 
-	BUG_ON(!kernel_locked());
 
+	lock_kernel();
 	/*
 	 * These ioctls don't rely on the hardware to be present.
 	 */
@@ -1136,6 +1143,7 @@
  out_up:
 	mutex_unlock(&state->mutex);
  out:
+	unlock_kernel();
 	return ret;
 }
 
@@ -1146,7 +1154,6 @@
 	unsigned long flags;
 	unsigned int cflag = tty->termios->c_cflag;
 
-	BUG_ON(!kernel_locked());
 
 	/*
 	 * These are the bits that are used to setup various
@@ -1158,9 +1165,11 @@
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
 	    tty->termios->c_ospeed == old_termios->c_ospeed &&
 	    tty->termios->c_ispeed == old_termios->c_ispeed &&
-	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
+	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0) {
 		return;
+	}
 
+	lock_kernel();
 	uart_change_speed(state, old_termios);
 
 	/* Handle transition to B0 status */
@@ -1193,7 +1202,7 @@
 		}
 		spin_unlock_irqrestore(&state->port->lock, flags);
 	}
-
+	unlock_kernel();
 #if 0
 	/*
 	 * No need to wake up processes in open wait, since they
