Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZLDV6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZLDV6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZLDV6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:58:37 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:41302 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbZLDV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:58:36 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
Date: Fri, 4 Dec 2009 22:58:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912041625360.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041625360.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912042258.48323.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 4. Dezember 2009 22:36:22 schrieb Alan Stern:
> > > Typically the driver would take a reference during open() and drop it
> > > during close().
> >
> > 
> > You can do that but then you must not do IO prior to open() or after
> > close(). That is you must actually wait for IO to finish in close() and
> > cannot prefill your buffers before open().
> 
> If open() or close() is called before disconnect() then you don't have 
> to worry.
> 
> If close() is called after disconnect() there's nothing to wait for, 
> because disconnect() should call usb_kill_urb() on all outstanding 
> transfers (actually usbcore will do that for you).  Likewise with 
> open().
> 
> The problem in this example stems from the fact that you are using
> instance->dev at a time when you don't know that it is valid -- in
> fact, you have good reason to believe it _isn't_ valid because
> instance->disconnected is set.

OK, yes. It's a bad example. However this is tricky.

This is a bug then:

mutex_lock(...);

if (instance->error) {
	rv = instance->error;
	instance->error  = 0;
	dev_dbg(instance->dev,...);
	goto err_out;
}

rv = -ENODEV;
if (instance->disconnected)
	goto err_out;

> One approach is to set instance->dev to NULL in disconnect().  That
> wouldn't do much good for your dev_dbg(), though.  A better solution is
> to refcount the instance->dev pointer: Take a reference to the device
> when setting instance->dev and drop it when clearing instance->dev (or
> when instance is freed).

That would mean that I am forced to adopt refcounting just to print
something. This seems very inelegant.

	Regards
		Oliver
