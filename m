Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYDIXNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYDIXNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 19:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYDIXNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 19:13:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYDIXNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 19:13:35 -0400
Date: Wed, 9 Apr 2008 16:12:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NoWhereMan <uncommonnonsense@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH 2.6.25-rc7 001/001] ACPI: workaround for buggy BIOS to
 ignore error LINK CRS method
Message-Id: <20080409161251.0c0e73e9.akpm@linux-foundation.org>
In-Reply-To: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
References: <f7430a760804090842s44ece7bh216d5d28e347955@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008 17:42:34 +0200
NoWhereMan <uncommonnonsense@gmail.com> wrote:

> >From : Edoardo Vacchi <uncommonnonsense@gmail.com>
> 
> When acpi_pci_link_crs_ignore is passed at boot to the kernel,
> ignores the error about the _CRS method of LINK device and selects
> IRQ from possible IRQ list returned by _PRS method.
> 
> Signed-off-by: Edoardo Vacchi <uncommonnonsense@gmail.com>
> 

Let's add some cc's.

> 
> This is nothing more than the patch on comment #127 on bug #8896
> http://bugzilla.kernel.org/show_bug.cgi?id=8896#c127
> 
> originally by Zhao Yakui <yakui.zhao@intel.com>
> 
> ported to 2.6.25 and wrapped into an additional check for the kernel parameter
> (plus of course the defintion of the kernel param itself)
> 
> The patch provides a workaround for some buggy BIOSes such as Insyde
> in Packard Bell EasyNote r1938 (of which I'm an unfortunate owner),
> while still keeping boot safe for people not suffering from this bug
> 

That patch is about four months old.  Hopefully there was a reason why we
dodn't proceed with it?


> diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
> index 233c40c..ed54c63 100644
> --- a/drivers/acpi/pci_link.c
> +++ b/drivers/acpi/pci_link.c
> @@ -297,6 +297,16 @@ static int acpi_pci_link_get_current(struct
> acpi_pci_link *link)
>         return result;
>  }
> 
> +
> +/*
> + * this is set when acpi_pci_link_crs_ignore is passed on boot
> + * it will ignore the -ENODEV error on buggy BIOSes
> + *
> + * workaround for bug #8896
> + *
> + */
> +static int acpi_pci_link_crs_ignore; /* 0 or 1*/
> +
>  static int acpi_pci_link_set(struct acpi_pci_link *link, int irq)
>  {
>         int result = 0;
> @@ -385,9 +395,16 @@ static int acpi_pci_link_set(struct acpi_pci_link
> *link, int irq)
> 
>         /* Query _CRS, set link->irq.active */
>         result = acpi_pci_link_get_current(link);
> -       if (result) {
> -               goto end;
> -       }
> +       if (acpi_pci_link_crs_ignore && result == -ENODEV) {
> +               /*
> +                * Ignore the error about the _CRS method of Link device and
> +                * select IRQ from the Possible IRQ list
> +                * returned by _PRS method.
> +                */
> +                printk(KERN_WARNING "Ignore error LINK CRS method.\n");
> +                link->irq.active = irq;
> +                result = 0;
> +        }
> 
>         /*
>          * Is current setting not what we set?
> @@ -412,7 +429,16 @@ static int acpi_pci_link_set(struct acpi_pci_link
> *link, int irq)
>         return result;
>  }
> 
> -/* --------------------------------------------------------------------------
> +int __init acpi_pci_link_crs_ignore_set(char *str)
> +{
> +       acpi_pci_link_crs_ignore = 1;
> +       return 1;
> +}
> +
> +__setup("acpi_pci_link_crs_ignore", acpi_pci_link_crs_ignore_set);
> +
> +
> + /* --------------------------------------------------------------------------
>                              PCI Link IRQ Management
>     --------------------------------------------------------------------------
> */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
