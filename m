Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbZJCOFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbZJCOFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 10:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbZJCOFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 10:05:22 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:36886 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbZJCOFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 10:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i65faPTWlyGX2NKQuGw4hTrTgffL6kWmbIJGfpMnu+2dtYz4UYvxV8cNG3ymIf0gZh
         Fua1OjC5q2tmsYZkzDaymRSynhs8o55AxHsdl89iecEpwHyS/50LgkOlW7GkHHgHaHOr
         iZz/mFpFLY7Wa0eRbY2vPGSjHmvlDeGNTKEWU=
Date: Sat, 3 Oct 2009 16:05:22 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003140522.GA8725@localhost>
References: <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
 <20090924211459.GB27963@localhost>
 <4ABD020B.4040901@gandalf.sssup.it>
 <20090929145514.GF2152@localhost>
 <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
 <m163ayzevu.fsf@fess.ebiederm.org>
 <20091002084755.GA7382@localhost>
 <20091002173308.6158d734@lxorguk.ukuu.org.uk>
 <20091003114229.GB605@localhost>
 <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 02:18:07PM +0100, Alan Cox wrote:
> On Sat, 3 Oct 2009 13:42:29 +0200
> Johan Hovold <jhovold@gmail.com> wrote:
> > On Fri, Oct 02, 2009 at 05:33:08PM +0100, Alan Cox wrote:
> > And, obviously, this doesn't solve the problem of tty_flip_buffer_push
> > being called from interrupt context (but I assume that was never the
> > intention).
> 
> Calling tty_flip_buffer_push from an interrupt is perfectly acceptable
> providing tty->low_latency isn't set: which it isn't.

Of course -- the "with low latency set" part fell out (or, was implicit
;-) ). Your patch, however, still has low_latency set when it calls
tty_flip_buffer_push and that's the problem.

> > -	spin_lock_irqsave(&priv->rx_lock, flags);
> > -	priv->rx_flags &= ~(THROTTLED | ACTUALLY_THROTTLED);
> > -	spin_unlock_irqrestore(&priv->rx_lock, flags);
> > +	spin_lock_irqsave(&port->lock, flags);
> > +	port->throttled = 0;
> > +	spin_unlock_irqrestore(&port->lock, flags);
> 
> If you only have a single bit use the set_bit/clear_bit/test_and_xxx_bit
> stuff as it's faster on most boxes

The generic driver uses two fields in usb_serial_port for
throttled/trottle_req, whereas ftdi_sio, whiteheat, aircable, cypress
and perhaps a couple more have private a flag field for THROTTLED and
ACTUALLY_THROTTLED.

How about unifying them to all use a single flag field (with two flags)
in usb_serial_port?

> > +	 * The per character mucking around with sysrq path it too slow, so
> > +	 * shortcircuit it in the 99.9999999% of cases where the USB serial is
> > +	 * not a console anyway.
> > +	 */
> > +	ch = packet + 2;
> > +	len -= 2;
> > +	if (!port->console || !port->sysrq)
> 
> You need && flag == TTY_NORMAL ?

You tell me. :-) Are we interested in them unless port->console is set?

> Definitely a move in the right direction

Thanks,
Johan

