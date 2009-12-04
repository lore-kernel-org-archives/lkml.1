Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbZLDU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbZLDU5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZLDU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:57:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41642 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932440AbZLDU5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:57:44 -0500
Date: Fri, 4 Dec 2009 15:57:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <200912042055.55565.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912041555430.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Oliver Neukum wrote:

> > > 1. am I supposed to get a reference just so that I can use dev_err?
> > 
> > No, you should already have a reference on the device when doing the
> > call, right?
> 
> No, why? Consider this:
> 
> int write(...)
> {
> 	...
> 	mutex_lock(&instance->lock);
> 	if (instance->disconnected) {
> 		dev_dbg(instance->dev,"writing to disconnected device"); 
> 		rv = -ENODEV;
> 	} else {
> 		res = usb_submit_urb(...);
> 		rv = res < 0 ? -EIO : count;
> 	}
> 	mutex_unlock(&instance->lock);
> 	return rv;
> }
> 
> void disconnect(...)
> {
> 	...
> 	mutex_lock(&instance->lock);
> 	instance->disconnected = 1;
> 	usb_kill_urb(...);
> 	usb_kill_urb(...);
> 	mutex_unlock(&instance->lock);
> }
> 
> This would be perfectly valid code without any references taken save
> for the pesky dev_dbg()

Whoever calls write() must possess a valid reference.  Otherwise 
instance might already be deallocated when write() starts, causing an 
oops well before the call to dev_dbg().

Typically the driver would take a reference during open() and drop it 
during close().

Alan Stern

