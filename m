Return-Path: <linux-kernel-owner+w=401wt.eu-S637779AbXDSOVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637779AbXDSOVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637781AbXDSOVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:21:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:38423 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637779AbXDSOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ay2SLHGrK8nKzTL+yTuWYJXNjxXh6TffClRGwm0bOrixEK41S/1oJIC59dDzONeS8zX/CpKZnzTT7WGaMLfGDqlMNuELtHt4bGBO3IUkJS1qszJfiZ82mozrUXXyFUIzDJ0+4UKSjEZfr0TI5+tdD1PpaXHxDo/ghgJ+t7q12o8=
Message-ID: <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:21:41 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Cc: "Tejun Heo" <htejun@gmail.com>, "Alan Stern" <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Greg K-H" <greg@kroah.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
	 <46263A82.1030703@gmail.com>
	 <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>
	 <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>
	 <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>
	 <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Thu, 19 Apr 2007 09:13:43 -0400,
> "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>
> > Because they are managed by 2 different entities. the struct device
> > objects are managed by device core and driver-specific objects are
> > managed by their respective driver.
>
> Not sure if I understand you here. My view of this was always that the
> embedding object was kind of an extended device and that the relevant
> driver/subsystem managed it through the driver core infrastructure.
>

I am not sure if I agree with this point of view. Driver (or
subsystem) provides an instance of struct device for the rest of the
system to iteract uniformly with (suspend/resume/tree
visualization/etc) i.e. struct device implement an interface for
subsystems. However most of the system use their own mechanisms to
manage their devices. They can rely on the driver core to a certain
degree but driver core is mostly a carries out helper functions, not
the meat.

> >
> > > > Pretty much drivers have 2 options:
> > > >
> > > > struct my_device {
> > > >         void *private_data;
> > > >         struct device dev;
> > > > };
> > > >
> > > > In this case ->release must live in a subsystem code; individual
> > > > drivers kfree(my_dev->private) and do any additional cleanup after
> > > > calling device_unregister(&my_dev->dev);
> > >
> > > They must do this in the ->remove callback.
> >
> > Why? If the driver truly stops hardware then any driver-specific data
> > is not needed. With sysfs severing access to removed attributes there
> > is no need to gave "global release", cleanup can be done in stages.
>
> I think I meant the same thing :) Freeing the data in the ->release
> callback is obviously too late. Freeing it in the ->remove callback
> means that the device is no longer really used (and can't be looked up
> any more); only some further refrences may linger (and those are of no
> consequence with the sysfs disconnect).
>

Ah, right, I confused ->remove() with ->release() in your post. Sorry
about that.

-- 
Dmitry
