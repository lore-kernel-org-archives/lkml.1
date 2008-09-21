Return-Path: <linux-kernel-owner+w=401wt.eu-S1752339AbYIUOOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbYIUOOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYIUOOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:14:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60724 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751539AbYIUOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:14:16 -0400
Date: Sun, 21 Sep 2008 15:14:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tollef Fog Heen <tfheen@err.no>
Cc: linux-kernel@vger.kernel.org, werner@cornelius-consult.de,
       frank@kingswood-consulting.co.uk
Subject: Re: [PATCH] Winchiphead 340/1: full baud rate and status/control
 line support
Message-ID: <20080921151407.10c89452@lxorguk.ukuu.org.uk>
In-Reply-To: <87ej3d4zv3.fsf_-_@xoog.err.no>
References: <200807290254.m6T2sIBG010575@imap1.linux-foundation.org>
	<20080729104331.367fde6b@lxorguk.ukuu.org.uk>
	<87ej3d4zv3.fsf_-_@xoog.err.no>
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

Some niggles but this is a big improvement to the code.


>  static int ch341_set_baudrate(struct usb_device *dev,
> +			      struct tty_struct *tty,
>  			      struct ch341_private *priv)
> +	baud = CH341_BAUDBASE_FACTOR / t1;
> +
> +	if (baud && tty)
> +		tty_encode_baud_rate(tty, baud, baud);

Can you really get a speed below 1 baud ?

If there is a hangup requested (c_cflag & CBAUD) == B0 then you don't
want to overwrite the baud rate but that you handled in set_termios
already.


> +static void ch341_close(struct tty_struct *tty, struct usb_serial_port *port,
> +			struct file *filp)
> +{
> +	struct ch341_private *priv = usb_get_serial_port_data(port);
> +	unsigned long flags;
> +
> +	dbg("%s - port %d", __func__, port->number);
> +
> +	/* shutdown our urbs */
> +	dbg("%s - shutting down urbs", __func__);
> +	usb_kill_urb(port->write_urb);
> +	usb_kill_urb(port->read_urb);
> +	usb_kill_urb(port->interrupt_in_urb);
> +
> +	if (tty) {

close should never be called with tty == NULL unless there is some kind
of internal abuse of it - is the tty check really needed ?

> @@ -242,21 +320,34 @@ static int ch341_open(struct tty_struct *tty, struct usb_serial_port *port,
>  	dbg("ch341_open()");
>  
>  	priv->baud_rate = DEFAULT_BAUD_RATE;
> -	priv->dtr = 1;
> -	priv->rts = 1;
> +
> +	if (C_CLOCAL(tty))

Open on the other hand is currently called with tty = NULL in the case it
is used as a console device (ugly and something I want to fix but it
happens for now)

> @@ -270,38 +361,207 @@ static void ch341_set_termios(struct tty_struct *tty,
>  {
>  	struct ch341_private *priv = usb_get_serial_port_data(port);
>  	unsigned baud_rate;
> +	unsigned long flags;
>  
>  	dbg("ch341_set_termios()");
>  
> +	if (!tty)
> +		return;
> +

set_termios should never be called with tty == NULL nowdays so that test
should be removable.


> +	control = priv->line_control;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return ch341_set_handshake(port->serial->dev, control);
> +}

This could race another set_handshake ? I'm not sure it matters and I'd
suggest that stuff gets fixed after this is submitted separately



