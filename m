Return-Path: <linux-kernel-owner+w=401wt.eu-S1751640AbZLDWHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbZLDWHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZLDWHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:07:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50149 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750802AbZLDWHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:07:06 -0500
Date: Fri, 4 Dec 2009 17:07:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <200912042258.48323.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912041702510.2616-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Oliver Neukum wrote:

> OK, yes. It's a bad example. However this is tricky.
> 
> This is a bug then:
> 
> mutex_lock(...);
> 
> if (instance->error) {
> 	rv = instance->error;
> 	instance->error  = 0;
> 	dev_dbg(instance->dev,...);

Unless you can guarantee at this point that instance->dev isn't stale, 
it is indeed a bug.

> 	goto err_out;
> }
> 
> rv = -ENODEV;
> if (instance->disconnected)
> 	goto err_out;
> 
> > One approach is to set instance->dev to NULL in disconnect().  That
> > wouldn't do much good for your dev_dbg(), though.  A better solution is
> > to refcount the instance->dev pointer: Take a reference to the device
> > when setting instance->dev and drop it when clearing instance->dev (or
> > when instance is freed).
> 
> That would mean that I am forced to adopt refcounting just to print
> something. This seems very inelegant.

What can I say?  When the something you want to print can be
deallocated at any time, there isn't much choice.

Maybe reference counting is inelegant; it depends on your point of
view.  Can you think of a more elegant way to make sure that a pointer
isn't stale?

Alan Stern

