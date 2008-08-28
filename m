Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYH1V2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYH1V2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbYH1V2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:28:23 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56700 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYH1V2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:28:22 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Thu, 28 Aug 2008 23:29:33 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20080827183615.GA15692@kroah.com> <200808281210.27661.oliver@neukum.org> <20080828161702.GB18132@kroah.com>
In-Reply-To: <20080828161702.GB18132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282329.34780.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > +		buffer[4] = (this_part - 12 - 3) & 255;
> > > +		buffer[5] = ((this_part - 12 - 3) >> 8) & 255;
> > > +		buffer[6] = ((this_part - 12 - 3) >> 16) & 255;
> > > +		buffer[7] = ((this_part - 12 - 3) >> 24) & 255;
> > 
> > We have excellent endianness conversion macros.
> 
> For splitting values up into the individual byte portions?  I think this
> is far more obvious as to exactly what is going on, don't you?

No. Kernel code does not exist to show how to do endianness conversion.
We have clearly labeled functions.

> > > +		buffer[8] = data->TermCharEnabled * 2;
> > > +		/* Use term character? */
> > 
> > smp_rmb(); /* we must make sure we don't read a stale terminator */
> 
> I'm not going to worry about races here, that's not a real issue.

There is no such thing as an ignorable race. On second thought
you can take the mutex in the sysfs handlers. That will also do the job.


> > This and usbtmc_read() need a test for disconnection. Open() and disconnect
> > are guarded in usbcore, read & write are not. By reference count you've made
> > sure you have a valid device descriptor, but the device may have been reprobed.
> 
> If so, then struct usb_device would be different, right?  Oh, I see,
> disconnect() using usbfs/sysfs.  Bah, is it really something that
> happens in the real world?  Oh well, I'll go fix this...

This is oopsable from user space.

> > If you ignore an error return, be open about it.
> 
> I'm not?  Should I print an error and then just continue on?  Would that
> be sufficient?

Yes.
 
> > > +static void usbtmc_disconnect(struct usb_interface *intf)
> > > +{
> > > +	struct usbtmc_device_data *data;
> > > +
> > > +	dev_dbg(&intf->dev, "usbtmc_disconnect called\n");
> > > +
> > 
> > You must set a flag for read, write and ioctl.
> 
> Will do.  Then I need to lock the flag with a mutex, right?

Yes. You can set the intf pointer to NULL. That's sort of idiomatic.
And you should NULL intfdata.


	Regards
		Oliver


