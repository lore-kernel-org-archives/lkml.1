Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYAaBRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYAaBRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYAaBRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:17:22 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:15586 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYAaBRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:17:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jvP3vFZ9wwitIZ4T9FMU7DHxyFv0jzRjeG8TwSsXTNoq7DwUxArHreAvqfGXIhzK0jkWvHQKz1wkYM7kSBLBVEppG2Zv4jjFvN7ssrz1aQYkxnccR2iDJwZqU6sxzRIpDdeuftanTgLisVRlK1j6tJul/nKAKX8rQlICELjlysE=
Message-ID: <a8e1da0801301717v1ca21bd7y6ecf16065fe34f7d@mail.gmail.com>
Date: Thu, 31 Jan 2008 09:17:18 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] driver-core : get_device before create/remove sysfs files
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080130113257.53555fee@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080130015625.GA3058@darkstar.te-china.tietoenator.com>
	 <20080130113257.53555fee@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 6:32 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Wed, 30 Jan 2008 09:56:25 +0800,
> Dave Young <hidave.darkstar@gmail.com> wrote:
>
> > get dev reference before create/remove sysfiles, errno fixes as well.
> >
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > ---
> > drivers/base/core.c |   12 ++++++++----
> > 1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff -upr a/drivers/base/core.c b/drivers/base/core.c
> > --- a/drivers/base/core.c     2008-01-30 09:49:56.000000000 +0800
> > +++ b/drivers/base/core.c     2008-01-30 09:49:56.000000000 +0800
> > @@ -414,7 +414,7 @@ struct kset *devices_kset;
> >   */
> >  int device_create_file(struct device *dev, struct device_attribute *attr)
> >  {
> > -     int error = 0;
> > +     int error = -ENODEV;
>
> Uhm... why?

In this function :
        if (get_device(dev)) {
                do create issue
        }
        return error

So IMO the initial error should be -ENODEV

>
> >       if (get_device(dev)) {
> >               error = sysfs_create_file(&dev->kobj, &attr->attr);
> >               put_device(dev);
> > @@ -442,9 +442,11 @@ void device_remove_file(struct device *d
> >   */
> >  int device_create_bin_file(struct device *dev, struct bin_attribute *attr)
> >  {
> > -     int error = -EINVAL;
> > -     if (dev)
> > +     int error = -ENODEV;
> > +     if (get_device(dev)) {
> >               error = sysfs_create_bin_file(&dev->kobj, attr);
> > +             put_device(dev);
> > +     }
>
> Why do we need to grab a reference here? If the calling site doesn't
> hold unto a reference already, something is seriously broken.

First, we should keep consistent with previous function "device_create_file";
Second, AFAIK this function mostly are called after something like device_add
and the dev reference are not hold.


>
> >       return error;
> >  }
> >  EXPORT_SYMBOL_GPL(device_create_bin_file);
> > @@ -456,8 +458,10 @@ EXPORT_SYMBOL_GPL(device_create_bin_file
> >   */
> >  void device_remove_bin_file(struct device *dev, struct bin_attribute *attr)
> >  {
> > -     if (dev)
> > +     if (get_device(dev)) {
> >               sysfs_remove_bin_file(&dev->kobj, attr);
> > +             put_device(dev);
> > +     }
>
> Dito.
>
>
> >  }
> >  EXPORT_SYMBOL_GPL(device_remove_bin_file);
>
