Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYAUDQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYAUDQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 22:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYAUDPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 22:15:51 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:11070 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYAUDPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 22:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lUN4j427/q/e41Hqj+18JxLWAz0j9gILPCgVW88HN/M88eVLL8tnljRsDKLTHDinm7rQIdD30Yq4GjN6ULGLaKx0RNhr/wdKaUcCDLxQOIDDybALiXvsl8Dz0BX8KfXTq+U5N/f8fLun1k5KKfO2+u0W0Jk1mZTIzJYer1EVglE=
Message-ID: <a8e1da0801201915m5608ec7bnda31bd1db898f7e4@mail.gmail.com>
Date: Mon, 21 Jan 2008 11:15:47 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Cc: "Gabor Gombas" <gombasg@sztaki.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       "Greg KH" <greg@kroah.com>, "Marcel Holtmann" <marcel@holtmann.org>,
       davem@davemloft.net
In-Reply-To: <20080118122625.370e2fba@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu>
	 <20080116230646.GB6715@boogie.lpds.sztaki.hu>
	 <a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
	 <20080117081504.GA3123@darkstar.te-china.tietoenator.com>
	 <20080117124259.19a88129@gondolin.boeblingen.de.ibm.com>
	 <a8e1da0801171937r92a1c32l116315a76f334776@mail.gmail.com>
	 <20080118101933.258bfae9@gondolin.boeblingen.de.ibm.com>
	 <20080118112337.0b457c49@gondolin.boeblingen.de.ibm.com>
	 <a8e1da0801180234k4b48fd1axaba6d7d334219430@mail.gmail.com>
	 <20080118122625.370e2fba@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 7:26 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Fri, 18 Jan 2008 18:34:55 +0800,
> "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
>
> > On Jan 18, 2008 6:23 PM, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > > On Fri, 18 Jan 2008 10:19:33 +0100,
> > > Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > >
> > > > >
> > > > > 1314         if (IS_ERR(new_parent_kobj)) {
> > > > > 1315                 error = PTR_ERR(new_parent_kobj);
> > > > > 1316                 put_device(new_parent);
> > > > > 1317                 goto out;
> > > > > 1318         }
> > > > > 1319         pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
> > > > > 1320                  new_parent ? new_parent->bus_id : "<NULL>");
> > > > > 1321         error = kobject_move(&dev->kobj, new_parent_kobj);
> > > > > 1322         if (error) {
> > > > > 1323                 put_device(new_parent);
> > > > >
> > > > > imagine new_parent is NULL, then the new_parent_kobj should be put
> > > >
> > > > No, we would need a put_device_parent() (crappy name) which puts the
> > > > reference iff get_device_parent() grabbed it.
> > >
> > > And looking at Greg's patchset, it has cleanup_device_parent(), which
> > > does just that. But it is only called in device_del(), not when
> > > device_move() has errors.
> > >
> > > (get_device_parent() also always returns a pointer to a kobject or
> > > NULL, so we can get rid of those IS_ERR() checks in setup_parent() and
> > > device_move() as well.)
> > >
> >
> > Hmm, thanks.
> > I will be offline during weekend,  but I will still check the
> > device_move and other code if I have time.
>
> Just hacked together the following against Greg's tree:
>
> COMPLETELY UNTESTED DO NOT APPLY
>
> ---
>  drivers/base/core.c |   33 ++++++++++++++++-----------------
>  1 files changed, 16 insertions(+), 17 deletions(-)
>
> --- linux-2.6.orig/drivers/base/core.c
> +++ linux-2.6/drivers/base/core.c
> @@ -553,6 +553,8 @@ static struct kobject *get_device_parent
>  }
>
>  static inline void cleanup_device_parent(struct device *dev) {}
> +static inline void cleanup_glue_dir(struct device *dev,
> +                                   struct kobject *kobj) {}
>  #else
>  static struct kobject *virtual_device_parent(struct device *dev)
>  {
> @@ -617,27 +619,27 @@ static struct kobject *get_device_parent
>         return NULL;
>  }
>
> -static void cleanup_device_parent(struct device *dev)
> +static void cleanup_glue_dir(struct device *dev, struct kobject *kobj)
>  {
> -       struct kobject *glue_dir = dev->kobj.parent;
> -
>         /* see if we live in a "glue" directory */
> -       if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
> +       if (!dev->class || kobj->kset != &dev->class->class_dirs)
>                 return;
>
> -       kobject_put(glue_dir);
> +       kobject_put(kobj);
> +}
> +
> +static void cleanup_device_parent(struct device *dev)
> +{
> +       cleanup_glue_dir(dev, dev->kobj.parent);
>  }
>  #endif
>
> -static int setup_parent(struct device *dev, struct device *parent)
> +static void setup_parent(struct device *dev, struct device *parent)
>  {
>         struct kobject *kobj;
>         kobj = get_device_parent(dev, parent);
> -       if (IS_ERR(kobj))
> -               return PTR_ERR(kobj);
>         if (kobj)
>                 dev->kobj.parent = kobj;
> -       return 0;
>  }
>
>  static int device_add_class_symlinks(struct device *dev)
> @@ -782,9 +784,7 @@ int device_add(struct device *dev)
>         pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
>
>         parent = get_device(dev->parent);
> -       error = setup_parent(dev, parent);
> -       if (error)
> -               goto Error;
> +       setup_parent(dev, parent);
>
>         /* first, register with generic layer. */
>         error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
> @@ -862,6 +862,7 @@ int device_add(struct device *dev)
>         kobject_uevent(&dev->kobj, KOBJ_REMOVE);
>         kobject_del(&dev->kobj);
>   Error:
> +       cleanup_device_parent(dev);
>         if (parent)
>                 put_device(parent);
>         goto Done;
> @@ -1303,15 +1304,12 @@ int device_move(struct device *dev, stru
>
>         new_parent = get_device(new_parent);
>         new_parent_kobj = get_device_parent (dev, new_parent);
> -       if (IS_ERR(new_parent_kobj)) {
> -               error = PTR_ERR(new_parent_kobj);
> -               put_device(new_parent);
> -               goto out;
> -       }
> +
>         pr_debug("device: '%s': %s: moving to '%s'\n", dev->bus_id,
>                  __FUNCTION__, new_parent ? new_parent->bus_id : "<NULL>");
>         error = kobject_move(&dev->kobj, new_parent_kobj);
>         if (error) {
> +               cleanup_glue_dir(dev, new_parent_kobj);
>                 put_device(new_parent);
>                 goto out;
>         }
> @@ -1334,6 +1332,7 @@ int device_move(struct device *dev, stru
>                                 klist_add_tail(&dev->knode_parent,
>                                                &old_parent->klist_children);
>                 }
> +               cleanup_glue_dir(dev, new_parent_kobj);
>                 put_device(new_parent);
>                 goto out;
>         }
>

Looks good.
