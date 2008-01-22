Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYAVGag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYAVGag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYAVGa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:30:29 -0500
Received: from hs-out-0708.google.com ([64.233.178.242]:49911 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbYAVGa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aUIOoUhtBD7PC/STmjJs9SeUsSxuAOcjBC1zPfWfIFSxGLaPFH71NRhZzuWJDl+8sK7ijK93BWp9oDk79kePMrli4B5X6/nxFdODNsMh+0eKZDl2F/ujveHpJpbcb2Lp+57jEiAaHeYxHsTFyrWRbqOS2Kqm7AndcLZiNZhn138=
Message-ID: <a8e1da0801212230y4c0c9bf4v295018e094dbeabf@mail.gmail.com>
Date: Tue, 22 Jan 2008 14:30:27 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 1/6] driver-core : add class iteration api
Cc: "Greg KH" <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       James.Bottomley@hansenpartnership.com, a.zummo@towertech.it,
       peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, dwmw2@infradead.org, davem@davemloft.net,
       jarkao2@gmail.com
In-Reply-To: <200801212224.18149.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
	 <20080122055434.GB3066@darkstar.te-china.tietoenator.com>
	 <200801212224.18149.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 2:24 PM, David Brownell <david-b@pacbell.net> wrote:
> On Monday 21 January 2008, Dave Young wrote:
> >
> > +/**
> > + *   class_for_each_device - device iterator
> > + *   @class: the class we're iterating
> > + *   @data: data for the callback
> > + *   @fn: function to be called for each device
> > + *
> > + *   Iterate over @class's list of devices, and call @fn for each,
> > + *   passing it @data.
> > + *
> > + *   We check the return of @fn each time. If it returns anything
> > + *   other than 0, we break out and return that value.
>
> I have a suggestion for better documentation, which
> applies to all these utilities:
>
>
> > + */
> > +int class_for_each_device(struct class *class, void *data,
> > +                        int (*fn)(struct device *, void *))
> > +{
> > +     struct device *dev;
> > +     int error = 0;
> > +
> > +     if (!class)
> > +             return -EINVAL;
> > +     down(&class->sem);
> > +     list_for_each_entry(dev, &class->devices, node) {
> > +             dev = get_device(dev);
> > +             if (dev) {
> > +                     error = fn(dev, data);
>
> This is called with class->sem held.  So fn() has a
> constraint to not re-acquire that ... else it'd be
> self-deadlocking.  I'd like to see docs at least
> mention that; calls to add or remove class members
> would be verboten, for example, which isn't an issue
> with most other driver model iterators.

Very good comment, thanks david.  I will update after a while.

>
>
>
> > +                     put_device(dev);
> > +             } else
> > +                     error = -ENODEV;
> > +             if (error)
> > +                     break;
> > +     }
> > +     up(&class->sem);
> > +
> > +     return error;
> > +}
> > +EXPORT_SYMBOL_GPL(class_for_each_device);
>
