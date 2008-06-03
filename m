Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYFCOei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYFCOei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 10:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbYFCOe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 10:34:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54949 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757695AbYFCOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 10:34:27 -0400
Date: Tue, 3 Jun 2008 15:18:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: gyang <graf.yang@analog.com>
Cc: Bryan Wu <cooloney@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org
Subject: [PATCH] serial_core: uart_set_ldisc (Was Re: Blackfin Serial
 Driver: Enable IR function when user application (irattach /dev/ttyBFx -s)
 call TIOCSETD ioctl with line discipline N_IRDA)
Message-ID: <20080603151854.488af929@core>
In-Reply-To: <1212459526.6187.8.camel@dyang>
References: <200804241929.m3OJToSE021045@hera.kernel.org>
	<20080424215004.34517136@the-village.bc.nu>
	<0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
	<20080425105545.77b8c5e8@core>
	<386072610805040827w7a606ee2ld24e6752a6c745c7@mail.gmail.com>
	<20080504165625.083d3d22@core>
	<1212459526.6187.8.camel@dyang>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 10:18:46 +0800
gyang <graf.yang@analog.com> wrote:

> Hi, Alan,
> 
> Have the set_ldisc operator been put into main tree?

It's been in for ages. The Uart level one seems to have gotten stuck. Let
me poke that again
--

The tty layer provides a callback that is used when the line discipline
is changed. Some hardware uses this to configure hardware specific
features such as IrDA mode on serial ports. Unfortunately the serial
layer does not provide this feature or pass it down to drivers.

Blackfin used to hack around this by rewriting the tty ops, but those are
now properly shared and const so the hack fails. Instead provide the
proper operations.

Linus: This change plus a follow up from the Blackfin guys is needed to
avoid blackfin losing features in this release.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.26-rc2/drivers/serial/serial_core.c linux-2.6.26-rc2/drivers/serial/serial_core.c
--- linux.vanilla-2.6.26-rc2/drivers/serial/serial_core.c	2008-05-12 12:09:06.000000000 +0100
+++ linux-2.6.26-rc2/drivers/serial/serial_core.c	2008-06-03 15:09:52.000000000 +0100
@@ -1165,6 +1166,15 @@
 	return ret;
 }
 
+static void uart_set_ldisc(struct tty_struct *tty, int ldisc)
+{
+	struct uart_state *state = tty->driver_data;
+	struct uart_port *port = state->port;
+
+	if (port->ops->set_ldisc)
+		port->ops->set_ldisc(port);
+}
+
 static void uart_set_termios(struct tty_struct *tty,
 						struct ktermios *old_termios)
 {
@@ -2285,6 +2298,7 @@
 	.unthrottle	= uart_unthrottle,
 	.send_xchar	= uart_send_xchar,
 	.set_termios	= uart_set_termios,
+	.set_ldisc	= uart_set_ldisc,
 	.stop		= uart_stop,
 	.start		= uart_start,
 	.hangup		= uart_hangup,
diff -u --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.26-rc2/include/linux/serial_core.h linux-2.6.26-rc2/include/linux/serial_core.h
--- linux.vanilla-2.6.26-rc2/include/linux/serial_core.h	2008-05-12 12:09:08.000000000 +0100
+++ linux-2.6.26-rc2/include/linux/serial_core.h	2008-06-03 15:08:28.000000000 +0100
@@ -192,6 +192,7 @@
 	void		(*shutdown)(struct uart_port *);
 	void		(*set_termios)(struct uart_port *, struct ktermios *new,
 				       struct ktermios *old);
+	void		(*set_ldisc)(struct uart_port *);
 	void		(*pm)(struct uart_port *, unsigned int state,
 			      unsigned int oldstate);
 	int		(*set_wake)(struct uart_port *, unsigned int state);
