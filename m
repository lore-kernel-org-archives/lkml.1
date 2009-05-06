Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbZEFUcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbZEFUcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760393AbZEFUcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:32:10 -0400
Received: from kroah.org ([198.145.64.141]:39147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759379AbZEFUcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:32:08 -0400
Date: Wed, 6 May 2009 13:28:21 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
	writes
Message-ID: <20090506202821.GA12449@kroah.com>
References: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org> <200905062201.42965.oliver@neukum.org> <4A01F201.3020406@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A01F201.3020406@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 03:24:33PM -0500, Jason Wessel wrote:
> Oliver Neukum wrote:
> > Am Mittwoch, 6. Mai 2009 21:24:56 schrieb Alan Stern:
> >   
> >> Converting \n to \r\n will add some complication
> >> but not too much.
> >>     
> 
> This conversion is done in the tty layer "the high level".  By the time
> the low level driver gets it character stream via the tty call backs
> everything is already processed.
> 
> >> Allocating URBs on the fly adds a lot of complication.  There has to be
> >> a minimum number of pre-allocated URBs; otherwise write_room could
> >>     
> >
> > Why? You can always calculate with the number of URBs you'd
> > allocate as a maximum.
> >
> >   
> 
> In the scheme originally posted with the cap of 42 "in flight" urbs, I
> had not seen it run out while using the standard tty driver.   The tty
> driver really is not really the key problem I was after with the forced
> poll patch.
> 
> The console driver is where all the character loss is going on.  There
> is no tty interface, and there are no "write room" checks.  The present
> kernel interface to the uart console callbacks is synchronous.
> 
> Here is a back trace to illustrate the typical 8250 driver.
> 
> #0  serial8250_console_putchar at drivers/serial/8250.c:2690
> #1  0xc03977d4 in uart_console_write at drivers/serial/serial_core.c:1810
> #2  0xc039cbb8 in serial8250_console_write at drivers/serial/8250.c:2729
> #3  0xc022802b in __call_console_drivers at kernel/printk.c:419
> #4  0xc022808b in _call_console_drivers at kernel/printk.c:449
> #5  0xc0228269 in call_console_drivers at kernel/printk.c:499
> #6  release_console_sem at kernel/printk.c:1020
> #7  0xc022872b in vprintk at kernel/printk.c:749
> #8  0xc022889b in printk at kernel/printk.c:582
> 
> Doing enough printk's such as in register_console() will cause loss
> because you run out of URBs unless you can force them to complete.

Why not just make the upper bound of urbs very large?  We used to have
an unlimited number of in-flight urbs for some drivers until it was
pointed out that a simple:
	cat /dev/null > /dev/ttyUSB0
would cause a DoS :)

What happens if your upper bound is 400?  4000?  Will that work
properly?

thanks,

greg k-h
