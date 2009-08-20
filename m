Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbZHTTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbZHTTgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZHTTgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:36:14 -0400
Received: from ppp-136-40.adsl.restena.lu ([158.64.136.40]:41061 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbZHTTgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:36:11 -0400
Date: Thu, 20 Aug 2009 21:25:49 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090820212549.7b4d93c9@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.0908191834180.26174-100000@iolanthe.rowland.org>
References: <20090819225034.470c52e8@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0908191834180.26174-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 19 Aug 2009, Alan Cox wrote:
> 
> > > So Alan, what's the explanation?  An unsuccessful open method call
> > > should not lead to a close method call.
> > 
> > For tty it always has since back in 0.9x, and most drivers depend
> > upon this behaviour.
> 
> Curiouser and curiouser...
> 
> Okay Bruno, try out this patch and let's see if it helps.  It should 
> fix the problem with the pl2303.  I'm not so sure about the FTDI
> device because that driver maintains its own reference count for its
> private data.
> 
> Alan Stern

No, that one does not really help (well it avoids dereferencing a bad
pointer (NULL for pl2302 or invalid for ftdi) with serial_do_free() after
destroy_serial() but is does underflow module refcount (refcount ends
up at 2^32-1) and lets the kernel stall/panic a short time later without
any useful information at that moment (only very first line of trace
ever appears) [ftdi for the panic/freeze].

So I would say at best it's just a step towards the solution...
there are still unbalanced operations left (module refcount being the
visible one, then probably the already mentioned private book-keeping
of ftdi)!

Bruno

> Index: usb-2.6/drivers/usb/serial/usb-serial.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/serial/usb-serial.c
> +++ usb-2.6/drivers/usb/serial/usb-serial.c
> @@ -209,8 +209,13 @@ static int serial_open (struct tty_struc
>  	 * to be acquired while serial->disc_mutex is held.
>  	 */
>  	mutex_unlock(&serial->disc_mutex);
> +
> +	/* For reasons that have been lost in antiquity, the TTY
> layer calls
> +	 * our close method even if the open call fails.  Hence we
> must not
> +	 * drop the reference obtained by usb_serial_get_by_index().
> +	 */
>  	if (retval)
> -		goto bailout_serial_put;
> +		return retval;
>  
>  	if (mutex_lock_interruptible(&port->mutex)) {
>  		retval = -ERESTARTSYS;
> @@ -276,8 +281,6 @@ bailout_mutex_unlock:
>  	mutex_unlock(&port->mutex);
>  bailout_port_put:
>  	put_device(&port->dev);
> -bailout_serial_put:
> -	usb_serial_put(serial);
>  	return retval;
>  }
>  
> 
