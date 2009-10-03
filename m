Return-Path: <linux-kernel-owner+w=401wt.eu-S1751262AbZJCQrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbZJCQrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZJCQrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:47:07 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54013 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZJCQrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sOi1uSK6nzokUfmQu9n74+n3TlBKAzaIMbSE24MhN38nNs1dxeJiFmE+WyDvzO8flw
         ytG/KwiOK2dc71ooLi9PnJehNBamJZ6k0/I8uSwMrD4b1VYeM58JeGHBovlHeyEhYyAf
         t3d8yU/9Nu+Z+QR282Vf414nIf49D0mBf9TJ4=
Date: Sat, 3 Oct 2009 18:46:25 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003164625.GB12952@localhost>
References: <4ABD020B.4040901@gandalf.sssup.it>
 <20090929145514.GF2152@localhost>
 <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
 <m163ayzevu.fsf@fess.ebiederm.org>
 <20091002084755.GA7382@localhost>
 <20091002173308.6158d734@lxorguk.ukuu.org.uk>
 <20091003114229.GB605@localhost>
 <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
 <20091003140522.GA8725@localhost>
 <20091003173324.315855ac@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003173324.315855ac@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 05:33:24PM +0100, Alan Cox wrote:
> > Of course -- the "with low latency set" part fell out (or, was implicit
> > ;-) ). Your patch, however, still has low_latency set when it calls
> > tty_flip_buffer_push and that's the problem.
> 
> I don't think it does - I removed all the low latency setting.

It's still in the patch you posted (and ASYNC_LOW_LATENCY is left
unmodifed, that is set, by your patch):

@@ -1700,9 +1697,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
        spin_lock_irqsave(&priv->tx_lock, flags);
        priv->tx_bytes = 0;
        spin_unlock_irqrestore(&priv->tx_lock, flags);
-       spin_lock_irqsave(&priv->rx_lock, flags);
-       priv->rx_bytes = 0;
-       spin_unlock_irqrestore(&priv->rx_lock, flags);

        if (tty)
                tty->low_latency = (priv->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
@@ -1730,7 +1724,6 @@ static int ftdi_open(struct tty_struct *tty, struct usb_serial_port *port)
        spin_unlock_irqrestore(&priv->rx_lock, flags);

        /* Start reading from the device */
-       priv->rx_processed = 0;
        usb_fill_bulk_urb(port->read_urb, dev,
                        usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress),
                        port->read_urb->transfer_buffer,


But nevermind, we agree it should go. :-)

