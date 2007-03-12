Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbXCLUfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbXCLUfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXCLUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:35:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:38500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXCLUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:35:06 -0400
Date: Mon, 12 Mar 2007 13:33:31 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>, Jim Radford <radford@blackbean.org>,
       linux-usb-devel@lists.sourceforge.net
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression (Oops)  in 2.6.21-rc*
Message-ID: <20070312203331.GA6769@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F5B67E.7000105@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 04:22:22PM -0400, Mark Lord wrote:
> Oliver Neukum wrote:
> >>Mark Lord wrote:
> >>>Okay, from that part (above), the problem is obvious:
> >>>in that the "MCT U232 converter now disconnected" appears,
> >>>and then we continue to try and call the driver's method.. Oops!
> ..
> >IMHO shutdown() is using serial->port[] and bombs.
> >Could you reverse the order here?
> 
> Yup.  Fixed.  Tested.  Works.
> 
> This patch fixes the Oops that otherwise occurs whenever
> a USB serial adapter is unplugged from a system, as well
> the Oops seen when one is in use before resume (to RAM).
> 
> GregKH:  This needs to go into 2.6.21-rc*.
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> --- 2.6.21-rc3/drivers/usb/serial/usb-serial.c	2007-03-12 
> 11:22:43.000000000 -0400
> +++ linux/drivers/usb/serial/usb-serial.c	2007-03-12 
> 16:12:53.000000000 -0400
> @@ -141,6 +141,9 @@
> 	for (i = 0; i < serial->num_ports; ++i)
> 		serial->port[i]->open_count = 0;
> 
> +	if (serial->type->shutdown)
> +		serial->type->shutdown(serial);
> +
> 	/* the ports are cleaned up and released in port_release() */
> 	for (i = 0; i < serial->num_ports; ++i)
> 		if (serial->port[i]->dev.parent != NULL) {
> @@ -148,9 +151,6 @@
> 			serial->port[i] = NULL;
> 		}
> 
> -	if (serial->type->shutdown)
> -		serial->type->shutdown(serial);
> -


Argh, no, this change was done to help the ftdi drivers out.

Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
tree from Jim Radford:
	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a

It makes this change because the usb-serial drivers need the port
devices when the port_remove() callbacks happen.  Otherwise you get an
oops that way.

Jim, can you take a look at this and see if you can figure something
out?

thanks,

greg k-h
