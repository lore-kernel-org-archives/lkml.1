Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbXGCOOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbXGCOOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXGCOOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:14:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57134 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755359AbXGCOOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:14:35 -0400
Date: Tue, 3 Jul 2007 15:20:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] genericserial: Remove bogus optimisation check and dead
 code paths
Message-ID: <20070703152021.6eb8013d@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've been using the 'new locking' for a long time now so it seems
pointless keeping the old one around. Remove it and undo the macros it
uses back into real code for readability. Remove the bogus 'no termios
change' checks.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/char/generic_serial.c linux-2.6.22-rc6-mm1/drivers/char/generic_serial.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/char/generic_serial.c	2007-07-02 20:47:23.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/char/generic_serial.c	2007-07-02 21:05:53.000000000 +0100
@@ -43,16 +43,6 @@
 
 #define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __FUNCTION__)
 #define func_exit()  gs_dprintk (GS_DEBUG_FLOW, "gs: exit  %s\n", __FUNCTION__)
-#define NEW_WRITE_LOCKING 1
-#if NEW_WRITE_LOCKING
-#define DECL      /* Nothing */
-#define LOCKIT    mutex_lock(& port->port_write_mutex);
-#define RELEASEIT mutex_unlock(&port->port_write_mutex);
-#else
-#define DECL      unsigned long flags;
-#define LOCKIT    save_flags (flags);cli ()
-#define RELEASEIT restore_flags (flags)
-#endif
 
 #define RS_EVENT_WRITE_WAKEUP	1
 
@@ -62,7 +52,6 @@
 void gs_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct gs_port *port;
-	DECL
 
 	func_enter (); 
 
@@ -75,11 +64,11 @@
 	if (! (port->flags & ASYNC_INITIALIZED)) return;
 
 	/* Take a lock on the serial tranmit buffer! */
-	LOCKIT;
+	mutex_lock(& port->port_write_mutex);
 
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
-		RELEASEIT;
+		mutex_unlock(&port->port_write_mutex);
 		return;
 	}
 
@@ -87,13 +76,11 @@
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;  /* Characters in buffer */
 
-	RELEASEIT;
+	mutex_unlock(&port->port_write_mutex);
 	func_exit ();
 }
 
 
-#ifdef NEW_WRITE_LOCKING
-
 /*
 > Problems to take into account are:
 >       -1- Interrupts that empty part of the buffer.
@@ -166,90 +153,6 @@
 	func_exit ();
 	return total;
 }
-#else
-/*
-> Problems to take into account are:
->       -1- Interrupts that empty part of the buffer.
->       -2- page faults on the access to userspace. 
->       -3- Other processes that are also trying to do a "write". 
-*/
-
-int gs_write(struct tty_struct * tty,
-                    const unsigned char *buf, int count)
-{
-	struct gs_port *port;
-	int c, total = 0;
-	int t;
-	unsigned long flags;
-
-	func_enter ();
-
-	/* The standard serial driver returns 0 in this case. 
-	   That sounds to me as "No error, I just didn't get to writing any
-	   bytes. Feel free to try again." 
-	   The "official" way to write n bytes from buf is:
-
-		 for (nwritten = 0;nwritten < n;nwritten += rv) {
-			 rv = write (fd, buf+nwritten, n-nwritten);
-			 if (rv < 0) break; // Error: bail out. //
-		 } 
-
-	   which will loop endlessly in this case. The manual page for write
-	   agrees with me. In practise almost everybody writes 
-	   "write (fd, buf,n);" but some people might have had to deal with 
-	   incomplete writes in the past and correctly implemented it by now... 
-	 */
-
-	if (!tty) return -EIO;
-
-	port = tty->driver_data;
-	if (!port || !port->xmit_buf)
-		return -EIO;
-
-	local_save_flags(flags);
-	while (1) {
-		cli();
-		c = count;
-
-		/* This is safe because we "OWN" the "head". Noone else can 
-		   change the "head": we own the port_write_mutex. */
-		/* Don't overrun the end of the buffer */
-		t = SERIAL_XMIT_SIZE - port->xmit_head;
-		if (t < c) c = t;
-
-		/* This is safe because the xmit_cnt can only decrease. This 
-		   would increase "t", so we might copy too little chars. */
-		/* Don't copy past the "head" of the buffer */
-		t = SERIAL_XMIT_SIZE - 1 - port->xmit_cnt;
-		if (t < c) c = t;
-
-		/* Can't copy more? break out! */
-		if (c <= 0) {
-			local_restore_flags(flags);
-			break;
-		}
-		memcpy(port->xmit_buf + port->xmit_head, buf, c);
-		port->xmit_head = ((port->xmit_head + c) &
-		                   (SERIAL_XMIT_SIZE-1));
-		port->xmit_cnt += c;
-		local_restore_flags(flags);
-		buf += c;
-		count -= c;
-		total += c;
-	}
-
-	if (port->xmit_cnt && 
-	    !tty->stopped && 
-	    !tty->hw_stopped &&
-	    !(port->flags & GS_TX_INTEN)) {
-		port->flags |= GS_TX_INTEN;
-		port->rd->enable_tx_interrupts (port);
-	}
-	func_exit ();
-	return total;
-}
-
-#endif
 
 
 
@@ -737,23 +640,6 @@
 		gs_dprintk (GS_DEBUG_TERMIOS, "termios structure (%p):\n", tiosp);
 	}
 
-	/* This is an optimization that is only allowed for dumb cards */
-	/* Smart cards require knowledge of iflags and oflags too: that 
-	   might change hardware cooking mode.... */
-	if (old_termios) {
-		if(   (tiosp->c_iflag == old_termios->c_iflag)
-		   && (tiosp->c_oflag == old_termios->c_oflag)
-		   && (tiosp->c_cflag == old_termios->c_cflag)
-		   && (tiosp->c_lflag == old_termios->c_lflag)
-		   && (tiosp->c_line  == old_termios->c_line)
-		   && (memcmp(tiosp->c_cc, old_termios->c_cc, NCC) == 0)) {
-			gs_dprintk(GS_DEBUG_TERMIOS, "gs_set_termios: optimized away\n");
-			return /* 0 */;
-		}
-	} else 
-		gs_dprintk(GS_DEBUG_TERMIOS, "gs_set_termios: no old_termios: "
-		           "no optimization\n");
-
 	if(old_termios && (gs_debug & GS_DEBUG_TERMIOS)) {
 		if(tiosp->c_iflag != old_termios->c_iflag)  printk("c_iflag changed\n");
 		if(tiosp->c_oflag != old_termios->c_oflag)  printk("c_oflag changed\n");
