Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYAPBDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYAPBDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYAPBDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:03:08 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:63617 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYAPBDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ADaQvAlIu2K4emabJ7Ju7RF5rpFmY9f080wx2UtwGWBb5pgDOhda79IeGLs8rlkD8wZD4zGWf1xqn3p7gzXeYAyD0gNfohksUXSKHhLWtt04SyyVSyTckM6ERN4L04tyxQYm9WwHcJgcXZzVjUK40f+5cOWyPmOuY/VOSIDunS8=
Message-ID: <a8e1da0801151703w52df227en42eae85e75d5017f@mail.gmail.com>
Date: Wed, 16 Jan 2008 09:03:03 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de, david-b@pacbell.net,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20080115135604.GD1696@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112100515.GA2956@darkstar.te-china.tietoenator.com>
	 <20080115091527.GB3186@darkstar.te-china.tietoenator.com>
	 <20080115135604.GD1696@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 9:56 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
>
> On Tue, Jan 15, 2008 at 05:15:27PM +0800, Dave Young wrote:
> > Convert the class semaphore to mutex.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > ---
> >  drivers/base/class.c   |   38 +++++++++++++++++++-------------------
> >  drivers/base/core.c    |   18 ++++++++----------
> >  include/linux/device.h |    3 ++-
> >  3 files changed, 29 insertions(+), 30 deletions(-)
> >
> > diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
> > --- linux/drivers/base/class.c        2008-01-15 14:04:26.000000000 +0800
> > +++ linux.new/drivers/base/class.c    2008-01-15 14:04:26.000000000 +0800
> > @@ -144,7 +144,7 @@ int class_register(struct class * cls)
> >       INIT_LIST_HEAD(&cls->devices);
> >       INIT_LIST_HEAD(&cls->interfaces);
> >       kset_init(&cls->class_dirs);
> > -     init_MUTEX(&cls->sem);
> > +     mutex_init(&cls->mutex);
> >       error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
> >       if (error)
> >               return error;
> > @@ -617,13 +617,13 @@ int class_device_add(struct class_device
> >       kobject_uevent(&class_dev->kobj, KOBJ_ADD);
> >
> >       /* notify any interfaces this device is now here */
> > -     down(&parent_class->sem);
> > +     mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);
> >       list_add_tail(&class_dev->node, &parent_class->children);
> >       list_for_each_entry(class_intf, &parent_class->interfaces, node) {
> >               if (class_intf->add)
> >                       class_intf->add(class_dev, class_intf);
> >       }
> > -     up(&parent_class->sem);
> > +     mutex_unlock(&parent_class->mutex);
> >
> >       goto out1;
> >
> > @@ -725,12 +725,12 @@ void class_device_del(struct class_devic
> >       struct class_interface *class_intf;
> >
> >       if (parent_class) {
> > -             down(&parent_class->sem);
> > +             mutex_lock(&parent_class->mutex);
>
> I hope I'm wrong with this (I don't know this code at all...), and
> of course I should've noticed this earlier after all, but I wonder
> about this _NESTING corretness here. So, if these variables names
> are right, and say about real nesting dependency, then it seems
> mutex_lock_nested() should be used consistently even if (currently?)
> not forced by lockdep warnings; otherwise this could possibly cover
> some other warnings. Alas, if accidentally I'm right, it seems a
> bit of new testing would be necessary...

The lockdep warining was posted in the below thread, actually, I have
built and run this patced kernel for several days, there's no more
warnings.
http://lkml.org/lkml/2008/1/3/2

>
> Regards,
> Jarek P.
>
