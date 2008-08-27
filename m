Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYH0SmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYH0SmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYH0SmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:42:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYH0SmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:42:03 -0400
Date: Wed, 27 Aug 2008 11:36:15 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
	2
Message-ID: <20080827183615.GA15692@kroah.com>
References: <20080827172042.GA18774@kroah.com> <Pine.LNX.4.44L0.0808271423030.17568-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0808271423030.17568-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 02:28:22PM -0400, Alan Stern wrote:
> On Wed, 27 Aug 2008, Greg KH wrote:
> 
> > Here's an updated version of the usbtmc driver, with all of the
> > different issues that have been raised, hopefully addressed.
> 
> This is an example of what I was discussing with Oliver.  In all 
> likelihood you simply don't need usbtmc_mutex, and using it will cause 
> a lockdep violation.
> 
> That's why so many of the other USB class drivers don't have an 
> analogous static mutex.

Ok, then it's just safe to drop this static mutex entirely, right?

> > +static int usbtmc_open(struct inode *inode, struct file *filp)
> > +{
> > +	struct usb_interface *intf;
> > +	struct usbtmc_device_data *data;
> > +	int retval = -ENODEV;
> > +
> > +	mutex_lock(&usbtmc_mutex);
> 
> You must never acquire a lock in your open method if it will be held
> by your disconnect method while unregistering the minor.
> 
> > +static int usbtmc_probe(struct usb_interface *intf,
> > +			const struct usb_device_id *id)
> > +{
> ...
> > +	retcode = usb_register_dev(intf, &usbtmc_class);
> > +	if (retcode) {
> > +		dev_err(&intf->dev, "Not able to get a minor"
> > +			" (base %u, slice default): %d\n", USBTMC_MINOR_BASE,
> > +			retcode);
> > +		goto error_register;
> > +	}
> > +	dev_dbg(&intf->dev, "Using minor number %d\n", intf->minor);
> 
> You do call usb_register_dev() during probe...
> 
> > +
> > +	return 0;
> > +
> > +error_register:
> > +	sysfs_remove_group(&intf->dev.kobj, &capability_attr_grp);
> > +	sysfs_remove_group(&intf->dev.kobj, &data_attr_grp);
> > +	kref_put(&data->kref, usbtmc_delete);
> > +	return retcode;
> > +}
> > +
> > +static void usbtmc_disconnect(struct usb_interface *intf)
> > +{
> > +	struct usbtmc_device_data *data;
> > +
> > +	dev_dbg(&intf->dev, "usbtmc_disconnect called\n");
> > +
> > +	mutex_lock(&usbtmc_mutex);
> > +	data = usb_get_intfdata(intf);
> > +	sysfs_remove_group(&intf->dev.kobj, &capability_attr_grp);
> > +	sysfs_remove_group(&intf->dev.kobj, &data_attr_grp);
> > +	kref_put(&data->kref, usbtmc_delete);
> > +	mutex_unlock(&usbtmc_mutex);
> > +}
> 
> But you don't call usb_unregister_dev() during disconnect.  An 
> oversight?

Ah, yes, my fault, I converted this from using a private cdev to using
the usb_register_dev() call and forgot about this.  Thanks for catching
it, I'll go fix this.

Oh, it's usb_deregister_dev(), stupid programmers with inconsitant
interfaces :)

thanks,

greg k-h
