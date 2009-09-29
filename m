Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZI2UMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZI2UMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZI2UMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:12:06 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:54118 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZI2UME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rnGMDolreHLhhpVuVV+d6Lblpamc6nHU2lYBC5Hu8NDi1WdKIS34usJ+FizAZLIXmi
         v9cAyFVjvzpV+vrKyE5TyZouhx3U/Evmbl58YpPZLq+9vzHUWDtudpgvWFq3rYlyHE+e
         VZFC+SRZpGILoCBT90kU+p7XWePGkmXxj309Q=
MIME-Version: 1.0
In-Reply-To: <200909291041.31481.bjorn.helgaas@hp.com>
References: <c4e36d110909290218g3f98c595kaa15566b94527f04@mail.gmail.com>
	 <200909291041.31481.bjorn.helgaas@hp.com>
Date: Tue, 29 Sep 2009 22:12:07 +0200
Message-ID: <c4e36d110909291312p115f4d56jd998b65e7ed5b8ba@mail.gmail.com>
Subject: Re: ACPI boot memory leaks in 2.6.32-rc1/2
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/29 Bjorn Helgaas <bjorn.helgaas@hp.com>:
> On Tuesday 29 September 2009 03:18:53 am Zdenek Kabelac wrote:
>> My qemu guest seems to be reporting now 46 memleaks  ACPI related.
>
> Thanks a lot for the report!
>
> Can you verify that the patch below fixes these leaks?
>

Yes - leaks are fixed with this patch

>
> commit fff7774a805e392ce258f0342e48cbe682ef2b9b
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Tue Sep 29 10:32:19 2009 -0600
>
>    ACPI: fix bus scanning memory leaks
>
>    Free an acpi_get_object_info() buffer when we're finished.  Skip the
>    acpi_get_name() altogether -- it was only used for a printk that was
>    really just for debug anyway.
>
>    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>    Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>


Reported-and-tested-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>

>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 468921b..14a7481 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1052,6 +1052,8 @@ static void acpi_device_set_id(struct acpi_device *device)
>                        device->flags.bus_address = 1;
>                }
>
> +               kfree(info);
> +
>                /*
>                 * Some devices don't reliably have _HIDs & _CIDs, so add
>                 * synthetic HIDs to make sure drivers can find them.
> @@ -1325,13 +1327,8 @@ static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
>                         struct acpi_device **child)
>  {
>        acpi_status status;
> -       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>        void *device = NULL;
>
> -       acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> -       printk(KERN_INFO PREFIX "Enumerating devices from [%s]\n",
> -              (char *) buffer.pointer);
> -
>        status = acpi_bus_check_add(handle, 0, ops, &device);
>        if (ACPI_SUCCESS(status))
>                acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
>
