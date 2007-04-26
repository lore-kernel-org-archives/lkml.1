Return-Path: <linux-kernel-owner+w=401wt.eu-S1031247AbXDZO6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031247AbXDZO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031249AbXDZO6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:58:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55353 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031247AbXDZO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:58:47 -0400
Date: Thu, 26 Apr 2007 10:58:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070426102151.0da2e928@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704261040440.3552-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Cornelia Huck wrote:

> On Wed, 25 Apr 2007 16:13:12 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > Documentation/driver-model/lifetime-rules.txt?
> > 
> > When (if) such a file is added, it should contain more than just these few 
> > paragraphs.
> 
> This file may be a good idea in general. I'll see if I can come up with
> something useful.

Good.

> > > The remove() method must also unset driver_data.
> > 
> > It doesn't really have to.  The driver core could do it.
> 
> I think it is more consistent if the driver takes care of the fields
> specifically designed for its usage.

Yes.  However if the driver forgets to clear the field it shouldn't cause
a warning.  After all, there won't be any harm; the next driver to bind 
to the device will just overwrite the driver_data anyway.

> > If every driver follows this rule, we may not need the kobject->owner 
> > stuff.  Although it wouldn't hurt to keep it for safety's sake.
> 
> I'm still concerned about that problem. It is that there is simply no
> guarantee that everybody released their reference before the module's
> exit function returned (the driver itself can and must assure that it
> drops its last reference before it finishes exit, but it just can't
> control who else holds a reference). I'm much in favour of adding a bit
> of code than to risk oopses about which the driver can't do anything
> itself (plus, the race exists now, but the immediate disconnect will
> involve auditing all drivers).

I agree.

> > > > 		The driver must restrict itself to reading (not
> > > > 		writing!) the fields in the device structure.  The
> > > > 		only exception is that the driver may lock/unlock
> > > > 		dev->sem.
> > > 
> > > And it may decrease the reference count, of course :)
> > 
> > :-)  Actually this should be a little more general, since the device will 
> > generally be embedded in a larger structure created by the subsystem.  The 
> > driver should also be able to acquire and release locks in that larger 
> > structure.
> 
> Yes. Especially since the "gone"-field may be contained in that
> embedding structure if the subsystem controls it.

No, no!  The "gone" flag must be in the private data structure.  If it 
were in a container of the device structure, then it could be overwritten 
when a different driver binds to the device.

Alan Stern

