Return-Path: <linux-kernel-owner+w=401wt.eu-S932682AbZLEAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbZLEAjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932525AbZLEAjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:39:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:43788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbZLEAjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:39:19 -0500
Date: Fri, 4 Dec 2009 16:33:57 -0800
From: Greg KH <gregkh@suse.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, stable@kernel.org,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
Message-ID: <20091205003357.GC8792@suse.de>
References: <Pine.LNX.4.44L0.0912041625360.3070-100000@iolanthe.rowland.org>
 <200912042258.48323.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912042258.48323.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 10:58:48PM +0100, Oliver Neukum wrote:
> Am Freitag, 4. Dezember 2009 22:36:22 schrieb Alan Stern:
> > > > Typically the driver would take a reference during open() and drop it
> > > > during close().
> > >
> > > 
> > > You can do that but then you must not do IO prior to open() or after
> > > close(). That is you must actually wait for IO to finish in close() and
> > > cannot prefill your buffers before open().
> > 
> > If open() or close() is called before disconnect() then you don't have 
> > to worry.
> > 
> > If close() is called after disconnect() there's nothing to wait for, 
> > because disconnect() should call usb_kill_urb() on all outstanding 
> > transfers (actually usbcore will do that for you).  Likewise with 
> > open().
> > 
> > The problem in this example stems from the fact that you are using
> > instance->dev at a time when you don't know that it is valid -- in
> > fact, you have good reason to believe it _isn't_ valid because
> > instance->disconnected is set.
> 
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

Don't print anything if you are disconnecting :)

thanks,

greg k-h
