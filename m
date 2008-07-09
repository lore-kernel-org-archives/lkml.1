Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYGILQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYGILQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYGILPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:15:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:18032 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbYGILPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a8duD4wFtuiENRw3k/6U7zgH5Z4RlC++CCoFpF0KofDKSLf6pDrf+LsVlXM3d59gwj
         0UbtQw3WJb5JCXD0ulbZSFNCA1DweEsx/NHTILDmyA+TYPlEwd8/4wvk+v0zxZyWhC6C
         Ej4OPkdODNv2gTgycmuxw1w+W8FOe62F9LNXw=
Message-ID: <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
Date: Wed, 9 Jul 2008 15:15:47 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       sameo@openedhand.com
In-Reply-To: <20080709104933.101610936@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/9 Ben Dooks <ben-linux@fluff.org>:
> This patch changes the mfd core behaviour to wrapper the platform_device
> it creates in an struct mfd_device which contains the information
> about the cell that was created.
>
> 1) The creation of the resource list and then passing it to the
>   platform_device_add_resources() causes the allocation of a
>   large array on the stack as well as copying the source data
>   twice (it is copied from the mfd_cell to the temporary array
>   and then copied into the newly allocated array)
>
> 2) We can wrapper the platform_device into an mfd_device and use
>   that to do the platform_device and resource allocation in one
>   go to reduce the failiure.
>
> Note, is there actually any reason to pass the sub devices any
> information about the cell they are created from? The mfd core
> already makes the appropriate resource adjustments and anything
> else like clocks should be exported by the clock drivers?
>
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>


NAK.
0) It was discussed yesterday on the list and the decision was to go
in a different way.
  I've provided a bit cleaner patch with the same idea, but then we
decided to go in a bit different way.
1) I prefer patch by Mike Rapoport which is more clear and goes in a
more correct way.
2) Please examine the tmio-nand driver (was here on the list and on
linux-mtd). It uses the mfd_cell
   to call hooks from the "host" driver (tc6393xb, more to be added soon).

>
> Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h 2008-07-09 10:46:23.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h      2008-07-09 11:14:55.000000000 +0100
> @@ -18,8 +18,6 @@
>
>  /*
>  * This struct describes the MFD part ("cell").
> - * After registration the copy of this structure will become the platform data
> - * of the resulting platform_device
>  */
>  struct mfd_cell {
>        const char              *name;
> @@ -33,9 +31,21 @@ struct mfd_cell {
>        const struct resource   *resources;
>  };
>
> +struct mfd_device {
> +       struct platform_device  pdev;
> +       struct mfd_cell         *cell;
> +       struct resource         resources[0];
> +};
> +
> +static inline struct mfd_device *to_mfd_device(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       return container_of(pdev, struct mfd_device, pdev);
> +}
> +
>  static inline struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
>  {
> -       return (struct mfd_cell *)pdev->dev.platform_data;
> +       return container_of(pdev, struct mfd_device, pdev)->cell;
>  }
>
>  extern int mfd_add_devices(struct platform_device *parent,
> Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
> ===================================================================
> --- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c   2008-07-09 10:59:54.000000000 +0100
> +++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c        2008-07-09 11:09:59.000000000 +0100
> @@ -15,28 +15,41 @@
>  #include <linux/platform_device.h>
>  #include <linux/mfd/core.h>
>
> +static void mfd_dev_release(struct device *dev)
> +{
> +       struct mfd_device *mdev = to_mfd_device(dev);
> +
> +       kfree(mdev);
> +}
> +
>  static int mfd_add_device(struct platform_device *parent,
>                          const struct mfd_cell *cell,
>                          struct resource *mem_base,
>                          int irq_base)
>  {
> -       struct resource res[cell->num_resources];
> +       struct resource *res;
> +       struct mfd_device *mdev;
>        struct platform_device *pdev;
>        int ret = -ENOMEM;
>        int r;
>
> -       pdev = platform_device_alloc(cell->name, parent->id);
> -       if (!pdev)
> +       mdev = kzalloc(sizeof(struct mfd_device) +
> +                      sizeof(struct resource) * cell->num_resources,
> +                      GFP_KERNEL);
> +       if (!mdev)
>                goto fail_alloc;
>
> -       pdev->dev.parent = &parent->dev;
> +       mdev->cell = cell;
> +       mdev->pdev.dev.parent = &parent->dev;
>
> -       ret = platform_device_add_data(pdev,
> -                       cell, sizeof(struct mfd_cell));
> -       if (ret)
> -               goto fail_device;
> +       pdev = &mdev->pdev;
> +       res = &mdev->resources;
> +
> +       device_initialise(&pdev->dev);
> +       pdev->id = parent->id;
> +       pdev->name = cell->name;
> +       pdev->release = mfd_device_release;
>
> -       memzero(res, sizeof(res));
>        for (r = 0; r < cell->num_resources; r++) {
>                res[r].name = cell->resources[r].name;
>                res[r].flags = cell->resources[r].flags;
>
> --
>



-- 
With best wishes
Dmitry
