Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbXK2UUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbXK2UUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbXK2UTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:19:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:62553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbXK2UTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:19:50 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291455410.5666-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711291455410.5666-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 21:19:57 +0100
Message-Id: <1196367597.7903.25.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19GzPtaGKTzKaJ/YHOCZsd41GdGFzxio7E+vZs
 iEviSHp6RBQnpxvXIk51L5Tn364JoLGDm4IM9VSiJ8ImjXArxd
 S/LktXHP6O8hz5aPuVvlPjQfjxSY6Z+
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 15:09 -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Kay Sievers wrote:
> 
> > > My conclusion is different.  We should make kobject_init() not consume
> > > any resources at all; just initialize various fields.  That way it
> > > would be okay to call either kfree() or kobject_put() on an initialized
> > > kobject.  And then when something like device_register() fails, the
> > > caller would know the proper thing to do would be to call the put()  
> > > routine, always.
> > > 
> > > Of course, once the name has been assigned, only kobject_put() should
> > > be used.
> > 
> > Now we just move the exactly the same problem from _init() to
> > _set_name(). To free the name of an unregistered we would need to call
> > _put() which free()'s the whole object again. :) 
> 
> I don't see that as a problem and it's not clear why you do.
> 
> It doesn't matter whether a kobject has been registered or not; once
> it has been initialized you _should_ call kobject_put().  (Although
> it's okay to call kfree() if the name hasn't been set yet.)

I just say, it's exactly the same problem and it does not really make a
difference that kobject_init() does not do anything, if we require
another function to be called before we can call kobject_add(). A
kobject without a name will not be valid, and we will need a way for an
easy cleanup of allocated resources I think.

> The same is true of larger objects.  Once you have called
> device_initialize(), you _should_ call device_put() (although it's okay
> to call kfree()).  Provided init routines don't consume resources, this
> will work.
> 
> The only remaining problem is that somebody might set the name first
> and then decide to abandon the object before calling kobject_init().  
> However this probably never happens anywhere.

What is the whole point of kobject_init() then? You can just do the same
stuff in kobject_add() if you require not to allocate anything there. 

None of the initialized fields can be used before we have called
kobject_add(), right?

> > > There's another good reason for not assigning the name in
> > > kobject_init(): Code that uses kobjects (like the driver core) doesn't
> > > set the name until later.
> > 
> > That can be done at any stage, I guess. We will rip out the name in the
> > struct device anyway.
> 
> Are you also going to change all the places in the kernel where the
> device name (.bus_id) isn't set until after device_initialize() has
> been called?

Yes, I already have a patch that does that for all stuff that was needed
on my boxes.

Kay

