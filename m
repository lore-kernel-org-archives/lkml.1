Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYEOWF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYEOWF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYEOWFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:05:16 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:14843 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYEOWFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:05:15 -0400
Date: Thu, 15 May 2008 15:05:10 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Arthur Jones <Arthur.Jones@riverbed.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "mszeredi@suse.cz" <mszeredi@suse.cz>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
       "trond.myklebust@fys.uio.no" <trond.myklebust@fys.uio.no>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] mm: bdi: export BDI attributes in sysfs
Message-ID: <20080515220510.GY23649@ajones-laptop.nbttech.com>
References: <20080513190435.GG23649@ajones-laptop.nbttech.com> <20080514144030.GD6458@ajones-laptop.nbttech.com> <E1JwiZa-0007UA-Tm@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151213430.3019@woody.linux-foundation.org> <E1Jwj7G-0007Zs-GB@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0805151247010.3019@woody.linux-foundation.org> <20080515210254.GA23684@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080515210254.GA23684@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, ...

On Thu, May 15, 2008 at 02:02:54PM -0700, Greg KH wrote:
> On Thu, May 15, 2008 at 12:54:57PM -0700, Linus Torvalds wrote:
> >
> >
> > On Thu, 15 May 2008, Miklos Szeredi wrote:
> > >
> > > Actually nothing should need protection.  The only problem AFAICS is
> > > that the device_create()/dev_set_drvdata() interface is racy: somebody
> > > can come in after the device has been created but before drvdata has
> > > been set, and then we are in trouble.
> >
> > Well, I'm not sure that the locking should be at that level. Maybe the
> > locking *should* be in the driver that does this. It may need to do other
> > setup too, after all.
> >
> > Of course, doing a device_create_drvdata() thing might be the right
> > solution, at least part of the time. Greg?
> 
> Here's a patch that is build tested only.
> 
> Can someone who can reproduce this let me know if it solves the problem?

Yes, this patch survives many power cycles
without hitting the BUG...

Thanks for looking into this...

Arthur
> --------------------
> 
> Subject: Driver core: add device_create_vargs and device_create_drvdata
> 
> We want to have the drvdata field set properly when creating the device
> as sysfs callbacks can assume it is present and it can race the later
> setting of this field.
> 
> So, create two new functions, deviec_create_vargs() and
> device_create_drvdata() that take this new field.
> 
> Also move the mm/backing-dev.c code to use it as it is showing this
> problem today.
> 
> device_create_drvdata() will go away in 2.6.27 as the drvdata field will
> just be moved to the device_create() call as it should be.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/base/core.c    |   85 +++++++++++++++++++++++++++++++++++++++++++++----
>  include/linux/device.h |   12 ++++++
>  mm/backing-dev.c       |   12 +-----
>  3 files changed, 93 insertions(+), 16 deletions(-)
> 
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1163,11 +1163,13 @@ static void device_create_release(struct
>  }
> 
>  /**
> - * device_create - creates a device and registers it with sysfs
> + * device_create_vargs - creates a device and registers it with sysfs
>   * @class: pointer to the struct class that this device should be registered to
>   * @parent: pointer to the parent struct device of this new device, if any
>   * @devt: the dev_t for the char device to be added
> + * @drvdata: the data to be added to the device for callbacks
>   * @fmt: string for the device's name
> + * @args: va_list for the device's name
>   *
>   * This function can be used by char device classes.  A struct device
>   * will be created in sysfs, registered to the specified class.
> @@ -1183,10 +1185,10 @@ static void device_create_release(struct
>   * Note: the struct class passed to this function must have previously
>   * been created with a call to class_create().
>   */
> -struct device *device_create(struct class *class, struct device *parent,
> -                            dev_t devt, const char *fmt, ...)
> +struct device *device_create_vargs(struct class *class, struct device *parent,
> +                                  dev_t devt, void *drvdata, const char *fmt,
> +                                  va_list args)
>  {
> -       va_list args;
>         struct device *dev = NULL;
>         int retval = -ENODEV;
> 
> @@ -1203,10 +1205,9 @@ struct device *device_create(struct clas
>         dev->class = class;
>         dev->parent = parent;
>         dev->release = device_create_release;
> +       dev_set_drvdata(dev, drvdata);
> 
> -       va_start(args, fmt);
>         vsnprintf(dev->bus_id, BUS_ID_SIZE, fmt, args);
> -       va_end(args);
>         retval = device_register(dev);
>         if (retval)
>                 goto error;
> @@ -1217,6 +1218,78 @@ error:
>         kfree(dev);
>         return ERR_PTR(retval);
>  }
> +EXPORT_SYMBOL_GPL(device_create_vargs);
> +
> +/**
> + * device_create_drvdata - creates a device and registers it with sysfs
> + * @class: pointer to the struct class that this device should be registered to
> + * @parent: pointer to the parent struct device of this new device, if any
> + * @devt: the dev_t for the char device to be added
> + * @drvdata: the data to be added to the device for callbacks
> + * @fmt: string for the device's name
> + *
> + * This function can be used by char device classes.  A struct device
> + * will be created in sysfs, registered to the specified class.
> + *
> + * A "dev" file will be created, showing the dev_t for the device, if
> + * the dev_t is not 0,0.
> + * If a pointer to a parent struct device is passed in, the newly created
> + * struct device will be a child of that device in sysfs.
> + * The pointer to the struct device will be returned from the call.
> + * Any further sysfs files that might be required can be created using this
> + * pointer.
> + *
> + * Note: the struct class passed to this function must have previously
> + * been created with a call to class_create().
> + */
> +struct device *device_create_drvdata(struct class *class,
> +                                    struct device *parent,
> +                                    dev_t devt,
> +                                    void *drvdata,
> +                                    const char *fmt, ...)
> +{
> +       va_list vargs;
> +       struct device *dev;
> +
> +       va_start(vargs, fmt);
> +       dev = device_create_vargs(class, parent, devt, drvdata, fmt, vargs);
> +       va_end(vargs);
> +       return dev;
> +}
> +EXPORT_SYMBOL_GPL(device_create_drvdata);
> +
> +/**
> + * device_create - creates a device and registers it with sysfs
> + * @class: pointer to the struct class that this device should be registered to
> + * @parent: pointer to the parent struct device of this new device, if any
> + * @devt: the dev_t for the char device to be added
> + * @fmt: string for the device's name
> + *
> + * This function can be used by char device classes.  A struct device
> + * will be created in sysfs, registered to the specified class.
> + *
> + * A "dev" file will be created, showing the dev_t for the device, if
> + * the dev_t is not 0,0.
> + * If a pointer to a parent struct device is passed in, the newly created
> + * struct device will be a child of that device in sysfs.
> + * The pointer to the struct device will be returned from the call.
> + * Any further sysfs files that might be required can be created using this
> + * pointer.
> + *
> + * Note: the struct class passed to this function must have previously
> + * been created with a call to class_create().
> + */
> +struct device *device_create(struct class *class, struct device *parent,
> +                            dev_t devt, const char *fmt, ...)
> +{
> +       va_list vargs;
> +       struct device *dev;
> +
> +       va_start(vargs, fmt);
> +       dev = device_create_vargs(class, parent, devt, NULL, fmt, vargs);
> +       va_end(vargs);
> +       return dev;
> +}
>  EXPORT_SYMBOL_GPL(device_create);
> 
>  static int __match_devt(struct device *dev, void *data)
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -456,9 +456,21 @@ extern int __must_check device_reprobe(s
>  /*
>   * Easy functions for dynamically creating devices on the fly
>   */
> +extern struct device *device_create_vargs(struct class *cls,
> +                                         struct device *parent,
> +                                         dev_t devt,
> +                                         void *drvdata,
> +                                         const char *fmt,
> +                                         va_list vargs);
>  extern struct device *device_create(struct class *cls, struct device *parent,
>                                     dev_t devt, const char *fmt, ...)
>                                     __attribute__((format(printf, 4, 5)));
> +extern struct device *device_create_drvdata(struct class *cls,
> +                                           struct device *parent,
> +                                           dev_t devt,
> +                                           void *drvdata,
> +                                           const char *fmt, ...)
> +                                   __attribute__((format(printf, 5, 6)));
>  extern void device_destroy(struct class *cls, dev_t devt);
> 
>  /*
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -172,30 +172,22 @@ postcore_initcall(bdi_class_init);
>  int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>                 const char *fmt, ...)
>  {
> -       char *name;
>         va_list args;
>         int ret = 0;
>         struct device *dev;
> 
>         va_start(args, fmt);
> -       name = kvasprintf(GFP_KERNEL, fmt, args);
> +       dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
>         va_end(args);
> -
> -       if (!name)
> -               return -ENOMEM;
> -
> -       dev = device_create(bdi_class, parent, MKDEV(0, 0), name);
>         if (IS_ERR(dev)) {
>                 ret = PTR_ERR(dev);
>                 goto exit;
>         }
> 
>         bdi->dev = dev;
> -       dev_set_drvdata(bdi->dev, bdi);
> -       bdi_debug_register(bdi, name);
> +       bdi_debug_register(bdi, dev_name(dev));
> 
>  exit:
> -       kfree(name);
>         return ret;
>  }
>  EXPORT_SYMBOL(bdi_register);
