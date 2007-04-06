Return-Path: <linux-kernel-owner+w=401wt.eu-S1767474AbXDFBSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767474AbXDFBSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767473AbXDFBSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:18:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767471AbXDFBR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:17:58 -0400
Date: Thu, 5 Apr 2007 18:16:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yinghai.lu@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, "Len Brown" <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86_64/acpi: make kernel to be compiled when
 CONFIG_ACPI_NUMA is set and power management with acpi is not enabled
Message-Id: <20070405181643.aa8f8df7.akpm@linux-foundation.org>
In-Reply-To: <86802c440704032102h6e624cabrcfe6356b47d272a8@mail.gmail.com>
References: <86802c440704032055q43691a64v9eefb2a625c095ed@mail.gmail.com>
	<86802c440704032102h6e624cabrcfe6356b47d272a8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 21:02:03 -0700
"Yinghai Lu" <yinghai.lu@amd.com> wrote:

> [PATCH] x86_64/acpi: make kernel to be compiled when  CONFIG_ACPI_NUMA is set and power management with acpi is not enabled
> 
> when CONFIG_ACPI_NUMA is set, and power management with acpi is not used. the kernel can not be compiled.
> so use CONFIG_ACPI_POWER and CONFIG_ACPI_SYTEM to comment function about set/get power and event.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@amd.com> 
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index dd49ea0..4d06885 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -121,6 +121,7 @@ int acpi_bus_get_status(struct acpi_device *device)
>  
>  EXPORT_SYMBOL(acpi_bus_get_status);
>  
> +#ifdef CONFIG_ACPI_POWER
>  /* --------------------------------------------------------------------------
>                                   Power Management
>     -------------------------------------------------------------------------- */
> @@ -269,7 +270,9 @@ int acpi_bus_set_power(acpi_handle handle, int state)
>  }
>  
>  EXPORT_SYMBOL(acpi_bus_set_power);
> +#endif
>  
> +#ifdef CONFIG_ACPI_SYSTEM
>  /* --------------------------------------------------------------------------
>                                  Event Management
>     -------------------------------------------------------------------------- */
> @@ -358,6 +361,7 @@ int acpi_bus_receive_event(struct acpi_bus_event *event)
>  }
>  
>  EXPORT_SYMBOL(acpi_bus_receive_event);
> +#endif
>  
>  /* --------------------------------------------------------------------------
>                               Notification Handling
> diff --git a/drivers/net/e1000/e1000_param.c b/drivers/net/e1000/e1000_param.c
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index a064f36..c2a1ac9 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -255,7 +255,7 @@ static int acpi_pci_choose_state(struct pci_dev *pdev, pm_message_t state)
>  
>  	return -ENODEV;
>  }
> -
> +#ifdef CONFIG_ACPI_POWER
>  static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  {
>  	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
> @@ -272,7 +272,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  		return -ENODEV;
>  	return acpi_bus_set_power(handle, acpi_state);
>  }
> -
> +#endif
>  
>  /* ACPI bus type */
>  static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
> @@ -321,7 +321,9 @@ static int __init acpi_pci_init(void)
>  	if (ret)
>  		return 0;
>  	platform_pci_choose_state = acpi_pci_choose_state;
> +#ifdef CONFIG_ACPI_POWER
>  	platform_pci_set_power_state = acpi_pci_set_power_state;
> +#endif
>  	return 0;
>  }
>  arch_initcall(acpi_pci_init);

This is a rather unpleasing patch from a maintainability point of view -
all those ifdefs do cause various problems.

I wonder if the situation could be improved by something like:

- Move acpi_bus_set_power() and acpi_bus_get_power() into power.c, which
  is only compiled if CONFIG_ACPI_POWER.

- Move acpi_bus_generate_event() and acpi_bus_receive_event() and their
  associated global variables into event.c, whcih is only compiled if
  CONFIG_ACPI_SYSTEM.

- Move acpi_pci_set_power_state() into power.c

- Move the initalisation of platform_pci_set_power_state into
  acpi_power_init() (this will have runtime effects - changed startup
  ordering)

Of course, making these changes might require some adjustments elsewhere -
some symbols might need to be made global, others maybe can become newly
static, etc.

The primary aim should be to keep the code _logical_.  If we think that the
above code motion reduces ifdefs, but makes the overall code layout less
logical, then we shouldn't do it.  But if the code remains at least equally
logical afterwards, and we can reduce the ifdeffing then we should do it.

