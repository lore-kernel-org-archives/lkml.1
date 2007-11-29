Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbXK2SFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbXK2SFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbXK2SFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:05:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59585 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761523AbXK2SFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:05:01 -0500
Date: Thu, 29 Nov 2007 13:04:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <1196356667.3118.16.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711291259300.4712-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Kay Sievers wrote:

> > > Sounds fine, maybe we should also pass the name along, so it will be
> > > obvious what happens here:
> > >   int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)
> > 
> > I don't know...  Normally *_init() routines can't fail, but this could.  
> > Then things like device_register() would run into trouble: The caller 
> > wouldn't know whether a failure occurred before or after the 
> > kobject_init() call, so it wouldn't know what sort of cleanup action 
> > was needed: kfree() or device_put().
> 
> But wouldn't device_register() do the kobject cleanup for you when it
> fails? Why would a caller of device_register() care about the state of
> the kobject?

Let's say device_register() calls device_init(), which calls 
kobject_init(), which fails.  Then there's no cleanup to do -- 
device_register() returns -ENOMEM or some such code and the caller has 
to do the kfree().

Now let's say device_register() calls device_init(), which succeeds, 
and then calls device_add(), which fails.  To recover properly, 
somebody then has to call device_put().  That "somebody" can't be the 
original caller -- according to the previous paragraph the original 
caller won't do anything but kfree().  So the "somebody" has to be 
device_register() itself.

But the device_put() will call kobject_put(), which will invoke the
device's cleanup routine, which will deallocate the structure.  Now the
original caller gets an error code (perhaps -ENOMEM again) but must
_not_ call kfree().

So what should the original caller do when an error occurs?

Alan Stern

