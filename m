Return-Path: <linux-kernel-owner+w=401wt.eu-S2993486AbXEBQ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993486AbXEBQ3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993487AbXEBQ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:29:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40328 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993486AbXEBQ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:29:09 -0400
Date: Wed, 2 May 2007 09:26:39 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: BAD PATCH: USB: remove use of the bus rwsem, as it doesn't
	really protect anything.
Message-ID: <20070502162639.GA13497@kroah.com>
References: <200704272059.l3RKxNPS023912@hera.kernel.org> <20070427224932.34a03e2e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427224932.34a03e2e@the-village.bc.nu>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 10:49:32PM +0100, Alan Cox wrote:

(please CC: me on patches that I submitted, I missed this...)

> Unless there is something I'm missing most of these patches seem totally
> unsafe.

Hm, no, they were using a lock that was never being used by the core,
thereby protecting nothing.

> > --- a/drivers/usb/core/devices.c
> > +++ b/drivers/usb/core/devices.c
> > @@ -246,7 +246,6 @@ static char *usb_dump_interface_descriptor(char *start, char *end,
> >  
> >  	if (start > end)
> >  		return start;
> > -	down_read(&usb_bus_type.subsys.rwsem);
> >  	if (iface) {
> >  		driver_name = (iface->dev.driver
> >  				? iface->dev.driver->name
> 
> iface->dev.driver can now become NULL during the evaluation above

All of the USB stuff is already covered by a different lock, see the
linux-usb-devel list for when I originally proposed this patch (also
 CC:ed to verify I didn't miss anything...)

> > @@ -444,8 +441,6 @@ static int releaseintf(struct dev_state *ps, unsigned int ifnum)
> >  	if (ifnum >= 8*sizeof(ps->ifclaimed))
> >  		return err;
> >  	dev = ps->dev;
> > -	/* lock against other changes to driver bindings */
> > -	down_write(&usb_bus_type.subsys.rwsem);
> >  	intf = usb_ifnum_to_if(dev, ifnum);
> >  	if (!intf)
> >  		err = -ENOENT;
> > @@ -453,7 +448,6 @@ static int releaseintf(struct dev_state *ps, unsigned int ifnum)
> >  		usb_driver_release_interface(&usbfs_driver, intf);
> 
> Which takes iface->dev.driver to NULL
> 
> >  		err = 0;
> >  	}
> > -	up_write(&usb_bus_type.subsys.rwsem);
> >  	return err;
> >  }
> >  
> > @@ -813,7 +807,6 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
> >  
> >  	if (copy_from_user(&gd, arg, sizeof(gd)))
> >  		return -EFAULT;
> > -	down_read(&usb_bus_type.subsys.rwsem);
> >  	intf = usb_ifnum_to_if(ps->dev, gd.interface);
> >  	if (!intf || !intf->dev.driver)
> >  		ret = -ENODATA;
> 
> Ditto ...

thanks,

greg k-h
