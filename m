Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXITOfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXITOfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbXITOfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:35:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57088 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbXITOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:35:12 -0400
Date: Thu, 20 Sep 2007 15:42:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: expose new methods needed for drivers to get termios
 right
Message-ID: <20070920154222.75534bd5@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds three new functions (or in one case to be more exact makes it
always available)

tty_termios_copy_hw

Copies all the hardware settings from one termios structure to the other.
This is intended for drivers that support little or no hardware setting


tty_termios_encode_baud_rate

Allows you to set the input and output baud rate in a termios structure.
A driver is supposed to set the resulting baud rate from a request so
most will want to use this function to set the resulting input and output
rates to match the hardware values. Internally it knows about keeping
Bxxx encoding when possible to maximise compatibility.


tty_encode_baud_rate

As above but for the tty's own current termios structure


I suspect this will initially need some tweaking as it gets enabled by
driver patches over the next few mm cycles so consider this lot -mm only
for the moment so it can stabilize and end up neat before it goes to base.

I've tried not to break any obscure architectures - if you get a speed
you can't represent the code will print warnings on non updated termios
systems but not break.

Once this is merged and seems sane I've got a growing pile of driver
updates to use it - notably for USB serial drivers.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/include/linux/tty.h linux-2.6.23rc6-mm1/include/linux/tty.h
--- linux.vanilla-2.6.23rc6-mm1/include/linux/tty.h	2007-09-18 15:33:00.000000000 +0100
+++ linux-2.6.23rc6-mm1/include/linux/tty.h	2007-09-18 16:39:18.000000000 +0100
@@ -316,6 +309,9 @@
 extern speed_t tty_get_baud_rate(struct tty_struct *tty);
 extern speed_t tty_termios_baud_rate(struct ktermios *termios);
 extern speed_t tty_termios_input_baud_rate(struct ktermios *termios);
+extern void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud);
+extern void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud);
+extern void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/drivers/char/tty_ioctl.c linux-2.6.23rc6-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.23rc6-mm1/drivers/char/tty_ioctl.c	2007-09-18 15:32:51.000000000 +0100
+++ linux-2.6.23rc6-mm1/drivers/char/tty_ioctl.c	2007-09-18 16:49:14.000000000 +0100
@@ -206,8 +206,6 @@
 
 EXPORT_SYMBOL(tty_termios_input_baud_rate);
 
-#ifdef BOTHER
-
 /**
  *	tty_termios_encode_baud_rate
  *	@termios: ktermios structure holding user requested state
@@ -225,6 +223,9 @@
  *
  *	Locking: Caller should hold termios lock. This is already held
  *	when calling this function from the driver termios handler.
+ *
+ *	The ifdefs deal with platforms whose owners have yet to update them
+ *	and will all go away once this is done.
  */
 
 void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud)
@@ -233,10 +234,14 @@
 	int ifound = -1, ofound = -1;
 	int iclose = ibaud/50, oclose = obaud/50;
 	int ibinput = 0;
+	
+	if (obaud == 0)			/* CD dropped 		  */
+		ibaud = 0;		/* Clear ibaud to be sure */
 
 	termios->c_ispeed = ibaud;
 	termios->c_ospeed = obaud;
 
+#ifdef BOTHER
 	/* If the user asked for a precise weird speed give a precise weird
 	   answer. If they asked for a Bfoo speed they many have problems
 	   digesting non-exact replies so fuzz a bit */
@@ -247,8 +252,15 @@
 		iclose = 0;
 	if ((termios->c_cflag >> IBSHIFT) & CBAUD)
 		ibinput = 1;	/* An input speed was specified */
-
+#endif
 	termios->c_cflag &= ~CBAUD;
+	
+	/*
+	 *	Our goal is to find a close match to the standard baud rate
+	 *	returned. Walk the baud rate table and if we get a very close
+	 *	match then report back the speed as a POSIX Bxxxx value by
+	 *	preference
+	 */
 
 	do {
 		if (obaud - oclose >= baud_table[i] && obaud + oclose <= baud_table[i]) {
@@ -256,23 +268,45 @@
 			ofound = i;
 		}
 		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
-			/* For the case input == output don't set IBAUD bits if the user didn't do so */
-			if (ofound != i || ibinput)
+			if (ofound == i && !ibinput)
+				ifound  = i;
+#ifdef IBSHIFT				
+			else {
+				ifound = i;
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
-			ifound = i;
+			}
+#endif			
 		}
 	} while (++i < n_baud_table);
+	
+	/*
+	 *	If we found no match then use BOTHER if provided or warn
+	 *	the user their platform maintainer needs to wake up if not.
+	 */
+#ifdef BOTHER
 	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
 	/* Set exact input bits only if the input and output differ or the
 	   user already did */
 	if (ifound == -1 && (ibaud != obaud || ibinput))
 		termios->c_cflag |= (BOTHER << IBSHIFT);
+#else
+	if (ifound == -1 || ofound == -1) {
+		static int warned = 0;
+		if (!warned++)
+			printk(KERN_WARNING "tty: Unable to return correct speed data as your architecture needs updating.\n");
+	}
+#endif			
 }
 
 EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
 
-#endif
+void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud)
+{
+	tty_termios_encode_baud_rate(tty->termios, ibaud, obaud);
+}
+
+EXPORT_SYMBOL_GPL(tty_encode_baud_rate);
 
 /**
  *	tty_get_baud_rate	-	get tty bit rates
@@ -304,6 +338,29 @@
 EXPORT_SYMBOL(tty_get_baud_rate);
 
 /**
+ *	tty_termios_copy_hw	-	copy hardware settings
+ *	@new: New termios
+ *	@old: Old termios
+ *
+ *	Propogate the hardware specific terminal setting bits from
+ *	the old termios structure to the new one. This is used in cases
+ *	where the hardware does not support reconfiguration or as a helper
+ *	in some cases where only minimal reconfiguration is supported
+ */
+
+void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old)
+{
+	/* The bits a dumb device handles in software. Smart devices need
+	   to always provide a set_termios method */
+	new->c_cflag &= HUPCL | CREAD | CLOCAL;
+	new->c_cflag |= old->c_cflag & ~(HUPCL | CREAD | CLOCAL);
+	new->c_ispeed = old->c_ispeed;
+	new->c_ospeed = old->c_ospeed;
+}	
+	
+EXPORT_SYMBOL(tty_termios_copy_hw);
+
+/**
  *	change_termios		-	update termios values
  *	@tty: tty to update
  *	@new_termios: desired new value
@@ -340,13 +397,12 @@
 		tty->erasing = 0;
 	}
 	
-	
+	/* This bit should be in the ldisc code */
 	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
 		/* Get characters left over from canonical mode. */
 		wake_up_interruptible(&tty->read_wait);
 
 	/* See if packet mode change of state. */
-
 	if (tty->link && tty->link->packet) {
 		int old_flow = ((old_termios.c_iflag & IXON) &&
 				(old_termios.c_cc[VSTOP] == '\023') &&
@@ -366,6 +422,8 @@
 	   
 	if (tty->driver->set_termios)
 		(*tty->driver->set_termios)(tty, &old_termios);
+	else
+		tty_termios_copy_hw(tty->termios, &old_termios);
 
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
@@ -440,6 +498,11 @@
 	}
 
 	change_termios(tty, &tmp_termios);
+	
+	/* FIXME: Arguably if tmp_termios == tty->termios AND the
+	   actual requested termios was not tmp_termios then we may
+	   want to return an error as no user requested change has
+	   succeeded */
 	return 0;
 }
 
