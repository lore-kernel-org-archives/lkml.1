Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXK2SfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXK2SfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759873AbXK2Sez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:34:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:50479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721AbXK2Sez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:34:55 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291259300.4712-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711291259300.4712-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 19:33:46 +0100
Message-Id: <1196361226.7903.6.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+cgZ32TQhQZhWbPoA631H4epQ3aNOfgh3CZK+
 utTSnJTBPqNUrigu8ksMtpaD6AkODGya7ydUlvTCGqpPTY8iYt
 UYzC3YEYwhAdn//gG+NtcQC+zLe4Z3k
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 13:04 -0500, Alan Stern wrote: 
> On Thu, 29 Nov 2007, Kay Sievers wrote:
> 
> > > > Sounds fine, maybe we should also pass the name along, so it will be
> > > > obvious what happens here:
> > > >   int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)
> > > 
> > > I don't know...  Normally *_init() routines can't fail, but this could.  
> > > Then things like device_register() would run into trouble: The caller 
> > > wouldn't know whether a failure occurred before or after the 
> > > kobject_init() call, so it wouldn't know what sort of cleanup action 
> > > was needed: kfree() or device_put().
> > 
> > But wouldn't device_register() do the kobject cleanup for you when it
> > fails? Why would a caller of device_register() care about the state of
> > the kobject?
> 
> Let's say device_register() calls device_init(), which calls 
> kobject_init(), which fails.  Then there's no cleanup to do -- 
> device_register() returns -ENOMEM or some such code and the caller has 
> to do the kfree().
> 
> Now let's say device_register() calls device_init(), which succeeds, 
> and then calls device_add(), which fails.  To recover properly, 
> somebody then has to call device_put().  That "somebody" can't be the 
> original caller -- according to the previous paragraph the original 
> caller won't do anything but kfree().  So the "somebody" has to be 
> device_register() itself.
> 
> But the device_put() will call kobject_put(), which will invoke the
> device's cleanup routine, which will deallocate the structure.  Now the
> original caller gets an error code (perhaps -ENOMEM again) but must
> _not_ call kfree().
> 
> So what should the original caller do when an error occurs?

Right, and that is not covered today, the current code just leaks the
allocated name.

Your error scenario confirmed my initial concern about suggesting
kobject_put() to clean up an initialized kobject.

We should probably make kobject_cleanup() free only the resources taken
by kobject_init(), and use kobject_cleanup() instead of kobject_put()?

Kay

