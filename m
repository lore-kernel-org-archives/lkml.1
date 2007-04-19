Return-Path: <linux-kernel-owner+w=401wt.eu-S1766888AbXDSRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766888AbXDSRTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766889AbXDSRTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:19:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1766888AbXDSRTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:19:23 -0400
Date: Thu, 19 Apr 2007 13:19:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704191254070.3413-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Dmitry Torokhov wrote:

> I am still do not understand why this is needed. Would it not be
> simplier just to use a reference to struct device instead of embedding
> it in a larger structure if their lifetimes are different and one does
> not have a subsystem that takes care of releasing logic.
> 
> 
> Pretty much drivers have 2 options:
> 
> struct my_device {
>         void *private_data;
>         struct device dev;
> };

Actually people use dev_[gs]et_drvdata() instead of a separate
private_data pointer.  That way there's no need for the my_device
container.

> In this case ->release must live in a subsystem code; individual
> drivers kfree(my_dev->private) and do any additional cleanup after
> calling device_unregister(&my_dev->dev);

That doesn't sound right.  Generally the call to device_unregister() and
the release method live in the same module.  Maybe you meant to say
individual drivers kfree(my_dev->private_data) and do any additional
cleanup in their remove() routine.

This approach seems dangerous.  Suppose there's mutex embedded in 
my_dev->private_data, and suppose some other thread is blocked waiting on 
that mutex when remove() is called.  That other thread will then oops when 
my_dev->private_data is deallocated.

> Second option:
> 
> struct my_device {
>         type member1;
>         type member2;
> 
>        struct device *dev;
> };
> 
> dev is coming from _device_create(). Driver core takes care of
> releasing dev structure; driver does cleanup of my_device.

Lots of drivers create devices dynamically without using device_create().

More to the point, how does the driver clean up my_device?  It probably 
has a reference count somewhere in my_device, especially if my_device is 
shared with other threads or other drivers.  We then face exactly the same 
problem: What happens if the driver's module is unloaded before all the 
references to my_device are gone?

> With current sysfs orphaning attributes upon removal request there is
> no issue of accessing driver-private data through references obtained
> via ether embedded or referenced dev structure so everything is fine.

Not so.  There are other pathways besides sysfs which can cause a driver
to access its data structures.

Alan Stern

