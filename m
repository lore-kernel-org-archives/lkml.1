Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXCMPgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXCMPgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbXCMPgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:36:50 -0400
Received: from cpe-67-49-92-118.socal.res.rr.com ([67.49.92.118]:51284 "EHLO
	mail.blackbean.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXCMPgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:36:50 -0400
Date: Tue, 13 Mar 2007 08:30:50 -0700
From: Jim Radford <radford@blackbean.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression fix
Message-ID: <20070313153050.GA14687@blackbean.org>
References: <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com> <20070312224235.GB3709@blackbean.org> <20070312225922.GA4064@blackbean.org> <20070313001819.GA6147@kroah.com> <20070313004142.GA4835@blackbean.org> <45F60482.6010501@rtr.ca> <20070313091408.GA7205@blackbean.org> <45F6AD5D.4020700@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6AD5D.4020700@rtr.ca>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (mail.blackbean.org [127.0.0.1]); Tue, 13 Mar 2007 08:30:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:55:41AM -0400, Mark Lord wrote:
> Jim Radford wrote:
> >On Mon, Mar 12, 2007 at 09:55:14PM -0400, Mark Lord wrote:
> >
> >>So where does the memory get freed -- the structure pointed at
> >>by the serial->port[i] thingie ?  It's not a leak, is it?
> >
> >It gets free'd through device_unregister
> >
> >    for (i = 0; i < num_ports; ++i) {
> >       ...
> >       port->dev.release = &port_release;
> >       ...
> >       retval = device_register(&port->dev);
> >
> >which means that until all the drivers get converted to use
> >->port_probe() and ->port_remove() (which gets called by
> >device_unregister) and stop using the ->port[] array in ->shutdown()
> >we need to have ->shutdown() called before device_unregister.
> >
> >>>>>Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
> >>>>>tree from Jim Radford:
> >
> >>>>>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a

> >So, this patch should be reverted for now.

> Okay, so.. Jim, could you spell it out for us now?

> I'm confused.

> Based on the current 2.6.21-rc3-git*, tell us *exactly* what (if
> any) needs to be reverted, and *exactly* which (if any) of my
> suggested patches to apply ?

The simple change to not NULL the ->port[] array after unregister was
not quite enough, as ->shutdown() would, as hinted at by Mark, then
access kfree'd memory.

The best thing to do is to just revert
d9a7ecacac5f8274d2afce09aadcf37bdb42b93a and work out a better fix for
the next release.  My patches to fix ftdi_sio no longer require this
patch, so it is pointless at this late state if it breaks *anything*,
and it does.


This patch reverts d9a7ecacac5f8274d2afce09aadcf37bdb42b93a since it
breaks drivers that need to access the ->port[] array in shutdown
(most of them).

Signed-Off: Jim Radford <radford@blackbean.org>

--- b/drivers/usb/serial/usb-serial.c
+++ a/drivers/usb/serial/usb-serial.c
@@ -137,6 +135,11 @@
 
 	dbg("%s - %s", __FUNCTION__, serial->type->description);
 
+	serial->type->shutdown(serial);
+
+	/* return the minor range that this device had */
+	return_serial(serial);
+
 	for (i = 0; i < serial->num_ports; ++i)
 		serial->port[i]->open_count = 0;
 
@@ -147,12 +150,6 @@
 			serial->port[i] = NULL;
 		}
 
-	if (serial->type->shutdown)
-		serial->type->shutdown(serial);
-
-	/* return the minor range that this device had */
-	return_serial(serial);
-
 	/* If this is a "fake" port, we have to clean it up here, as it will
 	 * not get cleaned up in port_release() as it was never registered with
 	 * the driver core */



