Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYIXE73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYIXE73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYIXE7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:59:22 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56797 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYIXE7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FkkmjZ3YjLYFnW/YWIe3h5Oklze8InOuWym9dZSXlajhEwncujmVGBVonAAkEeuq+f
         DpdHkeKG46E9klbrzIMU8AmcfQIp+MHTg1Cr+t2sJO6P46M6J5oYMZ2PXMaSTCxIsQDn
         /AsFZ6WNNV8CulT1ytSephba1fFyyzxVrsISo=
Message-ID: <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>
Date: Tue, 23 Sep 2008 21:59:19 -0700
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Drew Moseley" <dmoseley@mvista.com>
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of struct device
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org
In-Reply-To: <48D95EA2.9040804@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D95EA2.9040804@mvista.com>
X-Google-Sender-Auth: 4a7e8e06d9a8fab9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 14:24, Drew Moseley <dmoseley@mvista.com> wrote:
> I have seen an issue where the sysfs entries for a PNP device are
> created nonatomically resulting in a race condition with freedesktop
> HAL.  The patch below is my first attempt at addressing this by creating
> the device attributes as default bus attributes and allowing the
> device_register() call to create them.  Any nasty side effects I am not
> addressing?  Comments?

> diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
> index 9fd7bb9..b07787f 100644
> --- a/drivers/pnp/base.h
> +++ b/drivers/pnp/base.h
> @@ -16,7 +16,7 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *,
> int id, char *pnpid);
>
>  int pnp_add_device(struct pnp_dev *dev);
>  struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
> -int pnp_interface_attach_device(struct pnp_dev *dev);
> +void pnp_interface_attach_device(struct pnp_dev *dev);
>
>  int pnp_add_card(struct pnp_card *card);
>  void pnp_remove_card(struct pnp_card *card);
> diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
> index a411582..bcd49ba 100644
> --- a/drivers/pnp/core.c
> +++ b/drivers/pnp/core.c
> @@ -159,8 +159,6 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol
> *protocol, int id, char *pnpid
>
>  int __pnp_add_device(struct pnp_dev *dev)
>  {
> -       int ret;
> -
>        pnp_fixup_device(dev);
>        dev->status = PNP_READY;
>        spin_lock(&pnp_lock);
> @@ -168,12 +166,8 @@ int __pnp_add_device(struct pnp_dev *dev)
>        list_add_tail(&dev->protocol_list, &dev->protocol->devices);
>        spin_unlock(&pnp_lock);
>
> -       ret = device_register(&dev->dev);
> -       if (ret)
> -               return ret;
> -
>        pnp_interface_attach_device(dev);
> -       return 0;
> +       return device_register(&dev->dev);
>  }
>
>  /*
> diff --git a/drivers/pnp/interface.c b/drivers/pnp/interface.c
> index a876ecf..442684d 100644
> --- a/drivers/pnp/interface.c
> +++ b/drivers/pnp/interface.c
> @@ -243,8 +243,6 @@ static ssize_t pnp_show_options(struct device *dmdev,
>        return ret;
>  }
>
> -static DEVICE_ATTR(options, S_IRUGO, pnp_show_options, NULL);
> -
>  static ssize_t pnp_show_current_resources(struct device *dmdev,
>                                          struct device_attribute *attr,
>                                          char *buf)
> @@ -420,9 +418,6 @@ done:
>        return count;
>  }
>
> -static DEVICE_ATTR(resources, S_IRUGO | S_IWUSR,
> -                  pnp_show_current_resources, pnp_set_current_resources);
> -
>  static ssize_t pnp_show_current_ids(struct device *dmdev,
>                                    struct device_attribute *attr, char *buf)
>  {
> @@ -437,27 +432,16 @@ static ssize_t pnp_show_current_ids(struct device
> *dmdev,
>        return (str - buf);
>  }
>
> -static DEVICE_ATTR(id, S_IRUGO, pnp_show_current_ids, NULL);
> +static struct device_attribute pnp_interface_attrs[] = {
> +       __ATTR(resources, S_IRUGO | S_IWUSR,
> +                  pnp_show_current_resources,
> +                  pnp_set_current_resources),
> +       __ATTR(options, S_IRUGO, pnp_show_options, NULL),
> +       __ATTR(id, S_IRUGO, pnp_show_current_ids, NULL),
> +       __ATTR_NULL,
> +};
>
> -int pnp_interface_attach_device(struct pnp_dev *dev)
> +void pnp_interface_attach_device(struct pnp_dev *dev)
>  {
> -       int rc = device_create_file(&dev->dev, &dev_attr_options);
> -
> -       if (rc)
> -               goto err;
> -       rc = device_create_file(&dev->dev, &dev_attr_resources);
> -       if (rc)
> -               goto err_opt;
> -       rc = device_create_file(&dev->dev, &dev_attr_id);
> -       if (rc)
> -               goto err_res;
> -
> -       return 0;
> -
> -err_res:
> -       device_remove_file(&dev->dev, &dev_attr_resources);
> -err_opt:
> -       device_remove_file(&dev->dev, &dev_attr_options);
> -err:
> -       return rc;
> +       dev->dev.bus->dev_attrs = pnp_interface_attrs;

Any reason not to assign it statically to pnp_bus_type at in
drivers/pnp/driver.c?

>  }

Thanks,
Kay
