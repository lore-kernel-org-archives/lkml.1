Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZGVKQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZGVKQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZGVKQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:16:38 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37463 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZGVKQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:16:36 -0400
Date: Wed, 22 Jul 2009 12:16:31 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       stern@rowland.harvard.edu
Subject: Re: [PATCH] tty: Fix a USB serial crash/scribble
Message-ID: <20090722101631.GG13236@buzzloop.caiaq.de>
References: <20090722093735.27118.36158.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722093735.27118.36158.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 10:39:51AM +0100, Alan Cox wrote:
> See if this one looks sensible. It does leave a tiny race window but that
> semes wiser than hacking up the tty kref_put path in the middle of an -rc
> series.
> 
> Thanks to Daniel and Alan Stern for chasing this down and getting traces. Also
> to Daniel for being persistent when I took it as a random odd "only seen by one
> user" error which it wasn't.

Thanks Alan for your patience. You know the tty layer well which I have
no clue of, so I missed the bits in the close callback.

I tested your patch and can confirm it fixes the problem for me.

Daniel



> The port lock is used to protect the port state. However the port structure
> is freed on a hangup, then the lock taken on a close. The right fix is to
> drop the port on tty->shutdown() but we can't yet do that due to sleep v
> non-sleeping rules. Instead do the next best thing and fix it up when we are
> not in -rc season.
> 
> Reported-by: Daniel Mack <daniel@caiaq.de>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Tested-by: Daniel Mack <daniel@caiaq.de>


> ---
> 
>  drivers/usb/serial/usb-serial.c |   19 ++++++++++++++++++-
>  1 files changed, 18 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> index bd7581b..228d77c 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -340,6 +340,22 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
>  
>  	dbg("%s - port %d", __func__, port->number);
>  
> +	/* FIXME:
> +	   This leaves a very narrow race. Really we should do the
> +	   serial_do_free() on tty->shutdown(), but tty->shutdown can
> +	   be called from IRQ context and serial_do_free can sleep.
> +
> +	   The right fix is probably to make the tty free (which is rare)
> +	   and thus tty->shutdown() occur via a work queue and simplify all
> +	   the drivers that use it.
> +	*/
> +	if (tty_hung_up_p(filp)) {
> +		/* serial_hangup already called serial_down at this point.
> +		   Another user may have already reopened the port but 
> +		   serial_do_free is refcounted */
> +		serial_do_free(port);
> +		return;
> +	}
>  
>  	if (tty_port_close_start(&port->port, tty, filp) == 0)
>  		return;
> @@ -355,7 +371,8 @@ static void serial_hangup(struct tty_struct *tty)
>  	struct usb_serial_port *port = tty->driver_data;
>  	serial_do_down(port);
>  	tty_port_hangup(&port->port);
> -	serial_do_free(port);
> +	/* We must not free port yet - the USB serial layer depends on it's
> +	   continued existence */
>  }
>  
>  static int serial_write(struct tty_struct *tty, const unsigned char *buf,
> 
