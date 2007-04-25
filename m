Return-Path: <linux-kernel-owner+w=401wt.eu-S1423333AbXDYI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423333AbXDYI5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423331AbXDYI5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:57:21 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:29856 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423329AbXDYI5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:57:19 -0400
Date: Wed, 25 Apr 2007 11:00:05 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070425110005.304d3087@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0704241501170.2647-100000@iolanthe.rowland.org>
References: <20070422174051.GA21680@kroah.com>
	<Pine.LNX.4.44L0.0704241501170.2647-100000@iolanthe.rowland.org>
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

On Tue, 24 Apr 2007 15:38:12 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> We ought to make it explicitly clear that _all_ subsystems should behave
> this way.  Maybe it isn't necessary to go as far as having device_del()
> call itself recursively; doing that would open up lots of possible races.  
> But I think it would be a good idea to add a WARN_ON in device_del, right
> after the call to bus_remove_device(), that would be triggered if the
> device still had any children.

If we decide that this should be policy, WARN_ON may be the least
invasive option.

Should it be a possible option to move children to a different parent,
so that the requirement wouldn't be "unregister all children", but "no
children remain after remove() returns"?

> It would also be good to document (but where?) some lifetime rules for 
> device drivers.

Documentation/driver-model/lifetime-rules.txt?

> Something like this:
> 
> 	When a driver's remove() method returns, the driver must no
> 	longer try to use the device it was just unbound from.  The
> 	device may be physically gone, or a different driver may be
> 	bound to it.  Most importantly, remove() should unregister
> 	all child devices created by the driver.

s/should/must/, if we agree on the policy above.

The remove() method must also unset driver_data.

> 	To accomplish all this safely, the driver should allocate a
> 	private data structure containing at least a "gone" flag and 
> 	a mutex or spinlock for synchronization.  Each time the driver
> 	needs to use the device, it should first lock the mutex or 
> 	spinlock and check the "gone" flag.

How should a driver make the device -> private data transition if it
may no longer have private data attached to the device?

> 	Ideally remove() should release all of the driver's references
> 	to the device, in accord with the "Immediate Detach" principle.
> 	However it is acceptable for the driver to retain a reference,
> 	provided it meets the following conditions:
> 
> 		The reference must be dropped in a timely manner,
> 		such as when the release() methods for all child
> 		devices have run.
> 
> 		The driver must also retain a module reference to
> 		the owner of the device.  In practice this means the
> 		driver must contain static code references to the
> 		subsystem which created the device, since struct
> 		device doesn't have an "owner" field.

Uhm. This would imply that a driver may never create a device itself.
However, the kobject->owner and module refcounting stuff should remove
this restriction.

> 		The driver must restrict itself to reading (not
> 		writing!) the fields in the device structure.  The
> 		only exception is that the driver may lock/unlock
> 		dev->sem.

And it may decrease the reference count, of course :)

> How does that sound?

Yes, we should have some documentation like that.
