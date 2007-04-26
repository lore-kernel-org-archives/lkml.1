Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXDZITH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXDZITH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933675AbXDZITG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:19:06 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:7049 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681AbXDZITB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:19:01 -0400
Date: Thu, 26 Apr 2007 10:21:51 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070426102151.0da2e928@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704251516480.2650-100000@iolanthe.rowland.org>
References: <20070425110005.304d3087@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.44L0.0704251516480.2650-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 16:13:12 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> > Documentation/driver-model/lifetime-rules.txt?
> 
> When (if) such a file is added, it should contain more than just these few 
> paragraphs.

This file may be a good idea in general. I'll see if I can come up with
something useful.

> > The remove() method must also unset driver_data.
> 
> It doesn't really have to.  The driver core could do it.

I think it is more consistent if the driver takes care of the fields
specifically designed for its usage.

> It should never need to make that transition.  The only routines in the
> driver which get passed a pointer to the device (as opposed to a pointer
> to the private data) should be the methods called by the driver core or
> sysfs.  Neither will make any calls to the driver after remove() has
> returned, unless the driver does something wrong.

OK, thinko on my side.

> > Uhm. This would imply that a driver may never create a device itself.
> 
> A trivial omission on my part -- "The driver must also retain a module 
> reference to the owner of the device (unless the driver is itself the 
> device's owner)."
> 
> > However, the kobject->owner and module refcounting stuff should remove
> > this restriction.
> 
> If every driver follows this rule, we may not need the kobject->owner 
> stuff.  Although it wouldn't hurt to keep it for safety's sake.

I'm still concerned about that problem. It is that there is simply no
guarantee that everybody released their reference before the module's
exit function returned (the driver itself can and must assure that it
drops its last reference before it finishes exit, but it just can't
control who else holds a reference). I'm much in favour of adding a bit
of code than to risk oopses about which the driver can't do anything
itself (plus, the race exists now, but the immediate disconnect will
involve auditing all drivers).

> > > 		The driver must restrict itself to reading (not
> > > 		writing!) the fields in the device structure.  The
> > > 		only exception is that the driver may lock/unlock
> > > 		dev->sem.
> > 
> > And it may decrease the reference count, of course :)
> 
> :-)  Actually this should be a little more general, since the device will 
> generally be embedded in a larger structure created by the subsystem.  The 
> driver should also be able to acquire and release locks in that larger 
> structure.

Yes. Especially since the "gone"-field may be contained in that
embedding structure if the subsystem controls it.
