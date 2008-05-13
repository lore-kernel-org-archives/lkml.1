Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbYEMWi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbYEMWi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYEMWil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:38:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57978 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848AbYEMWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:38:39 -0400
Date: Tue, 13 May 2008 23:27:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org,
       Andrew Bird <ajb@spheresystems.co.uk>,
       Javier Marcet <javier@krausbeck.org>, Filip Aben <f.aben@option.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSO: add option hso driver
Message-ID: <20080513232727.21c74bb2@core>
In-Reply-To: <20080513215134.GC6139@kroah.com>
References: <20080513215134.GC6139@kroah.com>
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

> Jeff, please queue this up for 2.6.27 if there are no problems that you
> can see.  It has been in the linux-next tree for a while, and many users
> are reporting that it is working for them.
> 
> Or if you feel it's ok for 2.6.26, I will not object to that either :)

Can we get it into 2.6.26 - its a driver for new hardware and the driver
is going to get a clean up for 2.6.27 anyway.

Comments below are minor and I don't think blockers

So for the serial side

Acked-by: Alan Cox <alan@redhat.com>


> +	termios = serial->tty->termios;

tty is passed why keep using serial->tty (hint: think about parallel
hangup versus close/open)

> +/* close the requested serial port */
> +static void hso_serial_close(struct tty_struct *tty, struct file *filp)
> +{
> +	struct hso_serial *serial = tty->driver_data;
> +	u8 usb_gone;
> +
> +	D1("Closing serial port");
> +
> +	/* sanity check */
> +	if (tty == NULL || serial == NULL) {
> +		D1("(tty == NULL || tty->driver_data == NULL)");
> +		return;
> +	}

tty cannot be NULL here


> +static int hso_serial_write(struct tty_struct *tty, const unsigned char *buf,
> +			    int count)
> +{
> +	struct hso_serial *serial = get_serial_by_tty(tty);
> +	int space, tx_bytes;
> +	unsigned long flags;
> +
> +	/* sanity check */
> +	if (serial == NULL) {
> +		printk(KERN_ERR "%s: tty or tty->driver_data is NULL\n",

Checks one thing printks another 8)

> +	/* the actual setup */
> +	spin_lock_irqsave(&serial->serial_lock, flags);
> +	if (serial->open_count)
> +		_hso_serial_set_termios(tty, old);

(else *tty->termios = *old_termios)


