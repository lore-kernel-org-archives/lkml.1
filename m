Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXDSSjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXDSSjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXDSSjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:39:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:58109 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbXDSSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cPbTdv7idctk0tiWfuZfSq6Jq59tAWMEsUuQ+IBDQVMGSVW7LpaZb2Fc7aG2WmMGoC2pVPDeaWeVN9sOCF9Fs0iDTjNT91coGQP6JfVaGz2FknJP7IcQxBJizGDymB7L9AZXOV2xXtN6x1X8ESI/Moq2l13Qdv0ZNHoNhwVAdos=
Message-ID: <d120d5000704191139m3caf4cfeqd95047d1c33faf64@mail.gmail.com>
Date: Thu, 19 Apr 2007 14:39:40 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Tejun Heo" <htejun@gmail.com>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <Pine.LNX.4.44L0.0704191254070.3413-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
	 <Pine.LNX.4.44L0.0704191254070.3413-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 18 Apr 2007, Dmitry Torokhov wrote:
>
> > I am still do not understand why this is needed. Would it not be
> > simplier just to use a reference to struct device instead of embedding
> > it in a larger structure if their lifetimes are different and one does
> > not have a subsystem that takes care of releasing logic.
> >
> >
> > Pretty much drivers have 2 options:
> >
> > struct my_device {
> >         void *private_data;
> >         struct device dev;
> > };
>
> Actually people use dev_[gs]et_drvdata() instead of a separate
> private_data pointer.  That way there's no need for the my_device
> container.
>

No, drvdata belongs to driver that is bound to a device. We are
talking about private data created and managed by driver that provides
device.

> > In this case ->release must live in a subsystem code; individual
> > drivers kfree(my_dev->private) and do any additional cleanup after
> > calling device_unregister(&my_dev->dev);
>
> That doesn't sound right.  Generally the call to device_unregister() and
> the release method live in the same module.  Maybe you meant to say
> individual drivers kfree(my_dev->private_data) and do any additional
> cleanup in their remove() routine.

Again, if we are talking about driver bound to a device then devices
->release() is irrelevant. If we are talking about driver that created
device then driver's ->remove() is irrelevant.

>
> This approach seems dangerous.  Suppose there's mutex embedded in
> my_dev->private_data, and suppose some other thread is blocked waiting on
> that mutex when remove() is called.  That other thread will then oops when
> my_dev->private_data is deallocated.

What other thread? I suppose it is module-local thread or
subsystem-local thread. Let's that particular subsystem take care of
it's own data and use its own ->release() when it is ready. What I
mean is there is no need to perform clean-up at once; every layer can
do its own cleanup.

>
> > Second option:
> >
> > struct my_device {
> >         type member1;
> >         type member2;
> >
> >        struct device *dev;
> > };
> >
> > dev is coming from _device_create(). Driver core takes care of
> > releasing dev structure; driver does cleanup of my_device.
>
> Lots of drivers create devices dynamically without using device_create().
>
> More to the point, how does the driver clean up my_device?  It probably
> has a reference count somewhere in my_device, especially if my_device is
> shared with other threads or other drivers.  We then face exactly the same
> problem: What happens if the driver's module is unloaded before all the
> references to my_device are gone?
>

This is up to subsystem to ensure that it does not access dead devices.

> > With current sysfs orphaning attributes upon removal request there is
> > no issue of accessing driver-private data through references obtained
> > via ether embedded or referenced dev structure so everything is fine.
>
> Not so.  There are other pathways besides sysfs which can cause a driver
> to access its data structures.
>

Which ones? These needs to be identified and treated with "immediate
disconnect" that you advocated earlier. Once active users of device's
services are gone you can zap it.

-- 
Dmitry
