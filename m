Return-Path: <linux-kernel-owner+w=401wt.eu-S637764AbXDSNNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637764AbXDSNNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637765AbXDSNNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:13:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:10332 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637764AbXDSNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=htyJ1dh3QLVWrCZgSfujadG+OCgdAv5NfEXOrSCcK/m2vcykbUyRG04eRXkzGT2CSgpsjTm1YUSN0Q50qq02RmwewbNnKRMK2gcvUIoL1ISNikEXeCkhNRLMeTc/+/VxLCWxv+aFGdJy6hGmg75O408ZWRtPLNuwTcBhklbtt94=
Message-ID: <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>
Date: Thu, 19 Apr 2007 09:13:43 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Tejun Heo" <htejun@gmail.com>, "Alan Stern" <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
	 <46263A82.1030703@gmail.com>
	 <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
	 <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Wed, 18 Apr 2007 12:41:36 -0400,
> "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>
> > I am still do not understand why this is needed. Would it not be
> > simplier just to use a reference to struct device instead of embedding
> > it in a larger structure if their lifetimes are different and one does
> > not have a subsystem that takes care of releasing logic.
>
> Why are their lifetimes different? Usually, if I hold on to the device,
> I also want to be able to use the structure that embeds the device.
>

Because they are managed by 2 different entities. the struct device
objects are managed by device core and driver-specific objects are
managed by their respective driver.

> > Pretty much drivers have 2 options:
> >
> > struct my_device {
> >         void *private_data;
> >         struct device dev;
> > };
> >
> > In this case ->release must live in a subsystem code; individual
> > drivers kfree(my_dev->private) and do any additional cleanup after
> > calling device_unregister(&my_dev->dev);
>
> They must do this in the ->remove callback.

Why? If the driver truly stops hardware then any driver-specific data
is not needed. With sysfs severing access to removed attributes there
is no need to gave "global release", cleanup can be done in stages.

>
> >
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
> device_create() would need to not expect a class then, or it's not
> universally usable. Also, the driver would need a method to get back
> from the device to my_device. We're practically back at the first
> option again, only that now the ->release function is sitting in the
> driver core instead of the subsystem.
>

To a degree.

-- 
Dmitry
