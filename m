Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbXGCO3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbXGCO3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXGCO3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:29:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45974 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755233AbXGCO3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:29:31 -0400
Date: Tue, 3 Jul 2007 15:35:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] mos7840.c: Turn this into a serial driver
Message-ID: <20070703153536.07d9d27f@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The MOS driver is "interesting", in a bad kind of 'how the hell did this
get merged' kind of way

- Remove the bogus termios change check
- Remove the duplicate code for half the ioctls
- Remove the supporting code to duplicate the ioctl code

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/mos7840.c linux-2.6.22-rc6-mm1/drivers/usb/serial/mos7840.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/mos7840.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/mos7840.c	2007-07-02 21:25:13.000000000 +0100
@@ -2189,16 +2189,6 @@
 		return;
 	}
 
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag) &&
-		    (RELEVANT_IFLAG(tty->termios->c_iflag) ==
-		     RELEVANT_IFLAG(old_termios->c_iflag))) {
-			dbg("%s\n", "Nothing to change");
-			return;
-		}
-	}
-
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__,
 	    tty->termios->c_cflag, RELEVANT_IFLAG(tty->termios->c_iflag));
 
@@ -2258,30 +2248,6 @@
 }
 
 /*****************************************************************************
- * mos7840_get_bytes_avail - get number of bytes available
- *
- * Purpose: Let user call ioctl to get the count of number of bytes available.
- *****************************************************************************/
-
-static int mos7840_get_bytes_avail(struct moschip_port *mos7840_port,
-				   unsigned int __user *value)
-{
-	unsigned int result = 0;
-	struct tty_struct *tty = mos7840_port->port->tty;
-
-	if (!tty)
-		return -ENOIOCTLCMD;
-
-	result = tty->read_cnt;
-
-	dbg("%s(%d) = %d", __FUNCTION__, mos7840_port->port->number, result);
-	if (copy_to_user(value, &result, sizeof(int)))
-		return -EFAULT;
-
-	return -ENOIOCTLCMD;
-}
-
-/*****************************************************************************
  * mos7840_set_modem_info
  *      function to set modem info
  *****************************************************************************/
@@ -2429,8 +2395,6 @@
 	struct async_icount cprev;
 	struct serial_icounter_struct icount;
 	int mosret = 0;
-	int retval;
-	struct tty_ldisc *ld;
 
 	if (mos7840_port_paranoia_check(port, __FUNCTION__)) {
 		dbg("%s", "Invalid port \n");
@@ -2449,42 +2413,6 @@
 	switch (cmd) {
 		/* return number of bytes available */
 
-	case TIOCINQ:
-		dbg("%s (%d) TIOCINQ", __FUNCTION__, port->number);
-		return mos7840_get_bytes_avail(mos7840_port, argp);
-
-	case TIOCOUTQ:
-		dbg("%s (%d) TIOCOUTQ", __FUNCTION__, port->number);
-		return put_user(tty->driver->chars_in_buffer ?
-				tty->driver->chars_in_buffer(tty) : 0,
-				(int __user *)arg);
-
-	case TCFLSH:
-		retval = tty_check_change(tty);
-		if (retval)
-			return retval;
-
-		ld = tty_ldisc_ref(tty);
-		switch (arg) {
-		case TCIFLUSH:
-			if (ld && ld->flush_buffer)
-				ld->flush_buffer(tty);
-			break;
-		case TCIOFLUSH:
-			if (ld && ld->flush_buffer)
-				ld->flush_buffer(tty);
-			/* fall through */
-		case TCOFLUSH:
-			if (tty->driver->flush_buffer)
-				tty->driver->flush_buffer(tty);
-			break;
-		default:
-			tty_ldisc_deref(ld);
-			return -EINVAL;
-		}
-		tty_ldisc_deref(ld);
-		return 0;
-
 	case TIOCSERGETLSR:
 		dbg("%s (%d) TIOCSERGETLSR", __FUNCTION__, port->number);
 		return mos7840_get_lsr_info(mos7840_port, argp);
