Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXK2UJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXK2UJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759914AbXK2UJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:09:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54418 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759497AbXK2UJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:09:12 -0500
Date: Thu, 29 Nov 2007 15:09:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <1196365883.7903.11.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711291455410.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Kay Sievers wrote:

> > My conclusion is different.  We should make kobject_init() not consume
> > any resources at all; just initialize various fields.  That way it
> > would be okay to call either kfree() or kobject_put() on an initialized
> > kobject.  And then when something like device_register() fails, the
> > caller would know the proper thing to do would be to call the put()  
> > routine, always.
> > 
> > Of course, once the name has been assigned, only kobject_put() should
> > be used.
> 
> Now we just move the exactly the same problem from _init() to
> _set_name(). To free the name of an unregistered we would need to call
> _put() which free()'s the whole object again. :) 

I don't see that as a problem and it's not clear why you do.

It doesn't matter whether a kobject has been registered or not; once
it has been initialized you _should_ call kobject_put().  (Although
it's okay to call kfree() if the name hasn't been set yet.)

The same is true of larger objects.  Once you have called
device_initialize(), you _should_ call device_put() (although it's okay
to call kfree()).  Provided init routines don't consume resources, this
will work.

The only remaining problem is that somebody might set the name first
and then decide to abandon the object before calling kobject_init().  
However this probably never happens anywhere.

> > There's another good reason for not assigning the name in
> > kobject_init(): Code that uses kobjects (like the driver core) doesn't
> > set the name until later.
> 
> That can be done at any stage, I guess. We will rip out the name in the
> struct device anyway.

Are you also going to change all the places in the kernel where the
device name (.bus_id) isn't set until after device_initialize() has
been called?

Alan Stern

