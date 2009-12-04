Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZLDVSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZLDVSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbZLDVSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:18:04 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:56078 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277AbZLDVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:17:59 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
Date: Fri, 4 Dec 2009 22:18:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912041555430.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041555430.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912042218.11410.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Dezember 2009 21:57:50 schrieb Alan Stern:
> On Fri, 4 Dec 2009, Oliver Neukum wrote:
> > > > 1. am I supposed to get a reference just so that I can use dev_err?
> > >
> > > No, you should already have a reference on the device when doing the
> > > call, right?
> >
> > No, why? Consider this:
> >
> > int write(...)
> > {
> > 	...
> > 	mutex_lock(&instance->lock);
> > 	if (instance->disconnected) {
> > 		dev_dbg(instance->dev,"writing to disconnected device");
> > 		rv = -ENODEV;
> > 	} else {
> > 		res = usb_submit_urb(...);
> > 		rv = res < 0 ? -EIO : count;
> > 	}
> > 	mutex_unlock(&instance->lock);
> > 	return rv;
> > }
> >
> > void disconnect(...)
> > {
> > 	...
> > 	mutex_lock(&instance->lock);
> > 	instance->disconnected = 1;
> > 	usb_kill_urb(...);
> > 	usb_kill_urb(...);
> > 	mutex_unlock(&instance->lock);
> > }
> >
> > This would be perfectly valid code without any references taken save
> > for the pesky dev_dbg()
> 
> Whoever calls write() must possess a valid reference.  Otherwise
> instance might already be deallocated when write() starts, causing an
> oops well before the call to dev_dbg().

He needs a valid reference to "instance", not to the device. In fact
he may do IO to the device only if he knows it hasn't been disconnected.
 
> Typically the driver would take a reference during open() and drop it
> during close().

You can do that but then you must not do IO prior to open() or after
close(). That is you must actually wait for IO to finish in close() and
cannot prefill your buffers before open().

	Regards
		Oliver

