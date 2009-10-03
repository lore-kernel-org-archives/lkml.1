Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZJCNQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZJCNQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZJCNQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:16:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57467 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbZJCNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:16:48 -0400
Date: Sat, 3 Oct 2009 14:18:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Johan Hovold <jhovold@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
In-Reply-To: <20091003114229.GB605@localhost>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org>
	<20091002084755.GA7382@localhost>
	<20091002173308.6158d734@lxorguk.ukuu.org.uk>
	<20091003114229.GB605@localhost>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009 13:42:29 +0200
Johan Hovold <jhovold@gmail.com> wrote:

> On Fri, Oct 02, 2009 at 05:33:08PM +0100, Alan Cox wrote:
> > For upstream how does this look as a tidy up
> 
> I found a couple of issues: 
> 
>  - The patch breaks unthrottling, as it checks THROTTLE before resubmitting
>    urb whereas unthrottle checks ACTUALLY_UNTROTTLED which is never set.
> 
>  - The countread stuff should also be removed from
>    ftdi_read_bulk_callback as they where only used for updating
>    rx_bytes,
> 
> And, obviously, this doesn't solve the problem of tty_flip_buffer_push
> being called from interrupt context (but I assume that was never the
> intention).

Calling tty_flip_buffer_push from an interrupt is perfectly acceptable
providing tty->low_latency isn't set: which it isn't.
 
> I've actually been working on cleaning up ftdi_sio inspired by the
> generic driver. I also threw out the work queue, but had not noticed the
> unused rx_byte yet. I also used the generic drivers scheme of not
> pushing to tty until unthrottled, but as you point out this is not really
> needed anymore.

The generic driver is a very bad example to follow in some areas but
this looks a big improvement. There are some patches reworking the
generic code to use kfifo on the output side which make it vastly better.
Not sure where the relevant google submissions went ?

> -	spin_lock_irqsave(&priv->rx_lock, flags);
> -	priv->rx_flags &= ~(THROTTLED | ACTUALLY_THROTTLED);
> -	spin_unlock_irqrestore(&priv->rx_lock, flags);
> +	spin_lock_irqsave(&port->lock, flags);
> +	port->throttled = 0;
> +	spin_unlock_irqrestore(&port->lock, flags);

If you only have a single bit use the set_bit/clear_bit/test_and_xxx_bit
stuff as it's faster on most boxes

> +	 * The per character mucking around with sysrq path it too slow, so
> +	 * shortcircuit it in the 99.9999999% of cases where the USB serial is
> +	 * not a console anyway.
> +	 */
> +	ch = packet + 2;
> +	len -= 2;
> +	if (!port->console || !port->sysrq)

You need && flag == TTY_NORMAL ?

Definitely a move in the right direction
