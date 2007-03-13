Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXCMAUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXCMAUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbXCMAUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:20:17 -0400
Received: from mail.suse.de ([195.135.220.2]:51603 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbXCMAUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:20:16 -0400
Date: Mon, 12 Mar 2007 17:18:19 -0700
From: Greg KH <greg@kroah.com>
To: Jim Radford <radford@blackbean.org>
Cc: Mark Lord <lkml@rtr.ca>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression fix
Message-ID: <20070313001819.GA6147@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com> <20070312224235.GB3709@blackbean.org> <20070312225922.GA4064@blackbean.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312225922.GA4064@blackbean.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:59:22PM -0700, Jim Radford wrote:
> On Mon, Mar 12, 2007 at 03:42:35PM -0700, Jim Radford wrote:
> > On Mon, Mar 12, 2007 at 01:33:31PM -0700, Greg KH wrote:
> > > On Mon, Mar 12, 2007 at 04:22:22PM -0400, Mark Lord wrote:
> > > > Oliver Neukum wrote:
> > > > >>Mark Lord wrote:
> > > > >>>Okay, from that part (above), the problem is obvious:
> > > > >>>in that the "MCT U232 converter now disconnected" appears,
> > > > >>>and then we continue to try and call the driver's method.. Oops!
> > 
> > > > >IMHO shutdown() is using serial->port[] and bombs.
> > > > >Could you reverse the order here?
> > 
> > > > Yup.  Fixed.  Tested.  Works.
> > 
> > > > This patch fixes the Oops that otherwise occurs whenever
> > > > a USB serial adapter is unplugged from a system, as well
> > > > the Oops seen when one is in use before resume (to RAM).
> > 
> > > Argh, no, this change was done to help the ftdi drivers out.
> > 
> > > Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
> > > tree from Jim Radford:
> > > 	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
> > > 
> > > It makes this change because the usb-serial drivers need the port
> > > devices when the port_remove() callbacks happen.  Otherwise you get an
> > > oops that way.
> > 
> > > Jim, can you take a look at this and see if you can figure something
> > > out?
> > 
> > The problem is really the
> > 
> >    serial->port[i] = NULL;
> > 
> > line after device_unregister() which is used to flag "fake" devices
> > that don't need legacy cleanup later in the destrol_serial.  That
> > flagging should be done using a *real* flag, and not by overloading
> > the ->port[i] pointer since we require it to be non-NULL in
> > ->shutdown() in all drivers that are not converted to new
> > ->port_probe()/->port_remove() framework (currently all except ftdi).
> 
> > I'll work on a patch to do that, but for now, I think you should apply
> > Mark's patch to revert the order change since the FTDI driver no
> > longer requires the correct ordering of device_unregister() and
> > ->shutdown().
> 
> Do not NULL serial->port[i] since it is used in ->shutdown().  This
> wasn't an issue until the order or ->shutdown() and device_unregister
> was corrected.
> 
> Signed-Off: Jim Radford <radford@blackbean.org>
> 
> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> index 8511352..871c9a8 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -145,7 +145,6 @@ static void destroy_serial(struct kref *kref)
>         for (i = 0; i < serial->num_ports; ++i)
>                 if (serial->port[i]->dev.parent != NULL) {
>                         device_unregister(&serial->port[i]->dev);
> -                       serial->port[i] = NULL;
>                 }

But shouldn't you null it out somewhere?  It will be an "empty" pointer
at some point in time...

Mark, does this solve your oops (after you revert your previous patch)?

thanks,

greg k-h
